Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20881FB623
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgFPP2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:28:04 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52219 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728919AbgFPP2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 11:28:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 409415C0067;
        Tue, 16 Jun 2020 11:28:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 16 Jun 2020 11:28:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=5y9AmCCjeUZeauU6i0hEHAo72sH
        zfdV2cm8Kz0wg7KE=; b=mSjXWy9P71RxCM5kyWmgdyesawTiqYC6vxX1VVC3tQl
        gtTov0Cwre45OdJ9r59BHTIMFhSkNJUe7ttW5qHDLQKwtCy2iFCxyydt2Ns5/OuX
        6opP/9t/AYzoT/dbanzKA71SarbKRharCXJqKgg49QKHH03KY2kTRE4YJOzHBSXM
        VT+LdDQFC4xYQuY0Gw6VFVpLtsGRiVtxAUJiRk/YmOFpR4YlhuGXhBq75xEGCWzb
        1ROBVxFj8W9XtghrKd/nXs2LES5v9aSMf9b2UkATXthDrqgBw8nDvQfKrgg/xSku
        4UTTvuspmZsKfgyFsSNeJTE0Jh5D1J/h8n12q7TxHag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5y9AmC
        CjeUZeauU6i0hEHAo72sHzfdV2cm8Kz0wg7KE=; b=CI74hBUeSg3wFq/hQqvnTM
        H4CKTWy5SGJ3bpmQUdladKg+APJ+Lfw1Ugyz9ueNDSZnB8dHWsoZlsilctXrrqoN
        istVnYicqycMChPFggoMzk/dXL3T/JmaxJkGtAE0TRnpWhRCJMcGQMw5EXK+rMoJ
        DgqihZO06fzse/Tg9wabwi15U5ypm5YSXx55b9VjLzkKGOo9F8OLpmcwlDGM0cop
        eKXsl5EIlWOtScJs87exJZfhnVTlyzL/xhTYI9O99VGqArrkdolJxj9gEqeV8c0R
        NrZVjUl9yYK7zGNf2To00q1g6JGmc6CimNBECDXwctPaEEKyR1oZw8NtyBS3EPew
        ==
X-ME-Sender: <xms:AOXoXh95m-CdjyN4of9kQHjkzcue9jTo3P6wQQeuzN4R0rNLZoShtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejtddgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:AOXoXluIjiMIdG9a0P0I2JeHdQZNKLONuwfH8C8Z6-RayUI9eIsR_Q>
    <xmx:AOXoXvAodscD6lz62lZVFCiDf16B10tapTUY63hsdu6LuL8MrGGq7g>
    <xmx:AOXoXld6OjiwwwhKP0aJfYPMTMO9SFaBq3EHF6cy-yPMKdGVSSzoKQ>
    <xmx:AeXoXjqVXk_rjrJjh13lLc7M_a5e5395NcoeWc1uoP3DKTWka7XumA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 25E1630618BF;
        Tue, 16 Jun 2020 11:27:59 -0400 (EDT)
Date:   Tue, 16 Jun 2020 17:27:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH stable-5.6] KVM: arm64: Save the host's PtrAuth keys in
 non-preemptible context
Message-ID: <20200616152753.GB4079045@kroah.com>
References: <20200616141502.2217274-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616141502.2217274-1-maz@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 03:15:02PM +0100, Marc Zyngier wrote:
> commit ef3e40a7ea8dbe2abd0a345032cd7d5023b9684f upstream
> 
> When using the PtrAuth feature in a guest, we need to save the host's
> keys before allowing the guest to program them. For that, we dump
> them in a per-CPU data structure (the so called host context).
> 
> But both call sites that do this are in preemptible context,
> which may end up in disaster should the vcpu thread get preempted
> before reentering the guest.
> 
> Instead, save the keys eagerly on each vcpu_load(). This has an
> increased overhead, but is at least safe.
> 
> Cc: stable@vger.kernel.org
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm/include/asm/kvm_emulate.h   |  3 ++-
>  arch/arm64/include/asm/kvm_emulate.h |  6 ------
>  arch/arm64/kvm/handle_exit.c         | 19 ++-----------------
>  virt/kvm/arm/arm.c                   | 22 +++++++++++++++++++++-
>  4 files changed, 25 insertions(+), 25 deletions(-)

Both now queued up, thanks.

greg k-h
