Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A092EF7D3
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 20:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbhAHTDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 14:03:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728420AbhAHTDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 14:03:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610132515;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1sD1eZv7JZRwttnalOB1m2cuEcGwMY83yW6AhUvcDJM=;
        b=i3au9DJ3AwM7J8SirbQsT6OacPlQSd/pn8Fd+VvjHxxAdkL5UaJP0/qzTUUrXZC3axvTA1
        8MMwfppHAvpuDm0CbNPqVknT49jyrTidS7CnsQ6J+Z1obFLiUQyzUV5TdRsclULYeTtaaA
        FRuj41VRaBkSGsLyYYWcxkqk+RmxA4U=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-_0nBLW-nMzO7mapR5NrSMg-1; Fri, 08 Jan 2021 14:01:53 -0500
X-MC-Unique: _0nBLW-nMzO7mapR5NrSMg-1
Received: by mail-qv1-f69.google.com with SMTP id eb4so8898778qvb.21
        for <stable@vger.kernel.org>; Fri, 08 Jan 2021 11:01:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=1sD1eZv7JZRwttnalOB1m2cuEcGwMY83yW6AhUvcDJM=;
        b=K5pj8b6+1VGwQZ9DZ/SRgjZmK7dt5rORFN1jkFgxaNYB8fRv//Tpb3DuOw0lv2+Sg0
         yjGXuJXS1i4UNHnt9jm7HT3HpQEtT3qfN6zWnYQuU2U0LAP+mKI+PlxJ0Ez3Gq9JGYeX
         ByKZa8n+kwMFymlsry3/FykqcKTPvwBWFbOgpv4wYwTx5Ghxjn7t0R/YtviiJOYwnxDu
         Z8Zd4u06guVW+Th/wZkcJz0H+OFDz/m0plVFP3TsDJd2aslbm7t7wg08MbZssNCJPTUk
         3cFQ9l7v6JZwwO20XxdEQ3tiaLZXnTtYEJnFCLEZ05SOrZ6BLP8Qi++6RAB1zHcYpgu6
         5Prw==
X-Gm-Message-State: AOAM531TEtbIi76sJU/D4u0n8zSMztPpvAZ1UVbqAupMasPwUBweKWIX
        RWEZoqWIAZKSh2kJmRkg3ykEW08mnCONRP0/TL8CsRZ0Y9OI0BB6YrmXGgs6xv81iodCPAZEpWk
        CysZSP8fQ3nmA2Sft
X-Received: by 2002:a05:620a:a9c:: with SMTP id v28mr5223841qkg.107.1610132513557;
        Fri, 08 Jan 2021 11:01:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwg4dzi6rxVQQjlvpYTsPGfXkAIhakChTQLT1zzbDOwvPss0Oyv4/Xoh8KgLILVOJz3gst3EA==
X-Received: by 2002:a05:620a:a9c:: with SMTP id v28mr5223797qkg.107.1610132513141;
        Fri, 08 Jan 2021 11:01:53 -0800 (PST)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id 9sm5087072qtr.64.2021.01.08.11.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 11:01:52 -0800 (PST)
Message-ID: <e5fd2290fae25fc1167ea6fe91e7060840d0db47.camel@redhat.com>
Subject: Re: [PATCH] drm/i915/backlight: fix CPU mode backlight takeover on
 LPT
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     Jani Nikula <jani.nikula@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org
Date:   Fri, 08 Jan 2021 14:01:51 -0500
In-Reply-To: <20210108152841.6944-1-jani.nikula@intel.com>
References: <20210108152841.6944-1-jani.nikula@intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Lyude Paul <lyude@redhat.com>

Let me know when you've pushed this upstream and I'll go ahead and send out a
rebased version of my backlight series.

On Fri, 2021-01-08 at 17:28 +0200, Jani Nikula wrote:
> The pch_get_backlight(), lpt_get_backlight(), and lpt_set_backlight()
> functions operate directly on the hardware registers. If inverting the
> value is needed, using intel_panel_compute_brightness(), it should only
> be done in the interface between hardware registers and
> panel->backlight.level.
> 
> The CPU mode takeover code added in commit 5b1ec9ac7ab5
> ("drm/i915/backlight: Fix backlight takeover on LPT, v3.") reads the
> hardware register and converts to panel->backlight.level correctly,
> however the value written back should remain in the hardware register
> "domain".
> 
> This hasn't been an issue, because GM45 machines are the only known
> users of i915.invert_brightness and the brightness invert quirk, and
> without one of them no conversion is made. It's likely nobody's ever hit
> the problem.
> 
> Fixes: 5b1ec9ac7ab5 ("drm/i915/backlight: Fix backlight takeover on LPT, v3.")
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: <stable@vger.kernel.org> # v5.1+
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_panel.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_panel.c
> b/drivers/gpu/drm/i915/display/intel_panel.c
> index 67f81ae995c4..7a4239d1c241 100644
> --- a/drivers/gpu/drm/i915/display/intel_panel.c
> +++ b/drivers/gpu/drm/i915/display/intel_panel.c
> @@ -1649,16 +1649,13 @@ static int lpt_setup_backlight(struct intel_connector
> *connector, enum pipe unus
>                 val = pch_get_backlight(connector);
>         else
>                 val = lpt_get_backlight(connector);
> -       val = intel_panel_compute_brightness(connector, val);
> -       panel->backlight.level = clamp(val, panel->backlight.min,
> -                                      panel->backlight.max);
>  
>         if (cpu_mode) {
>                 drm_dbg_kms(&dev_priv->drm,
>                             "CPU backlight register was enabled, switching to
> PCH override\n");
>  
>                 /* Write converted CPU PWM value to PCH override register */
> -               lpt_set_backlight(connector->base.state, panel-
> >backlight.level);
> +               lpt_set_backlight(connector->base.state, val);
>                 intel_de_write(dev_priv, BLC_PWM_PCH_CTL1,
>                                pch_ctl1 | BLM_PCH_OVERRIDE_ENABLE);
>  
> @@ -1666,6 +1663,10 @@ static int lpt_setup_backlight(struct intel_connector
> *connector, enum pipe unus
>                                cpu_ctl2 & ~BLM_PWM_ENABLE);
>         }
>  
> +       val = intel_panel_compute_brightness(connector, val);
> +       panel->backlight.level = clamp(val, panel->backlight.min,
> +                                      panel->backlight.max);
> +
>         return 0;
>  }
>  

-- 
Sincerely,
   Lyude Paul (she/her)
   Software Engineer at Red Hat
   
Note: I deal with a lot of emails and have a lot of bugs on my plate. If you've
asked me a question, are waiting for a review/merge on a patch, etc. and I
haven't responded in a while, please feel free to send me another email to check
on my status. I don't bite!

