Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB6154313B
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 15:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240043AbiFHNVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 09:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240040AbiFHNVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 09:21:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C7843BFB8
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 06:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654694508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SkCtRFwTpix6cqqR0vaJf3gcR2UPvZl1kedDkrrQHQk=;
        b=VvlhPLcOUnEdK8RtDv2BDwRqLgyUnkbZ96xhTp7u2lr/LFSP59HNudtAWmYhzmDArAmKdz
        rJ4sm8wZ3znGIsujVZOqdxtL8gcwohTsUITpzDAVE17oAoDNnW6nAJ42gCyEKD0gTIktPE
        OsbLaOmGfh82m+7Egvy+K6/vEkjzCl8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-F9xOtmuIPviO0z6dwotNgQ-1; Wed, 08 Jun 2022 09:21:47 -0400
X-MC-Unique: F9xOtmuIPviO0z6dwotNgQ-1
Received: by mail-wm1-f72.google.com with SMTP id u12-20020a05600c19cc00b0038ec265155fso14407044wmq.6
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 06:21:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SkCtRFwTpix6cqqR0vaJf3gcR2UPvZl1kedDkrrQHQk=;
        b=mn8gec9xAcOeMOFtKKiKbt3lYmekT5PosYSy6Muc/KqtegbQ9dAsIWha8D4ARA6h/i
         TxnC5VWfH5sqH38fU8RBy0BOzmlWnbbHVL0wnheSb7tz3/G0RhOmUNY/SiacRSlI6e3L
         h0kppdjdZIQTBOyVIfFAMgjfIMg6sBhuhgcjYKY5Yl5febbkaVMf2ixHOMV1bZmRTOHP
         6DLrEG+ZAPS7Dx8zF2s+HkfL8ygHJ8ZDa/AoELoVQJThQfjScNDh30ArR5M22A+IOhmh
         VTVblEorv0xr8O/4pjTdMJsMNpJ7Ia8xf/0bG+H0sDcYozI36hzXmEqZbC3J13gc/qyo
         oDsg==
X-Gm-Message-State: AOAM533xCRqQsLk0vjX8eE7qG2xJertdVmvVi+MCkb66tqpsuLveb84f
        dWKC+LS98LhzN1gupEDisf7XwB4m7GlEmgIPJUqQoUJv0LzeacCHa3rNGdlxXCuqyatxNyW04yx
        6rH2cqLqGUpU4R1qX
X-Received: by 2002:adf:f20d:0:b0:214:c726:ce76 with SMTP id p13-20020adff20d000000b00214c726ce76mr26699115wro.649.1654694506286;
        Wed, 08 Jun 2022 06:21:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaA7jNNnJGWGxSZi3mS5Ma8c5boc4zfZ2u1LoRf9h9fTXyTDTHq18tyu2dPMjTs6YP00xiHA==
X-Received: by 2002:adf:f20d:0:b0:214:c726:ce76 with SMTP id p13-20020adff20d000000b00214c726ce76mr26699096wro.649.1654694506013;
        Wed, 08 Jun 2022 06:21:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id c14-20020adffb0e000000b00213465d202esm18742388wrr.46.2022.06.08.06.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 06:21:45 -0700 (PDT)
Message-ID: <c7fb78e2-2650-f9a2-3062-5d5ecc34332b@redhat.com>
Date:   Wed, 8 Jun 2022 15:21:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 4/7] KVM: x86: SVM: fix avic_kick_target_vcpus_fast
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        stable@vger.kernel.org
References: <20220606180829.102503-1-mlevitsk@redhat.com>
 <20220606180829.102503-5-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220606180829.102503-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/6/22 20:08, Maxim Levitsky wrote:
> There are two issues in avic_kick_target_vcpus_fast
> 
> 1. It is legal to issue an IPI request with APIC_DEST_NOSHORT
>     and a physical destination of 0xFF (or 0xFFFFFFFF in case of x2apic),
>     which must be treated as a broadcast destination.
> 
>     Fix this by explicitly checking for it.
>     Also don’t use ‘index’ in this case as it gives no new information.
> 
> 2. It is legal to issue a logical IPI request to more than one target.
>     Index field only provides index in physical id table of first
>     such target and therefore can't be used before we are sure
>     that only a single target was addressed.
> 
>     Instead, parse the ICRL/ICRH, double check that a unicast interrupt
>     was requested, and use that info to figure out the physical id
>     of the target vCPU.
>     At that point there is no need to use the index field as well.
> 
> 
> In addition to fixing the above	issues,	also skip the call to
> kvm_apic_match_dest.
> 
> It is possible to do this now, because now as long as AVIC is not
> inhibited, it is guaranteed that none of the vCPUs changed their
> apic id from its default value.
> 
> 
> This fixes boot of windows guest with AVIC enabled because it uses
> IPI with 0xFF destination and no destination shorthand.
> 
> Fixes: 7223fd2d5338 ("KVM: SVM: Use target APIC ID to complete AVIC IRQs when possible")
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Is it possible to use kvm_intr_is_single_vcpu_fast, or am I missing 
something?

Series queued, thanks.

Paolo

