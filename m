Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203B23C9E98
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237075AbhGOMax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:30:53 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:38570 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhGOMax (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 08:30:53 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 009C022A40;
        Thu, 15 Jul 2021 12:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1626352079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CJEWq8qiVgvEoVbn4aLIKGb5fN74YYFkq1XScfceEpA=;
        b=UzW72TZ1XOcaU2Yrkabqq0GrXcQuW3FxMgmoOpGJl8KNPeqskrMjR+Ty0kWneMszvM6m2r
        /pSVXUBknVyeVnBBczRGUD6ZOG7PkfOMyJ5EEXxciemhIUgEaJ/+4pyURWeer8M73E1ETH
        mYf7/jYSqQEfRJS4ngdJnNXpdF1+hsU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1626352079;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CJEWq8qiVgvEoVbn4aLIKGb5fN74YYFkq1XScfceEpA=;
        b=rj2SYw+nY2a8p3YpBCTL+WirfJhVCko8/VO3xIclrvXosgaTLyoqdB0vgHgchJPJs+iwMT
        20Earc0sUckerDAg==
Received: from quack2.suse.cz (unknown [10.100.200.198])
        by relay2.suse.de (Postfix) with ESMTP id ACA50A3B8D;
        Thu, 15 Jul 2021 12:27:58 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 86F2F1E0BF2; Thu, 15 Jul 2021 14:27:58 +0200 (CEST)
Date:   Thu, 15 Jul 2021 14:27:58 +0200
From:   Jan Kara <jack@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Holger Kiehl <Holger.Kiehl@dwd.de>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
Message-ID: <20210715122758.GB31920@quack2.suse.cz>
References: <20210712060912.995381202@linuxfoundation.org>
 <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
 <YO56HTE3k95JLeje@kroah.com>
 <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de>
 <df63b875-f140-606a-862a-73b102345cd@praktifix.dwd.de>
 <YO7nHhW2t4wEiI9G@kroah.com>
 <CA+G9fYuhbE6sY3ykoiyqZqYSG=+V0r3z0TiaVL8LptbXWw=duQ@mail.gmail.com>
 <CA+G9fYtWkOLVVKB0xYfAXWS57G1C2xV-Zbtp5i4dAJDJqwLQhg@mail.gmail.com>
 <YO70LLnTE6LxcBnt@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO70LLnTE6LxcBnt@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 14-07-21 16:26:52, Greg Kroah-Hartman wrote:
> On Wed, Jul 14, 2021 at 07:29:26PM +0530, Naresh Kamboju wrote:
> > On Wed, 14 Jul 2021 at 19:22, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Wed, 14 Jul 2021 at 19:01, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > 
> > <trim>
> > 
> > > My two cents,
> > > While running ssuite long running stress testing we have noticed deadlock.
> > >
> > > > So if you drop that, all works well?  I'll go drop that from the queues
> > > > now.
> > >
> > > Let me drop that patch and test it again.
> > >
> > > Crash log,
> > >
> > > [ 1957.278399] ============================================
> > > [ 1957.283717] WARNING: possible recursive locking detected
> > > [ 1957.289031] 5.13.2-rc1 #1 Not tainted
> > > [ 1957.292703] --------------------------------------------
> > > [ 1957.298016] kworker/u8:7/236 is trying to acquire lock:
> > > [ 1957.303241] ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
> > > bfq_finish_requeue_request+0x55/0x500 [bfq]
> > > [ 1957.312643]
> > > [ 1957.312643] but task is already holding lock:
> > > [ 1957.318467] ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
> > > bfq_insert_requests+0x81/0x1750 [bfq]
> > > [ 1957.327334]
> > > [ 1957.327334] other info that might help us debug this:
> > > [ 1957.333852]  Possible unsafe locking scenario:
> > > [ 1957.333852]
> > > [ 1957.339762]        CPU0
> > > [ 1957.342206]        ----
> > > [ 1957.344651]   lock(&bfqd->lock);
> > > [ 1957.347873]   lock(&bfqd->lock);
> > > [ 1957.351097]
> > > [ 1957.351097]  *** DEADLOCK ***
> > > [ 1957.351097]
> > 
> > Also noticed on stable-rc 5.12.17-rc1.
> 
> I dropped the same patch from there as well already, thanks.

OK, when you dropped this patch, please also drop upstream commit
fd2ef39cc9a6b ("blk: Fix lock inversion between ioc lock and bfqd lock").
Because without BFQ patch this block layer patch could cause some
use-after-free issues. I'll have a look if I can understand why BFQ patch
causes problems in stable kernels...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
