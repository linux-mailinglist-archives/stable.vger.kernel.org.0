Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB1B691D2F
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 11:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjBJKsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 05:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjBJKsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 05:48:00 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9536D63D
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 02:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676026078; x=1707562078;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=pf056wxaf9+3pMVFuyOB0yeKHcsdpjtr3/dwXb+Uw3o=;
  b=KL5Xp6YREn+oo1JNLJY3uzCP8qWuOkVFmTPkpHQIiZjAUJjyiv3gVJ2H
   3ePs1lYL3hdeGziogLQGcZuR/LyyaxAxas+Vzc0ZBedxptYCLhVlVRcpZ
   0X2kcimD1zLZQrRF1cVIXS8VjI0JX5YPcMvy3I6DJusBexbAK1tk6el7q
   5N/layh8WNwkCG4vd8Ym6x0o4qsQwYZPi+o1c7XiyyA0tAB6A/uAWqn9g
   HohQ5BHsYQXcNB8oDQW9dSnCt2PssUymYy7usp/9mksPjyYJQemyG5g5W
   RtCIXoslZFHMdYVovA+HzfvHEfmQf3HdFhk/r1W0VU8THAdDqvQU2Xz0J
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="330397600"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="330397600"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 02:47:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="810776659"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="810776659"
Received: from myegin-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.38.74])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 02:47:54 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     Lyude Paul <lyude@redhat.com>, imre.deak@intel.com,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Karol Herbst <kherbst@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [Cc: drm-misc folks] Re: [Intel-gfx] [CI 1/4] drm/i915/dp_mst:
 Add the MST topology state for modesetted CRTCs
In-Reply-To: <0b5a4e81dc98f9c28d77f0f53741712d1c7c3c09.camel@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20230206114856.2665066-1-imre.deak@intel.com>
 <Y+JLQfuSAS6xLPIS@ideak-desk.fi.intel.com>
 <0b5a4e81dc98f9c28d77f0f53741712d1c7c3c09.camel@redhat.com>
