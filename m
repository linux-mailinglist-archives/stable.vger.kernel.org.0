Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14684467C83
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 18:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353282AbhLCRbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 12:31:12 -0500
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:21377
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245736AbhLCRbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Dec 2021 12:31:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ic61d+3Ze5uJVudOoI9emHS3oOHwoKjsG1Vmj0J5i8BIMTTwbRRGsYvHuajvW7W8vSSQQ135VB8n+eIXh8spGOz7YiVL/OlNmagv0/QKvWtyVRFmofXx2zbKlwevZMPCdlUO+ZSe17CMN3EyRS8YYkofxvTvHwkvZdh6HhpAB/+kmJlsao74o7wxkdQh0hjiFPyoif3K+b+y6z6uwABy1hKVBQ8fYEKl9/IvIOElfxG0uhT9oYfq06REMrU7j0S31kboBfNMEYcK7JRZl4DSNu4ZVsXOzvhUQ5XHLP3I+Usp/w/4WauebbIx5eUJKE5XSnxscYYuxD9TIfzj/M8XFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7Pk46FtnrzKtx6JRBSPqcEhdkXdQ45VqAymja9y/o0=;
 b=aj88nO5krkzizH9Bj5ALN4vP5espvyHcwW1nS8pfCT2ysfg4bdTt7ENXUmwe1YhR+XacaF1dc++mwDBODVu4d4Y8K7/DT3xR1f/+syC4Gzv/83HX9WsCMgruWckWOkuC7miDXwhIPyzThVHPywGJcOH9GV7En60N1vXysinXaiZKaTw55yrUoKapdGx8uXM4Z8KpP8u60FYOp7AmT/udOC+9wg54U763j3NGeQJKdscWCGsyHYQ7vNsw0dQb1NycK1veFaZ//QV4pxWte0/EpDiF2DG/cOVepKd1IAB3fdU43uSBy+WDa9aL0q0PJ1tNWkABgWuLDYKm/raj8xlD+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7Pk46FtnrzKtx6JRBSPqcEhdkXdQ45VqAymja9y/o0=;
 b=TBiAf3T8IdgCyGsRUzKb2PRFUxdO6jyT0y5TaX5v8V7fb76KY2xPK7M86iOTBBjQdoaRRCsmqaYIQARj2xgMwZHhVsdkcYY1qHK6pHAK7gc3UBU6V5KM/4zhUxN5ihWivnVofjxn+EBJuFpHbIkdkZNt2a0e7UaqsBl+0NQbUg8=
Received: from DM5PR11CA0021.namprd11.prod.outlook.com (2603:10b6:3:115::31)
 by CH2PR12MB4246.namprd12.prod.outlook.com (2603:10b6:610:a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Fri, 3 Dec
 2021 17:27:45 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::7b) by DM5PR11CA0021.outlook.office365.com
 (2603:10b6:3:115::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend
 Transport; Fri, 3 Dec 2021 17:27:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Fri, 3 Dec 2021 17:27:43 +0000
Received: from work_495456.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 3 Dec
 2021 11:27:41 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/5] drm/amdgpu: move iommu_resume before ip init/resume
Date:   Fri, 3 Dec 2021 12:27:30 -0500
Message-ID: <1638552452-4198-4-git-send-email-James.Zhu@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: eb3d4d96-c4af-4dda-9ea0-08d9b68236f6
X-MS-TrafficTypeDiagnostic: CH2PR12MB4246:
X-Microsoft-Antispam-PRVS: <CH2PR12MB42468B426746C08B9DFC5087E46A9@CH2PR12MB4246.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xI+kvUzKN3LgqdQZ/Zn2N6FypA2fvyAdRvFAnmfSICvBBCvTj8BuW/MnjuN07D0+O1WG0jq67FwIMlBuXlOm8AbDer8pNuHbc1Sr1hNlDnM6L0OhVuM7GIsCk9LYfZOFi7+nCV+e11HcbRdK5SDqryp/hBrT8JOKkvfIMKue++fl0UFauxgl+iigf+gD3oNFx5eoiO8MNPTsK09EF3EtCFeoeLfBuDqFtwzttMsy3eNxOFeugyJ12DbE+NTR00bfJxJ3b752LyC4uq1DYA3tTROmO7tlkAnGqRwgjDMBmskkzmTcBy1BXJevKYAVgMu8jVozNOiwKkYnM8WRpH4T4rK43dU5IpbdJeOEhHFfxxHxUFOsnJKSoYXjGJQx4Hid0UCleHw9J0uhok0yA98K2fbsKWgUYXd8X1hcZrMObBqdjeRAV3UxEc1y/Cnpuuun4zlZTCswsEBsdu1//gJFqMK+arbw/OjUAtplSP4WSSobcdBV1UvdKxxJNmc3NIwUc4oKnU53ZhqRp47voUeh3Exumc7Vw6mJAJywpfmEAzbvHFmJc2lVi9YfvLAjw5f2aXee3ci51WIH/v+4OKwd3ddEkSIacbM8HACnGuBTz53Jp9LzVeOneGbzhRdcPK7N8YchAh7Gd7DMQMgtmuOUWZKaL2hfEQJbbGt1ilqVQtJMkSE45wJe2xhGDAut5eJpZ4l/UeqembvAwcqg7QgcZ5x7Z9iElRr0hyadSlmDT5TbuH/Cwct3BmSn8ELHVJ1BctHFs4DCzG8sd92QdWNOay+HQ6Gvax5/6QUHRVOybd3svEVWiqcbSI2p/bRMaBCKhw9C1kh6cgP3V/ApKVfEIVOXnK/kbb0LwmTKpSzl6OHqv60Tl4zMe3CNh5naXdjH
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(47076005)(426003)(70206006)(356005)(336012)(2616005)(70586007)(81166007)(316002)(54906003)(8936002)(26005)(36860700001)(966005)(86362001)(16526019)(82310400004)(186003)(40460700001)(7696005)(5660300002)(36756003)(2906002)(4326008)(6666004)(6916009)(8676002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 17:27:43.2678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb3d4d96-c4af-4dda-9ea0-08d9b68236f6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4246
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
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 97723f2..2947bde 100644
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
2.7.4

