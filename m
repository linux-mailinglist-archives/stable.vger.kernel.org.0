Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9BF53D1A9
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347176AbiFCSlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347170AbiFCSlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:41:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 354C713F56
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 11:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654281664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pa7cJ5G4COGyAzAnTJD9ItMqf7WRFzB0pDurEI93KXo=;
        b=OyLE4ybXwrHgcWk4NfzlvZfkAjb1yVtAYzc4O+B91HJugco70pTWCqGmPFAHb/DZqQlOYK
        Ggu6LGPx4/78D3J7X+vGJTUUKdPDIa6mz3/ljX2CFLoR+hwH0uiaAbmv4SYySxq9BKydqB
        qVsdRLXoA/721dQdPTvYgVp2rCe7qQ0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-peeeAOOWOTOVOZngY-v8Ow-1; Fri, 03 Jun 2022 14:41:02 -0400
X-MC-Unique: peeeAOOWOTOVOZngY-v8Ow-1
Received: by mail-il1-f198.google.com with SMTP id x5-20020a923005000000b002d1a91c4d13so6870586ile.4
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 11:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pa7cJ5G4COGyAzAnTJD9ItMqf7WRFzB0pDurEI93KXo=;
        b=JtQ3M7M4Rr40aJNnTCCk/pbw8d41asUxVahuTRsUHDSFHM/8LhomQsju3Y2zybAuCB
         SNT2HL2XejuCx6IjoG6LvHV0J1THK6udawYVQVlit+eTscPXiaWmlmdG4uPuCEBlT41V
         1UDdlGcNqQH6rFmseM3Bbhe5TUBzxIRow7trSs7Wy6f8Q9Rv4YSYS2jTxnxRXf549z/k
         Gy2EWpaj3kdgjgBTXG0bkkZW+Z5sHkvZcWHcMOTn17S04EWOgdYaj16ugsTKVnLi3Dk9
         2U0Ipkdhwo/SCZHC9vfeX+7YvqAJytbIIAg172lTDUhdBO1tWBlDGrRpEyP5lLdrGdmE
         bl7A==
X-Gm-Message-State: AOAM532UQyR/E8enPLcEONBKm3uTz2AL29ff+PXvStKSaVCC94GyqTj+
        ut/X5HSKfIA6EtzeJ2QTHdyyfoJB0A8R8I9t95AQJcCB8qdySGhmOyxB7QBi7IO2q5t/Ci9SBPP
        C8IKweUq4nB1pv1Nh
X-Received: by 2002:a5d:96d0:0:b0:654:91d3:97b7 with SMTP id r16-20020a5d96d0000000b0065491d397b7mr5560407iol.164.1654281662258;
        Fri, 03 Jun 2022 11:41:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkDTDyNAxtQgrl3i4tHY0k/Op4bKpQ1vmRy3Ff+VxQAjwl9MttXildmqnXNEnZbpVVaYCPcg==
X-Received: by 2002:a5d:96d0:0:b0:654:91d3:97b7 with SMTP id r16-20020a5d96d0000000b0065491d397b7mr5560398iol.164.1654281661970;
        Fri, 03 Jun 2022 11:41:01 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id cp2-20020a056638480200b0032e332882e0sm2814503jab.75.2022.06.03.11.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:41:00 -0700 (PDT)
Date:   Fri, 3 Jun 2022 14:40:58 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Leonardo Bras <leobras@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        chang.seok.bae@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH AUTOSEL 5.16 07/28] x86/kvm/fpu: Limit guest
 user_xfeatures to supported bits of XCR0
Message-ID: <YppVupW+IWsm7Osr@xz-m1.local>
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-7-sashal@kernel.org>
 <5f2b7b93-d4c9-1d59-14df-6e8b2366ca8a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5f2b7b93-d4c9-1d59-14df-6e8b2366ca8a@redhat.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 01, 2022 at 09:22:10PM +0100, Paolo Bonzini wrote:
> On 3/1/22 21:13, Sasha Levin wrote:
> > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > index d28829403ed08..6ac01f9828530 100644
> > --- a/arch/x86/kernel/fpu/xstate.c
> > +++ b/arch/x86/kernel/fpu/xstate.c
> > @@ -1563,7 +1563,10 @@ static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
> >   		fpregs_restore_userregs();
> >   	newfps->xfeatures = curfps->xfeatures | xfeatures;
> > -	newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
> > +
> > +	if (!guest_fpu)
> > +		newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
> > +
> >   	newfps->xfd = curfps->xfd & ~xfeatures;
> >   	curfps = fpu_install_fpstate(fpu, newfps);
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index bf18679757c70..875dce4aa2d28 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -276,6 +276,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >   	vcpu->arch.guest_supported_xcr0 =
> >   		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
> > +	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0;
> > +
> >   	kvm_update_pv_runtime(vcpu);
> >   	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> 
> Leonardo, was this also buggy in 5.16?  (I should have asked for a Fixes
> tag...).

I just stumbled over this patch on some migration tests in the past few
days..

In short, I was migrating a VM from 5.15 host to 5.18 host and the guest
trigger double fault immediately after the switch-over (I think that's when
it's trying to do vmenter, a VECTOR_DF was injected), with either precopy
or postcopy.

After I upgrade 5.15 src host to 5.18 host, problem goes away. I did a
bisect on dest and surprisingly it points to this commit.

Side note: I'm using two hosts that have the same processor model, so no
case of missing features on either side - they just match.

I'm not really sure whether this is a bug or by design - do we require this
patch to be applied to all stable branches to make the guest not crash
after migration, or it is unexpected?

FWICT, this patch modifies user_xfeatures while we don't do that trick
before. It sounds reasonable to me from the 1st glance, say if the guest
didn't enable some of the fpu features so we don't need to migrate those
fpu state chunks as we're migrating things based on user_xfeatures, and it
sounds good to solve the migration issue on "has-pksu" host to "no-pksu"
host as described in the patch commit message.

However there seems to be something missing at least to me, on why it'll
fail a migration from 5.15 (without this patch) to 5.18 (with this patch).
In my test case, user_xfeatures will be 0x7 (FP|SSE|YMM) if without this
patch, but 0x0 if with it.

I think what it should be happening is user_xfeatures will be set on src
with 0x7 (old kernel), so we should have migrated some more chunks to dest,
but I just don't quickly understand why that's a problem there because
fundamentally when we restore the fpu status (fpu_swap_kvm_fpstate) we use
the max feature bitmask anyway, and the dest hardware should support all of
them.  I don't quickly see how that could trigger a double fault, though.

I'll continue the dig probably next week, before that, any thoughts?

-- 
Peter Xu

