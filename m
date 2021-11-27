Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A385245F77F
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 01:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhK0AnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 19:43:01 -0500
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:46048
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343969AbhK0AlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 19:41:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bst7ZHvQqAQCTfK/9RxfBqdu+4VUQu+SIcrFLEVcg8qLz5VfydO77L7mpX0QM6Po8UO7qGakDHIzw3T3AePx21CyEt3fNOXJ2gNNQU8SLkAODus0SYY4lU/LsQu6JxcWdsDRiFBTSYjEXY6JxzGJLC0sIRkCxZPPGPDGUEilNXqM3QCDdmPrui5ERfMV5dgIFPeDyOnUMK8xuV3/JWkT0AJIOVBi5NFG/cfPQWeXiUWrK5sYPnNrmD6nTC3l5YWa+QpPLHX3S0Sifgmm0oF6mPDqJNHlgl7zL6DCn+o0MfYVffgoTl2dVSUpFPll23ZrD+Zg/E3WFc3eUgSYYIL1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrwHyrE1VR11Y4Lm/PTYOiTNK5sSmOlTS7QT6yJDsgQ=;
 b=Sh/zM7lKDhaRpN5zBNIQkyJhEaDVuYByoNRGcgVXXlzifUE0Mw6L+DT0wPWTWBgEU2mMPdlm9v03dfYRfANd8ySO/sgFM/MNxSEy92ThclSw5xl6POqFC2qZHRdHg/GY9aDdt1XlMScFOsSMWjJxWGNe0S/C0zxbOz2c3Fw+iDPQOS7cpMJvNivQQE3MYZCqYoq15GpLcNKpkM0/O+DoQoe74YUSEfBqTngzS9YAyIUoda3f1XhE3ct04O09WwrTr5Kcnpe630zfmRQSPjlEf5nqKm/TPCGUKocFK5Wqs7g7W9g7f0HfjdWZhMlJxCBFPnUZlIu3IYowORKZNBY+QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrwHyrE1VR11Y4Lm/PTYOiTNK5sSmOlTS7QT6yJDsgQ=;
 b=P189gr5wxT3RjrTia60C4p4E58uw6Z6E1gh9hGtjQ9fb6/IfpqDDFEUKxubJB/q5PWpjni6wxGzUOVu/sISSYpo5ccf5i12q0MdLQh4A0OIp5tUqYQITZw0JLXM+4pFObll66JY+FU0vW0Rv7+vD4zNjR7Joc597mrnwldh8J4k=
Received: from DM6PR03CA0010.namprd03.prod.outlook.com (2603:10b6:5:40::23) by
 BY5PR12MB4273.namprd12.prod.outlook.com (2603:10b6:a03:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sat, 27 Nov
 2021 00:37:43 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::a2) by DM6PR03CA0010.outlook.office365.com
 (2603:10b6:5:40::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Sat, 27 Nov 2021 00:37:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4734.22 via Frontend Transport; Sat, 27 Nov 2021 00:37:43 +0000
Received: from Philip-Dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 26 Nov
 2021 18:37:39 -0600
From:   Philip Yang <Philip.Yang@amd.com>
To:     <brahma_sw_dev@amd.com>
CC:     <felix.kuehling@amd.com>, <christian.koenig@amd.com>,
        Philip Yang <Philip.Yang@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 21.40 V2 1/5] drm/amdgpu: IH process reset count when restart
Date:   Fri, 26 Nov 2021 19:37:09 -0500
Message-ID: <20211127003713.19071-2-Philip.Yang@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211127003713.19071-1-Philip.Yang@amd.com>
References: <20211126172030.30143-1-Philip.Yang@amd.com>
 <20211127003713.19071-1-Philip.Yang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 164d4c86-16c9-42f8-52f8-08d9b13e2034
X-MS-TrafficTypeDiagnostic: BY5PR12MB4273:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4273AC60B6D24268C1745A33E6649@BY5PR12MB4273.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7tYbvl9j2yycq3X6exBmnM5uJRfKXB2BeBwRLCyBUoWbfCYAIrWuoC/7MRqy7eQg6YC71YQ3b3JeT3ZvYXcQDb1aolycmzgeLaMIL8/gRY23hvr9OjxPHdT3K2txeu3yhvXbqfbHmis0XIZ/kZxM2SQKrZkHbkHfAxZBYRd4X21qZEw36NgfVeWAfGzFjw9W42omDIV1ykbR1NW9Zk39dpD/4lHuhTBlCB6aO4LOFC9gfRlo/tSve/jbh7Op1b7hp9IwH2vMYBvSv0ijZDnt1Vsku2bXFjgRx6UxAhh+KLjoIHJYfyWKslS6BawvZXPWvu8xEG2FJEaJgXYdVu1XltrLpRpzUN92gcUIuvIhGO2Vp1WYgOwdkoSBbZi7lyiU9jsSv39/AaDwnk2L5er/MedvCfM/chyVe4Yi9PFAiKgIgi4gfHNDTuI2bnI5wu2/Hv/Z/gNlS4PhVjgT5Idnh25Fc2JJgZwGl5cCXvvMyjZa+E9D+ywEwqWrJS5wXEGdvq3ns/F1KY6xCk43NUtEB2Q5QMJY/40wKDcZSJo8sOOC/ijZldfc/18qpWasoAFuiOQDI85ljS38n6SWNCVDHXn+1Xq/k4byrSX4MazIHlwtrV4w3EA8CPiogccmt+T2cfSaDGXmSdvi7278sO1TUAYlGKnT1U6K4+W6QCpXgYCuh2W17NYKvfGzs56X0yGZKcq5jwLgf3ohp0VwudiVvlM1bwyR6oKAeCmMTdiGv2o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(83380400001)(2616005)(186003)(4326008)(8936002)(47076005)(86362001)(1076003)(26005)(508600001)(6862004)(66574015)(6636002)(36756003)(8676002)(5660300002)(82310400004)(6666004)(316002)(16526019)(37006003)(7696005)(356005)(2906002)(70206006)(54906003)(70586007)(36860700001)(336012)(426003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2021 00:37:43.4985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 164d4c86-16c9-42f8-52f8-08d9b13e2034
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4273
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

