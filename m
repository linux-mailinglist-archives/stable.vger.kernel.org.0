Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14F11A782D
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 12:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438186AbgDNKMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 06:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438130AbgDNKL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 06:11:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C772072D;
        Tue, 14 Apr 2020 10:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586859116;
        bh=hrv4v7Jt4rjXY8XDpLLFYQdJXTw1qD7wkIQHdPDy4gY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nx3ijwYi5SAGPPVbjzMSFoOLVqnQVr+6YoSec7RfUeDZNaJ+iiJY/BFThII6KAACp
         v/xSjaOu7CSOFEzh7dwMsax5a5zlaT4/axwC6MoC6JHzcji7S1Jc3BUlas9joWgkin
         e7KXdsE2Agxe2amSaOjZifJbSr0YBTGEliumwtDE=
Date:   Tue, 14 Apr 2020 12:11:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Patchset for CVE-2020-1749 Kernel 4.19
Message-ID: <20200414101153.GA37302@kroah.com>
References: <1586262823357.14177@mentor.com>
 <20200411114450.GE2606747@kroah.com>
 <baec5c33121948aca8660b5bdaf9643c@SVR-IES-MBX-03.mgc.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <baec5c33121948aca8660b5bdaf9643c@SVR-IES-MBX-03.mgc.mentorg.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 10:05:09AM +0000, Schmid, Carsten wrote:
> > > Applies to stable linux-v4.19.y (with y=114).
> >
> > Have you been able to test these patches so that you know they work?
> >
> I did apply and compile on x86 in both 4.14 and 4.19 (making sure to have all CONFIG_s set
> to compile the changed code).
> I then ran 4.14 (project kernel) on our target; however i can't build an
> encrypted IPv6 tunnel to verify if the patchset helps.
> (From the patch descriptions, it really looks like they fix this)
> 
> IPv6 tunnel testing will be done by other folks in the project, i can't tell when due to
> the CoVid situation as this requires special equipment that i can't access at all.

Please wait to submit these until you can actually test that they solve
the issue involved.

> > And can you please send them as a patch series, not as attachments, and
> >  cc: all the original authors so that everyone can know what is going on
> > and weigh in if they see any issues?
> Of course. Sorry that i didn't do this yet.
> 
> >
> > And finally, do not change the changelog text from the original commits,
> > that's not ok.
> Except for the "upstream commit id", right?

Correct.

> > If you need to put any notes in there as to what you
> > did, follow the format we have been using for years, and put it in the
> > s-o-b: area in a small [ box ]
> >
> > Same for the 4.14 patches.
> >
> > thanks,
> >
> > greg k-h
> 
> Of course i will do so, if it makes sense due to little testing effort possible.
> Please give a short notice if you think i should resend the patch series.
> 
> One question:
> Our IT department adds a signature since a few days, after a line with "----".
> Is this a problem? I can't turn that off, unfortunately.
> (At least they keep the "text only" and don't switch to HTML)

Is it a problem for what, patches?  It shouldn't be.

thanks,

greg k-h
