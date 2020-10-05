Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F3C283BF0
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 18:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbgJEQDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 12:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbgJEQDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 12:03:36 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24880C0613A7;
        Mon,  5 Oct 2020 09:03:36 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id n15so4454074wrq.2;
        Mon, 05 Oct 2020 09:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jeqnhc2N5T9rlVWAzTis3gMt6Y6yUtPh2doG+rLKNTI=;
        b=bbPR7U0fyhsxh5v/m/lorbumPYbvJPWcqXsT8JJmfpHnJ0WaT9RQ++1BQwztfFMsoU
         vNkaOIn7n+Yh4rXeVKCZnr8y4uTCjdS9A8tZcOdFgOVjXtV3asahjeQoUuCcIt0OyGGv
         tTTW4wheBv6WKDALZxKciZbyD0rnv8D24Xb6rIrb6AW3Snvz4q8hejF3n6r1kO0P9Rzb
         Gtb7S4emyaXEbKuYFPriC/SfIMEJnVQpGo4TWispI5OSJYCmMiXYvecgyBQBOYjAGH5v
         iCnw7tGpni3fjp6D2S5fPWQHJm1zdAIJ6DGCmLhPfCoxKflBFNv2MgxqYEBwaLTdrTZg
         f44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jeqnhc2N5T9rlVWAzTis3gMt6Y6yUtPh2doG+rLKNTI=;
        b=iCuBhL4HGPNPmzL1ZuURwHVw9Lbcgx4sfggiq5/1lQGkUjVf7q5/rzkOsuL+ThUhGd
         rfF3Zp0ihsBPZhtdB4U+LdRAwXED1pYfBuad4ltufBoJmvpuj8eOKPVprJIfNd+RDvt1
         zVR/uoZznrq83zKsti6freQkQ7LfBOav/OMlaTpSW1SJUNSLi+WaEsQvAN2PaGIGbLoR
         hXoloYXfxConb0mNBIcALB+y5o6EynVPRl8Pxy0p4JJ2b5tFH51n5/9DgQM/8ks6XvvN
         laRqJN1fCOBkOzu54BuOTiB/yhmkZpsVgyJzcsb4NkAQh1m4TuDT2TMdEQqj0OLyBNz1
         744g==
X-Gm-Message-State: AOAM5310ec5c8exQWWGkT+H2FPQBkUwu4Lud55oHLUcVswWFhNApKi46
        g0tbrbmHVVLIZz3F0ytdpVk=
X-Google-Smtp-Source: ABdhPJwt3UrbruF8bmK4GFwLiN2e6hIYPPKUGC7ynDoy9J7LCG6dPseTDzGuv/lGqi75Nee0NdqWcQ==
X-Received: by 2002:adf:fd90:: with SMTP id d16mr115846wrr.52.1601913814728;
        Mon, 05 Oct 2020 09:03:34 -0700 (PDT)
Received: from [192.168.1.125] (46-126-183-173.dynamic.hispeed.ch. [46.126.183.173])
        by smtp.gmail.com with ESMTPSA id f14sm516476wrt.53.2020.10.05.09.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 09:03:34 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.8 10/12] drm/vmwgfx: Fix error handling in
 get_node
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Martin Krastev <krastevm@vmware.com>,
        Roland Scheidegger <sroland@vmware.com>,
        dri-devel@lists.freedesktop.org
References: <20201005144501.2527477-1-sashal@kernel.org>
 <20201005144501.2527477-10-sashal@kernel.org>
From:   Roland Scheidegger <rscheidegger.oss@gmail.com>
Message-ID: <73db41ac-4a87-aa99-d03c-7391fd0390c2@gmail.com>
Date:   Mon, 5 Oct 2020 18:03:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201005144501.2527477-10-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Not entirely sure how the patches for autosel were selected, but this
patch is no good for 5.8, since the patch which introduced the breakage
in the first place is only in 5.9 (in particular it was
58e4d686d456c3e356439ae160ff4a0728940b8e, drm/ttm: cleanup
ttm_mem_type_manager_func.get_node interface v3), and at least I don't
see that one being backported to 5.8.

Roland

Am 05.10.20 um 16:44 schrieb Sasha Levin:
> From: Zack Rusin <zackr@vmware.com>
> 
> [ Upstream commit f54c4442893b8dfbd3aff8e903c54dfff1aef990 ]
> 
> ttm_mem_type_manager_func.get_node was changed to return -ENOSPC
> instead of setting the node pointer to NULL. Unfortunately
> vmwgfx still had two places where it was explicitly converting
> -ENOSPC to 0 causing regressions. This fixes those spots by
> allowing -ENOSPC to be returned. That seems to fix recent
> regressions with vmwgfx.
> 
> Signed-off-by: Zack Rusin <zackr@vmware.com>
> Reviewed-by: Roland Scheidegger <sroland@vmware.com>
> Reviewed-by: Martin Krastev <krastevm@vmware.com>
> Sigend-off-by: Roland Scheidegger <sroland@vmware.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c | 2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_thp.c           | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
> index 7da752ca1c34b..b93c558dd86e0 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
> @@ -57,7 +57,7 @@ static int vmw_gmrid_man_get_node(struct ttm_mem_type_manager *man,
>  
>  	id = ida_alloc_max(&gman->gmr_ida, gman->max_gmr_ids - 1, GFP_KERNEL);
>  	if (id < 0)
> -		return (id != -ENOMEM ? 0 : id);
> +		return id;
>  
>  	spin_lock(&gman->lock);
>  
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c b/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c
> index b7c816ba71663..c8b9335bccd8d 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c
> @@ -95,7 +95,7 @@ static int vmw_thp_get_node(struct ttm_mem_type_manager *man,
>  		mem->start = node->start;
>  	}
>  
> -	return 0;
> +	return ret;
>  }
>  
>  
> 

