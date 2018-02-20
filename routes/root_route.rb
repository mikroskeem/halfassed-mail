module HalfassedMail
  module Routes


    class RootRoute < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(req, res)
        res.status = 200
        res['Content-Type'] = 'application/json'
        res.body = if req.path.end_with?('.json') || req.path.start_with?('/.')
                     JSON.pretty_generate(whoIsFat: 'Your Mom!')
                   else
                     JSON.pretty_generate(message: 'Hello World!')
                   end
      end
    end


  end
end