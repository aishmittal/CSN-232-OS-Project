import screenlets
from screenlets.options import BoolOption, ColorOption, IntOption, ListOption
import cairo
import pango
import subprocess
import re
import gobject
import gtk
import os

DRIVE_HEIGHT = 50
PADDING      = 8

def load(quota):
	load = int(quota.replace('%',''))

	if load > 99: load = 99
	elif load < 0: load = 0

	return load

def nickname(mount):
	if mount == '/':
		return mount
	
	return mount[mount.rfind('/')+1:]

class DiskSpaceScreenlet(screenlets.Screenlet):
	"""A screenlet that displays free/used space information for selected hard drives."""
	
	# Default Meta-Info for Screenlets
	__name__    = 'DiskSpaceScreenlet'
	__desc__    = __doc__

	# Internals
	__timeout     = None
	p_layout      = None	
	drive_clicked = -1
	__info        = [{ 'mount': '/', 'nick': '/', 'free': 0, 'size': 0, 'quota': 0, 'load': 0 }]

	# Default Settings
	clicks_enabled     = False
	stack_horizontally = False
	update_interval    = 20
	mount_points       = ['/']
	threshold          = 80

	color_normal   = (0.0, 0.69, 0.94,  1.0)
	color_critical = (1.0, 0.2,  0.545, 1.0)
	color_text     = (0.0, 0.0,  0.0,   0.6)
	frame_color    = (1.0, 1.0,  1.0,   1.0)

	def __init__(self, **keyword_args):
		"""Constructor"""
		# call super
		screenlets.Screenlet.__init__(self, width=220, height=DRIVE_HEIGHT + 2 * PADDING, uses_theme=True, **keyword_args)

		# set theme
		self.theme_name = 'default'

		# add options
		self.add_options_group('DiskSpace', 'DiskSpace specific options')
		self.add_option(BoolOption('DiskSpace', 'clicks_enabled', self.clicks_enabled, 'Clicks Enabled',
			'If checked, clicking on a drive icon opens the drive in Nautilus'))
		self.add_option(BoolOption('DiskSpace', 'stack_horizontally',
			self.stack_horizontally, 'Stack Horizontally',
			'If checked, drives will stack horizontally'))
		self.add_option(IntOption('DiskSpace', 'update_interval', 
			self.update_interval, 'Update Interval', 
			'The interval for updating the Disk usage (in seconds) ...',
			min=1, max=60))
		self.add_option(ListOption('DiskSpace', 'mount_points',
			self.mount_points, 'Mount Points',
			'Python-style list of mount points for the devices you want to show'))
		self.add_option(IntOption('DiskSpace', 'threshold',
			self.threshold, 'Threshold',
			'The percentage threshold to display cricital color',
			min=0, max=100))
		self.add_option(ColorOption('DiskSpace', 'color_normal', self.color_normal, 'Normal Color',
			'The color to be displayed when drive usage is below the threshold'))
		self.add_option(ColorOption('DiskSpace', 'color_critical', self.color_critical, 'Critical Color',
			'The color to be displayed when drive usage is above the threshold'))
		self.add_option(ColorOption('DiskSpace', 'color_text', self.color_text, 'Text Color', ''))
		self.add_option(ColorOption('DiskSpace', 'frame_color', self.frame_color, 'Frame Color', ''))

		self.add_default_menuitems()
		self.update_interval = self.update_interval

	def on_after_set_atribute(self, name, value):
		if name == 'update_interval':
			self.on_set_update_interval()
		elif name == 'mount_points':
			self.on_set_mount_points()
		elif name == 'stack_horizontally':
			self.on_set_stack_horizontally()
		else:
			self.update_graph()

	def on_set_update_interval(self):
		if self.update_interval <= 0:
			self.update_interval = 1
		if self.__timeout:
			gobject.source_remove(self.__timeout)
		self.__timeout = gobject.timeout_add(int(self.update_interval * 1000), self.timeout)

	def on_set_mount_points(self):
		for i, mp in enumerate(self.mount_points):
			mp = mp.strip()
			if mp != '/':
				mp = mp.rstrip('/')
			self.mount_points[i] = mp

		self.timeout()

	def on_set_stack_horizontally(self):
		self.recalculate_size()
		self.update_graph()

	def recalculate_size(self):	
		if self.stack_horizontally:
			self.width  = 220 * len(self.__info)
			self.height = DRIVE_HEIGHT + 2 * PADDING
		else:
			self.width  = 220
			self.height = DRIVE_HEIGHT * len(self.__info) + 2 * PADDING

		if self.window:
			self.window.resize(self.width * self.scale, self.height * self.scale)

	def get_drive_info(self):
		result = []
		temp = {}
		proc = subprocess.Popen('df -hP', shell='true', stdout=subprocess.PIPE)
		sdevs = proc.stdout.read().rsplit('\n')
		sdevs = sdevs[1:-1]

		for stdev in sdevs:
			sdev = re.findall("(\S*)\s*", stdev)

			dev = {
				'device': sdev[0],
				'size'  : sdev[1],
				'used'  : sdev[2],
				'free'  : sdev[3],
				'quota' : sdev[4],
				'mount' : sdev[5],
				'nick'  : nickname(sdev[5]),
				'load'  : load(sdev[4])
			}

			if dev['mount'] in self.mount_points:
				temp[dev['mount']] = dev
			elif dev['device'] in self.mount_points:
				temp[dev['device']] = dev

		for mp in self.mount_points:
			try:
				result.append(temp[mp])
			except KeyError:
				pass

		return result
	
	def update_graph(self):
		self.redraw_canvas()
		return True

	def timeout(self):
		self.__info = self.get_drive_info()
		self.recalculate_size()
		self.update_graph()
	
	def on_draw(self, ctx):
		ctx.scale(self.scale, self.scale)
		ctx.set_operator(cairo.OPERATOR_OVER)

		gradient = cairo.LinearGradient(0, self.height*2,0, 0)
		gradient.add_color_stop_rgba(1,*self.frame_color)
		gradient.add_color_stop_rgba(0.7,self.frame_color[0],self.frame_color[1],self.frame_color[2],1-self.frame_color[3]+0.5)
		ctx.set_source(gradient)
		self.draw_rectangle_advanced (ctx, 0, 0, self.width-12, self.height-12, rounded_angles=(5,5,5,5), fill=True, border_size=2, border_color=(0,0,0,0.5), shadow_size=6, shadow_color=(0,0,0,0.5))

		ctx.translate(0, PADDING)
		for i in range(len(self.__info)):
			self.draw_device(ctx, self.__info[i])

			if self.stack_horizontally:
				ctx.translate(220, 0)	
			else:
				ctx.translate(0, DRIVE_HEIGHT)	

	def draw_device(self, ctx, dev):
		# draw text
		ctx.save()
		ctx.translate(55, 5)

		if self.p_layout == None :
			self.p_layout = ctx.create_layout()
		else:
			ctx.update_layout(self.p_layout)

		p_fdesc = pango.FontDescription()
		p_fdesc.set_family_static("Free Sans")
		p_fdesc.set_size(10 * pango.SCALE)
		self.p_layout.set_font_description(p_fdesc)

		markup = "<b>%(nick)s</b>\n<b>%(free)s</b> free of <b>%(size)s - %(quota)s</b>\n\n" % dev

		self.p_layout.set_markup(markup)
		ctx.set_source_rgba(*self.color_text)
		ctx.show_layout(self.p_layout)
		ctx.fill()
		ctx.restore()
		ctx.save()

		w = 190.0 * dev['load'] / 100.0
		ctx.rectangle(14, 39, w, 6)
		if dev['load'] < self.threshold:
			ctx.set_source_rgba(*self.color_normal)
		else:
			ctx.set_source_rgba(*self.color_critical)
		ctx.fill()
		ctx.save()
		self.draw_icon(ctx, 10, 0, gtk.STOCK_HARDDISK, 40, 40)
		ctx.restore()

	def on_draw_shape(self, ctx):
		if self.stack_horizontally:
			ctx.rectangle(0, 0, (220 * len(self.__info) + 2 * PADDING) * self.scale, (DRIVE_HEIGHT +  2 * PADDING) * self.scale)
		else:
			ctx.rectangle(0, 0, 220 * self.scale, (DRIVE_HEIGHT * len(self.__info) + 2 * PADDING) * self.scale)

		ctx.fill()
	
	def on_mouse_down(self, event):
		if self.clicks_enabled and event.button == 1:
			if event.type == gtk.gdk.BUTTON_PRESS:
				return self.detect_button(event.x, event.y)
			else:
				return True
		else:
			return False

	def on_mouse_up(self, event):
		if self.clicks_enabled and self.__drive_clicked >= 0:
			os.system('nautilus "%s"' % self.__info[self.__drive_clicked]['mount'])
			self.__drive_clicked = -1
		return False
	
	def detect_button(self, x, y):
		x /= self.scale
		y /= self.scale

		drive_clicked = -1

		if x >= 15 and x <= 52:
			if y%DRIVE_HEIGHT >= 4 and y%DRIVE_HEIGHT <= 30:
				drive_clicked = int(y)/DRIVE_HEIGHT

		self.__drive_clicked = drive_clicked

		if drive_clicked >= 0:
			return True
		else:
			return False

# If the program is run directly or passed as an argument to the python
# interpreter then create a Screenlet instance and show it
if __name__ == "__main__":
	import screenlets.session
	screenlets.session.create_session(DiskSpaceScreenlet)
