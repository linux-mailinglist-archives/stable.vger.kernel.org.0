Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F6B48F9C7
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 00:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbiAOXDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 18:03:01 -0500
Received: from mail-sn1anam02on2127.outbound.protection.outlook.com ([40.107.96.127]:20922
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233895AbiAOXDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jan 2022 18:03:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/FUfbdvSPh9Kea2BDGKT8MI72/0fEY+bh29jeDx3G2gO1V/S3TisPSyr5bRjzXJ2oBkI9LjZNxr7jNTAmnmGYnM3txIOLQxR+z7xZuPaEC6kM8POn5JwwI2FmZ+/ANOBuo8WotHmtCppI8BTA45W8fGELxbeXNbE/0Vos1jJ2lnV92SZrnHNHWTdtcrTImK1NuQ48SMC6kTe3gzE59RYQCqYBpj8dxJTibqWWX9Xh90PIff0Rv5Qkh1fmoDJfRb40QTdOrPBPK57UsCI9CIKOsmcaK2bgKXnePNaQbsXHqNuWvoXbNBJuetyuSgqqFrwP7q2SGcvFYITEEmE1QBag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfidEllS2PHma5Rq+M/fqEnyQ9pS9xA+ZgZZXZbbF7U=;
 b=F3u086bNyC9SHTiRkihjDeh+06782qSKfcehz2BkpLJfsiYZtuMMuTicblbUew3+tbl333Iz+aYRhPTJCQXKAKxxzGxdoPKH+hzpfDpEZbdQ9T1n9sZ6HA+mxrlmnwVlyLzD5Uj25qxn58pz1/R6/Kzs6Q73KsWjYwkwR+/uVXYBwQrDDebexwjaQuU6d5gOhV23zNVvTmFC5zCuMLx052AUVdSs1HFGP6xAzs1kfpOSiVXsG/hy15ZJTU92Z6Y85N9JYyFh760Uxsx2LT1IRPu90uw5Xx07ZdH3uiB7WvZmQRZJMpktd3LEbYjKdL7XZ7paeO0DrJA792nL3qdVLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfidEllS2PHma5Rq+M/fqEnyQ9pS9xA+ZgZZXZbbF7U=;
 b=aXi4xblEBFGeCikgDivsCwAGFVqLhrKVvekFsCGQ2v3P0FcvazpMG7NvYxDqwPkMhi1caJKJFech0oYFob+wtu8FNvIBovP2MfxDxlCJzT/LYufkPlAJP6LZJW9B/FO/hnUMqqpGywsJJXmmW9kQgEHOhXz7YRuimclKL+Vcf86aH5Sv6sPvIHUQDbY/BzjSWQWJsr9IQDN7Z397Hal3eNKzNC6SEapY75lKJpJpVK7ZldK8f1Lu2BaeNqDQG9yJi+yNjO0Z8NcuO7mQvp9KiVO+SvbWFLaSBaG/i/gjciT5ASB+dOIMB8UXMttYMcq4lfai/kdJd24S0uWZ4Z3ndg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 SA0PR01MB6140.prod.exchangelabs.com (2603:10b6:806:e4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.11; Sat, 15 Jan 2022 23:02:59 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::110:392e:efd1:88d0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::110:392e:efd1:88d0%8]) with mapi id 15.20.4888.012; Sat, 15 Jan 2022
 23:02:59 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Subject: [PATCH for-rc 3/4] IB/hfi1: Fix AIP early init panic
