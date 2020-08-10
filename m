Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAB924074E
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgHJOPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgHJOPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 10:15:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BF4B20748;
        Mon, 10 Aug 2020 14:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597068906;
        bh=q4THmdDeArkPVIhpOEo1zicWwSuUaeOk4h+g5z4Wruw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fELN5Esw/bhrzfSj5Lo7M2ulfhizDnzn0KYpV/ANjdeW4oTO1edTmm4PUC8m+mr+6
         lbgHeW7kgEurs+HuORsjBBi1UHtYJSfGeDp/h1K7qnlnGS64bHcdr624acLO6YMx0O
         5ZeMapZSU2M5i/UCB5foC6gorXHRJvMMs2qtNcek=
Date:   Mon, 10 Aug 2020 16:15:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     Timo Rothenpieler <timo@rothenpieler.org>, stable@vger.kernel.org
Subject: Re: Backport request: nfsd: Fix NFSv4 READ on RDMA when using readv
Message-ID: <20200810141518.GA3758520@kroah.com>
References: <9cc28958-b715-5e51-e0c8-6f1821d2bfe0@rothenpieler.org>
 <20200810135218.GC3491228@kroah.com>
 <22C4A9C2-5986-447C-B91E-DC2F9653A7E9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22C4A9C2-5986-447C-B91E-DC2F9653A7E9@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 09:57:56AM -0400, Chuck Lever wrote:
> Hi Greg-
> 
> > On Aug 10, 2020, at 9:52 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > On Tue, Aug 04, 2020 at 10:47:26PM +0200, Timo Rothenpieler wrote:
> >> Sorry if this is not the right approach to this, but I'd like to request a
> >> backport of 412055398b9e67e07347a936fc4a6adddabe9cf4, "nfsd: Fix NFSv4 READ
> >> on RDMA when using readv" to Linux 5.4.
> >> 
> >> The patch applies cleanly and fixes a rare but severe issue with NFS over
> >> RDMA, which I just spent several days tracking down to that patch, with
> >> major help from linux-nfs/rdma.
> >> 
> >> I have right now manually applied it to my 5.4 Kernel and can confirm it
> >> fixes the issue.
> > 
> > It's good to cc: the developers/maintainers of the patch you are asking
> > about, to see if they object or not.
> > 
> > Chuck, any objection for the above patch being added to 5.4 and maybe
> > 4.19?
> 
> Since Timo applied it to 5.4 and tested it, I have no objection there.
> 
> v4.19 suffers from the same bug, but I don't have reports of anyone
> having tried 4120553 on that kernel. I would say wait on that one until
> someone can state that it works without regression.

Ok, sounds good, now queued up for 5.4.y, thanks!

greg k-h
