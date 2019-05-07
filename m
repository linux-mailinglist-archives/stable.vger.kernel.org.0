Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEBEE16C15
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 22:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfEGUSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 16:18:22 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38966 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfEGUSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 16:18:22 -0400
Received: by mail-qk1-f194.google.com with SMTP id z128so8382505qkb.6
        for <stable@vger.kernel.org>; Tue, 07 May 2019 13:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E+94DeG/Cjai3KQu1dmx6FwycC/IR8RFjQ6FJQvgySI=;
        b=SRtwe796Ln1mTAv6ShT7et5/HBB6sOe4yG9tHm7VTvE+o58ZESHA8b8IOntpBfrcc8
         1u7MIisiP/wBui5dpMwAYrQVz09DCYyzBhagjwiynOiL4k5GYo9QPvRAdI46mryDFcjM
         +6U8+v7Cc1DJOhsUvN2s6wAKqQBcnCeCU+jdWN1CiZ9cYDZD///tjCQUBK6Rs23aB+VF
         CsdlSMCAn+T/JfNUd581Ix0iyZAXDkAXxSYa+7NPZzvAZA1rU9+rAjE9IRfAKb/43ARy
         6H7+GYPjhDUPF0tShoFBE6X1aMB0Q/vCGD0Au6dOm4idRG78J2a2KDYTeRaeVxfA0Bur
         hwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E+94DeG/Cjai3KQu1dmx6FwycC/IR8RFjQ6FJQvgySI=;
        b=d8WAyTUKNhnS6l/V/F0LF22oLvzwy7Ud+z5JxcaAKl8kUiAkERytg7Kj6kMMyPixG+
         n1IhT+0hRlqqVRod7CJiM0kIjVijR95+PI+ETOb9ptDk965gTpDbWrS4DgGIIFc31oF/
         NpHGjHmmUNtHlGnX7GEwvqa0dUI8zevt1wLCEi+TZJ63NA/CV1m7fSWGzEHCwsf8LJWJ
         d2wyUqtRcrV3bz8T1ij/N8wjDB30vSJ0zup0+xoIU6pnPA6n1w4X1X5lfXKJiom29LeX
         f5UE/vjJbcTPqvUPZZ1u9C8Ehh6EtCvuj0Ncaqhwn/P3fy9GyCFgUDolACKiUruKeT0M
         ittQ==
X-Gm-Message-State: APjAAAX2QFK3KpciPweY/GiYohRkbBN/6V6WOTgg8+N1KaYab8Zm5bGw
        PvSDtaUa7q3Uw26QsikhD7Y3qw==
X-Google-Smtp-Source: APXvYqx9XMRCil7J0ZbdY48pPd3nYGBEXSKh037S2lHSoBcl6eE/1OgpwKKtmnr0KppO1wFSMqLQmA==
X-Received: by 2002:a37:9cd5:: with SMTP id f204mr12747236qke.75.1557260301063;
        Tue, 07 May 2019 13:18:21 -0700 (PDT)
Received: from localhost ([2620:0:1013:11:89c6:2139:5435:371d])
        by smtp.gmail.com with ESMTPSA id 3sm2248680qtm.37.2019.05.07.13.18.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 13:18:20 -0700 (PDT)
Date:   Tue, 7 May 2019 16:18:19 -0400
From:   Sean Paul <sean@poorly.run>
To:     Helen Koike <helen.koike@collabora.com>
Cc:     dri-devel@lists.freedesktop.org, nicholas.kazlauskas@amd.com,
        andrey.grodzovsky@amd.com, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        boris.brezillon@collabora.com, David Airlie <airlied@linux.ie>,
        Sean Paul <seanpaul@google.com>, kernel@collabora.com,
        harry.wentland@amd.com,
        =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@google.com>,
        stable@vger.kernel.org, Sean Paul <sean@poorly.run>,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        eric@anholt.net, robdclark@gmail.com,
        amd-gfx@lists.freedesktop.org,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        freedreno@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH v3 5/5] drm: don't block fb changes for async plane
 updates
