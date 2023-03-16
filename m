Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052EB6BDA95
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 22:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjCPVJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 17:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCPVJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 17:09:05 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77566C6B0
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 14:09:00 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id h8so12855787ede.8
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 14:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679000939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mo21bXSqJEEs1fH3Hhlq/Ji61Lv/UMBWopZqqi3k7nY=;
        b=OjqSSm3Gq0V9630rIW0EpnCK2NRWkdnIH8cTIvkeVFWRyFNMkf6GYPmHFvgXgitcf6
         fkwPScAJkj8W3oW2tBZucDDPpFvZOovDRkonmKd53rXW6F4kNX08XNnRF4uSQxySnvSU
         FfkFhjGbx/42XFt5O58b07ytwDArWAq/JE5kWpVbsA1HZEye0/J+6O6zFnuYawba14YN
         fELcQVMvYlljxNP7xGWmwg9VHJe3g7ZzkvbnFc+0YxTfG7Ls/wHfg+Um2mD7oj+KdKbm
         2SiCAWrr+9PnLR7Q04vJ1frK+c9GCrwivMiaop2oexViQlB8e+X8xZbVepJEeuAryvg/
         dnbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679000939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mo21bXSqJEEs1fH3Hhlq/Ji61Lv/UMBWopZqqi3k7nY=;
        b=LfQAqxeJK1knhyxOR0m7cjDs1B7BzvzPpaZrWPvgJJHoKvANTymVf6IFBTeKhxAiw/
         GOsMcQt/EnCLiMmkbpaTpQK95ulJUqbZGVXS0MrHUiURugoNtwavNHlfKvgfxG1ksEhD
         dtaQSJn/fopN3b3jhkfVGdQ9Y/SlKhlMPjO1+7Q0jV546wZAFcK5Rq5C1wFhx5+lEGtf
         R6ZVGmzre7KOF5Whu0kGWhAprNxRmP56kf6BSeMOUH8sRU5BY80OE9bTUEu0WvQMASWZ
         pZygFFcg1p3X4obSlboCkdT10OeWjbsFgQcc9K7E+RR8huM9C+bH/TAsFJjQDznqCIUd
         nB7g==
X-Gm-Message-State: AO0yUKXWjt0lwR6NP0Mx6S63qHZ5ZXVXg7wB3Z8D4fsF4klruNfS9NQh
        nOFNNLFrSyRcMWUwnBw0HYw=
X-Google-Smtp-Source: AK7set99S8EXCKqADK4tLtGJAPItn3DNysoXBxnqgVyBlKq9lRzqXL2U6xdgc8bHtmE2J1PaSn1KTQ==
X-Received: by 2002:a17:907:36e:b0:8b1:32b0:2a24 with SMTP id rs14-20020a170907036e00b008b132b02a24mr11709930ejb.47.1679000939206;
        Thu, 16 Mar 2023 14:08:59 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id e6-20020a170906748600b008bfe95c46c3sm83231ejl.220.2023.03.16.14.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 14:08:58 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 208A7BE2DE0; Thu, 16 Mar 2023 22:08:57 +0100 (CET)
Date:   Thu, 16 Mar 2023 22:08:57 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     gregkh@linuxfoundation.org
Cc:     lyude@redhat.com, alexander.deucher@amd.com,
        harry.wentland@amd.com, odyx@debian.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu/display/mst: Fix
 mst_state->pbn_div and slot count" failed to apply to 6.1-stable tree
