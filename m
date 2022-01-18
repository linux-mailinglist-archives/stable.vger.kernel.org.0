Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2524949304E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 23:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344872AbiARWHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 17:07:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233791AbiARWHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 17:07:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642543669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d0sGw2ZPYXzHKweBVhujAqyZsD9cCnAGET6DRlSS3ng=;
        b=KNczw6hT56HJ4OCA2fG152IvigF0gxo7sxDmgzo4Hh8bzhk0pJUw7mRhwGQ49pChz0tfcH
        /molfaaTeABnh7k7OuhaUrV5Ps1kGuXExriVBi86GWwAk0Kfl7vveuDtkeQxWNzF8pnC3u
        M2q/C/LGnCu3Lo6rgkLj4szeFi1axgI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-0TORenSZP1isYD7zkx4OmA-1; Tue, 18 Jan 2022 17:07:48 -0500
X-MC-Unique: 0TORenSZP1isYD7zkx4OmA-1
Received: by mail-wm1-f70.google.com with SMTP id w5-20020a1cf605000000b0034b8cb1f55eso2825233wmc.0
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:07:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=d0sGw2ZPYXzHKweBVhujAqyZsD9cCnAGET6DRlSS3ng=;
        b=jpD5Ol9TQXn8xDxRGQHbnMnVdHxUpILVLNNQCT+AjRxIdrmVNem5b87guLvJKGe/eZ
         PZya9CsUoQuS+cpYuiWLGr3FZtLU8OvTr1tU1h5c2Kdav29W8dQG97LVOHzOJcXR6jQW
         +l3A8aPzwbTrvVeUwasHNXPlaBh2s/7h3hpXcFCrP38W/Q5DQN5tCmwkkuN8s1KJ2f2E
         /XDhMNlzAqfYYly9ZiBW4gTrLkSrR6U/EpGMbS/HJe21lsY2sNn3OXl7dHR9eAfcqu2T
         aJ/I1Feey7CbyxR8tGV9FtNP8l/001B1/F9ESzdPxUu0kga2h774xylSyMFwuAfe535Z
         a2/g==
X-Gm-Message-State: AOAM533Oa7YWYyGORuiWt3ZMqzw3AUJNS5oyHyhBKMxWtaaJtRfTnL0R
        SA4GIxRkdfe/l+WwQZlkWWYoG+9sI/YpMwJKMgmQwGVEm4LYIuXVtHld32fuYDb9oiW1+TD+Uq7
        D9R0L0xPY0At+RlJw
X-Received: by 2002:a05:600c:1548:: with SMTP id f8mr534858wmg.80.1642543667240;
        Tue, 18 Jan 2022 14:07:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzmsLGGsfiN9P0Bu5mv4S4OEuLIMtNzK5eJHhUjfMgF1/wws1jiVjLlCMibHenYl081/ffkoA==
X-Received: by 2002:a05:600c:1548:: with SMTP id f8mr534847wmg.80.1642543666981;
        Tue, 18 Jan 2022 14:07:46 -0800 (PST)
Received: from [192.168.1.102] ([92.176.231.205])
        by smtp.gmail.com with ESMTPSA id az32sm3619067wmb.2.2022.01.18.14.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 14:07:46 -0800 (PST)
Message-ID: <34f43b01-bcaf-fb93-9148-5d65a35b974e@redhat.com>
Date:   Tue, 18 Jan 2022 23:07:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Content-Language: en-US
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     Zack Rusin <zackr@vmware.com>, dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, stable@vger.kernel.org,
        mombasawalam@vmware.com
References: <20220117180359.18114-1-zack@kde.org>
 <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
In-Reply-To: <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/22 20:00, Javier Martinez Canillas wrote:
> Hello Zack,
> 
> On 1/17/22 19:03, Zack Rusin wrote:
>> From: Zack Rusin <zackr@vmware.com>
>>
>> When sysfb_simple is enabled loading vmwgfx fails because the regions
>> are held by the platform. In that case remove_conflicting*_framebuffers
>> only removes the simplefb but not the regions held by sysfb.
>>
> 
> Indeed, that's an issue. I wonder if we should drop the IORESOURCE_BUSY
> flag from the memory resource added to the "simple-framebuffer" device ?
>
> In fact, maybe in sysfb_create_simplefb() shouldn't even attempt to claim
> a memory resource and just register the platform device with no resources ?
>  

Answering my own question, this would mean adding that platform specific
logic to the drivers matching the "simple-framebuffer" device so it should
remain in sysfb_create_simplefb().

But I still wonder if dropping the IORESOURCE_BUSY flag is something that
will be reasonable to prevent other drivers having the the issue reported
in this patch.

Best regards,
-- 
Javier Martinez Canillas
Linux Engineering
Red Hat

