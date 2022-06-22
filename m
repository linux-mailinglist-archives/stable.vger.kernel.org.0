Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDB9554DDA
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 16:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357785AbiFVOtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 10:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358772AbiFVOte (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 10:49:34 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70093.outbound.protection.outlook.com [40.107.7.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EDB3E5CC
        for <stable@vger.kernel.org>; Wed, 22 Jun 2022 07:49:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTi7sfkXHLXqSpc+4Wp09epE/pPMjj1/8SKMuKD9o229PhVL5YX2oI3GYMzLDNhrCYApW/l58vYyG1/Oso2TlFBJliBzFfOOwI7z4apFCNE7BLMuT5CCYRv5dES5epqUXRqVZsgw0KMU12UmFlGLtOAFiSWWHwqf1KsqYnKYNUbFVP7z074vrG0SsMd2aFIUtvQ06pQL1D2Snw6mZdqXu3RbjHP6TCSUjYpY45SsyOzTN+0WZBAsQ2YQyw8xBqDcYbh87E3kK1IdQFZAGH5DUCRSho4VYO3KZK2yBKQq29HBvajVJRZYMhCzoMneo0rVy/2w1Hum9SvLB00aMQQcRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P8OzlpzFHYKiG29ow9tar4xUHsLqxUPNZYw6ztbXhGQ=;
 b=e4a5Cxmj1zTzABHH9ucAdcuwK3RSYBoGEBFne6KTw1VLiqQ0hzvP6t1sB7yO0J+fBSPLmnrN78CsNCiJdkp0GH4uq3Wh9k58eS84njChj4PLMVMKAqdTkxAIRtN0hA69BS4VauYxHTfVdro5bSoen+vYTUqaa5tOXEadBmzcnVijQAUzIRNZq+evKFGXAs6MLtJlX4k4NWLr21QiYa3V2noJAhWC7OG92uzIEwdNxYyxTs2C7tc4Xj6rpRQzFFiQHLCt1f7Nd0yZuTHAuLQIR+1DlWw+PFLuC29DZUx16xFSFQR7Q1MPbS5Q+DdAuNFoP+4Sv0p9bsWcpcPvBHrwlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 212.159.232.72) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=bbl.ms.philips.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=bbl.ms.philips.com; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Philips.onmicrosoft.com; s=selector2-Philips-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8OzlpzFHYKiG29ow9tar4xUHsLqxUPNZYw6ztbXhGQ=;
 b=DRC8iINYPWWhhDbLAafM2yfWjhpjchND3Pi3DWFD+UkEJ8/kGcgXdG7/2Yi5Twsw5WkQZSi6u49EpFXfLovkmt/onqUm1NOmKii7B7RiuVsW+Whi2dI2SjUpyQJvc0FpjDGfvYfozQ1lIxynsjnvWAixAqI9Xx/V5Se6m1WrdSI=
Received: from OS6P279CA0024.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:33::11)
 by VI1P122MB0222.EURP122.PROD.OUTLOOK.COM (2603:10a6:800:176::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Wed, 22 Jun
 2022 14:49:14 +0000
Received: from HE1EUR01FT081.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:e10:33:cafe::88) by OS6P279CA0024.outlook.office365.com
 (2603:10a6:e10:33::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Wed, 22 Jun 2022 14:49:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 212.159.232.72)
 smtp.mailfrom=bbl.ms.philips.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=bbl.ms.philips.com;
Received-SPF: Pass (protection.outlook.com: domain of bbl.ms.philips.com
 designates 212.159.232.72 as permitted sender)
 receiver=protection.outlook.com; client-ip=212.159.232.72;
 helo=ext-eur1.smtp.philips.com; pr=C
