Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852D33E43DC
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 12:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbhHIKXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 06:23:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234346AbhHIKXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 06:23:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628504605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lBMgmsHqw0YdLKVpdWLFV60bEE3X7POBff7kY81z7+0=;
        b=NhlXYLePc588orL/szPFEExZ9i7+Pshae1FCaohyK8yBodDc3nu5qbWGLUSefMte5AOn0H
        58CHccqgoN1hmB39/7jJ7443v8n1PkJLH2L70S5NUv3rNhT01hJBG5yNa0AovJvUw1tptP
        509QgW/zCjl0LQOCrAXFu0ozgBzmbBc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-fsZpdtQPMnuluJbCZk3_JQ-1; Mon, 09 Aug 2021 06:23:24 -0400
X-MC-Unique: fsZpdtQPMnuluJbCZk3_JQ-1
Received: by mail-ej1-f70.google.com with SMTP id q19-20020a170906b293b029058a1e75c819so4332990ejz.16
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 03:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lBMgmsHqw0YdLKVpdWLFV60bEE3X7POBff7kY81z7+0=;
        b=h1GELd4E8+zDzVEeZokStDI8kBIurBy/uopoJuSsyaJq3Nnaeah3WpI82Reabs02LN
         Sm5YXIe1XXsCmrqWhTZ+8Td894AnzVmUNmlMOgL1lGRlRw+2BQlEB9KcmziGt/1J8Z2R
         /+/9JiiZPY63/ZPvrXEhhBg0fJjKUPrayoOaoAp9EowEug4O0iZaY+hi1+1ci165WJUt
         jGvbVrNsTO0qYjbiRWW1AM5+FO1qZC/kivkIKq6IZVClx/8Oi9WuREwe1jeNwvjusht5
         8MKlpaVLGqUBAmjrqcAjnXjO0VTnR94LH6m3ZRJTzS/k9qa9SbQXOSz/iH3Fy1C2cE8q
         jbhA==
X-Gm-Message-State: AOAM5335kb2RitW+sg24vdji73rQ0/+ahAbk+DTfS0LLLAhXTpgaJa/b
        qSF7RYbQqJBoy6R2Q9VkimTMxQNJaNDAX9jmFbsoB+r16AuTmxv1osxlImnBSYQQlhS1Wb4OD7P
        h/S7RI12wDPNEKrbb
X-Received: by 2002:aa7:c647:: with SMTP id z7mr28762253edr.52.1628504603585;
        Mon, 09 Aug 2021 03:23:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxu4/FLaxiABAh3xlH1zEltzZAqe/JpBP91yZt7peMzpTB2Jakv6WmDhskp7f5QhwHz26t4Ug==
X-Received: by 2002:aa7:c647:: with SMTP id z7mr28762236edr.52.1628504603409;
        Mon, 09 Aug 2021 03:23:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id l9sm7953930edt.55.2021.08.09.03.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 03:23:22 -0700 (PDT)
To:     Joao Martins <joao.m.martins@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210805105423.412878-1-pbonzini@redhat.com>
 <4b530fb6-81cc-be36-aa68-92ec01c65775@oracle.com>
 <5f3c13be-f65d-1793-bd91-7491d3e149b0@redhat.com>
 <bab67d1c-f9b7-0a91-2d4f-9881e3f47218@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] selftests: KVM: avoid failures due to reserved
 HyperTransport region
Message-ID: <ac72b77c-f633-923b-8019-69347db706be@redhat.com>
Date:   Mon, 9 Aug 2021 12:23:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bab67d1c-f9b7-0a91-2d4f-9881e3f47218@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/08/21 12:00, Joao Martins wrote:
> [0]https://developer.amd.com/wp-content/resources/56323-PUB_0.78.pdf
> 
> 1286 Spurious #GP May Occur When Hypervisor Running on
> Another Hypervisor
> 
> Description
> 
> The processor may incorrectly generate a #GP fault if a hypervisor running on a hypervisor
> attempts to access the following secure memory areas:
> 
> • The reserved memory address region starting at FFFD_0000_0000h and extending up to
> FFFF_FFFF_FFFFh.
> • ASEG and TSEG memory regions for SMM (System Management Mode)
> • MMIO APIC Space

This errata took a few months to debug so we're quite familiar with it 
:) but I only knew about the ASEG/TSEG/APIC cases.

So this HyperTransport region is not related to this issue, but the 
errata does point out that FFFD_0000_0000h and upwards is special in guests.

The Xen folks also had to deal with it only a couple months ago 
(https://yhbt.net/lore/all/1eb16baa-6b1b-3b18-c712-4459bd83e1aa@citrix.com/):

   From "Open-Source Register Reference for AMD Family 17h Processors 
(PUB)":
   https://developer.amd.com/wp-content/resources/56255_3_03.PDF

   "The processor defines a reserved memory address region starting at
   FFFD_0000_0000h and extending up to FFFF_FFFF_FFFFh."

   It's still doesn't say that it's at the top of physical address space
   although I understand that's how it's now implemented. The official
   document doesn't confirm it will move along with physical address space
   extension.

   [...]

   1) On parts with <40 bits, its fully hidden from software
   2) Before Fam17h, it was always 12G just below 1T, even if there was
   more RAM above this location
   3) On Fam17h and later, it is variable based on SME, and is either
   just below 2^48 (no encryption) or 2^43 (encryption)

> It's
> interesting that fn8000_000A EDX[28] is part of the reserved bits from that CPUID leaf.

It's only been defined after AMD deemed that the errata was not fixable 
in current generation processors); it's X86_FEATURE_SVME_ADDR_CHK now.

I'll update the patch based on the findings from the Xen team.

Paolo

