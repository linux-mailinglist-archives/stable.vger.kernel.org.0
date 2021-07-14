Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300D53C8739
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 17:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbhGNPVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 11:21:30 -0400
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:41021 "EHLO ofcsgdbm.dwd.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232308AbhGNPVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 11:21:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by ofcsg2dn1.dwd.de (Postfix) with ESMTP id 4GQ1Ns5797z1xPB
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 15:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dwd.de; h=
        content-type:content-type:mime-version:references:message-id
        :in-reply-to:subject:subject:from:from:date:date:received
        :received:received:received:received:received:received:received;
         s=dwd-csg20210107; t=1626275917; x=1627485518; bh=gk6Zd1VQ4AHyT
        Uvq/4ZIJE45JUEru4L0zwq/otC8nKM=; b=3V41kaj4RDIe8TU3XtSOQNtTdHGs/
        V8VIc3JQe1HDtm+ekwQ6BkaOtl8GXoZsiZdVpbeqrMBhvLfpqzzEpQ6kjIi6nBB1
        b+nUpdV3WnFMJBG2G8kg3ZfOdVFmxScvPSC6aEfhmc3x2EIDZ/IM+Y6sfkTZ5HZx
        p8k5klVn7cy7nr36zvy4Ta/gLHzc41ixBcrVfIlNrh2cMB1+Uo+YVFs3LwmjgRb8
        kwqoMW9PV9U0LL4zSOurrAvC7Y5cITb2zFb7g48wj/SVbRURC1Sg4Ut4RwskiAzA
        vPcnA6McX9xDpS7pjD5aaPPNu4HM/qbMijQB8lfqk+szMTn3+Gm1kDdSw==
X-Virus-Scanned: by amavisd-new at csg.dwd.de
Received: from ofcsg2cteh1.dwd.de ([172.30.232.65])
        by localhost (ofcsg2dn1.dwd.de [172.30.232.24]) (amavisd-new, port 10024)
        with ESMTP id c1FqjvsZsPkb for <stable@vger.kernel.org>;
        Wed, 14 Jul 2021 15:18:37 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 7B050C9024FE
        for <root@ofcsg2dn1.dwd.de>; Wed, 14 Jul 2021 15:18:37 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 74924C9022B7
        for <root@ofcsg2dn1.dwd.de>; Wed, 14 Jul 2021 15:18:37 +0000 (UTC)
X-DDEI-TLS-USAGE: Unused
Received: from ofcsgdbm.dwd.de (unknown [172.30.232.24])
        by ofcsg2cteh1.dwd.de (Postfix) with ESMTP
        for <root@ofcsg2dn1.dwd.de>; Wed, 14 Jul 2021 15:18:37 +0000 (UTC)
Received: from ofcsgdbm.dwd.de by localhost (Postfix XFORWARD proxy);
 Wed, 14 Jul 2021 15:18:37 -0000
Received: from ofcsg2dvf2.dwd.de (ofcsg2dvf2.dwd.de [172.30.232.11])
        by ofcsg2dn1.dwd.de (Postfix) with ESMTPS id 4GQ1Ns30X3z1xPB;
        Wed, 14 Jul 2021 15:18:37 +0000 (UTC)
Received: from ofmailhub.dwd.de (ofldap.dwd.de [141.38.39.208])
        by ofcsg2dvf2.dwd.de  with ESMTP id 16EFIaNs000632-16EFIaNt000632;
        Wed, 14 Jul 2021 15:18:36 GMT
Received: from praktifix.dwd.de (praktifix.dwd.de [141.38.44.46])
        by ofmailhub.dwd.de (Postfix) with ESMTP id B72C6453CE;
        Wed, 14 Jul 2021 15:18:36 +0000 (UTC)
Date:   Wed, 14 Jul 2021 15:18:36 +0000 (GMT)
From:   Holger Kiehl <Holger.Kiehl@dwd.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
In-Reply-To: <YO70VCcsg3k35C4E@kroah.com>
Message-ID: <bdf6f4cc-e534-f572-8b47-40bb4e4eca78@praktifix.dwd.de>
References: <20210712060912.995381202@linuxfoundation.org> <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de> <YO56HTE3k95JLeje@kroah.com> <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de> <df63b875-f140-606a-862a-73b102345cd@praktifix.dwd.de>
 <YO7nHhW2t4wEiI9G@kroah.com> <efa2bd81-2219-9e17-2841-d9b63fde22a1@praktifix.dwd.de> <YO70VCcsg3k35C4E@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-FE-Policy-ID: 2:2:1:SYSTEM
