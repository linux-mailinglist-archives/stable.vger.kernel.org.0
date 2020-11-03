Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBA72A4B08
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKCQU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:20:26 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:36525 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727479AbgKCQUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:20:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 90245E11;
        Tue,  3 Nov 2020 11:20:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 11:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=hOF8FNvxc4SQUeq7TX/+p+QshEY
        nmOr7iflw8oTimHI=; b=3oMiCto3vdunkBDlZjagjxdMW+EqIIfuQa/XBr3UGqe
        BquYs6Lbzcwy9P9M3j+WSZzhWzBBcHI09YDLWq3r/4X9up/q6xcKtikazUa8hXGY
        zCro/SF43h0sL2yHsGK0NJAgaeoBhk/by9oU9UxRTDCvg9nPpN7+Lp076qcP8U46
        o9uu0evwANpDLiR24oideSwLrHfNKf6w/T5nT503SwImaZDM5/QHrCOCWDliSkxf
        f8DSQWe4NpJUCqiqcrIdqq82B5D1X4cHkypPONKhPYKi/bia2qGZLanl6mvv69Jt
        3ALUFpkyqhYk35Z5CTqdoJUGZrhnOlop8ZtZwxLbG3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hOF8FN
        vxc4SQUeq7TX/+p+QshEYnmOr7iflw8oTimHI=; b=ngu7Xt/H1wEkpifC8jydGl
        RoaHrt1PVUkyvn99UNZD51WbSQGY54wfSZGDyE/Q0zkzIUxgIR9xy+wgJ20Zj1bi
        HMq9q0No8R66NtHhAXMUkWV6u3E0ccb8iaTYmotJLdDT5lLvxHwJ/yP3IOOg/h1L
        uzClMtbIxKyUcd3T4YGz7LXfhR60Q8PRZcdXdLHDJsSmfayJTIAFXEg7q5u3cwZG
        ckdcG5K5H6bxh3Zl9m92KRGxSfbd3cZ+LCYVqB9XJyozlvpRyaDHpQVNpx5Ho2yo
        /ruI6QGOxMksnkkNfnnhsZ2vLQKAOfuJ8stdJ9LRHk2e4fGhAq9edZRs5FaXE3fw
        ==
X-ME-Sender: <xms:SIOhX9UYNJWaL-zE0vDueVJaa_ih4BUonhY77mRxXz5J7W5t4a53lQ>
    <xme:SIOhX9kM0Dc4uZP5Jb2QpK08hmZs_o7w42R7XOMo5U4s35Ce_rHknXdlBzP8ipZiG
    aT8PpnFGk9qXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:SIOhX5bGjKyPJ7tcEwP23FOsH8gzf1Ckqt05ChHzeRct987CvV6B8A>
    <xmx:SIOhXwW-hl2TrHjkkjBIoVTIdHTHO3Jccvahb2WSyPDcWZSBUBF23Q>
    <xmx:SIOhX3kq958SfMlQ7lMzePhmIc215tTOIBFE8MLrGZKETzTeKze60A>
    <xmx:SIOhX9Sh7Xu19UTqKE0U3Vut2M_KbuhNVaowm0HkpRKsggJXPRdRrA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2436328005E;
        Tue,  3 Nov 2020 11:20:23 -0500 (EST)
Date:   Tue, 3 Nov 2020 17:21:17 +0100
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 00/14] Backport of patch series for stable 4.19 branch
Message-ID: <20201103162117.GB80864@kroah.com>
References: <20201103141922.21026-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103141922.21026-1-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 03:19:08PM +0100, Juergen Gross wrote:
> V2: correct patch 2

Patch 2 updated, thanks.

greg k-h
