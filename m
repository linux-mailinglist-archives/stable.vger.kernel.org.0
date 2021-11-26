Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B50645F2D0
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 18:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhKZR0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 12:26:05 -0500
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:49185
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229528AbhKZRYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 12:24:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhEo0q2IJLZt+MfKQGCQIq/8eWaGJjX4VJuHYkcUiHIkuVIwy8crdj2M2A8JJl/Pk15QTjVC6Qygi2vpkLjCVuXAU9X6LVvvKH4BzNloCWiBuIHbaUbgmUOcJiI/RpNgfdOrxqGYiJiJHuNGFMv/CnmggKwE4xyh3V6Wl3UeH2/kwomakRYEUGctwsNWHdNh+n6959lZ8D491NWQ8iahDBIK70tYurX5mOFlTd78PRzDxxG13NtQTwLuDp9hhIdegit3cD8CYdCEFh602e9v0hdkI1K9S2Nx/5FFk/+FmXtj8JulE2JB1LWQqSOWDucb6K2SXvWK5l8IkfILcElrHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrwHyrE1VR11Y4Lm/PTYOiTNK5sSmOlTS7QT6yJDsgQ=;
 b=jPnCT5S56NTiyoj6jQfSzh74FJ1nc08hlTiN8Ew0NopPpFpYvJSp5Mvz5A5XqKrD/8zE1S+EkIZk+ZyWnegAyNL/ZKOSXPbgC1IZ137Blmw6YnznB015YDYwMV8g/0nrHN8LPllw9XvyjZSl3vFNanSND/t2GlTm7c/rD/DcRjAA0lEqd32ser1I0Hk+P+rtshQV6wjQutx/jix6q3BMEdCgbkNlRxukNEtBHHZyhbSEdUziLi/kFBMTwKSB/Dcb/BjE27/oP+w6i4nu1kqS3QynHF20leGCEmBS/7MfFE6eol8IvLgDsQqbrV1fE9JAWznJX4ccl1hgd9cifgI2Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrwHyrE1VR11Y4Lm/PTYOiTNK5sSmOlTS7QT6yJDsgQ=;
 b=kx4pC3ttSDqR5VWneb9hAAWNCF0W/FfEKMelEmAr31Gkx1FbBzwOlCodKylzDTBAwwgp7IVY84D2hfFDu6sPxOcj7kyxW4/2ewC8yT/YSgOV8Exr8fWTQl02f9MbixGPteCikQ1Lc9utr3zXSsuOgTDpdInfc/fbY6zKrW8lchc=
Received: from BN0PR04CA0025.namprd04.prod.outlook.com (2603:10b6:408:ee::30)
 by DM5PR1201MB2554.namprd12.prod.outlook.com (2603:10b6:3:ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 26 Nov
 2021 17:20:50 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::c5) by BN0PR04CA0025.outlook.office365.com
 (2603:10b6:408:ee::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend
 Transport; Fri, 26 Nov 2021 17:20:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4734.22 via Frontend Transport; Fri, 26 Nov 2021 17:20:50 +0000
Received: from Philip-Dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 26 Nov
 2021 11:20:45 -0600
From:   Philip Yang <Philip.Yang@amd.com>
To:     <brahma_sw_dev@amd.com>
CC:     <felix.kuehling@amd.com>, <christian.koenig@amd.com>,
        Philip Yang <Philip.Yang@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 21.40 1/7] drm/amdgpu: IH process reset count when restart
Date:   Fri, 26 Nov 2021 12:20:24 -0500
Message-ID: <20211126172030.30143-2-Philip.Yang@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211126172030.30143-1-Philip.Yang@amd.com>
References: <20211126172030.30143-1-Philip.Yang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7416f9b-6631-4fc1-351d-08d9b10117e7
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2554:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB25548B0CFFE94D2A918DAF94E6639@DM5PR1201MB2554.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ylTyMz29XQ9ABFJAq8JeSPkHYOygBAlp/kzOeMidfG8/e6jWr7Fw9An7/+Aikl1pVp1zeOs1xcFBhleK4X7RUFtlGP2fFfgRM1jvA0pBy2BIlZq464DFCp9VXdhiBFH6YP5G12JeEmHGQkgwB3Yix9YztsxmknnJzcQ2XT7yVOqKRYeus9f3pc2uCZW2gJzT/tLYE/fNRal9USTZMGwf7k40gSVZb9slZa57F7gzHQGqmk5l8+Hickfcw3WhpQZ5muOVi9V8QcaxUHWpJ2eKerQpB/XiuXaVf4FV/I2tbJSWjAY+yKBy+10ZOj0Sa5/61wTWQZVrVYQJWMTrT73Sj65N+1k7KkuP/FmsCItFtiJVWNCMVLsyygcaEbVs1dVu3Cl7st6vGeXHDUWhTMzpNOQs7ABSUVddeHfija3Iwygux9/GSrcShXiUn6J34eGzjQqsHSFjZc9O9GdQfuF/VW9KdxiShEk1ud2NraDf45X+qn5ZoWWcYmJi5KzTx59cLOsGNUsyqURgPdVDTN6V+6daGZHu18uxGFNfNDLLLB+l86itU7xzbXqFghREEQwMhUZP/AzHHY5I/J/5BJbHp5lu8jvfP8wTbtZTTRgzQzENNgwN5EfmoGSAyFFcWRFqLGNdRqgVXbDaGf4OFfFqmsmjnYuAmV/IxEuLFJaI11EvDs5mLUjFWim19sVV/UofGyxx+2545nnCFECdQbvFw3lKTB+7Xxjt/dXzoeSZqUs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(47076005)(36756003)(6666004)(26005)(336012)(8676002)(2616005)(7696005)(1076003)(186003)(16526019)(5660300002)(66574015)(426003)(6862004)(4326008)(70206006)(83380400001)(2906002)(70586007)(8936002)(356005)(82310400004)(86362001)(37006003)(81166007)(54906003)(508600001)(316002)(6636002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 17:20:50.3318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7416f9b-6631-4fc1-351d-08d9b10117e7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2554
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Otherwise when IH process restart, count is zero, the loop will
not exit to wake_up_all after processing AMDGPU_IH_MAX_NUM_IVS
interrupts.

Cc: stable@vger.kernel.org
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ih.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ih.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ih.c
index a36e191cf086..6a3ee80a6d62 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ih.c
@@ -221,7 +221,7 @@ int amdgpu_ih_wait_on_checkpoint_process(struct amdgpu_device *adev,
  */
 int amdgpu_ih_process(struct amdgpu_device *adev, struct amdgpu_ih_ring *ih)
 {
-	unsigned int count = AMDGPU_IH_MAX_NUM_IVS;
+	unsigned int count;
 	u32 wptr;
 
 	if (!ih->enabled || adev->shutdown)
@@ -230,6 +230,7 @@ int amdgpu_ih_process(struct amdgpu_device *adev, struct amdgpu_ih_ring *ih)
 	wptr = amdgpu_ih_get_wptr(adev, ih);
 
 restart_ih:
+	count  = AMDGPU_IH_MAX_NUM_IVS;
 	DRM_DEBUG("%s: rptr %d, wptr %d\n", __func__, ih->rptr, wptr);
 
 	/* Order reading of wptr vs. reading of IH ring data */
-- 
2.17.1

