Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E7C28A65D
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 10:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgJKIhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 04:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbgJKIhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Oct 2020 04:37:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FCE720575;
        Sun, 11 Oct 2020 08:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602405467;
        bh=Xc/WmREH0wqc7wpdtwNgT6qEgcCAwnlMtrdwCkXM1GE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GXms/FtzFZRXb/qPQ9dYzXR8cV9pf4gMm26UN0aSjp02SZBEYAMg/PuUTi4LtnpLI
         xWxZBJvOdptHcpufnQYgqcOLkJajm6WBuP8QCevSS0tlHRBktTekpd7QrmLo3KF3JK
         zsUnOOUHVzK3XRHBHOcJMlqq4qtIS3o9CPnGeFjg=
Date:   Sun, 11 Oct 2020 10:38:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     miquel.raynal@bootlin.com, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "mtd: rawnand: sunxi: Fix the probe error path" has been
 added to the 4.4-stable tree
Message-ID: <20201011083828.GA2055740@kroah.com>
References: <1602252149123251@kroah.com>
 <20201010232833.kiboif4q6gi7ynwg@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201010232833.kiboif4q6gi7ynwg@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 11, 2020 at 08:28:33AM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> On Fri, Oct 09, 2020 at 04:02:29PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     mtd: rawnand: sunxi: Fix the probe error path
> > 
> > to the 4.4-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      mtd-rawnand-sunxi-fix-the-probe-error-path.patch
> > and it can be found in the queue-4.4 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> 
> This patch content is not sufficient for 4.4.y.
> 4.4.y does not provide nand_cleanup(), which results in a build error.
> 
> Please drop this from 4.4.y queue.

Ah, good catch, sorry about that, now dropped.

greg k-h
