Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDDC3E233A
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 08:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhHFG1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 02:27:01 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41611 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229581AbhHFG1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 02:27:00 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 012185C0172;
        Fri,  6 Aug 2021 02:26:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 06 Aug 2021 02:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=GmcLuPciE0nOIlSC6r4lUBh7a1t
        bjmCywfazxxDqUDY=; b=I59l2n1AaUqAneFuUQxCLrg/7U0ToKDJVhOpchPWloA
        FgRPeszvgU5+kko0CVMPCAsEWKlxCLWdI1oM2Zm2ncwgShP3/gjDU7MbOb+N4CYy
        AJ7Tt5V19GxzBYBOXmv/ahfI3IBvcZT6lw/UH3HZzx1aVQwk/cGc44J0Ti9jBM8c
        x65P/jrbdloNFVamu/m2ssQDNbvavHSbnWeFAarIaTdqCI8zcSOOHyahw85vp5m7
        h19rcr4firMKljahMxgRJIy1ZBSMQqg1iyz6A58ZMmJ5MbLDdVGt6ZpNzIAY4eeP
        gmwPb5mz1zNMAQiPGvAveyUm0PV4KM6qpzFahRQ6dcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GmcLuP
        ciE0nOIlSC6r4lUBh7a1tbjmCywfazxxDqUDY=; b=KDTeoQ0Sr6eEPV49c0BRWx
        wyUwibm6QK0aZZLdACAehZxIFJA0pBq8TkdOO5tlQyx1Jz+0GYBRrLJq2OzoAS0L
        C5Q2r1OW0if1j1B9fvVxiIgcn44FYepRon5bKE0zulUTY91DvNuV2fD+7Xk69HUE
        RtLPgJU8bY9UwrcPwmVLrxderQp0XtPOMpem6BYoMy9pKNPmkJ+kHwslzmeCTKAL
        KabhSckcu+XJIgdezpH6bfIgzye+riQjoHVFZXRoAC0pornciatJqsENSRB2Zqmb
        FL2XR5kl6OzuOLh3lRInmjBSTVsv5Q2/D705SY+HGsDd8Kl+KcBs/S8vj4nWYFjQ
        ==
X-ME-Sender: <xms:JNYMYRDjT6TTS6afUZZ_A14ucL9uMazQVrON0kukCSFqhUiCCJEZGg>
    <xme:JNYMYfgpujYTfQ54BBvm7TFq4dDyslWFUbF2mjJmMYlH40YNpbvQqO40G6NT-VECg
    i7_obHbnmir0Q>
X-ME-Received: <xmr:JNYMYckG-UboUbo4za0EW9pPlpLZ7yOzexi26R_1LYRYgfYKW1FoM90WKjYWLuNae2wVQHrCLZB5OO2MnntwoPlDUIlSbsj4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjedtgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:JNYMYbzlT8hdMOvUybj9tXHc9_DFOQhhXvEAp-8hGvdzj687NOef-w>
    <xmx:JNYMYWR9_x-0pGOYRVHmjCeSXFGrK5erKDAS0l_SC_IXA5PmlskqRA>
    <xmx:JNYMYebXhvuk_PwrcgV2_GTACVFGUEljaZcWTSIPI5bqBg6Z0Cxh_g>
    <xmx:JNYMYcMLKDeLHlq3zRnfQtpTTNIpNoGslOrPhU_FHqF99-4xnn0geg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Aug 2021 02:26:44 -0400 (EDT)
Date:   Fri, 6 Aug 2021 08:26:41 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 4.14 1/3] KVM: do not assume PTE is writable after
 follow_pfn
Message-ID: <YQzWIULC3KZkAcO9@kroah.com>
References: <20210803135521.2603575-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803135521.2603575-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 03, 2021 at 04:55:19PM +0300, Ovidiu Panait wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> commit bd2fae8da794b55bf2ac02632da3a151b10e664c upstream.
> 
> In order to convert an HVA to a PFN, KVM usually tries to use
> the get_user_pages family of functinso.  This however is not
> possible for VM_IO vmas; in that case, KVM instead uses follow_pfn.
> 
> In doing this however KVM loses the information on whether the
> PFN is writable.  That is usually not a problem because the main
> use of VM_IO vmas with KVM is for BARs in PCI device assignment,
> however it is a bug.  To fix it, use follow_pte and check pte_write
> while under the protection of the PTE lock.  The information can
> be used to fail hva_to_pfn_remapped or passed back to the
> caller via *writable.
> 
> Usage of follow_pfn was introduced in commit add6a0cd1c5b ("KVM: MMU: try to fix
> up page faults before giving up", 2016-07-05); however, even older version
> have the same issue, all the way back to commit 2e2e3738af33 ("KVM:
> Handle vma regions with no backing page", 2008-07-20), as they also did
> not check whether the PFN was writable.
> 
> Fixes: 2e2e3738af33 ("KVM: Handle vma regions with no backing page")
> Reported-by: David Stevens <stevensd@google.com>
> Cc: 3pvd@google.com
> Cc: Jann Horn <jannh@google.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [OP: backport to 4.14, adjust follow_pte() -> follow_pte_pmd()]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>  virt/kvm/kvm_main.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)

All now queued up, thanks.

greg k-h
