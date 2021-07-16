Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5183CB348
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhGPHjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:39:03 -0400
Received: from mail-bn1nam07on2075.outbound.protection.outlook.com ([40.107.212.75]:33875
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231454AbhGPHjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:39:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XAxvFqr9KuzIxd99oZJAhXgfwIEghbxMSBC3qHM/BVyBEEA68kAGwhrkKbR3oT0eBY5zFdXv4mYTCNhhUKCUCDm8P8gs9H8izKXQQG2Ic80fG0koxlTGAbHZQzQOzONaZR/wWTcilk+/UZeKmBm5Rw1ZC/fmwLRNju/+Irsh+HgJ3fqqMP3sTgyk/Z8H9O/cndUGtTzG03grtqPh2ZOV9uLD6OfpLqK+9r0PyeoLnMULnRlEGxUqqKBuyvKaXQuzCEnSuXA9LQbTv3/lbnClkDjg8o5nYFRGhI6Poc6WkrMslKFHvXjciSjyExNDSesSEXl4puAr0ghwkYjK+QQiyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96XRQWmz+1j2wR+7fLFYuz26279RQuFgSMmgQKjpA6M=;
 b=Seu7Op5Jp4th9TFaFwhovH1tFNx7mzoWF+R8K6z0J0iiP+DQzcasUvv7AwIbRV1osnv/0aFy/zzR4pjPiOtg75NUsXO0NTtB+eoTtZfbkt9LLxotDWnS78j2Xn0zJH/vy+Eu1wPNQ237wDoxPtnRhF20jSnh+aK9PtM4sya35SoT22mKhdf6qeV+XPUhjdozXsdhSoUf+8r4HQalmDE0IxILY1DggDy3pC5u9p67sBL1in/YTY/11i3gx78lA7QupAg/Wyg0TFGzTn/yUQqTYOJiYaV4tS0dWIDPdSG+YQ2bMLs74gKs2m8WbKDqPlCVN5bzgLg1pxH7XLAJeCea/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96XRQWmz+1j2wR+7fLFYuz26279RQuFgSMmgQKjpA6M=;
 b=YXDhgKJ720s8wbdr+lwilOSB7AS6X2x9FY06He4jrAId4oeH9Zz0X3tYjDuiK0+Yj1fkQHXnWilfF8FrocqKd7ZNIMU3HbsRwOyKW+rjJWvbZiRZHh3ncQipp3AlWK9sjUuy9lRBol2oZNDCaNf+Zwj9wgwEuR1bYYHMVW1tSTI=
Received: from BN6PR11CA0068.namprd11.prod.outlook.com (2603:10b6:404:f7::30)
 by DM5PR12MB2581.namprd12.prod.outlook.com (2603:10b6:4:b2::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 16 Jul
 2021 07:36:06 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f7:cafe::31) by BN6PR11CA0068.outlook.office365.com
 (2603:10b6:404:f7::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Fri, 16 Jul 2021 07:36:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:36:06 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:36:05 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:36:05 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:36:04 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>, Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 0/3] Backport patches for 5.10-stable tree
Date:   Fri, 16 Jul 2021 15:34:47 +0800
Message-ID: <20210716073450.26497-1-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15d0b0db-a537-4445-6433-08d9482c5f6a
X-MS-TrafficTypeDiagnostic: DM5PR12MB2581:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2581707808A293946680EBECFC119@DM5PR12MB2581.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:556;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Ldu3BI2m2TGN+JON170j0mhATouhYyrzmbCWbutxX+tIBZ3IcKEuZ5sV3ko+ucJyuRNtUqmxgylvCIMmHi16BEhWT0btze68Hf55DH18ZOmrhbCYUcQ8eDew8ZQOw/RJ/R8w4RTyuBSWVnlnHd17xRT5xjUFj/jzGxcSAceGV/jBmH8o0GoxhYvD7DFu58orFQmF/EAKEuY9dwAJZPgmd3uWklxfKWNDs/62SHvR6eQv2ODlZIml/ITx8gWHfDsI7vzP9dFNWVtBM1Qk1QcyeGdKdBIdOsa5DbESr6IPlKbl6q4slY1I1JZC4FYwQCcGcWwxwhkOn/jwtTB243mep83A5uNS5D/8T0WkyqlvCgOtbHqd6/vxatlmKel3Thr9D79XKEFqg/bC4T66eip8zyZCiruHpZrfr+neiaNaRawdnW1BonDE7437Jt0hRKM5LyfwOngld7xa5okgsRBk7ncyMU3h6EMZJojlXEDTc06ej4lCLboF1A5VckPbi1D9brC6RRNRdzecsxIG9RenV6CeNONo4FW0JwI/P42pxtI9xs8dG03dNd7myvEkAAmAz8OtQVe6KxYEAPG42J3OnsWuvz901XyMGa0avPu63GtH9q1JoPjgkMgMZh20uT/HWtyIllJnncA0L9jmGlsQ+eEPyj1iatRj3Q+aKZiuDYj6fbRXmO6iohf4KmoHODNFoL5AEE2vWgPcQy/ctzf3l9jOkbtvMfTEUCMlNqPycM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(36840700001)(46966006)(82310400003)(426003)(2616005)(26005)(36860700001)(70206006)(86362001)(4744005)(356005)(82740400003)(316002)(81166007)(54906003)(478600001)(4326008)(5660300002)(83380400001)(6666004)(47076005)(7696005)(8676002)(70586007)(186003)(36756003)(8936002)(336012)(2906002)(110136005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:36:06.5675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d0b0db-a537-4445-6433-08d9482c5f6a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2581
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patches below in Linus's tree failed to apply to 5.10-stable tree.
Adjust them so we can apply them to 5.10-stable tree.

original git commit id:
* 3769e4c0af5b82c8ea21d037013cb9564dfaa51f
  [PATCH] drm/dp_mst: Avoid to mess up payload table by ports in stale topology

* 35d3e8cb35e75450f87f87e3d314e2d418b6954b
  [PATCH] drm/dp_mst: Do not set proposed vcpi directly

* 24ff3dc18b99c4b912ab1746e803ddb3be5ced4c
  [PATCH] drm/dp_mst: Add missing drm parameters to recently added call to drm_dbg_kms()

José Roberto de Souza (1):
  drm/dp_mst: Add missing drm parameters to recently added call to
    drm_dbg_kms()

Wayne Lin (2):
  drm/dp_mst: Do not set proposed vcpi directly
  drm/dp_mst: Avoid to mess up payload table by ports in stale topology

 drivers/gpu/drm/drm_dp_mst_topology.c | 68 +++++++++++++++++----------
 1 file changed, 42 insertions(+), 26 deletions(-)

-- 
2.17.1

