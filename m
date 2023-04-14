Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F376E1F49
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 11:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjDNJ30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 05:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDNJ3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 05:29:24 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A5F2100
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 02:29:23 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id w24so7230489wra.10
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 02:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681464562; x=1684056562;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KIRaTiGVJHutsxHwytNtnJEYC8NOQXa64IXdr62gYmk=;
        b=vC5WBMuYLwbMg/gPsSvug/5ZKaoP0HJDR2cE6ZryHOt00ZdBBFvlZnbCcWpKcnTrGC
         s9PxyJhj2cBWtZVNeIgEDKm+ekjlS1hNI3zHMKBrJS/TPHE1mfASCuQuThfr/dGYS4YB
         diD7RjvWZ1xFEL0H1KgGe4qlbaPsuDQRzTcBevKgi/Me991emZ93DhLQLsYCaUmwMAUe
         PtyYnCR/l2lfk6hf2SNVH3Go0rlipYuArydqe4IAnynAhWdEWDahDvzXiy5aMz2JORPS
         wM/mducHudwyOKOz/zFjaOGOG2WnF3OxqsYIiuPoctGdyxebvJDORRmBj+wpP/sUGNC0
         d1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681464562; x=1684056562;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KIRaTiGVJHutsxHwytNtnJEYC8NOQXa64IXdr62gYmk=;
        b=LcmYl+WuxZ6pjc7PGXmljdPXathxfyKYZElIlke65lu3uenzn4DNZykp5ERB3KNMTw
         esESGOI5H2rj/N0yCTZO0s9RMJlWdW9UDSpXCT14nllQou8iBKr1XanXq6eCm5EY+vow
         Kqbk9Vpu2elZVcpqGHv989RjelNioo4/KTgeuuBgYod75bp33a7ms8to3cPc/dWyhn6G
         aZqYXQLwXLb26sqODkjTc5ZRfLmp+MOZ//Oe105uC+UkUWpjzmrQHqeY7EoYwkwdaaVW
         XsBd/U/OMr8xNhb0fQZy3iwCfH97AfCq4J7nKkkpxSM6zvtovVLW2GoWh72uVVsKSJan
         eb/Q==
X-Gm-Message-State: AAQBX9fWrYqCEnIGjuYHLB6gGxoBTmeldOxPeJx3bZVui+5sZBvVldLG
        SKnj3W73E0NWSnOUU2/k7LSpPw==
X-Google-Smtp-Source: AKy350Yld6S7prtEH2My94k4mNWRvHKrCSm4/MIqG1e3Qa0OAQuJ4tY2NxQ0giMdPl1CpwyEBQdBrA==
X-Received: by 2002:a5d:6a82:0:b0:2f4:311:c877 with SMTP id s2-20020a5d6a82000000b002f40311c877mr3949522wru.34.1681464561834;
        Fri, 14 Apr 2023 02:29:21 -0700 (PDT)
Received: from ?IPV6:2003:f6:af15:b900:825b:a446:cb0c:8607? (p200300f6af15b900825ba446cb0c8607.dip0.t-ipconnect.de. [2003:f6:af15:b900:825b:a446:cb0c:8607])
        by smtp.gmail.com with ESMTPSA id n8-20020a5d4c48000000b002f587f6c9b2sm3114366wrt.107.2023.04.14.02.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 02:29:21 -0700 (PDT)
Message-ID: <026dcbfe-a306-85c3-600e-17cae3d3b7c5@grsecurity.net>
Date:   Fri, 14 Apr 2023 11:29:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP
 users
Content-Language: en-US, de-DE
From:   Mathias Krause <minipli@grsecurity.net>
To:     Sean Christopherson <seanjc@google.com>, Greg KH <greg@kroah.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        stable@vger.kernel.org
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <167949641597.2215962.13042575709754610384.b4-ty@google.com>
 <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net>
 <ZB7oKD6CHa6f2IEO@kroah.com> <ZC4tocf+PeuUEe4+@google.com>
 <0c47acc0-1f13-ebe5-20e5-524e5b6930e3@grsecurity.net>
