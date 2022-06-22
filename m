Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2015554DD8
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 16:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358758AbiFVOts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 10:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358771AbiFVOtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 10:49:33 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00095.outbound.protection.outlook.com [40.107.0.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2D73E5E6
        for <stable@vger.kernel.org>; Wed, 22 Jun 2022 07:49:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2b67p12OhR8hCVhOSPOA2bnUBw2C7go+H56CTCborGd12oYHdBWoN23cYG8XfNQF6DmmPALHjE3pE8+3gPIv4xfo1rFA6a4FjznDnE219fylEm8+D/oIYII5oAkyYG606eE9sOs31TZl0bhSHl6oD3oBFUHuO0bawDQZmp0YCwxqSdHMXBIH7ymYcbfcgvBd1Lrt6/Ooj9ATor9tkwSVNnYceVgobGvdIeO3OXfyHjouNWVNErSL1eaI09Xti/sftaCqnb6Od9Cae4kwFl9TeheOrC+1EJaUx7oPTNFnYVzX72reo1ZpeYHVJUJreK5njZs997jKj+T/xXpwAAcQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySGdaxzN18L7N5AayvblSC0JsieZ6nAlPwhMDUIoBAA=;
 b=XVcwkkQQlnfCCG5gV2avWdVZ7BTOT1zYIbFTYPiDlUwn9xoziQT7ysrE1fGyH6peURObjTfTiCDvvXuGR1Vim1zi9Kzw3IALP9/lI6QWApQPqNikCgTZyOxuC85Vyz97sJDtSJWJNypkah+cW9CdfzDFJQIMkJjj4wVOn3NrMkSVuAGbgXZ9kv0lxfaJfpvPwbTaTR+4HwcSFlrh4Un8yRf+yJwrIM66a6LAHZb6p0oeug9oSOcSJA2W8lPBfOAZ9GxnTcMVyIUnBFWsufwVvDCA3/9ZbtTXKZ+6k1Of8Q0QdsUIrwxNLTRRglgm63GmlG2gfUyNeqwfqaxWwBcW0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 212.159.232.72) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=bbl.ms.philips.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=bbl.ms.philips.com; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Philips.onmicrosoft.com; s=selector2-Philips-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySGdaxzN18L7N5AayvblSC0JsieZ6nAlPwhMDUIoBAA=;
 b=AltUoJcxag7RYjJRMn0FpKXYRHrZKfS4zLIBg79O1UAbPjuwlVzcIiSezJXm+OBv9iZ7fV/6U9tKpSVPsHySyOFBt/at5oJUwLzjs+7jD8/8YTiHghrfBoRCKOry0l0w0RwRvk8hH07cjXfJRkLYWN7RwIeOcmbOqJzm+bUKoSo=
Received: from OL1P279CA0072.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:15::23)
 by DBBP122MB0249.EURP122.PROD.OUTLOOK.COM (2603:10a6:10:174::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Wed, 22 Jun
 2022 14:49:17 +0000
Received: from HE1EUR01FT038.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:e10:15:cafe::43) by OL1P279CA0072.outlook.office365.com
 (2603:10a6:e10:15::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Wed, 22 Jun 2022 14:49:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 212.159.232.72)
 smtp.mailfrom=bbl.ms.philips.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=bbl.ms.philips.com;
Received-SPF: Pass (protection.outlook.com: domain of bbl.ms.philips.com
 designates 212.159.232.72 as permitted sender)
 receiver=protection.outlook.com; client-ip=212.159.232.72;
 helo=ext-eur1.smtp.philips.com; pr=C
