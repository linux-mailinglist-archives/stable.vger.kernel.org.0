Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A7D2D7818
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 15:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405915AbgLKOnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 09:43:53 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41587 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404393AbgLKOnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 09:43:21 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4332E5C00FE;
        Fri, 11 Dec 2020 09:42:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 11 Dec 2020 09:42:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=lsjXstOyPJi4EKOzUzGcAuaYxPT
        2y3zCoI7pEaJZ6GY=; b=uKMgCCdo1IUNePECS0o9hxV9G/7igOyH9+dTax0CurB
        Kja8AGNbOWeWLpuT3OkbCuxkVzCCE95NvT4fs3ICwLJUPv9bzVWvTTBzkzZpXhj3
        aKnDYWzl8+2+U3LrzTZAMUIBBG2f76EmIDVXocQ9e90bIbUTZoVYZ+Sdn257ve2J
        skcIV3UZ7l5x9HqDrWwaHJ0Eir1oW6b6QiDvibwfeA/NkKWObk/Yj96luyi0m2Mo
        bTEPprL+jdjwUKQIEsULgitPbhaXTiz0FOtdfV8zwzKWDzy6G70Bios6YmS4XEYA
        RoNBRQhWnchKmhCWLtMnprRM4IFDwowF7QCeEctvdrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lsjXst
        OyPJi4EKOzUzGcAuaYxPT2y3zCoI7pEaJZ6GY=; b=SrxyrknWG2TdQxTcBxrxs4
        UA21bFezRONG3KXGdhMiUV2F6NK82qXnBhztCx0he4Iv6DpqgeG9hZoHifD9n7Y2
        cu0/hDAjl13Px6sC32pQQ2XZ5KZMpAZ41GTiMTijtGVJsf1iMvQAHR4tjGBz5llk
        gbTgkALqGvVlLFjaJt2pBcHB3RFEPdXJTBhHZE5LfhDEemZ376+p627NPFXdUlqE
        7oQ6wXHN8Q/IhE2/csKv4w2El0LtZuxQoT8MH2/GSGLSjKgJnQhE2L+jvePUeZi9
        kDYUQZfzuXtx+3Rbj4B2bYfZDpOkJUMM+C7DML/yqAyrnUQK7VDV6ghhEAAtaQQQ
        ==
X-ME-Sender: <xms:WoXTX1VWozoBBgHYeKQuRlJyNHwAID8KVmv7w46dsi7pNtAdDJWpaw>
    <xme:WoXTX1k8bku28B2by_XVfedyqx2vHGw-vMi7G5TlTyUJGLp6PFsE4XyL-uuKJ54mx
    _nQi9Fdyp55-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WoXTXxYAlO-yJU0AH7qJs45CRdGjVbcEa0c040Te3tNQOaq1qImq7A>
    <xmx:WoXTX4U5Q2dLq8QrMGaxhutNGpoafW359xOVFrWWgtlPLv9IHADggQ>
    <xmx:WoXTX_m_LPbxv-sEbJxGt0bGPOGQU3dX9aTZ_6h4Rmu7A9IT-0k7Aw>
    <xmx:W4XTX4BTOMiyu_ns73wnQB2QBELDc3oPZdBBwB8sDtgmtshHlEWZlA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C7F731080057;
        Fri, 11 Dec 2020 09:42:33 -0500 (EST)
Date:   Fri, 11 Dec 2020 15:43:45 +0100
From:   Greg KH <greg@kroah.com>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 4.14 4.9 4.4-stable 1/2] spi: bcm2835aux: Fix
 use-after-free on unbind
Message-ID: <X9OFodj07FsX1IQj@kroah.com>
References: <6a940079e894346e8ee00878ef844decd216e695.1607626808.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a940079e894346e8ee00878ef844decd216e695.1607626808.git.lukas@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 08:20:01PM +0100, Lukas Wunner wrote:
> [ Upstream commit e13ee6cc4781edaf8c7321bee19217e3702ed481 ]
> 

Both patches now queued up everywhere, thanks!

greg k-h
