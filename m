Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C8E399D94
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 11:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhFCJVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 05:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhFCJVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 05:21:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AD27613B1;
        Thu,  3 Jun 2021 09:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622711961;
        bh=hNMchlf9O444bO7mxFnY6LjWcVswdmGJYNW5Cvcqp6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KBZnItNEhuIP6RjnuWWg2l7dErC4umNFQ3a0YEvAwBsL2QiCq2bLF7NDoxt4SGsCH
         nCWwzbOc4ProgyI+4Aqw6rpwMykrjVR8BeEpjnEvKONqr/r4AGn4snvzfW/K9kfgFD
         XMsfwSBKaJ0AB5VWCfLNwPzzAeNw1vLf2QQrzmv8=
Date:   Thu, 3 Jun 2021 11:19:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?Q?Lauren=C8=9Biu_P=C4=83ncescu?= <lpancescu@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Backporting fix for #199981 to 4.19.y?
Message-ID: <YLiel5ZEcq+mlshL@kroah.com>
References: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
 <YLiNrCFFGEmltssD@kroah.com>
 <5399984e-0860-170e-377e-1f4bf3ccb3a0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5399984e-0860-170e-377e-1f4bf3ccb3a0@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 10:24:04AM +0200, Laurențiu Păncescu wrote:
> On 6/3/21 10:07 AM, Greg KH wrote:
> > On Thu, Jun 03, 2021 at 09:53:46AM +0200, Laurențiu Păncescu wrote:
> > > Hi there,
> > > 
> > > I'm running Debian Buster on an old Asus EeePC and I see the battery always
> > > at 100% when unplugged, with an estimated battery life of 4200 hours, no
> > > matter how long I've been using it without AC power.
> > > 
> > > I suspect this might be bug #201351, marked as duplicate of #199981 and
> > > fixed in 5.0-rc1. Would you please consider backporting it to the 4.19 LTS
> > > kernel?
> > 
> > What specific commit in Linus's tree is this so we know what to
> > backport?
> 
> Hi Greg,
> 
> I think it's commit b1c0330823fe842dbb34641f1410f0afa51c29d3.
> 
> Many thanks,
> Laurențiu

That commit does not apply cleanly and I need a backported version.  Can
you do that and test it to verify it works and then send it to us to be
applied?

thanks,

greg k-h
