Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610CD34B892
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 18:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhC0Rnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 13:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhC0RnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 13:43:08 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DF1C0613B2
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 10:43:08 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id y124-20020a1c32820000b029010c93864955so6451357wmy.5
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 10:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yNxslCOJwZYx+SbKa/upP8KV5ZgrhKAsdDOHz5EQWWM=;
        b=iOVm2RbQPCV69seaL+izj3Bh/O+c+idV03XMwCDg2iHiirkdVubBYmkj553VX0J2ok
         zuShUO2DF47DlNjsapux1l2sQoDajBgT4RsWa0+pLHFe1u0Eac7PzMI+m1CikXRkfEF8
         yJ6kcQ1Lq1RVadI5LDrJyQoIPUtJJIttewRzCdHHO7cj1wDHOQZPUhQ5x9A9LHV0So3q
         z+7xgFoIjzTtqpO8Y2UHpyiQMXt/0DZbW6i3U8ogktx26lN0NKVhMkSHCoMHeQA8pNNk
         oCcqTNHyUyw8Ld7r3TgJyqc2luHHrk7NhfY3V1NB7/KRyhY8zlZ+lajtJbOSqXt3ag4V
         7jOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yNxslCOJwZYx+SbKa/upP8KV5ZgrhKAsdDOHz5EQWWM=;
        b=uZDmLZUQOmCA70I0vHNV+uf8gjQEnT1VDgjV7poWA1z8m2RADBteBZNBiVn8hnCSMN
         2/oz2AWnDGXBXZ/M/P1fEU+GXldpL1GaHw3xJX0xCmhuFKFO1mfgmtSdhoVBpMFSI7lz
         Xn7CCxyKuQdD6hC7JazGnD/nf+6QrftfcMwNLK72ji9PYc+49zagU8dEHaVFsW8fwKjW
         lcnoi2NXXOp0fZmMQFi2otodDcON7tpa1WPgMfJtP5WUGruvvngQiyJO+QjhO7ggOA4M
         /O70QrTBmvZ7q69TFA/66IsmZY8OIow5iZJfh0xb1y3zz1e4eeABbeDA8uI9WeZlrTlz
         i1Wg==
X-Gm-Message-State: AOAM533CrhaztLzp9TayXir3egYL2mNgmk7NDtb6OPgx5EDNpYw18Zdi
        cV5H1cbmMC5DrKwYnr6AjbhTP7wDHeQN5/9n
X-Google-Smtp-Source: ABdhPJxz8erCB49wvD/D6v8ICiz9rIyHy8vRfJ50YOzrz9LIBHUBMGNkAjOtzYj+4k637hV9/bnj4A==
X-Received: by 2002:a05:600c:3553:: with SMTP id i19mr18021218wmq.1.1616866986716;
        Sat, 27 Mar 2021 10:43:06 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id u20sm20705443wru.6.2021.03.27.10.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Mar 2021 10:43:06 -0700 (PDT)
Subject: Re: [PATCH] powerpc/vdso: Separate vvar vma from vdso
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20210326191720.138155-1-dima@arista.com>
 <52562f46-6767-ba04-7301-04c6209fe4f1@csgroup.eu>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <1b1494a8-da80-e170-78fa-48dfb3226e75@arista.com>
Date:   Sat, 27 Mar 2021 17:43:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <52562f46-6767-ba04-7301-04c6209fe4f1@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christophe,

On 3/27/21 5:19 PM, Christophe Leroy wrote:
[..]
>> I opportunistically Cc stable on it: I understand that usually such
>> stuff isn't a stable material, but that will allow us in CRIU have
>> one workaround less that is needed just for one release (v5.11) on
>> one platform (ppc64), which we otherwise have to maintain.
> 
> Why is that a workaround, and why for one release only ? I think the
> solution proposed by Laurentto use the aux vector AT_SYSINFO_EHDR should
> work with any past and future release.

Yeah, I guess.
Previously, (before v5.11/power) all kernels had ELF start at "[vdso]"
VMA start, now we'll have to carry the offset in the VMA. Probably, not
the worst thing, but as it will be only for v5.11 release it can break,
so needs separate testing.
Kinda life was a bit easier without this additional code.

>> I wouldn't go as far as to say that the commit 511157ab641e is ABI
>> regression as no other userspace got broken, but I'd really appreciate
>> if it gets backported to v5.11 after v5.12 is released, so as not
>> to complicate already non-simple CRIU-vdso code. Thanks!
>>
>> Cc: Andrei Vagin <avagin@gmail.com>
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>> Cc: Laurent Dufour <ldufour@linux.ibm.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: linuxppc-dev@lists.ozlabs.org
>> Cc: stable@vger.kernel.org # v5.11
>> [1]: https://github.com/checkpoint-restore/criu/issues/1417
>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>> Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> 
> I tested it with sifreturn_vdso selftest and it worked, because that
> selftest doesn't involve VDSO data.

Thanks again on helping with testing it, I appreciate it!

> But if I do a mremap() on the VDSO text vma without remapping VVAR to
> keep the same distance between the two vmas, gettimeofday() crashes. The
> reason is that the code obtains the address of the data by calculating a
> fix difference from its own address with the below macro, the delta
> being resolved at link time:
> 
> .macro get_datapage ptr
>     bcl    20, 31, .+4
> 999:
>     mflr    \ptr
> #if CONFIG_PPC_PAGE_SHIFT > 14
>     addis    \ptr, \ptr, (_vdso_datapage - 999b)@ha
> #endif
>     addi    \ptr, \ptr, (_vdso_datapage - 999b)@l
> .endm
> 
> So the datapage needs to remain at the same distance from the code at
> all time.
> 
> Wondering how the other architectures do to have two independent VMAs
> and be able to move one independently of the other.

It's alright as far as I know. If userspace remaps vdso/vvar it should
be aware of this (CRIU keeps this in mind, also old vdso image is dumped
to compare on restore with the one that the host has).

Thanks,
          Dmitry
