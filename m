Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75473C2819
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 19:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhGIRON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 13:14:13 -0400
Received: from mail-bn8nam11on2047.outbound.protection.outlook.com ([40.107.236.47]:44641
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229606AbhGIROM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 13:14:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5caMMWmjYS6RQjMLm/5mqvPDf7LhZw9pBlDDu62cDs5dOLq5EVhU60q5bq34B29zQm2CeDUd6R8uLK17+ebxYoTCp37y1ZsToBFJBhD7asyQ9OTcR4F79gokz2dHf6s0y6a4t9oiDSJfTnL+V5zHOkNe+elJH8R0O4OJS5PclCVjKcw0LVpFy6r/FbVw5L/ScnhaUa+oNcLdE8duyvNZ9HGKKYJ0ZclnWPs6xTtkYkvLjjoh61tPsy8dqVezUNTTIlTouAJsRsC6BYwFwxsxQPFVAJfitn/kezj2gOSO4X3QEa0ENoEf9TGiN/MulHCakcDwdkJU8pSKEHbSNI72A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULCJyUD7rmKFv9L0YQLQeXBA0WhhMroDoBWi7HrjtpE=;
 b=cQqPOpg1CdJTIc3tuLfYKO4KyZjvc2CHcSVWa/SZ2xYAxi9X84w9xujAXnQ0xV8GZukkKsju0SVcM5pYAUbk/m/tcncWhbs2PDibbhBzu+AJuBWUsvIZmwjhzKwlgI1VNd5d1hVhzdsrcTdRq0yCLqTYgNlaMCtGNzv8B+BdfX4En5pd+mG8rskyIfaNZ6nK+UWkP0BSTEew5G5ZIbLhzQFIIMXWRFMWGfT/JDVja0kbT5iVh0IPUEXJQC/+irh6Dl0CQ3G1ZRroaiquVVXz+jCPrf3kW+LRo5UtZD3kDDknWJNlwQX7KXk44KRtmKE2uUuCH2dQxcT5iCg+TipXdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULCJyUD7rmKFv9L0YQLQeXBA0WhhMroDoBWi7HrjtpE=;
 b=L+HaAgo3n5fYj96LIfpmarbmQppryFgzHvi+XnH3JxGtWWqMHvL5M8nsrv4czqHJUYDIVcvNAFmmIr61lpoD3/jLDJoX3rvO0y3ewLKEcf/gdsIC9ixYa0FsEK3cS+tXRCwjpgOMH+c06fMQmAk2WL101mu0RQav/vqtF8sXi+M0yArrXO7UZV7ipt+56X1t/mrndkkYPqhvK3GTooe9MBOS1rV8V8zL8+rb2NzIXyRMXXrcUqIqfer4/Yl314r6kVNLY31/JA8xDv1iP1thX0f5amAvvyYjPPkveBmZHAq1VmXJQB/mrUiuyzc/gE1Epg4K1nTWDV7OkhqMz7RDfg==
Received: from MWHPR17CA0052.namprd17.prod.outlook.com (2603:10b6:300:93::14)
 by CH2PR12MB4905.namprd12.prod.outlook.com (2603:10b6:610:64::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Fri, 9 Jul
 2021 17:11:27 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::e7) by MWHPR17CA0052.outlook.office365.com
 (2603:10b6:300:93::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 17:11:27 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Jul
 2021 10:11:26 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:26 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/34] 4.19.197-rc1 review
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
References: <20210709131644.969303901@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Message-ID: <2f05744fb2b04104b75674bff186fa8a@HQMAIL107.nvidia.com>
Date:   Fri, 9 Jul 2021 17:11:26 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b778df4-882e-4788-20ee-08d942fc966a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4905:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4905EAB6A90EE5E7CF68AA57D9189@CH2PR12MB4905.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f5ieSJS9s8fVs9ma5CawAP4X1ZCIn5rYTpbR++uFQpOL2dUXUSeEBrdhYTqTzkPgttPub+H08IhI/ALE7QGJzA19+pOQCkYHCgZVXxnUvUbryfppfxOSeWfqwgLQbcM25/NQGiYoaxvawYVn+aw1LJVVgWqukzL5OjJWokOY1VDXcCRYWA5uEh37iLZDFlqectZ1GgiBASUmMcMe/dvcAJ27cTXiHUCtTQH0uQHmHSojaqatT7nMpV779O+c4uYif9cyh5cz7IW32k5w2Fa7rKm7znz9QQwslBDGu4hAWl4hIB2eHTOh/oKScROgg9LnPhu5vzGkfdkeAmVlIblbdUO/t2ZeTanaSvNANk+dKkDaR+0F4mgNIv3VqV5v+L5pklp7dpOX9BsLPA7M3IEwv9YeAF9vTYTjSagQkcwCjVry4bGlG0HvCydm2tYNjSNzOphEhxoCwiB7QmKvExqzIRSKYRZmeO4yI1E+J5dLhn/CbUnACsWdq93YxVVgTRVlMm1OMFxHBM6EwtNaD8cAYYn5NbLE3VQF8ZSr2hspDj+HXAUsOe01ZC6/yr+AuK/bDHsLPUuVt/Gzq0o1B5nNVvRrX6HdJUSaOPcgN0PpACq4wl5NfwKkrkC66caqOvU5/xkArOVMh0+FR8rPm+pSs6f3qRMj3Mn6wmZzSGLkdv/AoAj84PYaPffkLQn7FCUC73jLL0WHpOBt4BdM89jM2tFn8ldD0jC7X9DRUmiW/NazqhTkZROg3IqMRKALSDKfkin4HJRhgAUPbYLTZpadi52bHQ0RwUM3APaTI49IXKyqgEKVyslgTxuWRR8fS4yP
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(36840700001)(46966006)(108616005)(82310400003)(7636003)(356005)(86362001)(8676002)(36860700001)(34070700002)(47076005)(6916009)(24736004)(316002)(66574015)(7416002)(83380400001)(336012)(70206006)(70586007)(54906003)(4326008)(186003)(82740400003)(26005)(478600001)(8936002)(5660300002)(966005)(2906002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 17:11:27.1275
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b778df4-882e-4788-20ee-08d942fc966a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4905
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 09 Jul 2021 15:20:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.197 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.197-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git l=
inux-4.19.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 4.19.197-rc1
>=20
> Tony Lindgren <tony@atomide.com>
>     clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940
>=20
> Tony Lindgren <tony@atomide.com>
>     clocksource/drivers/timer-ti-dm: Prepare to handle dra7 timer wrap issue
>=20
> Tony Lindgren <tony@atomide.com>
>     clocksource/drivers/timer-ti-dm: Add clockevent and clocksource support
>=20
> afzal mohammed <afzal.mohd.ma@gmail.com>
>     ARM: OMAP: replace setup_irq() by request_irq()
>=20
> Alper Gun <alpergun@google.com>
>     KVM: SVM: Call SEV Guest Decommission if ASID binding fails
>=20
> Juergen Gross <jgross@suse.com>
>     xen/events: reset active flag for lateeoi events later
>=20
> Petr Mladek <pmladek@suse.com>
>     kthread: prevent deadlock when kthread_mod_delayed_work() races with kt=
hread_cancel_delayed_work_sync()
>=20
> Petr Mladek <pmladek@suse.com>
>     kthread_worker: split code for canceling the delayed work timer
>=20
> Anson Huang <Anson.Huang@nxp.com>
>     ARM: dts: imx6qdl-sabresd: Remove incorrect power supply assignment
>=20
> David Rientjes <rientjes@google.com>
>     KVM: SVM: Periodically schedule when unregistering regions on destroy
>=20
> Tahsin Erdogan <trdgn@amazon.com>
>     ext4: eliminate bogus error in ext4_data_block_valid_rcu()
>=20
> Christian K=C3=B6nig <christian.koenig@amd.com>
>     drm/nouveau: fix dma_address check for CPU/GPU sync
>=20
> ManYi Li <limanyi@uniontech.com>
>     scsi: sr: Return appropriate error code when disk is ejected
>=20
> Hugh Dickins <hughd@google.com>
>     mm, futex: fix shared futex pgoff on shmem huge page
>=20
> Hugh Dickins <hughd@google.com>
>     mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
>=20
> Hugh Dickins <hughd@google.com>
>     mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
>=20
> Hugh Dickins <hughd@google.com>
>     mm: page_vma_mapped_walk(): get vma_address_end() earlier
>=20
> Hugh Dickins <hughd@google.com>
>     mm: page_vma_mapped_walk(): use goto instead of while (1)
>=20
> Hugh Dickins <hughd@google.com>
>     mm: page_vma_mapped_walk(): add a level of indentation
>=20
> Hugh Dickins <hughd@google.com>
>     mm: page_vma_mapped_walk(): crossing page table boundary
>=20
> Hugh Dickins <hughd@google.com>
>     mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
>=20
> Hugh Dickins <hughd@google.com>
>     mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd
>=20
> Hugh Dickins <hughd@google.com>
>     mm: page_vma_mapped_walk(): settle PageHuge on entry
>=20
> Hugh Dickins <hughd@google.com>
>     mm: page_vma_mapped_walk(): use page for pvmw->page
>=20
> Yang Shi <shy828301@gmail.com>
>     mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
>=20
> Hugh Dickins <hughd@google.com>
>     mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
>=20
> Jue Wang <juew@google.com>
>     mm/thp: fix page_address_in_vma() on file THP tails
>=20
> Hugh Dickins <hughd@google.com>
>     mm/thp: fix vma_address() if virtual address below file offset
>=20
> Hugh Dickins <hughd@google.com>
>     mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
>=20
> Hugh Dickins <hughd@google.com>
>     mm/thp: make is_huge_zero_pmd() safe and quicker
>=20
> Hugh Dickins <hughd@google.com>
>     mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/rmap: use page_not_mapped in try_to_unmap()
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/rmap: remove unneeded semicolon in page_not_mapped()
>=20
> Alex Shi <alex.shi@linux.alibaba.com>
>     mm: add VM_WARN_ON_ONCE_PAGE() macro
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                               |   4 +-
>  arch/arm/boot/dts/dra7.dtsi            |  11 ++
>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi |   4 -
>  arch/arm/mach-omap1/pm.c               |  13 ++-
>  arch/arm/mach-omap1/time.c             |  10 +-
>  arch/arm/mach-omap1/timer32k.c         |  10 +-
>  arch/arm/mach-omap2/board-generic.c    |   4 +-
>  arch/arm/mach-omap2/timer.c            | 181 +++++++++++++++++++++++------=
----
>  arch/x86/kvm/svm.c                     |  33 ++++--
>  drivers/clk/ti/clk-7xx.c               |   1 +
>  drivers/gpu/drm/nouveau/nouveau_bo.c   |   4 +-
>  drivers/scsi/sr.c                      |   2 +
>  drivers/xen/events/events_base.c       |  23 ++++-
>  fs/ext4/block_validity.c               |   4 +-
>  include/linux/cpuhotplug.h             |   1 +
>  include/linux/huge_mm.h                |   8 +-
>  include/linux/hugetlb.h                |  16 ---
>  include/linux/mm.h                     |   3 +
>  include/linux/mmdebug.h                |  13 +++
>  include/linux/pagemap.h                |  13 +--
>  include/linux/rmap.h                   |   3 +-
>  kernel/futex.c                         |   2 +-
>  kernel/kthread.c                       |  77 +++++++++-----
>  mm/huge_memory.c                       |  56 +++++-----
>  mm/hugetlb.c                           |   5 +-
>  mm/internal.h                          |  53 +++++++---
>  mm/memory.c                            |  41 ++++++++
>  mm/page_vma_mapped.c                   | 160 ++++++++++++++++++-----------
>  mm/pgtable-generic.c                   |   4 +-
>  mm/rmap.c                              |  48 +++++----
>  mm/truncate.c                          |  43 ++++----
>  31 files changed, 546 insertions(+), 304 deletions(-)
>=20
>=20
>=20

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.197-rc1-gdf520a4397b2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
