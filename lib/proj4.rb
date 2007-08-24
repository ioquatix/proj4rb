ENV['PROJ_LIB'] = File.dirname(__FILE__) + '/../data'
require 'projrb'

# Ruby bindings for the Proj4 cartographic projection library.
module Proj4

    # The UV class holds one coordinate pair. Can be either lon/lat or x/y.
    class UV

        # Compare to UV instances, they are equal if both coordinates are equal, respectively.
        def ==(uv)
            self.u == uv.u && self.v == uv.v
        end

        # Create string in format 'x,y'.
        def to_s
            "#{u},#{v}"
        end

    end

    # The Projection class represents a geographical projection.
    class Projection

        # Convenience function for calculating a forward projection with degrees instead of radians.
        def forwardDeg(uv)
            forward(Proj4::UV.new( uv.u * Proj4::DEG_TO_RAD, uv.v * Proj4::DEG_TO_RAD))
        end

        # Convenience function for calculating an inverse projection with the result in degrees instead of radians.
        def inverseDeg(uv)
            uvd = inverse(uv)
            Proj4::UV.new( uvd.u * Proj4::RAD_TO_DEG, uvd.v * Proj4::RAD_TO_DEG)
        end

    end

    # Abstract base class for several types of definitions: Proj4::Datum, Proj4::Ellipsoid, Proj4::PrimeMeridian, Proj4::Unit.
    class Def

        # Initialize function raises error. Definitions are always defined by the underlying Proj.4 library, you can't create them yourself.
        def initialize # :nodoc:
            raise TypeError, "You can't created objects of this type yourself."
        end

        # Get the definition with given id.
        def self.get(id)
            self.list.select{ |u| u.id == id }.first
        end

        # Compares definitions by comparing ids.
        def ==(other)
            self.id == other.id
        end

        # Compares definitions by comparing ids.
        def <=>(other)
            self.id <=> other.id
        end

        # Stringify definition. Returns ID of this definition.
        def to_s
            id
        end

    end

    class Unit < Def

        # Returns unit definition as string in format '#<Proj4::Unit id="...", to_meter="...", name="...">'.
        def inspect
            "#<Proj4::Unit id=\"#{id}\", to_meter=\"#{to_meter}\", name=\"#{name}\">"
        end

    end

    class Ellipsoid < Def

        # Returns ellipsoid definition as string in format '#<Proj4::Ellipsoid id="...", major="...", ell="...", name="...">'.
        def inspect
            "#<Proj4::Ellipsoid id=\"#{id}\", major=\"#{major}\", ell=\"#{ell}\", name=\"#{name}\">"
        end

    end

    class Datum < Def

        # Returns datum definition as string in format '#<Proj4::Datum id="...", ellipse_id="...", defn="...", comments="...">'.
        def inspect
            "#<Proj4::Datum id=\"#{id}\", ellipse_id=\"#{ellipse_id}\", defn=\"#{defn}\", comments=\"#{comments}\">"
        end

    end

    class PrimeMeridian < Def

        # Returns a prime meridian definition as string in format '#<Proj4::PrimeMeridian id="...", defn="...">'.
        def inspect
            "#<Proj4::PrimeMeridian id=\"#{id}\", defn=\"#{defn}\">"
        end

    end

end

