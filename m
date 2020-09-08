Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53FD261FBD
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 22:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgIHUGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 16:06:13 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37479 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729912AbgIHPVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:21:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 2DA495C01DD;
        Tue,  8 Sep 2020 09:14:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 09:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=2qA2WwVOYTJ/JKgn5QKD5CyblkA
        Y4zDi6p6kW5fywlg=; b=mxduW+tKdNbTwHGOez6fvBmNdK7lYsPlETKXUYK+v0d
        DAqiNaftey51UE9+y8s2tlTgdQm6lZ+E2Eapz1PadTBE5V7wVIB1rmOMhr3u/wRg
        k8sMg3dyI1+h3ai0d2oktWKn82SBsBTs91S7b2l2Eb7ree0QUphWqhvBrnbvmxVj
        ymuNsu2nZAic2eSJsNdW/BMLPpfSJWkx7D7azTl13nf5tZP8BhIyHzGx+9rNVj76
        FYW8FIA8gYkT49qXa0cwsgieFZaD8GnSrn+5dHZhE0pVjCe420iT0DEMXvGp+JHC
        wcXrs570996TW7f9gGbdmIYbFAYnrQjsk32PijApKNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2qA2Ww
        VOYTJ/JKgn5QKD5CyblkAY4zDi6p6kW5fywlg=; b=nWMyEuJgtvi9DoGOOMxMy+
        qEw0JY2SUat/yVPxd8xQE51TxRYsZoRQSnqNFvfxmnyhzdPrIP09IJOL7uV2S6il
        6qvoP0/w+WikPlbN6OF2EEIkrtXPzQmzSqSK7YLVXnUNBblfJGDM5aF9G6bYQiF2
        0CAfPjjEjj1cBnErOBKgkctZ6kidXMSlvyhjBBM765tls3qVDLpFth9Jl4iRwf3C
        VvP3ssIcgSoydmVTNVc8umCCu71u/WKlWgfos8clTitkhupppt4o5M6SgpxL/g77
        vAfRKvlLrWm4BkYg5+OPg1omN7jC/zAOaj2tBV14BlLsEeGJUiDuajOkmegFoIBA
        ==
X-ME-Sender: <xms:l4NXX3vqohG3EZ5yDEt8v2s7qofZANuz7VjTraUCdNMR8F4EaQotPA>
    <xme:l4NXX4d0YvyzxYRfkSfPKAi9Lkk2l-WU5VJCGtu9aUsAGAtOJhKFfNicA8TRxCTRt
    _vfIy7P66cGmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:l4NXX6w_cWBcc0e0yQLJySA_F8eraGM5r9132rc_8GNVvYc6jQ6cMg>
    <xmx:l4NXX2MQ4O7mD-IhxfOvGrv4WyL2fYIA9k8p3ZKm77u2Rl__U8bBDw>
    <xmx:l4NXX3-wpzWVirztDz6qHU83Ak7Mf0t7QnB7118vApgvmyeXBJICJw>
    <xmx:mINXX5KuYjF0XQTuSZ07ayQ_96_Iw9llbcONc3npn4rU02npOoeN6w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 622523280065;
        Tue,  8 Sep 2020 09:13:59 -0400 (EDT)
Date:   Tue, 8 Sep 2020 15:14:12 +0200
From:   Greg KH <greg@kroah.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH stable v4.19 0/4] KVM: arm64: Fix AT instruction handling
Message-ID: <20200908131412.GA3173498@kroah.com>
References: <20200902100821.149574-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902100821.149574-1-andre.przywara@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 11:08:17AM +0100, Andre Przywara wrote:
> In some architectural corner cases, AT instructions can generate an
> exception, which KVM is not really ready to handle properly.
> Teach the code to handle this situation gracefully.
> 
> This is a backport of the respective upstream patches to v4.19(.142).
> James prepared and tested these already, but we were lacking the upstream
> commit IDs so far.
> I am sending this on his behalf, since he is off this week.
> 
> The original patches contained stable tags, but with a prerequisite
> patch in v5.3. Patch 2/4 is a backport of this one, patches 1/4 and 3/4
> needed some massaging to apply and work on 4.19.

Now queued up, thanks.

greg k-h