Message-ID: <20190507201819.GI17077@art_vandelay>
References: <20190314002027.7833-1-helen.koike@collabora.com>
 <20190314002027.7833-6-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190314002027.7833-6-helen.koike@collabora.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 13, 2019 at 09:20:26PM -0300, Helen Koike wrote:
> In the case of a normal sync update, the preparation of framebuffers (be
> it calling drm_atomic_helper_prepare_planes() or doing setups with
> drm_framebuffer_get()) are performed in the new_state and the respective
> cleanups are performed in the old_state.
> 
> In the case of async updates, the preparation is also done in the
> new_state but the cleanups are done in the new_state (because updates
> are performed in place, i.e. in the current state).
> 
> The current code blocks async udpates when the fb is changed, turning
> async updates into sync updates, slowing down cursor updates and
> introducing regressions in igt tests with errors of type:
> 
> "CRITICAL: completed 97 cursor updated in a period of 30 flips, we
> expect to complete approximately 15360 updates, with the threshold set
> at 7680"
> 
> Fb changes in async updates were prevented to avoid the following scenario:
> 
> - Async update, oldfb = NULL, newfb = fb1, prepare fb1, cleanup fb1
> - Async update, oldfb = fb1, newfb = fb2, prepare fb2, cleanup fb2
> - Non-async commit, oldfb = fb2, newfb = fb1, prepare fb1, cleanup fb2 (wrong)
> Where we have a single call to prepare fb2 but double cleanup call to fb2.
> 
> To solve the above problems, instead of blocking async fb changes, we
> place the old framebuffer in the new_state object, so when the code
> performs cleanups in the new_state it will cleanup the old_fb and we
> will have the following scenario instead:
> 
> - Async update, oldfb = NULL, newfb = fb1, prepare fb1, no cleanup
> - Async update, oldfb = fb1, newfb = fb2, prepare fb2, cleanup fb1
> - Non-async commit, oldfb = fb2, newfb = fb1, prepare fb1, cleanup fb2
> 
> Where calls to prepare/cleanup are balanced.
> 
> Cc: <stable@vger.kernel.org> # v4.14+

I'm not convinced this should be cc: stable, seems more in the improvement
category than a bug fix.

