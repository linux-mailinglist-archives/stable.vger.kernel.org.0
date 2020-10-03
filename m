Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45084281FA6
	for <lists+stable@lfdr.de>; Sat,  3 Oct 2020 02:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgJCAQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 20:16:22 -0400
Received: from mail-bn7nam10on2086.outbound.protection.outlook.com ([40.107.92.86]:31936
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbgJCAQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Oct 2020 20:16:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewH9J1LulpobLxiZp08wkCIME55LsTI/rr+N7ro5rneJhHiWC5AdzziVjdD47VmXVRFNc2qklXLEdAfuP2TSDLT1Os5V9Y/VXpKbx6++PiowG7cnrK9EDHy2r+lNHCDPNmXV+9fTyn6YTNurjzQNseEoqAYnFz3d/00UnNdf8I6jcN7l0eiQTTo9wdt066BcpIyikK1jRZcV1odW5/wbJ8OWiJSvLkLmNff50+Z2n8UsNrpQI8kjo9qPn1xTL5hkT6gMzJj9PHDaO/UJAqEXjXZrv/C9flWI1wsULP9sH0Tt2PP0deCp3iJfRjcus8xTryNDeZvI8W8VF5/FxOXhqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qguI5WP31wPs7CePkC9z8U0WRS70DZJ2s4GuJjyCMJM=;
 b=AWA01aprR4l6MhZZk3wCjmhYS4kkEM5xMg4bddPUBhf0oTdsB1JWZSbgEqsgd+2ScMZWGPxd7S0zoJ8IyNAT5O+csXZf11GjDrVwHvN5tPHrPQZ0QAJMGtUfa2pPIT8LymXcnZj+FUk/YlqNiABo6b865Akh8YG/K6uY1J/P9+8X3Pn1j0I9EDMuIV1/y6C8kHQrHsMSUDDSaTYdEmttoQUpfqRP7E155ZonpixzkAKt2RGoyFahZ3lweUA956K2wcfjByMpiBGFC+j6JOlWIhjsHsCzU6/01dqbAJ7oE5qTVZUASwFu4eSH/ZybnpjP3XF3/WYuY1Qa/IR7ldQ3wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qguI5WP31wPs7CePkC9z8U0WRS70DZJ2s4GuJjyCMJM=;
 b=N0jh+aR/+TfBIsY8VXkblqNqQ0a2nOObErkgbSa8HPFfUWVw4Udke8VzwHk5jeX7Xp/tetPekUYpgHTPHSf3RR3bpOGqBDPQvuHfS9dTktUlu3l5vMqDNZlGBzgT7ogI8RT23guonM2IhVgFnW36iqy3cv+pUlAlDpCI0yWH3U0=
Received: from CO2PR05CA0079.namprd05.prod.outlook.com (2603:10b6:102:2::47)
 by DM5PR12MB2391.namprd12.prod.outlook.com (2603:10b6:4:b3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Sat, 3 Oct
 2020 00:16:19 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::c0) by CO2PR05CA0079.outlook.office365.com
 (2603:10b6:102:2::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.13 via Frontend
 Transport; Sat, 3 Oct 2020 00:16:18 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3433.35 via Frontend Transport; Sat, 3 Oct 2020 00:16:18 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 2 Oct 2020
 19:16:17 -0500
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 2 Oct 2020
 19:16:17 -0500
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 2 Oct 2020 19:16:16 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Qingqing.Zhuo@amd.com>, <Eryk.Brol@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] drm/amd/display: [FIX] Compilation error
Date:   Fri, 2 Oct 2020 20:16:16 -0400
Message-ID: <20201003001616.16816-1-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d64baf1-a6a1-4282-ca10-08d867318cb3
X-MS-TrafficTypeDiagnostic: DM5PR12MB2391:
X-Microsoft-Antispam-PRVS: <DM5PR12MB23914652DF80B92F6DF2F716FB0E0@DM5PR12MB2391.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JQa2HpqVUyyIruDOkNutWVbRccrlopXxtv+eGt68XPZQOz2HPyO+XMcuBZq4ty4Q4j2UhbPyekT4xHUdgCLQPt0qiZNAbjmGfxpGdX+4/qwYCou1VQGu44d1LMewcB8tOtuWuSqGB1afgnwHf/pWX40JHXpyno8vR5sILfsupMKjFdXr5u9X1ITdOVU1NdGxY0y4RNRH8qbhZ0mdNQ5XliZkjtRWBvS2JQ/tGx+toIVncxPV2twUb81aCn/7RmFhzBKByEnF/149xRKyNEdyperY35XGQBOPfErtrs0mXTUek2wD1Pgt0rwwOg12cbFutVfEiJrxxrr+KuOE/kSEJHE55Vt+nsR0AtJ+F8TEF3BLCRTEvlM5AR5F+rJiM2GWa+oJmb48mitTC/IPh1ulf6rDIKVEa6O5oaGJSwqhXqfSwKs3ihmkstEnInEM1jBr
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB02.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966005)(2616005)(426003)(44832011)(26005)(186003)(70206006)(70586007)(47076004)(4744005)(83380400001)(86362001)(336012)(2906002)(8936002)(54906003)(36756003)(356005)(5660300002)(1076003)(82740400003)(4326008)(316002)(81166007)(6916009)(82310400003)(478600001)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 00:16:18.2767
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d64baf1-a6a1-4282-ca10-08d867318cb3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2391
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
ifdef mismatch.

[How]
Update to the correct flag.

Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Cc: <stable@vger.kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.h b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.h
index 389ca0d54d1b..829cd9a93ba9 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.h
@@ -189,7 +189,7 @@
 
 #define ABM_MASK_SH_LIST_DCN20(mask_sh) ABM_MASK_SH_LIST_DCE110(mask_sh)
 
-#if defined(CONFIG_DRM_AMD_DC_DCN3_01)
+#if defined(CONFIG_DRM_AMD_DC_DCN3_0) || defined(CONFIG_DRM_AMD_DC_DCN3_01)
 #define ABM_MASK_SH_LIST_DCN301(mask_sh) ABM_MASK_SH_LIST_DCN10(mask_sh)
 #endif
 
-- 
2.17.1

