Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD686148EA9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 20:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387683AbgAXTXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 14:23:54 -0500
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:23265
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389871AbgAXTXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 14:23:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cj9+OahlUDLPdD3zkxKfMhov8l51AiqSj8bButb3FIGGM4BmN/Cc+69L8ywf44wliceL1VSDUM1YknFffhbOIYFFfxI/cfDUX4XhZaCLw4AAeDMZ2yprMU4Ua0GkkvK9IrEX1AuIWWKRzuLaKcjvoSKjjuc5Dyi/WRZYs0jDBXFSkwCc7ufNmjAKKm+MtxnxCKgOp6BlaDoBYxYVFBS3i84/og1GtpM+8bmBOMv3u/+bnIEgWJB1hl98WtipKPymAL/hLpV6D/oBwDMyMa/ZzEt9dDzC34pgYHDE1Zi7bWOs6zgUKCUQR69u2Wsl5EnXLl1mlBs+dPd31WZ3SGrJAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QapBYtAW9RphrDvDR3527X5/6cw7pRBMMGLMyR/MeA=;
 b=WCBoMD2yGCmkPICxz/sw4scoU17LjWugtBi9Q2rxv0H2JMK1UvJ7H5PiLXjio/c7WHKHO+1bsGaZ1Fv9Ie0xIgDMfCN/NoHVLNqMmp8zhPGxPg4JjvbhTR0ykJKAu3oDEjZ/L3DxGmMqzdZQqAbRyUDmXyrkfubc1W35L3n6BXiejKj0NL0RyOUNLzXalWnJOdehGr4/cE2sedQfgkZOudFSdXmlfT8JNjTD/7vLrKaaauF644QlQLMxcYdneufV2hz7lYNi0O/CAaplZaxFTp76IN7NooXdz5yexDh6PcYRdj8mBboVx3+e6ZHF00D1AnQUHOWW2vLJMkczFAE9JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QapBYtAW9RphrDvDR3527X5/6cw7pRBMMGLMyR/MeA=;
 b=bKXB8Y5+TjU3AYvLclMS4DDDU+YuS9kncCnJJ7ko2ss7LIaD6cFskX6B87Cz0COMEajgiKjdmUqQcCray0tBUzd93h/ljIvYn0mXcJUCqNHxwdJtgGgevtd9HfzYwNdCN7CIyBmm0ePEjZLO5r3ezgseluCl/p+7LWIqGK5fxKA=
Received: from DM6PR12CA0029.namprd12.prod.outlook.com (2603:10b6:5:1c0::42)
 by MWHPR12MB1136.namprd12.prod.outlook.com (2603:10b6:300:f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18; Fri, 24 Jan
 2020 19:23:51 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eaa::208) by DM6PR12CA0029.outlook.office365.com
 (2603:10b6:5:1c0::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend
 Transport; Fri, 24 Jan 2020 19:23:51 +0000
Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2665.18 via Frontend Transport; Fri, 24 Jan 2020 19:23:50 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Fri, 24 Jan
 2020 13:23:50 -0600
Received: from SATLEXMB01.amd.com (10.181.40.142) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Fri, 24 Jan
 2020 13:23:50 -0600
Received: from hwentlanhp.amd.com (10.180.168.240) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 24 Jan 2020 13:23:44 -0600
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     Roman Li <Roman.Li@amd.com>,
        Colin Ian King <colin.king@canonical.com>,
        <stable@vger.kernel.org>, Roman Li <roman.li@amd.com>,
        Zhan Liu <Zhan.Liu@amd.com>
Subject: [PATCH] drm/amd/display: Fix psr static frames calculation
Date:   Fri, 24 Jan 2020 14:23:43 -0500
Message-ID: <20200124192343.12540-1-harry.wentland@amd.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <d4fb24b4-bc95-4684-bb09-3cf4df8b3c2c@canonical.com>
References: <d4fb24b4-bc95-4684-bb09-3cf4df8b3c2c@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:165.204.84.17;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(346002)(376002)(428003)(189003)(199004)(8676002)(81156014)(8936002)(81166006)(26005)(70586007)(54906003)(186003)(7696005)(86362001)(316002)(36756003)(2616005)(2906002)(44832011)(426003)(4326008)(356004)(1076003)(5660300002)(478600001)(336012)(70206006)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR12MB1136;H:SATLEXMB02.amd.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1f3c788-bd46-4bb1-83a4-08d7a102f164
X-MS-TrafficTypeDiagnostic: MWHPR12MB1136:
X-Microsoft-Antispam-PRVS: <MWHPR12MB113600FE2CAFA5081C06D9A68C0E0@MWHPR12MB1136.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:800;
X-Forefront-PRVS: 02929ECF07
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtHwMeidgUtAI0qaKdKm1tFcppjlu9SUUC05PrpEDXsMF4nfsM0SxSSv4SNluWyxdc+8WdDtbQz6qm9n+H7j9elSopfy72QTBF128X2j+ZxcavygPozlKrM564UASXvU4vqRYwln4rDTjsb+95P1eYpp1E/+KNe4v9GPWielAJdTi6AW9D5LpyRssCgj1ZOV5z3kNnzlr3C3pyVm//JuebJXwnOs4511Qv0piSnvVvLEXhDWO+J8caaAmBNu9tz2VyWTmLg6lZEjtsAytA0cITO3hulqZ/nrowMG7X2dSy3vQdvIDeDNNpR+plcSSKEyEzZHu3wlHh8QKGD2aL5B6mkzY2RFrsz3PjybIEhq00LdjiYPpdmttUxonmuMv882cS5Y/L9I2rseylfR/yDOJw6CMEnPK3yKvIlbyN0K+ZuS5z9/wnT6B6sgga3jZyUo
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2020 19:23:50.7206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f3c788-bd46-4bb1-83a4-08d7a102f164
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1136
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[Why]
Driver crash with psr feature enabled due to divide-by-zero error.
This is a regression after rework to calculate static screen frame
number entry time.

[How]
Correct order of operations to avoid divide-by-zero.

Cc: Colin Ian King <colin.king@canonical.com>
Fixes: 5b5abe952607 drm/amd/display: make PSR static screen entry within 30 ms
Cc: stable@vger.kernel.org
Signed-off-by: Roman Li <roman.li@amd.com>
Reviewed-by: Zhan Liu <Zhan.Liu@amd.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index eed3ed7180fd..61c36c1520c2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8491,7 +8491,6 @@ bool amdgpu_dm_psr_enable(struct dc_stream_state *stream)
 	/* Calculate number of static frames before generating interrupt to
 	 * enter PSR.
 	 */
-	unsigned int frame_time_microsec = 1000000 / vsync_rate_hz;
 	// Init fail safe of 2 frames static
 	unsigned int num_frames_static = 2;
 
@@ -8506,8 +8505,10 @@ bool amdgpu_dm_psr_enable(struct dc_stream_state *stream)
 	 * Calculate number of frames such that at least 30 ms of time has
 	 * passed.
 	 */
-	if (vsync_rate_hz != 0)
+	if (vsync_rate_hz != 0) {
+		unsigned int frame_time_microsec = 1000000 / vsync_rate_hz;
 		num_frames_static = (30000 / frame_time_microsec) + 1;
+	}
 
 	params.triggers.cursor_update = true;
 	params.triggers.overlay_update = true;
-- 
2.25.0

