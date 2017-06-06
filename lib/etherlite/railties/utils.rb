module Etherlite::Railties
  module Utils
    def self.load_contracts(_path, prefix: 'Contract')
      Dir.glob(_path.join('**/*.json')).map do |fullpath|
        path = Pathname.new fullpath
        path = path.relative_path_from _path
        path = path.dirname.join(path.basename(path.extname)).to_s

        Object.const_set(path.camelize + prefix, Etherlite::Abi.load_contract_at(fullpath))
      end
    end
  end
end
