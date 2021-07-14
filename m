Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2773C7FDA
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 10:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbhGNIRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 04:17:55 -0400
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:36291 "EHLO ofcsgdbm.dwd.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhGNIRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 04:17:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by ofcsg2dn4.dwd.de (Postfix) with ESMTP id 4GPr070SHNz3wDm
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 08:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dwd.de; h=
        content-type:content-type:mime-version:references:message-id
        :in-reply-to:subject:subject:from:from:date:date:received
        :received:received:received:received:received:received:received;
         s=dwd-csg20210107; t=1626250502; x=1627460103; bh=e5pnm72OJF8lq
        bUh1JoO9W40SSc2JAzCwfBIeXGRxU4=; b=h+f3LQOGRaP+lwOT30gFzAQoB1GUB
        Pom3WQNh2k+wGayVMje89gNyVQriqKnXa+EOzA34BwlTZerLzREwxkXzB9BwLjHP
        lHGaY1a97RB8hWslccGLhBUdwDEYHJyzXEHM3AgdnE1ln3vIWrDF9GqtBXQwnNFw
        dUu2bDS2n+74Xv2P633n8yGU4opMPafqsSDilW4OqDzrMBe3DYe6V0KlU7P5oHr0
        0XzkcRv/5Uarwc2p/8jyYvUfkV3meV4yF8w/CFkDPVAs/ifI2MlF/L8Ujnp5nLKV
        cE3OZU9I5ujKQZ7HFHqzNlKr0/z03DiTHs9K3+q/I/EZ6IKaduI6aWCJg==
X-Virus-Scanned: by amavisd-new at csg.dwd.de
Received: from ofcsg2ctev2.dwd.de ([172.30.232.68])
        by localhost (ofcsg2dn4.dwd.de [172.30.232.27]) (amavisd-new, port 10024)
        with ESMTP id pgD1kr2XRIQ3 for <stable@vger.kernel.org>;
        Wed, 14 Jul 2021 08:15:02 +0000 (UTC)
Received: from ofcsg2ctev2.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 870D55E3C80
        for <root@ofcsg2dn4.dwd.de>; Wed, 14 Jul 2021 08:15:01 +0000 (UTC)
Received: from ofcsg2ctev2.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 79CED5E3C74
        for <root@ofcsg2dn4.dwd.de>; Wed, 14 Jul 2021 08:15:01 +0000 (UTC)
X-DDEI-TLS-USAGE: Unused
Received: from ofcsgdbm.dwd.de (unknown [172.30.232.27])
        by ofcsg2ctev2.dwd.de (Postfix) with ESMTP
        for <root@ofcsg2dn4.dwd.de>; Wed, 14 Jul 2021 08:15:01 +0000 (UTC)
Received: from ofcsgdbm.dwd.de by localhost (Postfix XFORWARD proxy);
 Wed, 14 Jul 2021 08:15:02 -0000
Received: from ofcsg2dvf2.dwd.de (ofcsg2dvf2.dwd.de [172.30.232.11])
        by ofcsg2dn4.dwd.de (Postfix) with ESMTPS id 4GPr065Nx3z3wTw;
        Wed, 14 Jul 2021 08:15:02 +0000 (UTC)
Received: from ofmailhub.dwd.de (ofldap.dwd.de [141.38.39.196])
        by ofcsg2dvf2.dwd.de  with ESMTP id 16E8F2Gh015635-16E8F2Gi015635;
        Wed, 14 Jul 2021 08:15:02 GMT
Received: from praktifix.dwd.de (praktifix.dwd.de [141.38.44.46])
        by ofmailhub.dwd.de (Postfix) with ESMTP id 21608E2BEC;
        Wed, 14 Jul 2021 08:15:02 +0000 (UTC)
