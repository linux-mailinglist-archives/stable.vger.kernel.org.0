Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749D431329C
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 13:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhBHMnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 07:43:21 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38863 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232698AbhBHMmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 07:42:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9F34D5C0069;
        Mon,  8 Feb 2021 07:42:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 07:42:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=r2f1MQLip7D2d9wuRUzmSSsTUf+
        OPlwBIlFXW5RyV/Y=; b=eeV7+KlLY6iA8rhZoOFNtxHpp1T+HU5lRTxwE3wfISE
        HbAdL+3NyFqUyxN5m07q9dsRKng0+XWj6Ml11o8zR0Oxjery8iVk6rL2kAe5UO4y
        1XYY52LXJf4LQNPn3RhjfQBIrHUmlRPq55XH7biH9b61Tuq6Lf4C2K58po5TNdoG
        Cb83XHJqGwpkn5RqLmjXUEksCfsLlhWOTxZJLZd9v9wRy9MTW4RuFjH3SowVzJLD
        4Plv0bO5xbLfTiVAtDcNbMaLFTwQbpFLrKUGgp13ZIXyebLXhRcvcR2SNpRe9pvb
        tLQpOLv9iF3CK2XENdSuFdYNlayCQgQCTZ5Y+Yn32TQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=r2f1MQ
        Lip7D2d9wuRUzmSSsTUf+OPlwBIlFXW5RyV/Y=; b=p1tXUyr4f2Dz14Fwyzxpc3
        R6rZjuWB0xou2YyfNaRbHlPdJO/8mDyasL233Y+FWUT7TzmwWg3hwt9u9j+MVk/7
        GaLLvrDKsHPseS9kNwXsFoHKPKG9HcCtfDJbs30mryAJ2ewLSNVd+ivGNfnTA5pi
        mtl4lG/huUfyqz6ije1iMxEGqqE6k2G6cNG52OfkLkEF6GLix9yNrjnYzau78T9A
        ji2AM8WTxNlyox1c2VjLBe9U4elipc5ASaSjNoaBJ1BDzVN2o9ScTcSXgXx8mydH
        VXHcT0tGR7vB26oB6D+NaPy4ENGFeK+sE5UC+LyYaEU2DWSdIz7PbzET4JPPeMOw
        ==
X-ME-Sender: <xms:nTEhYOlRuKhqrd9FYzD_TQ8iu_DEQDA4E4Nul1LaNHKrmW0GIaGreg>
    <xme:nTEhYFy3U2lWJsTJRR9tSWeJywocIIXDo15EeFfQNjzLawXz99iWReGRP_vIYRZhD
    KvEPw2XJcJYQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeen
    ucggtffrrghtthgvrhhnpeevueehjefgfffgiedvudekvdektdelleelgefhleejieeuge
    egveeuuddukedvteenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:nTEhYJivVoHuUUTAwGxqiMGa_x3uLX4JmKF-v0fi9kXWYEGTvXIdXw>
    <xmx:nTEhYKVAdmVDsN7fMD4KNVlKef0ZzjlvYYpl1GgaJugSE349HzWETw>
    <xmx:nTEhYL3NiC7h0F6nGNaW7bXaQknprfceOmSsHRefcLu_qpAH0FT4UQ>
    <xmx:nTEhYAAC5uBw1lozo3ajM1XimmbGTu4OtYary9zdpyXhzgeZIYu_-w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D284F1080066;
        Mon,  8 Feb 2021 07:42:04 -0500 (EST)
Date:   Mon, 8 Feb 2021 13:42:03 +0100
From:   Greg KH <greg@kroah.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     stable@vger.kernel.org, rafael.j.wysocki@intel.com,
        stephen.berman@gmx.net
Subject: Re: [PATCH] ACPI: thermal: Do not call acpi_thermal_check() directly
Message-ID: <YCExm74avCXOCqnL@kroah.com>
References: <20210207210634.iaufnwzlibmpabos@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207210634.iaufnwzlibmpabos@linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 07, 2021 at 10:06:34PM +0100, Sebastian Andrzej Siewior wrote:
> Upstream commit 81b704d3e4674e09781d331df73d76675d5ad8cb
> 
> Applies to 4.4-stable tree

Both now queued up, thanks.

greg k-h
