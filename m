Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2BB676329
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 03:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjAUCuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 21:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUCui (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 21:50:38 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7555C7B2F6
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 18:50:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iChl1sKM8mtavlxNfTNkgCy59NexcjsAFyN5iWVF1F8I8wSdsMYEpiQZWPD4168dO12hyagnMIYebfW7tgRA2vvP+ScUgS0t2c4yhRI4QXtgPaiXJh1rTMsOW2jmIRh1bUSjd3mCk7C8FDxi9UrTmrji6I+Gj32PZ1XRgiPNWbcy5E7ebJzUfLZT49dSQQ/6V8B1CNHOr/QzAN3tB5DZ9XkxhmqvbcUMlJSdbP8rOUh66GZvnSu5Yb/4IPS60NE8CVYYccfLTdDl+xynSpUph3zEa0pZvkZQ9KoP9hgIomB01dXC1FtWZ5gXa2mxheXzs4igZSf9Biy6lv9yHftK0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=omDbx4qqizVEh6+L1pEeX0GLWw6FEmp7+rFyOjgb3NQ=;
 b=Nf2+QIDD9wmq/HlrQZPtmxsO1ORJwWX/mz20+gb788sPDUWITxAVcXs0U5s42o2rZ4EGJVtFqYqSp/cI7L0HG/c1hy+sI+URKiUvHKJcq4elld0U33wGUqIviq47Gja6FFtVjPbT+ISkb20ll2ZPLvRhIvgK05P/HPD3ahh7YvPPTePMTkn7q4C+orzNuCF5RM6cDd6vSOIt/9hvffEJXH4haHhvlDrwuI1Rjee/Z1/KkWSq0xk+yU2nDJo5Ic/6VZLaBglgFRmKBbR+l6SItEqtPsELXQtlxQfSGjeJjNqrV3rO4pCz4pQ1OPNuMXzteSDPEdrLqZ95LnWr/nTl6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=omDbx4qqizVEh6+L1pEeX0GLWw6FEmp7+rFyOjgb3NQ=;
 b=NQj0km62jdzMYTvuNbvYu43kGPrxXsA/ywedUDcEsbQmUn1wOLCPU20/sUjSov7H3l2k0Cr9XC6Tghm2/DaibizbHO0PRsS8rxeWJFjv29b4Mjhd/eNnKdQLB0Z8WH+yNNFWZIw1zY72HLfLOarQm9XRVyKaM/BBvUaGmczjEO8=
Received: from BN9PR03CA0888.namprd03.prod.outlook.com (2603:10b6:408:13c::23)
 by DM6PR12MB4578.namprd12.prod.outlook.com (2603:10b6:5:2a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Sat, 21 Jan
 2023 02:50:36 +0000
Received: from BL02EPF00010209.namprd05.prod.outlook.com
 (2603:10b6:408:13c:cafe::45) by BN9PR03CA0888.outlook.office365.com
 (2603:10b6:408:13c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27 via Frontend
 Transport; Sat, 21 Jan 2023 02:50:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00010209.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Sat, 21 Jan 2023 02:50:35 +0000
Received: from ldev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 20 Jan
 2023 20:50:33 -0600
From:   Tim Huang <tim.huang@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>, <Alexander.Deucher@amd.com>,
        <Yifan1.zhang@amd.com>, <Xiaojian.Du@amd.com>, <li.ma@amd.com>,
        <mario.limonciello@amd.com>, Tim Huang <tim.huang@amd.com>
Subject: [PATCH v2] drm/amd/pm: drop unneeded dpm features disablement for SMU 13.0.4/11
Date:   Sat, 21 Jan 2023 10:49:55 +0800
Message-ID: <20230121024955.1601467-1-tim.huang@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010209:EE_|DM6PR12MB4578:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f5c26e9-d0e1-41c4-63ca-08dafb5a4579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YiIZi2coihnAmCCYp+SzXUk2g0j8t2NlkTYVs1LEbUC+iSjEblDGujQPjZRzmazI5QM8m2jO5oysBg7BBgSZzX89LDbj9L5MoI/9enBMm9e91Ya+j4w1pGPS9XfI+n2dZfDSXGN9SjlZzV2uMhAUXsIRC0Fe93mvhOovN2tQlKBx79WiCkHKVqNtH0p72YYtMYzcxJ6f+Y28zTdtz2IF8bUIrld7JWGkcM+gBm4Ni/eWNlPWx9Tly1hn+C1WgFcoQnde3C62GhS+Bo10dZBklC200h2iCRjCXzk65BT7coM+nv6EytGVKPYgr8UjGG8KF0HBqUUuxFU86tTX5rEn1hfkNo7EEhM/v1ZEG6hO2IvacE7FJB9ZZ0Ab++e0jdHmcf/tEP65YAii2cLgFqUimTjOlDtUP1yyt6xpmOdYm5muHW1F1/m19yaOf4RW69gcb+0MZUPwYgStARvYJlHJvMCLvQ7M8yqIjMhiWNEZsTyRFhdGek0tg9Nu8CdMhb1/BAjs6/8pGpVtKbwF6byRwvl+Y4yjP61Fupyv3E+h45bzqPlj0fsaE3C8wEwtYc9RQ8pkw+9IULcXRKDYWMpK3G+8OR0ywSb1MQEsn5Jqse/Oj6tw0Ch+In2XxHzv+DfO0Re20Wilv02Ef5EGtEOtNvagVjrljjYRuV6MaIYwcdz+lYbqoQVWv/6My/Nv4JV3QRcB6BeRJC0VnjHfwocYTpx5yJpNtG3LOjrVb91cUMA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(36860700001)(40460700003)(36756003)(478600001)(86362001)(7696005)(40480700001)(82310400005)(426003)(47076005)(356005)(336012)(82740400003)(81166007)(4326008)(26005)(2906002)(1076003)(41300700001)(6916009)(4744005)(2616005)(8676002)(16526019)(6666004)(186003)(44832011)(54906003)(70206006)(70586007)(5660300002)(8936002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2023 02:50:35.7090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f5c26e9-d0e1-41c4-63ca-08dafb5a4579
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4578
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PMFW will handle that properly for gpu reset case. Driver involvement
may cause some unexpected issues.

Signed-off-by: Tim Huang <tim.huang@amd.com>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index ec52830dde24..8bae3fe869cd 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1497,6 +1497,20 @@ static int smu_disable_dpms(struct smu_context *smu)
 		}
 	}
 
+	/*
+	 * For SMU 13.0.4/11, PMFW will handle the features disablement properly
+	 * for gpu reset case. Driver involvement is unnecessary.
+	 */
+	if (amdgpu_in_reset(adev)) {
+		switch (adev->ip_versions[MP1_HWIP][0]) {
+		case IP_VERSION(13, 0, 4):
+		case IP_VERSION(13, 0, 11):
+			return 0;
+		default:
+			break;
+		}
+	}
+
 	/*
 	 * For gpu reset, runpm and hibernation through BACO,
 	 * BACO feature has to be kept enabled.
-- 
2.25.1

