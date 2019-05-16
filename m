Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13852203F3
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 12:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfEPK5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 06:57:54 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4092 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbfEPK5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 06:57:53 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cdd422c0000>; Thu, 16 May 2019 03:57:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 16 May 2019 03:57:52 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 16 May 2019 03:57:52 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 May
 2019 10:57:49 +0000
Subject: Re: [PATCH 4.4 000/266] 4.4.180-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>
References: <20190515090722.696531131@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f32de22f-c928-2eaa-ee3f-d2b26c184dd4@nvidia.com>
Date:   Thu, 16 May 2019 11:57:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1558004268; bh=d6xdDPGIBvJ5QstgC2Nw2Cwip3DSHDDaU8lNDLsgEBo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=kV7MXgTbsuYCFRp9BGASRRlQFID1B4ja9jyM8K1cR1QUg7WrUyXD8gRtXhUXH7HH4
         to9MCDz//AU0t1JSrZKtEuRCTDZkvU1N6Ot7OihzYCUQFgK8MzP3N68V8CW5UcyUcE
         wRrdO/EyrIMmlqfuLRfl4nZrrtlLs9tdKhR5jq7+qHN4dFaNq0x0WnHYaY0c85RcZj
         uDL84FzvR5a0U+ma4kW1TLPelwa2e96MHyk8CpGAzeEkN67YJ5kjCK2JSVvHqQcNTZ
         ECxR6PRCvOLnWmRROXL4wHqRVDrpq3gT06HT4nTyS/JmHFo/xR7SUoncfnCmZWJEcQ
         DghHt3gn3kVFA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 15/05/2019 11:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.180 release.
> There are 266 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:49 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.180-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Boot regression detected for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    15 boots:	6 pass, 9 fail
    8 tests:	8 pass, 0 fail

Linux version:	4.4.180-rc1-gbe756da
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Bisect is point to the following commit ...

# first bad commit: [7849d64a1700ddae1963ff22a77292e9fb5c2983] mm, vmstat: make quiet_vmstat lighter

Reverting this on top v4.4.180-rc1 fixes the problem.  

Crash observed ...

[   17.155812] ------------[ cut here ]------------
[   17.160431] kernel BUG at /home/jonathanh/workdir/tegra/mlt-linux_stable-4.4/kernel/mm/vmstat.c:1425!
[   17.169632] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
[   17.175450] Modules linked in: ttm
[   17.178859] CPU: 0 PID: 92 Comm: kworker/0:2 Not tainted 4.4.179-00160-g7849d64a1700 #8
[   17.186843] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
[   17.193100] Workqueue: vmstat vmstat_update
[   17.197279] task: ee14e700 ti: ee17a000 task.ti: ee17a000
[   17.202663] PC is at vmstat_update+0x9c/0xa4
[   17.206921] LR is at vmstat_update+0x94/0xa4
[   17.211179] pc : [<c00cdd80>]    lr : [<c00cdd78>]    psr: 20000113
[   17.211179] sp : ee17bef8  ip : 00000000  fp : eef91ac0
[   17.222629] r10: 00000008  r9 : 00000000  r8 : 00000000
[   17.227840] r7 : eef99900  r6 : eef91ac0  r5 : eef8f34c  r4 : ee13dc00
[   17.234350] r3 : 00000001  r2 : 0000000f  r1 : c0a885e0  r0 : 00000001
[   17.240861] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   17.247978] Control: 10c5387d  Table: ad02006a  DAC: 00000051
[   17.253708] Process kworker/0:2 (pid: 92, stack limit = 0xee17a210)
[   17.259957] Stack: (0xee17bef8 to 0xee17c000)
[   17.264301] bee0:                                                       ee13dc00 eef8f34c
[   17.272459] bf00: eef91ac0 c003b69c eef91ac0 ee17a038 c0a4ba60 eef91ac0 eef91ad4 ee17a038
[   17.280618] bf20: c0a4ba60 ee13dc18 ee13dc00 00000008 eef91ac0 c003b8f8 00000000 c09f6100
[   17.288778] bf40: c003b8b0 ee102a00 00000000 ee13dc00 c003b8b0 00000000 00000000 00000000
[   17.296937] bf60: 00000000 c0040ad0 00000000 00000000 00000000 ee13dc00 00000000 00000000
[   17.305094] bf80: ee17bf80 ee17bf80 00000000 00000000 ee17bf90 ee17bf90 ee17bfac ee102a00
[   17.313253] bfa0: c00409d0 00000000 00000000 c000f650 00000000 00000000 00000000 00000000
[   17.321412] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   17.329570] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[   17.337733] [<c00cdd80>] (vmstat_update) from [<c003b69c>] (process_one_work+0x124/0x338)
[   17.345893] [<c003b69c>] (process_one_work) from [<c003b8f8>] (worker_thread+0x48/0x4c4)
[   17.353966] [<c003b8f8>] (worker_thread) from [<c0040ad0>] (kthread+0x100/0x118)
[   17.361348] [<c0040ad0>] (kthread) from [<c000f650>] (ret_from_fork+0x14/0x24)
[   17.368553] Code: e5930010 eb05c417 e3500000 08bd8070 (e7f001f2) 
[   17.374633] ---[ end trace 17cf004302766810 ]---

Cheers
Jon

-- 
nvpublic
