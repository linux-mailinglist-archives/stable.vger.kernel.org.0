Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88A42A9EBF
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 21:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgKFU4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 15:56:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728408AbgKFU4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 15:56:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604696168;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NxW9gx65PlBBUjL9DwwFszpbrnQZH79vZNnD8Uc6MNA=;
        b=NFYtKTFMTRA4gm4fzspSXy9/LnQK+8T0FODYuJssDV052MzOX8JhoHEKWNdJElM67Lumsq
        4LYF61xfAIKE4kBOTF7yfQmqqekBLWF7U1M+jrSmisIy+jZdyOp/ginyGzS23C3L/MKzkL
        L7/fRKm8y/QgJ6tG+PAsRaWO0uQXqL4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-Mckp428AMc-H3sqCW4m_fw-1; Fri, 06 Nov 2020 15:56:07 -0500
X-MC-Unique: Mckp428AMc-H3sqCW4m_fw-1
Received: by mail-qk1-f198.google.com with SMTP id f126so1587118qke.17
        for <stable@vger.kernel.org>; Fri, 06 Nov 2020 12:56:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=NxW9gx65PlBBUjL9DwwFszpbrnQZH79vZNnD8Uc6MNA=;
        b=oAcUCPI5FaI+k3bmY+ewRWYgR42C/GlcmFRUEa/LrcFPuxwJ46oG6yKaZohIMifyzE
         OyLyoJXhWEYZsz9pZT+nZa1RnXOzh6DY6Dq2/fz6IYmLhzgqYKFOp6DbKE7lqUyJ4oZR
         VjNI0MHH7N0pCuJz2ZvvGcy4CsWyzJtctGdvzIMGgEWPGgbi4PreTjT2qGVwwS/phQir
         HLUEmAXUOu3lYgf3uqaIG9u4O+dS3+tcaDcF463HiVJQr5/L0XySw1EyzRAmvQMZ74A8
         Ivahrg77or5cYhVnnbeTDzj7o0frWO/SGRUpts8bePGSrvRq8HA0v+s/R3QSnQ6MDX2A
         evLQ==
X-Gm-Message-State: AOAM531Mx7cweJ1Z/SE1pTDhAHl/xxM5T6lVDqNQ60A2ckomj/M0njmf
        w03ZEHlZGTWNa+/saaSYSm+Omipk8jNEtKpkxpczfgcI9nSTRkvPVfReSExTLXvg5WoHdSybxI2
        WijxRZFXEU/C+oIcI
X-Received: by 2002:a0c:bd07:: with SMTP id m7mr3471001qvg.34.1604696166380;
        Fri, 06 Nov 2020 12:56:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwktFCvoAilzq0FR0x+IGCOp2NQdSTaI6uVZ/wTcXTJvqnPemgKY9/oI6dV7eINmeRzlkiCsw==
X-Received: by 2002:a0c:bd07:: with SMTP id m7mr3470985qvg.34.1604696166146;
        Fri, 06 Nov 2020 12:56:06 -0800 (PST)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id h18sm1383442qtc.17.2020.11.06.12.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 12:56:05 -0800 (PST)
Message-ID: <db280b0e49cef626c69f1a90eb7201c0135115d2.camel@redhat.com>
Subject: Re: FAILED: patch "[PATCH] drm/nouveau/kms/nv50-: Get rid of bogus"
 failed to apply to 5.9-stable tree
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     gregkh@linuxfoundation.org, bskeggs@redhat.com,
        stable@vger.kernel.org, ville.syrjala@linux.intel.com
Date:   Fri, 06 Nov 2020 15:56:04 -0500
In-Reply-To: <160459060724988@kroah.com>
References: <160459060724988@kroah.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Actually - this fix caused some problems, and there's a follow-up fix in linus's
tree now that we want to make sure to apply at the same time. It looks like I
forgot to Cc it to stable though, so I'll backport both this and the subsequent
fix and send them to you in just a bit

