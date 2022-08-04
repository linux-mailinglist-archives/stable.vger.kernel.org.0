Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4553589EF8
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 17:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237091AbiHDPyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 11:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbiHDPyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 11:54:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4C335B7B8
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 08:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659628481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0KPYk0cvmqpRu1UsMYKSMmpVLkOgi0Pp9d5E7ivg9cQ=;
        b=Fjsy0c+7qdF9HAvbvrneNFL0dg8ijxj3g+nfXQIsywJK/BlXc2cF7pgTGe1gAwS7qsHeC9
        +8eFpAg2jFI+gSQV4r/toac9yVEPKNzC0zT19b/6d7jIHcPpkoSpVvMkT6xTYQuEZaW4nc
        DrXnCqLKEXYVs6OtGU3qUnM+fo4yIXc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-EF9yNxbnMh6mA31hM9vUgw-1; Thu, 04 Aug 2022 11:54:32 -0400
X-MC-Unique: EF9yNxbnMh6mA31hM9vUgw-1
Received: by mail-wr1-f70.google.com with SMTP id u17-20020adfa191000000b0021ed2209fccso9276wru.16
        for <stable@vger.kernel.org>; Thu, 04 Aug 2022 08:54:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0KPYk0cvmqpRu1UsMYKSMmpVLkOgi0Pp9d5E7ivg9cQ=;
        b=7O8MPiA6pZeOqQmF1b+PKqfP9ja5a9UgxU1vl2nbDC6mxRh+iB+Q7nzebVGTE4BRNO
         eDGdreJ3iWJVFwzcY2Jntlc8Se4R4eu6YFSw/rUEi2g/wEmH9MI+TSACP3dXOE8eoQ2e
         /OzxOAI58md/Qa01pgvN/8goF04mRwVJvCDhTnnAw7Q2UomjSVkAyUrJfW46lNP/96a8
         2dlKXXkTSQQBax7AQly3mUmH87x3fTJzDWzMQaVmfYJ2GEu07MuuVXXoZpaWOfNbJrYH
         /PeqAUs2rmNqzP5YRFGJlf1zkasi36BPgeq5ElRZhtcqmoxj0wySy5X1d63wfnRRHF/O
         7Kcg==
X-Gm-Message-State: ACgBeo3HIWPe8xAkTqUY/urd81EKn8iPrG04v0aKqyexHv4GA0i83GSN
        P5I+alTRm+raunFHWz7ykNCPXSafAi7PhqS6JbsNFVSB4HJ15XfyoaCK1aHIGQSAaAWT3uK28F/
        b2/ID44fi0hs5ftvN
X-Received: by 2002:a05:600c:1c89:b0:3a4:ef8b:f3c7 with SMTP id k9-20020a05600c1c8900b003a4ef8bf3c7mr1970195wms.82.1659628471793;
        Thu, 04 Aug 2022 08:54:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6QokHbaojcJupLbf2goH5PYgzJaypPWWzG3gWFSp7zY1CDaiB/VOnk1HP9TTfWpY+Hi9lT9A==
X-Received: by 2002:a05:600c:1c89:b0:3a4:ef8b:f3c7 with SMTP id k9-20020a05600c1c8900b003a4ef8bf3c7mr1970181wms.82.1659628471582;
        Thu, 04 Aug 2022 08:54:31 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id q4-20020a1c4304000000b003a4a5bcd37esm6604835wma.23.2022.08.04.08.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 08:54:31 -0700 (PDT)
Date:   Thu, 4 Aug 2022 16:54:29 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Dave Young <ruyang@redhat.com>,
        Xiaoying Yan <yiyan@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: revalidate steal time cache if MSR value
 changes
Message-ID: <YuvrtIj/asIVIf6u@work-vm>
References: <20220804132832.420648-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804132832.420648-1-pbonzini@redhat.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Paolo Bonzini (pbonzini@redhat.com) wrote:
> Commit 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time
> / preempted status", 2021-11-11) open coded the previous call to
> kvm_map_gfn, but in doing so it dropped the comparison between the cached
> guest physical address and the one in the MSR.  This cause an incorrect
> cache hit if the guest modifies the steal time address while the memslots
> remain the same.  This can happen with kexec, in which case the steal
> time data is written at the address used by the old kernel instead of
> the old one.
> 
> While at it, rename the variable from gfn to gpa since it is a plain
> physical address and not a right-shifted one.
> 
> Reported-by: Dave Young <ruyang@redhat.com>
> Reported-by: Xiaoying Yan  <yiyan@redhat.com>
> Analyzed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

The kernel you built with this in passes Dave Young's kexec set I was
using to debug it, so:

Tested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Cc: stable@vger.kernel.org
> Fixes: 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5fa335a4ea7..36dcf18b04bf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3380,6 +3380,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
>  	struct kvm_steal_time __user *st;
>  	struct kvm_memslots *slots;
> +	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
>  	u64 steal;
>  	u32 version;
>  
> @@ -3397,13 +3398,12 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  	slots = kvm_memslots(vcpu->kvm);
>  
>  	if (unlikely(slots->generation != ghc->generation ||
> +		     gpa != ghc->gpa ||
>  		     kvm_is_error_hva(ghc->hva) || !ghc->memslot)) {
> -		gfn_t gfn = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> -
>  		/* We rely on the fact that it fits in a single page. */
>  		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
>  
> -		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gfn, sizeof(*st)) ||
> +		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, sizeof(*st)) ||
>  		    kvm_is_error_hva(ghc->hva) || !ghc->memslot)
>  			return;
>  	}
> -- 
> 2.37.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

