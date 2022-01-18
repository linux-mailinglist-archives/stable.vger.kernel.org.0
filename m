Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290AD492E08
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 20:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244905AbiARTAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 14:00:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244633AbiARTAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 14:00:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642532417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3L786VdHb7jzEuUgQYqOh5SVXdHks5akSmwjq1fQ6HA=;
        b=dYDtzekZE23nJ6P8dhUzMhkTEuChgaJlejAPHDjRra+2NWwRiz89H7/jSDLmSc9hMxyHPE
        Ao2/xqEmmtuAFGIZjnEL8E4+bghtHG5eSEENpCfAd3NTUdtXYPBc+zEEOggi9Y1aA3BVLK
        yRnbQmWFJsLBeEq1zX1NkNqLJa5S+D8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-M0HqvuuiPoCD-ACfZSROXw-1; Tue, 18 Jan 2022 14:00:15 -0500
X-MC-Unique: M0HqvuuiPoCD-ACfZSROXw-1
Received: by mail-wm1-f70.google.com with SMTP id j18-20020a05600c1c1200b0034aeea95dacso2484249wms.8
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 11:00:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3L786VdHb7jzEuUgQYqOh5SVXdHks5akSmwjq1fQ6HA=;
        b=B/TidK6/jp9o/C+NBFLnbekGYjGG709wwngfdmBAli6IIa5YJLw++bYmm6qlubYckA
         +CML9XzDfB9/2plJgqc0wU40oePKodAPYJHnhExj/BFsIu6NiAb6c8R2mBGK6p+3UsC/
         c9WgLLHbvrvHNc4cLCLG8kTU2h9SMybrOmSfxM4t/LcPplqmAG7Jquj/3GU+alQNtXKn
         YyttJQh2LK1mDxgmp9LeTocxZzJYU32uwy29KrVgHMWWqkt9ry4HwmdRwTfB93wWwQlR
         Y27irL5VSOhHfktJoI3QsdsN0vSZJ8nHhcP5Wrz4Kl84arU9XWjCHN0rcdAKSXbgrWnh
         cKgg==
X-Gm-Message-State: AOAM530wDNk9wlwFINjrF1mfE4yEg+TZo8Kg3H873JisVQemZuIiHOvL
        Yo4qMEfQbFhBhNjBOULqq5HvVqZGfnElgyrZSW6TEr1ZNwstRAVkBA4tRjQp+eTsICDemm5XSRR
        51TkAJN+ZqMjjgAGf
X-Received: by 2002:a5d:64e3:: with SMTP id g3mr13109099wri.450.1642532414445;
        Tue, 18 Jan 2022 11:00:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQMjevWFmDnMSNPtcO0MVjLlxRtAJh85PUR+OA7yNXYiLwmX95uE7hoiVGvVFiXlrSwzbnjQ==
X-Received: by 2002:a5d:64e3:: with SMTP id g3mr13109083wri.450.1642532414215;
        Tue, 18 Jan 2022 11:00:14 -0800 (PST)
Received: from [192.168.1.102] ([92.176.231.205])
        by smtp.gmail.com with ESMTPSA id o15sm3386819wms.11.2022.01.18.11.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 11:00:13 -0800 (PST)
Message-ID: <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
Date:   Tue, 18 Jan 2022 20:00:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Content-Language: en-US
To:     Zack Rusin <zackr@vmware.com>, dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, stable@vger.kernel.org,
        mombasawalam@vmware.com
References: <20220117180359.18114-1-zack@kde.org>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <20220117180359.18114-1-zack@kde.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Zack,

On 1/17/22 19:03, Zack Rusin wrote:
> From: Zack Rusin <zackr@vmware.com>
> 
> When sysfb_simple is enabled loading vmwgfx fails because the regions
> are held by the platform. In that case remove_conflicting*_framebuffers
> only removes the simplefb but not the regions held by sysfb.
>

Indeed, that's an issue. I wonder if we should drop the IORESOURCE_BUSY
flag from the memory resource added to the "simple-framebuffer" device ?

In fact, maybe in sysfb_create_simplefb() shouldn't even attempt to claim
a memory resource and just register the platform device with no resources ?
 
> Like the other drm drivers we need to stop requesting all the pci regions
> to let the driver load with platform code enabled.
> This allows vmwgfx to load correctly on systems with sysfb_simple enabled.
>

I read this very interesting thread from two years ago:

https://lkml.org/lkml/2020/11/5/248

Maybe is worth mentioning in the commit message what Daniel said there,
that is that only a few DRM drivers request explicitly the PCI regions
and the only reliable approach is for bus drivers to claim these.

In other words, removing the pci_request_regions() seems to have merit
on its own.

> Signed-off-by: Zack Rusin <zackr@vmware.com>
> Fixes: 523375c943e5 ("drm/vmwgfx: Port vmwgfx to arm64")
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Martin Krastev <krastevm@vmware.com>
> ---

The patch looks good to me, thanks a lot for fixing this:

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

Best regards,
-- 
Javier Martinez Canillas
Linux Engineering
Red Hat

