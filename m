Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF55D375908
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 19:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbhEFRPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 13:15:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236122AbhEFRPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 13:15:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620321256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WHt7BDD9RIfUmR/n7ErimXYampz84sK/Te7hVMTDzGg=;
        b=WPtAz49HtA1ziLeoyf4ln/r2hksIkDIFLPPSwN6XRYH7x4BrvVSmqmETSBjsv/d8PdxEug
        vKPWJl+KHEqJmAXOLYDKpA5PlK2pnPWDUih4TojAWXxH8qJbn9mnwnI6cGywgdOE1MwIcm
        Dywmes3pxNtZUPYFrn7YEYBiwD9fEuE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-p0wniNWiP9GVJqpP_ERg3A-1; Thu, 06 May 2021 13:14:14 -0400
X-MC-Unique: p0wniNWiP9GVJqpP_ERg3A-1
Received: by mail-qv1-f71.google.com with SMTP id 99-20020a0c80ec0000b029017de514d56fso4602284qvb.17
        for <stable@vger.kernel.org>; Thu, 06 May 2021 10:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=WHt7BDD9RIfUmR/n7ErimXYampz84sK/Te7hVMTDzGg=;
        b=uS9NVIg6LhGldIeDseY/RYnqkRFNzEgUp/LK4HKFYBRsiVoRgGksYXOB1Ox4LZd7Bm
         ot6RIeZTKx9YcKp3mQOZwUYUwWiawrcVGHDduJA7POid/IOuQL/m0CKtKD0I+q45vCTl
         2QeSULaKPOoFjbwSUxNZC/ISn7E5//osTgSsHLjKqCpWaaKefalq8PfnQRjHOk5v2dvp
         lSo5Yr01rjVzHyWtEswPeMwmKn/cv2poym4X9Z1vKGGsrhH5kbstz+riG+qWnbW4l5hb
         NZJUo1DvdH2OsxXeWSdeU0rqygpsgDO+Q2jTg9E2yitoI3S+IsxOfPAmxXPWcMowO5Q2
         Nhqw==
X-Gm-Message-State: AOAM532gFo6JsZqdkWECjipyyvDRv9qKfwcAf9Q/0q7RGW02jqhAoqhh
        UB+UPAZwm3GFLiQjJrxs7C2hY9G2P3H2SSAKkBB4vTckaO5P5THINMsNJxRUCyrN9ZSwhLukmq0
        h/CnX8EhdKA3tMnj7
X-Received: by 2002:ae9:dc41:: with SMTP id q62mr4943868qkf.22.1620321252600;
        Thu, 06 May 2021 10:14:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjEwnhoBPGfrifNUIwk2RVyavP6PRLpFE5xqW6/Y3DxB14jDNDqb1w/0e5lbnPGihQCWj+RQ==
X-Received: by 2002:ae9:dc41:: with SMTP id q62mr4943844qkf.22.1620321252385;
        Thu, 06 May 2021 10:14:12 -0700 (PDT)
Received: from Ruby.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id f5sm2475312qkk.12.2021.05.06.10.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 10:14:11 -0700 (PDT)
Message-ID: <59cd454b3a104a3a469a94be95cc860ced7581bd.camel@redhat.com>
Subject: Re: [PATCH AUTOSEL 4.9 08/24] drm/bridge/analogix/anx78xx: Setup
 encoder before registering connector
From:   Lyude Paul <lyude@redhat.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Robert Foss <robert.foss@linaro.org>,
        dri-devel@lists.freedesktop.org
Date:   Thu, 06 May 2021 13:14:10 -0400
In-Reply-To: <20210503164252.2854487-8-sashal@kernel.org>
References: <20210503164252.2854487-1-sashal@kernel.org>
         <20210503164252.2854487-8-sashal@kernel.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I would drop this patch for all of the stable kernel versions, it doesn't
really fix any user reported issues.

The other patches CC'd to me look fine for stable though

On Mon, 2021-05-03 at 12:42 -0400, Sasha Levin wrote:
> From: Lyude Paul <lyude@redhat.com>
> 
> [ Upstream commit 9962849d0871f5e53d0e3b3d84561f8f2847fbf4 ]
> 
> Since encoder mappings for connectors are exposed to userspace, we should
> be attaching the encoder before exposing the connector to userspace. Just a
> drive-by fix for an issue I noticed while fixing up usages of
> drm_dp_aux_init()/drm_dp_aux_register() across the tree.
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Reviewed-by: Robert Foss <robert.foss@linaro.org>
> Link:
> https://patchwork.freedesktop.org/patch/msgid/20210219215326.2227596-9-lyude@redhat.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/bridge/analogix-anx78xx.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/bridge/analogix-anx78xx.c
> b/drivers/gpu/drm/bridge/analogix-anx78xx.c
> index eb97e88a103c..16babacb7cf0 100644
> --- a/drivers/gpu/drm/bridge/analogix-anx78xx.c
> +++ b/drivers/gpu/drm/bridge/analogix-anx78xx.c
> @@ -1045,12 +1045,6 @@ static int anx78xx_bridge_attach(struct drm_bridge
> *bridge)
>         drm_connector_helper_add(&anx78xx->connector,
>                                  &anx78xx_connector_helper_funcs);
>  
> -       err = drm_connector_register(&anx78xx->connector);
> -       if (err) {
> -               DRM_ERROR("Failed to register connector: %d\n", err);
> -               return err;
> -       }
> -
>         anx78xx->connector.polled = DRM_CONNECTOR_POLL_HPD;
>  
>         err = drm_mode_connector_attach_encoder(&anx78xx->connector,
> @@ -1060,6 +1054,12 @@ static int anx78xx_bridge_attach(struct drm_bridge
> *bridge)
>                 return err;
>         }
>  
> +       err = drm_connector_register(&anx78xx->connector);
> +       if (err) {
> +               DRM_ERROR("Failed to register connector: %d\n", err);
> +               return err;
> +       }
> +
>         return 0;
>  }
>  

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

