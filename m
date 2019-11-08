Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7564AF4CDE
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 14:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfKHNNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 08:13:48 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58637 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbfKHNNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 08:13:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 56D94210DC;
        Fri,  8 Nov 2019 08:13:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 08 Nov 2019 08:13:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=ddyJ32vAM4FDDJlCq7dlKHCzTJn
        rUJknqcsky0x73tw=; b=GtVkW8pAxlWja315VYtvCvMONOZEqpsIVwk1dG5LN/e
        j69A09w+CWFlLbIDrhZ90agMNiALNEYNcb/eIq4pI7n5s0h3iBRYlESRaKqgQa6o
        Rcdmm3xDy58Sz5KNiYTlhKTLb+HhLi/aoklGSjefFIfb4MGTTJC6Ba/n0Lr4coE9
        ZsapIYGbBuz9iYeDrof+YtQpfuNZmQsop7/Nvn00z/jIAcTnELhClJ2vMGgjYyyH
        sXm4hbALhY9/i1vKNjSziJ1FHBR6AxdYCo7n8L1W7C6p15C22l1w3JtVnMcNZJYW
        3A5JOCzBt0irPdAMrl1Le037+GXXUkcP1GNkCRAkbNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ddyJ32
        vAM4FDDJlCq7dlKHCzTJnrUJknqcsky0x73tw=; b=tRonAZymvlmbYY1rumC6mB
        HkyHFE3/v/wWkYsf9Arw6PXmTrRLnGxwj0xKPf5+IFN4Tt9wCb/9NlJ5u8dokh0x
        eTl3q//BM32/byWJaRF2Pn66Y3l60VIa/jiREdGBVxaVd7Dy2BY8sqdaBx3nfqwP
        5eX3X+m/3hnvkJYfnkuuToyCSVfhDz8uJeZktgN1suwpXbU25KnZbuVnDjKFafoc
        z6eaJb2jlHKUDP0X+Wcclc3dwVf9MvlGhDiH5TLgnW9EztaqbKzQ14+mm25RqAYI
        FE9k1oGLxZX95MivJrPGNO3pnAZ+cndMVLiV8849HZ/B31okW7Kly1DYj7KUHt5Q
        ==
X-ME-Sender: <xms:CmrFXcEOjwr8LgQRGXIqlBFrDnhC2GJhG81XSUoYcYihlokF54y0wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvuddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:CmrFXcD-lq0SAEblyFn1Yw3S072un-vNfGiL4jZbMXmfEJNVfRSMdQ>
    <xmx:CmrFXQXG9mxQnSz95NQFBj0K7YHf-zXBVpdQnbBEgQ3IT2mUuTR1gg>
    <xmx:CmrFXevrmxQyWEOGcRJfVtTypCRA7eXGEHfl7gDg6LrXrhB6hEmo4w>
    <xmx:C2rFXVVxkowxKGikfYWnem8M_lvW61ZHomHdwvSc6KSoS31aPkYWlw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 746348005C;
        Fri,  8 Nov 2019 08:13:46 -0500 (EST)
Date:   Fri, 8 Nov 2019 14:13:45 +0100
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     stable@vger.kernel.org, linus.walleij@linaro.org,
        rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH for-stable-4.4 25/50] ARM: spectre-v2: add firmware based
 hardening
Message-ID: <20191108131345.GA761587@kroah.com>
References: <20191108123554.29004-1-ardb@kernel.org>
 <20191108123554.29004-26-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108123554.29004-26-ardb@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 01:35:29PM +0100, Ard Biesheuvel wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Commit 10115105cb3aa17b5da1cb726ae8dd5f6854bd93 upstream.
> Commit 6282e916f774e37845c65d1eae9f8c649004f033 upstream.

2 commits?  It's just the first one here as far as I can tell...

