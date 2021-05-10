Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134B2377DAE
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhEJIIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:08:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:47948 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhEJIIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 04:08:14 -0400
IronPort-SDR: +5uTZj8hoTOOxT1n2ozebl0+m0+0yZFoOUE08RDC3YtxXQOfUHnB0aVfy03DWaq7mlcyUgNWMM
 AMYw0/NwmEHQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="198815321"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="198815321"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:07:09 -0700
IronPort-SDR: vwQrUF55x6Ko/lUxR8jfkH4CEuRMGZHpIRMM10j5435z3rKnoAE82svwvtpzNobMIiuPLoYwb8
 tFregOlTDJeQ==
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="536295792"
Received: from chenyu-desktop.sh.intel.com (HELO chenyu-desktop) ([10.239.158.173])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:07:08 -0700
Date:   Mon, 10 May 2021 16:11:43 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Len Brown <len.brown@intel.com>
Subject: Re: Please apply commit 301b1d3a9104 ("tools/power/turbostat: Fix
 turbostat for AMD Zen CPUs") to v5.10.y and later
Message-ID: <20210510081143.GA228962@chenyu-desktop>
References: <YJaTXf1b9IPj/5If@eldamar.lan>
 <YJa4fUfMY9/suEkm@kroah.com>
 <20210508175852.GA197041@chenyu-desktop>
 <YJjliqXkAwR6A+b9@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJjliqXkAwR6A+b9@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 09:49:30AM +0200, Greg Kroah-Hartman wrote:
> On Sun, May 09, 2021 at 01:58:52AM +0800, Chen Yu wrote:
> > On Sat, May 08, 2021 at 06:12:45PM +0200, Greg Kroah-Hartman wrote:
> > > On Sat, May 08, 2021 at 03:34:21PM +0200, Salvatore Bonaccorso wrote:
> > > > Hi
> > > > 
> > > > the following was commited in Linus tree a couple of days ago, but so
> > > > is not yet in a tagged version. 
> > > > 
> > > > But still please consider to queue up 301b1d3a9104
> > > > ("tools/power/turbostat: Fix turbostat for AMD Zen CPUs") to v5.10.y
> > > > and later for the next round of updates, as it turbostat no lonwer
> > > > worked on those Zen based systems since 5.10.
> > > > 
> > > > Thank you for considering, I can otherwise reping once 5.13-rc1 is
> > > > tagged and released.
> > > 
> > > Now queued up, thanks.
> > >
> > Thanks Greg. Besides this patch, could you please also queue
> > commit 8167875a1d68 ("tools/power turbostat: Fix offset overflow issue in index converting")
> > to 5.10+ stable which could work with 301b1d3a9104 to fix the regression on Zen.
> 
> There is no such git id in Linus's tree :(
>
Should be this one:
commit 13a779de4175 ("tools/power turbostat: Fix offset overflow issue in index converting")

Thanks,
Chenyu
