Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4945E373
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfGCMIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfGCMID (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 08:08:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84833218A0;
        Wed,  3 Jul 2019 12:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562155683;
        bh=rh/E6Ph/YsPuATiqv6cOREYhAyMygzjvuRX8z0OrqAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ouP7I3FT3CA1OlIRcefiZq7gaUNdk53n2T6W+NjmVFZU4CFrj4IpFqbBEaDedBtYJ
         1bkX5BZKY8iMHzHkpc3Rh/MZKh4Z1MZSnDxVF07epUvSYqTHaDbwH4IvoCgeaX/96y
         g5BRKY09eyCZrXh66QWSMObbgO/6z10R8dcZ54rY=
Date:   Wed, 3 Jul 2019 14:07:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.1
Message-ID: <20190703120759.GA7784@kroah.com>
References: <cki.3BCD9A354F.JWPY9HGRUT@redhat.com>
 <20190703112520.GA20712@kroah.com>
 <1989107726.28546762.1562155276612.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1989107726.28546762.1562155276612.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 08:01:16AM -0400, Veronika Kabatova wrote:
> 
> 
> ----- Original Message -----
> > From: "Greg KH" <gregkh@linuxfoundation.org>
> > To: "CKI Project" <cki-project@redhat.com>
> > Cc: "Linux Stable maillist" <stable@vger.kernel.org>
> > Sent: Wednesday, July 3, 2019 1:25:20 PM
> > Subject: Re: ❌ FAIL: Stable queue: queue-5.1
> > 
> > On Wed, Jul 03, 2019 at 07:16:58AM -0400, CKI Project wrote:
> > > Hello,
> > > 
> > > We ran automated tests on a patchset that was proposed for merging into
> > > this
> > > kernel tree. The patches were applied to:
> > > 
> > >        Kernel repo:
> > >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> > >             Commit: 8584aaf1c326 - Linux 5.1.16
> > > 
> > > The results of these automated tests are provided below.
> > > 
> > >     Overall result: FAILED (see details below)
> > >              Merge: FAILED
> > 
> > Guys, this is getting annoying, this is your test systems, the queue is
> > empty :)
> > 
> 
> Hi,
> 
> this is not an empty queue problem (that should be fixed now). We triggered
> the testing right after the 5.1.16 was released to test the present queue
> with it. We have added the commit hash of the queue to the merge details in
> the report to verify this is indeed the case.
> 
> The base commit for the stable kernel is 8584aaf1c326
> The commit of the stable queue is d0f506ba82
> 
> This queue was removed a minute later (obviously with the release) after the
> baseline change was pushed but we caught this combo as we try to trigger
> testing after every change to any of those repos. So the patches from the
> queue really didn't apply.
> 
> 
> I currently see two ways (or their combination) around this:
> 1) The queue changes need to be pushed first

Given that you are working behind a mirror of the "real" git trees, they
can, and probably will, get out of order, so there's no guarantee of
"first" here.

And I am doing this in a scripted way, so they should be pushed within 1
minute of each other at this point in time.

> 2) We detect how long ago the baseline was pushed and if it's less than
>    let's say 5mins we abort the pipeline to give you enough time to do the
>    changes to the repo

I say this is the best thing to do to help with the mirroring issues
involved.

thanks,

greg k-h
