Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858582136CB
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 10:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgGCI6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 04:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbgGCI6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jul 2020 04:58:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3F0320826;
        Fri,  3 Jul 2020 08:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593766682;
        bh=2K/z0KFxB9PhPJ019QiL9WvVF0HXAZ9h8wUwORV5UQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ubVqsJWHtd16pd2BNFY9VJmIwZ1Dtt/ehHgecVQ6xmX/Hn4cIF0em81pvI/nb6yLM
         f/3SYN87MoUHmigDAX+bIl9ATeltht3fgmBhZRf9FzYKgCKkkhl4JS6rJ9yd3Nwlmt
         1cjsKxyuYk2W+yYXL0zveEpKBd3Ob2fmVxsLuG5s=
Date:   Fri, 3 Jul 2020 10:58:06 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: patch "serial: sh-sci: Initialize spinlock for uart console"
 added to tty-linus
Message-ID: <20200703085806.GB2514858@kroah.com>
References: <1593765640253201@kroah.com>
 <OSAPR01MB2915705C9D066B832772457FAA6A0@OSAPR01MB2915.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB2915705C9D066B832772457FAA6A0@OSAPR01MB2915.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 03, 2020 at 08:53:18AM +0000, Prabhakar Mahadev Lad wrote:
> Hi Greg,
> 
> > -----Original Message-----
> > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > Sent: 03 July 2020 09:41
> > To: Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>; Biju Das <biju.das.jz@bp.renesas.com>;
> > gregkh@linuxfoundation.org; stable@vger.kernel.org
> > Subject: patch "serial: sh-sci: Initialize spinlock for uart console" added to tty-linus
> >
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     serial: sh-sci: Initialize spinlock for uart console
> >
> > to my tty git tree which can be found at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> > in the tty-linus branch.
> >
> > The patch will show up in the next release of the linux-next tree
> > (usually sometime within the next 24 hours during the week.)
> >
> > The patch will hopefully also be merged in Linus's tree for the
> > next -rc kernel release.
> >
> > If you have any questions about this process, please let me know.
> >
> It looks like it's a regression in serial_core.c [1] as Geert pointed out [2]. Please drop this patch until we come to a conclusion.
> 
> [1] https://www.spinics.net/lists/linux-serial/msg37119.html
> [2] https://patchwork.kernel.org/patch/11636731/

We have had MANY patches for individual drivers to fix up the issue with
that serial_core patch.  I think, and hope, they are all now caught.  If
not, please let us know, but for now, this patch is needed, so I'll keep
it.

thanks,

greg k-h
