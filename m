Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0626C8D83
	for <lists+stable@lfdr.de>; Sat, 25 Mar 2023 12:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCYLkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Mar 2023 07:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYLkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Mar 2023 07:40:02 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017A846BD
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 04:40:00 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id cn12so17589607edb.4
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 04:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679744399;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wd22/vWONbk3WUNNM+gvXjr7Gccl9dW9XU0Mq3slivY=;
        b=r6s2yXd2bBH1EqHJYdtcDsuBLBQKjFL9x6YLEJzvx09P836Eqj40BGf64OzxddtJZW
         d5nuh84qpxIRYVLeqGuv0yChoVP9l3qXyV0KPsKE0yW+82V245yx5He1OyRpbgfM+Jrs
         aS/eRroy0GJmMCx7A8UdmlWu/zuG1+ivol8YBHsIcxryI+z+2AA9XUx0ZZ6SXh+H/Nqj
         die29i/NzZ7Trd7oaklZU08XA6hty6eE732H4cVbAhygnexRKA//+p3NEmmvUtqtiYQb
         a0j1c8Tn1mnwE/12x7KJffMG6otQbExpIRaCvZpXmjM5d9M0LQsrG4uPLUhySbcbJ5Cv
         +uJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679744399;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wd22/vWONbk3WUNNM+gvXjr7Gccl9dW9XU0Mq3slivY=;
        b=H3Dti8xONMcfYBQl/ft3pNMZJfYquJa0OMSbRS7jR68PqWR8wuzSlVPgnSBjql7c7e
         J8zqhBTQI0+YIsuJO5XdYROKVaxkpX/SYPcoDS6eZS9oWwdnxW8VxA49WlPtFyR14LUC
         8c+ing3ENBj6nPUbBrK0Sbzv/mHfCL670D50sPQFAFfgJjI8cVgmsAZgT9Vybixn21Be
         nX/YDFaIfAuZj+iYftLb6rOgwsxQ0xw+INruyLcS1CDh7wLMLScLCzahdu+k78Zixk2a
         ZhBumOnzC/W0y1Cv8DpDahzVVqm+sjGdQoGiPY+v6X0/WgqWeTP6RQOX0rpMuynLHPNW
         1zNQ==
X-Gm-Message-State: AO0yUKXrvxELqgRuypy1dPzyuAosbBMxE1EUTjIbwpwTfhiOvWKvRsf2
        MD5Ko8zoDvl+56+GgQpqaV4nJw==
X-Google-Smtp-Source: AK7set/I3OX5IAinZfWSdKlR+CGDrxYPIiN3UgRjXO7KTuweqEtrJjU2Neg3OqKsbrcFLO/tnj893w==
X-Received: by 2002:a05:6402:5d87:b0:4af:740d:fde with SMTP id if7-20020a0564025d8700b004af740d0fdemr10673310edb.20.1679744399470;
        Sat, 25 Mar 2023 04:39:59 -0700 (PDT)
Received: from ?IPV6:2003:f6:af27:200:4bd7:14cf:98bf:224e? (p200300f6af2702004bd714cf98bf224e.dip0.t-ipconnect.de. [2003:f6:af27:200:4bd7:14cf:98bf:224e])
        by smtp.gmail.com with ESMTPSA id v1-20020a50d581000000b0050234b3fecesm492649edi.73.2023.03.25.04.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Mar 2023 04:39:59 -0700 (PDT)
Message-ID: <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net>
Date:   Sat, 25 Mar 2023 12:39:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP
 users
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>, Greg KH <greg@kroah.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        stable@vger.kernel.org
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <167949641597.2215962.13042575709754610384.b4-ty@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <167949641597.2215962.13042575709754610384.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.03.23 23:50, Sean Christopherson wrote:
> On Wed, 22 Mar 2023 02:37:25 +0100, Mathias Krause wrote:
>> v3: https://lore.kernel.org/kvm/20230201194604.11135-1-minipli@grsecurity.net/
>>
>> This series is the fourth iteration of resurrecting the missing pieces of
>> Paolo's previous attempt[1] to avoid needless MMU roots unloading.
>>
>> It's incorporating Sean's feedback to v3 and rebased on top of
>> kvm-x86/next, namely commit d8708b80fa0e ("KVM: Change return type of
>> kvm_arch_vm_ioctl() to "int"").
>>
>> [...]
> 
> Applied 1 and 5 to kvm-x86 mmu, and the rest to kvm-x86 misc, thanks!
> 
> [1/6] KVM: x86/mmu: Avoid indirect call for get_cr3
>       https://github.com/kvm-x86/linux/commit/2fdcc1b32418
> [2/6] KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
>       https://github.com/kvm-x86/linux/commit/01b31714bd90
> [3/6] KVM: x86: Ignore CR0.WP toggles in non-paging mode
>       https://github.com/kvm-x86/linux/commit/e40bcf9f3a18
> [4/6] KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
>       https://github.com/kvm-x86/linux/commit/74cdc836919b
> [5/6] KVM: x86/mmu: Fix comment typo
>       https://github.com/kvm-x86/linux/commit/50f13998451e
> [6/6] KVM: VMX: Make CR0.WP a guest owned bit
>       https://github.com/kvm-x86/linux/commit/fb509f76acc8

Thanks a lot, Sean!

As this is a huge performance fix for us, we'd like to get it integrated
into current stable kernels as well -- not without having the changes
get some wider testing, of course, i.e. not before they end up in a
non-rc version released by Linus. But I already did a backport to 5.4 to
get a feeling how hard it would be and for the impact it has on older
kernels.

Using the 'ssdd 10 50000' test I used before, I get promising results
there as well. Without the patches it takes 9.31s, while with them we're
down to 4.64s. Taking into account that this is the runtime of a
workload in a VM that gets cut in half, I hope this qualifies as stable
material, as it's a huge performance fix.

Greg, what's your opinion on it? Original series here:
https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/

Thanks,
Mathias
