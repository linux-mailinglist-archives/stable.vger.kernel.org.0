Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5571A6923DA
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 18:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjBJRAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 12:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbjBJRAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 12:00:24 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8016D109
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 09:00:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+EV+cvQThUxc2BdeKRqjcjz8H25WBmfs0Gamu20mgCenM/211gc8xCAQk2YvTph2J1ZcYw90Py99eqcmUpe6hPWCz77agPbLqoDuQMkXghrlhV983q4MidAuGotY1xJ8lYl7Bs7Sdo8w3vYqCi6294kkYLdQuUEXrGqwa3s1olpMaHl2DoBi9yblrczjyG/r35NsN/sMPLR6l9G5znYatLR4i1JQfVtUAQ++64p1fC33hFA2VG1iAmv/1vxpKxTYpcDfA/yIs/3kbzEZplyYv4pQ2iUg7beI4Mxqg2C1wkCmzj9Om8EwCDfzQJimCSXh8Duum/qH1ITg/hNLoHNFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRFKSOyo7U20EteksdXY7m7udTeYHsyEUY78CnUAj/I=;
 b=iCw/B69rNjkmr58LfRIaYIQsOri+ZOtl645VRMlPOeqG8L2i2lCrRRxqUaBgQ5/A9bHjCFQGRAU5wA/Wxjxv6LPiFVPU6JS2Gj8K6JB3PqgNzfVFQe/cyZDD1+bHgHdKMB3QDWQRtr/RR5+PGRFu87+7S2ogg8wR9bdnjvgJSmYkaqWHsiNP3mx3CmvSJQdL5kB/0kbDBRocbdLi48V/ofsEDsTPTE62cjUSl87NYcwB98h9GIiiPeR7Cn2/UYXVa4iiV+5knIIe0x1vlUhDBitF9la+V70jIFSI5BblgHbaZNfKq27ZdHlkCmRUWQmYSI1OCMFX3WLcd3sksJx+7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRFKSOyo7U20EteksdXY7m7udTeYHsyEUY78CnUAj/I=;
 b=Pz50g05YvYIamoVpdU7wrhV3pmtpzOEi1781sQsPqZvZ4f9+zYL35lTH0Nh5zBIkb2/vCirgKFLYEC2xxgk5CvYAf5gyQtxHzMVo9lszFPy1oL9f44EBH3iuM23x9vOlUHzN8HaHG9+FzEVoSIMlKlzChUO392qEQNQ5ncqMje0=
