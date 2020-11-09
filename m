Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADFD2AAE95
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 01:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgKIAru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 19:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbgKIArt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 19:47:49 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00332C0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 16:47:47 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id l36so7390687ota.4
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 16:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yySy3DFm44bx8rXiZiyOPTRRQVp4AGQNae89TK6O29M=;
        b=cZex2lw9wSeONoER664yALe/YTwPmHVv50E+hV5ihyXV/elXXCaDgJUrYdecAKTQie
         3/s6Bw/6mdZ881WrnrUpmTp5nS+7d8zwyafaHAP2rKJrBtEd3nmh6XFwNubT8PbyWw24
         n4Yn0GgK1FdKzivNJQDsRGX+9Ay/L5IZGp6mAATPbgwvJrtQtDkg6s3rKyQRIx3hOyC2
         WbRVa0WopAL4AdoElJ+f7v3rlMIvpTO4+lg6HxzqbLXG1co0fpQV5Mw7B8cNRarp8cAA
         AjfTY/waW49kA+l1aR6xWlEI4ZwHa1ZfgqE1oA1/euvmTTOmIOEB+v8p/8SPlhryDY8Y
         0w7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=yySy3DFm44bx8rXiZiyOPTRRQVp4AGQNae89TK6O29M=;
        b=ia0Brp8sTG2rJvMTIWPUKSqxjgVxozO6dVqT9gN7SeBQVYF/ryGXALi+fB3uBPT5Ol
         BwuZsTwqR8JXNmQqldFSlWlD1Md/aSK9Q8tFaW4btL2y+IPvWQ2x7CQkhQRxytkBaQG3
         VIIPI6fhcoZJg2o5DdWuor3XDaxa2ss2b925+ECNPElCzVVcqsBYBT2qYknrSMsyj/6C
         0R9AkfDdgR7yodo2u6S2yAgT3EujRIDs5xWFm9QYl4WxzfjjQx5RyBZumVb56o8Bucx/
         c5Tw9zJHHsVop3nHolqaW33TItHVAZ5bB1t+R9mBvvP02K4ojUbKDfbvtN1cgM0JddJA
         P3/g==
X-Gm-Message-State: AOAM530TFuHNIvl6cAQwNKRQrC3tiK+CYh5Hy3PrJqQhxr1b0+Sq0pdG
        OcDabLgsVdRDGE/E+WWJCMCm0x4mI8I=
X-Google-Smtp-Source: ABdhPJwAfPomXNRuZTAqP7CZq36BguRpim6GE3Lit11JyqvKmnv3XSHfTrYBA2Sf6hpGI3SxBBDBdw==
X-Received: by 2002:a9d:760c:: with SMTP id k12mr8889634otl.52.1604882866797;
        Sun, 08 Nov 2020 16:47:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i8sm2148415otl.60.2020.11.08.16.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 16:47:46 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: build failures in v4.4.y stable queue
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20201104141230.GC4312@roeck-us.net>
 <20201104143709.GC2202359@kroah.com> <20201104161817.GG2092@sasha-vm>
 <1fc37180-ad6f-d2b7-7921-77e9c271ebb0@roeck-us.net>
 <20201109001955.GS2092@sasha-vm>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <48bf5e65-115e-45b7-39f2-110542a650ff@roeck-us.net>
Date:   Sun, 8 Nov 2020 16:47:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201109001955.GS2092@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/20 4:19 PM, Sasha Levin wrote:
> On Wed, Nov 04, 2020 at 06:34:50PM -0800, Guenter Roeck wrote:
>> On 11/4/20 8:18 AM, Sasha Levin wrote:
>>> On Wed, Nov 04, 2020 at 03:37:09PM +0100, Greg KH wrote:
>>>> On Wed, Nov 04, 2020 at 06:12:30AM -0800, Guenter Roeck wrote:
>>>>> Building ia64:defconfig ... failed
>>>>> --------------
>>>>> Error log:
>>>>> drivers/acpi/numa.c: In function 'pxm_to_node':
>>>>> drivers/acpi/numa.c:49:43: error: 'numa_off' undeclared
>>>>
>>>> Caused by 8a3decac087a ("ACPI: Add out of bounds and numa_off
>>>> protections to pxm_to_node()"), I'll go drop it.
>>>>
>>>> Sasha, you didn't queue this up to 4.9, but you did to 4.4?
>>>>
>>>>>
>>>>> Building powerpc:defconfig ... failed
>>>>> --------------
>>>>> Error log:
>>>>> arch/powerpc/kvm/book3s_hv.c: In function ‘kvm_arch_vm_ioctl_hv’:
>>>>> arch/powerpc/kvm/book3s_hv.c:3161:7: error: implicit declaration of function ‘kvmhv_on_pseries’
>>>>
>>>> Caused by 05e6295dc7de ("KVM: PPC: Book3S HV: Do not allocate HPT for a
>>>> nested guest"), I'll go drop this.
>>>>
>>>> Sasha, why did you only queue this up to 4.4 and 5.4 and 5.9 and not the
>>>> middle queues as well?
>>>
>>> Originally it got queued everywhere, but then it looks like I dropped it
>>> from 4.9-4.19 because of build failures, but it seems that the 4.4
>>> failure wasn't detected.
>>>
>>> Looking into why, it seems that my baseline for that build also fails
>>> for some reason:
>>>
>>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
>>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:1603: Warning: invalid register expression
>>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:1644: Warning: invalid register expression
>>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:839: Error: attempt to move .org backwards
>>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:840: Error: attempt to move .org backwards
>>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:864: Error: attempt to move .org backwards
>>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:865: Error: attempt to move .org backwards
>>> make[2]: *** [/home/sasha/data/linux/scripts/Makefile.build:375: arch/powerpc/kernel/head_64.o] Error 1
>>> make[1]: *** [/home/sasha/data/linux/Makefile:1006: arch/powerpc/kernel] Error 2
>>>
>>> I think that I'll rebuild my toolchain for powerpc and redo the baseline
>>> builds, sorry about that.
>>>
>>
>> Is that an allmodconfig build ? That simply won't build in 4.4.y because
>> exceptions-64s.S is too large there.
> 
> But only on 4.4, and not on 4.9+? sheesh...
> 

The file was rearranged in later kernel versions. I tried a long time ago
to find a minimum set of necessary patches to apply, but gave up after
a while. Feel free to give it a try yourself :-)

Guenter
