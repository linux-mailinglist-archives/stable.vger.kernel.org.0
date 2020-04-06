Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF6A19FE05
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 21:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgDFTYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 15:24:23 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:41446 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFTYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 15:24:23 -0400
Received: by mail-il1-f196.google.com with SMTP id t6so627443ilj.8
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 12:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vePX0/zywlzH/S3pB4C4OQDkDkegT3qQSMEsAoWIPuc=;
        b=ZAmz+GjJjLF4PlS9vtEeLKUZ1oOZ13Gyd7sGQCR5YO9Hc0UXp6aoZdrwCaL9kCEUnA
         cOvFtLY21jz6X4TTAvJ5i9zxcVKrq50xT3z+ZQH4nzBwBxuZsds9EgHd5Jh/B4GnHjMI
         gb4Fivc2nyAbAg0PuA+5EVBZoevMCno9B1edFLNPe5qBw5+Zi3hO9jqV4K0v9SGkXunN
         chfufTf/QYAhCf+Y2BWfwWvSkKM9hoTFoIYLwlIjWS0yUhbyqgsb89Dj1pBu8zDqhieV
         se9OX4bwhCB+5XB2qXblllxcrLk2knEyumL4GBZ3rHZqp4WePONPYj457rD7l5BS4YAK
         FCpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vePX0/zywlzH/S3pB4C4OQDkDkegT3qQSMEsAoWIPuc=;
        b=EhSyxVVpSVir6kf7D707vs1Sgj6NsTBxYwKNKUt85w60+vm51ns0qOTPm4+Ije/1Co
         z2m/Mw9gQUOOIWFmxwlpKYr6qX7e0V/pAjwMevK35ZDRoun5tJv04scMxIcd8GsEQ5B2
         PiP7MpazGuHFS3D1zN46UjF3ZCFUQYWiGieHBTXi43lsgNjB4uATAA3mfj1IPXJJ/C7W
         ivA6kcIV7pCAQoD7Sl0GjzeqNNCE3OvV5uEGMlPGGzGB79vMle6OKF8r802u0zTKMBm3
         tctHcKyI9dlBhdyVvEbM/ZMDQg7gRXNMe3Ib0Ue7Da/0XTWgEBd/krPp+OmRVdIrIfvS
         5Fwg==
X-Gm-Message-State: AGi0Pua3dR2Quc/KvGfNo8DU4HXueuZ0H9F91Oiqz7KbyUEHqiEg/Uys
        qGDTgQQ4DvbUKastZFpdtZvZOhRvnmeLjSTItuiY4Q==
X-Google-Smtp-Source: APiQypL2MG5b6ggF1ip4yCdvbuL8ZGEpWTi12pOkrrcYep7bseoSKkbcrp87/m+HbZrf5Mac2unzD5FFDmdmURhBvkM=
X-Received: by 2002:a92:3b56:: with SMTP id i83mr960355ila.75.1586201062614;
 Mon, 06 Apr 2020 12:24:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200403200757.886443-1-lyude@redhat.com> <20200403200757.886443-3-lyude@redhat.com>
In-Reply-To: <20200403200757.886443-3-lyude@redhat.com>
From:   Sean Paul <sean@poorly.run>
Date:   Mon, 6 Apr 2020 15:23:46 -0400
Message-ID: <CAMavQKL6G9QsUE7ZzGXNpjjEVdZGQZkbN3oke-M=Lz=pHOn70A@mail.gmail.com>
Subject: Re: [PATCH 2/4] drm/dp_mst: Reformat drm_dp_check_act_status() a bit
To:     Lyude Paul <lyude@redhat.com>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Todd Previte <tprevite@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 3, 2020 at 4:08 PM Lyude Paul <lyude@redhat.com> wrote:
>
> Just add a bit more line wrapping, get rid of some extraneous
> whitespace, remove an unneeded goto label, and move around some variable
> declarations. No functional changes here.
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> [this isn't a fix, but it's needed for the fix that comes after this]
> Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)")
> Cc: Sean Paul <sean@poorly.run>
> Cc: <stable@vger.kernel.org> # v3.17+
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
> index 2b9ce965f044..7aaf184a2e5f 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -4473,33 +4473,31 @@ static int drm_dp_dpcd_write_payload(struct drm_dp_mst_topology_mgr *mgr,
>   */
>  int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr)
>  {
> +       int count = 0, ret;
>         u8 status;
> -       int ret;
> -       int count = 0;
>
>         do {
> -               ret = drm_dp_dpcd_readb(mgr->aux, DP_PAYLOAD_TABLE_UPDATE_STATUS, &status);
> -
> +               ret = drm_dp_dpcd_readb(mgr->aux,
> +                                       DP_PAYLOAD_TABLE_UPDATE_STATUS,
> +                                       &status);
>                 if (ret < 0) {
> -                       DRM_DEBUG_KMS("failed to read payload table status %d\n", ret);
> -                       goto fail;
> +                       DRM_DEBUG_KMS("failed to read payload table status %d\n",
> +                                     ret);
> +                       return ret;
>                 }
>
>                 if (status & DP_PAYLOAD_ACT_HANDLED)
>                         break;
>                 count++;
>                 udelay(100);
> -
>         } while (count < 30);
>
>         if (!(status & DP_PAYLOAD_ACT_HANDLED)) {
> -               DRM_DEBUG_KMS("failed to get ACT bit %d after %d retries\n", status, count);
> -               ret = -EINVAL;
> -               goto fail;
> +               DRM_DEBUG_KMS("failed to get ACT bit %d after %d retries\n",

Should we print status in base16 here?

Otherwise:

Reviewed-by: Sean Paul <sean@poorly.run>

> +                             status, count);
> +               return -EINVAL;
>         }
>         return 0;
> -fail:
> -       return ret;
>  }
>  EXPORT_SYMBOL(drm_dp_check_act_status);
>
> --
> 2.25.1
>
