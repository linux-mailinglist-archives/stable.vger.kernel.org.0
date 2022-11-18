Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA3762FE79
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 20:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiKRT5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 14:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiKRT5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 14:57:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24F2BF779
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 11:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668801378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CEyx53gZXx39r5ZzEsUmHHGc7+WMh+K1iTS4aj34mp4=;
        b=XNHxTd9gpEY2eXmt+77eePNuu4M1+cclbOgKyyMkrsvyq44xfoSJOa2vxNOR/3WUQaqdnD
        K9FEPrQ9h3OMK2UiW0cgc29u9mcSNcL+h8QNqz46eUsShjc2tOYxJ5wrLLdox2Re4HoqWy
        R6+YPX7pqLeZPiqzrbRM0lNjgNPa6D0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-16-fDFkvnifNc-_WLP_n3LM4Q-1; Fri, 18 Nov 2022 14:56:17 -0500
X-MC-Unique: fDFkvnifNc-_WLP_n3LM4Q-1
Received: by mail-qk1-f198.google.com with SMTP id bi42-20020a05620a31aa00b006faaa1664b9so7374241qkb.8
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 11:56:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CEyx53gZXx39r5ZzEsUmHHGc7+WMh+K1iTS4aj34mp4=;
        b=FCBDNrMFgf8ULJynKEqIFrnmVgCZyTiWxy3oR5yZA2gMr5TWsoKZqzbpdIV8RU/718
         r5bZg5Lo7HuPolOoO6silkCHPuOsu5ycOk385Xsaeo4Nqfpd556RdUI17YVsBty5N8/b
         jhZs77GR/Eu4z8l/ILfQ+/pvk2e4yWB+0dcitX3jRgi6I4t9GY1eIDqUn/FsntIkiehT
         cMuk1eoCCWKD87/j3qVtrezxTQElx/DAHmpBtKLx1hk0X+pWd0geWGbZ1oot8n6QLUBi
         QCNfe5c0Xfh+iK3HAIWzRe3RZuqS4DrpM/5DKc+eaFBvwhM7fMpqmTMjXxP8Qg2HObQq
         /bgA==
X-Gm-Message-State: ANoB5pmV73dFm8CVkZf1+RHXITiiCBTbYV3ugjerTviHK+4IBWHPCUzL
        FKUsVz8cp6AoCkAp1YtOf0fV+L6aWd5js38GDD7KocaFLGbXa9pacggjfe1rXAVWTSVm6k+HYVT
        QVoJ10Ddd7n7cfoab
X-Received: by 2002:a37:ad0a:0:b0:6fa:2c9a:ae20 with SMTP id f10-20020a37ad0a000000b006fa2c9aae20mr7362129qkm.582.1668801376804;
        Fri, 18 Nov 2022 11:56:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6jVEmgdXsUXSppWKoJ7M9sbgjAsYF7Ypp5NpRxswZIuJCBfKdIHXU/TUOh60v5/BUpKijHZw==
X-Received: by 2002:a37:ad0a:0:b0:6fa:2c9a:ae20 with SMTP id f10-20020a37ad0a000000b006fa2c9aae20mr7362096qkm.582.1668801376361;
        Fri, 18 Nov 2022 11:56:16 -0800 (PST)
Received: from ?IPv6:2600:4040:5c6c:9200::feb? ([2600:4040:5c6c:9200::feb])
        by smtp.gmail.com with ESMTPSA id z15-20020a05622a124f00b003a51e6b6c95sm2517759qtx.14.2022.11.18.11.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 11:56:15 -0800 (PST)
