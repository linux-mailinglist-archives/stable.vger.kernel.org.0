Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E28E3D742E
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 13:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbhG0LUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 07:20:25 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45561 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236221AbhG0LUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 07:20:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 864B75C01B5;
        Tue, 27 Jul 2021 07:20:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 27 Jul 2021 07:20:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=r
        WCqH1ryE95CtG1PvWuuGdoabfF/kLCCfVKZInFWSJ0=; b=st9u9/KpNSpXJ1/Sd
        BBME0dPYiUeqCJUNKw+GHFj/MCv51O38X7cf/KmK36eb1sQ8YLO0y0cVCQ87EmSq
        D8lUgeaIG9AnOXY+CB8VdGE6LKrj86iPok8odyM5NpGS+S5E4eqOEEe7EWZzovq4
        UPufjlO5ZMfmTgqsoYxMU3WgjyqRaM8d6OI6ra+KWQLQRWBqmKzQkGPZU3gnVlgk
        xV4OiQCz0VPqPQGRcOGDrZMHp0jr3VYN4RGdmj97WmflcFb4qkfcmWc+Szqvg6PG
        NdRBDQoX08cItFLF0hH1vyzOAvYHknGhzMKJvteWjKYzvCebgjbVbCKBq3a99oRd
        uV8Hw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=rWCqH1ryE95CtG1PvWuuGdoabfF/kLCCfVKZInFWS
        J0=; b=IjJKOfk0Jmhqbii0qX719ehh4t62QAg83ONvFofHdq19MscaaSGkD52T+
        qXooqSI29Z9aH9XtCL16Zg9jPjIyYh7pwGRw6JceZfJHg2x0wP0LVrOPSWzfBrPi
        OJAFTtYCBSP54tDAVAnfuwe4Svg7Uc9jI5vd4/dI1tBJUhsooiSs9vHVpQtHLpKG
        NbuMK4M/QidgeGdI7Jldo1oOOEp3yA+0QzI9JbmAhnBHIaP0ttoTnim6ci+CYBKJ
        c+j3HiHZ5/A50mvy1XQWNVJ7oDxf3KQc769I4SO8QiYN7LyrfTwI6dhPkhjtJDz5
        qfsV/y368oSiFLLl2sVHySou+Xyvg==
X-ME-Sender: <xms:-Ov_YBkMK_QLEoyQavMJQrsJBBreDqUj7TC2lUm4Z4M2dwjNoPGNsg>
    <xme:-Ov_YM24NMD5Z0bulHPdbvI40C3gBDBEnZSHME8qvTSBFIeEIdJHbCWuqNXcy9qIa
    PdADbnC8wuMeg>
X-ME-Received: <xmr:-Ov_YHo1107Ewv1jbIOHUQdZEyJsSbMpyXpckaqiq7Zz_2D-py5W2NrQvwGGMlKKz1JwuLqqoN8y1Or_HAu0xKUGXlYOOAjS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrgeejgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuheekhe
    elffefieduteefkeejffdvueehjeejffehledugfetkedvleekudduvdenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:-Ov_YBnNCEnZWeCP7IvAITx16D0QUbj-Dh-bt9hIdBjul7PgCX5AvA>
    <xmx:-Ov_YP2NU_5-UbeyHkXRm3ro9Gb_B6veDZTogw8ZGiFEwedOQ1JRcg>
    <xmx:-Ov_YAtfRyfO6wT_zvQu_G291hJbWgYeEupJ4hsN8rSaixOuzMh_jQ>
    <xmx:-Ov_YKTLVi0DqWYP4kOsT-yWwBvjW8oTHaK_ZEzUZSHRJ3R1d_E83A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Jul 2021 07:20:23 -0400 (EDT)
Date:   Tue, 27 Jul 2021 13:20:21 +0200
From:   Greg KH <greg@kroah.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 4.19 3/3] KVM: Use kvm_pfn_t for local PFN variable in
 hva_to_pfn_remapped()
Message-ID: <YP/r9VaOpLunpwCo@kroah.com>
References: <20210727082924.2336367-1-ovidiu.panait@windriver.com>
 <20210727082924.2336367-3-ovidiu.panait@windriver.com>
 <07f120ee-28fd-4521-495f-071a0d71a8cc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07f120ee-28fd-4521-495f-071a0d71a8cc@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 01:01:01PM +0200, Paolo Bonzini wrote:
> On 27/07/21 10:29, Ovidiu Panait wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > commit a9545779ee9e9e103648f6f2552e73cfe808d0f4 upstream
> > 
> > Use kvm_pfn_t, a.k.a. u64, for the local 'pfn' variable when retrieving
> > a so called "remapped" hva/pfn pair.  In theory, the hva could resolve to
> > a pfn in high memory on a 32-bit kernel.
> > 
> > This bug was inadvertantly exposed by commit bd2fae8da794 ("KVM: do not
> > assume PTE is writable after follow_pfn"), which added an error PFN value
> > to the mix, causing gcc to comlain about overflowing the unsigned long.
> > 
> >    arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function ‘hva_to_pfn_remapped’:
> >    include/linux/kvm_host.h:89:30: error: conversion from ‘long long unsigned int’
> >                                    to ‘long unsigned int’ changes value from
> >                                    ‘9218868437227405314’ to ‘2’ [-Werror=overflow]
> >     89 | #define KVM_PFN_ERR_RO_FAULT (KVM_PFN_ERR_MASK + 2)
> >        |                              ^
> > virt/kvm/kvm_main.c:1935:9: note: in expansion of macro ‘KVM_PFN_ERR_RO_FAULT’
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: add6a0cd1c5b ("KVM: MMU: try to fix up page faults before giving up")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Message-Id: <20210208201940.1258328-1-seanjc@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> > ---
> >   virt/kvm/kvm_main.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 3559eba5f502..a3d82113ae1c 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1501,7 +1501,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
> >   			       bool write_fault, bool *writable,
> >   			       kvm_pfn_t *p_pfn)
> >   {
> > -	unsigned long pfn;
> > +	kvm_pfn_t pfn;
> >   	pte_t *ptep;
> >   	spinlock_t *ptl;
> >   	int r;
> > 
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> and the other two are the same as v1.

Thanks, now queued up.  I'll push out a new -rc with this added.

greg k-h
