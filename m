Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D69A164FEE
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 21:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgBSUdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 15:33:16 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:55949 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726760AbgBSUdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 15:33:16 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 75E1872E;
        Wed, 19 Feb 2020 15:33:15 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 19 Feb 2020 15:33:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=xGi9fA6ewJYeQYIyw8XMVeTlHau
        WC/uXzSIZBCLY2wY=; b=k0wNH+ynZgjHvRi9JvyRp1uwOHjYAXPWJENgbap0aFq
        Fc7LezAMeTU3om5BX0xhtHOaIuDEOPsF+B4WQelcQxkQ3TgZK0GQFwGYw7cSyzeJ
        /ktZo32ycxM7yjx48qEkRZRmakJmEc3vi+odsZ5JxPPHlzLOvyrig9SltBawY0Ek
        QtlqPZaRgjwoxITjgPVLtAtI4znwPMEAt3be8Gp5i3QrxqrNoRaRLWpk+U0osp7k
        et6aAOAkkwml6aV3MJGsXEWBkWBBfTGByMh9UQbJmvc1QxMkPopUMIRyzhbhit1q
        rAHeuszSaTThUz3aOKrflaUVsNflTh4Ic6iH9cdJzZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xGi9fA
        6ewJYeQYIyw8XMVeTlHauWC/uXzSIZBCLY2wY=; b=O3IzysPFvf9a78DqI50Bka
        s/8jGE4Ne7g4e6ahWYadzaQ73t38+0P1AORFRx3wPg/QZnzCZU9Q8+bdxDnK2WHT
        cFKnOt9/VF1IjqYkNTl6z8XnjHTwGCsqxNJq3u9Uwpv+yetbiircJ7Y7Wztx3cvg
        4Wd8Nc9WDXC8C8CF2oCi2xmmGTbPCKZ5Khe4d10sZagJMABFRdcfoPJDmB9Jvz4b
        IDXo+H807fuwQ055At6vfSgshaWZR29H+G7o6t0moNh8pCxt594sr4iRdM5QoN0A
        OFJCZT0Rl2uRRZ8YGgSGbJZxXJDQUv+VKibhFVgKRiJXcPFbGyJ0agjZKDcrQ3UA
        ==
X-ME-Sender: <xms:iptNXhMrqBRm5K-4kp_gqVXpr8ONVA7oc7TRQHUnKMf4m2N8vq4CnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedtgddugedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:iptNXqhydyc7OldgKg4t69bdcZFQvYab-DM6KtFfR1Ti9YGWV8CGzw>
    <xmx:iptNXh8fopZsnokLz8URY5dc2_ed6mtTZ58Su3ZHsUAhRMCQ1wwasg>
    <xmx:iptNXnJsgA_kKLVz_2_Xw6AD06yfnsDDsOMf7mtruaT7eCIS6DcN_g>
    <xmx:i5tNXsh5shvZIPRcTpC6qlmzXm48jxiheQrdYUeBweeGY7c2Z-9r2Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C5123060C28;
        Wed, 19 Feb 2020 15:33:14 -0500 (EST)
Date:   Wed, 19 Feb 2020 21:32:59 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200219203259.GA2887937@kroah.com>
References: <20200218.154107.1558318594551687515.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218.154107.1558318594551687515.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 03:41:07PM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.5 -stable, respectively.

Now queued up, thanks!

greg k-h