X-TMASE-Version: DDEI-5.1-8.6.1018-26282.000
X-TMASE-Result: 10--19.483800-10.000000
X-TMASE-MatchedRID: 0+daXaNUWRWWfDtBOz4q28bYuTb6+cQg69aS+7/zbj/mNRhvDVinv2Kp
        MJoimBcbPsj5qjS+dCEYwvDSTCG2BJQlTsRs6bL83nHtGkYl/VpF/jSlPtma/r0/f33kf9Gljn9
        2T7igP2sXndhpsXecxygywW45LfL0yFuWu3nxO+19j6Il8VAHF8ZU3kmz9C/H3pxmYneHU6t/cL
        JHsj+DkZhk/6bphJLMKISk8WdGcXCHbsX/GOLqdgPZZctd3P4BuqgVqRoQsiB7lDzh8Z+EhhBmt
        oCUanEvwgx24xjlvojzX5siSEObomsc2OVQ/NyCfid4LSHtIANuWkE39mLwR2zpNYa+Tlcne/cQ
        kmt0G7GVIsnYOY5w/uF45apSJW4bV6HcTxi1U3IqkSeDPauzryIk3dpe5X+hy5JfHvVu9Itvxt6
        yFJGkPy7TvubsyJqlq4m5Bec/+bTecSkNT7l/2Tn/wcdfjLjCp5HLLTy++LOKpw8ALShsZoIV24
        CuYj50/sXPK0ncsYCD2kmNFYh3E4R9x+rbFqRWhL9NX2TqmkAApu/OILCbuFGeC58QTjRVY2iR7
        K8WcsyfGsabEL0iTCoUbIPi49csR+a91TJtsEMwNhI4fIyiAtQeZo36ab1gQjW74KwsSvRpA0qW
        fVwWaLWrMaVJoeHukWBlIbwkmtSdqMbGsmxTg54CIKY/Hg3A2K+lN2ZUJHbEQdG7H66TyKsQd9q
        PXhnJ/4rWvpj9UcgD/dHyT/Xh7Q==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-DDEI-PROCESSED-RESULT: Safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Jul 2021, Greg Kroah-Hartman wrote:

