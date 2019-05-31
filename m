Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1426930810
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 07:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfEaFUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 01:20:40 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:36037 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfEaFUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 01:20:40 -0400
Received: by mail-ua1-f67.google.com with SMTP id 94so3401939uam.3
        for <stable@vger.kernel.org>; Thu, 30 May 2019 22:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qpai1dizZw4ZY6x8Ow3gR3n28YNslzAiSw17+S2M1YA=;
        b=LOdwyfESjQtESnLroxL2GX7F29IKROYuFufkpcwlMr5PAHaPCRWqAaqIdDJncERdOr
         jP+2T0hqNxkmnTiAk62Sga0A1FZ5pW1d+OING+nNqqLLseHE9fCyprp61kGEYyDudu/5
         S9HoaYabeUYHVHGnZrrcy/uSYV7zkesWLY8/L4yMMpDiCyH9HrK+X/IEB57Ck/lRD/2r
         6isrt5KKY0XEq2cs3uCK+Q2+nfSGJmEJ3gttKde8+XIik+PkdDrdoAtXcMUb3LfFOCza
         lsDfNPjTnzU/dxRFnVomyekY5kdlK7pGncu12O4fF31Yc6tvZ6QAjqRfFV28D3lVCCkc
         JEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qpai1dizZw4ZY6x8Ow3gR3n28YNslzAiSw17+S2M1YA=;
        b=RP4SLaGfBvANOzovVD48OJ8YEB6wKhXndXtE2hm2yH+f9rl362oKYBY35xgh5e2Jn5
         ufYND36aVC2+MCaHjuC2pQw5DVVotUz6XhDJlyu6dY12li2Xl1Hb/AVONgwlwlvbHjp7
         MzSu5HdPuh7L8D6Cx2BMspkniDn4XM61q8Dcz5GrINDOB3U9JYX0U20qgZL1n6Wopzvj
         nLqfw65Fey0M5Kxy2amNuKsOdZgk1LwyZtOcdMIlJlfXIBd8mQuozjLgYm33jth5LfIg
         z0TblEi2rf4jbM6+duzO/Dn4cBQP70dlotpNgiomlxBBBZu+sdGqdLk7NrcPiDOBUYVA
         9ROQ==
X-Gm-Message-State: APjAAAXrwf2g3KAIjdzswElwSlRj6FzgzcQXb7Flj7Hws0CKOqTyUZio
        3moErpfsXCv78yKSAo2z6uEMeVz30rc646LstnZ+2/k+aE7pZA==
X-Google-Smtp-Source: APXvYqyC1Ir4TqxddrXZ/GzYemfvSDtBTki4GLNoqqeZk/bFW5wgj2BJJE5A669khJpjpyhRPmYd+EosEXjTM24n4hE=
X-Received: by 2002:ab0:5a89:: with SMTP id w9mr4162535uae.64.1559280038274;
 Thu, 30 May 2019 22:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190524034154.3376-1-jian-hong@endlessm.com>
In-Reply-To: <20190524034154.3376-1-jian-hong@endlessm.com>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Fri, 31 May 2019 13:20:01 +0800
Message-ID: <CAPpJ_eeig8WJkYRszhmzk75r6Ucsbvsy5w4t6f=thJZ8ziWykw@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio
 power is enabled
To:     stable@vger.kernel.org
Cc:     Linux Upstreaming Team <linux@endlessm.com>,
        Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Clint Taylor <Clinton.A.Taylor@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jian-Hong Pan <jian-hong@endlessm.com> =E6=96=BC 2019=E5=B9=B45=E6=9C=8824=
