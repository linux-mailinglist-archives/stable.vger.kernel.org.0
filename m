Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A1F37737B
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 19:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhEHRzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 13:55:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:25441 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhEHRzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 May 2021 13:55:17 -0400
IronPort-SDR: vceHAjegRx8Z/8Qr4dCcsDmqKJ3XgdzoucAlMqOcVRfG/ZS3elVKnusGipvFjeSrw2FXvugqbC
 oISJKvj1yNaQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9978"; a="198987669"
X-IronPort-AV: E=Sophos;i="5.82,283,1613462400"; 
   d="scan'208";a="198987669"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2021 10:54:15 -0700
IronPort-SDR: cjLSXhPwc3j+6OzP2Z0aZ9is3TCIfmlHY9QkOZUOS2WSc+MOhrMXXTYtB7bmJV0j3/3IqH7Ruz
 1rNgrqU2Eu2w==
X-IronPort-AV: E=Sophos;i="5.82,283,1613462400"; 
   d="scan'208";a="435440942"
Received: from chenyu-desktop.sh.intel.com (HELO chenyu-desktop) ([10.239.158.173])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2021 10:54:13 -0700
Date:   Sun, 9 May 2021 01:58:52 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Len Brown <len.brown@intel.com>
Subject: Re: Please apply commit 301b1d3a9104 ("tools/power/turbostat: Fix
 turbostat for AMD Zen CPUs") to v5.10.y and later
Message-ID: <20210508175852.GA197041@chenyu-desktop>
References: <YJaTXf1b9IPj/5If@eldamar.lan>
 <YJa4fUfMY9/suEkm@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJa4fUfMY9/suEkm@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 08, 2021 at 06:12:45PM +0200, Greg Kroah-Hartman wrote:
> On Sat, May 08, 2021 at 03:34:21PM +0200, Salvatore Bonaccorso wrote:
> > Hi
> > 
> > the following was commited in Linus tree a couple of days ago, but so
> > is not yet in a tagged version. 
> > 
> > But still please consider to queue up 301b1d3a9104
> > ("tools/power/turbostat: Fix turbostat for AMD Zen CPUs") to v5.10.y
> > and later for the next round of updates, as it turbostat no lonwer
> > worked on those Zen based systems since 5.10.
> > 
> > Thank you for considering, I can otherwise reping once 5.13-rc1 is
> > tagged and released.
> 
> Now queued up, thanks.
>
Thanks Greg. Besides this patch, could you please also queue
commit 8167875a1d68 ("tools/power turbostat: Fix offset overflow issue in index converting")
to 5.10+ stable which could work with 301b1d3a9104 to fix the regression on Zen.


thanks,
Chenyu
> greg k-h
