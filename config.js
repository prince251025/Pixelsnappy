/* PixelSnappy public configuration.
   Paste the project's Supabase Project URL and anon/publishable key here.
   Never put a service_role/secret key in browser code. */
window.PIXELSNAPPY_CONFIG = {
  SUPABASE_URL: 'https://geehkerazioatdydlgla.supabase.co',
  SUPABASE_ANON_KEY: 'sb_publishable_dUnzPjb-sERhxJWfN4Mecw_u267xYoi'
};
window.PIXELSNAPPY_IS_CONFIGURED = () => {
  const c = window.PIXELSNAPPY_CONFIG || {};
  return !!c.SUPABASE_URL && !!c.SUPABASE_ANON_KEY &&
    !c.SUPABASE_URL.includes('YOUR-PROJECT') &&
    !c.SUPABASE_ANON_KEY.includes('YOUR_SUPABASE');
};
