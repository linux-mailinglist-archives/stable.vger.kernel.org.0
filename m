Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1E92B5CCC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 11:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgKQKYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 05:24:51 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45817 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgKQKYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 05:24:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 974CC5C00E5;
        Tue, 17 Nov 2020 05:24:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 17 Nov 2020 05:24:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=GrxclhTeEs/Nu4RfstehOco5P02
        q1DWOJgHj7ZJvVTw=; b=w934/waam+ocRVynfOh2rEQXyXKhrVcY5X/re/GEwOp
        M4YaQ/McAJygkAd1O0i3tW8Pl6aEAoZ9u4iaCnidB+qONIOULweLkvTxVC7whJCS
        t6tabNrDS28bxvMD7x/u1+G9/BEDTCHlQDOZNI9XtFihT4+rCQ6WH2FWPgfPy+3t
        YgANvWh3A2U8N+CpXysLldwiRVbXkPl0kxHbmDQ+s0Vr5TBDqe1pKPkq6t1noMH/
        /Wc5C4g27qXj47FmcBklzFtrijx1cseuY0epx7xDjeDlsqouyqQgMMSKxSaUHUmr
        nMOChmivKqOuz/nCzRSogK/DyWxbPb21BUKYIuFPHPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Grxclh
        TeEs/Nu4RfstehOco5P02q1DWOJgHj7ZJvVTw=; b=ZYwB6lbn4zbziMl5XLd3/o
        5SQEgVh5JBMAWEWKiBCTZ9f/V1x4kHQilcxxHr1Ef1tnVC1W+UR3thSd2glcU5gt
        PfJU/vFcmmh3QN7AK2HaCjpgg/O263hreooThLn+KoBp86hy8oWOU8S5UE/XrM/n
        IVlRuW6oCgMn2UuHwl2fZMGrhVugH4OR/ILBim+n5kwqaktGkFjVroG+jA05rkiG
        FuknXf9eXDpO+wX6/FZ43H2CenYV/TETEYYddCKoDyWk8PlOlBepEKtEKndmPwhd
        9uNabmaWe+GqrazwwQcL2jOxpt5fKvIkjkyZfWQwjZR1ITIATR83qtCtB2MdR5KA
        ==
X-ME-Sender: <xms:8qSzX2Av_Cm2rpSIC6PFDR-kYO-UpbRp2qiOHyVL8MVAN69-HFvrgQ>
    <xme:8qSzXwiIZqeicwOXHQk0RGl8vpxUkcCRrYrKRQdg4UZHwmk0sfhfyMKF8lWZNWFOL
    -zT_y_wewmEYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8qSzX5lzn7O6Sxj6tgE05eOppERu4unNGbmBKzyUN-rXRWL9YYJW1Q>
    <xmx:8qSzX0war0DbFzquHuzQJwC2_rrYHCav1FgzGfo0ORNQKdGdenWfPg>
    <xmx:8qSzX7Q-gj58y7LF_1WHVTJnN_CMUoCSQGh4tRphR9iqegVZDSAYVQ>
    <xmx:8qSzX-OzoFPMjRYHNc_kGVQo-PW1dCJZc8hWbQH0junP5Q8KJZUPYg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AAFB93064AAA;
        Tue, 17 Nov 2020 05:24:49 -0500 (EST)
Date:   Tue, 17 Nov 2020 11:25:37 +0100
From:   Greg KH <greg@kroah.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     linux-stable <stable@vger.kernel.org>
Subject: Re: Stable backport request for 44492e70adc8 ("rtw88: pci: Power
 cycle device during shutdown")
Message-ID: <X7OlIVJLWq8y9xtn@kroah.com>
References: <747E6F28-BE7E-424B-A879-7EA9DE015DB0@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <747E6F28-BE7E-424B-A879-7EA9DE015DB0@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 01:55:14PM +0800, Kai-Heng Feng wrote:
> Hi,
> 
> Please backport 44492e70adc8 to 5.4 stable.
> 
> The commit fixes broken WiFi for many users.
> Currently only stable 5.4 misses this patch, older kernels don't have rtw88.

It does not apply cleanly there, can you provide a working backport?

thanks,

greg k-h
