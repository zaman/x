require 'ap'
FancyIrb.start	:rocket_mode   => true,
		:colorize      => {
			:output => false,
        		:rocket_prompt => [:cyan, :bright],
        		:result_prompt => [:cyan, :bright],
		},
               :result_proc   => proc { |context|
                        context.last_value.awesome_inspect
                }