On Thu, 2020-11-05 at 16:36 +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.9-stable tree.
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
> From 2d831155cf0607566e43d8465da33774b2dc7221 Mon Sep 17 00:00:00 2001
> From: Lyude Paul <lyude@redhat.com>
> Date: Tue, 29 Sep 2020 18:31:31 -0400
> Subject: [PATCH] drm/nouveau/kms/nv50-: Get rid of bogus
>  nouveau_conn_mode_valid()
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Ville also pointed out that I got a lot of the logic here wrong as well,
> whoops.
> While I don't think anyone's likely using 3D output with nouveau, the next
> patch
> will make nouveau_conn_mode_valid() make a lot less sense. So, let's just get
> rid of it and open-code it like before, while taking care to move the 3D frame
> packing calculations on the dot clock into the right place.
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: d6a9efece724 ("drm/nouveau/kms/nv50-: Share DP SST mode_valid()
> handling with MST")
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.8+
> Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c
> b/drivers/gpu/drm/nouveau/nouveau_connector.c
> index 49dd0cbc332f..6f21f36719fc 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_connector.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
> @@ -1023,29 +1023,6 @@ get_tmds_link_bandwidth(struct drm_connector
> *connector)
>                 return 112000 * duallink_scale;
>  }
>  
> -enum drm_mode_status
> -nouveau_conn_mode_clock_valid(const struct drm_display_mode *mode,
> -                             const unsigned min_clock,
> -                             const unsigned max_clock,
> -                             unsigned int *clock_out)
> -{
> -       unsigned int clock = mode->clock;
> -
> -       if ((mode->flags & DRM_MODE_FLAG_3D_MASK) ==
> -           DRM_MODE_FLAG_3D_FRAME_PACKING)
> -               clock *= 2;
> -
> -       if (clock < min_clock)
> -               return MODE_CLOCK_LOW;
> -       if (clock > max_clock)
> -               return MODE_CLOCK_HIGH;
> -
> -       if (clock_out)
> -               *clock_out = clock;
> -
> -       return MODE_OK;
> -}
> -
>  static enum drm_mode_status
>  nouveau_connector_mode_valid(struct drm_connector *connector,
>                              struct drm_display_mode *mode)
> @@ -1053,7 +1030,7 @@ nouveau_connector_mode_valid(struct drm_connector
> *connector,
>         struct nouveau_connector *nv_connector = nouveau_connector(connector);
>         struct nouveau_encoder *nv_encoder = nv_connector->detected_encoder;
>         struct drm_encoder *encoder = to_drm_encoder(nv_encoder);
> -       unsigned min_clock = 25000, max_clock = min_clock;
> +       unsigned int min_clock = 25000, max_clock = min_clock, clock = mode-
> >clock;
>  
>         switch (nv_encoder->dcb->type) {
>         case DCB_OUTPUT_LVDS:
> @@ -1082,8 +1059,15 @@ nouveau_connector_mode_valid(struct drm_connector
> *connector,
>                 return MODE_BAD;
>         }
>  
> -       return nouveau_conn_mode_clock_valid(mode, min_clock, max_clock,
> -                                            NULL);
> +       if ((mode->flags & DRM_MODE_FLAG_3D_MASK) ==
> DRM_MODE_FLAG_3D_FRAME_PACKING)
> +               clock *= 2;
> +
> +       if (clock < min_clock)
> +               return MODE_CLOCK_LOW;
> +       if (clock > max_clock)
> +               return MODE_CLOCK_HIGH;
> +
> +       return MODE_OK;
>  }
>  
>  static struct drm_encoder *
> diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c
> b/drivers/gpu/drm/nouveau/nouveau_dp.c
> index 7b640e05bd4c..93e3751ad7f1 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_dp.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
> @@ -232,12 +232,14 @@ nv50_dp_mode_valid(struct drm_connector *connector,
>                    unsigned *out_clock)
>  {
>         const unsigned min_clock = 25000;
> -       unsigned max_clock, ds_clock, clock;
> -       enum drm_mode_status ret;
> +       unsigned max_clock, ds_clock, clock = mode->clock;
>  
>         if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
>                 return MODE_NO_INTERLACE;
>  
> +       if ((mode->flags & DRM_MODE_FLAG_3D_MASK) ==
> DRM_MODE_FLAG_3D_FRAME_PACKING)
> +               clock *= 2;
> +
>         max_clock = outp->dp.link_nr * outp->dp.link_bw;
>         ds_clock = drm_dp_downstream_max_dotclock(outp->dp.dpcd,
>                                                   outp->dp.downstream_ports);
> @@ -245,9 +247,13 @@ nv50_dp_mode_valid(struct drm_connector *connector,
>                 max_clock = min(max_clock, ds_clock);
>  
>         clock = mode->clock * (connector->display_info.bpc * 3) / 10;
> -       ret = nouveau_conn_mode_clock_valid(mode, min_clock, max_clock,
> -                                           &clock);
> +       if (clock < min_clock)
> +               return MODE_CLOCK_LOW;
> +       if (clock > max_clock)
> +               return MODE_CLOCK_HIGH;
> +
>         if (out_clock)
>                 *out_clock = clock;
> -       return ret;
> +
> +       return MODE_OK;
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