In-Reply-To: <0c47acc0-1f13-ebe5-20e5-524e5b6930e3@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06.04.23 15:22, Mathias Krause wrote:
> On 06.04.23 04:25, Sean Christopherson wrote:
>> On Sat, Mar 25, 2023, Greg KH wrote:
>>> On Sat, Mar 25, 2023 at 12:39:59PM +0100, Mathias Krause wrote:
>>>> As this is a huge performance fix for us, we'd like to get it integrated
>>>> into current stable kernels as well -- not without having the changes
>>>> get some wider testing, of course, i.e. not before they end up in a
>>>> non-rc version released by Linus. But I already did a backport to 5.4 to
>>>> get a feeling how hard it would be and for the impact it has on older
>>>> kernels.
>>>>
>>>> Using the 'ssdd 10 50000' test I used before, I get promising results
>>>> there as well. Without the patches it takes 9.31s, while with them we're
>>>> down to 4.64s. Taking into account that this is the runtime of a
>>>> workload in a VM that gets cut in half, I hope this qualifies as stable
>>>> material, as it's a huge performance fix.
>>>>
>>>> Greg, what's your opinion on it? Original series here:
>>>> https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/
>>>
>>> I'll leave the judgement call up to the KVM maintainers, as they are the
>>> ones that need to ack any KVM patch added to stable trees.
>>
>> These are quite risky to backport.  E.g. we botched patch 6[*], and my initial
>> fix also had a subtle bug.  There have also been quite a few KVM MMU changes since
>> 5.4, so it's possible that an edge case may exist in 5.4 that doesn't exist in
>> mainline.
> 
> I totally agree. Getting the changes to work with older kernels needs
> more work. The MMU role handling was refactored in 5.14 and down to 5.4
> it differs even more, so backports to earlier kernels definitely needs
> more care.
> 
> My plan would be to limit backporting of the whole series to kernels
> down to 5.15 (maybe 5.10 if it turns out to be doable) and for kernels
> before that only without patch 6. That would leave out the problematic
> change but still give us the benefits of dropping the needless mmu
> unloads for only toggling CR0.WP in the VM. This already helps us a lot!

To back up the "helps us a lot" with some numbers, here are the results
I got from running the 'ssdd 10 50000' micro-benchmark on the backports
I did, running on a grsecurity L1 VM (host is a vanilla kernel, as
stated below; runtime in seconds, lower is better):

                          legacy     TDP    shadow
    Linux v5.4.240          -        8.87s   56.8s
    + patches               -        5.84s   55.4s

    Linux v5.10.177       10.37s    88.7s    69.7s
    + patches              4.88s     4.92s   70.1s

    Linux v5.15.106        9.94s    66.1s    64.9s
    + patches              4.81s     4.79s   64.6s

    Linux v6.1.23          7.65s    8.23s    68.7s
    + patches              3.36s    3.36s    69.1s

    Linux v6.2.10          7.61s    7.98s    68.6s
    + patches              3.37s    3.41s    70.2s

I guess we can grossly ignore the shadow MMU numbers, beside noting them
to regress from v5.4 to v5.10 (something to investigate?). The backports
don't help (much) for shadow MMU setups and the flux in the measurements
is likely related to the slab allocations involved.

Another unrelated data point is that TDP MMU is really broken for our
use case on v5.10 and v5.15 -- it's even slower that shadow paging!

OTOH, the backports give nice speed-ups, ranging from ~2.2 times faster
for pure EPT (legacy) MMU setups up to 18(!!!) times faster for TDP MMU
on v5.10.

I backported the whole series down to v5.10 but left out the CR0.WP
guest owning patch+fix for v5.4 as the code base is too different to get
all the nuances right, as Sean already hinted. However, even this
limited backport provides a big performance fix for our use case!

Thanks,
Mathias