> On Wed, Jul 14, 2021 at 02:07:10PM +0000, Holger Kiehl wrote:
> > On Wed, 14 Jul 2021, Greg Kroah-Hartman wrote:
> > 
> > > On Wed, Jul 14, 2021 at 01:26:26PM +0000, Holger Kiehl wrote:
> > > > On Wed, 14 Jul 2021, Holger Kiehl wrote:
> > > > 
> > > > > On Wed, 14 Jul 2021, Greg Kroah-Hartman wrote:
> > > > > 
> > > > > > On Wed, Jul 14, 2021 at 05:39:43AM +0000, Holger Kiehl wrote:
> > > > > > > Hello,
> > > > > > > 
> > > > > > > On Mon, 12 Jul 2021, Greg Kroah-Hartman wrote:
> > > > > > > 
> > > > > > > > This is the start of the stable review cycle for the 5.13.2 release.
> > > > > > > > There are 800 patches in this series, all will be posted as a response
> > > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > > let me know.
> > > > > > > > 
> > > > > > > > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > > > > > > > Anything received after that time might be too late.
> > > > > > > > 
> > > > > > > With this my system no longer boots:
> > > > > > > 
> > > > > > >    [  OK  ] Reached target Swap.
> > > > > > >    [   75.213852] NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
> > > > > > >    [   75.213926] NMI watchdog: Watchdog detected hard LOCKUP on cpu 2
> > > > > > >    [   75.213962] NMI watchdog: Watchdog detected hard LOCKUP on cpu 4
> > > > > > >    [FAILED] Failed to start Wait for udev To Complete Device Initialization.
> > > > > > >    See 'systemctl status systemd-udev-settle.service' for details.
> > > > > > >             Starting Activation of DM RAID sets...
> > > > > > >    [      ] (1 of 2) A start job is running for Activation of DM RAID sets (..min ..s / no limit)
> > > > > > >    [      ] (2 of 2) A start job is running for Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling (..min ..s / no limit)
> > > > > > > 
> > > > > > > System is a Fedora 34 with all updates applied. Two other similar
> > > > > > > systems with AMD CPUs (Ryzen 4750G + 3400G) this does not happen
> > > > > > > and boots fine. The system where it does not boot has an Intel
> > > > > > > Xeon E3-1285L v4 CPU. All of them use a dm_crypt root filesystem.
> > > > > > > 
> > > > > > > Any idea which patch I should drop to see if it boots again. I already
> > > > > > > dropped
> > > > > > > 
> > > > > > >    [PATCH 5.13 743/800] ASoC: Intel: sof_sdw: add quirk support for Brya and BT-offload
> > > > > > > 
> > > > > > > and I just see that this one should also be dropped:
> > > > > > > 
> > > > > > >    [PATCH 5.13 768/800] hugetlb: address ref count racing in prep_compound_gigantic_page
> > > > > > > 
> > > > > > > Will still need to test this.
> > > > > > 
> > > > > > Can you run 'git bisect' to see what commit causes the problem?
> > > > > > 
> > > > > Yes, will try to do that. I think it will take some time ...
> > > > > 
> > > > With the help of Pavel Machek and Jiri Slaby I was able 'git bisect'
> > > > this to:
> > > > 
> > > >    yoda:/usr/src/kernels/linux-5.13.y# git bisect good
> > > >    a483f513670541227e6a31ac7141826b8c785842 is the first bad commit
> > > >    commit a483f513670541227e6a31ac7141826b8c785842
> > > >    Author: Jan Kara <jack@suse.cz>
> > > >    Date:   Wed Jun 23 11:36:33 2021 +0200
> > > > 
> > > >        bfq: Remove merged request already in bfq_requests_merged()
> > > > 
> > > >        [ Upstream commit a921c655f2033dd1ce1379128efe881dda23ea37 ]
> > > > 
> > > >        Currently, bfq does very little in bfq_requests_merged() and handles all
> > > >        the request cleanup in bfq_finish_requeue_request() called from
> > > >        blk_mq_free_request(). That is currently safe only because
> > > >        blk_mq_free_request() is called shortly after bfq_requests_merged()
> > > >        while bfqd->lock is still held. However to fix a lock inversion between
> > > >        bfqd->lock and ioc->lock, we need to call blk_mq_free_request() after
> > > >        dropping bfqd->lock. That would mean that already merged request could
> > > >        be seen by other processes inside bfq queues and possibly dispatched to
> > > >        the device which is wrong. So move cleanup of the request from
> > > >        bfq_finish_requeue_request() to bfq_requests_merged().
> > > > 
> > > >        Acked-by: Paolo Valente <paolo.valente@linaro.org>
> > > >        Signed-off-by: Jan Kara <jack@suse.cz>
> > > >        Link: https://lore.kernel.org/r/20210623093634.27879-2-jack@suse.cz
> > > >        Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > >        Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > 
> > > >     block/bfq-iosched.c | 41 +++++++++++++----------------------------
> > > >     1 file changed, 13 insertions(+), 28 deletions(-)
> > > > 
> > > > Holger
> > > 
> > > Wonderful!
> > > 
> > > So if you drop that, all works well?  I'll go drop that from the queues
> > > now.
> > > 
> > Yes. Just double checked it took a plain 5.13.1, patched it with
> > patch-5.13.2-rc1.xz and then reverted
> > 
> >    PATCH-5.13-259-800-bfq-Remove-merged-request-already-in-bfq_requests_merged
> > 
> > and it booted fine with no problems. Tested several times.
> > Just wonder why it only happens on the Intel Broadwell CPU.
> > Maybe it is the 128MB eDRAM L4 Cache ...
> 
> Wondeful!
> 
> Could you test 5.14-rc1 to verify if this problem is there or not?  If
> it is, the developers need to know this so that they can work to fix the
> regression.
> 
No. 5.14-rc1 boots fine. Could not see any problems with it. Just tried
it.

Holger
