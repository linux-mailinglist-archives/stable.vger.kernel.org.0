Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A48129D2EB
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgJ1VhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbgJ1VhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:37:22 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE32C0613CF;
        Wed, 28 Oct 2020 14:37:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a9so585840wrg.12;
        Wed, 28 Oct 2020 14:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=reply-to:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=gqxbff3sIwRJKJ2vetLSa1wEknO8WgouSta4QsKyVI4=;
        b=CWH37Rbx0kYXww4gIBBgMaSYSknkO+ocuTjqw8MKssUIq99FsGhR3gIaCbV1ZLuXff
         n6MvssieCJynUHj0QBcblZj72K3cVeWbFIaam0cUp5TuBNkOVILOB9C206CtuwRVqfoQ
         rDsxZTsXP0VoLG51XWAtNWGiqHsiOMAz4HEMYPS36vAI1IfmbdyhsTQDnAF2hD0VkerM
         LjKKf8vrJo+5MMY7iPF3J34cWfGrydB8Ti1/3jLDoWTqfDkn9/8riY6CBv4TxnXfhw7j
         iU5RgpQgmZZeFkw8BpKRHNGATHXCDzIypDUhAlOOb2mF7QZyrBb1uutoxcfi7tlWNLVp
         zVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=gqxbff3sIwRJKJ2vetLSa1wEknO8WgouSta4QsKyVI4=;
        b=IDJ/Vf28I+IK5b31bPDfAc/L32s2/YmW1fT0cWqpF40bvR2Xcj6GSKJm+cJpqviPiZ
         QRl59k4PzZi9bTLtm8iotE17YAUkogmWSsDJbvWQ91sY2iKxlSxiKTd5KxIKfyKyB6jy
         oT1L9TzaV9zZPtzNRe/kL8w1y9ceNYf/9gUj5fuoH3xnnA1wvOHV8KRq22g95dA6nO12
         VSOBAJ0CEaVN0jvfjDMAlvrEeuEmJGY3A/jUrzE8djdIHooFHSOzOe1X1GzjwoTZ8c8w
         ReUXqYcIw+1MuISAptDvvg3t9+mJIbR3T3H0KUTUI/11M8XAA/8Md2wJsVQc/uPNc2b8
         khyw==
X-Gm-Message-State: AOAM533n5w3N6C14cDjspGRLq9XCS9bP1oguzQOkbX22g4tpkfnI4gA+
        mmSn63Fx8dqNAGcHt8FOrmhSw4VM2J0=
X-Google-Smtp-Source: ABdhPJw+FfZnd8LSJtXqeaZjKv8Rr31kSq6R9Gg4Nw/fxyyAp5tvKQxisnaGWJNOnsxbVlPXxp4Hew==
X-Received: by 2002:a17:906:af71:: with SMTP id os17mr6750928ejb.200.1603879072094;
        Wed, 28 Oct 2020 02:57:52 -0700 (PDT)
Received: from ?IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7? ([2a02:908:1252:fb60:be8a:bd56:1f94:86e7])
        by smtp.gmail.com with ESMTPSA id 64sm470042eda.63.2020.10.28.02.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 02:57:51 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [Linaro-mm-sig] [PATCH] drm/shme-helpers: Fix dma_buf_mmap
 forwarding bug
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Rob Herring <robh@kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        piotr.oniszczuk@gmail.com, Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        stable@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Daniel Vetter <daniel.vetter@intel.com>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
References: <20201027214922.3566743-1-daniel.vetter@ffwll.ch>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <62e05cfd-0030-ad32-0b3f-69dd257b2e3c@gmail.com>
Date:   Wed, 28 Oct 2020 10:57:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201027214922.3566743-1-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 27.10.20 um 22:49 schrieb Daniel Vetter:
> When we forward an mmap to the dma_buf exporter, they get to own
> everything. Unfortunately drm_gem_mmap_obj() overwrote
> vma->vm_private_data after the driver callback, wreaking the
> exporter complete. This was noticed because vb2_common_vm_close blew
> up on mali gpu with panfrost after commit 26d3ac3cb04d
> ("drm/shmem-helpers: Redirect mmap for imported dma-buf").
>
> Unfortunately drm_gem_mmap_obj also acquires a surplus reference that
> we need to drop in shmem helpers, which is a bit of a mislayer
> situation. Maybe the entire dma_buf_mmap forwarding should be pulled
> into core gem code.
>
> Note that the only two other drivers which forward mmap in their own
> code (etnaviv and exynos) get this somewhat right by overwriting the
> gem mmap code. But they seem to still have the leak. This might be a
> good excuse to move these drivers over to shmem helpers completely.
>
> Note to stable team: There's a trivial context conflict with
> d693def4fd1c ("drm: Remove obsolete GEM and PRIME callbacks from
> struct drm_driver"). I'm assuming it's clear where to put the first
> hunk, otherwise I can send a 5.9 version of this.
>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Russell King <linux+etnaviv@armlinux.org.uk>
> Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
> Cc: Inki Dae <inki.dae@samsung.com>
> Cc: Joonyoung Shim <jy0922.shim@samsung.com>
> Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Fixes: 26d3ac3cb04d ("drm/shmem-helpers: Redirect mmap for imported dma-buf")
> Cc: Boris Brezillon <boris.brezillon@collabora.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-media@vger.kernel.org
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: <stable@vger.kernel.org> # v5.9+
> Reported-and-tested-by: piotr.oniszczuk@gmail.com
> Cc: piotr.oniszczuk@gmail.com
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>

Acked-by: Christian König <christian.koenig@amd.com>

> ---
>   drivers/gpu/drm/drm_gem.c              | 4 ++--
>   drivers/gpu/drm/drm_gem_shmem_helper.c | 7 ++++++-
>   2 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 1da67d34e55d..d586068f5509 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -1076,6 +1076,8 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
>   	 */
>   	drm_gem_object_get(obj);
>   
> +	vma->vm_private_data = obj;
> +
>   	if (obj->funcs->mmap) {
>   		ret = obj->funcs->mmap(obj, vma);
>   		if (ret) {
> @@ -1096,8 +1098,6 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
>   		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
>   	}
>   
> -	vma->vm_private_data = obj;
> -
>   	return 0;
>   }
>   EXPORT_SYMBOL(drm_gem_mmap_obj);
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index fb11df7aced5..8233bda4692f 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -598,8 +598,13 @@ int drm_gem_shmem_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
>   	/* Remove the fake offset */
>   	vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
>   
> -	if (obj->import_attach)
> +	if (obj->import_attach) {
> +		/* Drop the reference drm_gem_mmap_obj() acquired.*/
> +		drm_gem_object_put(obj);
> +		vma->vm_private_data = NULL;
> +
>   		return dma_buf_mmap(obj->dma_buf, vma, 0);
> +	}
>   
>   	shmem = to_drm_gem_shmem_obj(obj);
>   

