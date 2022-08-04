Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED05589FB6
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 19:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiHDRIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 13:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiHDRI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 13:08:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C898218342
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 10:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659632907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=acKEhL55txfWJodj/kwqYF65Txyu4XN1fZSdGnmYxoY=;
        b=DwgWNffr7ospba1tYg10qdiIfYQc3WaksfIvsALGP3E2J23K+VB9YPklX0zsvqNo3CLL97
        3v4fTiVmKIYdBRey4p3jt3AuyEamH94JU9TxDQHcc4gU67kZxsJrUegqt5eOdPQu2/JU3Z
        FnqkTPYnimzCcjwQvvqCL58r6UDvbiU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-Q0EhbUjGOBS-PDjfQ8h4IA-1; Thu, 04 Aug 2022 13:08:26 -0400
X-MC-Unique: Q0EhbUjGOBS-PDjfQ8h4IA-1
Received: by mail-wr1-f70.google.com with SMTP id j20-20020adfb314000000b00220d9957623so89538wrd.0
        for <stable@vger.kernel.org>; Thu, 04 Aug 2022 10:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=acKEhL55txfWJodj/kwqYF65Txyu4XN1fZSdGnmYxoY=;
        b=40A/7p9hk2QbU2zTP611iS6M00dnXJyCARCAPuXvugIgRSUWDP/5MM6Qut/GD3AXwV
         n91ARff0Z1eB3vl4ltt6XpNLXR3RmxxLZg9mLd7Bml/Kog8JncD4OYC0r/C8Ms4jxUnz
         nUizc8aCR8lfUjiKeQYVo912gsqNNbkT9DcDtq810IzWw45z2B3YPGSlC8nys7wsfHmX
         6++LrbXH3bTHGOjSKGDUSJAyLE4gzAmW0xvtB3nB2lHU9KzhCiT1O/jHTa05VnsD8B8K
         +c8YT4iZKrFzXhW4S81FyEzN65AOmnsnGq8VfkXzctdC7kFjaFW3JiS6K8Q/JrGhU6ON
         ZoXg==
X-Gm-Message-State: ACgBeo2Vx1v/oMQmgzg/Lr6trLHZexFaXhnSY/5D0E8EtvNsIxLfA++o
        nbRgmW0pOpNkP8Z+tPs0B3wXc+KvpIQKGu7Z98osUTTi5ZcTHTh86eotMaU/ldhJ61lxQpcsmNA
        /LOtsCmFir9hZUcfZ
X-Received: by 2002:a5d:67c1:0:b0:220:7079:78ef with SMTP id n1-20020a5d67c1000000b00220707978efmr2069184wrw.264.1659632905408;
        Thu, 04 Aug 2022 10:08:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR69LuPWeRZ63EEvNbjUmD6npjXR31aH5eDe1l9v6pHIeuEf1FkGBjnYrOa4bgoa+Aro9OFfYg==
X-Received: by 2002:a5d:67c1:0:b0:220:7079:78ef with SMTP id n1-20020a5d67c1000000b00220707978efmr2069167wrw.264.1659632905142;
        Thu, 04 Aug 2022 10:08:25 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id a18-20020a05600c349200b003a35ec4bf4fsm2119048wmq.20.2022.08.04.10.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 10:08:24 -0700 (PDT)
Date:   Thu, 4 Aug 2022 18:08:22 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Dave Young <ruyang@redhat.com>,
        Xiaoying Yan <yiyan@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: revalidate steal time cache if MSR value
 changes
Message-ID: <Yuv9BoFtf9q3Ew5G@work-vm>
References: <20220804132832.420648-1-pbonzini@redhat.com>
 <87v8r8yuvo.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8r8yuvo.fsf@redhat.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Vitaly Kuznetsov (vkuznets@redhat.com) wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
> > Commit 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time
> > / preempted status", 2021-11-11) open coded the previous call to
> > kvm_map_gfn, but in doing so it dropped the comparison between the cached
> > guest physical address and the one in the MSR.  This cause an incorrect
> > cache hit if the guest modifies the steal time address while the memslots
> > remain the same.  This can happen with kexec, in which case the steal
> > time data is written at the address used by the old kernel instead of
> > the old one.
> >
> > While at it, rename the variable from gfn to gpa since it is a plain
> > physical address and not a right-shifted one.
> >
> > Reported-by: Dave Young <ruyang@redhat.com>
> > Reported-by: Xiaoying Yan  <yiyan@redhat.com>
> > Analyzed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > Cc: David Woodhouse <dwmw@amazon.co.uk>
> > Cc: stable@vger.kernel.org
> > Fixes: 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e5fa335a4ea7..36dcf18b04bf 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3380,6 +3380,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> >  	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
> >  	struct kvm_steal_time __user *st;
> >  	struct kvm_memslots *slots;
> > +	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> >  	u64 steal;
> >  	u32 version;
> >  
> > @@ -3397,13 +3398,12 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> >  	slots = kvm_memslots(vcpu->kvm);
> >  
> >  	if (unlikely(slots->generation != ghc->generation ||
> > +		     gpa != ghc->gpa ||
> >  		     kvm_is_error_hva(ghc->hva) || !ghc->memslot)) {
> > -		gfn_t gfn = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> > -
> >  		/* We rely on the fact that it fits in a single page. */
> >  		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
> >  
> > -		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gfn, sizeof(*st)) ||
> > +		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, sizeof(*st)) ||
> 
> (It would be nice to somehow get at least a warning when 'gfn_t' is used
> instead of 'gpa_t' and vice versa)

Can't sparse be taught to do that?

Dave

> >  		    kvm_is_error_hva(ghc->hva) || !ghc->memslot)
> >  			return;
> >  	}
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

