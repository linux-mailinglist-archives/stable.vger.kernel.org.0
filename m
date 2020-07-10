Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E08021BE7B
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 22:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGJUeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 16:34:04 -0400
Received: from mail-eopbgr760083.outbound.protection.outlook.com ([40.107.76.83]:57009
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726725AbgGJUeD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 16:34:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEclNMt4AEcfXFNIVtylwPvd3XASLn7INKbWqn87lhAmCZvAarKAgXNuP0K4kmU3LCviXjiAK/p3FOoJlF9OjJgPwytUYm+okTqt07mr2FQw7Uw1j6gg0NopOGp7RnrJBA1ptmNo9vzgcL77D17yQVGgbcSRYOEsy06+rQDU35jdGfoPoEEeHVbjC5cV4hJgV8TMqjOvF35yUpCRc3iuYglPKtzKigTLJWDsBfT7xVe4y1742mTOpoTPe5qxX6jkM/gmQ2yZIEZSnSJrVxaGtcD8ieB7A3RJ8awSiU5/BqHQF/5T+MBa+64humCn7YDWUL7feRxanEnTsGp+Ov3R9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN5UwhteYtoxml3Ak4BoRL/xX/HWJqs9qyXbNaW7GRI=;
 b=nrwj9jt+oFHomt+NkDFK+ZPwJbIrPpmeP6YDaLSDxWfLVdsR/+Z45hFNFY8XYzQzZ5GAwzI5ko6pEUZROKqhqZzWdUNOw7Dsk3yq+aHN0s8XTdxtp2EK5bC/90WDFAao3PQcGQRf3wldzCur8olJI5MU9Q6Xiz1hxKroEG9v3DtzZg1fc+mejvNZ6DJoHCVZSZCCUmgYmdqQZ1aaC7i3ZKeA9r7NoLI+XzR2gPlxAlt8UZIB+fivL7Ip49r5LT+Yv00J3LU3atZXp4OqkfrXy0d0EdmE/cao/8nXszMpJIxUP1cSY94c/J/1+l6cW61/pcdfkaFqS+jZqMDiFnZTIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN5UwhteYtoxml3Ak4BoRL/xX/HWJqs9qyXbNaW7GRI=;
 b=A5niN3FZt329ySaTK5OF4YuWKgqg0JUp8p99q407o9lQpPjheSSZAnH6jCLn5rBqpWmIHthCA9RR9mbEtL/0FHWZ1/b13hIwSAbr6GVcRf9CCy2JS5wIr5i7bpJvkwohq3HE/E3/7Jyg8k/O8tIzjeU0//8bQu4yLgBQXSuID5c=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received: from CH2PR12MB4198.namprd12.prod.outlook.com (2603:10b6:610:7e::23)
 by CH2PR12MB4231.namprd12.prod.outlook.com (2603:10b6:610:7d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 10 Jul
 2020 20:34:02 +0000
Received: from CH2PR12MB4198.namprd12.prod.outlook.com
 ([fe80::9013:9410:7d60:cce1]) by CH2PR12MB4198.namprd12.prod.outlook.com
 ([fe80::9013:9410:7d60:cce1%9]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 20:34:01 +0000
From:   Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Harry.Wentland@amd.com, Sunpeng.Li@amd.com,
        Bhawanpreet.Lakha@amd.com, Rodrigo.Siqueira@amd.com,
        Aurabindo.Pillai@amd.com, qingqing.zhuo@amd.com, Eryk.Brol@amd.com,
        hersen wu <hersenxs.wu@amd.com>, stable@vger.kernel.org,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Subject: [PATCH 04/10] drm/amd/display: OLED panel backlight adjust not work with external display connected
Date:   Fri, 10 Jul 2020 16:33:19 -0400
Message-Id: <20200710203325.1097188-5-Rodrigo.Siqueira@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710203325.1097188-1-Rodrigo.Siqueira@amd.com>
References: <20200710203325.1097188-1-Rodrigo.Siqueira@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YTOPR0101CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::38) To CH2PR12MB4198.namprd12.prod.outlook.com
 (2603:10b6:610:7e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from atma2.hitronhub.home (2607:fea8:56a0:8440::b10e) by YTOPR0101CA0025.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 20:34:01 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [2607:fea8:56a0:8440::b10e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ade2866e-8867-402c-a016-08d8251094aa
X-MS-TrafficTypeDiagnostic: CH2PR12MB4231:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB4231394AC9FE163BBDA5727398650@CH2PR12MB4231.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HTpHADZ6u1FtNBstKZXUopvZuaQi4bXAjBIIPoad0eOhRZoJvnaGEbB0vWMmh1Hx5sZtqqgnRlDP5xosEcSLyMsm5HbBGwFyxEjrfZ8JgapbN1T9apqcM3RCx7EJf+cND+hd6WjB4JZ/bWbgG08Mx0dtlwqudSFXZPA0NwSdhmCC27kpPkJ1wwn4NSOgxB1GpOYqjYkzuswwY9bM8prhm1tHG/Wd0hXAXdR8qFNaT3PtUS4IbvOqIpaRbr896w8vCHijywM1t/BNJyKwy1vIuWvpWcmsPZ/bqHPDWkt4fbBPbIAWOesnpz5OQak/L3PLNRkyEvUc9SbO8pg0m7/m2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4198.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(54906003)(2616005)(8936002)(8676002)(6512007)(478600001)(316002)(16526019)(5660300002)(186003)(4326008)(86362001)(6916009)(52116002)(6506007)(6486002)(1076003)(6666004)(36756003)(66476007)(66556008)(66946007)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Wo9ZNqWgUdg2WhsL5gc2C5hiSd61gZ6daIXB4gMbf1CtQo9ML1w/0zBtzw0yksU1R/P8gerwApNWxm7SWirutDAabcXv+8utH3ViYTFwVxPPsjN26LV3W7aEWqDtlfz4bqt13MtzVVfJxDra2MiPyqaEwYbhoxgstMkbogLpgDMv+dkXhl/jFgAFs/eIAXYeKYerSyQ4f5DsfgTCMVadBw1/YYg3KzpMzxrrK11Rx5lYGnn/nBIkQWcC+V5QcI4EcErvrGfIvME9hYv+gNAya4nMaky9RLglloH2m+uXCGCrEPQKG5Jff7K+Vx1adu+ekazpjLZjMcNj6vZncynUt9tNb6fxMLlJOc0SBUta4CF+ju9Znn+m1etrmE5JJbFYXiAdtgXruzYdTNf59lPNkkASl1JvdLMXR1Y9YkpdufbmH+S25Mu5mh0D5hC+iYH5o5lKlaxhda+risX9fjDw90s47lSYF9FZhLNFDFonsJ9qbuoyk+eltzVWlFrUfK5RPT/FwAcuk7F7G/WH2vfoNA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ade2866e-8867-402c-a016-08d8251094aa
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4198.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 20:34:01.8412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j1xR+Hyb3ZDYzu2rLebRZOFK0C5PYok3J0FtERDxwYR7vUC5jIoVWpuPPeM7V9k9wmEaqCrpScF6JsyAuhnZNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4231
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: hersen wu <hersenxs.wu@amd.com>

[Why]
amdgpu_dm->backlight_caps is for single eDP only. the caps are upddated
for very connector. Real eDP caps will be overwritten by other external
display. For OLED panel, caps->aux_support is set to 1 for OLED pnael.
after external connected, caps+.aux_support is set to 0. This causes
OLED backlight adjustment not work.

[How]
within update_conector_ext_caps, backlight caps will be updated only for
eDP connector.

Cc: stable@vger.kernel.org
Signed-off-by: hersen wu <hersenxs.wu@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index b4e120e95438..5569e0500734 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2019,6 +2019,7 @@ static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 	struct amdgpu_display_manager *dm;
 	struct drm_connector *conn_base;
 	struct amdgpu_device *adev;
+	struct dc_link *link = NULL;
 	static const u8 pre_computed_values[] = {
 		50, 51, 52, 53, 55, 56, 57, 58, 59, 61, 62, 63, 65, 66, 68, 69,
 		71, 72, 74, 75, 77, 79, 81, 82, 84, 86, 88, 90, 92, 94, 96, 98};
@@ -2026,6 +2027,10 @@ static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 	if (!aconnector || !aconnector->dc_link)
 		return;
 
+	link = aconnector->dc_link;
+	if (link->connector_signal != SIGNAL_TYPE_EDP)
+		return;
+
 	conn_base = &aconnector->base;
 	adev = conn_base->dev->dev_private;
 	dm = &adev->dm;
-- 
2.27.0

