Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07A00BD31B
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 21:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731206AbfIXTxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 15:53:19 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53123 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727204AbfIXTxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 15:53:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8E84453B;
        Tue, 24 Sep 2019 15:53:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 24 Sep 2019 15:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=0
        DABbGHI1KsUtv7Qm/bD2WsnuLzwF7uA1zmazrd6eu4=; b=Y2A0xNKZS7esPyqk1
        qTugC0xUe3Avu21TqD4NDWOinX1odr/Zp6uGA/moqaw46pGGT/hqwGP9Kxb4h+fa
        xN1+Aty3rs0Rkpop4OtXKQUJ7XD6qRDF0RNZwtO8rGW6G6JNMLCY7FC5agJadH7c
        FnKI2XOF4XL+aM2LYn48CTP+bZh6wLrWQFkAiJEBOuUNncOypLtcKkkoHyWEmrlW
        J4SnojqgMqGRKaw8uOfuHC/rTjrS5LaefuJOulaRBqJl/LDbCkSzm5IJtDyLwATK
        xPIEmOxvbK03SNnU8i6aCQacVevCdO6/ajYCygZFxTinWD4+j+2qqHZZ5HU5zDJ0
        2yaJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=0DABbGHI1KsUtv7Qm/bD2WsnuLzwF7uA1zmazrd6e
        u4=; b=TLjZsfRNp6+ZsS1FIJbJP3+0vOToLYpprblLGNFWvs/Qs3LZ27SeGlDoB
        NLh1olliRj+hd6xwep0hiSlWxGKZCj8LG6Ulfo4X2Ra6jJ3qxvElr8NSSt7Od2Dv
        R1tsp5yEWOjRmboYqaGgP2x7j/AvYywvolTGuiATmPw1SBPY15EO11IlZ59C0NSn
        uYjW6pkaAWQzai56NstRiEoYbwqLz7mpT9SZLw5hbFPlLLlqkO9Px60hzNHhskCQ
        +QKQH2SXeHY1G4Xyz+QCIRGcfhSkCnYOBpA5ItA+5tt5f2XGJ1o7S/UbM1+S4X1a
        EpsecSzok12Ui6bCv1UipPUCrPu0g==
X-ME-Sender: <xms:LHSKXXP4OdWllSz58l8FCHDZ9xteUDXDu6M15VeCasZ9LNNDgAY_0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedtgddugedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtredunecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:LHSKXZDgjsIBbuVSqlVdaq-1pjsWxzEalCuWL3H5kpxNyZSTrkjsBw>
    <xmx:LHSKXaiujaiQhVBxx42wagGRGKUATyKCSace0F2XeQl9_U8E1xuQRA>
    <xmx:LHSKXecpo1LoBFUPfeI7AyvfrKQoKKeGzxEppMWIDRryNfReXTjwXw>
    <xmx:LXSKXW2WTNU-cxeqys7ah0B5rYuWd2N7wKipZ9pZnRjOGih8jLVdLA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89718D6005E;
        Tue, 24 Sep 2019 15:53:16 -0400 (EDT)
Date:   Tue, 24 Sep 2019 21:53:13 +0200
From:   Greg KH <greg@kroah.com>
To:     Jeremy Cline <jcline@redhat.com>
Cc:     stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Filipe =?iso-8859-1?Q?La=EDns?= <lains@archlinux.org>
Subject: Re: [PATCH] Partially revert "HID: logitech-hidpp: add USB PID for a
 few more supported mice"
Message-ID: <20190924195313.GA1000135@kroah.com>
References: <20190924191311.22413-1-jcline@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190924191311.22413-1-jcline@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 24, 2019 at 07:13:11PM +0000, Jeremy Cline wrote:
> From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> commit addf3382c47c033e579c9c88f18e36c4e75d806a upstream.
> 
> This partially reverts commit 27fc32fd9417968a459d43d9a7c50fd423d53eb9.
> 
> It turns out that the G502 has some issues with hid-logitech-hidpp:
> when plugging it in, the driver tries to contact it but it fails.
> So the driver bails out leaving only the mouse event node available.
> 
> This timeout is problematic as it introduce a delay in the boot,
> and having only the mouse event node means that the hardware
> macros keys can not be relayed to the userspace.
> 
> Filipe and I just gave a shot at the following devices:
> 
> G403 Wireless (0xC082)
> G703 (0xC087)
> G703 Hero (0xC090)
> G903 (0xC086)
> G903 Hero (0xC091)
> G Pro (0xC088)
> 
> Reverting the devices we are not sure that works flawlessly.
> 
> Reviewed-by: Filipe Laíns <lains@archlinux.org>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Signed-off-by: Jeremy Cline <jcline@redhat.com>
> ---
> 
> For the v5.2 stable kernels. v5.2.11 picked up upstream commit
> 27fc32fd9417 ("HID: logitech-hidpp: add USB PID for a few more supported
> mice") and v5.2.12 picked up commit a3384b8d9f63cc0 ("HID:
> logitech-hidpp: remove support for the G700 over USB") with some
> conflicts because this patch wasn't picked up. This backport resolves
> the conflicts against v5.2.17.

Thanks, now queued up.

greg k-h