Date:   Sat, 15 Jan 2022 18:02:35 -0500
Message-Id: <1642287756-182313-4-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642287756-182313-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
References: <1642287756-182313-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::21) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a98495c3-cc61-4a66-58ab-08d9d87b2ce4
X-MS-TrafficTypeDiagnostic: SA0PR01MB6140:EE_
X-Microsoft-Antispam-PRVS: <SA0PR01MB6140998EDE02961E23B1C2ADF2559@SA0PR01MB6140.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wmBkDzTMv+FE4TKbWHO7VRPAL/js+xSQeLD3xyW9YIvynNzDL/9dMgcxJE6aSv9nZ9shYlfc6r8cKIgYwI8XcJxdtW2ybd6MHKNstN/ak0fvr1unamTqR4/uFT7arpgFMQOuWWYrx3FiGjCrd0+UHaMiVEq/TQYYBQwIuexx/ZtBPo/+0UJeuC8QX9282n+R9tJ/2BZL7hmK2/ghWStn6A7eb8UlkeIcyHA55pUEu3WpBl3QXIkzmp1Wj5zl1U7VbKM2YTgjD/aTF1DYGKhGS/wlRs4dfSYLXDDqFiNHuH5blVJdvC0lvX86X9JIJ4JwE3TArGQ2GLD6q2F1JxPvOSUzqwDHAEu1eREjJOrn6FA3Ermu4ko1z5DO31d2qKgi8j0+9dCP4aZAb+8lzGJGJZ/hyEWfpUS6AzvvCuQ+8qxityrlHwtJEZ7svqfvMopc9xWdT8b3ZJ3/namGRSYL3/FXhn2d0E26lEVnfPKpzrytTprsWTHxxS65KL3GCZfhtbgxdyycKat/4gCzUNByfBQoZP3Ytb/GkPhRO8GqOZKMZuLpmZQ6aCDWzZp2CqcvdhyDyCnGbeNqYrkQ5mL9OGx453DJ2lryd9vWb9Ren70oPORLWRNUQm5gQsyG1+lw98xdxrnMdEGEwwbFtzAjWALq3bSZC4ZJ0+v6hAI75pbOKDh+Um0dKFbZCPubGqGRxGJmqHwupV0CAKGm6O4tjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(396003)(376002)(136003)(346002)(366004)(36756003)(86362001)(508600001)(4326008)(26005)(45080400002)(52116002)(8936002)(6666004)(38350700002)(38100700002)(6916009)(8676002)(6486002)(66946007)(5660300002)(83380400001)(66556008)(66476007)(186003)(2906002)(316002)(2616005)(9686003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8gG/Dxk1Hrz3SUSrRVxrGYSX8BrDhLoPildMxgSO3nPHQzIM+yY0mjzWXHL9?=
 =?us-ascii?Q?pzxzmhDWCuLhpioTkwUifUekPjLu/fHJDSP5lfJ1Znl3PMXQkVLHPuXbCXek?=
 =?us-ascii?Q?MQIVOkBzmJ6QuCnF8e5upjA71JvZZou0be1O9uMYScZUSYPAJPvTg88ROuHS?=
 =?us-ascii?Q?zxFNKnV86/6TEoaIVuYG3h8XWEZK75jB1M0a40Oc0bxoMuSIIJZ9VZ9Ls2fy?=
 =?us-ascii?Q?WSIqdoJcG+CWi5EBZHEY4QcAFnQ7mYnO7UBbjJE0kY+LnZpOdHyjZAf3HVXV?=
 =?us-ascii?Q?XNQzw+ETyEUXT7hGjaHUl49jrmFVTqANScxoxcFX8e0URN0mLRewMlIb+oP2?=
 =?us-ascii?Q?xtVsi/xH5SVhAPzABcTy8VIVD4yMunaaoTe6DOO82+5P5VriHlUaF1i0KSfH?=
 =?us-ascii?Q?kxPPIN+0nlhWh9IBPmY8dzCDN3SI+naoNFwpNriw4rr2Rdz/eTmSAfh/csei?=
 =?us-ascii?Q?b+i1y5YIcDA5koUI6dMyvNWYHdiGF8dPN1LZrbLqEYi3hwabyAbRL2Zo7PL5?=
 =?us-ascii?Q?w/66uEH57jVzA/pDaWCQ00snEnK5eLd6I39/ZoqetgRXbMyRInCkOkfCUY9b?=
 =?us-ascii?Q?jBbJq9bDIE6NiYOI9e8M+0LuR8oVUlVAJDnionQ7baTGldYbj3FR3SRC0N38?=
 =?us-ascii?Q?IfAxuVYQOdj3BhyMzznduquHekqlU+AOuY8Y+JJybePs+eB89Zvd4iMq30HB?=
 =?us-ascii?Q?qBx4xEMWbEaCsKGuMCdD7bdPPD80NF1wOEYHwxmJZxcGP7X7zwYqqs5aKNXA?=
 =?us-ascii?Q?ma/I7hjsuJFbeSdogZdYER+cKbaj3q1qLKYNNg029z7Go4tMFeGpyATJOm+t?=
 =?us-ascii?Q?TbrOI5UzZWGmvSE7iGn0veKa2v5kO53rAk4DZexr4a2sD32Z+E5hmK5OYTWB?=
 =?us-ascii?Q?jW0zuAFlw2Jik6rwIJLBCcDq8RNnTfKX8o07GREluddIkMrv38pPLJwQoGS/?=
 =?us-ascii?Q?Ix1EodmSkPIrMnNYe4jSzcRTtBIh5OFrY/l7sk2Kkpp1cNPyi0/18ic2CHEc?=
 =?us-ascii?Q?L8GkdNBX6TI81E3H1nQyPnGzebFOVwmJ+KSs4Ti9HQtqvcmU11RhnhO/NWGB?=
 =?us-ascii?Q?j4dOUrZkhJ60RgYGLcMJKOWzSdlPZRIczB/osJ1oElAjOjf3NI+1+I2Pvxe+?=
 =?us-ascii?Q?tPQdMFVbWJNzptc0RY0fP6ut881qpkfU4jZRSsLh18faicStK4df+BoK0DV3?=
 =?us-ascii?Q?+6TSJvvcz2m+lYdQb34xExXW++sNzkypvgIicw2O4fTKusKme8DPoub+20i2?=
 =?us-ascii?Q?+tYZ1o9HJcqXpMBNyC6SugmWv0Djs9aTK7jU0byCA63n7fUwd+t7vmnQzQHA?=
 =?us-ascii?Q?SWh/eD+0p+/n5Je0R4EwHLP9a0X74A0bUQ6yNYRbpB6WpkNwE1I5jSdDdGdB?=
 =?us-ascii?Q?zHaI/985j8x1nD0qT2bYA+WYNDU6n8U4qY3XuYWhbx78UGSg3n4r8GQQYLOu?=
 =?us-ascii?Q?titzCrlhxVGW3doYsmnNWcRie3UMEIKAmdWvgBCFaDYuId1xjlY51ueYxaPd?=
 =?us-ascii?Q?ebkCMBK5rzVbZ8GbojSN3ZgUta+B0o9Mnn1vAL9HZIyGBmbbTDATjAJew170?=
 =?us-ascii?Q?3jSjq+N0TLJMgOLoKEgMNgPt/MY22UaoJ4Z/e5KZap4v1Z7ujqlClEh5k9Ac?=
 =?us-ascii?Q?6mgVLpWjWt9P1aSR8wQwWy4GDEPbsSxT3ZuJMDZ0RK1KV1TFRdPwpqfmuMo8?=
 =?us-ascii?Q?Sset3wYWU86r7kIB0oRrLg4/O8YwmaSungdLTbr72Q50YUfOmDTQTMaAkELa?=
 =?us-ascii?Q?y2An+OdDbQ=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98495c3-cc61-4a66-58ab-08d9d87b2ce4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2022 23:02:59.7430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRZ4YIOSyv0uc+6v5SUZ698w7cxT/q//ZGpI+ZH6xQpQiYBseHdnXPGkJTTo7BM962ECZogRCevYSzdhiNp4TfuGWXdyG9E1msBeWfsPCEdbTqGuOHMWYtWVJ2G1VRdv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6140
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

An early failure in hfi1_ipoib_setup_rn() can lead to the following
panic:

[  355.625765] BUG: unable to handle kernel NULL pointer dereference at 00000000000001b0
[  355.634188] PGD 0 P4D 0
[  355.636731] Oops: 0002 [#1] SMP NOPTI
[  355.659994] Workqueue: events work_for_cpu_fn
[  355.664371] RIP: 0010:try_to_grab_pending+0x2b/0x140
[  355.669361] Code: 1f 44 00 00 41 55 41 54 55 48 89 d5 53 48 89 fb 9c 58 0f 1f 44 00 00 48 89 c2 fa 66 0f 1f 44 00 00 48 89 55 00 40 84 f6 75 77 <f0> 48 0f ba 2b 00 72 09 31 c0 5b 5d 41 5c 41 5d c3 48 89 df e8 6c
[  355.688238] RSP: 0018:ffffb6b3cf7cfa48 EFLAGS: 00010046
[  355.693491] RAX: 0000000000000246 RBX: 00000000000001b0 RCX: 0000000000000000
[  355.700664] RDX: 0000000000000246 RSI: 0000000000000000 RDI: 00000000000001b0
[  355.707836] RBP: ffffb6b3cf7cfa70 R08: 0000000000000f09 R09: 0000000000000001
[  355.715007] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[  355.722178] R13: ffffb6b3cf7cfa90 R14: ffffffff9b2fbfc0 R15: ffff8a4fdf244690
[  355.729351] FS:  0000000000000000(0000) GS:ffff8a527f400000(0000) knlGS:0000000000000000
[  355.737485] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  355.743260] CR2: 00000000000001b0 CR3: 00000017e2410003 CR4: 00000000007706f0
[  355.750434] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  355.757607] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  355.764780] PKRU: 55555554
[  355.767497] Call Trace:
[  355.769954]  __cancel_work_timer+0x42/0x190
[  355.774159]  ? dev_printk_emit+0x4e/0x70
[  355.778115]  iowait_cancel_work+0x15/0x30 [hfi1]
[  355.782768]  hfi1_ipoib_txreq_deinit+0x5a/0x220 [hfi1]
[  355.787933]  ? dev_err+0x6c/0x90
[  355.791188]  hfi1_ipoib_netdev_dtor+0x15/0x30 [hfi1]
[  355.796188]  hfi1_ipoib_setup_rn+0x10e/0x150 [hfi1]
[  355.801094]  rdma_init_netdev+0x5a/0x80 [ib_core]
[  355.805832]  ? hfi1_ipoib_free_rdma_netdev+0x20/0x20 [hfi1]
[  355.811434]  ipoib_intf_init+0x6c/0x350 [ib_ipoib]
[  355.816251]  ipoib_intf_alloc+0x5c/0xc0 [ib_ipoib]
[  355.821068]  ipoib_add_one+0xbe/0x300 [ib_ipoib]
[  355.825712]  add_client_context+0x12c/0x1a0 [ib_core]
[  355.830794]  enable_device_and_get+0xdc/0x1d0 [ib_core]
[  355.836049]  ib_register_device+0x572/0x6b0 [ib_core]
[  355.841128]  rvt_register_device+0x11b/0x220 [rdmavt]
[  355.846219]  hfi1_register_ib_device+0x6b4/0x770 [hfi1]
[  355.851486]  do_init_one.isra.20+0x3e3/0x680 [hfi1]
[  355.856389]  local_pci_probe+0x41/0x90
[  355.860154]  work_for_cpu_fn+0x16/0x20
[  355.863921]  process_one_work+0x1a7/0x360
[  355.867948]  ? create_worker+0x1a0/0x1a0
[  355.871888]  worker_thread+0x1cf/0x390
[  355.875655]  ? create_worker+0x1a0/0x1a0
[  355.879594]  kthread+0x116/0x130
[  355.882838]  ? kthread_flush_work_fn+0x10/0x10
[  355.887302]  ret_from_fork+0x1f/0x40
[  355.890893] Modules linked in: rpcrdma sunrpc rdma_ucm ib_srpt ib_isert acpi_cpufreq(-) iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm mlx5_ib intel_rapl_msr intel_rapl_
common isst_if_common x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass mlx5_core crct10dif_pclmul crc32_pclmul hfi1(OE+) tls ghash_clmulni_intel rdmavt(OE) mgag200 drm_kms_helper mlxfw mei_me syscopyarea sysfill
rect ib_uverbs sysimgblt fb_sys_fops rapl ioatdma intel_cstate tg3 i2c_algo_bit mei hpwdt ses drm ib_core pci_hyperv_intf uas enclosure hpilo pcspkr intel_uncore wmi lpc_ich dca acpi_tad ipmi_ssif acpi_power_meter binfmt_misc xpmem(O
) numatools(O) fuse ip_tables dm_mod xfs libcrc32c vfat fat ext4 mbcache jbd2 sd_mod t10_pi sg smartpqi ipmi_si scsi_transport_sas usb_storage ipmi_devintf ipmi_msghandler crc32c_intel [last unloaded: mlxfw]
[  355.970226] CR2: 00000000000001b0
[  355.973583]

