Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80FC462055
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 20:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhK2TZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 14:25:19 -0500
Received: from mail-bn8nam08on2110.outbound.protection.outlook.com ([40.107.100.110]:44353
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234229AbhK2TXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 14:23:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKzeizBFpuEa7LdrdqL88vlCtA5jaf4wCbzKVv0/uaUcgTYeN2ju/lwGX8AmXdW9kusaRKxShJYP1DW++/lXb0xW8qKxrVzZJjaQhc+cOnszQ68SRyuA5HdUu1fHbUqByFC1n9B5HkjcoP6iA3Cint5R3XctHI/6nx+vZ2wwpUsGhyZB69zqqDLijhSaXZXA+V8jem7RXTYHZKSANlVJD5Bd+y5ceAui7p68jcThVt1M79s0S6LrbAv2+rkLR2oxAWFHp6UweLuEo7i7hhxMV43m0pjG1FEM44aIArkC7VqJKTFUZxou1GPq45kTMR+ptg3+h6lFXtnEEvDTbnvVpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOjuqqS32unn6C3gC6erHofd5sIdxCsdtG2rJBfwjns=;
 b=Dh2N0f5ajkN5eWitTi6pzhKHK8pmsRb46iCtA5dMCaYu/HNofHk0vLo96TZLbbK682E+4GLGL4ocAEsdAPQRtz/VFekUvpcDcyYvDjgLtoK7g1sjHkeOP7vGtw1hd57Y7pF6m0apFd24eQ1fB9XmCvt4tYu8/1JkT5rOe3f2vrdm4cPRWyYEcnDeeGTahQz982wlp5UuVqFaH3vPzyE1l1mzOBC6YCpz/YyenPV4hWqpA7Os69aIjrPVY5SD2LFgU/FTVc+mpEIx0e5PdHimT97KnZi/kJHubybZ4rwagW/QGYkBaBybI6a+KLblD9FfpCc7ms3XNaMG9Xa+xnP6TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOjuqqS32unn6C3gC6erHofd5sIdxCsdtG2rJBfwjns=;
 b=mA8qsbmva4HrRadFkUqY3ap72/GtIeU2zzjmtJpsuXx1xoo05NeMRzYsU22EzpKvn5r/hp9vUWvymR5LAk1Lk8EDKb92GAHWQbOd6ZstlbacAkGlNpGXegbdhZIQIVp+H4asY36hRpaTmKfZzp/g2UFYAZ/26tz3Jeg42lFPpX+d7KULtr0QHSViaGxbTX5nxMxPJ83byP1JaVV7so9Z4WV2aXqKmY1vX60VfFA2/Lgn/+OZp/HGcNlAhFTYBDAj0NbVadFBK6Nz+xYiFfhV7Yl5CdrbcpFOE2rZh1bKuzHM90yNjs9HTkS7zLprKgrco3AZ+UUL8aKbLutJJCq7FA==
Received: from DM3PR14CA0134.namprd14.prod.outlook.com (2603:10b6:0:53::18) by
 DM5PR0101MB2906.prod.exchangelabs.com (2603:10b6:4:2b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.21; Mon, 29 Nov 2021 19:19:59 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::9) by DM3PR14CA0134.outlook.office365.com
 (2603:10b6:0:53::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24 via Frontend
 Transport; Mon, 29 Nov 2021 19:19:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=awfm-01.cornelisnetworks.com;
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 19:19:58 +0000
Received: from awfm-01.cornelisnetworks.com (localhost [127.0.0.1])
        by awfm-01.cornelisnetworks.com (8.14.7/8.14.7) with ESMTP id 1ATJJwNN118013;
        Mon, 29 Nov 2021 14:19:58 -0500
Subject: [PATCH for-rc 2/4] IB/hfi1: Insure use of smp_processor_id() is
 preempt disabled
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To:     jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Date:   Mon, 29 Nov 2021 14:19:58 -0500
Message-ID: <20211129191958.101968.87329.stgit@awfm-01.cornelisnetworks.com>
In-Reply-To: <20211129191510.101968.6259.stgit@awfm-01.cornelisnetworks.com>
References: <20211129191510.101968.6259.stgit@awfm-01.cornelisnetworks.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de915734-8b16-444a-9474-08d9b36d3c13
X-MS-TrafficTypeDiagnostic: DM5PR0101MB2906:
X-Microsoft-Antispam-PRVS: <DM5PR0101MB29067D14DB080D193CFDB7FCF4669@DM5PR0101MB2906.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VzY1d31azzxtzOH1xlrOnbF75BQc0zYJMECr30SK7/+fiOl14aICDHiAVfDZHzOOVpd/kcQ56ZcgySbvHCt0XE3RoU2xn3eOOHyPXV/r1Ya+0vkiP5BZLfvZkddQ1y51lahjNPaR6ZMMjoHHrwPJUKgJ0wd4Vy/9zF+LlWpqFnPPqpjVyvsHEJ6A+91GojYJh4DIH9XTybcy46FPeEtrZCYCAEGefo18j/R8H2cynRvh5B6reqLH2kA2dpihQeojMNARu/c/LJJ5bNBIyWT73kW4FBu5ucUR1PTJUEPsHA1yBM7jdTcRHjhb6zoLM80kSTlGfgg0J0Los8xg84yg4P997h6BIE3PYm5+TzfZMCasrBmrwkY2LpMj+P7AZ9zFY94gRmr3S/5gTibfUkrhTwfLkE0KvgvjzwGBtsMpmtnWNSfI2YB+j5QwAgtmssPMAkXEgSGjh2s+ntys3coPePDbqO6zaqQL3xnUxjatNJlPFRjLNAj3Zn+pM5QGw4Ja9MEcFSmnnJrkCn3OQpH5j2KBDDnYd327LGTIc2jG6X8ZN857G07ByYZ82NnGqhptp05srcnEQza5vLydRIikiO8jXZlgK99ENMHGAPKOcFSUFDp++4UdIrekuSmUV1y8P28iDtA69qc4AcB8YyWw/ySeOW27a+3Yr0vG+sEKYbU7Vy55XeMLC6HIVcA+mitArEM4jjh5tj4roNnBX67I//yPQf6rD0RXBTQrU1hjkNI=
X-Forefront-Antispam-Report: CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:awfm-01.cornelisnetworks.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39840400004)(46966006)(36840700001)(7696005)(86362001)(8936002)(5660300002)(426003)(356005)(82310400004)(103116003)(8676002)(47076005)(70586007)(55016003)(508600001)(36860700001)(7126003)(81166007)(2906002)(4326008)(44832011)(26005)(1076003)(70206006)(83380400001)(6916009)(186003)(316002)(336012)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 19:19:58.8969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de915734-8b16-444a-9474-08d9b36d3c13
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[awfm-01.cornelisnetworks.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0101MB2906
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

The following BUG has just surfaced with our 5.16 testing:

[27140.581296] BUG: using smp_processor_id() in preemptible [00000000] code: mpicheck/1581081
[27140.590987] caller is sdma_select_user_engine+0x72/0x210 [hfi1]
[27140.597999] CPU: 0 PID: 1581081 Comm: mpicheck Tainted: G S                5.16.0-rc1+ #1
[27140.607454] Hardware name: Intel Corporation S2600WT2R/S2600WT2R, BIOS SE5C610.86B.01.01.0016.033120161139 03/31/2016
[27140.619628] Call Trace:
[27140.622682]  <TASK>
[27140.625350]  dump_stack_lvl+0x33/0x42
[27140.629760]  check_preemption_disabled+0xbf/0xe0
[27140.635222]  sdma_select_user_engine+0x72/0x210 [hfi1]
[27140.641299]  ? _raw_spin_unlock_irqrestore+0x1f/0x31
[27140.647140]  ? hfi1_mmu_rb_insert+0x6b/0x200 [hfi1]
[27140.652909]  hfi1_user_sdma_process_request+0xa02/0x1120 [hfi1]
[27140.659857]  ? hfi1_write_iter+0xb8/0x200 [hfi1]
[27140.665348]  hfi1_write_iter+0xb8/0x200 [hfi1]
[27140.670650]  do_iter_readv_writev+0x163/0x1c0
[27140.675827]  do_iter_write+0x80/0x1c0
[27140.680214]  vfs_writev+0x88/0x1a0
[27140.684315]  ? recalibrate_cpu_khz+0x10/0x10
[27140.689388]  ? ktime_get+0x3e/0xa0
[27140.693473]  ? __fget_files+0x66/0xa0
[27140.697853]  do_writev+0x65/0x100
[27140.701842]  do_syscall_64+0x3a/0x80

Fix this long standing bug by moving the smp_processor_id() to
after the rcu_read_lock().

The rcu_read_lock() implicitly disables preemption.

Cc: stable@vger.kernel.org
Fixes: 0cb2aa690c7e ("IB/hfi1: Add sysfs interface for affinity setup")
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/sdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 2b6c24b..f07d328 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -838,8 +838,8 @@ struct sdma_engine *sdma_select_user_engine(struct hfi1_devdata *dd,
 	if (current->nr_cpus_allowed != 1)
 		goto out;
 
-	cpu_id = smp_processor_id();
 	rcu_read_lock();
+	cpu_id = smp_processor_id();
 	rht_node = rhashtable_lookup(dd->sdma_rht, &cpu_id,
 				     sdma_rht_params);
 

