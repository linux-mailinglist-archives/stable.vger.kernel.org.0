Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D373C7F32
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 09:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238230AbhGNHSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 03:18:09 -0400
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:58887 "EHLO ofcsgdbm.dwd.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238176AbhGNHSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 03:18:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by ofcsg2dn4.dwd.de (Postfix) with ESMTP id 4GPpg53fqqz3x34
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 07:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dwd.de; h=
        content-type:content-type:mime-version:references:message-id
        :in-reply-to:subject:subject:from:from:date:date:received
        :received:received:received:received:received:received:received;
         s=dwd-csg20210107; t=1626246913; x=1627456514; bh=ptkvR+j9Q3EVi
        0DqyoYMFGSpBgWBrLYb69e0XRuZ9Sw=; b=zg/rK7FyuZvg09sc8xhuFopxc2LU5
        de0IjDhsEnIi1aZXG8OuDZkl/K4Ey8QEzOTZLA7zrAi46HCeeeA9uN6D3kYfE46u
        CrAzRVJ8+2Ujcol/ueosSombQGCCRPqA3qV6ingsQsiJE89jIN0r9x6Y8SyO453J
        4h70ZjTzPdI6XpuoP+ePgddrP0cYzhA7BfWI8x7uN+TTfowQIbSr6mMdl1Z3z1F1
        Xz+2MHdxTf4bI7ZwJyxBPebW/Q0F4nb8Kr/amYJropxSA/8fwz6B860FBpYAcMmx
        drob4OAsRGLYgY3PruDmw0LnsivCDYr+Klaz4IueRG6rP+7XCSxevVexA==
X-Virus-Scanned: by amavisd-new at csg.dwd.de
Received: from ofcsg2cteh1.dwd.de ([172.30.232.65])
        by localhost (ofcsg2dn4.dwd.de [172.30.232.27]) (amavisd-new, port 10024)
        with ESMTP id O9KBVbkD8KBP for <stable@vger.kernel.org>;
        Wed, 14 Jul 2021 07:15:13 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 4C738C902584
        for <root@ofcsg2dn4.dwd.de>; Wed, 14 Jul 2021 07:15:13 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 4A117C901F21
        for <root@ofcsg2dn4.dwd.de>; Wed, 14 Jul 2021 07:15:13 +0000 (UTC)
X-DDEI-TLS-USAGE: Unused
Received: from ofcsgdbm.dwd.de (unknown [172.30.232.27])
        by ofcsg2cteh1.dwd.de (Postfix) with ESMTP
        for <root@ofcsg2dn4.dwd.de>; Wed, 14 Jul 2021 07:15:13 +0000 (UTC)
Received: from ofcsgdbm.dwd.de by localhost (Postfix XFORWARD proxy);
 Wed, 14 Jul 2021 07:15:13 -0000
Received: from ofcsg2dvf2.dwd.de (ofcsg2dvf2.dwd.de [172.30.232.11])
        by ofcsg2dn4.dwd.de (Postfix) with ESMTPS id 4GPpg51kYlz3wcY;
        Wed, 14 Jul 2021 07:15:13 +0000 (UTC)
Received: from ofmailhub.dwd.de (ofldap.dwd.de [141.38.39.196])
        by ofcsg2dvf2.dwd.de  with ESMTP id 16E7FC2p012672-16E7FC2q012672;
        Wed, 14 Jul 2021 07:15:12 GMT
Received: from praktifix.dwd.de (praktifix.dwd.de [141.38.44.46])
        by ofmailhub.dwd.de (Postfix) with ESMTP id B1443E2BEB;
        Wed, 14 Jul 2021 07:15:12 +0000 (UTC)
Date:   Wed, 14 Jul 2021 07:15:12 +0000 (GMT)
From:   Holger Kiehl <Holger.Kiehl@dwd.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
In-Reply-To: <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
Message-ID: <1bb58e55-ed1a-9fd8-1d0-2f6c86b4294@praktifix.dwd.de>
References: <20210712060912.995381202@linuxfoundation.org> <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-FE-Policy-ID: 2:2:1:SYSTEM
X-TMASE-Version: DDEI-5.1-8.6.1018-26280.006
X-TMASE-Result: 10--20.763700-10.000000
X-TMASE-MatchedRID: vEvJ7Rh1lGiWfDtBOz4q28bYuTb6+cQg69aS+7/zbj+qvcIF1TcLYJIF
        RidW0GC6mA9yZrHVFoAYwvDSTCG2BJQlTsRs6bL83nHtGkYl/VpF/jSlPtma/r0/f33kf9Gljn9
        2T7igP2sXndhpsXecxygywW45LfL0yFuWu3nxO+19j6Il8VAHF8ZU3kmz9C/H3pxmYneHU6t/cL
        JHsj+DkZhk/6bphJLMKISk8WdGcXCHbsX/GOLqdgPZZctd3P4BuqgVqRoQsiB7lDzh8Z+EhhBmt
        oCUanEvwgx24xjlvojzX5siSEObomsc2OVQ/NyCfid4LSHtIANuWkE39mLwR2zpNYa+Tlcne/cQ
        kmt0G7GVIsnYOY5w/mah00JPACmxlwV2iaAfSWf+xOhjarOnHrHlqZYrZqdI+gtHj7OwNO2FR9H
        au8GO7qfDnZdVcKQklExlQIQeRG0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-DDEI-PROCESSED-RESULT: Safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Jul 2021, Holger Kiehl wrote:

> Hello,
> 
> On Mon, 12 Jul 2021, Greg Kroah-Hartman wrote:
> 
> > This is the start of the stable review cycle for the 5.13.2 release.
> > There are 800 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > Anything received after that time might be too late.
> > 
> With this my system no longer boots:
> 
>    [  OK  ] Reached target Swap.
>    [   75.213852] NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
>    [   75.213926] NMI watchdog: Watchdog detected hard LOCKUP on cpu 2
>    [   75.213962] NMI watchdog: Watchdog detected hard LOCKUP on cpu 4
>    [FAILED] Failed to start Wait for udev To Complete Device Initialization.
>    See 'systemctl status systemd-udev-settle.service' for details.
>             Starting Activation of DM RAID sets...
>    [      ] (1 of 2) A start job is running for Activation of DM RAID sets (..min ..s / no limit)
>    [      ] (2 of 2) A start job is running for Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling (..min ..s / no limit)
> 
> System is a Fedora 34 with all updates applied. Two other similar
> systems with AMD CPUs (Ryzen 4750G + 3400G) this does not happen
> and boots fine. The system where it does not boot has an Intel
> Xeon E3-1285L v4 CPU. All of them use a dm_crypt root filesystem.
> 
> Any idea which patch I should drop to see if it boots again. I already
> dropped
> 
>    [PATCH 5.13 743/800] ASoC: Intel: sof_sdw: add quirk support for Brya and BT-offload
> 
> and I just see that this one should also be dropped:
> 
>    [PATCH 5.13 768/800] hugetlb: address ref count racing in prep_compound_gigantic_page
> 
> Will still need to test this.
> 
Dropping that did not fix it.

Holger