=E6=97=A5 =E9=80=B1=E4=BA=94 =E4=B8=8A=E5=8D=8811:42=E5=AF=AB=E9=81=93=EF=
=BC=9A
>
> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>
> commit 905801fe72377b4dc53c6e13eea1a91c6a4aa0c4 upstream.
>
> CDCLK has to be at least twice the BLCK regardless of audio. Audio
> driver has to probe using this hook and increase the clock even in
> absence of any display.
>
> v2: Use atomic refcount for get_power, put_power so that we can
>     call each once(Abhay).
> v3: Reset power well 2 to avoid any transaction on iDisp link
>     during cdclk change(Abhay).
> v4: Remove Power well 2 reset workaround(Ville).
> v5: Remove unwanted Power well 2 register defined in v4(Abhay).
> v6:
> - Use a dedicated flag instead of state->modeset for min CDCLK changes
> - Make get/put audio power domain symmetric
> - Rebased on top of intel_wakeref tracking changes.
>
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Signed-off-by: Abhay Kumar <abhay.kumar@intel.com>
> Tested-by: Abhay Kumar <abhay.kumar@intel.com>
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> Reviewed-by: Clint Taylor <Clinton.A.Taylor@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190320135439.12201-=
1-imre.deak@intel.com
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=3D203623
> Cc: <stable@vger.kernel.org> # 5.1.x: d31c85fc8642 snd/hda, drm/i915: Tra=
ck the display_power_status using a cookie
> Cc: <stable@vger.kernel.org> # 5.1.x
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> ---
>  drivers/gpu/drm/i915/i915_drv.h      |  3 ++
>  drivers/gpu/drm/i915/intel_audio.c   | 64 +++++++++++++++++++++++++++-
>  drivers/gpu/drm/i915/intel_cdclk.c   | 30 +++++--------
>  drivers/gpu/drm/i915/intel_display.c |  9 +++-
>  drivers/gpu/drm/i915/intel_drv.h     |  3 ++
>  5 files changed, 86 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_=
drv.h
> index a67a63b5aa84..5c9bb1b2d1f3 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -1622,6 +1622,8 @@ struct drm_i915_private {
>                 struct intel_cdclk_state actual;
>                 /* The current hardware cdclk state */
>                 struct intel_cdclk_state hw;
> +
> +               int force_min_cdclk;
>         } cdclk;
>
>         /**
> @@ -1741,6 +1743,7 @@ struct drm_i915_private {
>          *
>          */
>         struct mutex av_mutex;
> +       int audio_power_refcount;
>
>         struct {
>                 struct mutex mutex;
> diff --git a/drivers/gpu/drm/i915/intel_audio.c b/drivers/gpu/drm/i915/in=
tel_audio.c
> index 502b57ce72ab..20324b0d34c7 100644
> --- a/drivers/gpu/drm/i915/intel_audio.c
> +++ b/drivers/gpu/drm/i915/intel_audio.c
> @@ -741,18 +741,78 @@ void intel_init_audio_hooks(struct drm_i915_private=
 *dev_priv)
>         }
>  }
>
> +static void glk_force_audio_cdclk(struct drm_i915_private *dev_priv,
> +                                 bool enable)
> +{
> +       struct drm_modeset_acquire_ctx ctx;
> +       struct drm_atomic_state *state;
> +       int ret;
> +
> +       drm_modeset_acquire_init(&ctx, 0);
> +       state =3D drm_atomic_state_alloc(&dev_priv->drm);
> +       if (WARN_ON(!state))
> +               return;
> +
> +       state->acquire_ctx =3D &ctx;
> +
> +retry:
> +       to_intel_atomic_state(state)->cdclk.force_min_cdclk_changed =3D t=
rue;
> +       to_intel_atomic_state(state)->cdclk.force_min_cdclk =3D
> +               enable ? 2 * 96000 : 0;
> +
> +       /*
> +        * Protects dev_priv->cdclk.force_min_cdclk
> +        * Need to lock this here in case we have no active pipes
> +        * and thus wouldn't lock it during the commit otherwise.
> +        */
> +       ret =3D drm_modeset_lock(&dev_priv->drm.mode_config.connection_mu=
tex,
> +                              &ctx);
> +       if (!ret)
> +               ret =3D drm_atomic_commit(state);
> +
> +       if (ret =3D=3D -EDEADLK) {
> +               drm_atomic_state_clear(state);
> +               drm_modeset_backoff(&ctx);
> +               goto retry;
> +       }
> +
> +       WARN_ON(ret);
> +
> +       drm_atomic_state_put(state);
> +
> +       drm_modeset_drop_locks(&ctx);
> +       drm_modeset_acquire_fini(&ctx);
> +}
> +
>  static unsigned long i915_audio_component_get_power(struct device *kdev)
>  {
> +       struct drm_i915_private *dev_priv =3D kdev_to_i915(kdev);
> +       intel_wakeref_t ret;
> +
>         /* Catch potential impedance mismatches before they occur! */
>         BUILD_BUG_ON(sizeof(intel_wakeref_t) > sizeof(unsigned long));
>
> -       return intel_display_power_get(kdev_to_i915(kdev), POWER_DOMAIN_A=
UDIO);
> +       ret =3D intel_display_power_get(dev_priv, POWER_DOMAIN_AUDIO);
> +
> +       /* Force CDCLK to 2*BCLK as long as we need audio to be powered. =
*/
> +       if (dev_priv->audio_power_refcount++ =3D=3D 0)
> +               if (IS_CANNONLAKE(dev_priv) || IS_GEMINILAKE(dev_priv))
> +                       glk_force_audio_cdclk(dev_priv, true);
> +
> +       return ret;
>  }
>
>  static void i915_audio_component_put_power(struct device *kdev,
>                                            unsigned long cookie)
>  {
> -       intel_display_power_put(kdev_to_i915(kdev), POWER_DOMAIN_AUDIO, c=
ookie);
> +       struct drm_i915_private *dev_priv =3D kdev_to_i915(kdev);
> +
> +       /* Stop forcing CDCLK to 2*BCLK if no need for audio to be powere=
d. */
> +       if (--dev_priv->audio_power_refcount =3D=3D 0)
> +               if (IS_CANNONLAKE(dev_priv) || IS_GEMINILAKE(dev_priv))
> +                       glk_force_audio_cdclk(dev_priv, false);
> +
> +       intel_display_power_put(dev_priv, POWER_DOMAIN_AUDIO, cookie);
>  }
>
>  static void i915_audio_component_codec_wake_override(struct device *kdev=
,
> diff --git a/drivers/gpu/drm/i915/intel_cdclk.c b/drivers/gpu/drm/i915/in=
tel_cdclk.c
> index 15ba950dee00..553f57ff60f4 100644
> --- a/drivers/gpu/drm/i915/intel_cdclk.c
> +++ b/drivers/gpu/drm/i915/intel_cdclk.c
> @@ -2187,19 +2187,8 @@ int intel_crtc_compute_min_cdclk(const struct inte=
l_crtc_state *crtc_state)
>         /*
>          * According to BSpec, "The CD clock frequency must be at least t=
wice
>          * the frequency of the Azalia BCLK." and BCLK is 96 MHz by defau=
lt.
> -        *
> -        * FIXME: Check the actual, not default, BCLK being used.
> -        *
> -        * FIXME: This does not depend on ->has_audio because the higher =
CDCLK
> -        * is required for audio probe, also when there are no audio capa=
ble
> -        * displays connected at probe time. This leads to unnecessarily =
high
> -        * CDCLK when audio is not required.
> -        *
> -        * FIXME: This limit is only applied when there are displays conn=
ected
> -        * at probe time. If we probe without displays, we'll still end u=
p using
> -        * the platform minimum CDCLK, failing audio probe.
>          */
> -       if (INTEL_GEN(dev_priv) >=3D 9)
> +       if (crtc_state->has_audio && INTEL_GEN(dev_priv) >=3D 9)
>                 min_cdclk =3D max(2 * 96000, min_cdclk);
>
>         /*
> @@ -2239,7 +2228,7 @@ static int intel_compute_min_cdclk(struct drm_atomi=
c_state *state)
>                 intel_state->min_cdclk[i] =3D min_cdclk;
>         }
>
> -       min_cdclk =3D 0;
> +       min_cdclk =3D intel_state->cdclk.force_min_cdclk;
>         for_each_pipe(dev_priv, pipe)
>                 min_cdclk =3D max(intel_state->min_cdclk[pipe], min_cdclk=
);
>
> @@ -2300,7 +2289,8 @@ static int vlv_modeset_calc_cdclk(struct drm_atomic=
_state *state)
>                 vlv_calc_voltage_level(dev_priv, cdclk);
>
>         if (!intel_state->active_crtcs) {
> -               cdclk =3D vlv_calc_cdclk(dev_priv, 0);
> +               cdclk =3D vlv_calc_cdclk(dev_priv,
> +                                      intel_state->cdclk.force_min_cdclk=
);
>
>                 intel_state->cdclk.actual.cdclk =3D cdclk;
>                 intel_state->cdclk.actual.voltage_level =3D
> @@ -2333,7 +2323,7 @@ static int bdw_modeset_calc_cdclk(struct drm_atomic=
_state *state)
>                 bdw_calc_voltage_level(cdclk);
>
>         if (!intel_state->active_crtcs) {
> -               cdclk =3D bdw_calc_cdclk(0);
> +               cdclk =3D bdw_calc_cdclk(intel_state->cdclk.force_min_cdc=
lk);
>
>                 intel_state->cdclk.actual.cdclk =3D cdclk;
>                 intel_state->cdclk.actual.voltage_level =3D
> @@ -2405,7 +2395,7 @@ static int skl_modeset_calc_cdclk(struct drm_atomic=
_state *state)
>                 skl_calc_voltage_level(cdclk);
>
>         if (!intel_state->active_crtcs) {
> -               cdclk =3D skl_calc_cdclk(0, vco);
> +               cdclk =3D skl_calc_cdclk(intel_state->cdclk.force_min_cdc=
lk, vco);
>
>                 intel_state->cdclk.actual.vco =3D vco;
>                 intel_state->cdclk.actual.cdclk =3D cdclk;
> @@ -2444,10 +2434,10 @@ static int bxt_modeset_calc_cdclk(struct drm_atom=
ic_state *state)
>
>         if (!intel_state->active_crtcs) {
>                 if (IS_GEMINILAKE(dev_priv)) {
> -                       cdclk =3D glk_calc_cdclk(0);
> +                       cdclk =3D glk_calc_cdclk(intel_state->cdclk.force=
_min_cdclk);
>                         vco =3D glk_de_pll_vco(dev_priv, cdclk);
>                 } else {
> -                       cdclk =3D bxt_calc_cdclk(0);
> +                       cdclk =3D bxt_calc_cdclk(intel_state->cdclk.force=
_min_cdclk);
>                         vco =3D bxt_de_pll_vco(dev_priv, cdclk);
>                 }
>
> @@ -2483,7 +2473,7 @@ static int cnl_modeset_calc_cdclk(struct drm_atomic=
_state *state)
>                     cnl_compute_min_voltage_level(intel_state));
>
>         if (!intel_state->active_crtcs) {
> -               cdclk =3D cnl_calc_cdclk(0);
> +               cdclk =3D cnl_calc_cdclk(intel_state->cdclk.force_min_cdc=
lk);
>                 vco =3D cnl_cdclk_pll_vco(dev_priv, cdclk);
>
>                 intel_state->cdclk.actual.vco =3D vco;
> @@ -2519,7 +2509,7 @@ static int icl_modeset_calc_cdclk(struct drm_atomic=
_state *state)
>                     cnl_compute_min_voltage_level(intel_state));
>
>         if (!intel_state->active_crtcs) {
> -               cdclk =3D icl_calc_cdclk(0, ref);
> +               cdclk =3D icl_calc_cdclk(intel_state->cdclk.force_min_cdc=
lk, ref);
>                 vco =3D icl_calc_cdclk_pll_vco(dev_priv, cdclk);
>
>                 intel_state->cdclk.actual.vco =3D vco;
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/=
intel_display.c
> index 421aac80a838..ebbac873b8f4 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -12769,6 +12769,11 @@ static int intel_modeset_checks(struct drm_atomi=
c_state *state)
>                 return -EINVAL;
>         }
>
> +       /* keep the current setting */
> +       if (!intel_state->cdclk.force_min_cdclk_changed)
> +               intel_state->cdclk.force_min_cdclk =3D
> +                       dev_priv->cdclk.force_min_cdclk;
> +
>         intel_state->modeset =3D true;
>         intel_state->active_crtcs =3D dev_priv->active_crtcs;
>         intel_state->cdclk.logical =3D dev_priv->cdclk.logical;
> @@ -12864,7 +12869,7 @@ static int intel_atomic_check(struct drm_device *=
dev,
>         struct drm_crtc *crtc;
>         struct drm_crtc_state *old_crtc_state, *crtc_state;
>         int ret, i;
> -       bool any_ms =3D false;
> +       bool any_ms =3D intel_state->cdclk.force_min_cdclk_changed;
>
>         /* Catch I915_MODE_FLAG_INHERITED */
>         for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state,
> @@ -13456,6 +13461,8 @@ static int intel_atomic_commit(struct drm_device =
*dev,
>                 dev_priv->active_crtcs =3D intel_state->active_crtcs;
>                 dev_priv->cdclk.logical =3D intel_state->cdclk.logical;
>                 dev_priv->cdclk.actual =3D intel_state->cdclk.actual;
> +               dev_priv->cdclk.force_min_cdclk =3D
> +                       intel_state->cdclk.force_min_cdclk;
>         }
>
>         drm_atomic_state_get(state);
> diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/inte=
l_drv.h
> index d5660ac1b0d6..539caca05da4 100644
> --- a/drivers/gpu/drm/i915/intel_drv.h
> +++ b/drivers/gpu/drm/i915/intel_drv.h
> @@ -480,6 +480,9 @@ struct intel_atomic_state {
>                  * state only when all crtc's are DPMS off.
>                  */
>                 struct intel_cdclk_state actual;
> +
> +               int force_min_cdclk;
> +               bool force_min_cdclk_changed;
>         } cdclk;
>
>         bool dpll_set, modeset;
> --
> 2.21.0
>

Gentle ping for this patch on Linux stable 5.1.X

It fixes "The audio playback does not work anymore after suspend &
resume" on ASUS E406MA.
Any comment will be appreciated.

Jian-Hong Pan
