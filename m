Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5AD2A7592
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 03:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgKECe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 21:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgKECez (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 21:34:55 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C93AC0613CF
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 18:34:55 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id u127so132462oib.6
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 18:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NS64fQvYLPc8vKHF0Jx8ZL70MwzmV5ZlFDaZEyM6le4=;
        b=Optc8X+2fOcZEuxfMqB/zql6iuJCvzC61Hd9ehOTx4LcsXcr0YDJ2xXEsaVyK0S5dI
         7h7UMy08wxAG3y4GD7pT6iz2PpmCioxI0hyTvfFpuSWMSjbb90qzEI8rx6CsdwEqBdJX
         EfMIHwmVGZYXTCReesJ1oFFsqGv2+7KTeRN0H3a9pO5IMt+Zn3x/C8R4HMe3XYnjU1U2
         zV1MBDI9PZhVkggRSocv3CYz8u9u8PrzTAi1evN+G2M0U3gZIc6zW4JjFUyQYUPwTroN
         7oC41Ct4mA9a6YHPrqs5Pcld4fIhf/ASfgZzUd46LNJMXB+5iOLHQvFhEoOphighpMTV
         HXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NS64fQvYLPc8vKHF0Jx8ZL70MwzmV5ZlFDaZEyM6le4=;
        b=aIw4rha9WYYp1tQq+YkvHZemFRUqLw+62LLXA6qNH11rlC71rzUIm0dMo1j761qZFp
         ICZ74mbjVwh4YaRTSWiJJua+W5SWgH7Sgd35Wkc8hRaZbK6POaNavP4KkIbuQUGUTJOM
         bUwY9b22a5TR27IwjxrNvlTJJ245DPlPEGVK0hpM+iGyJ2zYCzg6+CVySJhALcGrBnIU
         AlaWCfgqNGU3ktBqCG5fLai4MAz/SMbRZvTe8WZzPtd+V5t99prhVaCwN30BBr/5soEh
         zrijUbP5Mht7gBm06cY4mYSD9SK7o21O8jozdiQqHmqMuugWNoD/Vw812Ek1THXEOGno
         bx1w==
X-Gm-Message-State: AOAM531DAzfyzbRmhGfl0wLhlvLiAJQXLz6bzSjQL2jd6cXQqM8/zX6u
        9LkMjFFCK9g+j5UK/DdEBHQx0Fzt/dw=
X-Google-Smtp-Source: ABdhPJyRWrtaC+8utrP9kO9SCI1VnAqwBtzUyuQWzAZ7XzwHgZKd+rPkocfwTrPOA/PZY+pNzQGAUQ==
X-Received: by 2002:aca:db85:: with SMTP id s127mr274661oig.176.1604543692737;
        Wed, 04 Nov 2020 18:34:52 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w18sm31423otl.38.2020.11.04.18.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 18:34:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: build failures in v4.4.y stable queue
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20201104141230.GC4312@roeck-us.net>
 <20201104143709.GC2202359@kroah.com> <20201104161817.GG2092@sasha-vm>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <1fc37180-ad6f-d2b7-7921-77e9c271ebb0@roeck-us.net>
Date:   Wed, 4 Nov 2020 18:34:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201104161817.GG2092@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/20 8:18 AM, Sasha Levin wrote:
> On Wed, Nov 04, 2020 at 03:37:09PM +0100, Greg KH wrote:
>> On Wed, Nov 04, 2020 at 06:12:30AM -0800, Guenter Roeck wrote:
>>> Building ia64:defconfig ... failed
>>> --------------
>>> Error log:
>>> drivers/acpi/numa.c: In function 'pxm_to_node':
>>> drivers/acpi/numa.c:49:43: error: 'numa_off' undeclared
>>
>> Caused by 8a3decac087a ("ACPI: Add out of bounds and numa_off
>> protections to pxm_to_node()"), I'll go drop it.
>>
>> Sasha, you didn't queue this up to 4.9, but you did to 4.4?
>>
>>>
>>> Building powerpc:defconfig ... failed
>>> --------------
>>> Error log:
>>> arch/powerpc/kvm/book3s_hv.c: In function ‘kvm_arch_vm_ioctl_hv’:
>>> arch/powerpc/kvm/book3s_hv.c:3161:7: error: implicit declaration of function ‘kvmhv_on_pseries’
>>
>> Caused by 05e6295dc7de ("KVM: PPC: Book3S HV: Do not allocate HPT for a
>> nested guest"), I'll go drop this.
>>
>> Sasha, why did you only queue this up to 4.4 and 5.4 and 5.9 and not the
>> middle queues as well?
> 
> Originally it got queued everywhere, but then it looks like I dropped it
> from 4.9-4.19 because of build failures, but it seems that the 4.4
> failure wasn't detected.
> 
> Looking into why, it seems that my baseline for that build also fails
> for some reason:
> 
> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:1603: Warning: invalid register expression
> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:1644: Warning: invalid register expression
> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:839: Error: attempt to move .org backwards
> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:840: Error: attempt to move .org backwards
> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:864: Error: attempt to move .org backwards
> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:865: Error: attempt to move .org backwards
> make[2]: *** [/home/sasha/data/linux/scripts/Makefile.build:375: arch/powerpc/kernel/head_64.o] Error 1
> make[1]: *** [/home/sasha/data/linux/Makefile:1006: arch/powerpc/kernel] Error 2
> 
> I think that I'll rebuild my toolchain for powerpc and redo the baseline
> builds, sorry about that.
> 

Is that an allmodconfig build ? That simply won't build in 4.4.y because
exceptions-64s.S is too large there.

Guenter
