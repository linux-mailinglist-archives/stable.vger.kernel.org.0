Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB89A31C22A
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 20:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhBOTGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 14:06:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230416AbhBOTGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 14:06:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613415872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ImJRI1yuJ7O4+8pVfGV5azZCf98csp8Xgq02hsPklo8=;
        b=O2u72zgVYDT+1V/CpjGbzYQBWj20XAXV9pp8ncS3Gvs9jbF5Idyr9cgyyiVEcTjrp6Xw+t
        0ip194yLjZ8V2WFcUJg7TjbKIkQk/+1s5V1eKHm0Mia2Ct3t8Q3DgDTaEguh8LNWUq3vOA
        iZDTIgk5GhZJKYUf4rvAirOgoeeka3U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-aMmYTspmMcGJVXtyeR63jA-1; Mon, 15 Feb 2021 14:04:30 -0500
X-MC-Unique: aMmYTspmMcGJVXtyeR63jA-1
Received: by mail-wr1-f71.google.com with SMTP id y6so10209313wrl.9
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 11:04:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ImJRI1yuJ7O4+8pVfGV5azZCf98csp8Xgq02hsPklo8=;
        b=BJpuFUZhp0nATuv9OyQx8vqnMEa3L/+wph0+r90cCNmW1HAZjNrGiofh4U9g2CA5aM
         QIuTgeXyeWz5VyH2J6yQ6cHbaBjVoZXXegULsoEo4reZFje7u0QbanOe/tpfi1FbQrl5
         /2/1u86pDE0s+cPlSSeCyQG1fitbEOipyxDFbdyvG5vp/gajI64VXN/tADUqmXx51fK2
         tezSkXYkydBwd3PYBu+v9I2XJoeGC1sqLcUASjmB1Eks+2bVJCwSJAp8yUJEa10X/cNt
         TFdpTRWLwj2Nbjko9a/BS6czYj4dMwOZ6B5VtRG0n18zcQwSsAFsB5dBh2N6ejxhAOAO
         VqWA==
X-Gm-Message-State: AOAM530qFEDbA+GYdvhRJGLQVlYz08K1AeYCJtGCd4LHA+9PzEYdtJNb
        kaBmklFXYdGYttBlSQFhIWpAozeaiDEgajqNCtbS12UWRq2F8LVXn4x45nGVDzT3UlgqunYBy7q
        91QLv2jWOBMZsEzIK
X-Received: by 2002:adf:bb54:: with SMTP id x20mr20480960wrg.112.1613415869057;
        Mon, 15 Feb 2021 11:04:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwuXw4FHbMOBKae+oWDB5mUcaF7jO1E7sfWFLf95KC5dNp0Yy6wmPhWvxW4ObReRsg9YJisPg==
X-Received: by 2002:adf:bb54:: with SMTP id x20mr20480939wrg.112.1613415868802;
        Mon, 15 Feb 2021 11:04:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c9sm278741wmb.33.2021.02.15.11.04.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Feb 2021 11:04:28 -0800 (PST)
Subject: Re: [PATCH 5.10 048/104] KVM: x86: cleanup CR3 reserved bits checks
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Sasha Levin <sashal@kernel.org>
References: <20210215152719.459796636@linuxfoundation.org>
 <20210215152721.031370031@linuxfoundation.org> <20210215184644.GA8689@amd>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f5107037-63b2-a745-1c3e-ba1960bc507b@redhat.com>
Date:   Mon, 15 Feb 2021 20:04:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210215184644.GA8689@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/02/21 19:46, Pavel Machek wrote:
> Hi!
> 
>> [ Upstream commit c1c35cf78bfab31b8cb455259524395c9e4c7cd6 ]
>>
>> If not in long mode, the low bits of CR3 are reserved but not enforced to
>> be zero, so remove those checks.  If in long mode, however, the MBZ bits
>> extend down to the highest physical address bit of the guest, excluding
>> the encryption bit.
>>
>> Make the checks consistent with the above, and match them between
>> nested_vmcb_checks and KVM_SET_SREGS.
> 
>> +++ b/arch/x86/kvm/x86.c
>> @@ -9558,6 +9558,8 @@ static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>>   		if (!(sregs->cr4 & X86_CR4_PAE)
>>   		    || !(sregs->efer & EFER_LMA))
>>   			return -EINVAL;
>> +		if (sregs->cr3 & vcpu->arch.cr3_lm_rsvd_bits)
>> +			return false;
>>   	} else {
> 
> Function has different return type between 5.10 and 5.11, so this
> needs fixing.

I'll check that c1c35cf78bfab31b8cb455259524395c9e4c7cd6 is enough and 
send either a backport of that one, or a fixed patch for <= 5.10. 
Thanks Pavel.

Paolo

