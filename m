Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50A16D3D95
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 08:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjDCGva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 02:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDCGv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 02:51:29 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93B7AD04
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 23:51:27 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id j1-20020a05600c1c0100b003f04da00d07so1058251wms.1
        for <stable@vger.kernel.org>; Sun, 02 Apr 2023 23:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680504686;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nb8hMsZoL157aXIKNcdvRKkRTkh4KKenB7HdAyviWGg=;
        b=j5AvQ7aw+jfuQe9QA7St0TuvqSBCPp3SnGq5ZywrBk1Xcejx1HVtTDsGZRexrOrSMy
         7WSkFVMaTcR/do1t6ddTgjkM/z3nQXfsw0Yy/4Wy0DZZJn3GLXZvcWFjTawKu8BozO7d
         jCTC+4gnhIvm4bigQ4dXItyldz5BP8U9gF0aVvaxEP/7NJIMal9YxQxsqGZikECJJiKd
         j/iWZ8NKdAiuckoum79E5lu0W7DNqyEFY9pAq/GV/m6V4X6LzJGLo8bYr+kywDVwxUN8
         ZgEZktYCmqvKm1BALhIgOpzLyZS476ypdvla3syyKxnkOBacDOB98zfEsT3jRUIT4sct
         dKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680504686;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nb8hMsZoL157aXIKNcdvRKkRTkh4KKenB7HdAyviWGg=;
        b=Wemi09ozE9JlKzP4ELKSpn2eBgLyUeuPCZ6kIYtFs9/218PnSkI837WYwmjE1BlAQt
         RcM2vx2PSMuapxdb3YP69FVeoB8NXsoj+PBPMmOBN1HqV/4KsTEUuvBOE0czdm4Nu1Zd
         CSuSiNDavg2yY3iN86FaxZOg3RkgUj/JeMr8qSMUo5jsRrhlIfqxXTqglmidzHDkCyvo
         BrmULYPJuTZffuTKJiBHyCY/UtQSnDsD/2J5a62eKfU7EMeJsLdrM/WCGjNPeA6vRaaZ
         TdiYTB7ncYU84nNoLucJ+SkJhxjCRMrtTDVR27PDIEErYTMaUe3UBtq7KUIDEHbHkoZy
         t8lQ==
X-Gm-Message-State: AO0yUKUNh8ECN4pZ3bQGTi1KRpbiwOBS+KXG/H7TaYquhRzZfjUnqzVR
        G88tYWPUqkZFgNaQd0yZdHXA0g==
X-Google-Smtp-Source: AK7set/7UhL6zASSvYckJ/LnYFdfFtsSyRAbQKxDmgfTrSMFkgMEUJ+qxFQgvS+Th4E/+wmKblZ6kw==
X-Received: by 2002:a7b:cd85:0:b0:3ee:96f0:ea3c with SMTP id y5-20020a7bcd85000000b003ee96f0ea3cmr25721582wmj.7.1680504686213;
        Sun, 02 Apr 2023 23:51:26 -0700 (PDT)
Received: from ?IPV6:2003:f6:af22:1600:2f4c:bf50:182f:1b04? (p200300f6af2216002f4cbf50182f1b04.dip0.t-ipconnect.de. [2003:f6:af22:1600:2f4c:bf50:182f:1b04])
        by smtp.gmail.com with ESMTPSA id b39-20020a05600c4aa700b003ed29189777sm17946698wmp.47.2023.04.02.23.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 23:51:25 -0700 (PDT)
Message-ID: <3ee86615-e8ee-801b-7a12-2f007ffbceea@grsecurity.net>
Date:   Mon, 3 Apr 2023 08:51:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Linux 5.15.103
Content-Language: en-US, de-DE
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        lwn@lwn.net, jslaby@suse.cz,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <1679040264214179@kroah.com>
 <c359c777-c3af-b4a6-791d-d51916160bf5@grsecurity.net>
 <ZCLaLWJiIsDV5yGr@kroah.com>
 <f86cb36e-b331-8b8d-f087-5e2e8a5ae962@grsecurity.net>
 <ZCgwaWSgnUWAPyiv@sashalap>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZCgwaWSgnUWAPyiv@sashalap>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01.04.23 15:23, Sasha Levin wrote:
> On Tue, Mar 28, 2023 at 02:29:11PM +0200, Mathias Krause wrote:
>> On 28.03.23 14:14, Greg Kroah-Hartman wrote:
>>> On Tue, Mar 28, 2023 at 02:02:03PM +0200, Mathias Krause wrote:
>>>> On 17.03.23 09:04, Greg Kroah-Hartman wrote:
>>>>> I'm announcing the release of the 5.15.103 kernel.
>>>>>
>>>>> [...]
>>>>>
>>>>> Vitaly Kuznetsov (4):
>>>>>       KVM: Optimize kvm_make_vcpus_request_mask() a bit
>>>>>       KVM: Pre-allocate cpumasks for
>>>>> kvm_make_all_cpus_request_except()
>>>>>       KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
>>>>>       KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
>>>>>
>>>>
>>>> That list is missing commit 6470accc7ba9 ("KVM: x86: hyper-v: Avoid
>>>> calling kvm_make_vcpus_request_mask() with vcpu_mask==NULL") to fulfill
>>>> the prerequisite of "KVM: Optimize kvm_make_vcpus_request_mask() a
>>>> bit".
>>>>
>>>> Right now the kvm selftests trigger a kernel NULL deref for the hyperv
>>>> test, making the system hang.
>>>>
>>>> Please consider applying commit 6470accc7ba9 for the next v5.15.x
>>>> release.
>>>
>>> It wasn't tagged for the stable kernels, so we didn't pick it up :(
>>
>> Neither were any of the above commits. o.O
>>
>> Commit 3e48a6349d29 ("KVM: Optimize kvm_make_vcpus_request_mask() a
>> bit") has this tag, though:
>>
>> Stable-dep-of: 2b0128127373 ("KVM: Register /dev/kvm as the _very_ last
>> thing during initialization")
>>
>> I don't know why, though. These two commits have little in common.
>> Maybe Sasha knows why?
> 
> Because you've skipped the commit in the middle of the two you've
> pointed out :)
> 
> 3e48a6349d29 is needed by 0a0ecaf0988b ("KVM: Pre-allocate cpumasks for
> kvm_make_all_cpus_request_except()"), which in turn is needed by
> 2b0128127373.

I see, 0a0ecaf0988b is "needed" by 2b0128127373 to make it apply clean.
However, there is no functional dependency for 2b0128127373, as it
simply moves device registration around. By picking all the "required"
commits to make it apply clean, still functional required commits were
missed. :(

A simple backport would probably had been the better solution to the
failed cherry-pick, but I see the original author didn't provide one, so
some kind off fall-back process kicked in to pick up dependent commits.
If these would have been announced more visible than by simply adding
them to the queue, it might had been noticed earlier that a commit is
missing still.

This is probably just another example of maintainer's time being such a
scarce resource problem, but the fallback process isn't working flawless
either :/

Thanks,
Mathias