Received: from ext-eur1.smtp.philips.com (212.159.232.72) by
 HE1EUR01FT038.mail.protection.outlook.com (10.152.1.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15 via Frontend Transport; Wed, 22 Jun 2022 14:49:16 +0000
Received: from smtprelay-eur1.philips.com ([130.144.57.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 256/256 bits)
        (Client did not present a certificate)
        by ext-eur1.smtp.philips.com with ESMTP
        id 3pGkoYU1Ul9Zi41fQoHJ8K; Wed, 22 Jun 2022 16:49:16 +0200
Received: from mail.bbl.ms.philips.com ([130.143.87.230])
        by smtprelay-eur1.philips.com with ESMTP
        id 41fQoElZdK1kB41fQoyNj9; Wed, 22 Jun 2022 16:49:16 +0200
X-CLAM-Verdict: legit
X-CLAM-Score: ??
X-CLAM-Description: ??
Received: from bbl2xr12.bbl.ms.philips.com (bbl2xr12.bbl.ms.philips.com [130.143.222.238])
        by mail.bbl.ms.philips.com (Postfix) with ESMTP id 71C921832D3;
        Wed, 22 Jun 2022 16:49:16 +0200 (CEST)
Received: by bbl2xr12.bbl.ms.philips.com (Postfix, from userid 1876)
        id 6F0902A0010; Wed, 22 Jun 2022 16:49:16 +0200 (CEST)
From:   Julian Haller <jhaller@bbl.ms.philips.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Haller <julian.haller@philips.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Subject: [PATCH 5.4 2/2] thermal/drivers/thermal_hwmon: Use hwmon_device_register_for_thermal()
Date:   Wed, 22 Jun 2022 16:49:02 +0200
Message-Id: <20220622144902.2954712-2-jhaller@bbl.ms.philips.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220622144902.2954712-1-jhaller@bbl.ms.philips.com>
References: <20220622144902.2954712-1-jhaller@bbl.ms.philips.com>
Reply-To: Julian Haller <julian.haller@philips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 0f346c7b-17d5-44fa-121f-08da545e61b4
X-MS-TrafficTypeDiagnostic: DBBP122MB0249:EE_
X-Microsoft-Antispam-PRVS: <DBBP122MB0249C39A69F6C0911CF46153C4B29@DBBP122MB0249.EURP122.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Npg+Hcj0J8CoXsXxZkNBmZ3J9FSVRbQr4zuAI/g6MO5UrYEVbsG6V3DT0aGe3l8cE5Va29XBGbBQvg9NaIfNMEcQ0ujUA6TOcXU72Oa9ou/kHR90f2KpPdV9BpB9iem6HH/ZHQNM/OFX0XLHH+BPR64XGN3IAXuNoO2nm2Ks+zEmFmOFi+jKkFLCc1KNYbH6VseV059ku5NgRhMiSgfNiIaDTkTsrz3REWvXuQgdTlyyUpVeePzEoxRUDHrSWBJOS74PJkcTb0Wfjew/Obi09ZLxK1mQ15W6o6PO7GCvw4YCtfd/udrBXm0ytzHJu8lcCm/7sX9qPZCIVc/C77vDPsX8mob1uuFHzdCiwRlX7weHZGTNtmJljg2cU/+4McqzkZBp4V0LtZ/3ja4MZeyz66GzT/svw4iz+LF2jSmvxR/M/SqnFuLPhSPXRifYQznPJeKKO0vsYHNYddPNFGq20UvHK/bNlgVF6n+crPTFUjheOy+Vg2XuEI1MQZwQLY+Ugfw2KXvQKYC5Q2GM2jsyeLwpv8Av9EbDYR3GIb4HmzT3aZscDoaUsI1NoOJF7bgkBtdei/ge9bggU5IVZryfQQSwcEe/a2npvcqxlR9GhzZJlNq++OYRnNh916j2PsD6/XWp4438cEe/eJUFYva6tT/c4ZbUeX1EJodg/tS7b2GH+m0UeLvdFqHDSV+tPdc2OwQvOSv+YzlqSI9qtzP3ynUivkofYRN9861PrYfwA7ANubkrU+0XYj/TRnzPvTFMlEtxK6MOCBZOcqp+LxQSqw==
X-Forefront-Antispam-Report: CIP:212.159.232.72;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:ext-eur1.smtp.philips.com;PTR:ext-eur1.smtp.philips.com;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(396003)(36840700001)(40470700004)(46966006)(1076003)(7596003)(186003)(83380400001)(7636003)(120186005)(36860700001)(82310400005)(40480700001)(336012)(47076005)(82740400003)(426003)(356005)(82960400001)(54906003)(2616005)(41300700001)(316002)(4326008)(8936002)(86362001)(5660300002)(6666004)(42186006)(70586007)(26005)(6266002)(70206006)(40460700003)(8676002)(478600001)(2906002);DIR:OUT;SFP:1102;
X-OriginatorOrg: ms.philips.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 14:49:16.8303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f346c7b-17d5-44fa-121f-08da545e61b4
X-MS-Exchange-CrossTenant-Id: 1a407a2d-7675-4d17-8692-b3ac285306e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1a407a2d-7675-4d17-8692-b3ac285306e4;Ip=[212.159.232.72];Helo=[ext-eur1.smtp.philips.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT038.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBP122MB0249
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ upstream commit 87743bcf08072b3e1952a0bf5524b2833e667b4c ]

The thermal subsystem registers a hwmon device without providing chip
information or sysfs attribute groups. While undesirable, it would be
difficult to change. On the other side, it abuses the
hwmon_device_register_with_info API by not providing that information.
Use new API specifically created for the thermal subsystem instead to
let us enforce the 'chip' parameter for other callers of
hwmon_device_register_with_info().

Acked-by: Rafael J . Wysocki <rafael@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/thermal/thermal_hwmon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_hwmon.c b/drivers/thermal/thermal_hwmon.c
index dd5d8ee37928..b3b229421936 100644
--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -147,8 +147,8 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	INIT_LIST_HEAD(&hwmon->tz_list);
 	strlcpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
 	strreplace(hwmon->type, '-', '_');
-	hwmon->device = hwmon_device_register_with_info(&tz->device, hwmon->type,
-							hwmon, NULL, NULL);
+	hwmon->device = hwmon_device_register_for_thermal(&tz->device,
+							  hwmon->type, hwmon);
 	if (IS_ERR(hwmon->device)) {
 		result = PTR_ERR(hwmon->device);
 		goto free_mem;
-- 
2.25.1

