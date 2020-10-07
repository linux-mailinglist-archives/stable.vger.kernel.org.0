Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220B9285F58
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 14:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgJGMmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 08:42:31 -0400
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:41056
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727927AbgJGMmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 08:42:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kiw2eeMBVo9IYfNhFwCqyCdD6euX6B8XHXQR9FBCAU8tp4khLHg5+R04vjA+vqEgLgMVVIuvvmRZPwikjEH7eKR7sGAKLRNnd8d9/oQ8Xl7Gle5MTZQDvwQgad70djUxz5VQmEBg6palwDR7333JUesMnkuksmUXHET8HrEe3iiQcsE4UpTiSGgX9ZWKv4t+ILzjuWKgdsH6WbkdA2fIvRjFWEy+dD/XpVlKtphrCnIv7BCL8nOygezxuuZ9WCoAOY0b8AU7D+q4r/wqIiYKFM/z3yPtWJMUz6uaHqsmYcnNNr59xi4sFGtiRQ0J1Y2Lj8ft0PmllPsaIFKNyaZhOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSM6hx9hNf5H6eZJYU8X6g9aYCLCAXq3IAmJ8LVHOeg=;
 b=J31znANzJKANyVgW/INt+vn7kTQwWAVL1pJlXnlA/aTbfEIeM9+WySPHb3L/IpJ5xzhU9JC6rxniPkTlpoywrJtHcrJqeVkdf/duLC7BtvxRsQP7B9GHu+iVXxtsPhWCvltg1PU+WV/QnIvsxXTroW1D05f2SKYHNuG2NH5tE0ru3PpiXOd04qB5WUZ6/pHRFbf5NQ2egDVmEoi7feBPfMJeQxaoZ5lLButDHl91BC+krMVCjmUPjePEM0aQGXsMkgueWEarK45aSjUbdZel1jJgnF7bgrSi8IhJ7oGsFPf2q/wdQ2bkqoVhztjnFOu5RVgy1ogk/MTgfJFfcb/HLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=none action=none header.from=amd.com; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSM6hx9hNf5H6eZJYU8X6g9aYCLCAXq3IAmJ8LVHOeg=;
 b=BSlEST+N4bdm5kIQVO2aBxM3UAp0owQRllkF58mazNM2+hNUcVQNDimYcCWSCi8alAJ2/8cGg4t2hi5zLKtkAU5pQHB3rEHjat6JMs81qF7HJq4ylFblMFBzkTpSt4zeZuXaq3JW/BSblLci18CqvRqZboSDZi2fYth/4Dadq7Q=
Received: from DM5PR06CA0051.namprd06.prod.outlook.com (2603:10b6:3:37::13) by
 DM6PR12MB2858.namprd12.prod.outlook.com (2603:10b6:5:182::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.40; Wed, 7 Oct 2020 12:42:26 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::ed) by DM5PR06CA0051.outlook.office365.com
 (2603:10b6:3:37::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend
 Transport; Wed, 7 Oct 2020 12:42:26 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3455.23 via Frontend Transport; Wed, 7 Oct 2020 12:42:26 +0000
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 7 Oct 2020
 07:42:26 -0500
Received: from aj-EliteDesk.amd.com (10.180.168.240) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 7 Oct 2020 07:42:25 -0500
From:   Aurabindo Pillai <aurabindo.pillai@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <Qingqing.Zhuo@amd.com>,
        <Eryk.Brol@amd.com>, Stylon Wang <stylon.wang@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 01/12] drm/amd/display: Fix black screen after DP/HDMI hot-plug
