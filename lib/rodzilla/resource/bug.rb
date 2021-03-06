module Rodzilla
  module Resource
    class Bug < Base

      # Get information about valid bug fields, including the lists of legal values for each field.
      # 
      # ids (array) - An array of integer field ids.
      # names (array) - An array of strings representing field names.
      # 
      # Support: >= 3.6
      # 
      # If neither ids nor names is specified, then all non-obsolete fields will be returned.
      def fields(params={})
        rpc_call :fields, params
      end

      # Allows you to search for bugs based on particular criteria.
      # 
      # Unless otherwise specified in the description of a parameter,
      # bugs are returned if they match exactly the criteria you specify in these parameters.
      # That is, we don't match against substrings--if a bug is in the "Widgets" product and you ask for bugs in the "Widg" product, you won't get anything.
      # 
      # Criteria are joined in a logical AND
      # 
      # alias         - string The unique alias for this bug.
      # assigned_to   - string The login name of a user that a bug is assigned to.
      # component     - string The name of the Component that the bug is in. Note that if there are multiple Components with the same name, and you search for that name, bugs in all those Components will be returned. If you don't want this, be sure to also specify the product argument.
      # creation_time - dateTime Searches for bugs that were created at this time or later. May not be an array.
      # creator       - string The login name of the user who created the bug.
      # id            - int The numeric id of the bug.
      # last_change_time - dateTime Searches for bugs that were modified at this time or later. May not be an array.
      # limit         - int Limit the number of results returned to int records. If the limit is more than zero and higher than the maximum limit set by the administrator, then the maximum limit will be used instead. If you set the limit equal to zero, then all matching results will be returned instead.
      # offset - int Used in conjunction with the limit argument, offset defines the starting position for the search. For example, given a search that would return 100 bugs, setting limit to 10 and offset to 10 would return bugs 11 through 20 from the set of 100.
      # op_sys - string The "Operating System" field of a bug.
      # platform -string The Platform (sometimes called "Hardware") field of a bug.
      # priority  - string The Priority field on a bug.
      # product - string The name of the Product that the bug is in.
      # resolution - string The current resolution--only set if a bug is closed. You can find open bugs by searching for bugs with an empty resolution.
      # severity - string The Severity field on a bug.
      # status - string The current status of a bug (not including its resolution, if it has one, which is a separate field above).
      # summary - string Searches for substrings in the single-line Summary field on bugs. If you specify an array, then bugs whose summaries match any of the passed substrings will be returned.
      # target_milestone - string The Target Milestone field of a bug. Note that even if this Bugzilla does not have the Target Milestone field enabled, you can still search for bugs by Target Milestone. However, it is likely that in that case, most bugs will not have a Target Milestone set (it defaults to "---" when the field isn't enabled).
      # qa_contact - string The login name of the bug's QA Contact. Note that even if this Bugzilla does not have the QA Contact field enabled, you can still search for bugs by QA Contact (though it is likely that no bug will have a QA Contact set, if the field is disabled).
      # url - string The "URL" field of a bug.
      # version
      # 
      # All params can be either the type or an array of the types
      def search(params={})
        rpc_call :search, params
      end

      # It allows you to get data about attachments, given a list of bugs and/or attachment ids.
      # Note: Private attachments will only be returned if you are in the insidergroup or if you are the submitter of the attachment.
      # 
      # ids (Array)             - An array of integer field ids.
      # attachment_ids (Array)  - An array of integer attachment ids.
      # 
      # Support: >= 3.6
      # 
      # Returns a Hash containing two elements: bugs and attachments
      def attachments(params={})
        raise ArgumentError, "Error: ids or attachment_ids must be set" unless params[:ids] || params[:attachment_ids]
        rpc_call :attachments, params
      end

      # Gets information about particular bugs in the database.
      # 
      # ids (Array) - An array of numbers and strings. If an element in the array is entirely numeric, 
      #               it represents a bug_id from the Bugzilla database to fetch. If it contains any non-numeric characters, 
      #               it is considered to be a bug alias instead, and the bug with that alias will be loaded.
      # permissive (Boolean) - Normally, if you request any inaccessible or invalid bug ids, Bug.get will throw an error. If true it returns info
      #               about bugs that fail.
      # 
      # 
      # Support: >= 3.4              
      # 
      # Returns a Hash containing two elements: bugs and faults
      def get(params={})
        rpc_call :get, params
      end

      # Same as get
      # 
      # Backwards compat with v3.0
      def get_bugs(params={})
        rpc_call :get_bugs, params
      end


      # This allows you to get data about comments, given a list of bugs and/or comment ids.
      # 
      # ids (Array)             - An array of integer field ids.
      # comment_ids (Array)             - An array of integer field ids.
      # 
      # Support: >= 3.4
      # 
      # Returns a Hash containing two items: bugs and comments
      def comments(params={})
        raise ArgumentError, "Error: ids or comment_ids must be set" unless params[:ids] || params[:comment_ids]
        rpc_call :comments, params
      end

      # This allows you to create a new bug in Bugzilla.
      #
      # product (string) Required - The name of the product the bug is being filed against.
      # component (string) Required - The name of a component in the product above.
      # summary (string) Required - A brief description of the bug being filed.
      # version (string) Required - A version of the product above; the version the bug was found in.
      # description (string) Defaulted - The initial description for this bug. Some Bugzilla installations require this to not be blank.
      # op_sys (string) Defaulted - The operating system the bug was discovered on.
      # platform (string) Defaulted - What type of hardware the bug was experienced on.
      # priority (string) Defaulted - What order the bug will be fixed in by the developer, compared to the developer's other bugs.
      # severity (string) Defaulted - How severe the bug is.
      def create!(params={})
        raise ArgumentError, "Error: product, component, summary, version are required args" unless check_params([:product, :component, :summary, :version], params)
        rpc_call :create, params
      end

      # Same as create! but does not raise an ArgumentError for required arguments
      def create(params={})
        rpc_call :create, params
      end

      # This allows you to add an attachment to a bug in Bugzilla.
      # 
      # ids - (Required) An array of ints and/or strings--the ids or aliases of bugs that you want to add this attachment to. The same attachment and comment will be added to all these bugs.
      # data - (Required) base64 or string The content of the attachment. If the content of the attachment is not ASCII text, you must encode it in base64 and declare it as the base64 type.
      # file_name - (Required) string The "file name" that will be displayed in the UI for this attachment.
      # summary - (Required) string A short string describing the attachment.
      # content_type - (Required) string The MIME type of the attachment, like text/plain or image/png.
      # 
      # comment - String A comment to add along with this attachment.
      # is_patch Boolean true if Bugzilla should treat this attachment as a patch
      # is_private  Boolean true if the attachment should be private 
      # 
      # Support: >= 4.0
      #
      # Returns a single item ids, which contains an array of the attachment id(s) created. 
      def add_attachment!(params={})
        raise ArgumentError, "Error: ids, data, file_name, summary, and content_type are required args" unless check_params([:ids, :data, :file_name, :summary, :content_type], params)
        rpc_call :add_attachment, params
      end

      # Same as add_attachment! but won't raise an exception for missing required arguments
      def add_attachment(params={})
        rcp_call :add_attachment, params
      end

      # Allows you to update the fields of a bug. Automatically sends emails out about the changes.
      # 
      # ids - Array of ints or strings. The ids or aliases of the bugs that you want to modify.
      # 
      # Returns a Hash with a single field, "bugs".
      def update(params={})
        raise ArgumentError, "Error: ids is a required arg" unless check_params([:ids], params)
        rpc_call :update, params
      end

    end
  end
end