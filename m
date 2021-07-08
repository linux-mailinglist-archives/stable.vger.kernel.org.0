Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662CB3C193D
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 20:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhGHSh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 14:37:59 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47623 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhGHSh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 14:37:59 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id C4D795C01B3;
        Thu,  8 Jul 2021 14:35:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 08 Jul 2021 14:35:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ttC9br+4URtyQYhyZuKB58P4L93
        9mdQxF+sgbPuugAo=; b=JzbBD2lo6GWXpczBqEfxeR+hMDQ1cUjuNXUyNFpdrdO
        wp58edSokuo++UksdkIXQwIBYAH8+n1sj0l6+aGwIjkoDvEcpaZ7M9dKroluB2C7
        d5wpXFkPnYVG/9VEIh2kRINciyPE55GXfQSbUul5hyWooMCdpiyr7kZ+mf8Kxyt8
        s5qDLJBuALS8yo5AIGSU5CXpcjMIqdOrIkRf0D6xfSLNFCF6SYnuHxT8QFwC7Yx8
        n4reoG6S+35BJjY8RpG4lBh7SjVTVq0L0yZZX5kiAKZoY3mYZQuZ8SD2g1YuiSUP
        VL/HvbagjecfeEp0j1VAW/pQM6QMZejKLriVdbHnN6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ttC9br
        +4URtyQYhyZuKB58P4L939mdQxF+sgbPuugAo=; b=JeJpac8btdmg70SkAB8yH7
        +c0clzf7f3i9fujRnbOKvEfcOYqViC2PP06BZReKEeh54KQ9fKfnoEqNZC+KFskA
        wnim1oxzhcuJ+wkl4km8M8RFsEbr5SWaTWMQ7lKvoFVG7G2auVQn2O62bBXtJLFX
        /3ALj4W5Q5yl7tpWGw/+TVYdEOpLYVctWOmrVCgaw0nFSCYM25MAgLD9e4ktjhkH
        WrDBfdgaZCythMzBWowy6KT2oi4fSO3ESV8uQDKa4y2rlo1CZLUXLzEXki7cyF2l
        GaBFHz16gFJ0BhrKn+6L9LNb/bJpGerEKwX7Exj4yW3DgYg3LDGJWX5mnU9mdIvA
        ==
X-ME-Sender: <xms:ZEXnYFLlN0ZtuYLOrKMj-blEb0GJ2ScJrUBmGEHU3wKhkxOLCY8Bdw>
    <xme:ZEXnYBJsYunPQ2yMAOr7h4mE-lkSVrpYsO79wWq2t2KrFf-GE9SjpXjUmsbTeMY84
    hke9tgTI4GqUQ>
X-ME-Received: <xmr:ZEXnYNuH-P-Owl6bp1nuO8khT-55_Tokz2X8XGkv33z47v9pL70k84yrAd3dZCWgQjAhrtNcI5SWKeU-liCSh1OArQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdeggdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZEXnYGYGqLPQ2_eRMrJJyiNq_GFx5Z3-hH7H0aw7yMRAQY3smOXOTQ>
    <xmx:ZEXnYMYhlgozx6pO7PP3hXqLq3lkavmAjzp1Cujf4X2RzXIMb4r30g>
    <xmx:ZEXnYKDhsrugQyiHSdo9xPirBVdASSVYEU45XCnPy66SPg9rZ0qJig>
    <xmx:ZEXnYCMdFdYywnwhBJXicN2YtCvTKM4PnYFVWzM5Ww3_HnRVGe1i-A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jul 2021 14:35:16 -0400 (EDT)
Date:   Thu, 8 Jul 2021 20:35:15 +0200
From:   Greg KH <greg@kroah.com>
To:     Alper Gun <alpergun@google.com>
Cc:     stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4.19] KVM: SVM: Call SEV Guest Decommission if ASID
 binding fails
Message-ID: <YOdFY+zKovWj84tW@kroah.com>
References: <20210628211012.60827-1-alpergun@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628211012.60827-1-alpergun@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 09:10:12PM +0000, Alper Gun wrote:
> commit 934002cd660b035b926438244b4294e647507e13 upstream.
> 
> Send SEV_CMD_DECOMMISSION command to PSP firmware if ASID binding
> fails. If a failure happens after  a successful LAUNCH_START command,
> a decommission command should be executed. Otherwise, guest context
> will be unfreed inside the AMD SP. After the firmware will not have
> memory to allocate more SEV guest context, LAUNCH_START command will
> begin to fail with SEV_RET_RESOURCE_LIMIT error.
> 
> The existing code calls decommission inside sev_unbind_asid, but it is
> not called if a failure happens before guest activation succeeds. If
> sev_bind_asid fails, decommission is never called. PSP firmware has a
> limit for the number of guests. If sev_asid_binding fails many times,
> PSP firmware will not have resources to create another guest context.
> 
> Cc: stable@vger.kernel.org
> Fixes: 59414c989220 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_START command")
> Reported-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Alper Gun <alpergun@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <20210610174604.2554090-1-alpergun@google.com>
> ---
>  arch/x86/kvm/svm.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)

Now queued up, thanks.

greg k-h
