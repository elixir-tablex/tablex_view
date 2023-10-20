defmodule TablexView.Renderer.HitPolicy do
  for {hit_policy, text} <- Tablex.HitPolicy.hit_policies() do
    def render_hit_policy(unquote(hit_policy)) do
      unquote(text)
    end
  end
end
