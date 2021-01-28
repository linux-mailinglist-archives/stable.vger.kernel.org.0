Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F373E307363
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 11:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhA1KGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 05:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhA1KG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 05:06:29 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAB1C061573;
        Thu, 28 Jan 2021 02:05:45 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m1so799721wml.2;
        Thu, 28 Jan 2021 02:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kBCcVC0SZ3UIXIu4hu72Rj9+3Dd8kHErgQA4UPujZrs=;
        b=T3lzVsHMLs2U7sP8Oo0/0DWUlkbNttHUeNH6jsIrKyQmdNO+PVvkwe5VqwASF4WAQj
         BSUjdTAkpdgY3aVbDhfx5UDCU3nC9qnqIfmodkGTpgy7CsdjFXoM5qGApOd0AOjKwn0T
         vvsfWJeOBKEXLpL4gYer+Av0X2KElnbxDAeU2fssw562ql+9PM7LlgZhQlA48877mThU
         Ebp90CmBfIF1h2DFN6XLjWBDSTq3Vb2WdnpDzzKit5fPTCbAxkJskXFFjs8YxHNp23nl
         NqUgZ3jMm2Xy4VfG4P8IVfzT7dEEB1NSffOUoGrdmvgsGLVCpAEwVNbK7/uhR0J2CCSM
         bebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kBCcVC0SZ3UIXIu4hu72Rj9+3Dd8kHErgQA4UPujZrs=;
        b=WrUUNCmfWjOOLYM5uv9teENoV1hwBEnk0yKwJBTTdgiSya0XtfEtdJyGKY/iBHho6R
         INni+4ZbNCVt7+g4DkGQN1Y/kl6m1p3zG8VYOULHGsEvUC3wwcUjlK9t6cjDX/P3RQJl
         F73S9Et8YQTIB+ChMwCKi9U/iBpqax+RgQc6pM6JF09W2wK/tF4hJ5IagK7DrccAaTzl
         4RXOa7el5pwHpdkx+dXIFNDo5QqcTXgQKzDVhg1d/LfqBhhwC+PGMpZZDoMgddgB3KcG
         9PWrQNjE9TccZkIzC9e1J9wKULoEO2WzsrpDVdPJTS4SG4xu9zUPKkCE3KgrEoLRBD/g
         aWSA==
X-Gm-Message-State: AOAM530sG+iCyoiNNAoteNFRAvEHUn2JPoNl/waLvruwqrUVmJitQLP5
        5u6bYfuv9YFC2bEoau6MaOfNKJfusww=
X-Google-Smtp-Source: ABdhPJwrFGEC64XsGK1Z3Zcdt2iTuumJ900it1s3bmjvyCqRvyHy5YdHpgm95AxEG0qQRtJ+To0mSA==
X-Received: by 2002:a7b:ca4d:: with SMTP id m13mr8258014wml.28.1611828344550;
        Thu, 28 Jan 2021 02:05:44 -0800 (PST)
Received: from [192.168.1.20] (5ec062a9.skybroadband.com. [94.192.98.169])
        by smtp.googlemail.com with ESMTPSA id s4sm5406454wme.38.2021.01.28.02.05.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 02:05:43 -0800 (PST)
Subject: Re: linux-5.10.11 build failure
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
References: <f141f12d-a5b9-1e60-2740-388bf350b631@googlemail.com>
 <YBKFNUp5WYtdg9pE@kroah.com>
From:   Chris Clayton <chris2553@googlemail.com>
Message-ID: <fef32b91-89fe-64b8-fe57-d681db29f86e@googlemail.com>
Date:   Thu, 28 Jan 2021 10:05:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YBKFNUp5WYtdg9pE@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 28/01/2021 09:34, Greg Kroah-Hartman wrote:
> On Thu, Jan 28, 2021 at 09:17:10AM +0000, Chris Clayton wrote:
>> Hi,
>>
>> Building 5.10.11 fails on my (x86-64) laptop thusly:
>>
>> ..
>>
>>  AS      arch/x86/entry/thunk_64.o
>>   CC      arch/x86/entry/vsyscall/vsyscall_64.o
>>   AS      arch/x86/realmode/rm/header.o
>>   CC      arch/x86/mm/pat/set_memory.o
>>   CC      arch/x86/events/amd/core.o
>>   CC      arch/x86/kernel/fpu/init.o
>>   CC      arch/x86/entry/vdso/vma.o
>>   CC      kernel/sched/core.o
>> arch/x86/entry/thunk_64.o: warning: objtool: missing symbol for insn at offset 0x3e
>>
>>   AS      arch/x86/realmode/rm/trampoline_64.o
>> make[2]: *** [scripts/Makefile.build:360: arch/x86/entry/thunk_64.o] Error 255
>> make[2]: *** Deleting file 'arch/x86/entry/thunk_64.o'
>> make[2]: *** Waiting for unfinished jobs....
>>
>> ..
>>
>> Compiler is latest snapshot of gcc-10.
>>
>> Happy to test the fix but please cc me as I'm not subscribed
> 
> Can you do 'git bisect' to track down the offending commit?
> 

Sure, but I'll hold that request for a while. I updated to binutils-2.36 on Monday and I'm pretty sure that is a feature
of this build fail. I've reverted binutils to 2.35.1, and the build succeeds. Updated to 2.36 again and, surprise,
surprise, the kernel build fails again.

I've had a glance at the binutils ML and there are all sorts of issues being reported, but it's beyond my knowledge to
assess if this build error is related to any of them.

I'll stick with binutils-2.35.1 for the time being.

> And what exact gcc version are you using?
>

 It's built from the 10-20210123 snapshot tarball.

I can report this to the binutils folks, but might it be better if the objtool maintainer looks at it first? The
binutils change might just have opened the gate to a bug in objtool.

> thanks,
> 
> greg k-h
> 

Thanks.

Chris
