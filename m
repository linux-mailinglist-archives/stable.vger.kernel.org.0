Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F9610E77A
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLBJOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:14:37 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:37029 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbfLBJOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:14:37 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 004AFAF3;
        Mon,  2 Dec 2019 04:14:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 02 Dec 2019 04:14:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=o44SThFfissTvc02fWt23tDIbhw
        JsyuZeItjJ8xemQU=; b=mnCgT85ZS7bPI+pLgMIEEfzZtYeXu85IDkgWgGOKlPa
        xmLz47Yc9DWGa7IyESg6YqnyFlHvOqySW3jLNmn3vFs0sw3KWvRuvl3u91wOYHB+
        N/oXwdEhOJ5hmBR0jd/xxOHf/N1xRwly+Dpczlab53gKo1tnRB3ajii9DVI5qXMH
        u5tTeyZb0iaDJrKj0eAWFBbnTkUvntIlmhHzmRaIRs8+4kSBNNW55lpJwAy2F8Rb
        /Gh5Z6k9HnQCEddlrJrBSEpt7a98Cy4A7HWLtXgoEWO+RpitUKJAvG7K4thf6JK3
        k5b34hGct36Qlk4t1ByShFXhJAvpV+kMY9ekjBd0I7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=o44STh
        FfissTvc02fWt23tDIbhwJsyuZeItjJ8xemQU=; b=kTwnFSdzQub6YqyTbvoJp8
        TKOlwT4UsXDFTLsyYV2s4YyjYwGpYjCYEpE2ovd5CaAtGqMYihpLLyfeXtgSev/Y
        soKs64w89SMJ9w8uy4jqJEV5456T82mAWg7ModOjP2KFTrD/ahsqzQiesXYRyOkE
        SAmZZRs+E0YBaJlMtzfwPNG5A/ghVJaHcHct080pUz7Hic2BXeWe+CUThyGWTI+G
        d45q4TNwDDMLpA+dxbDWregT3bjVDXdwY3QURrzX1E50VeYL4PfLkzC4AqUhakQ9
        zG+oTtT96UhH1N9HajgS19QcKg6DcxW3Y84LcGS5qCcYDZhn4hwCZ28AOY6WZ8lg
        ==
X-ME-Sender: <xms:-9XkXeBx2_uHGTYgz2_KIPwpwIbfg9omAIKVZPV5U7tT5Pjdc1xVbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudejhedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:-9XkXUBHBuLkUXtwoDmUKLrOTWakceTRtrAnkcj34XsoxPd0gYqUqA>
    <xmx:-9XkXWol0nLNwA3bJGEeQkl7fNxi4CO3LGwftG5e5iUH-Tzgfc73CQ>
    <xmx:-9XkXbv2YJxr8cRPuq05FOwIWWyvj2WmfGMQmGiyg2tArgTYoDILAw>
    <xmx:-9XkXbIP5Cfu7pz8Nzq6X_ItxVZlsPpg5x-WPdQgPt0OrXx08021bQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0FF3180060;
        Mon,  2 Dec 2019 04:14:34 -0500 (EST)
Date:   Mon, 2 Dec 2019 10:14:31 +0100
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Christian Lamparter <chunkeey@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1)
 detection
Message-ID: <20191202091431.GA3945609@kroah.com>
References: <5688116.JcRxOpqE2I@debian64>
 <20191201170245.GU5861@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191201170245.GU5861@sasha-vm>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 01, 2019 at 12:02:45PM -0500, Sasha Levin wrote:
> On Fri, Nov 29, 2019 at 09:52:14PM +0100, Christian Lamparter wrote:
> > commit f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 upstream
> > ---
> > > From f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 Mon Sep 17 00:00:00 2001
> > From: Christian Lamparter <chunkeey@gmail.com>
> > Date: Mon, 25 Mar 2019 13:50:19 +0100
> > Subject: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1) detection
> > To: linux-wireless@vger.kernel.org,
> >    ath10k@lists.infradead.org
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > 
> > This patch restores the old behavior that read
> > the chip_id on the QCA988x before resetting the
> > chip. This needs to be done in this order since
> > the unsupported QCA988x AR1A chips fall off the
> > bus when resetted. Otherwise the next MMIO Op
> > after the reset causes a BUS ERROR and panic.
> > 
> > Cc: stable@vger.kernel.org # 4.19
> > Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
> > Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> 
> Queued up for all branches, thanks!

This broke the 4.4 build :(

I'll drop it from there.

thanks,

greg k-h
