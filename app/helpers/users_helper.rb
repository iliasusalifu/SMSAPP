module UsersHelper
  def error_field?(object,field,message = nil)
      if object
         if message.nil?
           (object.errors[field.to_sym].any?) ? 'field_with_errors': ''
         else
           (object.errors[field.to_sym].include?(message))? 'field_with_errors' : ''
         end
      else
          ''
      end
  end
end


