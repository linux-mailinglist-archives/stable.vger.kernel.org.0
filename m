Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888111BF0E6
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 09:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD3HLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 03:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726337AbgD3HLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 03:11:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B382082E;
        Thu, 30 Apr 2020 07:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588230699;
        bh=pNOXaPYGfwN5YuaFisXoPHWYOkR2bfP+m8TNT7K869U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P1/J+ume/5ZXMAGcDwEIy9ayllS5B9qL0YownC6vFIxEfPOVIMQVK+YPOxyPjTH4L
         d0uVBHsa/3iVVcezj8FlasHzXZT82zghDjTO+//lXi61Wz3fjEOQmo8mtaigK4cSG1
         17E0XQLBL1P/POfn4Rd0g3La+Vwl/08rx1RQYWPI=
Date:   Thu, 30 Apr 2020 09:11:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Richard Weinberger <richard@nod.at>
Cc:     stable <stable@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: Please queue ubifs: Fix ubifs_tnc_lookup() usage in
 do_kill_orphans() for stable (was: Re: [PATCH] ubifs: Fix ubifs_tnc_lookup()
 usage in do_kill_orphans())
Message-ID: <20200430071137.GA2382543@kroah.com>
References: <20200119215233.7292-1-richard@nod.at>
 <875zdibasg.fsf@vostro.fn.ogness.net>
 <1537701093.171645.1588186266734.JavaMail.zimbra@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1537701093.171645.1588186266734.JavaMail.zimbra@nod.at>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 29, 2020 at 08:51:06PM +0200, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
> > Von: "John Ogness" <john.ogness@linutronix.de>
> > An: "richard" <richard@nod.at>
> > CC: "linux-mtd" <linux-mtd@lists.infradead.org>, "linux-kernel" <linux-kernel@vger.kernel.org>
> > Gesendet: Mittwoch, 29. April 2020 16:56:31
> > Betreff: Re: [PATCH] ubifs: Fix ubifs_tnc_lookup() usage in do_kill_orphans()
> 
> > Hi Richard,
> > 
> > Could you CC this patch to stable? It fixes a serious problem that I am
> > seeing on real devices (i.e. Linux not being able to mount its root
> > filesystem after a power cut). Thanks.
> 
> Just checked again, better ask stable maintainers. :-)
> 
> Stable maintainers, can you please make sure this patch will make it
> into stable?
> The upstream commit is:
> 4ab25ac8b2b5 ("ubifs: Fix ubifs_tnc_lookup() usage in do_kill_orphans()")
> 
> I always thought havings a Fixes-Tag is enough to make sure it will
> get picked up. Isn't this the case?

No it is not, please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

Our scripts are doing better to dig out stuff where maintainers mess up
and forget to put the cc: stable tag, but you can never rely on it.
Please stick with the above rules that have been there for 15+ years :)

thanks,

greg k-h
