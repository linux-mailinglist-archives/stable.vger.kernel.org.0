Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DD8377E92
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhEJIu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhEJIu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 04:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED65E61352;
        Mon, 10 May 2021 08:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620636560;
        bh=eMD4GbtaIGcsx4BXW3r60ermPqVUcq+Cp4oJe/0ld20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QYXppFx96BDka+TkgLo1hedMhl2HzXtBvq88DaUfqForvQTQg+PtvsSMQAfmzbRiK
         HlIJBFduwUeQiPbs0N4QWPWRr3a1MClbMilDip7YUe2eaYQxnEVCJ9DdmACnKwFr8Z
         SgzUBd58RImWL6B5UNPtaFQxGBph28IZImy3A50c=
Date:   Mon, 10 May 2021 10:49:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chen Yu <yu.c.chen@intel.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Len Brown <len.brown@intel.com>
Subject: Re: Please apply commit 301b1d3a9104 ("tools/power/turbostat: Fix
 turbostat for AMD Zen CPUs") to v5.10.y and later
Message-ID: <YJjzjknxzP4IEuKR@kroah.com>
References: <YJaTXf1b9IPj/5If@eldamar.lan>
 <YJa4fUfMY9/suEkm@kroah.com>
 <20210508175852.GA197041@chenyu-desktop>
 <YJjliqXkAwR6A+b9@kroah.com>
 <20210510081143.GA228962@chenyu-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510081143.GA228962@chenyu-desktop>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 04:11:43PM +0800, Chen Yu wrote:
> On Mon, May 10, 2021 at 09:49:30AM +0200, Greg Kroah-Hartman wrote:
> > On Sun, May 09, 2021 at 01:58:52AM +0800, Chen Yu wrote:
> > > On Sat, May 08, 2021 at 06:12:45PM +0200, Greg Kroah-Hartman wrote:
> > > > On Sat, May 08, 2021 at 03:34:21PM +0200, Salvatore Bonaccorso wrote:
> > > > > Hi
> > > > > 
> > > > > the following was commited in Linus tree a couple of days ago, but so
> > > > > is not yet in a tagged version. 
> > > > > 
> > > > > But still please consider to queue up 301b1d3a9104
> > > > > ("tools/power/turbostat: Fix turbostat for AMD Zen CPUs") to v5.10.y
> > > > > and later for the next round of updates, as it turbostat no lonwer
> > > > > worked on those Zen based systems since 5.10.
> > > > > 
> > > > > Thank you for considering, I can otherwise reping once 5.13-rc1 is
> > > > > tagged and released.
> > > > 
> > > > Now queued up, thanks.
> > > >
> > > Thanks Greg. Besides this patch, could you please also queue
> > > commit 8167875a1d68 ("tools/power turbostat: Fix offset overflow issue in index converting")
> > > to 5.10+ stable which could work with 301b1d3a9104 to fix the regression on Zen.
> > 
> > There is no such git id in Linus's tree :(
> >
> Should be this one:
> commit 13a779de4175 ("tools/power turbostat: Fix offset overflow issue in index converting")

That's better, now queued up.

greg k-h
