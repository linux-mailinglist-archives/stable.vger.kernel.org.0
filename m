Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A49D10E78C
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLBJTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:19:04 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:60109 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726350AbfLBJTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:19:04 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2EEFA9B5;
        Mon,  2 Dec 2019 04:19:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 02 Dec 2019 04:19:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=RYdMASyGG0xpg3ujwEtFJ3EWhXB
        JbplLWbwMxsnoW7Q=; b=nAaWVTnILSRPaBgaPqKaznO7HapRI40DD+6XxwLQsVW
        FrIXoWbqwbeH1GblruQnP6DMYF8zTksSJkl5qWMjSKYlOXDtnWp+TV0knSHJGCKM
        S+4sRpZNBzNHcw/jhpVPG9SCF3T8t+Jvs8WmR3oFKKri9SWFZC/qUyEIc3mhrp7H
        hZzJeUeY4oCpf702j2VwOnvfACZiRxqLLm3piURqYuwZuD5lwgDAEpdsjj4scmmO
        ij/pVXXlOdi2Ac9AVWdDlYH+PAlz+O66p8ZoDLHO2/YuZ2Qnar0y7GTomw6YAFHz
        F2riGPOCXkXaacKnVSWMuLcpHIuhAzSX1imof8KuSuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RYdMAS
        yGG0xpg3ujwEtFJ3EWhXBJbplLWbwMxsnoW7Q=; b=NMhwYLS7jMQcvrGV45OMRM
        Wfgsq+9n7WWTHvu7jmvM+2G+B6lK6r1wjSoizJ8pJF74mWqCQNYWHeo19Pr7BkGe
        CZ48K1U/8okyBNMPnCjxB7bR+VRjtV+5hvulAVgzITYvxxXZqwfVkwwqacJ30I8t
        t8RBw1cXZZwtvJuZUhIVRdSEE4EGszqRqSSv9L0ybcY3/2Ljufxd5Vo211ppjlRs
        cBokH96b/Ce7NxUyA74OInh+U2n3TVK22RkbzpRPpesu2p8kXplOJBuf/Tes7NkW
        /cnh177nulSz225IMvFW9TvqhV9+5WvK0SovfvaZ8rRVTgDSrElG1bh7L4q6BeYQ
        ==
X-ME-Sender: <xms:BtfkXft_85JDFPjW5ms_htWk4cHr0YsenH1Rph7o2dpQuvVo4njm4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudejhedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:BtfkXX5N4zjp7MOr7TxL4B6az40A7T86un5iaPD8ExWvHr9fvjebrg>
    <xmx:BtfkXQSHkrEEc79i2803SKqsWQ1uVyqP1hwbrMfoniOabRhYbR1q-g>
    <xmx:BtfkXZsnaGH5AJfcGOs7DdVPJ1FLglYVZAqONCjAT7ae4GZ1lFyeTQ>
    <xmx:BtfkXQHUaMMHKY8X2rbVJpMKZYlNemKXa_aop5_3-rn-vvXNGdPC5Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4B0D68005C;
        Mon,  2 Dec 2019 04:19:02 -0500 (EST)
Date:   Mon, 2 Dec 2019 10:18:57 +0100
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Christian Lamparter <chunkeey@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1)
 detection
Message-ID: <20191202091857.GA3964750@kroah.com>
References: <5688116.JcRxOpqE2I@debian64>
 <20191201170245.GU5861@sasha-vm>
 <20191202091431.GA3945609@kroah.com>
 <20191202091529.GB3945609@kroah.com>
 <20191202091700.GC3945609@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202091700.GC3945609@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 10:17:00AM +0100, Greg KH wrote:
> On Mon, Dec 02, 2019 at 10:15:29AM +0100, Greg KH wrote:
> > On Mon, Dec 02, 2019 at 10:14:31AM +0100, Greg KH wrote:
> > > On Sun, Dec 01, 2019 at 12:02:45PM -0500, Sasha Levin wrote:
> > > > On Fri, Nov 29, 2019 at 09:52:14PM +0100, Christian Lamparter wrote:
> > > > > commit f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 upstream
> > > > > ---
> > > > > > From f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 Mon Sep 17 00:00:00 2001
> > > > > From: Christian Lamparter <chunkeey@gmail.com>
> > > > > Date: Mon, 25 Mar 2019 13:50:19 +0100
> > > > > Subject: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1) detection
> > > > > To: linux-wireless@vger.kernel.org,
> > > > >    ath10k@lists.infradead.org
> > > > > Cc: Kalle Valo <kvalo@codeaurora.org>
> > > > > 
> > > > > This patch restores the old behavior that read
> > > > > the chip_id on the QCA988x before resetting the
> > > > > chip. This needs to be done in this order since
> > > > > the unsupported QCA988x AR1A chips fall off the
> > > > > bus when resetted. Otherwise the next MMIO Op
> > > > > after the reset causes a BUS ERROR and panic.
> > > > > 
> > > > > Cc: stable@vger.kernel.org # 4.19
> > > > > Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
> > > > > Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> > > > 
> > > > Queued up for all branches, thanks!
> > > 
> > > This broke the 4.4 build :(
> > 
> > And it broke the 4.9 build :(
> 
> And 4.14.y :(

And it broke the 4.19.y build!  Ugh, Christian, did you test build this?

confused,

greg k-h
