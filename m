Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC4B46F689
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhLIWNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:13:52 -0500
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:56161
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232422AbhLIWNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 17:13:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iymZLrCDAw/22laxHwnTnDetE8RwVQseTeq6tG9zujyWrvbgodLWW87vOmmwo49jaOwFGLygRbXRPlyX2QeDnNEDNrT+w9R4OL2SLG443mwB1tNIQq6U3Q3b+lPOIiBWDNNvcqUHGGGenvp1de/VhHM8a8ucIPqfz91B1BQxlctkUDlCH0zHadIWtosYjNMNtTpRen7+1SnJK5gJKOWuDcczZBK7dP9vTezjhGCqpHmo8+3vqNxPqyrBWO69uxiKNDymlBKl9jcZtGp0w9bivTTrREu1oVm1vtxbPZcs6OxbcJaKf5IjR5oqPOZwSxfZNKq1MAMsAdguZzIPo/2Gaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/fN6afqkmI8d/pRI3cR0sblrzgvCsHl+bmXWWQxfqnc=;
 b=SWH6cYGfYNHO3XodWBetgccJ3JyEap+EK9WpkPnjKptRhWdyfw0+K39WGal7PTicbkpWJwZYoVqwzNjMum2oyGY5/XSGQVjLae/hNfE/h5GvjGLSAKB7faMWC2sJIsKVCYMB+PLa26k0W2PiqsyErTmX/OvtMtbQ0FU7RTvDz9H+UGOvTpTYKhgdEHX2597gJSUrqfHFKx5bM2j5mNr1lS79H99vomDQTTKE3xc2z0bDgGraAC7ASCB9jVb0PZ1B1+hhTVao6FKlIxrLQx5WSro2Y3NnF5S4LZKiRMIGQm1FpOQpHf/C9x7gydY7nETvj+1DNRiK4B1SuZtr06TgjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fN6afqkmI8d/pRI3cR0sblrzgvCsHl+bmXWWQxfqnc=;
 b=JgHcSkxtDtHcdpUg8dYnmKtZ088xa8tYK2+D8BVDHPijHfGYifkbXrncDcxQSx++jUsr72Sj1yKDiY9HOwTqRADubk3jT4NsOxrbL1wEv9/irIgBEfv579eLpqG4RkbKLyLCZtiPijbojSHWzS6CdNBmOg7dnCdUStIlvhuIRgs=
Received: from DM5PR06CA0054.namprd06.prod.outlook.com (2603:10b6:3:37::16) by
 DM6PR12MB4387.namprd12.prod.outlook.com (2603:10b6:5:2ac::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.11; Thu, 9 Dec 2021 22:10:14 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::1d) by DM5PR06CA0054.outlook.office365.com
 (2603:10b6:3:37::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12 via Frontend
 Transport; Thu, 9 Dec 2021 22:10:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 22:10:14 +0000
Received: from jz-tester.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 9 Dec
 2021 16:10:13 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>, Felix Kuehling <Felix.Kuehling@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4/6] drm/amdgpu: move iommu_resume before ip init/resume
Date:   Thu, 9 Dec 2021 17:09:54 -0500
Message-ID: <20211209220956.3466442-5-James.Zhu@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209220956.3466442-1-James.Zhu@amd.com>
References: <20211209220956.3466442-1-James.Zhu@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8faf7e9-f319-47c8-829d-08d9bb60ad39
X-MS-TrafficTypeDiagnostic: DM6PR12MB4387:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB43879CFF5BD1AA6AAB7D8481E4709@DM6PR12MB4387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NZNgl1/x+liazRYW0CRFnRY3K5pnsSmQt3eiw41c/53E4dwx456DXK4yZBlmThOxgbB9h5vs/zSCDhdKsdGFJ2N0pHLysWAQdQEP6yFqeK2nReyXFSNVwnF/OJYDHeUGxAILC4WpzbN97qY5WgeYxeFjcct6zV/E/14hD7oB/rDbNymd81yG+TlDnYxJwbgENGYxLKxTTBp7nzgzUyCRpNGr2yYyZqJ11Alz8zvKxJA2AkT2bVfG7cxfCl1lCp1fs+2j+eV8H7nExfuY2/S94O3iwj9RzaNUcAOy+A/HIdx4kM0TEexqzIyMBd5XMs+pvKn2DHMmrSvwqFM85izZ2d6rhIV3dAkIEgEywnP8MHBM9FMoeXLm/XwLA47mYdF2SSD/7kQfrnYTJAMfEghBXNC+6DEnizOsiWtGGsD+hZwbxtTXoQbHKUHdzKA6Kozgs7VrWzIDcqjNyqgCkuV9vivztvvF8kQ80hQ3SIM+QfXe9/aDpYGNVnhEQI951G8slYSZGijW/lDCu9wAj+PY59RUP9QcYH94QCYfeEJFEKVypVSb4kJ37Pms/nQl4x2ww5CC4NDe2Hzem/XhHdetemuM/nabNPCyde255ggbOznqUHxYRHUkLQsXycze45nfG5foMaszln0t092OvuZrHUQSjKWXpiT17nFn7klC2uUaqWRG465G8/7pO/n2fkH31K72lIBP6nsxl0QaW4VFbWOiekn8W6RsvFnM8usR3Lt1S2y7g/rJyPeVKUe/8Z1WCQWu8hvvgnwahLdpe0UcCjWXwitSy4DfRyBrr56XXcCP8zsHCy9lbuftSaIJuTuQPbGqMYGtFS14GEn1t+793+RMcRS8016mLg3uHrH4DKE/+OHs8zjuEPZi30FVaXZl
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(316002)(16526019)(36756003)(7696005)(186003)(426003)(40460700001)(966005)(8936002)(5660300002)(26005)(356005)(2906002)(82310400004)(4326008)(8676002)(70206006)(54906003)(2616005)(70586007)(36860700001)(6666004)(47076005)(508600001)(81166007)(86362001)(6916009)(1076003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 22:10:14.6180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8faf7e9-f319-47c8-829d-08d9bb60ad39
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4387
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f02abeb0779700c308e661a412451b38962b8a0b upstream.

Separate iommu_resume from kfd_resume, and move it before
other amdgpu ip init/resume.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211277
Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: James Zhu <James.Zhu@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 97723f2b5ece..2947bded074a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2220,6 +2220,10 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 	if (r)
 		goto init_failed;
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		goto init_failed;
+
 	r = amdgpu_device_ip_hw_init_phase1(adev);
 	if (r)
 		goto init_failed;
@@ -2913,6 +2917,10 @@ static int amdgpu_device_ip_resume(struct amdgpu_device *adev)
 {
 	int r;
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		return r;
+
 	r = amdgpu_device_ip_resume_phase1(adev);
 	if (r)
 		return r;
@@ -4296,6 +4304,10 @@ static int amdgpu_do_asic_reset(struct amdgpu_hive_info *hive,
 
 			if (!r) {
 				dev_info(tmp_adev->dev, "GPU reset succeeded, trying to resume\n");
+				r = amdgpu_amdkfd_resume_iommu(tmp_adev);
+				if (r)
+					goto out;
+
 				r = amdgpu_device_ip_resume_phase1(tmp_adev);
 				if (r)
 					goto out;
-- 
2.25.1

