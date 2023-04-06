Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C78C6D9813
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 15:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238558AbjDFNXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 09:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238588AbjDFNXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 09:23:24 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7560393ED
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 06:23:01 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id g18so1356290ejx.7
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 06:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680787377;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ttt1Wrk11aqssHXvE6bPBSAFizYrCoyDM1ispHOs5pE=;
        b=hr+2Jx6wTreFTthuQzBFI7Qv6XG0rGQU4nd3RHjPonfrU9JWhSi4RK05HIvzecLXWA
         /PLpcvlVS0BY+RoRn68fpdolVJqoxP/64FGDQXhPe+88Z686UjSjL6awrti/8Qe0+BqN
         pvZmOL4kfIBLUBDz/7/BXLsXT6aEre6BluGMpFzgh2+8ydUFZFssIWQ3XB0Q90zKOyDM
         2/SlrYbb0iYxyaDDOd8FM7nJcrVN7eOQuwTK2CZSiMwdVTDQYwGyz8YEU9R9V57vH5oC
         +NKE/Q2K61QLgDFxwGMoB2WUjDhMuepjavqvwbCYvYsu9wB9SZI0TaQOILYRhH5K43xu
         Ivaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787377;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ttt1Wrk11aqssHXvE6bPBSAFizYrCoyDM1ispHOs5pE=;
        b=Ghb4PYAg4OfG4WAuFQX0PAfNAVfsmjQtk8aEqdslp3olGlgA+3QDBJClLjifYsIcny
         E34bA3CcbAlGuxEuZoZwE6y7V+fmSKFOXvlfM9OrszFkJB1JLm8xAcmBkwqbn1kjhBYz
         RBzmKLM27jnj+NAcuf3PEbayGp35sCTiHVQCB7PP7GRrZfwN56B7Mw3Ymx37+RLiUml5
         xje68Ox/iBF/+2v2HBa1Q9fmttKe4L86wKmx+iyE6SyP5l4CvFwG9Ej3WmMb4UFY8FRe
         SdtQ0c0KP+AaCSZn6tKj3uOMQjg5c9HTLZvLgstIRhhc//uyOqxRmz+OarfAa6PXfV6s
         b/cg==
X-Gm-Message-State: AAQBX9eKJSjEm8UfByJ7urJVpD+4VgUo9EYo7yDHYDrmSPKwdIhvK+Th
        eIIS3auuaR1ySF/EK9qKIKgAXI/HDL3WhIuT9oI=
X-Google-Smtp-Source: AKy350aaN9DxenSE+w3yUdr0k1oz+UymL0vJWEsoXz6gM+usLKKqCJfvHtum3Vi8suAK2SABz/qLfw==
X-Received: by 2002:a17:906:ccc6:b0:8b1:2c37:ae97 with SMTP id ot6-20020a170906ccc600b008b12c37ae97mr5506972ejb.43.1680787377618;
        Thu, 06 Apr 2023 06:22:57 -0700 (PDT)
Received: from ?IPV6:2003:f6:af05:3700:e3dd:8565:18f3:3982? (p200300f6af053700e3dd856518f33982.dip0.t-ipconnect.de. [2003:f6:af05:3700:e3dd:8565:18f3:3982])
        by smtp.gmail.com with ESMTPSA id ho11-20020a1709070e8b00b0093ebc654f78sm817622ejc.25.2023.04.06.06.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 06:22:57 -0700 (PDT)
Message-ID: <0c47acc0-1f13-ebe5-20e5-524e5b6930e3@grsecurity.net>
Date:   Thu, 6 Apr 2023 15:22:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP
 users
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>, Greg KH <greg@kroah.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        stable@vger.kernel.org
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <167949641597.2215962.13042575709754610384.b4-ty@google.com>
 <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net>
 <ZB7oKD6CHa6f2IEO@kroah.com> <ZC4tocf+PeuUEe4+@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZC4tocf+PeuUEe4+@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06.04.23 04:25, Sean Christopherson wrote:
> On Sat, Mar 25, 2023, Greg KH wrote:
>> On Sat, Mar 25, 2023 at 12:39:59PM +0100, Mathias Krause wrote:
>>> As this is a huge performance fix for us, we'd like to get it integrated
>>> into current stable kernels as well -- not without having the changes
>>> get some wider testing, of course, i.e. not before they end up in a
>>> non-rc version released by Linus. But I already did a backport to 5.4 to
>>> get a feeling how hard it would be and for the impact it has on older
>>> kernels.
>>>
>>> Using the 'ssdd 10 50000' test I used before, I get promising results
>>> there as well. Without the patches it takes 9.31s, while with them we're
>>> down to 4.64s. Taking into account that this is the runtime of a
>>> workload in a VM that gets cut in half, I hope this qualifies as stable
>>> material, as it's a huge performance fix.
>>>
>>> Greg, what's your opinion on it? Original series here:
>>> https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/
>>
>> I'll leave the judgement call up to the KVM maintainers, as they are the
>> ones that need to ack any KVM patch added to stable trees.
> 
> These are quite risky to backport.  E.g. we botched patch 6[*], and my initial
> fix also had a subtle bug.  There have also been quite a few KVM MMU changes since
> 5.4, so it's possible that an edge case may exist in 5.4 that doesn't exist in
> mainline.

I totally agree. Getting the changes to work with older kernels needs
more work. The MMU role handling was refactored in 5.14 and down to 5.4
it differs even more, so backports to earlier kernels definitely needs
more care.

My plan would be to limit backporting of the whole series to kernels
down to 5.15 (maybe 5.10 if it turns out to be doable) and for kernels
before that only without patch 6. That would leave out the problematic
change but still give us the benefits of dropping the needless mmu
unloads for only toggling CR0.WP in the VM. This already helps us a lot!

> 
> I'm not totally opposed to the idea since our tests _should_ be provide solid
> coverage, e.g. existing tests caught my subtle bug, but I don't think we should
> backport these without a solid usecase, as there is a fairly high risk of breaking
> random KVM users that wouldn't see any meaningful benefit.
> 
> In other words, who cares enough about the performance of running grsecurity kernels
> in VMs to want these backported, but doesn't have the resources to maintain (or pay
> someone to maintain) their own host kernel?

The ones who care are, obviously, our customers -- and we, of course!
Customers that can run their own infrastructure don't need these
backports in upstream LTS kernels, as we will provide them as well.
However, customers that rent VMs in the cloud have no control of what
runs as host kernel. It'll likely be some distribution kernel or some
tailored version of that, which is likely based on one of the LTS kernels.

Proxmox[1], for example, is a Debian based virtualization management
system. They do provide their own kernels, based on 5.15. However, the
official Debian stable kernel is based on 5.10. So it would be nice to
get backports down to this version at least.

[1] https://www.proxmox.com/en/proxmox-ve/features

> 
> [*] https://lkml.kernel.org/r/20230405002608.418442-1-seanjc%40google.com