Message-ID: <29f76fbb9d19c34f573b9c9a7123148227491c51.camel@redhat.com>
Subject: Re: [v3] drm/amdgpu/mst: Stop ignoring error codes and deadlocking
From:   Lyude Paul <lyude@redhat.com>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     Wenjing Liu <Wenjing.Liu@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        David Airlie <airlied@gmail.com>,
        David Francis <David.Francis@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Hung <alex.hung@amd.com>, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>, Leo Li <sunpeng.li@amd.com>,
        hersen wu <hersenxs.wu@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>, Roman Li <roman.li@amd.com>,
        stable@vger.kernel.org,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Date:   Fri, 18 Nov 2022 14:56:13 -0500
In-Reply-To: <3cc891d9-f136-2381-cc8e-016a2ad9a967@amd.com>
References: <20221118192546.87475-1-lyude@redhat.com>
         <3cc891d9-f136-2381-cc8e-016a2ad9a967@amd.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-11-18 at 13:54 -0600, Limonciello, Mario wrote:
> On 11/18/2022 13:25, Lyude Paul wrote:
> > It appears that amdgpu makes the mistake of completely ignoring the return
> > values from the DP MST helpers, and instead just returns a simple
> > true/false. In this case, it seems to have come back to bite us because as
> > a result of simply returning false from
> > compute_mst_dsc_configs_for_state(), amdgpu had no way of telling when a
> > deadlock happened from these helpers. This could definitely result in some
> > kernel splats.
> > 
> > V2:
> > * Address Wayne's comments (fix another bunch of spots where we weren't
> >    passing down return codes)
> > V3:
> > * Fix uninitialized var in pre_compute_mst_dsc_configs_for_state()
> 
> FYI v2 was just merged recently, it's in the 6.2 pull request that was 
> sent out and Alex planned to add it to 6.1-fixes next week too.
> 
> Can you send just the delta from v2->v3 as another patch so it can layer 
> in cleanly?

Just did that :), it should be on the list now

