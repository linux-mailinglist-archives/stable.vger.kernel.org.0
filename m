Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F965571ED
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 06:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbiFWEnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 00:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbiFWDPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 23:15:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D924D33342;
        Wed, 22 Jun 2022 20:15:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBSQXrdjwxmDKXNopgpCMefq8Jzge/2U+39xcLk/ZITL605jOQKaNTKiX42155hjbiVyUTjsm1fXIh1rYW+rx6vEwvtsHEx8NqVcWUkeY3DvJssZIoZ7Blbdfg5P0vnyeIHmsLaEcXrBbQLmaBwDZ4m7yB6bTJAvo/VEQDxtSyepuH3ZG7bEJqT9axyPP5ZSZs3PSNj50g50Nqj8hiBuxByxByC279WKTISzeGVkQgQqFr+o0bvfv4OGP6/JUNbCw/UuvUdAPJoCyCP2yUipA8tw/SgVnS0uL580rU8N2cJoKeO61/AjDRqEz9QBt782cqsA0qlcz5D7SFuSfiXOAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYXhx3PZAcdTmjtjLyNGcKvIk0zzb1HHVEsc7LUTT/0=;
 b=Av3N84FksF3dn2y81E5N7JmohmhpqaD4HKYn6AWi7q4xbVQtOX+eoCUKwziyF2TPB7TcK5x1uyZ6KM99Hkalnc6OvTJFAkJhNlt6lW4mMeYeHKf1KEsc5WHNeu7q+kMR2cV+9TE7amvAGxoH5JW0Ie8K4pMibPF7w7LebF7Ir2D7cMK/w0bOhqvjJkjHSXUe8qs1BoHnK+xknB1fgTe4Fj7ut1uPjxqpDrZX3HHrndy5Ok9y2DNZ7NlAATfTn7+cyLgvkuu9zLLVzDuOIseaqMjieWI1LleCOAtxyRRyj5EzowQAJAHpVeu4WyVbEJ55VNkw9GuNVsWuniBahaTXQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=rjwysocki.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYXhx3PZAcdTmjtjLyNGcKvIk0zzb1HHVEsc7LUTT/0=;
 b=fPdqD4dDg7RwJdeFYK/7l8anVfpWyZ53UYUKHc4zrHpkK1v9liP6h/kYLXulb4YacVLjRDKjwlKc7OTs6IZ78ntvn31WfizBr+Sy9wR0Audmmpyjzal9GdVcWtnNiSKD32PwZEgHgOyyRKZcsiJjYLCdqlbe41OXgdct12CbWBY=