The panic happens in hfi1_ipoib_txreq_deinit() because there is a NULL
deref when hfi1_ipoib_netdev_dtor() is called in this error case.

hfi1_ipoib_txreq_init() and hfi1_ipoib_rxq_init() are self unwinding so fix
by adjusting the error paths accordingly.

Other changes:
- hfi1_ipoib_free_rdma_netdev() is deleted including the free_netdev()
  since the netdev core code deletes calls free_netdev()
- The switch to the accelerated entrances is moved to the success path.

Fixes: d99dc602e2a5 ("IB/hfi1: Add functions to transmit datagram ipoib packets")
Cc: stable@vger.kernel.org
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/ipoib_main.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ipoib_main.c b/drivers/infiniband/hw/hfi1/ipoib_main.c
index e1a2b02..8306ed5 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_main.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_main.c
@@ -168,12 +168,6 @@ static void hfi1_ipoib_netdev_dtor(struct net_device *dev)
 	free_percpu(dev->tstats);
 }
 
-static void hfi1_ipoib_free_rdma_netdev(struct net_device *dev)
-{
-	hfi1_ipoib_netdev_dtor(dev);
-	free_netdev(dev);
-}
-
 static void hfi1_ipoib_set_id(struct net_device *dev, int id)
 {
 	struct hfi1_ipoib_dev_priv *priv = hfi1_ipoib_priv(dev);
@@ -211,24 +205,23 @@ static int hfi1_ipoib_setup_rn(struct ib_device *device,
 	priv->port_num = port_num;
 	priv->netdev_ops = netdev->netdev_ops;
 
-	netdev->netdev_ops = &hfi1_ipoib_netdev_ops;
-
 	ib_query_pkey(device, port_num, priv->pkey_index, &priv->pkey);
 
 	rc = hfi1_ipoib_txreq_init(priv);
 	if (rc) {
 		dd_dev_err(dd, "IPoIB netdev TX init - failed(%d)\n", rc);
-		hfi1_ipoib_free_rdma_netdev(netdev);
 		return rc;
 	}
 
 	rc = hfi1_ipoib_rxq_init(netdev);
 	if (rc) {
 		dd_dev_err(dd, "IPoIB netdev RX init - failed(%d)\n", rc);
-		hfi1_ipoib_free_rdma_netdev(netdev);
+		hfi1_ipoib_txreq_deinit(priv);
 		return rc;
 	}
 
+	netdev->netdev_ops = &hfi1_ipoib_netdev_ops;
+
 	netdev->priv_destructor = hfi1_ipoib_netdev_dtor;
 	netdev->needs_free_netdev = true;
 
-- 
1.8.3.1

