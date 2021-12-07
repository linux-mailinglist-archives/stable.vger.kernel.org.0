Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9BF46C82A
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 00:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238402AbhLGX1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 18:27:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59228 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238289AbhLGX1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 18:27:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638919433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EZE/1T3FX1trOA5XqIV9My2rwuFl3VXDtBCeYVaL8qA=;
        b=CoYyUDZ+CBwiu1P3zf+dkvE3fZO2wPRlFqHpdo6fxqcA6z3ZNZLyjKp7zi8OoN1zoED7BO
        y9/5LX7m1DCvNLoikRQ2Kf6S4NhlbJXUA/0Shcc4HShT9tqcnALOzDdEHR1KjsJbWTAq/Z
        08xM9VaD6fuGdh2JdxpZuutd8d/9f+0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-_aV3mO2rMZanJVje3aXKTQ-1; Tue, 07 Dec 2021 18:23:52 -0500
X-MC-Unique: _aV3mO2rMZanJVje3aXKTQ-1
Received: by mail-qt1-f197.google.com with SMTP id h20-20020ac85e14000000b002b2e9555bb1so1178294qtx.3
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 15:23:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=EZE/1T3FX1trOA5XqIV9My2rwuFl3VXDtBCeYVaL8qA=;
        b=uTFGbzQFvcD4dko06CJ+Nu07na7vDa/cb5iuC2J0UOW81Fw44+1IL95jIb0zJ8PnQ3
         T1hm02HS9YC+0KEGVTUufP9FhRUY1o6ZYxpVaKiKsHb16AkI1kPUOJOiAbDK90oizud+
         aHeNCZUFQwOFB7jD90NC+R5Ojd5T8RQmnhG4tXW45Xa7LGevjRgmrSopru8qjF2b1hzG
         xdN2KUREr+QVSjaaPEe6h3R1eZPPonD40YUIfU+IpRWxNkuMu5XafAod0aEhj55b8Ei1
         4NWrw99VSYZnlJfUQB3SvF4S0aIIflgjceqa3ORqsTxbOwubK8ua7aoSydHADrwWn/vc
         6vTw==
X-Gm-Message-State: AOAM533rpIDKtucIsPk8zLWtUoMROgciwPoJ3OOQEHxnpips7neP+NKX
        G+haf9YXnAg0zGbJb8aDAR2CfjYwZWjoBYwAeeE0LAqvXwZqHanCgk/8rNBKa1PCCZGV3ib3h/9
        ldvOZRu/+1JpcQDcF
X-Received: by 2002:ac8:4e4b:: with SMTP id e11mr3261709qtw.503.1638919431555;
        Tue, 07 Dec 2021 15:23:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwRRakzhqjCdEARUr1B6xpTA55jXtNMwyO8zS0QIUSkSC50FRLaI2l6vvsvEOm2CbxiGQwxAQ==
X-Received: by 2002:ac8:4e4b:: with SMTP id e11mr3261696qtw.503.1638919431374;
        Tue, 07 Dec 2021 15:23:51 -0800 (PST)
Received: from [192.168.8.138] (pool-96-230-249-157.bstnma.fios.verizon.net. [96.230.249.157])
        by smtp.gmail.com with ESMTPSA id t9sm683560qkp.110.2021.12.07.15.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 15:23:50 -0800 (PST)
Message-ID: <390babb7a9b7e27a9edbc909a4ea5bf6bf256da3.camel@redhat.com>
Subject: Re: FAILED: patch "[PATCH] drm/i915: Add support for panels with
 VESA backlights with" failed to apply to 5.15-stable tree
From:   Lyude Paul <lyude@redhat.com>
To:     gregkh@linuxfoundation.org, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, ville.syrjala@linux.intel.com
Date:   Tue, 07 Dec 2021 18:23:49 -0500
In-Reply-To: <16387074612176@kroah.com>
References: <16387074612176@kroah.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Huh, well this is strange. I'm assuming that you send these emails out as part
of an automated script that tries applying patches and fails, but I think
something may have gone wrong here as I just tried cherry-picking
04f0d6cc62cc1eaf9242c081520c024a17ba86a3 onto v5.15.6, and it applied without
needing any manual conflict resolution. Any idea what might be going on?

