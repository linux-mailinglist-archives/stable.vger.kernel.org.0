Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D594C5B7090
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbiIMO3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbiIMO2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:28:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAC563F2B;
        Tue, 13 Sep 2022 07:17:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22833614B4;
        Tue, 13 Sep 2022 14:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D553C433D6;
        Tue, 13 Sep 2022 14:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078554;
        bh=hKMAjFK4zx/IAfSMZtkx0sMQMfAwB+Yxy4VS+qaJ3uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Is0X7tN4qqa32ashmQRHOfd6QcgyxG1gfyQ+cVXbJ7NKLpB9RXVlXnPJ1aOvHL4+s
         yPaPkbRFxxwOhuDhAGpjtoP01unOoUxyciO5CITfKGqShl9Bb9Epuve/OzHMjYkO7N
         7mn2F8yPm5TNdMGbXDYhVSX1NBb6YQZCyPqLC4jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Urs Schroffenegger <nabajour@lampshade.ch>,
        Eugene Shalygin <eugene.shalygin@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 185/192] hwmon: (asus-ec-sensors) add definitions for ROG ZENITH II EXTREME
Date:   Tue, 13 Sep 2022 16:04:51 +0200
Message-Id: <20220913140419.276069175@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Urs Schroffenegger <nabajour@lampshade.ch>

[ Upstream commit 9992b19d756ab8f0889fcaf3e71ff93852e74694 ]

Add definitions for ROG ZENITH II EXTREME and some unknown yet
temperature sensors in the second EC bank. Details are available at
[1, 2].

[1] https://github.com/zeule/asus-ec-sensors/pull/26
[2] https://github.com/zeule/asus-ec-sensors/issues/16