Message-ID: <ZBOFaX9VNbedlGSj@eldamar.lan>
References: <167844819310084@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167844819310084@kroah.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Mar 10, 2023 at 12:36:33PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> To reproduce the conflict and resubmit, you may use the following commands:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
> git checkout FETCH_HEAD
> git cherry-pick -x c689e1e362ea29d10fbd9a5e94b17be991d0e231
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167844819310084@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..
> 
> Possible dependencies:
> 
> c689e1e362ea ("drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count assignments")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From c689e1e362ea29d10fbd9a5e94b17be991d0e231 Mon Sep 17 00:00:00 2001
> From: Lyude Paul <lyude@redhat.com>
> Date: Wed, 23 Nov 2022 14:50:16 -0500
> Subject: [PATCH] drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count
>  assignments
> 
> Looks like I made a pretty big mistake here without noticing: it seems when
> I moved the assignments of mst_state->pbn_div I completely missed the fact
> that the reason for us calling drm_dp_mst_update_slots() earlier was to
> account for the fact that we need to call this function using info from the
> root MST connector, instead of just trying to do this from each MST
> encoder's atomic check function. Otherwise, we end up filling out all of
> DC's link information with zeroes.
> 
> So, let's restore that and hopefully fix this DSC regression.
> 
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Signed-off-by: Harry Wentland <harry.wentland@amd.com>
> Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
> Cc: stable@vger.kernel.org # 6.1
> Reviewed-by: Harry Wentland <harry.wentland@amd.com>
> Tested-by: Didier Raboud <odyx@debian.org>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 39513a6d2244..2122c2be269b 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -9683,6 +9683,8 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
>  	struct drm_connector_state *old_con_state, *new_con_state;
>  	struct drm_crtc *crtc;
>  	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
> +	struct drm_dp_mst_topology_mgr *mgr;
> +	struct drm_dp_mst_topology_state *mst_state;
>  	struct drm_plane *plane;
>  	struct drm_plane_state *old_plane_state, *new_plane_state;
>  	enum dc_status status;
> @@ -9938,6 +9940,28 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
>  		lock_and_validation_needed = true;
>  	}
>  
> +#if defined(CONFIG_DRM_AMD_DC_DCN)
> +	/* set the slot info for each mst_state based on the link encoding format */
> +	for_each_new_mst_mgr_in_state(state, mgr, mst_state, i) {
> +		struct amdgpu_dm_connector *aconnector;
> +		struct drm_connector *connector;
> +		struct drm_connector_list_iter iter;
> +		u8 link_coding_cap;
> +
> +		drm_connector_list_iter_begin(dev, &iter);
> +		drm_for_each_connector_iter(connector, &iter) {
> +			if (connector->index == mst_state->mgr->conn_base_id) {
> +				aconnector = to_amdgpu_dm_connector(connector);
> +				link_coding_cap = dc_link_dp_mst_decide_link_encoding_format(aconnector->dc_link);
> +				drm_dp_mst_update_slots(mst_state, link_coding_cap);
> +
> +				break;
> +			}
> +		}
> +		drm_connector_list_iter_end(&iter);
> +	}
> +#endif
> +
>  	/**
>  	 * Streams and planes are reset when there are changes that affect
>  	 * bandwidth. Anything that affects bandwidth needs to go through
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> index 5fa9bab95038..e8d14ab0953a 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> @@ -927,11 +927,6 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
>  	if (IS_ERR(mst_state))
>  		return PTR_ERR(mst_state);
>  
> -	mst_state->pbn_div = dm_mst_get_pbn_divider(dc_link);
> -#if defined(CONFIG_DRM_AMD_DC_DCN)
> -	drm_dp_mst_update_slots(mst_state, dc_link_dp_mst_decide_link_encoding_format(dc_link));
> -#endif
> -
>  	/* Set up params */
>  	for (i = 0; i < dc_state->stream_count; i++) {
>  		struct dc_dsc_policy dsc_policy = {0};

FWIW, I'm not sure what happened here exactly. The commit was applied
for the first time in 1119e1f9636b76aef14068c7fd0b4d55132b86b8 in
6.2-rc6, backported to 6.1.9. Then again as
c689e1e362ea29d10fbd9a5e94b17be991d0e231 in 6.3-rc1.

Similar for the related commits, which was one of the major blocking
regressions for the 6.1 series.

Just wanted to mention here as noiced the failed apply mail.

Regards,
Salvatore
