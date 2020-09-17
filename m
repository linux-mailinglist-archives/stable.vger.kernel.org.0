Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C99126DE53
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgIQOeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:34:11 -0400
Received: from mail-eopbgr760071.outbound.protection.outlook.com ([40.107.76.71]:61863
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727639AbgIQOc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:32:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbLqOGiYzvkr4qQdUkGwVu5HzCOCTdzqbFTfnwS34VU5QWNteuJgEoRD+oLKOK+3aZ/4hkotZ4kvjHUIFCbuVqZ9d2hgV2FSVUSabIMbWvym6qV0naeH75vZhOwqNzqopC7btvSxMDgaFNdFYDyC6JovYVe58JHPrDlyq12exTkoMvY0yLoxu8GhvaXgT2aHA2dJMGrqarX4wtEwV0uww9bby2fZM7tCNdfWQOrAW7R0ZR2BtOLhItQejZoksqG3HjPULSxqrM8cQ3PHpO5n5/yCNvYKruz+N+HOvd7BSbNzd+QWPtA+QuOfpOm/lsXJmapeBlffd8G725dnUI0dRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gRxKGNLButXVcjddsGcvgmkkq0MGTrrtcWbFx/u7a0=;
 b=TpB7FDSK+alq8BuGroZ9Hk88JC0E1uXdMgnXerfS/aX1DHIBQuUoTihWoYcGUdo5AlH//D0ulFPlOoH8OtUdI9j/hPCI3Wgxtdqo/otwcbMgOKLMyeEbwz6oAzrf77TPF+qVkYOaaTY81YAL4IGpF1uDOYDWRLNY+56bcFnpXmROEguTkNDdTZdcCmSqOTPJgvbB+uttn2VHVF+wGInHWKzrJE4nHX41h/hwN8l3sMRpsPCk/mbrc6QTTsMeNLnpLxDFSt25sMh09YkjNza+xTPtm3i3mNfYiw/8eYYrJpHoxkyIZ+FCISVks5DPBuWUsz6zUVXsNF8KIEgZdYF5Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gRxKGNLButXVcjddsGcvgmkkq0MGTrrtcWbFx/u7a0=;
 b=2yzMYDuv1rI6kmALjy57kS0O2gaQu3qafDu3MNvXAW2atW/bR6DGuoPDUZyF8bdaX/BwCumEG8e0H72RpTGdHo61St/A9fb3n+B7kbwUMGgOxDzgXGREqpC7BXtZrbjs3hIc4dT3Qc6b5k/HFK26QtMLh0QLJAPZ0XYaNRxYjAU=
Received: from BN6PR04CA0106.namprd04.prod.outlook.com (2603:10b6:404:c9::32)
 by CH2PR12MB3669.namprd12.prod.outlook.com (2603:10b6:610:27::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 17 Sep
 2020 14:32:14 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:c9:cafe::7d) by BN6PR04CA0106.outlook.office365.com
 (2603:10b6:404:c9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend
 Transport; Thu, 17 Sep 2020 14:32:14 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3391.15 via Frontend Transport; Thu, 17 Sep 2020 14:32:14 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 17 Sep
 2020 09:32:13 -0500
Received: from SATLEXMB01.amd.com (10.181.40.142) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 17 Sep
 2020 09:32:13 -0500
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 17 Sep 2020 09:32:13 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Qingqing.Zhuo@amd.com>, <Eryk.Brol@amd.com>,
        Lewis Huang <Lewis.Huang@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH] drm/amd/display: [FIX] update clock under two conditions
Date:   Thu, 17 Sep 2020 10:32:12 -0400
Message-ID: <20200917143212.26346-1-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea284977-e135-4fef-48d1-08d85b167897
X-MS-TrafficTypeDiagnostic: CH2PR12MB3669:
X-Microsoft-Antispam-PRVS: <CH2PR12MB3669F67626C4F6B9893098D5FB3E0@CH2PR12MB3669.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:242;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hK2J57KaaRRvwj9qN3LOqoRXMJpR9bEWpXGIVKdVvNsUlhkECV6q3GpNtoneNNagwb9xV46AUeppcUabYod6qsHg5raqbeZIbYiKQyS8xcaQA286SgI9lcEtAkVk1NXa5JKbmG9h28ZMAPxD1VU0o/3n+wqN3hkxp/rar9QE8UAUpa6H6G1Kj3dxq7ybNe+SH8bs0nOKVa60rxgEbyO9kaIfIQnisKOIoJWs0gItOlJxShDLa0rccUH5CrdDC5MNKgqrfet8H/R4EKubSRUHK0Cv9e8PJBW2UtLhTyW9UbG7OCR5FA1thwmuaPxxbSzSnrmHQlgL/+jxb04x5vAlUDj+bqKsxAWba454VbIlPYg+fVshKSEbZDbXfYmj0AbXGMeQK9qGPKefeBQUv1Ip2g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB02.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(46966005)(316002)(26005)(44832011)(83380400001)(478600001)(5660300002)(82740400003)(1076003)(8676002)(2616005)(36756003)(82310400003)(54906003)(336012)(356005)(70586007)(70206006)(2906002)(8936002)(426003)(4326008)(81166007)(86362001)(186003)(6916009)(47076004)(15650500001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 14:32:14.3074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea284977-e135-4fef-48d1-08d85b167897
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3669
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
Update clock only when non-seamless boot stream exists
creates regression on multiple scenerios.

[How]
Update clock in two conditions
1. Non-seamless boot stream exist.
2. Stream_count = 0

Fixes:06f9b1475d98("drm/amd/display: update clock
when non-seamless boot stream exist")

Signed-off-by: Lewis Huang <Lewis.Huang@amd.com>
Acked-by: Qingqing Zhuo <Qingqing.zhuo@amd.com>
Cc: <stable@vger.kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 1efc823c2a14..7e74ddc1c708 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1286,7 +1286,8 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 			dc->optimize_seamless_boot_streams++;
 	}
 
-	if (context->stream_count > dc->optimize_seamless_boot_streams)
+	if (context->stream_count > dc->optimize_seamless_boot_streams ||
+		context->stream_count == 0)
 		dc->hwss.prepare_bandwidth(dc, context);
 
 	disable_dangling_plane(dc, context);
@@ -1368,7 +1369,8 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 
 	dc_enable_stereo(dc, context, dc_streams, context->stream_count);
 
-	if (context->stream_count > dc->optimize_seamless_boot_streams) {
+	if (context->stream_count > dc->optimize_seamless_boot_streams ||
+		context->stream_count == 0) {
 		/* Must wait for no flips to be pending before doing optimize bw */
 		wait_for_no_pipes_pending(dc, context);
 		/* pplib is notified if disp_num changed */
-- 
2.17.1

