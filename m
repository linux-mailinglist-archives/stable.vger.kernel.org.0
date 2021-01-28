Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A4E307A42
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 17:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhA1QEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 11:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhA1QET (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 11:04:19 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A54C061573;
        Thu, 28 Jan 2021 08:03:38 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id u14so4738130wml.4;
        Thu, 28 Jan 2021 08:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xfEXjTsyB40epa5HAx10VxFa68/B9Yc8HjeLy1Z8w0c=;
        b=AkIjNt9CVsZu2vaoJ//RaV7Qch3/6PdGJZkQufXHoE7eBw6lVPORKpV8nBaBSN6KG3
         I4c1LdK/iBPhaUvB0RKJAMw0KFzEo0udy96jVtYUmKIN1XQkGmf8KHRujpv8sil1ilby
         z406g1vs6IfWggb5onfN3Ef7Q8RkQcCigZrOGrhGRMkyfallyI/NNsxXAnAVk33EAZqm
         B1BBNWYXY/mrpBNvrFQftgPRmdt4Ae2ojUnn6nRINXwJkBHr795vG4OW9SW413l6gA0C
         XpDGcur0sqHSIkUqqioxuE1wLuLV1TwXxFM8i01foMQuf+Xga7kpuEDvoodRsABsxUVK
         WAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xfEXjTsyB40epa5HAx10VxFa68/B9Yc8HjeLy1Z8w0c=;
        b=jsp2E+q0yCo7IhavZMjxkD/o5j/v8kOob/OxNjacj+8nQ/lV1NtYMOyl5PdveJ4hsi
         nmwtRoGDKXwrn0UYF04tBFa68Yyg8UzKyPNaKdrf8MAniWYhdcPuOnBDyp2OnEVTyIqx
         Z7fkm4Y6cYC8Yx8vkG+eREjXs9Dwi2kUKgDlk7B4ki5WjJ9M4sL0VkZ/x1SNRdBePPay
         8nsZ6cAbpP89WKrgt7o9aaeswebyxvQ0yXBciqXHqZ6v/f5+NNWjTS6XCKiyMKqHyWcY
         NIddeLrGhV4+G8q/JwZVMr5MTKhRT4RSuCAZfFf1c3BJ6TlEO3zkI7n5lhGDH98W5QmV
         h8ew==
X-Gm-Message-State: AOAM530KJgUKXD3Y261x48IoEkPPar8I9706uDbN83iq9z70gObTMG1T
        asD/RFYomi7MLxdb9o+pKMxFIIjFgo0=
X-Google-Smtp-Source: ABdhPJydEyg/ijZlcV8vGJLXFHj74OGaMlwKaFjjfluhIAXN0fOFwaDwz3h1h5bNOjSt4yyfo+Em2A==
X-Received: by 2002:a1c:398b:: with SMTP id g133mr9136009wma.35.1611849817551;
        Thu, 28 Jan 2021 08:03:37 -0800 (PST)
Received: from [192.168.1.20] (5ec062a9.skybroadband.com. [94.192.98.169])
        by smtp.googlemail.com with ESMTPSA id y24sm6207342wmi.47.2021.01.28.08.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 08:03:36 -0800 (PST)
Subject: Re: linux-5.10.11 build failure
To:     Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Backlund <tmb@tmb.nu>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
References: <8b3e9d93-1381-b415-9ece-a10fb098b896@tmb.nu>
 <20210128155222.eu35xflfqlcinu7g@treble>
From:   Chris Clayton <chris2553@googlemail.com>
Message-ID: <fb240045-6a02-9f68-f122-481d044cffa2@googlemail.com>
Date:   Thu, 28 Jan 2021 16:03:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210128155222.eu35xflfqlcinu7g@treble>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 28/01/2021 15:52, Josh Poimboeuf wrote:
> On Thu, Jan 28, 2021 at 11:24:47AM +0000, Thomas Backlund wrote:
>> Den 28.1.2021 kl. 12:05, skrev Chris Clayton:
>>>
>>> On 28/01/2021 09:34, Greg Kroah-Hartman wrote:
>>>> On Thu, Jan 28, 2021 at 09:17:10AM +0000, Chris Clayton wrote:
>>>>> Hi,
>>>>>
>>>>> Building 5.10.11 fails on my (x86-64) laptop thusly:
>>>>>
>>>>> ..
>>>>>
>>>>>   AS      arch/x86/entry/thunk_64.o
>>>>>    CC      arch/x86/entry/vsyscall/vsyscall_64.o
>>>>>    AS      arch/x86/realmode/rm/header.o
>>>>>    CC      arch/x86/mm/pat/set_memory.o
>>>>>    CC      arch/x86/events/amd/core.o
>>>>>    CC      arch/x86/kernel/fpu/init.o
>>>>>    CC      arch/x86/entry/vdso/vma.o
>>>>>    CC      kernel/sched/core.o
>>>>> arch/x86/entry/thunk_64.o: warning: objtool: missing symbol for insn at offset 0x3e
>>>>>
>>>>>    AS      arch/x86/realmode/rm/trampoline_64.o
>>>>> make[2]: *** [scripts/Makefile.build:360: arch/x86/entry/thunk_64.o] Error 255
>>>>> make[2]: *** Deleting file 'arch/x86/entry/thunk_64.o'
>>>>> make[2]: *** Waiting for unfinished jobs....
>>>>>
>>>>> ..
>>>>>
>>>>> Compiler is latest snapshot of gcc-10.
>>>>>
>>>>> Happy to test the fix but please cc me as I'm not subscribed
>>>>
>>>> Can you do 'git bisect' to track down the offending commit?
>>>>
>>>
>>> Sure, but I'll hold that request for a while. I updated to binutils-2.36 on Monday and I'm pretty sure that is a feature
>>> of this build fail. I've reverted binutils to 2.35.1, and the build succeeds. Updated to 2.36 again and, surprise,
>>> surprise, the kernel build fails again.
>>>
>>> I've had a glance at the binutils ML and there are all sorts of issues being reported, but it's beyond my knowledge to
>>> assess if this build error is related to any of them.
>>>
>>> I'll stick with binutils-2.35.1 for the time being.
>>>
>>>> And what exact gcc version are you using?
>>>>
>>>
>>>   It's built from the 10-20210123 snapshot tarball.
>>>
>>> I can report this to the binutils folks, but might it be better if the objtool maintainer looks at it first? The
>>> binutils change might just have opened the gate to a bug in objtool.
>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>
>>
>>
>> AFAIK you need this in stable trees:
>>
>>  From 1d489151e9f9d1647110277ff77282fe4d96d09b Mon Sep 17 00:00:00 2001
>> From: Josh Poimboeuf <jpoimboe@redhat.com>
>> Date: Thu, 14 Jan 2021 16:14:01 -0600
>> Subject: [PATCH] objtool: Don't fail on missing symbol table
> 
> Actually I think you need:
> 
>   5e6dca82bcaa ("x86/entry: Emit a symbol for register restoring thunk")
> 
> I submitted a patch to stable list a few days ago.
> 

Yes, that's what I concluded, Josh. 5.10.11 builds with that patch added but it's not in Linus's tree yet, so, as I
understand it, is not yet a candidate from stable.


> (Though it's possible you need both commits, I'm not sure if binutils
>  2.36 has the symbol stripping stuff)
> 
