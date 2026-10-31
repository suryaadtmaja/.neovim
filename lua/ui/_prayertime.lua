vim.keymap.set("n", "<leader>pt", function()
	require("prayertime").show_today({ mode = "float" })
end, { desc = "PrayerTime: show today" })

vim.keymap.set("n", "<leader>pr", function()
	require("prayertime").refresh()
end, { desc = "PrayerTime: refresh schedule" })

vim.keymap.set("n", "<leader>pa", "<cmd>PrayerTest<CR>", { desc = "PrayerTime: test adhan" })
vim.api.nvim_create_autocmd("User", {
	pattern = "PrayertimeAdhan",
	callback = function(ev)
		vim.notify(("Time for %s (%s)"):format(ev.data.prayer, ev.data.time))
	end,
})

return {
	"muhfaris/prayertime.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { city = "Jakarta", country = "Indonesia", method = 2 },
	config = function()
		require("prayertime").show_today({ mode = "float" })
	end,
}
