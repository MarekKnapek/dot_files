# Save this file at c:\Users\xxx\AppData\Roaming\Sublime Text\Packages\User\mk_align.py
import sublime
import sublime_plugin
mk_debug = False
class MkAlignCommand(sublime_plugin.TextCommand):
	def debug_print(self, str):
		if mk_debug:
			print(str)
	def is_multi_cursor(self):
		view = self.view
		selection = view.sel()
		count = selection.__len__()
		iz = count >= 2
		self.debug_print("is_multi_cursor:" + str(iz))
		return iz
	def are_all_regions_empty(self):
		are = True
		view = self.view
		selection = view.sel()
		for region in selection:
			if not region.empty():
				are = False
				break
		self.debug_print("are_all_regions_empty:" + str(are))
		return are
	def are_all_cursors_connected(self):
		are = True
		view = self.view
		selection = view.sel()
		region = selection.__getitem__(0)
		row, col = view.rowcol(region.b)
		first_row = row
		count = selection.__len__()
		for i in range(count):
			region = selection.__getitem__(i)
			row, col = view.rowcol(region.b)
			if row != first_row + i:
				are = False
				break
		self.debug_print("are_all_cursors_connected:" + str(are))
		return are
	def are_all_cursors_post_tab(self):
		are = True
		view = self.view
		selection = view.sel()
		for region in selection:
			pos = region.b
			if pos == 0:
				are = False
				break
			char = view.substr(sublime.Region(pos - 1, pos))
			if char != "\t":
				are = False
				break
		self.debug_print("are_all_cursors_post_tab:" + str(are))
		return are
	def are_all_cursors_at_line_start(self):
		are = True
		view = self.view
		selection = view.sel()
		for region in selection:
			pos = region.b
			row, col = view.rowcol(pos)
			line_start = view.text_point(row, 0)
			txt = view.substr(sublime.Region(line_start, pos))
			for ch in txt:
				if ch not in ("\t", " "):
					are = False
		self.debug_print("are_all_cursors_at_line_start:" + str(are))
		return are
	def are_all_cursors_not_at_line_start(self):
		are = not self.are_all_cursors_at_line_start()
		return are
	def do_the_aligning(self, edit):
		max_col = 0
		view = self.view
		selection = view.sel()
		for region in selection:
			pos = region.b
			row, col = view.rowcol(pos)
			max_col = max(max_col, col)
		self.debug_print("max pos:" + str(max_col))
		sorted_positions = sorted((r.b for r in selection if r.b > 0), reverse = True)
		for pos in sorted_positions:
			row, col = view.rowcol(pos)
			cnt = max_col - col
			filler = " " * cnt
			view.erase(edit, sublime.Region(pos - 1, pos))
			view.insert(edit, pos - 1, filler)
	def logic(self, edit):
		do_it = True
		do_it = do_it and self.is_multi_cursor()
		do_it = do_it and self.are_all_regions_empty()
		do_it = do_it and self.are_all_cursors_connected()
		do_it = do_it and self.are_all_cursors_post_tab()
		do_it = do_it and self.are_all_cursors_not_at_line_start()
		if do_it:
			self.do_the_aligning(edit)
	def run(self, edit):
		self.debug_print("-----")
		self.logic(edit)
		self.debug_print("=====")
class MkAlignListener(sublime_plugin.EventListener):
	def debug_print(self, str):
		if mk_debug:
			print(str)
	def on_modified(self, view):
		if view.settings().get("mk_align_is_running"):
			return
		cmd, args, repeat = view.command_history(0)
		if cmd in ("undo", "redo"):
			return
		cmd, args, repeat = view.command_history(1)
		if cmd == "mk_align":
			return
		view.settings().set("mk_align_is_running", True)
		view.run_command("mk_align")
		view.settings().set("mk_align_is_running", False)
