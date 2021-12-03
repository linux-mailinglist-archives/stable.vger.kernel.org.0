Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA1A467C82
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 18:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353294AbhLCRbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 12:31:11 -0500
Received: from mail-mw2nam12on2080.outbound.protection.outlook.com ([40.107.244.80]:55136
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353282AbhLCRbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Dec 2021 12:31:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbV1GvPI7fQfNCDmyx1SV0t82nZA3/VWAyo/EZ4/1OWljU6SCwJCGEc5PrMw+3wd6p+xpfBcv/hlnkiEPBNxJjQ4XoJNJdqKZRsmPcKDtJrv1Z29Ts7a5f7rb16EdM1jPrzUHTnCNX1xd4bYMpYkgNX0AfC5+mk46se18F4U7K2sVAiXpa4slLsEvlVzG/q5CbAFHyEvCw69jjy3RH1yHgO02vweY4FNyLUJY72m4VekyzK5H97CeD4sYd9FREHzI2mjFzcjRdIIEbnidytvZuWjJsq5q1W0bPCHx6DS/txT9e7ty1Tzno7ttWmrNWd0/xMyXJjdA2PwHBQ3dN3A0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFulNL+gxKsn6QMU8HNS7jEB+amgVG7cdfIMT+xt4k8=;
 b=Rf7bNHDsxcIy1Dtciz6M35ok6NiI4QEgY/xHxr+qCznsHvNBTEj8ADoCkYpeP6UtdsrEqn1hpafrbueaMxR73T6hAYmjhaaYDW0Q2J15uVaUT9oHiFq6Q19mUEZZFeIKcZ1cuif3TVG7MWC9Dk57mKtVcb+jcyXv1PREAlYG11PZ6ZKDNsVkvo46kjwdNPJegU/CAhy6kz0VwZoIwl9LAoP24aKcQ2VmVbLn+YeTkXtbqgv1xFA1uQFcUfCRbzw2fd5/YxXllbczDieBlJu/CO4vMvLcIHe0QfYPpwaYnFV30o6s4AjI7Savob/dDRNCXuXmS486BU6TkTG6YRF8zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFulNL+gxKsn6QMU8HNS7jEB+amgVG7cdfIMT+xt4k8=;
 b=o1gyvuU1yCK01Ww4syEfIjRYkWwyuvJz64k6JHJ54Lo1ylGq63a/lvXcF1SmMi7uwC/ZjahQGMhXJQfJ3TH0Cd8B1qEVF8jB9mUlwgdEY6cp1VGQXNdReScrypKxbvPXj2y+H/U2PJ/84/19Gn2Fdyj61mJst0C/qj0m22J5R+o=
Received: from DM5PR11CA0004.namprd11.prod.outlook.com (2603:10b6:3:115::14)
 by BN9PR12MB5116.namprd12.prod.outlook.com (2603:10b6:408:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Fri, 3 Dec
 2021 17:27:45 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::d3) by DM5PR11CA0004.outlook.office365.com
 (2603:10b6:3:115::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Fri, 3 Dec 2021 17:27:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Fri, 3 Dec 2021 17:27:45 +0000
Received: from work_495456.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 3 Dec
 2021 11:27:42 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>, Yifan Zhang <yifan1.zhang@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4/5] drm/amdgpu: init iommu after amdkfd device init
Date:   Fri, 3 Dec 2021 12:27:31 -0500
Message-ID: <1638552452-4198-5-git-send-email-James.Zhu@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638552452-4198-1-git-send-email-James.Zhu@amd.com>
References: <1638552452-4198-1-git-send-email-James.Zhu@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ec22664-bb86-449b-3a3b-08d9b682383d
X-MS-TrafficTypeDiagnostic: BN9PR12MB5116:
X-Microsoft-Antispam-PRVS: <BN9PR12MB51166E7D7D761B7B495D1F98E46A9@BN9PR12MB5116.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:177;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SECU9STrx9ecqEyjEx2lo843xrZABVJ1Bt4ffxbCDnpAkB6hKjMKJVm5gBzOevTOaoF3KPfHkT3acIFMO8q4JMEo0OzR65w6hpOyf2l3UAg27EbQ4WsWJIfIGyrL7vv/X3mKfuchlXibC2/HsJyQ/CRby9NwL/8bQfbU8jFDBBwhfxhgWe7acYuDDhQUc5FVwOZyvXnuRZdpJEw9rTsj513hGIh+RcBbP05hP1dUjIsbo6kNAUD5JxwuzfH0X4MGLNyYyU8SWb3DqWjDT3e+QcRtS5jnWe0nOuZUX8DO5QGyhcS0IT2Ud/tmS3BigQFgRTud1EoVpqRBAZTuF9ozV9AK14f7yQeE6tFj3YNSttUhlTvmj0SlX0HonyZCYn0iCUKqNBRBRb8UUr1sKcv/qhu9c/S2aD3TElSACADs+h/+anYy8HXOvfxXDdJgQ1JKrCRIiIdWzw9CvSzTyMoTuBOjrjeGGoxT+f9q3wh4bDicjf5LALrTbL7mBbIxjweMx4C3XGExK5FeCZ65rlwu+LZu51a7QT9QR2fYGtyc1x2lp7c3dbEzIQRL7ZzGuXDXMIG2ICC6oJqeTWvG6J3uCt0ey7LzSWGYsLKyDMkzk93M0MRcCEuY/amgArfpiF5TxxVaXdhm2SK19j9phUMelGUpVumvpTWLpD67oGKSGguY/twcCM9TKPyWdXu5B9bm8gNx9Aq6pdFs32tCY8QZ5BAzn3X6GNft4rYncm2xhzdKr5k89OhpMD9h2aMIxB9a/5LQ1m/XBqL1XQUrZu8kkdHjDrXrhXRyHavwHxK+1YQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(8676002)(36756003)(54906003)(6666004)(82310400004)(336012)(316002)(36860700001)(86362001)(2906002)(2616005)(426003)(508600001)(70586007)(5660300002)(7696005)(83380400001)(6916009)(186003)(81166007)(16526019)(70206006)(356005)(40460700001)(47076005)(8936002)(26005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 17:27:45.4082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec22664-bb86-449b-3a3b-08d9b682383d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5116
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 714d9e4574d54596973ee3b0624ee4a16264d700 ]

This patch is to fix clinfo failure in Raven/Picasso:

Number of platforms: 1
  Platform Profile: FULL_PROFILE
  Platform Version: OpenCL 2.2 AMD-APP (3364.0)
  Platform Name: AMD Accelerated Parallel Processing
  Platform Vendor: Advanced Micro Devices, Inc.
  Platform Extensions: cl_khr_icd cl_amd_event_callback

  Platform Name: AMD Accelerated Parallel Processing Number of devices: 0

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Tested-by: James Zhu <James.Zhu@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 2947bde..488e574 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2220,10 +2220,6 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 	if (r)
 		goto init_failed;
 
-	r = amdgpu_amdkfd_resume_iommu(adev);
-	if (r)
-		goto init_failed;
-
 	r = amdgpu_device_ip_hw_init_phase1(adev);
 	if (r)
 		goto init_failed;
@@ -2259,6 +2255,10 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 		amdgpu_xgmi_add_device(adev);
 	amdgpu_amdkfd_device_init(adev);
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		goto init_failed;
+
 	amdgpu_fru_get_product_info(adev);
 
 init_failed:
-- 
2.7.4

