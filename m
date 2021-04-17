Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F88363081
	for <lists+stable@lfdr.de>; Sat, 17 Apr 2021 16:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbhDQOCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Apr 2021 10:02:04 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:39046 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhDQOCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Apr 2021 10:02:04 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 3C0EC92009C; Sat, 17 Apr 2021 16:01:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 2EBB492009B;
        Sat, 17 Apr 2021 16:01:36 +0200 (CEST)
Date:   Sat, 17 Apr 2021 16:01:36 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     Joe Perches <joe@perches.com>, Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/5] scsi: BusLogic: Fix missing `pr_cont' use
In-Reply-To: <6679310a77984cc0af9f48f5616b840c@AcuMS.aculab.com>
Message-ID: <alpine.DEB.2.21.2104171559260.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>  <alpine.DEB.2.21.2104141419040.44318@angie.orcam.me.uk> <787aae5540612555a8bf92de2083c8fa74e52ce9.camel@perches.com> <alpine.DEB.2.21.2104161224300.44318@angie.orcam.me.uk>
 <6679310a77984cc0af9f48f5616b840c@AcuMS.aculab.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 17 Apr 2021, David Laight wrote:

> > > In patch 2, vscnprintf should probably be used to make sure it's
> > > 0 terminated.
> > 
> >  Why?  C99 has this[1]:
> > 
> > "The vsnprintf function is equivalent to snprintf, with the variable
> > argument list replaced by arg, which shall have been initialized by the
> > va_start macro (and possibly subsequent va_arg calls)."
> 
> vscnprintf() is normally the function you want (not vsnprintf())
> because the return value is the number of characters actually
> put into the buffer, not the number that would have been written
> had the buffer been long enough.

 Good catch, thank you!  I'll respin the series then.  Thank you for the 
background story too!

  Maciej