> Fixes: 25dc194b34dd ("drm: Block fb changes for async plane updates")
> Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> 
> ---
> Hello,
> 
> I added a TODO in drm_atomic_helper_async_commit() regarding doing a
> full state swap(), Boris and Nicholas, let me know if this is ok and if
> I can keep your Reviewed-by tags)
> 
> As mentioned in the cover letter, I tested in almost all platforms with
> igt plane_cursor_legacy and kms_cursor_legacy and I didn't see any
> regressions. But I couldn't test on MSM and AMD because I don't have
> the hardware I would appreciate if anyone could help me testing those.
> 
> Thanks!
> Helen
> 
> Changes in v3:
> - Add Reviewed-by tags
> - Add TODO in drm_atomic_helper_async_commit()
> 
> Changes in v2:
> - Change the order of the patch in the series, add this as the last one.
> - Add documentation
> - s/ballanced/balanced
> 
>  drivers/gpu/drm/drm_atomic_helper.c      | 22 ++++++++++++----------
>  include/drm/drm_modeset_helper_vtables.h |  5 +++++
>  2 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> index 2453678d1186..de5812c362b5 100644
> --- a/drivers/gpu/drm/drm_atomic_helper.c
> +++ b/drivers/gpu/drm/drm_atomic_helper.c
> @@ -1608,15 +1608,6 @@ int drm_atomic_helper_async_check(struct drm_device *dev,
>  	    old_plane_state->crtc != new_plane_state->crtc)
>  		return -EINVAL;
>  
> -	/*
> -	 * FIXME: Since prepare_fb and cleanup_fb are always called on
> -	 * the new_plane_state for async updates we need to block framebuffer
> -	 * changes. This prevents use of a fb that's been cleaned up and
> -	 * double cleanups from occuring.
> -	 */
> -	if (old_plane_state->fb != new_plane_state->fb)
> -		return -EINVAL;
> -
>  	funcs = plane->helper_private;
>  	if (!funcs->atomic_async_update)
>  		return -EINVAL;
> @@ -1647,6 +1638,8 @@ EXPORT_SYMBOL(drm_atomic_helper_async_check);
>   * drm_atomic_async_check() succeeds. Async commits are not supposed to swap
>   * the states like normal sync commits, but just do in-place changes on the
>   * current state.
> + *
> + * TODO: Implement full swap instead of doing in-place changes.
>   */
>  void drm_atomic_helper_async_commit(struct drm_device *dev,
>  				    struct drm_atomic_state *state)
> @@ -1657,6 +1650,9 @@ void drm_atomic_helper_async_commit(struct drm_device *dev,
>  	int i;
>  
>  	for_each_new_plane_in_state(state, plane, plane_state, i) {
> +		struct drm_framebuffer *new_fb = plane_state->fb;
> +		struct drm_framebuffer *old_fb = plane->state->fb;
> +
>  		funcs = plane->helper_private;
>  		funcs->atomic_async_update(plane, plane_state);
>  
> @@ -1665,11 +1661,17 @@ void drm_atomic_helper_async_commit(struct drm_device *dev,
>  		 * plane->state in-place, make sure at least common
>  		 * properties have been properly updated.
>  		 */
> -		WARN_ON_ONCE(plane->state->fb != plane_state->fb);
> +		WARN_ON_ONCE(plane->state->fb != new_fb);
>  		WARN_ON_ONCE(plane->state->crtc_x != plane_state->crtc_x);
>  		WARN_ON_ONCE(plane->state->crtc_y != plane_state->crtc_y);
>  		WARN_ON_ONCE(plane->state->src_x != plane_state->src_x);
>  		WARN_ON_ONCE(plane->state->src_y != plane_state->src_y);
> +
> +		/*
> +		 * Make sure the FBs have been swapped so that cleanups in the
> +		 * new_state performs a cleanup in the old FB.
> +		 */
> +		WARN_ON_ONCE(plane_state->fb != old_fb);
>  	}
>  }
>  EXPORT_SYMBOL(drm_atomic_helper_async_commit);
> diff --git a/include/drm/drm_modeset_helper_vtables.h b/include/drm/drm_modeset_helper_vtables.h
> index cfb7be40bed7..ce582e8e8f2f 100644
> --- a/include/drm/drm_modeset_helper_vtables.h
> +++ b/include/drm/drm_modeset_helper_vtables.h
> @@ -1174,6 +1174,11 @@ struct drm_plane_helper_funcs {
>  	 * current one with the new plane configurations in the new
>  	 * plane_state.
>  	 *
> +	 * Drivers should also swap the framebuffers between plane state

Perhaps add "current" before plane state and then after add "(&drm_plane.state)"
so it's more clear what you're referring to here?

> +	 * and new_state. This is required because prepare and cleanup calls
> +	 * are performed on the new_state object, then to cleanup the old
> +	 * framebuffer, it needs to be placed inside the new_state object.

I'd change this bit to:

        * This is required since cleanup for async commits is performed on
        * the new state, rather than old state like for traditional commits.
        * Since we want to give up the reference on the current (old) fb instead
        * of our brand new one, swap them in the driver during the async commit.

> +	 *
>  	 * FIXME:
>  	 *  - It only works for single plane updates
>  	 *  - Async Pageflips are not supported yet
> -- 
> 2.20.1
> 

-- 
Sean Paul, Software Engineer, Google / Chromium OS
