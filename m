Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4110348D12F
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 05:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbiAMEBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 23:01:24 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:59936
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232377AbiAMEBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jan 2022 23:01:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzk3QChIbFlBE9OE/PWON3BTwSUAya627hPUdpShQH6NjsdDIbM6AgLzHBHktQJRL5/jyV1QYNB02A47s2cbulWCe394HSF5+d47Tp69d1hRJWbbS7JicuFdgTosNnVi8VqCS7i+ieR+PheJSeCOrdhb6GQl0RlLFRR/gcdW51wkUXNFzpNKhSKAgWvvR51cVgBubbkx4PV565hTJa5Gfggg5RbLHdykdRlIVn7aYa/zXxVmnzo4jWUCAfwdZTL++apt4WYEQaCrujOBefX/oUcSijK5Yg5WpA/rwqCWPvNUSjISLKOVCClxSnLP9jfd3kTZNnZ2HVjcQOlg1zpa+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMo1TaOF23O/ek4fdG1GK7MtKYKAST3pek58TRTYCQw=;
 b=m1UnfqYxckip6RNMsSQ/2nlVBTNlpM8XWZgOf9c501vYye81Uz4Mc1wjeQbDMXFFC84Sc4wRL8/9/yCdOhcTQaUqqx6T3mgNE0XdeSAX2x8sq3BGuM+RRknw0BEGS1x1BXX/uCfxOgFtRbWZ3oPtzxasKJXL2xO5M4UfwhC81l2GK1mtyMEmLE5yITNSgCzfESoD9qqKRifFSjCmYsw/bv/A+88HzF955EqzWM8muQw+EBzJlqHniDtPzA2kchfbPkLb8+cXKtOVOFbMIudp3VmASYe2HVSZYe8eZmt4+8jQqnho6s7vzinVjRCJb5Bg1IF21nAhX1oD+UiXJSLV1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMo1TaOF23O/ek4fdG1GK7MtKYKAST3pek58TRTYCQw=;
 b=Yx+RCUxWtOZ4qOjIEDSQB0JDcBD9Ynq2Q6W643+aHoItKgQtQsV+KUTyzm5Be0MxXS1S3uQ1NS9HINn8CNPM/JOpWLeoqmcut2O4pFIWcTnTY8UiZ2qGcelwDDRV71qBdRDgQOPuu0l/joD/91n4aNVqp6DTEhKaAavROSTEZTw=
Received: from MWHPR17CA0070.namprd17.prod.outlook.com (2603:10b6:300:93::32)
 by CH2PR12MB4310.namprd12.prod.outlook.com (2603:10b6:610:a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 04:01:18 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::ef) by MWHPR17CA0070.outlook.office365.com
 (2603:10b6:300:93::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11 via Frontend
 Transport; Thu, 13 Jan 2022 04:01:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Thu, 13 Jan 2022 04:01:17 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 12 Jan
 2022 22:01:16 -0600
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     Alex Deucher <alexander.deucher@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH] drm/amdgpu: don't do resets on APUs which don't support it
Date:   Wed, 12 Jan 2022 23:01:03 -0500
Message-ID: <20220113040103.311160-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06248ea2-7fd8-47f8-3ff8-08d9d64959bb
X-MS-TrafficTypeDiagnostic: CH2PR12MB4310:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB431009731971656E83CFF387F7539@CH2PR12MB4310.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WFdd5k60abS7Q0cPMnx27iyIoyXlY/8LCKYarUvaO5dOvx5RoXSqN8IXnpQaWUCBEbPlE2Ek8M8Ltwpo4HW3UsFlbywV5e/z+hOmmOolAqKyJlZG1QngZ0pJCEga1pDJq+vB0suU8pmB4S1/3xiJFiQrzaTFTbWtKLgIVtOpzT6HacuzhTysm0eTxrBvKRbqWK1yMLAZ+PcejYxDJeeTf3qSbuTPZOaWykfrtZPSkxIpgsQIY+LEGgBZoXm4VIpHLxFGO0DjI5GqBHo1uTnV+FuciqW8qMdd4thChQAZb/cZmAJuNd/0Mv6b+35CukqmAOJX6O+DwHskpkbPuG6gG5oVBM15xf83rOjI9YKawgSbIpuid/bONPcPhQoWwo7CuiSpB6d/wxtOimpxHDf0Kqw//KubZAgJNnQ9dXTvlVo98/+zkcHhZiVFd0RjUvldAbtVpZ+X6VDWJp8IBsUVsl3dSpyiWihngwfFxkvzLRSPT/Hjd8QlNWbUplcW/lC9dNMV8qbllTGXsJvbsUftsGrvBj92++DAmoEcM2Qh79bV8eNcsNYQvOf2yo54ApF787nHebWf9NLaFfmeN8u2g0sKi4ZHJmsH1fB4TNg6TxOgLkfee7oJYta+YvjKR+4CcBTCu+cOYZ1Lu4guzK7EHj9E64GBOPD4Aqi3ZwV80kkIk3e5qRcGqZOXi4dmeUiaSjVaG84R8Vy6647A4SwhaGf8PgOjm2NRTQ1l0r6R24Wy47jVGs7sqIKzHXqsv2NnSqdawUR/yC3hZ6oN/TBcZNmIxqzgFaCvjXPUqChWVec=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(40460700001)(83380400001)(1076003)(7696005)(36756003)(16526019)(356005)(336012)(47076005)(4326008)(82310400004)(81166007)(70206006)(70586007)(508600001)(36860700001)(2906002)(54906003)(8936002)(966005)(6916009)(316002)(186003)(86362001)(26005)(426003)(2616005)(6666004)(5660300002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 04:01:17.4473
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06248ea2-7fd8-47f8-3ff8-08d9d64959bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4310
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It can cause a hang.  This is normally not enabled for GPU
hangs on these asics, but was recently enabled for handling
aborted suspends.  This causes hangs on some platforms
on suspend.

Fixes: daf8de0874ab5b ("drm/amdgpu: always reset the asic in suspend (v2)")
Cc: stable@vger.kernel.org
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1858
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/cik.c | 4 ++++
 drivers/gpu/drm/amd/amdgpu/vi.c  | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/cik.c b/drivers/gpu/drm/amd/amdgpu/cik.c
index 54f28c075f21..f10ce740a29c 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1428,6 +1428,10 @@ static int cik_asic_reset(struct amdgpu_device *adev)
 {
 	int r;
 
+	/* APUs don't have full asic reset */
+	if (adev->flags & AMD_IS_APU)
+		return 0;
+
 	if (cik_asic_reset_method(adev) == AMD_RESET_METHOD_BACO) {
 		dev_info(adev->dev, "BACO reset\n");
 		r = amdgpu_dpm_baco_reset(adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index fe9a7cc8d9eb..6645ebbd2696 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -956,6 +956,10 @@ static int vi_asic_reset(struct amdgpu_device *adev)
 {
 	int r;
 
+	/* APUs don't have full asic reset */
+	if (adev->flags & AMD_IS_APU)
+		return 0;
+
 	if (vi_asic_reset_method(adev) == AMD_RESET_METHOD_BACO) {
 		dev_info(adev->dev, "BACO reset\n");
 		r = amdgpu_dpm_baco_reset(adev);
-- 
2.34.1