Signed-off-by: Urs Schroffenegger <nabajour@lampshade.ch>
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20220710202639.1812058-2-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 88700d1396ba ("hwmon: (asus-ec-sensors) autoload module via DMI data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/asus_ec_sensors.rst |  1 +
 drivers/hwmon/asus-ec-sensors.c         | 47 +++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/Documentation/hwmon/asus_ec_sensors.rst b/Documentation/hwmon/asus_ec_sensors.rst
index 1e40c123db777..02f4ad314a1eb 100644
--- a/Documentation/hwmon/asus_ec_sensors.rst
+++ b/Documentation/hwmon/asus_ec_sensors.rst
@@ -22,6 +22,7 @@ Supported boards:
  * ROG STRIX X570-F GAMING
  * ROG STRIX X570-I GAMING
  * ROG STRIX Z690-A GAMING WIFI D4
+ * ROG ZENITH II EXTREME
 
 Authors:
     - Eugene Shalygin <eugene.shalygin@gmail.com>
diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 0749cd023a323..61a4684fc020e 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -56,6 +56,8 @@ static char *mutex_path_override;
 
 #define ASUS_HW_ACCESS_MUTEX_RMTW_ASMX	"\\RMTW.ASMX"
 
+#define ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0 "\\_SB_.PCI0.SBRG.SIO1.MUT0"
+
 #define MAX_IDENTICAL_BOARD_VARIATIONS	3
 
 /* Moniker for the ACPI global lock (':' is not allowed in ASL identifiers) */
@@ -121,6 +123,18 @@ enum ec_sensors {
 	ec_sensor_temp_water_in,
 	/* "Water_Out" temperature sensor reading [℃] */
 	ec_sensor_temp_water_out,
+	/* "Water_Block_In" temperature sensor reading [℃] */
+	ec_sensor_temp_water_block_in,
+	/* "Water_Block_Out" temperature sensor reading [℃] */
+	ec_sensor_temp_water_block_out,
+	/* "T_sensor_2" temperature sensor reading [℃] */
+	ec_sensor_temp_t_sensor_2,
+	/* "Extra_1" temperature sensor reading [℃] */
+	ec_sensor_temp_sensor_extra_1,
+	/* "Extra_2" temperature sensor reading [℃] */
+	ec_sensor_temp_sensor_extra_2,
+	/* "Extra_3" temperature sensor reading [℃] */
+	ec_sensor_temp_sensor_extra_3,
 };
 
 #define SENSOR_TEMP_CHIPSET BIT(ec_sensor_temp_chipset)
@@ -136,6 +150,12 @@ enum ec_sensors {
 #define SENSOR_CURR_CPU BIT(ec_sensor_curr_cpu)
 #define SENSOR_TEMP_WATER_IN BIT(ec_sensor_temp_water_in)
 #define SENSOR_TEMP_WATER_OUT BIT(ec_sensor_temp_water_out)
+#define SENSOR_TEMP_WATER_BLOCK_IN BIT(ec_sensor_temp_water_block_in)
+#define SENSOR_TEMP_WATER_BLOCK_OUT BIT(ec_sensor_temp_water_block_out)
+#define SENSOR_TEMP_T_SENSOR_2 BIT(ec_sensor_temp_t_sensor_2)
+#define SENSOR_TEMP_SENSOR_EXTRA_1 BIT(ec_sensor_temp_sensor_extra_1)
+#define SENSOR_TEMP_SENSOR_EXTRA_2 BIT(ec_sensor_temp_sensor_extra_2)
+#define SENSOR_TEMP_SENSOR_EXTRA_3 BIT(ec_sensor_temp_sensor_extra_3)
 
 enum board_family {
 	family_unknown,
@@ -199,6 +219,18 @@ static const struct ec_sensor_info sensors_family_amd_500[] = {
 		EC_SENSOR("Water_In", hwmon_temp, 1, 0x01, 0x00),
 	[ec_sensor_temp_water_out] =
 		EC_SENSOR("Water_Out", hwmon_temp, 1, 0x01, 0x01),
+	[ec_sensor_temp_water_block_in] =
+		EC_SENSOR("Water_Block_In", hwmon_temp, 1, 0x01, 0x02),
+	[ec_sensor_temp_water_block_out] =
+		EC_SENSOR("Water_Block_Out", hwmon_temp, 1, 0x01, 0x03),
+	[ec_sensor_temp_sensor_extra_1] =
+		EC_SENSOR("Extra_1", hwmon_temp, 1, 0x01, 0x09),
+	[ec_sensor_temp_t_sensor_2] =
+		EC_SENSOR("T_sensor_2", hwmon_temp, 1, 0x01, 0x0a),
+	[ec_sensor_temp_sensor_extra_2] =
+		EC_SENSOR("Extra_2", hwmon_temp, 1, 0x01, 0x0b),
+	[ec_sensor_temp_sensor_extra_3] =
+		EC_SENSOR("Extra_3", hwmon_temp, 1, 0x01, 0x0c),
 };
 
 static const struct ec_sensor_info sensors_family_intel_300[] = {
@@ -231,6 +263,9 @@ static const struct ec_sensor_info sensors_family_intel_600[] = {
 #define SENSOR_SET_TEMP_CHIPSET_CPU_MB                                         \
 	(SENSOR_TEMP_CHIPSET | SENSOR_TEMP_CPU | SENSOR_TEMP_MB)
 #define SENSOR_SET_TEMP_WATER (SENSOR_TEMP_WATER_IN | SENSOR_TEMP_WATER_OUT)
+#define SENSOR_SET_WATER_BLOCK                                                 \
+	(SENSOR_TEMP_WATER_BLOCK_IN | SENSOR_TEMP_WATER_BLOCK_OUT)
+
 
 struct ec_board_info {
 	const char *board_names[MAX_IDENTICAL_BOARD_VARIATIONS];
@@ -379,6 +414,18 @@ static const struct ec_board_info board_info[] = {
 		.mutex_path = ASUS_HW_ACCESS_MUTEX_RMTW_ASMX,
 		.family = family_intel_600_series,
 	},
+	{
+		.board_names = {"ROG ZENITH II EXTREME"},
+		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB | SENSOR_TEMP_T_SENSOR |
+			SENSOR_TEMP_VRM | SENSOR_SET_TEMP_WATER |
+			SENSOR_FAN_CPU_OPT | SENSOR_FAN_CHIPSET | SENSOR_FAN_VRM_HS |
+			SENSOR_FAN_WATER_FLOW | SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE |
+			SENSOR_SET_WATER_BLOCK |
+			SENSOR_TEMP_T_SENSOR_2 | SENSOR_TEMP_SENSOR_EXTRA_1 |
+			SENSOR_TEMP_SENSOR_EXTRA_2 | SENSOR_TEMP_SENSOR_EXTRA_3,
+		.mutex_path = ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0,
+		.family = family_amd_500_series,
+	},
 	{}
 };
 
-- 
2.35.1