Received: from ext-eur1.smtp.philips.com (212.159.232.72) by
 HE1EUR01FT081.mail.protection.outlook.com (10.152.1.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15 via Frontend Transport; Wed, 22 Jun 2022 14:49:13 +0000
Received: from smtprelay-eur1.philips.com ([130.144.57.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 256/256 bits)
        (Client did not present a certificate)
        by ext-eur1.smtp.philips.com with ESMTP
        id 3oFAoYSRbl9Zi41fNoHJ89; Wed, 22 Jun 2022 16:49:13 +0200
Received: from mail.bbl.ms.philips.com ([130.143.87.230])
        by smtprelay-eur1.philips.com with ESMTP
        id 41fNoElZZK1kB41fNoyNj0; Wed, 22 Jun 2022 16:49:13 +0200
X-CLAM-Verdict: legit
X-CLAM-Score: ??
X-CLAM-Description: ??
Received: from bbl2xr12.bbl.ms.philips.com (bbl2xr12.bbl.ms.philips.com [130.143.222.238])
        by mail.bbl.ms.philips.com (Postfix) with ESMTP id 67C631832D3;
        Wed, 22 Jun 2022 16:49:13 +0200 (CEST)
Received: by bbl2xr12.bbl.ms.philips.com (Postfix, from userid 1876)
        id 6154A2A0010; Wed, 22 Jun 2022 16:49:13 +0200 (CEST)
From:   Julian Haller <jhaller@bbl.ms.philips.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Haller <julian.haller@philips.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Subject: [PATCH 5.4 1/2] hwmon: Introduce hwmon_device_register_for_thermal
Date:   Wed, 22 Jun 2022 16:49:01 +0200
Message-Id: <20220622144902.2954712-1-jhaller@bbl.ms.philips.com>
X-Mailer: git-send-email 2.25.1
Reply-To: Julian Haller <julian.haller@philips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 6e9ad83d-39d7-4b6a-d911-08da545e5fdf
X-MS-TrafficTypeDiagnostic: VI1P122MB0222:EE_
X-Microsoft-Antispam-PRVS: <VI1P122MB0222484099287CADF446DEECC4B29@VI1P122MB0222.EURP122.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k8EHbeCdvqcJB3ABbrviBe/M7nIPU63tSuYM9S5dTI2M1juKtVLpT+r9ylOO3szwR9+H0znwEVgMoJ0DWXgc1HkKrgWImwJhG8qkYIhV6XhWZc6mq237SWLhlj7F8cZUIXOJGjKu6tWEnihRVA5ozN5BsLSvzwE5Qp3xRVg6dyxz3yN+KsrvD5NnnHEhNIwMrJeHjAMK+OlK2lCM4jatIGtr61UbFFnBuQ1IUWtzAN5Ay1N5YkHZGktWyKHg7Q2dmfGCEquU3Fq1y43G95XllMOVIB5NkrEQFV2fbaCGfRlWzhQiMDbvw64Z4KQbwSligE6xXaGbz4xPbR+zW6xn9oBuvmcwqvOdygj9YoG2Ep9bhsDRDYwXBAQKoWRF8WJ75HHXnHWZBLM2YBUWyU4X/abSGaT6QXQbQlCSbp8CIizHjSTaJgLs/sIpHLYed4orTT0KM1OsO5hBXQs+u9OS/IGF7ctcJ4jYbgpp35jb79bhGQc8VCZAVqxswRkgzrD6O5IG1D05J2VsMPDEk1hd4t30YbqqPwfC26PFCPTqTYHhQqoFgX20d5PiaQddul8qFNj9Xd+RBWScB9Sv3T9mhRBFHWEIVTmd9uafExqANP+bgSBFGOAo3e798s3c89DKpuxdAwJ9/P/pgWggfcpN/dU7IHfUA+YikE5Gnxu7eX/lQghmETLE4haTagh6jh7E5xD/o4gnJjXDGOWh/regtV2c7xP7nkwkTe3ztb3vmSFYSk8G226Xl4iHDmpqAPc2/NSUkftSJ9vaoeBg4EBdwA==
X-Forefront-Antispam-Report: CIP:212.159.232.72;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:ext-eur1.smtp.philips.com;PTR:ext-eur1.smtp.philips.com;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(376002)(136003)(36840700001)(46966006)(40470700004)(8676002)(70586007)(26005)(41300700001)(70206006)(82310400005)(6666004)(6266002)(40460700003)(316002)(478600001)(86362001)(42186006)(54906003)(36860700001)(120186005)(82960400001)(356005)(186003)(2616005)(8936002)(47076005)(82740400003)(7636003)(1076003)(7596003)(5660300002)(40480700001)(426003)(336012)(4326008)(2906002);DIR:OUT;SFP:1102;
X-OriginatorOrg: ms.philips.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 14:49:13.7573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e9ad83d-39d7-4b6a-d911-08da545e5fdf
X-MS-Exchange-CrossTenant-Id: 1a407a2d-7675-4d17-8692-b3ac285306e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1a407a2d-7675-4d17-8692-b3ac285306e4;Ip=[212.159.232.72];Helo=[ext-eur1.smtp.philips.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT081.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P122MB0222
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ upstream commit e5d21072054fbadf41cd56062a3a14e447e8c22b ]

The thermal subsystem registers a hwmon driver without providing
chip or sysfs group information. This is for legacy reasons and
would be difficult to change. At the same time, we want to enforce
that chip information is provided when registering a hwmon device
using hwmon_device_register_with_info(). To enable this, introduce
a special API for use only by the thermal subsystem.

Acked-by: Rafael J . Wysocki <rafael@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/hwmon.c | 25 +++++++++++++++++++++++++
 include/linux/hwmon.h |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index c73b93b9bb87..e8a9955e3683 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -743,6 +743,31 @@ hwmon_device_register_with_info(struct device *dev, const char *name,
 }
 EXPORT_SYMBOL_GPL(hwmon_device_register_with_info);
 
+/**
+ * hwmon_device_register_for_thermal - register hwmon device for thermal subsystem
+ * @dev: the parent device
+ * @name: hwmon name attribute
+ * @drvdata: driver data to attach to created device
+ *
+ * The use of this function is restricted. It is provided for legacy reasons
+ * and must only be called from the thermal subsystem.
+ *
+ * hwmon_device_unregister() must be called when the device is no
+ * longer needed.
+ *
+ * Returns the pointer to the new device.
+ */
+struct device *
+hwmon_device_register_for_thermal(struct device *dev, const char *name,
+				  void *drvdata)
+{
+	if (!name || !dev)
+		return ERR_PTR(-EINVAL);
+
+	return __hwmon_device_register(dev, name, drvdata, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(hwmon_device_register_for_thermal);
+
 /**
  * hwmon_device_register - register w/ hwmon
  * @dev: the device to register
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index 72579168189d..104c492959b9 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -408,6 +408,9 @@ hwmon_device_register_with_info(struct device *dev,
 				const struct hwmon_chip_info *info,
 				const struct attribute_group **extra_groups);
 struct device *
+hwmon_device_register_for_thermal(struct device *dev, const char *name,
+				  void *drvdata);
+struct device *
 devm_hwmon_device_register_with_info(struct device *dev,
 				const char *name, void *drvdata,
 				const struct hwmon_chip_info *info,
-- 
2.25.1

