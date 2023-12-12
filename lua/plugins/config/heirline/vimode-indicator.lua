return {
    -- get vim current mode, this information will be required by the provider
    -- and the highlight functions, so we compute it only once per component
    -- evaluation and store it as a component attribute
    init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
    end,
    -- Now we define some dictionaries to map the output of mode() to the
    -- corresponding string and color. We can put these into `static` to compute
    -- them at initialisation time.
    static = {
        mode_names = { -- change the strings if you like it vvvvverbose!
            n = "N",
            no = "N",
            nov = "N",
            noV = "N",
            ["no\22"] = "N",
            niI = "N",
            niR = "N",
            niV = "N",
            nt = "N",
            v = "V",
            vs = "V",
            V = "V",
            Vs = "V",
            ["\22"] = "V",
            ["\22s"] = "V",
            s = "S",
            S = "S",
            ["\19"] = "S",
            i = "I",
            ic = "I",
            ix = "I",
            R = "R",
            Rc = "R",
            Rx = "R",
            Rv = "R",
            Rvc = "R",
            Rvx = "R",
            c = "C",
            cv = "C",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
        },
        mode_colors = {
            n = { fg = "normal_mode_fg", bg = "normal_mode_bg", bold = true },
            i = { fg = "insert_mode_fg", bg = "insert_mode_bg", bold = true },
            v = { fg = "visual_mode_fg", bg = "visual_mode_bg", bold = true },
            V = { fg = "visual_mode_fg", bg = "visual_mode_bg", bold = true },
            r = { fg = "replace_mode_fg", bg = "replace_mode_bg", bold = true },
            R = { fg = "replace_mode_fg", bg = "replace_mode_bg", bold = true },
            c = { fg = "change_mode_fg", bg = "change_mode_bg", bold = true },
        }
    },
    -- We can now access the value of mode() that, by now, would have been
    -- computed by `init()` and use it to index our strings dictionary.
    -- note how `static` fields become just regular attributes once the
    -- component is instantiated.
    -- To be extra meticulous, we can also add some vim statusline syntax to
    -- control the padding and make sure our string is always at least 2
    -- characters long. Plus a nice Icon.
    provider = function(self)
        return " %2("..self.mode_names[self.mode].."%)  "
    end,
    -- Same goes for the highlight. Now the foreground will change according to the current mode.
    hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return self.mode_colors[mode]
    end,
    -- Re-evaluate the component only on ModeChanged event!
    -- Also allows the statusline to be re-evaluated when entering operator-pending mode
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    },
}
