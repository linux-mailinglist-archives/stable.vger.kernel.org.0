Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0904F96C2
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 15:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbiDHNhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 09:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236298AbiDHNhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 09:37:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2093.outbound.protection.outlook.com [40.107.223.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AD52F2F01;
        Fri,  8 Apr 2022 06:35:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKWDlnsHYN4kDmVTSLa0VYpVIGDFQhx0wnp5D2ncg2k91Fc5Q36ymRenOMhyHmB79EsSj5f2SjLmaKJhOYyoDXbBbMj36o2jqDelmsECreNY5hUOPYda0n5G5cukML+hKNkMgse9eM1BoQifUBNfW9Of1t0+g7dh1R4rUQzWnInoGb8OLDq9wryOG09q+PrqhSmjhRFx+SWT4YTOkSTqUfHAYsERk0ssuJnpn0V1UvpbcJSQXulSZSmZMAJklidVZdvJFykcqSeyBzGkd/9CgWwX6EqjarppRqjOguT43rRara52uVm3BMlUdl+WvP9DRGAq+O+2Tmm9QihWCf9P6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klNnV1XAsBNVKfd0eAGL/7jL5aybKITsKgbMNKUM+Dg=;
 b=SQSFaN562TyJ9KCDzUTzdtFd0wzSqstaU31SWDMGoHD0e6r9/jciJIwztDYUA+KeqCPuQG03njNG//3ibfg2nx9MXKhAqHi4qDSX39NCq4ruoBOJ9KXAZDSVqGAGEL5tua29Z6AGxwGDVOrqKKI2wK+ZE2fFFQ2/zidtSX7NyCalth4djFOT8RFdZwXd1qoJjIkjuwsNc5u4RnL4AUjnHdKOB/k985LZqElSBaWpjNax2nbGHLJz0sh6ztbAd8Gg6hTWwXbRNgagJb5DNSNLKIyYeqjYMO1eOCAz+TtFvUTRVMkgAZbXJi51TUoYsrduKwNZHfj3RP3aaX/AZdGjyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=nvidia.com
 smtp.mailfrom=cornelisnetworks.com; dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klNnV1XAsBNVKfd0eAGL/7jL5aybKITsKgbMNKUM+Dg=;
 b=OOZeMZg27EBzUlCs77KBdRyed+6R7Jy1XKtpr0epsudZFjb0Rd1U2liHTbNg8SY/CEy4lvJztFhaxvc2qW5E+oMmMtib9M2bysAGOVv37ZS6d5oQauLSb1W9CUCnIR8Ky7Wb1htaTAH034e7nHlioGKJNX5e55x4MhS/cOxm+njhHtW4qpXSCdHyv+376UICh4v/cFSy4dUOJKr/jAslGerL07LXyPv6EqYDTiebz6iV6G+0KBibnK8vwfmRXbTcHzDY9YLMHWNeflITxDJZJab+PSFIlaB+NhbMkJQHdvg5miEnVeLM+9bXyHW/W9G/gSxS+bSmgzXKWLW6lZbh/A==
Received: from DM6PR14CA0046.namprd14.prod.outlook.com (2603:10b6:5:18f::23)
 by SN6PR01MB4221.prod.exchangelabs.com (2603:10b6:805:ae::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.21; Fri, 8 Apr 2022 13:35:24 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::cc) by DM6PR14CA0046.outlook.office365.com
 (2603:10b6:5:18f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22 via Frontend
 Transport; Fri, 8 Apr 2022 13:35:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=awfm-01.cornelisnetworks.com;
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.20 via Frontend Transport; Fri, 8 Apr 2022 13:35:24 +0000
Received: from awfm-01.cornelisnetworks.com (localhost [127.0.0.1])
        by awfm-01.cornelisnetworks.com (8.14.7/8.14.7) with ESMTP id 238DZNjH122187;
        Fri, 8 Apr 2022 09:35:23 -0400
Subject: [PATCH for-rc] RDMA/hfi1: Fix use-after-free bug for mm struct
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To:     jgg@nvidia.com
Cc:     linux-rdma@vger.kernel.org, leonro@nvidia.com,
        Douglas Miller <doug.miller@cornelisnetworks.com>,
        stable@vger.kernel.org
Date:   Fri, 08 Apr 2022 09:35:23 -0400
Message-ID: <20220408133523.122165.72975.stgit@awfm-01.cornelisnetworks.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d111028-2491-4044-2944-08da1964a2d0
X-MS-TrafficTypeDiagnostic: SN6PR01MB4221:EE_
X-Microsoft-Antispam-PRVS: <SN6PR01MB4221D40452D520FDC541B157F4E99@SN6PR01MB4221.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eZiBR/AKSABq0jjQ7guvjTuuBDzO+akzk37JbVocpZn5mDGB3zFmjdN0PBi1i4UP/0xVYPqKgIVgq6hmHCt9ZwXSCwC3Vau0d+KT5WeG+Cp5n72BLsfJWeb5816LZPWCQ+HUdiE+Ha7sN2GaWqjpQOZuZfo3zdwF3VjBtvuLca7cq7qKO0NxrPW0pMlDE4AqogEzevHWfm89TZ3bEpKqSRlW19HBJgaF0O/7fHFyAuW2j7vyRnUOSwycKFbIHzMDdeOoOpyW3g6C0cq7XRtSSSjkAEInmLZQyvMEJf/hjBF3Qg7JPxHyVHo+SyvkW/wYo8BjSm3p3jKgcVH6LP7j3ecrqIGwSkf7nLIWoTRymU9chGthSXbqx76p0GNzLyF4RjeG+mxOy7li6qOdPrW7QelFm8FLWBR0DD/5sLvac/Cg61D2jsUMUBhnDTdA0zOtCvX9sUzGB/y2o+KNXJjeOJrK9eM1Y293zMNd9Pq2iQIY4JXvJHpyfKRJrefhDz0grQ32fHhfpqKiQ1xLWnR7cHYh7lnIX79XH+wtP8Lj+xDyLMZYJEAOwvXcKjD7KaGGhX/O3GAy9vF8ioQ2tAbSXZWI22BJXe5n/n/2xIMDXOTnOJlvVrjrsGr63/MDGAdDOu/MBvrEcu3AM/7yCBUZybQnfo5BiEl2SiPI18tE2LGbTed1aV9UpS+i5RzP1fK+uVU6JF8l2N3YHLfvG4+Egw==
X-Forefront-Antispam-Report: CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:awfm-01.cornelisnetworks.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(39840400004)(346002)(136003)(376002)(396003)(46966006)(36840700001)(2906002)(40480700001)(55016003)(5660300002)(86362001)(6916009)(7696005)(8936002)(103116003)(82310400005)(508600001)(356005)(81166007)(44832011)(26005)(83380400001)(7126003)(1076003)(316002)(186003)(426003)(336012)(8676002)(70586007)(4326008)(70206006)(47076005)(36860700001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 13:35:24.4227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d111028-2491-4044-2944-08da1964a2d0
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[awfm-01.cornelisnetworks.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4221
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Miller <doug.miller@cornelisnetworks.com>

Under certain conditions, such as MPI_Abort, the hfi1 cleanup
code may represent the last reference held on the task mm.
hfi1_mmu_rb_unregister() then drops the last reference and the mm is
freed before the final use in hfi1_release_user_pages().  A new task
may allocate the mm structure while it is still being used, resulting in
problems. One manifestation is corruption of the mmap_sem counter leading
to a hang in down_write().  Another is corruption of an mm struct that
is in use by another task.

Fixes: 3d2a9d642512 ("IB/hfi1: Ensure correct mm is used at all times")
Cc: <stable@vger.kernel.org>
Signed-off-by: Douglas Miller <doug.miller@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 876cc78..7333646 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -80,6 +80,9 @@ void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler)
 	unsigned long flags;
 	struct list_head del_list;
 
+	/* Prevent freeing of mm until we are completely finished. */
+	mmgrab(handler->mn.mm);
+
 	/* Unregister first so we don't get any more notifications. */
 	mmu_notifier_unregister(&handler->mn, handler->mn.mm);
 
@@ -102,6 +105,9 @@ void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler)
 
 	do_remove(handler, &del_list);
 
+	/* Now the mm may be freed. */
+	mmdrop(handler->mn.mm);
+
 	kfree(handler);
 }
 

