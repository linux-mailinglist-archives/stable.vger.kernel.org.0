Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D0C304A65
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbhAZFFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731062AbhAYTYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 14:24:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611602550;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lFbYP4oVs5kF59+ynJOWZYJom9wck9XmDhxXSMFwYZM=;
        b=H8zPFaTEJhMgkhmRX9bMf4zz++ia4MzmBjrCWumjcEjdg47FT36ev09WEKNYcVoXrH2osY
        WeYJyYL1eXp4Kxq9+Y/3VMt1ZyfHKKhHbR0u6zljMhxQRZYr+REG9vVoNcVaK6UZPG4OWr
        GOiJy8GnfhDsg3o0hkuRQ2MdQsh5NoQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-zjSCgjrUOZyawrbk58pl_w-1; Mon, 25 Jan 2021 14:22:29 -0500
X-MC-Unique: zjSCgjrUOZyawrbk58pl_w-1
Received: by mail-qk1-f199.google.com with SMTP id i11so10653517qkn.21
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 11:22:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=lFbYP4oVs5kF59+ynJOWZYJom9wck9XmDhxXSMFwYZM=;
        b=QXDrhjbKAVZxeFaoILB7o0QBX/zCxzoDkoBsoYT8c73xFLvlz+/RQkzFF87fdXBc0j
         BCYVdMA1l0eMDlXlC/eFNhlrc+vigz0NY7cSr3KqHA3jj7Gp/Yc4krT3CCputko98bRT
         CWj2+TN7fs6PUgFEP8czm7A/TSy4d/xHFycri75y6KMocKquQndKJJEu1XRDuaeJSoqf
         jlFgwZSan+L4lrudDxW0ZGu6ycDqkbXvOobkebYDxIuJIyAcn24eduWzSHCvHcHw7/Dx
         g/dSd3JIAZugVH2RJwN+al6znJgw13mB77TI5aLSbKl7PF+YPaWzRH35RQ1noIWsALBT
         kNVA==
X-Gm-Message-State: AOAM531XGwj2CEQk5d9Aevbj9thT2pGbCv0GDyTkMmTS+pfiCxSbUDUM
        Bg4SNH1vnJ5sweP3rpCXxBr3dCDV6EQ4SKuJxvIazdcTh+6CsM5n5Q8xiwSt3GgsYC+NZcpHEXr
        ktc2bVK4dAEtwgP1e
X-Received: by 2002:a05:620a:79a:: with SMTP id 26mr2276790qka.302.1611602548398;
        Mon, 25 Jan 2021 11:22:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzyt85gHwAhRFiN3DIilz7ZmTABg2S7qVGI7CjGvOqN5Fk3yHharLZwMvD77KxfS6FmaecaNw==
X-Received: by 2002:a05:620a:79a:: with SMTP id 26mr2276775qka.302.1611602548209;
        Mon, 25 Jan 2021 11:22:28 -0800 (PST)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id 136sm12537457qkn.79.2021.01.25.11.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 11:22:27 -0800 (PST)
