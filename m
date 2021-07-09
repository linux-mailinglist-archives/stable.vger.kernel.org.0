Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BAC3C2811
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 19:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhGIROK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 13:14:10 -0400
Received: from mail-mw2nam08on2055.outbound.protection.outlook.com ([40.107.101.55]:42944
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229546AbhGIROK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 13:14:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1ZIc3d5QdjSrGroIzWoxw1tTU6mNWYb5G39vPJVP8qL0NxdzdmqGi3PJU/5dyv7ryHxXgCMqH5rtg7PfxVINXKConJ4atiU4g9AEcctOGmeTx37EoMEvVYSFh0iKROxeLqLKKB12iwr0bnPRsxtBpUV4uCA44/FR5pBpHbjwpLsCyFb+WUdarVymdKMqDGFEwY4kbGJX5v3nMmA8ZikpZoBt2lleT30JZBuRnHihRc40DqQUp1cG5Gym+CSNzypTxvSdBtp94ZeKh2L/g/rKh6jOySU76E4LGXOIBY/S+J2N4gm/F58o9QlhCr2ou6007Zxl+ZKWa42GdR1t0rl5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=689r8D6AA8cGsFlPuTkvekHb5vKPnC9snNmO3WXFzIU=;
 b=mbF4DLV6PxcH/h1AK8BN6VpEm1oaKDiMY3H9+sgicnttaLsNqxpp8SHFKriDSbBCywry47PMztC0ewZtZhwYRpKwy98CLmffBRmxoTMjPL0YKRGrH/Q7CAVIpVvBwZaLUIhX5xl8qw1Z5FQEmHeqO9Hfl3bsvo7QMKBXpyFsY5jHuH+tm6wlLPpfkaYL+6t943Fx4zv1cJEdOuugI/LSbdystIjybi4pX/n/w8wnHYLwFxVC1fPAqQFp9etWX7xyGdMAfgBZSLdAe8WW49Lo3lDiGFruUuLH9AUYtl5DWRieluSiLsAFp9l7QDArxFvC557Fgq+QfydkMRk9tX0KXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=689r8D6AA8cGsFlPuTkvekHb5vKPnC9snNmO3WXFzIU=;
 b=r1nHCi+QtiK89EfZtvi2IRS9AwcIOxXcNA4ng0vp+2kiK79Vc8GqI7/zGxiWYs8h4MJswk8AB6bLVwVyrzqFHPMQ7H+ZXameefxEV+GoroyPdh5jhvraYgAvxyar3n0PU58gc83kWteh8XE+IhshhRLMGIySeMS/DGfVDqIbxN+8/s3I3a938MGgU+LDXKGLHSLbPXRnaw1u/b8owdQA5SyJow5cYkm20D3XMxpCVXuBhsR19/iYfkQBX2v+aNDHOX6fO+ILML7ElHkIvaKOLsr5mQk1xxgZrZHd7+iv+Hq08g/aF4sPw7Wymd4pz3Ade3AAIecz7czea4pJXgkaMg==
Received: from MW4PR03CA0163.namprd03.prod.outlook.com (2603:10b6:303:8d::18)
 by DM5PR12MB2391.namprd12.prod.outlook.com (2603:10b6:4:b3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Fri, 9 Jul
 2021 17:11:24 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::bb) by MW4PR03CA0163.outlook.office365.com
 (2603:10b6:303:8d::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 17:11:23 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Jul
 2021 17:11:22 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:21 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/25] 4.14.239-rc1 review
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
References: <20210709131627.928131764@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Message-ID: <5d251a3d04e3445aabf774ae2164057e@HQMAIL101.nvidia.com>
Date:   Fri, 9 Jul 2021 17:11:21 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3f93cd9-5618-40ae-47e1-08d942fc941e
X-MS-TrafficTypeDiagnostic: DM5PR12MB2391:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2391BBAA4C0214B9AC4A2A77D9189@DM5PR12MB2391.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D1o4kA4/zuhzc7ynkN+mF6LtZpIwEUZzkw3J4weYhQMrtNQtU7uKbh2D7QsDpnu2nFXsFLFzdtQmoNEFSy/8cAlgHEz+wQsYL8p3x42dypoyGySY2PLrlDKibzxXUKYdzq1jSDeNdHEUKEVBzOX5yPbgaO+24BlQkAFsDbT2qP2Pc2leQrCmrN/i3D63DF4WfBSEepZiGCpu9zN6ZtlwC34lXFaxt8DJOLx0IvA7pzxV/lGAZB2X1N1WegLSfVfLs4tVJbJxlIq92V83zoRqCMtb/4EMOqbWT6M+pShSf7owuBhE4UfKugzmo0rIQ/B4DIhjU4dzbFN3sRpy8I5I6s43z6Z/TzKe9yAqriq3XLyXvwMTR454NZ1FCflKqu88hye02UOT2NnfTP+DvMBAN6M/NzU7ONwFOKzVfG4znt+CqgtVZOjCF9xdkvXIFBKRs/q4Ny9o050lNWvvSBTuOoS1M+ZouiqLe0Ma3MEbaLR+pDBDnfV+/8Oe3OmJp2sfBxPbKB4j9c99o7wC3CFp8NLaYoozj9CqH+jO+COFYHZcWRNeMuy6VCE59D8hCuRDGkexQRlQdS86YzFNgdhcr4xpotMmPyHUqsNXggkNyRWhVP4wpt+iUyGP+b9Bk6FV4dDxX3lksZBiR5xzFkayfcq6rZjxxzNmn9Mf0xYukeMMu8++tSg17FIBbqIDb8z9o8xNETDqoObPec+HIjie3byzKMHhRNIr0x7PfXg2gFIu0FuyAGdIRhdKjRq5//3cEIvc6sS2x7qy9bRic4Puf/FKXI8E9qFYNn5oU2bzAGlyqZTwMORspRmoQfNilzhg
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966006)(36840700001)(186003)(4326008)(316002)(54906003)(8676002)(7636003)(336012)(108616005)(36860700001)(6916009)(8936002)(26005)(70206006)(7416002)(70586007)(24736004)(966005)(356005)(82740400003)(83380400001)(47076005)(5660300002)(86362001)(66574015)(478600001)(34070700002)(426003)(2906002)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 17:11:23.2770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3f93cd9-5618-40ae-47e1-08d942fc941e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2391
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 09 Jul 2021 15:18:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.239 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.239-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git l=
inux-4.14.y
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
>     Linux 4.14.239-rc1
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
> Sean Young <sean@mess.org>
>     kfifo: DECLARE_KIFO_PTR(fifo, u64) does not work on arm 32 bit
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
> Jue Wang <juew@google.com>
>     mm/thp: fix page_address_in_vma() on file THP tails
>=20
> Hugh Dickins <hughd@google.com>
>     mm/thp: fix vma_address() if virtual address below file offset
>=20
> Hugh Dickins <hughd@google.com>
>     mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
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
> Michal Hocko <mhocko@kernel.org>
>     include/linux/mmdebug.h: make VM_WARN* non-rvals
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                             |   4 +-
>  drivers/gpu/drm/nouveau/nouveau_bo.c |   4 +-
>  drivers/scsi/sr.c                    |   2 +
>  drivers/xen/events/events_base.c     |  23 ++++-
>  include/linux/hugetlb.h              |  16 ----
>  include/linux/kfifo.h                |   3 +-
>  include/linux/mmdebug.h              |  21 ++++-
>  include/linux/pagemap.h              |  13 +--
>  include/linux/rmap.h                 |   3 +-
>  kernel/futex.c                       |   2 +-
>  kernel/kthread.c                     |  77 +++++++++++------
>  mm/huge_memory.c                     |  26 ++----
>  mm/hugetlb.c                         |   5 +-
>  mm/internal.h                        |  53 +++++++++---
>  mm/page_vma_mapped.c                 | 160 ++++++++++++++++++++++---------=
----
>  mm/rmap.c                            |  48 ++++++-----
>  16 files changed, 281 insertions(+), 179 deletions(-)
>=20
>=20
>=20

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.239-rc1-g89bdc2d2afb3
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