Received: from CY8PR02CA0010.namprd02.prod.outlook.com (2603:10b6:930:4d::13)
 by CY5PR12MB6180.namprd12.prod.outlook.com (2603:10b6:930:23::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 17:00:20 +0000
Received: from CY4PEPF0000C96D.namprd02.prod.outlook.com
 (2603:10b6:930:4d:cafe::d) by CY8PR02CA0010.outlook.office365.com
 (2603:10b6:930:4d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Fri, 10 Feb 2023 17:00:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96D.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.21 via Frontend Transport; Fri, 10 Feb 2023 17:00:19 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 11:00:17 -0600
From:   Pavan Kumar Paluri <papaluri@amd.com>
To:     <bp@alien8.de>
CC:     <tglx@linutronix.de>, <papaluri@amd.com>, <mingo@redhat.com>,
        <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
        <brijesh.singh@amd.com>, <michael.roth@amd.com>,
        <thomas.lendacky@amd.com>, <venu.busireddy@oracle.com>,
        <Jason@zx2c4.com>, <x86@kernel.org>,
        "Nikunj Dadhania" <nikunj.dadhania@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] x86/sev: Adjust the alignment of vaddr_end
Date:   Fri, 10 Feb 2023 10:58:54 -0600
Message-ID: <20230210165854.12146-1-papaluri@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96D:EE_|CY5PR12MB6180:EE_
X-MS-Office365-Filtering-Correlation-Id: 77f2c119-e03c-4e93-c7bd-08db0b884ab6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +TMEG/A8iNrjPN8NSVng2mZ1eCI2nv1JSVA1VKPfFrAWdAbL2dK5N//FEVHC/br7YWXIppdBNLx1Blq9cXA8mO9AGPB6CEnz/df2cE82Z/jxj6TYHo6jydEnvjCwzoatxhEm6ttftBOWxNjVXCfWQHUfQC6v9rWX+vweybZNAt8DoBDT1lfr/hGHj/igoyAEbte65RuJfy/nhHgN2fdmO73ULdgHa4LVD9d+ETd3wdhbBviaXJB/e4IHDIoxLtbA8RvfwNogWf9Kz8UApHRA0Ib5lTrWyL2zBosjXIXM1tk9eNqFuv6BEecrTg4/xPs2GtRqzh3g/Hqgfl68VyrQYsXikpiLdlwWyO159TZCkkU6VEqt9rhnfpDApFTaSfXIZD5XT999UQ9AOh0gJGj8c+1XR8vQqpL/njTj4LrGKzTgIsHDUivirjgheCh9JYZWuUqq52Szs9xX+pV0XAw0RDpBI8ZLX3v+vJL1dFNlvCKIrR3oVC/gnsFn/DGl6D3sOgwmIgkG/ziswoWvCV4qQqauphOEle77AxfAfVirHhxMpIheQTVOkYzf+5KotRT0dqlBRPXlBDtHZOp+7JZQwso08pjJ1maeMoUNvWwdewibbtxJXS0TSUgBz0AMsRk6bfrc2lFm5hRj3mkRR8+BVUCQKCLFhtVxLL70YbOsM2H9ULLABtBTxqbGRrMpTvdEzR9TLQ40V472bJg4BvesAG/SMXKoZ39wO4NB9+S8mCc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199018)(36840700001)(46966006)(40470700004)(82310400005)(8676002)(186003)(1076003)(8936002)(70586007)(70206006)(6916009)(4326008)(36756003)(82740400003)(81166007)(356005)(16526019)(2616005)(426003)(47076005)(336012)(40460700003)(2906002)(316002)(7696005)(54906003)(41300700001)(5660300002)(6666004)(40480700001)(478600001)(26005)(36860700001)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 17:00:19.8914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f2c119-e03c-4e93-c7bd-08db0b884ab6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6180
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As vaddr is aligned down, vaddr_end accordingly needs to be aligned.
Otherwise, vaddr_end would be one page short. While at it, compute vaddr
and vaddr_end using kernel defined headers.

Fixes: dc3f3d2474b8 ("x86/mm: Validate memory when changing the C-bit")
Fixes: 5e5ccff60a29 ("x86/sev: Add helper for validating pages in early enc attribute changes")
Suggested-by: Nikunj Dadhania <nikunj.dadhania@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 arch/x86/kernel/sev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 679026a640ef..0f261cb306c3 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -648,8 +648,8 @@ static void pvalidate_pages(unsigned long vaddr, unsigned int npages, bool valid
 	unsigned long vaddr_end;
 	int rc;
 
-	vaddr = vaddr & PAGE_MASK;
-	vaddr_end = vaddr + (npages << PAGE_SHIFT);
+	vaddr_end = PAGE_ALIGN(vaddr + (npages << PAGE_SHIFT));
+	vaddr = PAGE_ALIGN_DOWN(vaddr);
 
 	while (vaddr < vaddr_end) {
 		rc = pvalidate(vaddr, RMP_PG_SIZE_4K, validate);
@@ -886,8 +886,8 @@ static void set_pages_state(unsigned long vaddr, unsigned int npages, int op)
 	if (!desc)
 		panic("SNP: failed to allocate memory for PSC descriptor\n");
 
-	vaddr = vaddr & PAGE_MASK;
-	vaddr_end = vaddr + (npages << PAGE_SHIFT);
+	vaddr_end = PAGE_ALIGN(vaddr + (npages << PAGE_SHIFT));
+	vaddr = PAGE_ALIGN_DOWN(vaddr);
 
 	while (vaddr < vaddr_end) {
 		/* Calculate the last vaddr that fits in one struct snp_psc_desc. */
-- 
2.25.1

