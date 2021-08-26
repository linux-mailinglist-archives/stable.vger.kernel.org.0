Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460503F7FA6
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 03:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhHZBK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 21:10:57 -0400
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:8832
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235061AbhHZBK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Aug 2021 21:10:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsbX7Vf2XgGONRDySh68oBNZPob0XuhFxivfHsME8z4x4zwqayhgGXnYrELRitdeM8BRokMrL7utdou6sa1X8jgRA8IC1iAbtrF4DyJO6G9iyj3tHXH/B1mthojotgRZyJbV5yp3yZB9bvzZ+Gx6+peSZ91tQ0oVgZy8x0uq7RKR73bCwJdpce2Pd4OqVL9dudsxSQ0arqvi2wMpALhQr0WWhQ9M52ipXH5u+hhzQLOgGfDVbfJnq9znWJ2gNoTxzeHQjK37HUcFVp+f+Wj3iY/YK6SRpilYLw541mj6uQyBKtvHiKbkIv5E1HKM/7D7RZvJPdSxM6AkDQEGaSLdIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f28+3wO3Xq6uzWbfPmkMJUQRpAHOsihMcSuJUPERjhY=;
 b=iZCrFW3fBm3Hm+Lk3RIfXmqhM04LqR582TFYDjzoKlmpkcZTosfEecjGDOL1ARPdpffb3N9OZD7uGtz+I6YM/zwTonz5j6y1kyI6iSUvGpdLHriTJwu9I8HEszfnhd1ycoZErraqa+lDoyxpLfKBmE6WuMi9MecVYZUs7x8bM2C7BIWVpfUgxK7BI2pd9WChy+Qt+BaP0i+ZCt3/Xh2UDsamU4Mo/4dt6Db58FgDUbOVNvpFXBj0/wNHy7BRH/CF1/cvbIYevqCazDz0oQEVK/L3p9sOviv64Y+r0PJU0m11WaD/XGZ8siM747BYrtcPXXq9HWCFzb1ktJr8RsU1Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f28+3wO3Xq6uzWbfPmkMJUQRpAHOsihMcSuJUPERjhY=;
 b=TiRCc2zur9XrtiupdLcVJBelPPdwYUwrDco5L4KTTBcrJwBZ2B6UVUMI0XNsCG5dD+Zcz3BCeAVOvRoHBgXPSN2I9aHSZ804Tt5lkWGrCK7smvexgxzw2l/AkHPuqZClnY5wc67/P6iLKEiTTlFApDCNNaNB3KOaoxQ4hmDtFlc=
Received: from DM5PR08CA0040.namprd08.prod.outlook.com (2603:10b6:4:60::29) by
 DM5PR1201MB0091.namprd12.prod.outlook.com (2603:10b6:4:57::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.13; Thu, 26 Aug 2021 01:10:08 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::e) by DM5PR08CA0040.outlook.office365.com
 (2603:10b6:4:60::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19 via Frontend
 Transport; Thu, 26 Aug 2021 01:10:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 01:10:07 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Wed, 25 Aug
 2021 20:10:05 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Wed, 25 Aug
 2021 18:10:05 -0700
Received: from elite-desk-aura.lan (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.12 via Frontend
 Transport; Wed, 25 Aug 2021 20:10:03 -0500
From:   Aurabindo Pillai <aurabindo.pillai@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <nicholas.kazlauskas@amd.com>,
        <alexander.deucher@amd.com>, <aurabindo.pillai@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/4] drm/amd/display: Update number of DCN3 clock states
Date:   Wed, 25 Aug 2021 21:09:59 -0400
Message-ID: <20210826011002.425361-1-aurabindo.pillai@amd.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5210b775-15b1-4f17-7ab0-08d9682e3e7a
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0091:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0091A16331BC6460C21293AA8BC79@DM5PR1201MB0091.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sauyYXS8xgQ1CR6glS2eucLmr7bJvtHB0X+Xsy0SiCjvxCCeTtfe8QpIml+e/2AevLKupf457rMge1h+pf1UfWD2rWSoZ7S1JVsoPrtBMWOVHd3+rYBrjlnj6Eho16R8ckHFs4RoyOQnBZWujE06lZSeuJ4+P1a+swVcxhlvDt8/2e3DKVE5LwKgbK1+sSEEEboaDbfwljk5WHRo4gKeOdbOIth+1BZI0slzAfdIx6IrxW60JurWEiLMvHtTPgQ9KvuDu0GrZ+VGCFbQbdd8Gw7cJrXbIDbU5kHsG+sBPPuLTlOsUzyeNTPfHVEBzloHrrwlZgHaQs8ssPrLTsatkyaPUU3SsxbgmjH7qkvr7VZ0JK82TUcAIbVmtrqVHPPNwCfELjXcEF9xQGk7y7mfdXbswKnblMkffy2o3dglZIq6ZznZhvmeOUi/RZXQarYu6L4w4S6uE8f0ko12HxoPX74V9lpKuLpIo8kefL5RDTd7Vm7njQtppDRFNXFH5ZeFU+sRO/Psy1IuRN0QXXEvvFXONk2IC1QbFT0HomyEoJLqSCyZTWV1PsjRCEA8Kntj4afgs0fiXpNI1npqqhaVj01FHyk6K/8LuOohxJUu99i31nNcZvQaVYbP7V6FdZUm/6YzQw0cg6K6W1iCQoDOL/1M+7GW34j4DoAEA8TrLFaaO1QnoXBEho/T8acfuXeitTRCGlcBYCEHIpVUX8yKzjK95VMZ4wGW76Pw5WgKhQiI7PYT2dfi7IDe/7eOZjqvtGNtzDJojYP1ugVTLGiSDQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(46966006)(36840700001)(426003)(1076003)(54906003)(26005)(81166007)(4744005)(2616005)(86362001)(316002)(4326008)(8936002)(44832011)(2906002)(5660300002)(36860700001)(70586007)(336012)(70206006)(186003)(83380400001)(8676002)(6916009)(6666004)(82310400003)(82740400003)(36756003)(478600001)(47076005)(356005)(117716001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 01:10:07.2846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5210b775-15b1-4f17-7ab0-08d9682e3e7a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0091
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why & How]
The DCN3 SoC parameter num_states was calculated but not saved into the
object.

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
index 1333f0541f1b..43ac6f42dd80 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -2467,6 +2467,7 @@ void dcn30_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params
 			dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 		}
 
+		dcn3_0_soc.num_states = num_states;
 		for (i = 0; i < dcn3_0_soc.num_states; i++) {
 			dcn3_0_soc.clock_limits[i].state = i;
 			dcn3_0_soc.clock_limits[i].dcfclk_mhz = dcfclk_mhz[i];
-- 
2.30.2

