defmodule Torchx.NxDoctestTest do
  @moduledoc """
  Import Nx' doctest and run them on the Torchx backend.

  Many tests are excluded for the reasons below, coverage
  for the excluded tests can be found on Torchx.NxTest.
  """

  # TODO: Add backend tests for the doctests that are excluded

  use ExUnit.Case, async: true

  setup do
    Nx.default_backend(Torchx.Backend)
    :ok
  end

  @temporarily_broken_doctests [
    # broadcast - shape mismatch in one test
    broadcast: 3,
    # dot - Batching not supported
    dot: 6,
    # make_diagonal - depends on indexed_add
    make_diagonal: 2,
    # mean - Torchx does not support unsigned 64 bit integer
    mean: 2,
    # quotient - Torchx does not support unsigned 32 bit integer
    quotient: 2,
    # window_mean - depends on window_sum which is not implemented
    window_mean: 3,
    # require Elixir 1.13+
    sigil_M: 2,
    sigil_V: 2
  ]

  @rounding_error_doctests [
    atanh: 1,
    ceil: 1,
    cos: 1,
    cosh: 1,
    erfc: 1,
    erf_inv: 1,
    round: 1,
    logistic: 1
  ]

  case :os.type() do
    {:win32, _} -> @os_rounding_error_doctests [expm1: 1, erf: 1]
    _ -> @os_rounding_error_doctests []
  end

  @unrelated_doctests [
    default_backend: 1,
    template: 3,
    to_template: 1
  ]

  @inherently_unsupported_doctests [
    # as_type - the rules change per type
    as_type: 2,
    # no API available - bit based
    bitcast: 2,
    count_leading_zeros: 1,
    population_count: 1,
    # no API available - function based
    map: 3,
    window_reduce: 5,
    reduce: 4,
    # incomplete support
    pad: 3,
    # product - some output/input types are unsupported by libtorch
    product: 2
  ]

  @pending_doctests [
    # window_max - still needs to support window_dilations
    window_max: 3,
    # window_min - still needs to support window_dilations
    window_min: 3,
    # window_product - still needs to support window_dilations
    window_product: 3,
    # window_sum - still needs to support window_dilations
    window_sum: 3,
    put_slice: 3
  ]

  doctest Nx,
    except:
      @pending_doctests
      |> Kernel.++(@temporarily_broken_doctests)
      |> Kernel.++(@rounding_error_doctests)
      |> Kernel.++(@os_rounding_error_doctests)
      |> Kernel.++(@inherently_unsupported_doctests)
      |> Kernel.++(@unrelated_doctests)
      |> Kernel.++([:moduledoc])
end