Received: from BN8PR04CA0065.namprd04.prod.outlook.com (2603:10b6:408:d4::39)
 by CY4PR12MB1637.namprd12.prod.outlook.com (2603:10b6:910:d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 23 Jun
 2022 03:15:28 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::3c) by BN8PR04CA0065.outlook.office365.com
 (2603:10b6:408:d4::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Thu, 23 Jun 2022 03:15:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 03:15:27 +0000
Received: from jinzhosu-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 22 Jun 2022 22:15:22 -0500
From:   Jinzhou Su <Jinzhou.Su@amd.com>
To:     <rjw@rjwysocki.net>, <linux-pm@vger.kernel.org>
CC:     <ray.huang@amd.com>, <alexander.deucher@amd.com>,
        <xiaojian.du@amd.com>, <perry.yuan@amd.com>, <li.meng@amd.com>,
        <jinzhou.su@amd.com>, <richardqi.liang@amd.com>,
        <stable@vger.kernel.org>, Jinzhou Su <Jinzhou.Su@amd.com>
Subject: [PATCH] cpufreq: amd-pstate: Add resume and suspend callback for amd-pstate
Date:   Thu, 23 Jun 2022 11:15:09 +0800
Message-ID: <20220623031509.555269-1-Jinzhou.Su@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d24399c-1096-4382-a91e-08da54c69f40
X-MS-TrafficTypeDiagnostic: CY4PR12MB1637:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB163772C43F858573092AD40190B59@CY4PR12MB1637.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9LhwbZLPU2ulw4EbKCm90XuoLGqKMDXdGKV0C0FiPJ3NNXgVif9jfMuPcNmOb3pMkA6MUz69CpCgd2UsunvHnfVfVx5ZrcL1kiyUUwp+9OW46H2qTM252mNGCcDGo7wtbDd+0oFkot4qJwdjPgXS5MbEE5CLOKrBUmRAElOcuryeu4h4H+PDeBm9ngwre6EIgcjsIrlry9rqI182lgbsuCuKyjbkDBpC24YHE9kTH8DiUn7CfBp8kOHKq/xYeuujT0jPVG1ZJ+fVQH9FBrtl+rkukjbol5ZQuU6ZswNiAwC0plM4PfUSxSOc1jwDU7CfF13d6hPMQF6JCT/nTxdDJgnoqK+Vn16iFtyoFlCvCO0Yy8gScibWVZm+JlZ8wh34EGhe9h36O+OahDTU2Ftyn2G1sySUzpt2ea8i8f3YU8uQwCfzlb7d4gEsABD4wKHQh4cM+3tbynBMm4e7A1SFijHoIrlo2rpBNccWqsN7Fg9T0JLw8138sZNGQDzILhi5f235Jyk12sfI2hXSYJU0jAaHkBSnQcR5mCt+I7aX1tZOlxxXjRc/vOOHZE7gaXiZSgpFeemwPWFAlPLgGlt17KECA25Z7hsjYNKUlfL+mvc6caev8fV0vLmkAe/veuYBZJweMu9STFBk30Brc0761sHusxmAb5uHy6LB3IzCheMJrUC++qT4i6GhH/WApyjT/wuMuqn+Lm+tWU2gp0VHys6ujGGCipuVfqqT/U2bu1JuFPdfWJeoTuEIxcIchLu0a4qioeMyeonPKIRqNr/9bdny/SVL8AfQKu7k8Zwm68s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(46966006)(40470700004)(36840700001)(5660300002)(86362001)(478600001)(2906002)(15650500001)(26005)(1076003)(6666004)(8936002)(7696005)(110136005)(54906003)(316002)(36860700001)(40460700003)(356005)(82740400003)(8676002)(47076005)(83380400001)(36756003)(426003)(16526019)(4326008)(40480700001)(336012)(82310400005)(186003)(2616005)(70586007)(41300700001)(81166007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 03:15:27.7794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d24399c-1096-4382-a91e-08da54c69f40
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1637
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When system resumes from S3, the CPPC enable register will be
cleared and reset to 0. So sets this bit to enable CPPC
interface by writing 1 to this register.

Signed-off-by: Jinzhou Su <Jinzhou.Su@amd.com>
---
 drivers/cpufreq/amd-pstate.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 7be38bc6a673..9ac75c1cde9c 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -566,6 +566,28 @@ static int amd_pstate_cpu_exit(struct cpufreq_policy *policy)
 	return 0;
 }
 
+static int amd_pstate_cpu_resume(struct cpufreq_policy *policy)
+{
+	int ret;
+
+	ret = amd_pstate_enable(true);
+	if (ret)
+		pr_err("failed to enable amd-pstate during resume, return %d\n", ret);
+
+	return ret;
+}
+
+static int amd_pstate_cpu_suspend(struct cpufreq_policy *policy)
+{
+	int ret;
+
+	ret = amd_pstate_enable(false);
+	if (ret)
+		pr_err("failed to disable amd-pstate during suspend, return %d\n", ret);
+
+	return ret;
+}
+
 /* Sysfs attributes */
 
 /*
@@ -636,6 +658,8 @@ static struct cpufreq_driver amd_pstate_driver = {
 	.target		= amd_pstate_target,
 	.init		= amd_pstate_cpu_init,
 	.exit		= amd_pstate_cpu_exit,
+	.suspend	= amd_pstate_cpu_suspend,
+	.resume		= amd_pstate_cpu_resume,
 	.set_boost	= amd_pstate_set_boost,
 	.name		= "amd-pstate",
 	.attr           = amd_pstate_attr,
-- 
2.32.0

