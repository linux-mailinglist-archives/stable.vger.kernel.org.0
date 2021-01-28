Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C12307741
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 14:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhA1NjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 08:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhA1NjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 08:39:09 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D20CC061573;
        Thu, 28 Jan 2021 05:38:29 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id s7so2439224wru.5;
        Thu, 28 Jan 2021 05:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=an/vvbRrXDfPTOHYMdUOXFcH08G8fuDblC2KweDE27g=;
        b=VKiuqB0pyB2M46cuP8gMg66KlNWekFNNP9Fl4uRnL2EYk+BrpAX+mPQldVmDsLsjkd
         sgjJoWPoxcZiSS5zOrZ/GyImzqijD1w7vvVeG8lcaPQiAZakNvm77/6KXz5liHDifvyP
         1Hcr4c38vpQcC4bUTinOZu9q6fhtmvRUhILJ9rleWqRxeo2YFQtvDhIBbsVZIRXxRD4L
         dwW5Zws12ujzACbRSfb8gLENXq0BpPv0AJLBwvHYblS40Fw1Q7l9BvKL9jaRVYn4G8f/
         gE3BZW2mac6Nogb8uDOwbLDEa0C47e7VIKZZKUwkbXrarzbVrCPlbhxzMjWnI3Jo5miA
         9FjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=an/vvbRrXDfPTOHYMdUOXFcH08G8fuDblC2KweDE27g=;
        b=MF0+nfjGz8LKpjVBeVTWdDLUfGIFglo+UmwC5jPKvq+xvvKdwVRBTkM6cWNZMCBbbO
         W0nFUta9A+qnPEHAuc/rS1sR2wxQoHurTxSiLGqdg9ofL62x3dH+NKgNCdFyIUzg3EVz
         p3f2hHzXbCusiw+eaf4bQKGHxBSNKhlHDaRIvM3cRsG2TUVk63lYgkiKC2iX3lmGR8DD
         vWCXYZzxyHfwWf3gBwWzqH3ytlQH595vKP91HyqtNQthn+sRc4o0ZKmRWdXf7d+CdUV0
         TVRbhWlbX1k2OgCsf+ZJhz03l6XrdUNn26E66TBCyeg89KEKl7OTwFBjr4BPOr4KKis7
         kopA==
X-Gm-Message-State: AOAM531MBn4FeRHIyDw3ZkmyKMn7nb2yFSot2667ty1GiOopGzsuMXJw
        riFiIVFDFQuMuUgfFts9GF8=
X-Google-Smtp-Source: ABdhPJzTeaVtR9kPqWvx44mEIIuwAQA4LuWb4wT2drDrrkXAsNNAt/YpSqCZh3MQ/rifJrHF0JzWtg==
X-Received: by 2002:adf:f9cb:: with SMTP id w11mr16339115wrr.199.1611841107807;
        Thu, 28 Jan 2021 05:38:27 -0800 (PST)
Received: from [192.168.1.20] (5ec062a9.skybroadband.com. [94.192.98.169])
        by smtp.googlemail.com with ESMTPSA id u5sm6463244wmg.9.2021.01.28.05.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 05:38:26 -0800 (PST)
Subject: Re: linux-5.10.11 build failure
To:     Thomas Backlund <tmb@tmb.nu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        torvic9@mailbox.org
References: <8b3e9d93-1381-b415-9ece-a10fb098b896@tmb.nu>
From:   Chris Clayton <chris2553@googlemail.com>
Message-ID: <9617db49-cf67-3b48-1b31-3bcd34cf3e1a@googlemail.com>
Date:   Thu, 28 Jan 2021 13:38:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <8b3e9d93-1381-b415-9ece-a10fb098b896@tmb.nu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks, Thomas.

On 28/01/2021 11:24, Thomas Backlund wrote:
> Den 28.1.2021 kl. 12:05, skrev Chris Clayton:
>>
>> On 28/01/2021 09:34, Greg Kroah-Hartman wrote:
>>> On Thu, Jan 28, 2021 at 09:17:10AM +0000, Chris Clayton wrote:
>>>> Hi,
>>>>
>>>> Building 5.10.11 fails on my (x86-64) laptop thusly:
>>>>
>>>> ..
>>>>
>>>>   AS      arch/x86/entry/thunk_64.o
>>>>    CC      arch/x86/entry/vsyscall/vsyscall_64.o
>>>>    AS      arch/x86/realmode/rm/header.o
>>>>    CC      arch/x86/mm/pat/set_memory.o
>>>>    CC      arch/x86/events/amd/core.o
>>>>    CC      arch/x86/kernel/fpu/init.o
>>>>    CC      arch/x86/entry/vdso/vma.o
>>>>    CC      kernel/sched/core.o
>>>> arch/x86/entry/thunk_64.o: warning: objtool: missing symbol for insn at offset 0x3e
>>>>
>>>>    AS      arch/x86/realmode/rm/trampoline_64.o
>>>> make[2]: *** [scripts/Makefile.build:360: arch/x86/entry/thunk_64.o] Error 255
>>>> make[2]: *** Deleting file 'arch/x86/entry/thunk_64.o'
>>>> make[2]: *** Waiting for unfinished jobs....
>>>>
>>>> ..
>>>>
>>>> Compiler is latest snapshot of gcc-10.
>>>>
>>>> Happy to test the fix but please cc me as I'm not subscribed
>>>
>>> Can you do 'git bisect' to track down the offending commit?
>>>
>>
>> Sure, but I'll hold that request for a while. I updated to binutils-2.36 on Monday and I'm pretty sure that is a feature
>> of this build fail. I've reverted binutils to 2.35.1, and the build succeeds. Updated to 2.36 again and, surprise,
>> surprise, the kernel build fails again.
>>
>> I've had a glance at the binutils ML and there are all sorts of issues being reported, but it's beyond my knowledge to
>> assess if this build error is related to any of them.
>>
>> I'll stick with binutils-2.35.1 for the time being.
>>
>>> And what exact gcc version are you using?
>>>
>>
>>   It's built from the 10-20210123 snapshot tarball.
>>
>> I can report this to the binutils folks, but might it be better if the objtool maintainer looks at it first? The
>> binutils change might just have opened the gate to a bug in objtool.
>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
> 
> 
> AFAIK you need this in stable trees:
> 
>  From 1d489151e9f9d1647110277ff77282fe4d96d09b Mon Sep 17 00:00:00 2001
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> Date: Thu, 14 Jan 2021 16:14:01 -0600
> Subject: [PATCH] objtool: Don't fail on missing symbol table
> 
> 

That may be the caae, but it doesn't fix the build failure I've reported in this thread. However, as suggested by Tor,
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/patch/?id=5e6dca82bcaa49348f9e5fcb48df4881f6d6c4ae does fix it.

That hasn't made Linus' tree yet and I don't see a pull request, but it is in linux-next so I guess it could make it in
-rc6.

Chris
> --
> Thomas
> 