On Sun, 2021-12-05 at 13:31 +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 61e29a0956bdb09eac8aca7d9add9f902baff08b Mon Sep 17 00:00:00 2001
> From: Lyude Paul <lyude@redhat.com>
> Date: Fri, 5 Nov 2021 14:33:38 -0400
> Subject: [PATCH] drm/i915: Add support for panels with VESA backlights with
>  PWM enable/disable
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> This simply adds proper support for panel backlights that can be controlled
> via VESA's backlight control protocol, but which also require that we
> enable and disable the backlight via PWM instead of via the DPCD interface.
> We also enable this by default, in order to fix some people's backlights
> that were broken by not having this enabled.
> 
> For reference, backlights that require this and use VESA's backlight
> interface tend to be laptops with hybrid GPUs, but this very well may
> change in the future.
> 
> v4:
> * Make sure that we call intel_backlight_level_to_pwm() in
>   intel_dp_aux_vesa_enable_backlight() - vsyrjala
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Link: https://gitlab.freedesktop.org/drm/intel/-/issues/3680
> Fixes: fe7d52bccab6 ("drm/i915/dp: Don't use DPCD backlights that need PWM
> enable/disable")
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.12+
> Link:
> https://patchwork.freedesktop.org/patch/msgid/20211105183342.130810-2-lyude@redhat.com
> (cherry picked from commit 04f0d6cc62cc1eaf9242c081520c024a17ba86a3)
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> index 569d17b4d00f..f05b71c01b8e 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> @@ -293,6 +293,13 @@ intel_dp_aux_vesa_enable_backlight(const struct
> intel_crtc_state *crtc_state,
>         struct intel_panel *panel = &connector->panel;
>         struct intel_dp *intel_dp = enc_to_intel_dp(connector->encoder);
>  
> +       if (!panel->backlight.edp.vesa.info.aux_enable) {
> +               u32 pwm_level = intel_backlight_invert_pwm_level(connector,
> +                                                                panel-
> >backlight.pwm_level_max);
> +
> +               panel->backlight.pwm_funcs->enable(crtc_state, conn_state,
> pwm_level);
> +       }
> +
>         drm_edp_backlight_enable(&intel_dp->aux, &panel-
> >backlight.edp.vesa.info, level);
>  }
>  
> @@ -304,6 +311,10 @@ static void intel_dp_aux_vesa_disable_backlight(const
> struct drm_connector_state
>         struct intel_dp *intel_dp = enc_to_intel_dp(connector->encoder);
>  
>         drm_edp_backlight_disable(&intel_dp->aux, &panel-
> >backlight.edp.vesa.info);
> +
> +       if (!panel->backlight.edp.vesa.info.aux_enable)
> +               panel->backlight.pwm_funcs->disable(old_conn_state,
> +                                                  
> intel_backlight_invert_pwm_level(connector, 0));
>  }
>  
>  static int intel_dp_aux_vesa_setup_backlight(struct intel_connector
> *connector, enum pipe pipe)
> @@ -321,6 +332,15 @@ static int intel_dp_aux_vesa_setup_backlight(struct
> intel_connector *connector,
>         if (ret < 0)
>                 return ret;
>  
> +       if (!panel->backlight.edp.vesa.info.aux_enable) {
> +               ret = panel->backlight.pwm_funcs->setup(connector, pipe);
> +               if (ret < 0) {
> +                       drm_err(&i915->drm,
> +                               "Failed to setup PWM backlight controls for
> eDP backlight: %d\n",
> +                               ret);
> +                       return ret;
> +               }
> +       }
>         panel->backlight.max = panel->backlight.edp.vesa.info.max;
>         panel->backlight.min = 0;
>         if (current_mode == DP_EDP_BACKLIGHT_CONTROL_MODE_DPCD) {
> @@ -340,12 +360,7 @@ intel_dp_aux_supports_vesa_backlight(struct
> intel_connector *connector)
>         struct intel_dp *intel_dp = intel_attached_dp(connector);
>         struct drm_i915_private *i915 = dp_to_i915(intel_dp);
>  
> -       /* TODO: We currently only support AUX only backlight
> configurations, not backlights which
> -        * require a mix of PWM and AUX controls to work. In the mean time,
> these machines typically
> -        * work just fine using normal PWM controls anyway.
> -        */
> -       if ((intel_dp->edp_dpcd[1] & DP_EDP_BACKLIGHT_AUX_ENABLE_CAP) &&
> -           drm_edp_backlight_supported(intel_dp->edp_dpcd)) {
> +       if (drm_edp_backlight_supported(intel_dp->edp_dpcd)) {
>                 drm_dbg_kms(&i915->drm, "AUX Backlight Control
> Supported!\n");
>                 return true;
>         }
> 

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

