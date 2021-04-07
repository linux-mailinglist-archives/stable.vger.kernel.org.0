Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DC7357835
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 01:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhDGXEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 19:04:45 -0400
Received: from mail-mw2nam10on2050.outbound.protection.outlook.com ([40.107.94.50]:61793
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229714AbhDGXEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 19:04:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSm/WqPgyrB6xOCyi5PRie3SxowhLvB5rwZrHwg1oQaTjnk8ZfSmUF5KTUKgzaASKWv7sEvssRREeoR56ggwTUg59T5MYEsAY2BvjtZvvCGd8CdiI0lSn/poUYDnk7/w3qOl6qCNXmiZSkeAmcr4Zf8Jc2JSxtxC4uZKxooo+h5dmuyL9cPAlikCZ/J+kZSR6OTrkPy99ndNpnTZlZin7NGbKMR3yURz2MEte78+UbD6Cr2MJJItrcgl7zooFoeLQsT8m7uKvSMLgbQVqdZonchpBaKHSadVeHvlBLIneOUIpB2iUQyrVj2cR41mE9J4O9IfdFK3gND3Sohw+c6HEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5z9WNH76YK/e34xCmaZMzgaLey3vcmayUjQQmpbz/5o=;
 b=UV/G24X0vM1yoGAAzzCGiSfbBoRIeaxj7yAPy+V2NrK8FaBara2R8ejxLq71XNO8WeqJ2YLpV43yn9nlgtxANpnx4WskSOLVhUhcrMQVJBo0gGFtz0eGJ9J45g9lscD5abn28KtELJISGM2UZO7ioPjoWFIJaxOv5XwqfYgSfsj2gerLYqz7sznkqwdKx9iRFflZXvQ7Vw3nGDweMZWZLod+zOMz3WuxWGaTx+/wUzzyRk2lyyYXAzvTIq5JX8G7xjGhikkIVzni77yYhhAErZmue4HoDv3rfOCBWQnctquSuAHQI+b18uGikgSTKGjbGZBJKqMPkLKPACN/GGwQUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5z9WNH76YK/e34xCmaZMzgaLey3vcmayUjQQmpbz/5o=;
 b=OSSi5TXPDygcLG/75vCuAvsKTm6PeGIehqWZxOOsKRgWwPXmah/CRZxzRYtkFN7MSgk8X7SkOePyji0s+fl/EXTLcAW1ZH2eyMvIQonJDtjJRFfoX4u15Y/mIrjelpAE1EP1C9ct57p8jZ0gPh8aIz2I+4nhXy7cVcBwilVJyOXYMD1YLbaLrwavOXG5a+0uDXGGgPHTRRENCaY3W64OHltLcvizgR6dbtBRexk6q2zwoneM1XabQSbqLkku0Be4xwFtcjzJ93EPlb1aP25vIO3lGihYaPD8CW09yS8AYEcEbYLLGDPMlU6fX9XkV78ReVXJrtU8JL1kWI+y6E8WDw==
Authentication-Results: cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;cornelisnetworks.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0108.namprd12.prod.outlook.com (2603:10b6:4:58::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Wed, 7 Apr
 2021 23:04:33 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 23:04:33 +0000
Date:   Wed, 7 Apr 2021 20:04:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     dennis.dalessandro@cornelisnetworks.com
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for-rc 3/4] IB/hfi1: Fix probe time panic when AIP is
 enabled with a buggy BIOS
Message-ID: <20210407230430.GA575861@nvidia.com>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-4-git-send-email-dennis.dalessandro@cornelisnetworks.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617025700-31865-4-git-send-email-dennis.dalessandro@cornelisnetworks.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0314.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0314.namprd13.prod.outlook.com (2603:10b6:208:2c1::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Wed, 7 Apr 2021 23:04:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUHDq-002Pp0-SF; Wed, 07 Apr 2021 20:04:30 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b7420b9-084a-48cb-98f3-08d8fa19814c
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0108:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB01086C5C4D98A0F88DB3DA10C2759@DM5PR1201MB0108.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zgqCLDRdKNWak2wxdBpn7k88LeO56xNIi9KQRtF/I7wyA1mkLoFzpM6/jiZQ8/rxaPHUuZ2Bbd1nofup9dTGkoOO6f/JPdUfKFku99EOlorUh63kKFMI1H7V807kZiAaKrAxVudgruCQqruPJUc9gR0xhLgdMBVWC39f7SS7Nzyz82ffxG7FyhOMANLfP+Q6XHf5dkAwQzdpccG4J+ie0z/XTLgGS5Q0lQQoiN9Xfxrovh11NLdUQv6fX96e5B0w+nUWalvbnFIZUTWkebnlNEs9qW5146C7otaseSHrYMR09MahjeuyiWIGptsQHwAavieT3A0lgJc2FlFxQ+CiIei8RHdKb9AOxCabIGALqX2n/5vLzcjsGUuB/Qsqni9L+MimJ6eahTzUNAht23H6Gu9IxM3dUOexotCsJEg/smUMB4U1pNMZIBaG/MmoJ+W2GpUlyZ6JTbTQpdfS+kiZuUjESI4LbFMfdT9VT0WyEVoOre2b5sbrbG21fYP6xIbJHze8EPejbM54E6dEvxV+wMYqz28mpbOZY2hGpnFcrEBSS58dEIv2WZjb/PfVrrUeKwTcdNZEpJ3QIm1g9eLY4cFBseRWSN2bNVu/Y1GdA3vw8oIP8QaXNBHEIjyAWkxS5kjZkEPtqyQpfPOMCh9d7nreq7ohqaStCvtzeY18sDWDjkXnI4rrxNK/1A19TdCa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(2906002)(4326008)(2616005)(5660300002)(36756003)(26005)(83380400001)(6916009)(66476007)(316002)(1076003)(478600001)(86362001)(186003)(9746002)(8676002)(38100700001)(66946007)(33656002)(66556008)(9786002)(426003)(8936002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5pnIrON9bKs2cTQC4MCmlVrlt23PpK6H+dNbKnfhdxK0FONgGJg47SCkSsMd?=
 =?us-ascii?Q?OvbIYV+zCNBlr1+diJTUNWW297PZai7in8eAsuXrWwk1vMkWa7pWVds7Z7Rp?=
 =?us-ascii?Q?1l+Zajy+pvFH8xF9w2Ej9QfP69x5H3ephYBHI9/Tb4PPDSxZ4bNPYsfY6MOy?=
 =?us-ascii?Q?1l20Kk4AW7tSXMom1eerv4fl1Ardidvwssm/ZiPbSPmgDeU3bKFeHcaETBji?=
 =?us-ascii?Q?GcyX7Kr5F5KXqsbQ/UN8uar7Qn0tM6vQdANu0FvUPfMl79GIdWAPOcOzTCcp?=
 =?us-ascii?Q?uoXb6cx92B0lPevdk03v4bUgVMWsWSAOxadAUw0VsvA/q08eiQAuQtVIMXtN?=
 =?us-ascii?Q?tXcmIo4IVSEspnzYD6H7fYj6rUeaysgCF3HW5TDnBk0/A6057LinrlO9ePAg?=
 =?us-ascii?Q?qobboD5/dKNLTlIXuN38Rx9tOmWJZAgiP1Xp2eH1i24DDHIdSd15U4ulOpfC?=
 =?us-ascii?Q?KzZ7nHHEkDfRic4MONJzgsquLejfEupvLejEMGt68DHSzRGvBaGpmvTcjvfx?=
 =?us-ascii?Q?SFi8YLt4amZS8YNywDDGkk9lNIr3EIboaCHI+AvxHqiWOw8BcidwkZdGHkvl?=
 =?us-ascii?Q?2jvxr+iV+eYc86xRDgSCc9idbVKvs75vYR4Bs2bROb590rh5P1EMvPvUqBoh?=
 =?us-ascii?Q?PpJdAMnF1PP46T2Ju00e4Us+ET6sqG1aLok8acKUdcodaqJkFXZlRNPXIMG8?=
 =?us-ascii?Q?Prq1GFeKeVGfi+8IeDaEOjNGRpiWCw3kO/37JvalenVWNs4f/dQjDTUq/ADS?=
 =?us-ascii?Q?ur2PF5tn2/RV1WaRhg2HC7PMxnTa47tQ2wjZDp43NI7m7o2DAT5HcRWrZDyw?=
 =?us-ascii?Q?5WqNjqGWdGXBTKfA6RZW1uyLIXKdHLscMGXtxtb6AJ5UCw4KJh7y/3YUE/zv?=
 =?us-ascii?Q?FGF/N1gdeHC8/bBPnNbtfvYMbv0PJBAr2ZbnYiOg9F6YYW/v5oVc93vddfoa?=
 =?us-ascii?Q?K4EkDX1AVJYy4mf9LR7j/+N3e9F4lzcDOH2eXIs/svj0T3NUpoXv+UQ8KbH9?=
 =?us-ascii?Q?vknCk5n7brj9BslHAM2qCI+042jR2t+zJL5NH2r20/ivy+Z/MHO1uwh3wzGL?=
 =?us-ascii?Q?BWGr+3O7815eMHVEXELEhCr5fxqGAu8QxOE2WZupTUhgOh6MBPgM5xmG/ysw?=
 =?us-ascii?Q?h6Qy1v7lqPj6VR2AhuAdPVNtth+SLHs81RgzP8MjcYFhioRn4wxZOIK4lav4?=
 =?us-ascii?Q?itV3+VM7bC9z9lu6kDk+MmuHnxhFaQcVlY14QBsyYIr07DrD/yX1kdwAcTaj?=
 =?us-ascii?Q?6msNQz9K3i+6dDIrP27dOG+At/oboe+u+8SpAOEmgHh08mjC7z2Icl5Ci+k7?=
 =?us-ascii?Q?1e5Q9MTHlRqnQqBNGbAqdRS0Qj79leEJlwUhE4XLITd9wA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b7420b9-084a-48cb-98f3-08d8fa19814c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 23:04:33.1427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: myCv1oGn5zWHIW3NaeEgOOfb/Vt6+kJaOaTktkG0ioXGBLGshJjGEIxscuF4RA1F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0108
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 09:48:19AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
> From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> 
> A panic can result when AIP is enabled:
> 
> [ 8.644728] BUG: unable to handle kernel NULL pointer dereference at 000000000000000
> [ 8.657708] PGD 0 P4D 0
> [ 8.664488] Oops: 0000 1 SMP PTI
> [ 8.672190] CPU: 70 PID: 981 Comm: systemd-udevd Tainted: G OE --------- - - 4.18.0-240.el8.x86_64 #1
> [ 8.687916] Hardware name: Intel Corporation S2600KP/S2600KP, BIOS SE5C610.86B.01.01.0005.101720141054 10/17/2014
> [ 8.703340] RIP: 0010:__bitmap_and+0x1b/0x70
> [ 8.741702] RSP: 0018:ffff99aa0845f9f0 EFLAGS: 00010246
> [ 8.751757] RAX: 0000000000000000 RBX: ffff8d5a6fc18000 RCX: 0000000000000048
> [ 8.764203] RDX: 0000000000000000 RSI: ffffffffc06336f0 RDI: ffff8d5a8fa67750
> [ 8.776990] RBP: 0000000000000079 R08: 0000000fffffffff R09: 0000000000000000
> [ 8.789768] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffc06336f0
> [ 8.802007] R13: 00000000000000a0 R14: ffff8d5a6fc18000 R15: 0000000000000003
> [ 8.814317] FS: 00007fec137a5980(0000) GS:ffff8d5a9fa80000(0000) knlGS:0000000000000000
> [ 8.827629] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 8.838309] CR2: 0000000000000000 CR3: 0000000a04b48002 CR4: 00000000001606e0
> [ 8.850502] Call Trace:
> [ 8.857950] hfi1_num_netdev_contexts+0x7c/0x110 [hfi1]
> [ 8.868295] hfi1_init_dd+0xd7f/0x1a90 [hfi1]
> [ 8.877681] ? pci_bus_read_config_dword+0x49/0x70
> [ 8.887567] ? pci_mmcfg_read+0x3e/0xe0
> [ 8.896797] do_init_one.isra.18+0x336/0x640 [hfi1]
> [ 8.906958] local_pci_probe+0x41/0x90
> [ 8.915784] pci_device_probe+0x105/0x1c0
> [ 8.925002] really_probe+0x212/0x440
> [ 8.933687] driver_probe_device+0x49/0xc0
> [ 8.942918] device_driver_attach+0x50/0x60
> [ 8.952553] __driver_attach+0x61/0x130
> [ 8.961553] ? device_driver_attach+0x60/0x60
> [ 8.971122] bus_for_each_dev+0x77/0xc0
> [ 8.979912] ? klist_add_tail+0x3b/0x70
> [ 8.988886] bus_add_driver+0x14d/0x1e0
> [ 8.998175] ? dev_init+0x10b/0x10b [hfi1]
> [ 9.007531] driver_register+0x6b/0xb0
> [ 9.016757] ? dev_init+0x10b/0x10b [hfi1]
> [ 9.026220] hfi1_mod_init+0x1e6/0x20a [hfi1]
> [ 9.035601] do_one_initcall+0x46/0x1c3
> [ 9.043958] ? free_unref_page_commit+0x91/0x100
> [ 9.053460] ? _cond_resched+0x15/0x30
> [ 9.062426] ? kmem_cache_alloc_trace+0x140/0x1c0
> [ 9.071982] do_init_module+0x5a/0x220
> [ 9.080574] load_module+0x14b4/0x17e0
> [ 9.088911] ? __do_sys_finit_module+0xa8/0x110
> [ 9.098231] __do_sys_finit_module+0xa8/0x110
> [ 9.107307] do_syscall_64+0x5b/0x1a0
> 
> The issue happens when pcibus_to_node() returns NO_NUMA_NODE.
> 
> Fix this issue by moving the initialization of dd->node to hfi1_devdata
> allocation and remove the other pcibus_to_node() calls in the probe
> path and use dd->node instead.
> 
> Affinity logic is adjusted to use a new field dd->affinity_entry
> as a guard instead of dd->node.
> 
> Fixes: 4730f4a6c6b2 ("IB/hfi1: Activate the dummy netdev")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
> ---
>  drivers/infiniband/hw/hfi1/affinity.c  | 21 +++++----------------
>  drivers/infiniband/hw/hfi1/hfi.h       |  1 +
>  drivers/infiniband/hw/hfi1/init.c      | 10 +++++++++-
>  drivers/infiniband/hw/hfi1/netdev_rx.c |  3 +--
>  4 files changed, 16 insertions(+), 19 deletions(-)

Applied to for-rc

Thanks,
Jason
