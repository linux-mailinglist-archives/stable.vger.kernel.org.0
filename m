Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59591367E8
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 08:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgAJHHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 02:07:00 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:50595 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbgAJHG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 02:06:59 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 69FA76CA;
        Fri, 10 Jan 2020 02:06:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 10 Jan 2020 02:06:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=ZHqX7lzlBli89+7MvAWvvg5z3A3
        iTrN/CDhh1LYFvt0=; b=IzLaEMqfFjBmIlFiSioQBTMOmAp2FDkht9D6LzavGd5
        L6FIZm0oaQoMLBg0nRSk3jj77m3UJOAurtmC7x4nOiy67PNFvtpdRwEK3UVNvXmY
        SD45OKfZkAFBIJLZArmwOPl7ooafmhmiRlGv2d9T3qBsdTmKZzJu0k/wtB4x+oq+
        t5f9LkvXtJ53E+pgrft/2TTu1zkBbEExh5qNUQcVsmA9WJI60Ae5LGyOu+8k/7dJ
        2pAmewnydH3RoPA7xkDMwlqLTwtSUKP06QgCOEZoLyKzJC6GivboumLlGoUCBSNa
        vPWw77cwWLULyOGs6wimh5g4DwBEMDIsnY1LkaIl5+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZHqX7l
        zlBli89+7MvAWvvg5z3A3iTrN/CDhh1LYFvt0=; b=n2kArFzTIIlj9kfN8PH+yT
        CEqIP6HRwEzAlU/eKNuJuC3tZrsf8GzSeaTPQMZO6Lbo+XxsvsGALqSqMGyNPeza
        rdjNqHZ1Ae7SqNjIDi71UFDwCsODoQYumwi2fed0cD2205pM5p23VUw46ruKEZMx
        m2Uoz0Qo5UBpOY7YPaUzASqNMrbsIjD8dmTyrqw2uPsGa2lhRyi6hzHiP45oGzHa
        cbN4DezNb6gH88KUEFzY1yMSkpyTqZF+JQfXzQ+bdJg27Bj5JdPiCKUoNptRsFEr
        aOgoay7ev27+w4ESwQ9LXuZ2f2IKtAPLKf0MDiQNeO5XUOp5DsWBPvJ5bKIQw/lw
        ==
X-ME-Sender: <xms:kSIYXp86bXtKTDaUmegjCuQBZ9b6_uvhJmp5B9MDeRQ1xhfYLse61w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeivddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:kSIYXraILBhDOXvI7i1kOi559YUdxuT1I7Eq7VC_CHFdDQT9L8AHkw>
    <xmx:kSIYXhdQ7enfBKQB6MLS--x9faW66XCHal72t0NkwSkhIHdO1Kno1Q>
    <xmx:kSIYXlrl_aBBIi2hzpEsxGzo8SWJXjtHi4tTuChtM_Gq5tdbDFiTpA>
    <xmx:kiIYXtdcnyYxQMstIuHLhuBn_cxyov22o6cBAOPXHPax4KOvzQuBMw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5434980059;
        Fri, 10 Jan 2020 02:06:57 -0500 (EST)
Date:   Fri, 10 Jan 2020 08:06:54 +0100
From:   Greg KH <greg@kroah.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: Patch "ARM: shmobile: defconfig: Restore debugfs support" has
 been added to the 5.4-stable tree
Message-ID: <20200110070654.GA90626@kroah.com>
References: <20200109203851.7078B2072E@mail.kernel.org>
 <CAMuHMdUBMoNRK++Uadq2CYdK_Dv5W1vrBu+6VaOc=Tn-CUPVdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUBMoNRK++Uadq2CYdK_Dv5W1vrBu+6VaOc=Tn-CUPVdA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 09, 2020 at 11:09:18PM +0100, Geert Uytterhoeven wrote:
> Hi Sasha,
> 
> On Thu, Jan 9, 2020 at 9:38 PM Sasha Levin <sashal@kernel.org> wrote:
> > This is a note to let you know that I've just added the patch titled
> >
> >     ARM: shmobile: defconfig: Restore debugfs support
> >
> > to the 5.4-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      arm-shmobile-defconfig-restore-debugfs-support.patch
> > and it can be found in the queue-5.4 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> >
> >
> >
> > commit b56e3b1467eba2ba55bca05e3c8697b23304f12b
> > Author: Geert Uytterhoeven <geert+renesas@glider.be>
> > Date:   Mon Dec 9 11:13:27 2019 +0100
> >
> >     ARM: shmobile: defconfig: Restore debugfs support
> >
> >     [ Upstream commit fa2cdb1762d15f701b83efa60b04f0d04e71bf89 ]
> >
> >     Since commit 0e4a459f56c32d3e ("tracing: Remove unnecessary DEBUG_FS
> >     dependency"), CONFIG_DEBUG_FS is no longer auto-enabled.  This breaks
> 
> AFAIK, that commit is not present in v5.4, and hasn't been backported yet.
> So I don't think there is a need to backport this and all other fixes restoring
> debugfs support in post-v5.4 kernels.
> 
> BTW, I noticed you plan to backport this "fix" not just to v5.4, but also
> to v4.19?

I've dropped this from both queues now, thanks.

greg k-h
