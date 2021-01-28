Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041FE3079E9
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 16:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhA1PhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 10:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhA1PhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 10:37:16 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF67C061573;
        Thu, 28 Jan 2021 07:36:36 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id 7so5861595wrz.0;
        Thu, 28 Jan 2021 07:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JUSXPAcZpYFboireb0m7TBuhyPLVreIiYf7/0cW+maw=;
        b=UjhWg6MfPEwcyOIn8dK/YKDlGodesx5niqocyRPJp4TAr7CPY5Egg/IvSIZspq7Th+
         GsnFTvkKlLHVacVcttr0uWCs3vq2Fmqsn313yXXkOTxF77T3VejMGrXM3f7Dl0noQ7VA
         c0csUj+I2f36b+qjnxsUnG7/9lURVqY/Lq5VUva4kKVZUH7ZkxefcurIZpF+9VUH0aOE
         X0H81RbEMl9Ahf0Ip2Ylm3k63IYu4mH1O95/prrsk0mEse7IZm+8F9Ks+9wS5GZ2c3A/
         angilZgj/RX+syidO+ieu1hjsoHHLxd7gtLBCskAbic6dQWuG2kIMy8yTymkc5ZRV5fT
         D0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JUSXPAcZpYFboireb0m7TBuhyPLVreIiYf7/0cW+maw=;
        b=H0M16sZ8inutdudaMnfiAjw0YB9pSQdAhBk9zi6EUr0aWThrI+zU9i1EvNrmalJa4k
         synkkxWLJc/TT1Ig5MH7E9IohMMrxzmAxbVQTa47ynfPzHh3CxW756r+utqd6HZlh6zy
         c2kNVB00U8+SOSsauJdMRQq6CyGkpSF8DJ3WlGkvJxZQiDbSuG5TNANNKtMsmoI/PHNo
         BLElZTux4iDdJPl3siYf4cYWC2F4yDcrFxf3m1zgqNKdZyT4+LMUpMIyYgGPxX1Htbro
         aBtB1s3QrOSRtaGM6CmF2RIZEp86Jt8jWcQVWKHoN6DWgkXXNL/mqXka/04EIGa6XBRY
         L8/g==
X-Gm-Message-State: AOAM5335ThojEbZbPAVcGlbs2flPstRAmvXGxT98z/BwPKPO38aViVGu
        M/WMQrppfHgzryqsn2tVyMlarqrrZQw=
X-Google-Smtp-Source: ABdhPJy/c2i+vh7LCwVmpROWhrNhc2vzpPkPaOzTeusofAJsx3N5v3HiNki9jIaqLz1c1To802IqRw==
X-Received: by 2002:adf:df0a:: with SMTP id y10mr16755182wrl.214.1611848195189;
        Thu, 28 Jan 2021 07:36:35 -0800 (PST)
Received: from [192.168.1.20] (5ec062a9.skybroadband.com. [94.192.98.169])
        by smtp.googlemail.com with ESMTPSA id t18sm3350243wrr.56.2021.01.28.07.36.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 07:36:34 -0800 (PST)
Subject: Re: linux-5.10.11 build failure
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thomas Backlund <tmb@tmb.nu>, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, torvic9@mailbox.org
References: <8b3e9d93-1381-b415-9ece-a10fb098b896@tmb.nu>
 <9617db49-cf67-3b48-1b31-3bcd34cf3e1a@googlemail.com>
 <YBLNMBmsrmD7HfY6@kroah.com>
From:   Chris Clayton <chris2553@googlemail.com>
Message-ID: <91d85291-cad3-6498-15ab-be70b5adb502@googlemail.com>
Date:   Thu, 28 Jan 2021 15:36:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YBLNMBmsrmD7HfY6@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 28/01/2021 14:41, Greg Kroah-Hartman wrote:
> On Thu, Jan 28, 2021 at 01:38:25PM +0000, Chris Clayton wrote:
>> Thanks, Thomas.
>>
>> On 28/01/2021 11:24, Thomas Backlund wrote:
>>> Den 28.1.2021 kl. 12:05, skrev Chris Clayton:
>>>>
>>>> On 28/01/2021 09:34, Greg Kroah-Hartman wrote:
>>>>> On Thu, Jan 28, 2021 at 09:17:10AM +0000, Chris Clayton wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Building 5.10.11 fails on my (x86-64) laptop thusly:
>>>>>>
>>>>>> ..
>>>>>>
>>>>>>   AS      arch/x86/entry/thunk_64.o
>>>>>>    CC      arch/x86/entry/vsyscall/vsyscall_64.o
>>>>>>    AS      arch/x86/realmode/rm/header.o
>>>>>>    CC      arch/x86/mm/pat/set_memory.o
>>>>>>    CC      arch/x86/events/amd/core.o
>>>>>>    CC      arch/x86/kernel/fpu/init.o
>>>>>>    CC      arch/x86/entry/vdso/vma.o
>>>>>>    CC      kernel/sched/core.o
>>>>>> arch/x86/entry/thunk_64.o: warning: objtool: missing symbol for insn at offset 0x3e
>>>>>>
>>>>>>    AS      arch/x86/realmode/rm/trampoline_64.o
>>>>>> make[2]: *** [scripts/Makefile.build:360: arch/x86/entry/thunk_64.o] Error 255
>>>>>> make[2]: *** Deleting file 'arch/x86/entry/thunk_64.o'
>>>>>> make[2]: *** Waiting for unfinished jobs....
>>>>>>
>>>>>> ..
>>>>>>
>>>>>> Compiler is latest snapshot of gcc-10.
>>>>>>
>>>>>> Happy to test the fix but please cc me as I'm not subscribed
>>>>>
>>>>> Can you do 'git bisect' to track down the offending commit?
>>>>>
>>>>
>>>> Sure, but I'll hold that request for a while. I updated to binutils-2.36 on Monday and I'm pretty sure that is a feature
>>>> of this build fail. I've reverted binutils to 2.35.1, and the build succeeds. Updated to 2.36 again and, surprise,
>>>> surprise, the kernel build fails again.
>>>>
>>>> I've had a glance at the binutils ML and there are all sorts of issues being reported, but it's beyond my knowledge to
>>>> assess if this build error is related to any of them.
>>>>
>>>> I'll stick with binutils-2.35.1 for the time being.
>>>>
>>>>> And what exact gcc version are you using?
>>>>>
>>>>
>>>>   It's built from the 10-20210123 snapshot tarball.
>>>>
>>>> I can report this to the binutils folks, but might it be better if the objtool maintainer looks at it first? The
>>>> binutils change might just have opened the gate to a bug in objtool.
>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>>
>>>>
>>>
>>>
>>> AFAIK you need this in stable trees:
>>>
>>>  From 1d489151e9f9d1647110277ff77282fe4d96d09b Mon Sep 17 00:00:00 2001
>>> From: Josh Poimboeuf <jpoimboe@redhat.com>
>>> Date: Thu, 14 Jan 2021 16:14:01 -0600
>>> Subject: [PATCH] objtool: Don't fail on missing symbol table
>>>
>>>
>>
>> That may be the caae, but it doesn't fix the build failure I've reported in this thread. However, as suggested by Tor,
>> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/patch/?id=5e6dca82bcaa49348f9e5fcb48df4881f6d6c4ae does fix it.
>>
>> That hasn't made Linus' tree yet and I don't see a pull request, but it is in linux-next so I guess it could make it in
>> -rc6.
> 
> Ok, thanks, so this is not a new regression for 5.10.y.
> 

That seems to be the case, Greg. Neither 5.10.10 nor 5.10.9 build either.

> greg k-h
> 
