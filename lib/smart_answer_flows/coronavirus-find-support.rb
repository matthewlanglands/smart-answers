module SmartAnswer
  class CoronavirusFindSupportFlow < Flow
    def define
      name "coronavirus-find-support"
      start_page_content_id "6a6ab3c9-4612-4764-8f2f-2c534c3c6b19"
      flow_content_id "31d81949-aa15-48cf-a7f1-f0d0a670e8db"
      status :draft
      next_button_text "Continue"
      show_previous_answers false
      show_escape_link true

      # ======================================================================
      # Where do you live?
      # ======================================================================
      multiple_choice :nation? do
        option :england
        option :scotland
        option :wales
        option :northern_ireland

        on_response do |response|
          self.calculator = Calculators::CoronavirusFindSupportCalculator.new
          calculator.nation = response
        end

        next_node do
          question :need_help_with?
        end
      end

      # ======================================================================
      # What do you need help with because of coronavirus?
      # ======================================================================
      checkbox_question :need_help_with? do
        option :feel_safe
        option :afford_rent_mortgage_bills
        option :afford_food
        option :unemployed
        option :work
        option :live
        option :mental_health
        option :not_sure

        on_response do |response|
          calculator.need_help_with = response
        end

        next_node do
          question :feel_safe?
        end
      end

      # ======================================================================
      # Do you feel safe where you live?
      # ======================================================================
      multiple_choice :feel_safe? do
        option :yes
        option :yes_but
        option :no
        option :not_sure

        on_response do |response|
          calculator.feel_safe = response
        end

        next_node do
          question :afford_rent_mortgage_bills?
        end
      end

      # ======================================================================
      # Are you finding it hard to afford rent, your mortgage or bills?
      # ======================================================================
      multiple_choice :afford_rent_mortgage_bills? do
        option :yes
        option :no
        option :not_sure

        on_response do |response|
          calculator.afford_rent_mortgage_bills = response
        end

        next_node do
          question :afford_food?
        end
      end

      # ======================================================================
      # Are you finding it hard to afford food?
      # ======================================================================
      multiple_choice :afford_food? do
        option :yes
        option :no
        option :not_sure

        on_response do |response|
          calculator.afford_food = response
        end

        next_node do
          question :get_food?
        end
      end

      # ======================================================================
      # Are your able to get food?
      # ======================================================================
      multiple_choice :get_food? do
        option :yes
        option :no
        option :not_sure

        on_response do |response|
          calculator.get_food = response
        end

        next_node do |_response|
          if calculator.get_food == "yes"
            question :self_employed?
          else
            question :able_to_go_out?
          end
        end
      end

      # ======================================================================
      # Are you able to leave your home for food, medicine, or health reasons?
      # ======================================================================
      multiple_choice :able_to_go_out? do
        option :yes
        option :no_1
        option :no_2
        option :no_3
        option :no_4

        on_response do |response|
          calculator.able_to_go_out = response
        end

        next_node do
          question :self_employed?
        end
      end

      # ======================================================================
      # Are you self-employed or a sole trader?
      # ======================================================================
      multiple_choice :self_employed? do
        option :yes
        option :no
        option :not_sure

        on_response do |response|
          calculator.self_employed = response
        end

        next_node do |_response|
          if calculator.self_employed == "yes"
            question :worried_about_work?
          else
            question :have_you_been_made_unemployed?
          end
        end
      end

      # ======================================================================
      # Have you been told to stop working?
      # ======================================================================
      multiple_choice :have_you_been_made_unemployed? do
        option :yes_1
        option :yes_2
        option :no
        option :not_sure

        on_response do |response|
          calculator.have_you_been_made_unemployed = response
        end

        next_node do |_response|
          if %w[yes_1 yes_2].include? calculator.have_you_been_made_unemployed
            question :worried_about_work?
          else
            question :are_you_off_work_ill?
          end
        end
      end

      # ======================================================================
      # Are you off work because you're ill or self-isolating?
      # ======================================================================
      multiple_choice :are_you_off_work_ill? do
        option :yes
        option :no
        option :not_sure

        on_response do |response|
          calculator.are_you_off_work_ill = response
        end

        next_node do
          question :worried_about_work?
        end
      end

      # ======================================================================
      # Are you worried about going in to work?
      # ======================================================================
      multiple_choice :worried_about_work? do
        option :yes
        option :no
        option :not_sure

        on_response do |response|
          calculator.worried_about_work = response
        end

        next_node do
          question :have_somewhere_to_live?
        end
      end

      # ======================================================================
      # Do you have somewhere to live?
      # ======================================================================
      multiple_choice :have_somewhere_to_live? do
        option :yes
        option :yes_but
        option :no
        option :not_sure

        on_response do |response|
          calculator.have_somewhere_to_live = response
        end

        next_node do
          question :have_you_been_evicted?
        end
      end

      # ======================================================================
      # Have you been evicted?
      # ======================================================================
      multiple_choice :have_you_been_evicted? do
        option :yes
        option :soon
        option :no
        option :not_sure

        on_response do |response|
          calculator.have_you_been_evicted = response
        end

        next_node do
          question :mental_health_worries?
        end
      end

      # ======================================================================
      # Are you worries about your mental health or someone else's mental health?
      # ======================================================================
      multiple_choice :mental_health_worries? do
        option :yes
        option :no
        option :not_sure

        on_response do |response|
          calculator.mental_health_worries = response
        end

        next_node do
          outcome :results
        end
      end

      # ======================================================================
      # Results
      # ======================================================================
      outcome :results
    end
  end
end
