return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        ";f",
        function()
          Snacks.picker.files()
        end,
        desc = "Find files",
        remap = true,
      },
      {
        ";g",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep files",
        remap = true,
      },
      {
        ";r",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume search",
        remap = true,
      },
      {
        "<space>s.",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent files",
        remap = true,
      },
    },
  },
}
