Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21208377D6D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhEJHuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhEJHuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 03:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AD2961430;
        Mon, 10 May 2021 07:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620632972;
        bh=v2pFOrObGWpJagryCy2PNS3mUwhJKPFzoYtgEGR/9Tw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L5bKn9MmrS2mfc00CCOJ5TpvwPbSG8QyvtQvvSNPwUGioLfUZQERX5eRQFqAnOStb
         4zdAzBOYFKkc4kUlbDs6mh6HxJV7qXE63Aw8DBqDFxxejUJl23VNjzhHc9tOr22er3
         3hx8d8eKlJw1by6oNagihGcn+rj6nk7Z9boPbcH0=
Date:   Mon, 10 May 2021 09:49:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chen Yu <yu.c.chen@intel.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Len Brown <len.brown@intel.com>
Subject: Re: Please apply commit 301b1d3a9104 ("tools/power/turbostat: Fix
 turbostat for AMD Zen CPUs") to v5.10.y and later
Message-ID: <YJjliqXkAwR6A+b9@kroah.com>
References: <YJaTXf1b9IPj/5If@eldamar.lan>
 <YJa4fUfMY9/suEkm@kroah.com>
 <20210508175852.GA197041@chenyu-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508175852.GA197041@chenyu-desktop>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 09, 2021 at 01:58:52AM +0800, Chen Yu wrote:
> On Sat, May 08, 2021 at 06:12:45PM +0200, Greg Kroah-Hartman wrote:
> > On Sat, May 08, 2021 at 03:34:21PM +0200, Salvatore Bonaccorso wrote:
> > > Hi
> > > 
> > > the following was commited in Linus tree a couple of days ago, but so
> > > is not yet in a tagged version. 
> > > 
> > > But still please consider to queue up 301b1d3a9104
> > > ("tools/power/turbostat: Fix turbostat for AMD Zen CPUs") to v5.10.y
> > > and later for the next round of updates, as it turbostat no lonwer
> > > worked on those Zen based systems since 5.10.
> > > 
> > > Thank you for considering, I can otherwise reping once 5.13-rc1 is
> > > tagged and released.
> > 
> > Now queued up, thanks.
> >
> Thanks Greg. Besides this patch, could you please also queue
> commit 8167875a1d68 ("tools/power turbostat: Fix offset overflow issue in index converting")
> to 5.10+ stable which could work with 301b1d3a9104 to fix the regression on Zen.

There is no such git id in Linus's tree :(

