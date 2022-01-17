Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66B3490C4C
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 17:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbiAQQNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 11:13:51 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:38133
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240982AbiAQQNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jan 2022 11:13:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxJ0CS7qLZTFRqJ/bnnz60zqx7wW/+duUeRPPTPHp8LkrUXyu4x1d+UJhR4ySZd5DptfxMzaV7edq/K9Kpg76LxZ3E3yCaJ6LOehQFvkqd6/CyWPH0HXEGzBDIst2L0sBHwAJ5TVfShIgFKafWtKd2NBsxTJNY3owsd7zI5M/2+LePt/EZ4nMX3WbF1uCTaPHcMH+J19Skj2x2N5hwrRsoT9Q54o2d3D7y+Wrw3McQWqAnaJpSGlAwQxe5gMJlyRxGDr5Pl53IzXnr9mwN694F3NvolkFe48W7xGLnwjw7lkZkJPpFzPx9vUFjGwysHI/RCdV4vcroPDvQtzGfJ9Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y0hHcSrf91d9XsKJTvLIaraSzs9fR8XtatDBgI37DHM=;
 b=J496ww7O9+bddqxBrvHGW6Z3SMURj53KEQx/KscVJThGXbTzM7qwoKclp+aHZ4rW6Rj2qMdjlwL7ylbw8cI/4EdT9WSZUMbPwCzkGOTFxvrh532co5r4w27dyzQg80GOIz31pg9ci2ZRGGSbvCpvizt5sXmOdu7T+pqmknfuqQMhKSQEzdE35WOLnYQwNSPpcRJxw2ezpVZnSyOzNdMwCTId4W4OOPZCoj3JDXx+I05s6EymvHWYKqmrLCb8n0T9OHnolkCYgQs5wASuaY5zGvNFtiKLRAnZx2hn7RIzqfsdGnss6o5CuPSCmoSeZr5U9qPBOGMlPwE7ZEhKWfg9gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y0hHcSrf91d9XsKJTvLIaraSzs9fR8XtatDBgI37DHM=;
 b=FN4S5dUtRv8NL0A58gZoWH7CgJTP97XS0cxAg9b97144l3ug/RzpjLJmd0WchmwQaJJzEZ+kVXMXLTDoD03m8RuhrdvaSNYq4BZVe7rRfN3TmeGdvTfmsD2cJ2Kg8/0m+NteFnar2fSEbFfAYhX/EcziODe95AXjXEVcAOj63R8=
Received: from MWHPR19CA0072.namprd19.prod.outlook.com (2603:10b6:300:94::34)
 by CH2PR12MB4085.namprd12.prod.outlook.com (2603:10b6:610:79::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Mon, 17 Jan
 2022 16:13:43 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:94:cafe::e7) by MWHPR19CA0072.outlook.office365.com
 (2603:10b6:300:94::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9 via Frontend
 Transport; Mon, 17 Jan 2022 16:13:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Mon, 17 Jan 2022 16:13:43 +0000
Received: from yaz-ethanolx.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 17 Jan
 2022 10:13:40 -0600
From:   Yazen Ghannam <yazen.ghannam@amd.com>
To:     <linux-edac@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <tony.luck@intel.com>,
        <x86@kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] x86/MCE/AMD: Allow thresholding interface updates after init
Date:   Mon, 17 Jan 2022 16:13:28 +0000
Message-ID: <20220117161328.19148-1-yazen.ghannam@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31fd4a94-1ae6-4bde-1968-08d9d9d45510
X-MS-TrafficTypeDiagnostic: CH2PR12MB4085:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4085744897EBB6CDCBEDBB42F8579@CH2PR12MB4085.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uknqe9NdKe+jvx6eLcso2JJYiOxkok8+mbKL5nc4uApCSpS0S8WwLHissvj3XZlWqmJjhlpg7oZ8MzhSN+EhatipSRcR4jICtGutHOAqyuNE4mBsrMWJmiaW/Mhf96K99rW3g1i/OpFg7vDXl6xIZZ1dPMOq/8VQQ/x27Rr2Sasx4gGHjSorosoMH+dmEnmhcsLFcpWZMGpHm1On1EvRT9tbZsTlgeFNaRyScJdh4BC1fR7Fdw8YBUcfDoPGYIJI2hkg6csVQIa1zKgewJ2cQKR/eHOtVeMz+ctcKUtbYBl5RwtW4+5oEA9/+09cZ5+6zmmnpmtbsv82rkR4SpF/k559Ggqqp7hUfWta7K1Po3taLTPGVyOmLzJp3XZmC1AMPDIzF/MWM+lLyBvP3LilTEF0Ht3MNBjWczHjUzS7z2FD5BJ58t61aRrCYAtJpRJ3+nIBuOR05BOTSU8Q4NvYslLdUmSoDBozfoc7+W5ToCAjop/BwC7sdBMr5OjLkiy+Jf5I+QXHwvRlalZf4OeYpmjsv0qXLGz+q9wkDGRKhi6k/m7meZbMFk/SN2y8VdnyZV7E+IBk8yjK5Z9pB9lkbS1l7GXTqAZ3/SiFV6MNQm9drP88sXRuXYULbrKhzI4CXKt0v2btBX75duw07+0wUKqGYADyjiV2V473Zz39rKmHACBNSiLWc6YM8Lz28yCiHjtWb/OZxBDAJERxCUTSWbb8IbDsEwVyX/kPACcXdDv35+7RdOcUis4LpdWS4CziSFln0dF2lzwqlWAOrV2ICe1qTNG8WqB+HhyTzSTNbf6wtqV/eC4MnpbwxKDstaVsKKlmvPLQi6ekkTjpkWDp5UfyKWFw7dIoufl3qjdwf0vLIWa68sJG+ruDTv9Sfghi
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(70206006)(8676002)(5660300002)(1076003)(4326008)(356005)(7696005)(36860700001)(40460700001)(81166007)(44832011)(36756003)(336012)(8936002)(966005)(26005)(2906002)(6666004)(86362001)(83380400001)(15650500001)(16526019)(186003)(6916009)(426003)(508600001)(316002)(70586007)(82310400004)(2616005)(47076005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2022 16:13:43.1485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31fd4a94-1ae6-4bde-1968-08d9d9d45510
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4085
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes to the AMD Thresholding sysfs code prevents sysfs writes from
updating the underlying registers once CPU init is completed, i.e.
"threshold_banks" is set.

Allow the registers to be updated if the thresholding interface is
already initialized or if in the init path. Use the "set_lvt_off" value
to indicate if running in the init path, since this value is only set
during init.

Fixes: a037f3ca0ea0 ("x86/mce/amd: Make threshold bank setting hotplug robust")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: <stable@vger.kernel.org>
---
Link:
https://lkml.kernel.org/r/20211207193028.9389-1-yazen.ghannam@amd.com

v1->v2:
* Add Cc: stable
* Switch logic for check and drop extra comment.

 arch/x86/kernel/cpu/mce/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index a1e2f41796dc..9f4b508886dd 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -423,7 +423,7 @@ static void threshold_restart_bank(void *_tr)
 	u32 hi, lo;
 
 	/* sysfs write might race against an offline operation */
-	if (this_cpu_read(threshold_banks))
+	if (!this_cpu_read(threshold_banks) && !tr->set_lvt_off)
 		return;
 
 	rdmsr(tr->b->address, lo, hi);
-- 
2.25.1