Message-ID: <8780f792b606558ac501ce1d9b281d0da76a177b.camel@redhat.com>
Subject: Re: [PATCH 1/2] drm/dp/mst: Export drm_dp_get_vc_payload_bw()
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org
Cc:     Ville Syrjala <ville.syrjala@intel.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date:   Mon, 25 Jan 2021 14:22:26 -0500
In-Reply-To: <20210125173636.1733812-1-imre.deak@intel.com>
References: <20210125173636.1733812-1-imre.deak@intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-01-25 at 19:36 +0200, Imre Deak wrote:
> This function will be needed by the next patch where the driver
> calculates the BW based on driver specific parameters, so export it.
> 
> At the same time sanitize the function params, passing the more natural
> link rate instead of the encoding of the same rate.
> 
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Ville Syrjala <ville.syrjala@intel.com>
> Cc: <stable@vger.kernel.org>
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 24 ++++++++++++++++++------
>  include/drm/drm_dp_mst_helper.h       |  1 +
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> b/drivers/gpu/drm/drm_dp_mst_topology.c
> index 475939138b21..dc96cbf78cc6 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -3629,14 +3629,26 @@ static int drm_dp_send_up_ack_reply(struct
> drm_dp_mst_topology_mgr *mgr,
>         return 0;
>  }
>  
> -static int drm_dp_get_vc_payload_bw(u8 dp_link_bw, u8  dp_link_count)
> +/**
> + * drm_dp_get_vc_payload_bw - get the VC payload BW for an MST link
> + * @rate: link rate in 10kbits/s units
> + * @lane_count: lane count
> + *
> + * Calculate the toal bandwidth of a MultiStream Transport link. The returned

s/toal/total/

With that fixed, this patch is:

Reviewed-by: Lyude Paul <lyude@redhat.com>

> + * value is in units of PBNs/(timeslots/1 MTP). This value can be used to
> + * convert the number of PBNs required for a given stream to the number of
> + * timeslots this stream requires in each MTP.
> + */
> +int drm_dp_get_vc_payload_bw(int link_rate, int link_lane_count)
>  {
> -       if (dp_link_bw == 0 || dp_link_count == 0)
> -               DRM_DEBUG_KMS("invalid link bandwidth in DPCD: %x (link count:
> %d)\n",
> -                             dp_link_bw, dp_link_count);
> +       if (link_rate == 0 || link_lane_count == 0)
> +               DRM_DEBUG_KMS("invalid link rate/lane count: (%d / %d)\n",
> +                             link_rate, link_lane_count);
>  
> -       return dp_link_bw * dp_link_count / 2;
> +       /* See DP v2.0 2.6.4.2,
> VCPayload_Bandwidth_for_OneTimeSlotPer_MTP_Allocation */
> +       return link_rate * link_lane_count / 54000;
>  }
> +EXPORT_SYMBOL(drm_dp_get_vc_payload_bw);
>  
>  /**
>   * drm_dp_read_mst_cap() - check whether or not a sink supports MST
> @@ -3692,7 +3704,7 @@ int drm_dp_mst_topology_mgr_set_mst(struct
> drm_dp_mst_topology_mgr *mgr, bool ms
>                         goto out_unlock;
>                 }
>  
> -               mgr->pbn_div = drm_dp_get_vc_payload_bw(mgr->dpcd[1],
> +               mgr->pbn_div =
> drm_dp_get_vc_payload_bw(drm_dp_bw_code_to_link_rate(mgr->dpcd[1]),
>                                                         mgr->dpcd[2] &
> DP_MAX_LANE_COUNT_MASK);
>                 if (mgr->pbn_div == 0) {
>                         ret = -EINVAL;
> diff --git a/include/drm/drm_dp_mst_helper.h b/include/drm/drm_dp_mst_helper.h
> index f5e92fe9151c..bd1c39907b92 100644
> --- a/include/drm/drm_dp_mst_helper.h
> +++ b/include/drm/drm_dp_mst_helper.h
> @@ -783,6 +783,7 @@ drm_dp_mst_detect_port(struct drm_connector *connector,
>  
>  struct edid *drm_dp_mst_get_edid(struct drm_connector *connector, struct
> drm_dp_mst_topology_mgr *mgr, struct drm_dp_mst_port *port);
>  
> +int drm_dp_get_vc_payload_bw(int link_rate, int link_lane_count);
>  
>  int drm_dp_calc_pbn_mode(int clock, int bpp, bool dsc);
>  

-- 
Sincerely,
   Lyude Paul (she/her)
   Software Engineer at Red Hat
   
Note: I deal with a lot of emails and have a lot of bugs on my plate. If you've
asked me a question, are waiting for a review/merge on a patch, etc. and I
haven't responded in a while, please feel free to send me another email to check
on my status. I don't bite!

