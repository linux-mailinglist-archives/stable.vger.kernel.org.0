Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E858D1B16
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 23:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbfJIVkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 17:40:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52328 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731553AbfJIVkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 17:40:53 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iIJhQ-0002DT-Cs; Wed, 09 Oct 2019 23:40:48 +0200
Date:   Wed, 9 Oct 2019 23:40:48 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.3 28/68] KVM: x86: Expose XSAVEERPTR to the
 guest
Message-ID: <20191009214048.irolhz4rwfdiqf2e@linutronix.de>
References: <20191009170547.32204-1-sashal@kernel.org>
 <20191009170547.32204-28-sashal@kernel.org>
 <05acd554-dd0a-d7cd-e17c-90627fa0ec67@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <05acd554-dd0a-d7cd-e17c-90627fa0ec67@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-10-09 23:15:07 [+0200], Paolo Bonzini wrote:
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -479,6 +479,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
> >  
> >  	/* cpuid 0x80000008.ebx */
> >  	const u32 kvm_cpuid_8000_0008_ebx_x86_features =
> > +		F(XSAVEERPTR) |
> >  		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> >  		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
> >  
> > 
> 
> Yet another example of a patch that shouldn't be stable material (in
> this case it's fine, but there can certainly be cases where just adding
> a single flag depends on core kernel changes).

Also, taking advantage of this feature requires changes which just
landed in qemu's master branch.

> Paolo

Sebastian
