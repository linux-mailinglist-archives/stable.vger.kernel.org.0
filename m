Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88A7493E65
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 17:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353755AbiASQgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 11:36:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349163AbiASQgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 11:36:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642610201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wFfzavDQx936gew1yKc6L3xdvrq4AiuVOm3iTQKqyl4=;
        b=M6LPZ0WpJTcTIXEs3MPM4eStyJCFhJBqAcjdXrA/AEHuVmXYA4vjyUxzZdveg+xgvr7OH6
        AsTzoIRwxC+1GXQV8nHtpyuW50GMX6yezASDwkjfIADyvI+ta8k4Cq+dHrBMIZeK02C8sS
        QUPj0vaA34QOqSzpUi0SeFDcHKXxBBU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-NYk1h1OGMQqQ4gtOxvpbVQ-1; Wed, 19 Jan 2022 11:36:40 -0500
X-MC-Unique: NYk1h1OGMQqQ4gtOxvpbVQ-1
Received: by mail-wm1-f71.google.com with SMTP id o193-20020a1ca5ca000000b0034d78423625so3242643wme.3
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 08:36:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wFfzavDQx936gew1yKc6L3xdvrq4AiuVOm3iTQKqyl4=;
        b=mdbEnlam131sw3tLrz6zCN/TXmAK0T1ZVl+oT0tPfSESOKzAUMvSrb9zk+d0KVOd17
         iJiLQoYqHHYiHqxg3HpzE4+UxZ3lD79p6IXJwjlxFuIKE1mmPrBPK7BSCsTin36s+Hcl
         E04jFdeOHkjjNSxSMVucNZaXo1fSef22umWGTK1mzlBpTeAVR3E4CDx2bqwfVeWklIHS
         kV+9wXiI9LVAg8wRbDkGCqfMF1Qg/zhomSxQ4XLxjtOcM+WvIygrjLhCtmt9+nBgQRO9
         APgBTHHkhkxjgzt2CepFw+bd2c2Gkg/86dlvvaMPKxiD0IquL0q8HXIonbqkCTd8ZN/y
         nIuQ==
X-Gm-Message-State: AOAM5322UiBS9Mrd38tKkZ4RtO8tVOPiPyhYqxrydaMgZi0sH103exuP
        DDljBf0dGnuAJgeL1xkUedf88mBnbyylOhBVo2M1sN7Y2FioXTg0FKL+xSB5uc7BE5UK+hbryP7
        wi8f0Yh5fUnsaGyzf
X-Received: by 2002:a1c:7205:: with SMTP id n5mr3366822wmc.35.1642610199065;
        Wed, 19 Jan 2022 08:36:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwjpQZRz85zHAYLtcOcLkHWqH3M6z5p0KSsS8eVX+uv169vc3M1z5+Tw15bnLGL99eZxN3fog==
X-Received: by 2002:a1c:7205:: with SMTP id n5mr3366799wmc.35.1642610198778;
        Wed, 19 Jan 2022 08:36:38 -0800 (PST)
Received: from [192.168.1.102] ([92.176.231.205])
        by smtp.gmail.com with ESMTPSA id v5sm367492wrx.114.2022.01.19.08.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 08:36:38 -0800 (PST)
Message-ID: <e1861bd2-f59d-bfba-2a07-2e4359a6774a@redhat.com>
Date:   Wed, 19 Jan 2022 17:36:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Zack Rusin <zackr@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>
References: <20220117180359.18114-1-zack@kde.org>
 <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
 <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
 <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
 <afc4c659-b92e-3227-634f-7c171b7a74b3@suse.de>
 <80fc6b88d659dd7281364daccfed1fd294e785dc.camel@vmware.com>
 <89f1b9df-6ace-d59c-86a4-571cd92d0a4c@suse.de>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <89f1b9df-6ace-d59c-86a4-571cd92d0a4c@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/19/22 16:50, Thomas Zimmermann wrote:

[snip]

>>>> IMHO the best solution is to drop IORESOURCE_BUSY from sysfb and have
>>>> drivers register/release the range with _BUSY. That would signal the
>>>> memory belongs to the sysfb device but is not busy unless a driver
>>>> has
>>>> been bound. After simplefb released the range, it should be 'non-
>>>> busy'
>>>> again and available for vmwgfx. Simpledrm does a hot-unplug of the
>>>> sysfb
>>>> device, so the memory range gets released entirely. If you want, I'll
>>>> prepare some patches for this scenario.
>>>
>>> Attached is a patch that implements this. Doing
>>>
>>>    cat /proc/iomem
>>>     ...
>>>     e0000000-efffffff : 0000:00:02.0
>>>
>>>       e0000000-e07e8fff : BOOTFB
>>>
>>>         e0000000-e07e8fff : simplefb
>>>
>>>     ...
>>>
>>> shows the memory. 'BOOTFB' is the simple-framebuffer device and
>>> 'simplefb' is the driver. Only the latter uses _BUSY. Same for
>>> and the memory canbe acquired by vmwgfx.
>>>
>>> Zack, please test this patch. If it works, I'll send out the real
>>> patchset.
>>
>> Hmm, the patch looks good but it doesn't work. After boot: /proc/iomem
>> 50000000-7fffffff : pcie@0x40000000
>>    78000000-7fffffff : 0000:00:0f.0
>>      78000000-782fffff : BOOTFB
>>
>> and vmwgfx fails on pci_request_regions:
>>
>> kernel: fb0: switching to vmwgfx from simple
>> kernel: Console: switching to colour dummy device 80x25
>> kernel: vmwgfx 0000:00:0f.0: BAR 2: can't reserve [mem 0x78000000-
>> 0x7fffffff 64bit pref]
>> kernel: vmwgfx: probe of 0000:00:0f.0 failed with error -16
>>
>> leaving the system without a fb driver.
> 
> OK, I suspect that it would work if you use simpledrm instead of 
> simplefb. Could you try please? You'd have to build DRM and simpledrm 
> into the kernel binary.
>

Yes, I believe that should work.
 Zack, could you please try if just the following [0] make it works ?

That is, dropping the IORESOURCE_BUSY but not doing the memory region
request / release in simplefb and keeping it in the vmwgfx driver.

[0]:
From da6de1430b9dc252eccf2d6fee0446d33375fa6d Mon Sep 17 00:00:00 2001
From: Javier Martinez Canillas <javierm@redhat.com>
Date: Wed, 19 Jan 2022 14:41:25 +0100
Subject: [PATCH] drivers/firmware: Don't mark as busy the simple-framebuffer
 IO resource

The sysfb_create_simplefb() function requests a IO memory resource for the
simple-framebuffer platform device, but it also marks it as busy which led
to drivers requesting the same memory resource to fail.

Let's drop the IORESOURCE_BUSY flag and let drivers to request it as busy
instead.

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
---
 drivers/firmware/sysfb_simplefb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/sysfb_simplefb.c b/drivers/firmware/sysfb_simplefb.c
index 303a491e520d..76c4abc42a30 100644
--- a/drivers/firmware/sysfb_simplefb.c
+++ b/drivers/firmware/sysfb_simplefb.c
@@ -99,7 +99,7 @@ __init int sysfb_create_simplefb(const struct screen_info *si,
 
 	/* setup IORESOURCE_MEM as framebuffer memory */
 	memset(&res, 0, sizeof(res));
-	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	res.flags = IORESOURCE_MEM;
 	res.name = simplefb_resname;
 	res.start = base;
 	res.end = res.start + length - 1;
-- 
2.33.1

