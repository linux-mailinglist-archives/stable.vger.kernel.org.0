Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254212AB493
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgKIKRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgKIKRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 05:17:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C27F20684;
        Mon,  9 Nov 2020 10:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604917025;
        bh=NE9xceccWDnkxcvfj4eEQMMS1AzJzrGvHi0EeZq+lzs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=11cXeGSi5xVbGrNoYsmFKsPLztHStrIwX/e6ajqqHcPJ+FgNZS1zXkcHBhN7FMdYX
         rEkql8sjzc8t3POqCHthZ119tdNvPLgGtZmCpsAUaYP1fNyCpyQ+qFIGSnixXF0f0D
         B/s8tSd2wQN9MeF+AfHtoLAxVDzQKIqB+r1pL9BU=
Date:   Mon, 9 Nov 2020 11:18:04 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tty: serial: fsl_lpuart: LS1021A has a
 FIFO size of 16 words," failed to apply to 5.4-stable tree
Message-ID: <20201109101804.GA1065310@kroah.com>
References: <160441340011200@kroah.com>
 <20201103224825.gxvly2qijdr2hmsk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103224825.gxvly2qijdr2hmsk@skbuf>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 10:48:26PM +0000, Vladimir Oltean wrote:
> On Tue, Nov 03, 2020 at 03:23:20PM +0100, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Greg,
> 
> For linux-5.4.y, could you please do the following so that I don't need
> to explicitly resend these to linux-stable?
> 
> # tty: serial: fsl_lpuart: add LS1028A support
> git cherry-pick -xs c2f448cff22a7ed09281f02bde084b0ce3bc61ed # this is dependency
> # tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words, like LS1028A
> git cherry-pick -xs c97f2a6fb3dfbfbbc88edc8ea62ef2b944e18849 # this is the one that failed
> 
> Both sha1sums can be found in Linus' tree.
> 
> I have tested these 2 cherry-picks on top of linux-5.4.y on my board,
> and it works just fine.
> 
> I was a bit concerned about backporting the LS1028A patch as a
> dependency for my fix, but I have consulted
> Documentation/process/stable-kernel-rules.rst and it says:
> 
>  - New device IDs and quirks are also accepted.
> 
> That patch also satisfies the following:
> 
>  - It must be obviously correct and tested. <- check
>  - It cannot be bigger than 100 lines, with context. <- check
> 
> The patch does not apply because the fixes were discovered backwards.
> LS1021A and LS1028A should be compatible with one another. However
> when bringing up the LS1028A, Michael found the LPUART to be broken,
> thought the LS1021A was working, and added the FIFO size quirk as a
> LS1028A 'feature'.

That worked, now done, thanks.

greg k-h
