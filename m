Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B3710E77B
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLBJPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:15:32 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:55893 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbfLBJPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:15:32 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 20F26B06;
        Mon,  2 Dec 2019 04:15:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 02 Dec 2019 04:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=cqlRbD8HH8QroHRMAgdnJN6MUjv
        JtjWf/1/PwaBqfjQ=; b=hlfaosp4+ztrCBotkCdw54uUivHm2uDt0ZI/yLp7bQi
        Wp4BYMtm1xelnDBLITt4hk8Q1bgztgzONTXJYUu7Z6XR6O9DP+1fGKjgKZFty9zA
        ai7th2Pz0unXWNeW7wfslO+yH6RKF6OlOwYWnRNewHrAskcgp8vGcw5yt1cio9Xv
        +4YKCV+k1kycMzBpiPvEdEoElfaPEsdVB8VraZrUxL9pOQy07vNcJzzSuaX1Q/yj
        bZnD5UUrfDJL7AQhQxnsFqUdxjna9JrrOl2Rx5gDPKEO9K37MxZPFfCCzb0rzv5L
        NaEs9ySTqZyDLKRgzJQs+YiaBG0B+6lKav65TQ/nyOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cqlRbD
        8HH8QroHRMAgdnJN6MUjvJtjWf/1/PwaBqfjQ=; b=BplFUUvojVlaP4FY6UmRiz
        TUw+yq9kN7pY0zc8c1gxCnx2Gk3VMDgPASu87htCKKgFcTjVTq2sRViHP2GRRj5u
        QJm66H39hLVcLiYpjKVPGim5s0MMIkVXLGBHaOO7NIpwIjnIMpld24u6NKlClkzp
        AVthavKXhu16wimNOyOo5GgkNMZjwrznIg09uVqhKcPRxIZwuN0O+96RBcmp1RH0
        nzhJLi1XeB8hxGNej4S9UBA3txIykH2lQTMBc2nlW6G1AjO1YTQ3ChOmkl/LNM8L
        rVsE4/ZWu55W/swHNTgCTDCWYasT+yWcRNMXjkXP26qBQmT08A2YXm9cBsHlbndw
        ==
X-ME-Sender: <xms:MtbkXSg19p8Pm09vaeNbVzZq2KCCHqHYxOjRoYFBejonGptaIqUDIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudejhedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:MtbkXQJPjDUkrIuZwBG_kYSF5Xo_oZtRzYgKsmawB2Az20xT7arvlQ>
    <xmx:MtbkXZHJjXHUnL1loTxa-MZctc2pP12oZ8A875416XytIlW2_3t67A>
    <xmx:MtbkXcRgXKL0onvke527Kgr7uldkuop8uWtoxZ18-mGb6pwjLi8-7Q>
    <xmx:MtbkXfhAC_ZOMVe83OPqMgbgdIDxFvH7A-ZdDfWrZiutc6sjc5PTlg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 39FF780061;
        Mon,  2 Dec 2019 04:15:30 -0500 (EST)
Date:   Mon, 2 Dec 2019 10:15:29 +0100
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Christian Lamparter <chunkeey@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1)
 detection
Message-ID: <20191202091529.GB3945609@kroah.com>
References: <5688116.JcRxOpqE2I@debian64>
 <20191201170245.GU5861@sasha-vm>
 <20191202091431.GA3945609@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202091431.GA3945609@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 10:14:31AM +0100, Greg KH wrote:
> On Sun, Dec 01, 2019 at 12:02:45PM -0500, Sasha Levin wrote:
> > On Fri, Nov 29, 2019 at 09:52:14PM +0100, Christian Lamparter wrote:
> > > commit f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 upstream
> > > ---
> > > > From f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 Mon Sep 17 00:00:00 2001
> > > From: Christian Lamparter <chunkeey@gmail.com>
> > > Date: Mon, 25 Mar 2019 13:50:19 +0100
> > > Subject: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1) detection
> > > To: linux-wireless@vger.kernel.org,
> > >    ath10k@lists.infradead.org
> > > Cc: Kalle Valo <kvalo@codeaurora.org>
> > > 
> > > This patch restores the old behavior that read
> > > the chip_id on the QCA988x before resetting the
> > > chip. This needs to be done in this order since
> > > the unsupported QCA988x AR1A chips fall off the
> > > bus when resetted. Otherwise the next MMIO Op
> > > after the reset causes a BUS ERROR and panic.
> > > 
> > > Cc: stable@vger.kernel.org # 4.19
> > > Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
> > > Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> > 
> > Queued up for all branches, thanks!
> 
> This broke the 4.4 build :(

And it broke the 4.9 build :(
