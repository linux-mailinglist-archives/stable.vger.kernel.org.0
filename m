Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25391FB617
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgFPPZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:25:42 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56095 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728557AbgFPPZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 11:25:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D8A015C00E4;
        Tue, 16 Jun 2020 11:25:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 16 Jun 2020 11:25:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=25Q+zVjnA61PlZbscGTxjkAZQym
        PTTnvTYDAR1gloaQ=; b=CQkcM19XVnfdCTNt8TRktlh3BqTirDbFgbjvu8LrqBW
        YCqRKkJcHaDU2LzH5qws0iQXjKLsQV37BjpnUEC54h6TRuF6ArrjFT1giP3JGYm8
        l92/jvkVNKodVKChcqLbHt0MJk0xY71densYT2UpLOlQh2kKnYrXXMkkGU6/AlTP
        rrTWv4EPxGjN+8xt5fLBWiuQMe3k+WBdFrLlAe8uSVgTW4AAzvtOtZizrti65ZAQ
        sEgRRGhj8ryiuuCBhUwojuFKZCp629VYKUSo1TLukOfd2hVP2Hn6f+KRUhPSVdtA
        8q7jUCiOkz/TBwazWPK5YcduqpF9IzM37M59Iuvb5XQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=25Q+zV
        jnA61PlZbscGTxjkAZQymPTTnvTYDAR1gloaQ=; b=dCwNNqrGlYEUIU++5Ysvyj
        BgxgGSWPW5LVZRG9nD/rYyj4w4iv8YYAXXkbc/i2oMIQumn6/jhKnZU7WHYmP3jV
        g80dvZD1f1BKi7plUS5AvtkuBKlLkulWl7EiZMrLoHzLAlJ8l9wgduJST6TR2q7c
        Xb6oVYBGA9e2KGMWk/6vZGRX2gvoJXvoYP4aSH1paj5iU+c723mangKtZvP44YQ5
        DOk7KjGJreZCGzhSZxK/P1y5j5rlp06W24p757u/YLdd+ThJbE/gpNzfncgihZ+q
        fwQTHejnlhO9UfLjd8aGWHdtGrTVLG3l7cFaxSOWIU942/X292yLzIFlLaWynbFA
        ==
X-ME-Sender: <xms:deToXkKp2eHwA1MN7kEP1CIL3AWynAY38jhxM8WZdfatyvAzZxyZVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejtddgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:deToXkJ5jETPIR3djQRxIT2oWFvGRNpn9F9CCtq0OCM078PDrUziKg>
    <xmx:deToXktF-WCObNkStZDlTgVR1ba9dE58OQe5_elcEPIENEwiOVRdKw>
    <xmx:deToXhZPa244s83CVdGZUz5DHRQfbNz8vHlS9Uc-oxIQQnUgxxChQw>
    <xmx:deToXqniZsrjG4nNJPZ47sdkvIM12xIbUHFXhNRiHpWPGAyj5Bo06w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 010F23061CB6;
        Tue, 16 Jun 2020 11:25:40 -0400 (EDT)
Date:   Tue, 16 Jun 2020 17:25:36 +0200
From:   Greg KH <greg@kroah.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH stable-4.19] KVM: arm64: Synchronize sysreg state on
 injecting an AArch32 exception
Message-ID: <20200616152536.GA4079045@kroah.com>
References: <20200616140518.2216674-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616140518.2216674-1-maz@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 03:05:18PM +0100, Marc Zyngier wrote:
> commit 0370964dd3ff7d3d406f292cb443a927952cbd05 upstream
> 
> On a VHE system, the EL1 state is left in the CPU most of the time,
> and only syncronized back to memory when vcpu_put() is called (most
> of the time on preemption).
> 
> Which means that when injecting an exception, we'd better have a way
> to either:
> (1) write directly to the EL1 sysregs
> (2) synchronize the state back to memory, and do the changes there
> 
> For an AArch64, we already do (1), so we are safe. Unfortunately,
> doing the same thing for AArch32 would be pretty invasive. Instead,
> we can easily implement (2) by calling the put/load architectural
> backends, and keep preemption disabled. We can then reload the
> state back into EL1.
> 
> Cc: stable@vger.kernel.org
> Reported-by: James Morse <james.morse@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm/include/asm/kvm_host.h   |  2 ++
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  virt/kvm/arm/aarch32.c            | 28 ++++++++++++++++++++++++++++
>  3 files changed, 32 insertions(+)

Thanks for all 3 of these.

greg k-h
