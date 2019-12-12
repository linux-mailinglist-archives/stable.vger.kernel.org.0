Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5FF11C9BE
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfLLJnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:43:52 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47200 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728511AbfLLJnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 04:43:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576143830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8WYueCqZllh/g3kIvXk2fqY+m/Wf+jDC76k8N31CSUs=;
        b=Vtnt2/7EipLZumGR0KtT4zwhP4F0NYq0184L6xE8cZy15ywLjkXjPlR7UYlAVCllqyNzax
        985OjywVyjJlbrW/LtrlFGLcNvDFaw1buemUjihLqBk/BzGqNkx4TAXvikRaIxiOtol2KL
        6mSglYGebYqBw+xso2gyakJJ0LFG01k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-9kqgZN3iPWmlQdZNqDi92Q-1; Thu, 12 Dec 2019 04:43:49 -0500
X-MC-Unique: 9kqgZN3iPWmlQdZNqDi92Q-1
Received: by mail-wr1-f71.google.com with SMTP id t3so800535wrm.23
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 01:43:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8WYueCqZllh/g3kIvXk2fqY+m/Wf+jDC76k8N31CSUs=;
        b=JBRTObl6AC2nFcZ2LIkz3vMSbwQflAAZhPqg6Uqd0oBPmBMZjWlotPJI3bnU16l5+k
         bQAvYpEyvydmaAg2DIqODGe5yxX5JbvYU3v8KVU4JPU9ukZeG0vgczKYG7uh6x3IcyJO
         OwOmIZ0kQN8VT85mZKD2ZGSOkm1PEQXTY1o65wcvd414EaYe0JmJR1IxJUNHPMNR+XRM
         298loXa+B4bHAdoQkWfnK4XkByX0bxsUUTYTZkzScHHf2HMD/JJPY7T6EFCLPE/6YYRf
         6GzrkhplyDQPU3jcIf9/lw53GJgI8B+vjEzcEruMCE+fmdM5H0Olf0e4LnF9PMtNJ/tv
         zx+w==
X-Gm-Message-State: APjAAAXHGe0SWwkw4z8coshYiSzmEvy30VGM/BaPoIcLtFqB394c0yOJ
        0ngQvAnzIH9OxpIMuxry44/q3FSWTqsDJum0O+6hxb15D0lUEtyLnBZDmHGqe1hjgWAoMWTUIfO
        uS/xZkSMHyrRkpcUy
X-Received: by 2002:a1c:96c4:: with SMTP id y187mr5588714wmd.112.1576143827952;
        Thu, 12 Dec 2019 01:43:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqw08Vc/KqRo1P4kmQTeLxX+2WddiEmM7nSrw2R/9MgOOiC1YM2hfPCQ2hrrNXWGVLE5ckSEWg==
X-Received: by 2002:a1c:96c4:: with SMTP id y187mr5588680wmd.112.1576143827696;
        Thu, 12 Dec 2019 01:43:47 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5sm5529138wrh.5.2019.12.12.01.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 01:43:47 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Marios Pomonis <pomonis@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        Marios Pomonis <pomonis@google.com>, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 02/13] KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from Spectre-v1/L1TF attacks
In-Reply-To: <20191211204753.242298-3-pomonis@google.com>
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-3-pomonis@google.com>
Date:   Thu, 12 Dec 2019 10:43:47 +0100
Message-ID: <87eex9c20c.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Marios Pomonis <pomonis@google.com> writes:

> This fixes Spectre-v1/L1TF vulnerabilities in kvm_hv_msr_get_crash_data()
> and kvm_hv_msr_set_crash_data().
> These functions contain index computations that use the
> (attacker-controlled) MSR number.

Just to educate myself,

in both cases 'index' is equal to 'msr - HV_X64_MSR_CRASH_P0' where
'msr' is constrained:
  case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
         ....

and moreover, kvm_hv_{get,set}_msr_common() is only being called for a
narrow set of MSRs. How can an atacker overcome these limitations?

>
> Fixes: commit e7d9513b60e8 ("kvm/x86: added hyper-v crash msrs into kvm hyperv context")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kvm/hyperv.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 23ff65504d7e..26408434b9bc 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -809,11 +809,12 @@ static int kvm_hv_msr_get_crash_data(struct kvm_vcpu *vcpu,
>  				     u32 index, u64 *pdata)
>  {
>  	struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
> +	size_t size = ARRAY_SIZE(hv->hv_crash_param);
>  
> -	if (WARN_ON_ONCE(index >= ARRAY_SIZE(hv->hv_crash_param)))
> +	if (WARN_ON_ONCE(index >= size))
>  		return -EINVAL;
>  
> -	*pdata = hv->hv_crash_param[index];
> +	*pdata = hv->hv_crash_param[array_index_nospec(index, size)];
>  	return 0;
>  }
>  
> @@ -852,11 +853,12 @@ static int kvm_hv_msr_set_crash_data(struct kvm_vcpu *vcpu,
>  				     u32 index, u64 data)
>  {
>  	struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
> +	size_t size = ARRAY_SIZE(hv->hv_crash_param);
>  
> -	if (WARN_ON_ONCE(index >= ARRAY_SIZE(hv->hv_crash_param)))
> +	if (WARN_ON_ONCE(index >= size))
>  		return -EINVAL;
>  
> -	hv->hv_crash_param[index] = data;
> +	hv->hv_crash_param[array_index_nospec(index, size)] = data;
>  	return 0;
>  }

-- 
Vitaly