Date:   Wed, 7 Oct 2020 08:42:13 -0400
Message-ID: <20201007124224.18789-2-aurabindo.pillai@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201007124224.18789-1-aurabindo.pillai@amd.com>
References: <20201007124224.18789-1-aurabindo.pillai@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f974a045-27a4-4bac-200a-08d86abe7256
X-MS-TrafficTypeDiagnostic: DM6PR12MB2858:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2858D5284F5DF37A7F730EDF8B0A0@DM6PR12MB2858.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cWigTnDQqd46pG0IQczzjpYTLVeYPK8NK5i2GsLMow2AbLcled/JtiG7EGRnOBCaHJTgpTYZLDedfa/k/AQhSha36xDSRcthfW/3iOXzYd5X6QRiX85RWSQt1rGBJhgflpAyrVUvJ8vLsB+sqx+5phBfGDgfG4msGBdB0ZPg+pJYyxKh6USe+efrDWkx8YhyK6jzXmVFN31yXcSVdHW2YsIXLPoEmfna6xlSqHoBKvr1MZhBbf9IMQGpuKTE5PEOSXeK8vpTzi7Hrn/QRnFoa16O/+lsyvh3pBaMnl0TfJNQGL8bFwzi8HkGs0LeKaufoPaTrHSI9NAzr6QCa9ByJFhFBOq/tXsB73B6kbNByS3qKqe3oA2ziKAdMNDT2bUeHo28J7L30TVAch4vbhdjYQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB01.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(396003)(46966005)(83380400001)(356005)(47076004)(82740400003)(316002)(81166007)(44832011)(86362001)(6666004)(82310400003)(5660300002)(4326008)(70586007)(478600001)(54906003)(70206006)(1076003)(2906002)(8676002)(8936002)(426003)(2616005)(6916009)(336012)(36756003)(7696005)(186003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 12:42:26.6503
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f974a045-27a4-4bac-200a-08d86abe7256
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2858
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

[Why]
When restoring connector state we relies on drm_connector->status
to check if the connector with matching crtc is connected.
But that status is only updated later when user space calls
DRM_IOCTL_MODE_GETCONNECTOR and then calls fillsmodes().
This causes connectors being incorrectly reported as not connected
when we hot-plug the cable.

[How]
Instead of checking drm_connector->status directly, use helper
amdgpu_dm_connector_detect() to check for connectivity.

Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: <stable@vger.kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 45 ++++++++++---------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3cf4e08931bb..dfcea66ee23c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1735,25 +1735,6 @@ static int dm_suspend(void *handle)
 	return 0;
 }
 
-static struct amdgpu_dm_connector *
-amdgpu_dm_find_first_crtc_matching_connector(struct drm_atomic_state *state,
-					     struct drm_crtc *crtc)
-{
-	uint32_t i;
-	struct drm_connector_state *new_con_state;
-	struct drm_connector *connector;
-	struct drm_crtc *crtc_from_state;
-
-	for_each_new_connector_in_state(state, connector, new_con_state, i) {
-		crtc_from_state = new_con_state->crtc;
-
-		if (crtc_from_state == crtc)
-			return to_amdgpu_dm_connector(connector);
-	}
-
-	return NULL;
-}
-
 static void emulated_link_detect(struct dc_link *link)
 {
 	struct dc_sink_init_data sink_init_data = { 0 };
@@ -5003,7 +4984,8 @@ amdgpu_dm_connector_detect(struct drm_connector *connector, bool force)
 	    !aconnector->fake_enable)
 		connected = (aconnector->dc_sink != NULL);
 	else
-		connected = (aconnector->base.force == DRM_FORCE_ON);
+		connected = (aconnector->base.force == DRM_FORCE_ON ||
+				aconnector->base.force == DRM_FORCE_ON_DIGITAL);
 
 	return (connected ? connector_status_connected :
 			connector_status_disconnected);
@@ -8090,6 +8072,29 @@ static void reset_freesync_config_for_crtc(
 	       sizeof(new_crtc_state->vrr_infopacket));
 }
 
+static struct amdgpu_dm_connector *
+amdgpu_dm_find_first_crtc_matching_connector(struct drm_atomic_state *state,
+					     struct drm_crtc *crtc)
+{
+	uint32_t i;
+	struct drm_connector_state *new_con_state;
+	struct drm_connector *connector;
+	struct drm_crtc *crtc_from_state;
+
+	for_each_new_connector_in_state(state, connector, new_con_state, i) {
+		struct amdgpu_dm_connector *aconnector =
+			to_amdgpu_dm_connector(connector);
+		crtc_from_state = new_con_state->crtc;
+
+		if (crtc_from_state == crtc
+			&& connector != NULL
+			&& amdgpu_dm_connector_detect(connector, false) == connector_status_connected)
+			return aconnector;
+	}
+
+	return NULL;
+}
+
 static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 				struct drm_atomic_state *state,
 				struct drm_crtc *crtc,
-- 
2.25.1