Date:   Fri, 10 Feb 2023 12:47:51 +0200
Message-ID: <87bkm1x0dk.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 09 Feb 2023, Lyude Paul <lyude@redhat.com> wrote:
> On Tue, 2023-02-07 at 14:59 +0200, Imre Deak wrote:
>> Hi all,
>>=20
>> On Mon, Feb 06, 2023 at 01:48:53PM +0200, Imre Deak wrote:
>> > Add the MST topology for a CRTC to the atomic state if the driver
>> > needs to force a modeset on the CRTC after the encoder compute config
>> > functions are called.
>> >=20
>> > Later the MST encoder's disable hook also adds the state, but that isn=
't
>> > guaranteed to work (since in that hook getting the state may fail, whi=
ch
>> > can't be handled there). This should fix that, while a later patch fix=
es
>> > the use of the MST state in the disable hook.
>> >=20
>> > v2: Add missing forward struct declartions, caught by hdrtest.
>> > v3: Factor out intel_dp_mst_add_topology_state_for_connector() used
>> >     later in the patchset.
>> >=20
>> > Cc: Lyude Paul <lyude@redhat.com>
>> > Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>> > Cc: stable@vger.kernel.org # 6.1
>> > Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com> #=
 v2
>> > Reviewed-by: Lyude Paul <lyude@redhat.com>
>> > Signed-off-by: Imre Deak <imre.deak@intel.com>
>>=20
>> Is it ok to merge these 4 patches (also at [1]), via the i915 tree?
>>=20
>> If so could it be also acked from the AMD and Nouveau side?
>
> Whichever branch works best for y'all is fine by me, if it's via i915's t=
ree I
> guess we might need to back-merge drm-misc at some point so I can write up
> equivalent fixes for nouveau as well.
>
> (Added Thomas Zimmermann to Cc)

I suggest merging the series via drm-misc-next-fixes branch, to get them
to Linus' tree in the upcoming merge window. They all apply cleanly
there. The drivers can backmerge them from drm-next in the mean time, or
wait for v6.3-rc1.

Daniel acked this (well, any -next-fixes branch) on IRC yesterday,
obviously ack from me too.

I take the above as Lyude's ack for nouveau.

Harry, Wayne, do you agree with this, ack for merging the AMD part via
drm-misc-next-fixes? (Alex suggested to get your input.)


BR,
Jani.


>
>>=20
>> [1] https://patchwork.freedesktop.org/series/113703/
>>=20
>> > ---
>> >  drivers/gpu/drm/i915/display/intel_display.c |  4 ++
>> >  drivers/gpu/drm/i915/display/intel_dp_mst.c  | 61 ++++++++++++++++++++
>> >  drivers/gpu/drm/i915/display/intel_dp_mst.h  |  4 ++
>> >  3 files changed, 69 insertions(+)
>> >=20
>> > diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gp=
u/drm/i915/display/intel_display.c
>> > index 166662ade593c..38106cf63b3b9 100644
>> > --- a/drivers/gpu/drm/i915/display/intel_display.c
>> > +++ b/drivers/gpu/drm/i915/display/intel_display.c
>> > @@ -5936,6 +5936,10 @@ int intel_modeset_all_pipes(struct intel_atomic=
_state *state,
>> >  		if (ret)
>> >  			return ret;
>> >=20=20
>> > +		ret =3D intel_dp_mst_add_topology_state_for_crtc(state, crtc);
>> > +		if (ret)
>> > +			return ret;
>> > +
>> >  		ret =3D intel_atomic_add_affected_planes(state, crtc);
>> >  		if (ret)
>> >  			return ret;
>> > diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu=
/drm/i915/display/intel_dp_mst.c
>> > index 8b0e4defa3f10..f3cb12dcfe0a7 100644
>> > --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
>> > +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
>> > @@ -1223,3 +1223,64 @@ bool intel_dp_mst_is_slave_trans(const struct i=
ntel_crtc_state *crtc_state)
>> >  	return crtc_state->mst_master_transcoder !=3D INVALID_TRANSCODER &&
>> >  	       crtc_state->mst_master_transcoder !=3D crtc_state->cpu_transc=
oder;
>> >  }
>> > +
>> > +/**
>> > + * intel_dp_mst_add_topology_state_for_connector - add MST topology s=
tate for a connector
>> > + * @state: atomic state
>> > + * @connector: connector to add the state for
>> > + * @crtc: the CRTC @connector is attached to
>> > + *
>> > + * Add the MST topology state for @connector to @state.
>> > + *
>> > + * Returns 0 on success, negative error code on failure.
>> > + */
>> > +static int
>> > +intel_dp_mst_add_topology_state_for_connector(struct intel_atomic_sta=
te *state,
>> > +					      struct intel_connector *connector,
>> > +					      struct intel_crtc *crtc)
>> > +{
>> > +	struct drm_dp_mst_topology_state *mst_state;
>> > +
>> > +	if (!connector->mst_port)
>> > +		return 0;
>> > +
>> > +	mst_state =3D drm_atomic_get_mst_topology_state(&state->base,
>> > +						      &connector->mst_port->mst_mgr);
>> > +	if (IS_ERR(mst_state))
>> > +		return PTR_ERR(mst_state);
>> > +
>> > +	mst_state->pending_crtc_mask |=3D drm_crtc_mask(&crtc->base);
>> > +
>> > +	return 0;
>> > +}
>> > +
>> > +/**
>> > + * intel_dp_mst_add_topology_state_for_crtc - add MST topology state =
for a CRTC
>> > + * @state: atomic state
>> > + * @crtc: CRTC to add the state for
>> > + *
>> > + * Add the MST topology state for @crtc to @state.
>> > + *
>> > + * Returns 0 on success, negative error code on failure.
>> > + */
>> > +int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_stat=
e *state,
>> > +					     struct intel_crtc *crtc)
>> > +{
>> > +	struct drm_connector *_connector;
>> > +	struct drm_connector_state *conn_state;
>> > +	int i;
>> > +
>> > +	for_each_new_connector_in_state(&state->base, _connector, conn_state=
, i) {
>> > +		struct intel_connector *connector =3D to_intel_connector(_connector=
);
>> > +		int ret;
>> > +
>> > +		if (conn_state->crtc !=3D &crtc->base)
>> > +			continue;
>> > +
>> > +		ret =3D intel_dp_mst_add_topology_state_for_connector(state, connec=
tor, crtc);
>> > +		if (ret)
>> > +			return ret;
>> > +	}
>> > +
>> > +	return 0;
>> > +}
>> > diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.h b/drivers/gpu=
/drm/i915/display/intel_dp_mst.h
>> > index f7301de6cdfb3..f1815bb722672 100644
>> > --- a/drivers/gpu/drm/i915/display/intel_dp_mst.h
>> > +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.h
>> > @@ -8,6 +8,8 @@
>> >=20=20
>> >  #include <linux/types.h>
>> >=20=20
>> > +struct intel_atomic_state;
>> > +struct intel_crtc;
>> >  struct intel_crtc_state;
>> >  struct intel_digital_port;
>> >  struct intel_dp;
>> > @@ -18,5 +20,7 @@ int intel_dp_mst_encoder_active_links(struct intel_d=
igital_port *dig_port);
>> >  bool intel_dp_mst_is_master_trans(const struct intel_crtc_state *crtc=
_state);
>> >  bool intel_dp_mst_is_slave_trans(const struct intel_crtc_state *crtc_=
state);
>> >  bool intel_dp_mst_source_support(struct intel_dp *intel_dp);
>> > +int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_stat=
e *state,
>> > +					     struct intel_crtc *crtc);
>> >=20=20
>> >  #endif /* __INTEL_DP_MST_H__ */
>> > --=20
>> > 2.37.1
>> >=20
>>=20

--=20
Jani Nikula, Intel Open Source Graphics Center
