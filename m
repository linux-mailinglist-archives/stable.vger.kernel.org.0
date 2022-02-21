Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FE24BEB18
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 20:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiBUSf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 13:35:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiBUSen (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 13:34:43 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7971110E7;
        Mon, 21 Feb 2022 10:32:32 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id h15so14200590edv.7;
        Mon, 21 Feb 2022 10:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pX15Rc7KBZm9LZu7+vpomQYoySVNohVFbwea71EUpB0=;
        b=HP1Hf2pVi5Y4iRvT6DcNmAA5iuKlAgHmQwC5jn61rm6Z6i9VVC8T6OlMjMsQwLeuiC
         UrntMsuyprpHNCCEyqHUoiv8kndSIrRmTTCXrIEojTNTDIj7gzlvP49kVNVXU/EBCvg5
         0w5TKK8EYV3I59dnyhvid7d4700he8+06rewBAfvWwhMkzjIEhy+CtZ4hWU+BteN6pK6
         X6/pHyj9TiHFbQkVs0Qa/zlyx3Vw7z76ve7NRWTpA5PLlSxvEz9ykBTGXF51LynRbacg
         eryMAPK8zpLdPHkqATzjGRQXV15CGkCponTudSnRYr+ZKhRzlLklANms5ARYGcWgwD9u
         i2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pX15Rc7KBZm9LZu7+vpomQYoySVNohVFbwea71EUpB0=;
        b=Nb2UAXuz/OiUCTGRE7ggs9QfzRsToelwYu7IGfGn6D4evm7u+wJkJHx71dK+zqZuno
         YJDB0iNytN3d1dKqrmZlB4sDoXxkb8yd4ost9EvQ1ETHYpIOSgvroC5G7ltbjTzTUZFX
         RZt8c2YHY2fWXBIK7tUeau+BUqbK7gVJZv3reqG2Qi7JD2y26jIyVRWIg0BWyIgZOUme
         82rJX31WWosDDiLIGqIXOWTtWtrYG2MsTf6n/7ylCDutVFT47oE/xrwP+OTLZCc5esmy
         6XPAijTCIuQKaox9qHQMju47KpMHbpRKu8TGXsBjGk+C8INC+1mSgeI4j3qkt3F3ee7t
         6LVQ==
X-Gm-Message-State: AOAM531AVd9x3AnOYGmipFGrsywKTayDGNNYyjCiZ/2wQN9pCLukm8nn
        x2CG76A5ZTCSILhfjjcUx+U=
X-Google-Smtp-Source: ABdhPJwlwGOdYFpPXVk5Ln5iVqW14OJL3VebWqslw8VA2p0V7OAcMtK9THjDOzew9Or+NryOlymhuA==
X-Received: by 2002:a50:9ea2:0:b0:409:5438:debf with SMTP id a31-20020a509ea2000000b004095438debfmr22786257edf.126.1645468350940;
        Mon, 21 Feb 2022 10:32:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id lw18sm5369966ejb.88.2022.02.21.10.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 10:32:30 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3ec04333-7988-16ca-a176-2eeb237851a7@redhat.com>
Date:   Mon, 21 Feb 2022 19:32:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v6] KVM: SVM: Allow AVIC support on system w/ physical
 APIC ID > 255
Content-Language: en-US
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, mlevitsk@redhat.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com, stable@vger.kernel.org
References: <20220211000851.185799-1-suravee.suthikulpanit@amd.com>
 <5dd76348-f89c-58d9-1f6b-a6031b984330@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5dd76348-f89c-58d9-1f6b-a6031b984330@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/16/22 23:59, Suthikulpanit, Suravee wrote:
> Paolo,
> 
> Do you have any other concerns regarding this patch?

Queued it now, thanks.  I had left it aside for a second because it 
didn't apply cleanly.  I'll include it in 5.18 for now; we'll then have 
to repost this version as a <=5.17 backport for Greg, after the merge 
window.

Paolo

> Regards,
> Suravee
> 
> On 2/11/2022 7:08 AM, Suravee Suthikulpanit wrote:
>> Expand KVM's mask for the AVIC host physical ID to the full 12 bits 
>> defined
>> by the architecture.  The number of bits consumed by hardware is model
>> specific, e.g. early CPUs ignored bits 11:8, but there is no way for KVM
>> to enumerate the "true" size.  So, KVM must allow using all bits, else it
>> risks rejecting completely legal x2APIC IDs on newer CPUs.
>>
>> This means KVM relies on hardware to not assign x2APIC IDs that exceed 
>> the
>> "true" width of the field, but presumably hardware is smart enough to tie
>> the width to the max x2APIC ID.  KVM also relies on hardware to 
>> support at
>> least 8 bits, as the legacy xAPIC ID is writable by software.  But, those
>> assumptions are unavoidable due to the lack of any way to enumerate the
>> "true" width.
>>
>> Cc: stable@vger.kernel.org
>> Cc: Maxim Levitsky <mlevitsk@redhat.com>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Reviewed-by: Sean Christopherson <seanjc@google.com>
>> Fixes: 44a95dae1d22 ("KVM: x86: Detect and Initialize AVIC support")
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 7 +------
>>   arch/x86/kvm/svm/svm.h  | 2 +-
>>   2 files changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 90364d02f22a..e4cfd8bf4f24 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -974,17 +974,12 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu 
>> *vcpu, int cpu, bool r)
>>   void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>   {
>>       u64 entry;
>> -    /* ID = 0xff (broadcast), ID > 0xff (reserved) */
>>       int h_physical_id = kvm_cpu_get_apicid(cpu);
>>       struct vcpu_svm *svm = to_svm(vcpu);
>>       lockdep_assert_preemption_disabled();
>> -    /*
>> -     * Since the host physical APIC id is 8 bits,
>> -     * we can support host APIC ID upto 255.
>> -     */
>> -    if (WARN_ON(h_physical_id > 
>> AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
>> +    if (WARN_ON(h_physical_id & 
>> ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
>>           return;
>>       /*
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 47ef8f4a9358..cede59cd8999 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -565,7 +565,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
>>   #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT            31
>>   #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK        (1 << 31)
>> -#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK    (0xFFULL)
>> +#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK    
>> GENMASK_ULL(11, 0)
>>   #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK    (0xFFFFFFFFFFULL 
>> << 12)
>>   #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK        (1ULL << 62)
>>   #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK        (1ULL << 63)