> > 
> > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > Fixes: 8c20a1ed9b4f ("drm/amd/display: MST DSC compute fair share")
> > Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
> > Cc: Harry Wentland <harry.wentland@amd.com>
> > Cc: <stable@vger.kernel.org> # v5.6+
> > ---
> >   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  18 +-
> >   .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 235 ++++++++++--------
> >   .../display/amdgpu_dm/amdgpu_dm_mst_types.h   |  12 +-
> >   3 files changed, 147 insertions(+), 118 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > index 0db2a88cd4d7..852a2100c6b3 100644
> > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > @@ -6462,7 +6462,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
> >   	struct drm_connector_state *new_con_state;
> >   	struct amdgpu_dm_connector *aconnector;
> >   	struct dm_connector_state *dm_conn_state;
> > -	int i, j;
> > +	int i, j, ret;
> >   	int vcpi, pbn_div, pbn, slot_num = 0;
> >   
> >   	for_each_new_connector_in_state(state, connector, new_con_state, i) {
> > @@ -6509,8 +6509,11 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
> >   			dm_conn_state->pbn = pbn;
> >   			dm_conn_state->vcpi_slots = slot_num;
> >   
> > -			drm_dp_mst_atomic_enable_dsc(state, aconnector->port, dm_conn_state->pbn,
> > -						     false);
> > +			ret = drm_dp_mst_atomic_enable_dsc(state, aconnector->port,
> > +							   dm_conn_state->pbn, false);
> > +			if (ret < 0)
> > +				return ret;
> > +
> >   			continue;
> >   		}
> >   
> > @@ -9523,10 +9526,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
> >   
> >   #if defined(CONFIG_DRM_AMD_DC_DCN)
> >   	if (dc_resource_is_dsc_encoding_supported(dc)) {
> > -		if (!pre_validate_dsc(state, &dm_state, vars)) {
> > -			ret = -EINVAL;
> > +		ret = pre_validate_dsc(state, &dm_state, vars);
> > +		if (ret != 0)
> >   			goto fail;
> > -		}
> >   	}
> >   #endif
> >   
> > @@ -9621,9 +9623,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
> >   		}
> >   
> >   #if defined(CONFIG_DRM_AMD_DC_DCN)
> > -		if (!compute_mst_dsc_configs_for_state(state, dm_state->context, vars)) {
> > +		ret = compute_mst_dsc_configs_for_state(state, dm_state->context, vars);
> > +		if (ret) {
> >   			DRM_DEBUG_DRIVER("compute_mst_dsc_configs_for_state() failed\n");
> > -			ret = -EINVAL;
> >   			goto fail;
> >   		}
> >   
> > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> > index 6ff96b4bdda5..2f72745660fb 100644
> > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> > @@ -703,13 +703,13 @@ static int bpp_x16_from_pbn(struct dsc_mst_fairness_params param, int pbn)
> >   	return dsc_config.bits_per_pixel;
> >   }
> >   
> > -static bool increase_dsc_bpp(struct drm_atomic_state *state,
> > -			     struct drm_dp_mst_topology_state *mst_state,
> > -			     struct dc_link *dc_link,
> > -			     struct dsc_mst_fairness_params *params,
> > -			     struct dsc_mst_fairness_vars *vars,
> > -			     int count,
> > -			     int k)
> > +static int increase_dsc_bpp(struct drm_atomic_state *state,
> > +			    struct drm_dp_mst_topology_state *mst_state,
> > +			    struct dc_link *dc_link,
> > +			    struct dsc_mst_fairness_params *params,
> > +			    struct dsc_mst_fairness_vars *vars,
> > +			    int count,
> > +			    int k)
> >   {
> >   	int i;
> >   	bool bpp_increased[MAX_PIPES];
> > @@ -719,6 +719,7 @@ static bool increase_dsc_bpp(struct drm_atomic_state *state,
> >   	int remaining_to_increase = 0;
> >   	int link_timeslots_used;
> >   	int fair_pbn_alloc;
> > +	int ret = 0;
> >   
> >   	for (i = 0; i < count; i++) {
> >   		if (vars[i + k].dsc_enabled) {
> > @@ -757,52 +758,60 @@ static bool increase_dsc_bpp(struct drm_atomic_state *state,
> >   
> >   		if (initial_slack[next_index] > fair_pbn_alloc) {
> >   			vars[next_index].pbn += fair_pbn_alloc;
> > -			if (drm_dp_atomic_find_time_slots(state,
> > -							  params[next_index].port->mgr,
> > -							  params[next_index].port,
> > -							  vars[next_index].pbn) < 0)
> > -				return false;
> > -			if (!drm_dp_mst_atomic_check(state)) {
> > +			ret = drm_dp_atomic_find_time_slots(state,
> > +							    params[next_index].port->mgr,
> > +							    params[next_index].port,
> > +							    vars[next_index].pbn);
> > +			if (ret < 0)
> > +				return ret;
> > +
> > +			ret = drm_dp_mst_atomic_check(state);
> > +			if (ret == 0) {
> >   				vars[next_index].bpp_x16 = bpp_x16_from_pbn(params[next_index], vars[next_index].pbn);
> >   			} else {
> >   				vars[next_index].pbn -= fair_pbn_alloc;
> > -				if (drm_dp_atomic_find_time_slots(state,
> > -								  params[next_index].port->mgr,
> > -								  params[next_index].port,
> > -								  vars[next_index].pbn) < 0)
> > -					return false;
> > +				ret = drm_dp_atomic_find_time_slots(state,
> > +								    params[next_index].port->mgr,
> > +								    params[next_index].port,
> > +								    vars[next_index].pbn);
> > +				if (ret < 0)
> > +					return ret;
> >   			}
> >   		} else {
> >   			vars[next_index].pbn += initial_slack[next_index];
> > -			if (drm_dp_atomic_find_time_slots(state,
> > -							  params[next_index].port->mgr,
> > -							  params[next_index].port,
> > -							  vars[next_index].pbn) < 0)
> > -				return false;
> > -			if (!drm_dp_mst_atomic_check(state)) {
> > +			ret = drm_dp_atomic_find_time_slots(state,
> > +							    params[next_index].port->mgr,
> > +							    params[next_index].port,
> > +							    vars[next_index].pbn);
> > +			if (ret < 0)
> > +				return ret;
> > +
> > +			ret = drm_dp_mst_atomic_check(state);
> > +			if (ret == 0) {
> >   				vars[next_index].bpp_x16 = params[next_index].bw_range.max_target_bpp_x16;
> >   			} else {
> >   				vars[next_index].pbn -= initial_slack[next_index];
> > -				if (drm_dp_atomic_find_time_slots(state,
> > -								  params[next_index].port->mgr,
> > -								  params[next_index].port,
> > -								  vars[next_index].pbn) < 0)
> > -					return false;
> > +				ret = drm_dp_atomic_find_time_slots(state,
> > +								    params[next_index].port->mgr,
> > +								    params[next_index].port,
> > +								    vars[next_index].pbn);
> > +				if (ret < 0)
> > +					return ret;
> >   			}
> >   		}
> >   
> >   		bpp_increased[next_index] = true;
> >   		remaining_to_increase--;
> >   	}
> > -	return true;
> > +	return 0;
> >   }
> >   
> > -static bool try_disable_dsc(struct drm_atomic_state *state,
> > -			    struct dc_link *dc_link,
> > -			    struct dsc_mst_fairness_params *params,
> > -			    struct dsc_mst_fairness_vars *vars,
> > -			    int count,
> > -			    int k)
> > +static int try_disable_dsc(struct drm_atomic_state *state,
> > +			   struct dc_link *dc_link,
> > +			   struct dsc_mst_fairness_params *params,
> > +			   struct dsc_mst_fairness_vars *vars,
> > +			   int count,
> > +			   int k)
> >   {
> >   	int i;
> >   	bool tried[MAX_PIPES];
> > @@ -810,6 +819,7 @@ static bool try_disable_dsc(struct drm_atomic_state *state,
> >   	int max_kbps_increase;
> >   	int next_index;
> >   	int remaining_to_try = 0;
> > +	int ret;
> >   
> >   	for (i = 0; i < count; i++) {
> >   		if (vars[i + k].dsc_enabled
> > @@ -840,49 +850,52 @@ static bool try_disable_dsc(struct drm_atomic_state *state,
> >   			break;
> >   
> >   		vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.stream_kbps);
> > -		if (drm_dp_atomic_find_time_slots(state,
> > -						  params[next_index].port->mgr,
> > -						  params[next_index].port,
> > -						  vars[next_index].pbn) < 0)
> > -			return false;
> > +		ret = drm_dp_atomic_find_time_slots(state,
> > +						    params[next_index].port->mgr,
> > +						    params[next_index].port,
> > +						    vars[next_index].pbn);
> > +		if (ret < 0)
> > +			return ret;
> >   
> > -		if (!drm_dp_mst_atomic_check(state)) {
> > +		ret = drm_dp_mst_atomic_check(state);
> > +		if (ret == 0) {
> >   			vars[next_index].dsc_enabled = false;
> >   			vars[next_index].bpp_x16 = 0;
> >   		} else {
> >   			vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.max_kbps);
> > -			if (drm_dp_atomic_find_time_slots(state,
> > -							  params[next_index].port->mgr,
> > -							  params[next_index].port,
> > -							  vars[next_index].pbn) < 0)
> > -				return false;
> > +			ret = drm_dp_atomic_find_time_slots(state,
> > +							    params[next_index].port->mgr,
> > +							    params[next_index].port,
> > +							    vars[next_index].pbn);
> > +			if (ret < 0)
> > +				return ret;
> >   		}
> >   
> >   		tried[next_index] = true;
> >   		remaining_to_try--;
> >   	}
> > -	return true;
> > +	return 0;
> >   }
> >   
> > -static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
> > -					     struct dc_state *dc_state,
> > -					     struct dc_link *dc_link,
> > -					     struct dsc_mst_fairness_vars *vars,
> > -					     struct drm_dp_mst_topology_mgr *mgr,
> > -					     int *link_vars_start_index)
> > +static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
> > +					    struct dc_state *dc_state,
> > +					    struct dc_link *dc_link,
> > +					    struct dsc_mst_fairness_vars *vars,
> > +					    struct drm_dp_mst_topology_mgr *mgr,
> > +					    int *link_vars_start_index)
> >   {
> >   	struct dc_stream_state *stream;
> >   	struct dsc_mst_fairness_params params[MAX_PIPES];
> >   	struct amdgpu_dm_connector *aconnector;
> >   	struct drm_dp_mst_topology_state *mst_state = drm_atomic_get_mst_topology_state(state, mgr);
> >   	int count = 0;
> > -	int i, k;
> > +	int i, k, ret;
> >   	bool debugfs_overwrite = false;
> >   
> >   	memset(params, 0, sizeof(params));
> >   
> >   	if (IS_ERR(mst_state))
> > -		return false;
> > +		return PTR_ERR(mst_state);
> >   
> >   	mst_state->pbn_div = dm_mst_get_pbn_divider(dc_link);
> >   #if defined(CONFIG_DRM_AMD_DC_DCN)
> > @@ -933,7 +946,7 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
> >   
> >   	if (count == 0) {
> >   		ASSERT(0);
> > -		return true;
> > +		return 0;
> >   	}
> >   
> >   	/* k is start index of vars for current phy link used by mst hub */
> > @@ -947,13 +960,17 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
> >   		vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
> >   		vars[i + k].dsc_enabled = false;
> >   		vars[i + k].bpp_x16 = 0;
> > -		if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr, params[i].port,
> > -						  vars[i + k].pbn) < 0)
> > -			return false;
> > +		ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr, params[i].port,
> > +						    vars[i + k].pbn);
> > +		if (ret < 0)
> > +			return ret;
> >   	}
> > -	if (!drm_dp_mst_atomic_check(state) && !debugfs_overwrite) {
> > +	ret = drm_dp_mst_atomic_check(state);
> > +	if (ret == 0 && !debugfs_overwrite) {
> >   		set_dsc_configs_from_fairness_vars(params, vars, count, k);
> > -		return true;
> > +		return 0;
> > +	} else if (ret != -ENOSPC) {
> > +		return ret;
> >   	}
> >   
> >   	/* Try max compression */
> > @@ -962,31 +979,36 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
> >   			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.min_kbps);
> >   			vars[i + k].dsc_enabled = true;
> >   			vars[i + k].bpp_x16 = params[i].bw_range.min_target_bpp_x16;
> > -			if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
> > -							  params[i].port, vars[i + k].pbn) < 0)
> > -				return false;
> > +			ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
> > +							    params[i].port, vars[i + k].pbn);
> > +			if (ret < 0)
> > +				return ret;
> >   		} else {
> >   			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
> >   			vars[i + k].dsc_enabled = false;
> >   			vars[i + k].bpp_x16 = 0;
> > -			if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
> > -							  params[i].port, vars[i + k].pbn) < 0)
> > -				return false;
> > +			ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
> > +							    params[i].port, vars[i + k].pbn);
> > +			if (ret < 0)
> > +				return ret;
> >   		}
> >   	}
> > -	if (drm_dp_mst_atomic_check(state))
> > -		return false;
> > +	ret = drm_dp_mst_atomic_check(state);
> > +	if (ret != 0)
> > +		return ret;
> >   
> >   	/* Optimize degree of compression */
> > -	if (!increase_dsc_bpp(state, mst_state, dc_link, params, vars, count, k))
> > -		return false;
> > +	ret = increase_dsc_bpp(state, mst_state, dc_link, params, vars, count, k);
> > +	if (ret < 0)
> > +		return ret;
> >   
> > -	if (!try_disable_dsc(state, dc_link, params, vars, count, k))
> > -		return false;
> > +	ret = try_disable_dsc(state, dc_link, params, vars, count, k);
> > +	if (ret < 0)
> > +		return ret;
> >   
> >   	set_dsc_configs_from_fairness_vars(params, vars, count, k);
> >   
> > -	return true;
> > +	return 0;
> >   }
> >   
> >   static bool is_dsc_need_re_compute(
> > @@ -1087,15 +1109,16 @@ static bool is_dsc_need_re_compute(
> >   	return is_dsc_need_re_compute;
> >   }
> >   
> > -bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> > -				       struct dc_state *dc_state,
> > -				       struct dsc_mst_fairness_vars *vars)
> > +int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> > +				      struct dc_state *dc_state,
> > +				      struct dsc_mst_fairness_vars *vars)
> >   {
> >   	int i, j;
> >   	struct dc_stream_state *stream;
> >   	bool computed_streams[MAX_PIPES];
> >   	struct amdgpu_dm_connector *aconnector;
> >   	int link_vars_start_index = 0;
> > +	int ret = 0;
> >   
> >   	for (i = 0; i < dc_state->stream_count; i++)
> >   		computed_streams[i] = false;
> > @@ -1118,17 +1141,19 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> >   			continue;
> >   
> >   		if (dcn20_remove_stream_from_ctx(stream->ctx->dc, dc_state, stream) != DC_OK)
> > -			return false;
> > +			return -EINVAL;
> >   
> >   		if (!is_dsc_need_re_compute(state, dc_state, stream->link))
> >   			continue;
> >   
> >   		mutex_lock(&aconnector->mst_mgr.lock);
> > -		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
> > -						      &aconnector->mst_mgr,
> > -						      &link_vars_start_index)) {
> > +
> > +		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
> > +						       &aconnector->mst_mgr,
> > +						       &link_vars_start_index);
> > +		if (ret != 0) {
> >   			mutex_unlock(&aconnector->mst_mgr.lock);
> > -			return false;
> > +			return ret;
> >   		}
> >   		mutex_unlock(&aconnector->mst_mgr.lock);
> >   
> > @@ -1143,22 +1168,22 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> >   
> >   		if (stream->timing.flags.DSC == 1)
> >   			if (dc_stream_add_dsc_to_resource(stream->ctx->dc, dc_state, stream) != DC_OK)
> > -				return false;
> > +				return -EINVAL;
> >   	}
> >   
> > -	return true;
> > +	return ret;
> >   }
> >   
> > -static bool
> > -	pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> > -					      struct dc_state *dc_state,
> > -					      struct dsc_mst_fairness_vars *vars)
> > +static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> > +						 struct dc_state *dc_state,
> > +						 struct dsc_mst_fairness_vars *vars)
> >   {
> >   	int i, j;
> >   	struct dc_stream_state *stream;
> >   	bool computed_streams[MAX_PIPES];
> >   	struct amdgpu_dm_connector *aconnector;
> >   	int link_vars_start_index = 0;
> > +	int ret = 0;
> >   
> >   	for (i = 0; i < dc_state->stream_count; i++)
> >   		computed_streams[i] = false;
> > @@ -1184,11 +1209,12 @@ static bool
> >   			continue;
> >   
> >   		mutex_lock(&aconnector->mst_mgr.lock);
> > -		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
> > -						      &aconnector->mst_mgr,
> > -						      &link_vars_start_index)) {
> > +		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
> > +						       &aconnector->mst_mgr,
> > +						       &link_vars_start_index);
> > +		if (ret != 0) {
> >   			mutex_unlock(&aconnector->mst_mgr.lock);
> > -			return false;
> > +			return ret;
> >   		}
> >   		mutex_unlock(&aconnector->mst_mgr.lock);
> >   
> > @@ -1198,7 +1224,7 @@ static bool
> >   		}
> >   	}
> >   
> > -	return true;
> > +	return ret;
> >   }
> >   
> >   static int find_crtc_index_in_state_by_stream(struct drm_atomic_state *state,
> > @@ -1253,9 +1279,9 @@ static bool is_dsc_precompute_needed(struct drm_atomic_state *state)
> >   	return ret;
> >   }
> >   
> > -bool pre_validate_dsc(struct drm_atomic_state *state,
> > -		      struct dm_atomic_state **dm_state_ptr,
> > -		      struct dsc_mst_fairness_vars *vars)
> > +int pre_validate_dsc(struct drm_atomic_state *state,
> > +		     struct dm_atomic_state **dm_state_ptr,
> > +		     struct dsc_mst_fairness_vars *vars)
> >   {
> >   	int i;
> >   	struct dm_atomic_state *dm_state;
> > @@ -1264,11 +1290,12 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
> >   
> >   	if (!is_dsc_precompute_needed(state)) {
> >   		DRM_INFO_ONCE("DSC precompute is not needed.\n");
> > -		return true;
> > +		return 0;
> >   	}
> > -	if (dm_atomic_get_state(state, dm_state_ptr)) {
> > +	ret = dm_atomic_get_state(state, dm_state_ptr);
> > +	if (ret != 0) {
> >   		DRM_INFO_ONCE("dm_atomic_get_state() failed\n");
> > -		return false;
> > +		return ret;
> >   	}
> >   	dm_state = *dm_state_ptr;
> >   
> > @@ -1280,7 +1307,7 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
> >   
> >   	local_dc_state = kmemdup(dm_state->context, sizeof(struct dc_state), GFP_KERNEL);
> >   	if (!local_dc_state)
> > -		return false;
> > +		return -ENOMEM;
> >   
> >   	for (i = 0; i < local_dc_state->stream_count; i++) {
> >   		struct dc_stream_state *stream = dm_state->context->streams[i];
> > @@ -1316,9 +1343,9 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
> >   	if (ret != 0)
> >   		goto clean_exit;
> >   
> > -	if (!pre_compute_mst_dsc_configs_for_state(state, local_dc_state, vars)) {
> > +	ret = pre_compute_mst_dsc_configs_for_state(state, local_dc_state, vars);
> > +	if (ret != 0) {
> >   		DRM_INFO_ONCE("pre_compute_mst_dsc_configs_for_state() failed\n");
> > -		ret = -EINVAL;
> >   		goto clean_exit;
> >   	}
> >   
> > @@ -1349,7 +1376,7 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
> >   
> >   	kfree(local_dc_state);
> >   
> > -	return (ret == 0);
> > +	return ret;
> >   }
> >   
> >   static unsigned int kbps_from_pbn(unsigned int pbn)
> > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> > index b92a7c5671aa..97fd70df531b 100644
> > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> > @@ -53,15 +53,15 @@ struct dsc_mst_fairness_vars {
> >   	struct amdgpu_dm_connector *aconnector;
> >   };
> >   
> > -bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> > -				       struct dc_state *dc_state,
> > -				       struct dsc_mst_fairness_vars *vars);
> > +int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> > +				      struct dc_state *dc_state,
> > +				      struct dsc_mst_fairness_vars *vars);
> >   
> >   bool needs_dsc_aux_workaround(struct dc_link *link);
> >   
> > -bool pre_validate_dsc(struct drm_atomic_state *state,
> > -		      struct dm_atomic_state **dm_state_ptr,
> > -		      struct dsc_mst_fairness_vars *vars);
> > +int pre_validate_dsc(struct drm_atomic_state *state,
> > +		     struct dm_atomic_state **dm_state_ptr,
> > +		     struct dsc_mst_fairness_vars *vars);
> >   
> >   enum dc_status dm_dp_mst_is_port_support_mode(
> >   	struct amdgpu_dm_connector *aconnector,
> 

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

