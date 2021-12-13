Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB29A472E99
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhLMOLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:11:49 -0500
Received: from mail-mw2nam10on2100.outbound.protection.outlook.com ([40.107.94.100]:52609
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232329AbhLMOLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 09:11:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8ywoa082OcyvadQBL4tO1x9ClX84E14tavMSAu6oOxO4zkVsFR8FdKz4bFSERHdCfSI+MMhgyhhfDNtZcd45bLAvxDWn3AprvJ6XhY7l/etmDPbf2M+qAB1lSYxRctzr2O4UNW7Oz4rBA1kfpCzq8j0DJbl1wp8Tlu17uz7EoDzUxuKavV3Bn4cHWd/SK0l4fAUWzV5yi6lmYJGqJNKa1WvecTqRuNQz2xuxyYi+6zgpVLLzsPxKNV1eyQ7DYugVouc3m1DpWtV7EwFc777qX9G7H9GPvxE2WM3NVq6D1+uCJVYqkK0K7sCHS4u2p/qxieAU/JG5p3CwbI2AMB1Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xS5BM2VceaZEufruPbkoBD705S0jxPOUEwsgj5Yt+HE=;
 b=NNeohxOPRMbw0J7Hx5MIq9o6hZcs+izTi0ksXia+xr2tS76K69vgTncVnz02YcItEGYGQCXHmBxfDXCYFNI5XNX5DzGLsnRFhdPjuCZg4Scm75MQ4upSRU7+N0sKLjCctx3hHdQ/38+1Gu46lsj6QOKV1z9sXCTbN9Eiqmf946hpkWUuuo9CPx+ZBdhfhCr5VKS86RyUK/qAVOAHUDjy4LodI/ol5FqTLCYcrv3ZQv+deVvA+IFCabbozIVE/gKcHEIXPXKDEpLMrAI+v3nj0BbF/Ohl05gAJkJE4jCXTNZs2OQyuW79/PgOX64ObTBuCmrETsN01pm/sB9I32YwXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xS5BM2VceaZEufruPbkoBD705S0jxPOUEwsgj5Yt+HE=;
 b=N7Sh/4h+8RD7HkqaF1KCzHNF9GfsW17h66m+yzZZRu2xBHbs8AddkH+co7Ut7SoXt88gFAsbB6bfgxsYXtFTCFJS0qrl10QbiAcRPtxkNnbTxtiXhf6LbSIIPXdPIsNlHI6MDshi5n6ssIB9PVpXEEt09iZ4oB3p/QQVlJXShIREGneDi4ggQc0abIRax+K5vDmSGVwbzinNT/SjN37tT8o5GCtq8VqvY21nCQqw7bzv/GV0ZEJn/+AE09qCBdM1OGarg9nfpwh7NkoM+cUUTKYSSsuBVqYgBwHVQDfJ7UZR0DhAU0r5gkJHeEZby5UXVIGU2uHUAU2hiB4FB89VqQ==
Received: from MW4PR04CA0169.namprd04.prod.outlook.com (2603:10b6:303:85::24)
 by BYAPR01MB4278.prod.exchangelabs.com (2603:10b6:a03:11::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Mon, 13 Dec 2021 14:11:39 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::18) by MW4PR04CA0169.outlook.office365.com
 (2603:10b6:303:85::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17 via Frontend
 Transport; Mon, 13 Dec 2021 14:11:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=awfm-01.cornelisnetworks.com;
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 14:11:38 +0000
Received: from awfm-01.cornelisnetworks.com (localhost [127.0.0.1])
        by awfm-01.cornelisnetworks.com (8.14.7/8.14.7) with ESMTP id 1BDEBJWZ178024;
        Mon, 13 Dec 2021 09:11:27 -0500
Subject: [PATCH for-rc] IB/hfi1: Insure preempt is held across
 smp_processor_id
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To:     jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Date:   Mon, 13 Dec 2021 09:11:19 -0500
Message-ID: <20211213141119.177982.15684.stgit@awfm-01.cornelisnetworks.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a0991d3-d9a0-43f5-c02b-08d9be427ad8
X-MS-TrafficTypeDiagnostic: BYAPR01MB4278:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB4278535BD98F95675DDA48A2F4749@BYAPR01MB4278.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j1fNCSpCpG+Ac46ka7plcFWPkbUioC7TLjSnK08q2g5sKgFXbuHDNEUeL8b9EMkKlpYvPpN28IJBQGRFJ2bsdsGuA0dkhJEhOiaRFHzc7vYKQtmgCPi36dZD+3zI2Fp9lyehN15d6m6UVYHA9vpP2jQSnbxEIUY1v4fgktZtaNMjV37wikWC5k51p1EhjvGeDQziquPKoSUN4j2chYrg4FqQ3xm2dslvU0tO+jFXvrKkxCXnDiziG0T3u1RzRLgKnppISn6LBQlvRNu9dOe0l3qEI1AST9192Anb9GX8ThmP1PToMJLxjcVGtxNa8DoVRaG/6txp/LcbhRf/acgZirnHo6o5LOmVZAiC6eWmHMGwJ5goDFeqI5XD5ORtug4NvhFVSJuSo5c/IK+BKhwXS5vG795Z8tb0V7VHDugVUCFiTnTFZXEyvcBeZyHu9VZctYgB4YtK80VTCignkXyOGzNG0y0BTULCyxN8hKh0VmLdJc7uwHdwMqaX/HAtV9vaFyBSE6JBGSJhQ2rNe85FIeXTpA+hSm6C5SKA8/TXTrav+1/RVTkSPZr/3r3glqlfWQdtuVdm6zQuf8UJcSPIx7omfWUl4IeabKoDTJTcij6v89zP6nScKDkBOk60X0k7HiqF3aa18I0OWx5GvHQcOwMtHhF6VAEL9N3UqJoWZpc6yZ4iEzEufm9VJywvLInQnqwJyldWJucmqktyZx0waqAgRhCLvYkHNXUhfW3ITbfJ/+hx7BJAURhm80QnFXmJclAPL0UEPYGwUKHyvP5JQhC0Rq3OJ09vhyiCqqT952xuRLeHp7vd3H9e2IsuvWXZLrw6c3gSJePefq4qiyoEfCtBRppGvTd25B/Do/73ZPk=
X-Forefront-Antispam-Report: CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:awfm-01.cornelisnetworks.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39830400003)(346002)(36840700001)(46966006)(7126003)(40480700001)(6916009)(2906002)(82310400004)(356005)(8676002)(103116003)(47076005)(83380400001)(316002)(55016003)(426003)(86362001)(8936002)(336012)(44832011)(966005)(5660300002)(186003)(4326008)(6666004)(81166007)(508600001)(36860700001)(7696005)(26005)(1076003)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:11:38.6217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0991d3-d9a0-43f5-c02b-08d9be427ad8
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[awfm-01.cornelisnetworks.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4278
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

Despite the patch noted below, the warning still happens with
certain kernel configs.

It appears that either check_preemption_disabled() is inconsistent with
with debug_rcu_read_lock() or the patch incorrectly assumes that an RCU
critical section will prevent the current cpu from changing.

A clarification has been solicited via:
https://lore.kernel.org/linux-rdma/CH0PR01MB71536FB1BD5ECF16E65CB3BFF26F9@CH0PR01MB7153.prod.exchangelabs.com/T/#u

This patch will silence the warning for now by using get_cpu()/put_cpu().

Fixes: b6d57e24ce6c ("IB/hfi1: Insure use of smp_processor_id() is preempt disabled")
Cc: stable@vger.kernel.org
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/sdma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index f07d328..809096d 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -839,15 +839,15 @@ struct sdma_engine *sdma_select_user_engine(struct hfi1_devdata *dd,
 		goto out;
 
 	rcu_read_lock();
-	cpu_id = smp_processor_id();
+	cpu_id = get_cpu();
 	rht_node = rhashtable_lookup(dd->sdma_rht, &cpu_id,
 				     sdma_rht_params);
-
 	if (rht_node && rht_node->map[vl]) {
 		struct sdma_rht_map_elem *map = rht_node->map[vl];
 
 		sde = map->sde[selector & map->mask];
 	}
+	put_cpu();
 	rcu_read_unlock();
 
 	if (sde)

