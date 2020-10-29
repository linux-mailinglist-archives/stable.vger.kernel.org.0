Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B2729F4C8
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 20:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgJ2TSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 15:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgJ2TRB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 15:17:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C4092076D;
        Thu, 29 Oct 2020 19:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603999021;
        bh=Z7HglUzBMygilCAvzwCh2Drqd4bWtlEBiAHCSSTrsNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vBEOejOIJMKSGck1+EjPBZonVZX/K20gvYCRzxcgUFC285EbzLG+PwhOeQSsDP1Nv
         EvPMEJz6hYP9G2Af7nuVq45e5bjBE7b5Chn7VMm5rSsFPFDgHcbjakC46wWp4ezbqa
         vNphP34YRzHenmpt1SrBt9Gcn5U5e3vH1WGDCK3c=
Date:   Thu, 29 Oct 2020 20:17:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ronald Warsow <rwarsow@gmx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/757] 5.9.2-rc1 review
Message-ID: <20201029191750.GA988039@kroah.com>
References: <d8211fcd-ddb5-34e1-1f9e-aa5b94a03889@gmx.de>
 <20201029091412.GA3749125@kroah.com>
 <16326ab5-79f3-2e1b-511f-31f048608e6f@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16326ab5-79f3-2e1b-511f-31f048608e6f@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 03:42:09PM +0100, Ronald Warsow wrote:
> On 29.10.20 10:14, Greg KH wrote:
> > On Tue, Oct 27, 2020 at 07:09:52PM +0100, Ronald Warsow wrote:
> > > Hallo
> > > 
> > > this rc1 runs here (pure Intel-box) without errors.
> > > Thanks !
> > > 
> > > 
> > > An RPC (I'm thinking about since some month)
> > > ======
> > > 
> > > Wouldn't it be better (and not so much add. work) to sort the
> > > Pseudo-Shortlog towards subsystem/driver ?
> > > 
> > > something like this:
> > > 
> > > ...
> > > usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.
> > > usb: cdns3: gadget: free interrupt after gadget has deleted
> > > 
> > >     Lorenzo Colitti <lorenzo@google.com>
> > >     Peter Chen <peter.chen@nxp.com>
> > > ...
> > > 
> > > 
> > > Think of searching a bugfix in the shortlog.
> > > 
> > > With the current layout I need to read/"visual grep" the whole log.
> > > 
> > > With the new layout I'm able to jump to the "buggy" subsystem/driver and
> > > only need to read that part of the log to get the info if the bug is
> > > fixed or not yet
> > 
> > Do you have an example script that generates such a thing?  If so, I'll
> > be glad to look into it, but am not going to try to create it on my own,
> > sorry.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> first of all: in the above mail it should read "RFC"
> 
> 
> Surely, who get the most benefit of it (the layout) does the most work.
> Agreed, I will see what I can do -I'm unsure -
> 
> Currently, I'm thinking that the data for your shortlog are coming from
> a sort of an git query or so and it would just be an easy adjustment of
> the query parameter.
> 
> This seems not to be the case ?
> 
> To get an idea if my knowledge is sufficing (I'm no developer):
> 
> Where do you get the data from to generate your shortlog ?

A "simple" git command:
	git log --abbrev=12 --format="%aN <%aE>%n    %s%n" ${VERSION}..HEAD > ${TMP_LOG}

If you can come up with a command that replaces that, I'll be glad to
try it out.

thanks,

greg k-h