Date:   Wed, 14 Jul 2021 08:15:02 +0000 (GMT)
From:   Holger Kiehl <Holger.Kiehl@dwd.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
In-Reply-To: <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de>
Message-ID: <20653f1-deaa-6fac-1f8-19319e87623a@praktifix.dwd.de>
References: <20210712060912.995381202@linuxfoundation.org> <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de> <YO56HTE3k95JLeje@kroah.com> <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-FE-Policy-ID: 2:2:1:SYSTEM
X-TMASE-Version: DDEI-5.1-8.6.1018-26280.006
X-TMASE-Result: 10--21.179100-10.000000
X-TMASE-MatchedRID: PL66URbwWA+WfDtBOz4q28bYuTb6+cQg69aS+7/zbj/mNRhvDVinv2Kp
        MJoimBcbPsj5qjS+dCEYwvDSTCG2BJQlTsRs6bL83nHtGkYl/VpF/jSlPtma/r0/f33kf9Gljn9
        2T7igP2sXndhpsXecxygywW45LfL0yFuWu3nxO+19j6Il8VAHF8ZU3kmz9C/H3pxmYneHU6t/cL
        JHsj+DkZhk/6bphJLMKISk8WdGcXCHbsX/GOLqdgPZZctd3P4BuqgVqRoQsiB7lDzh8Z+EhhBmt
        oCUanEvwgx24xjlvojzX5siSEObomsc2OVQ/NyCfid4LSHtIANuWkE39mLwR2zpNYa+Tlcne/cQ
        kmt0G7GVIsnYOY5w/uF45apSJW4bV6HcTxi1U3IqkSeDPauzryIk3dpe5X+hy5JfHvVu9It4yU/
        xJmlyD5xLNR1DtMjuAbnTY7qqRyLvcjreWe4HbPbta0OAYFzy+wLfgJ/bqPM8sS0dkmSGjDzprL
        002Ijx4vM1YF6AJbY65tgsJWcFUd934/rDAK3zGjFMngtLLWhJFQD69E10vA==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-DDEI-PROCESSED-RESULT: Safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Wed, 14 Jul 2021, Holger Kiehl wrote:

> On Wed, 14 Jul 2021, Greg Kroah-Hartman wrote:
> 
> > On Wed, Jul 14, 2021 at 05:39:43AM +0000, Holger Kiehl wrote:
> > > Hello,
> > > 
> > > On Mon, 12 Jul 2021, Greg Kroah-Hartman wrote:
> > > 
> > > > This is the start of the stable review cycle for the 5.13.2 release.
> > > > There are 800 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > With this my system no longer boots:
> > > 
> > >    [  OK  ] Reached target Swap.
> > >    [   75.213852] NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
> > >    [   75.213926] NMI watchdog: Watchdog detected hard LOCKUP on cpu 2
> > >    [   75.213962] NMI watchdog: Watchdog detected hard LOCKUP on cpu 4
> > >    [FAILED] Failed to start Wait for udev To Complete Device Initialization.
> > >    See 'systemctl status systemd-udev-settle.service' for details.
> > >             Starting Activation of DM RAID sets...
> > >    [      ] (1 of 2) A start job is running for Activation of DM RAID sets (..min ..s / no limit)
> > >    [      ] (2 of 2) A start job is running for Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling (..min ..s / no limit)
> > > 
> > > System is a Fedora 34 with all updates applied. Two other similar
> > > systems with AMD CPUs (Ryzen 4750G + 3400G) this does not happen
> > > and boots fine. The system where it does not boot has an Intel
> > > Xeon E3-1285L v4 CPU. All of them use a dm_crypt root filesystem.
> > > 
> > > Any idea which patch I should drop to see if it boots again. I already
> > > dropped
> > > 
> > >    [PATCH 5.13 743/800] ASoC: Intel: sof_sdw: add quirk support for Brya and BT-offload
> > > 
> > > and I just see that this one should also be dropped:
> > > 
> > >    [PATCH 5.13 768/800] hugetlb: address ref count racing in prep_compound_gigantic_page
> > > 
> > > Will still need to test this.
> > 
> > Can you run 'git bisect' to see what commit causes the problem?
> > 
> Yes, will try to do that. I think it will take some time ...
> 
Hmm, I am doing something wrong?

   git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
   cd linux-5.13.y/
   git tag|grep v5.13
   v5.13
   v5.13-rc1
   v5.13-rc2
   v5.13-rc3
   v5.13-rc4
   v5.13-rc5
   v5.13-rc6
   v5.13-rc7
   v5.13.1

There is no v5.13.2-rc1. It is my first time with 'git bisect'. Must be
doing something wrong. How can I get the correct git kernel rc version?

Holger
