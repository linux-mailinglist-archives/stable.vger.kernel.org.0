Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDE48F1C0
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 19:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731854AbfHOROi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 13:14:38 -0400
Received: from mail-ed1-f100.google.com ([209.85.208.100]:46292 "EHLO
        mail-ed1-f100.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731822AbfHOROi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 13:14:38 -0400
Received: by mail-ed1-f100.google.com with SMTP id z51so2673341edz.13
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 10:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:message-id:date;
        bh=STOMTB8soQ9SpdsHI1kcwCTKID5AQX15fSXLD/Rbf0M=;
        b=Fd71TvFJolqh1gJmvhyNNiUoXLY7/v0V6VTP0c4cZjCJdRHjaGLhca7lezLQ2UEoN5
         eO/feafkOHNEDvGaSx4alxTM61shuwQlQJf3Y4KItJSDSTVtpvOk2put9fuU5PObHHOj
         dx7LzXfGjSkBhcJqLuw1dOevUelQOnXsCMq6wOOs1bxZ5kBG+V4Mn7+rsE76l6zyy2DT
         VFW0CuY3+8ThS7YNjbA4nrZZQMzVeMURTYgvQaNHsoESv+TXOBzCOtflshNLBvLOFOAc
         0poDJsyR1AwsE1QNVROsmh4/GNZjsgvfs13mZjolXEIBmKhQ1x46UwPFAOOkBAkdTB0y
         Yt/g==
X-Gm-Message-State: APjAAAXHaBvsocEj+S4S4GhIflyXvLwGYFiaV2YZ/ttzt5ExU3c7Ycff
        9d4z7DUj/yI/Dc9oFaI5tuj1mtnF+cF+atIWqUQkMtpAOkyooLyLXQmk0HjrO+VKpg==
X-Google-Smtp-Source: APXvYqzyLgL1YBE8FNASctPwC+Lz8lFYO0GlBacef5FmFcI+vyr96Ej3Sj0TANIE49KimsRnjlx4FWa+dJ98
X-Received: by 2002:a50:ba81:: with SMTP id x1mr6456670ede.257.1565889276186;
        Thu, 15 Aug 2019 10:14:36 -0700 (PDT)
Received: from heliosphere.sirena.org.uk (heliosphere.sirena.org.uk. [2a01:7e01::f03c:91ff:fed4:a3b6])
        by smtp-relay.gmail.com with ESMTPS id m17sm21059ejc.94.2019.08.15.10.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 10:14:36 -0700 (PDT)
X-Relaying-Domain: sirena.org.uk
Received: from ypsilon.sirena.org.uk ([2001:470:1f1d:6b5::7])
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1hyJKd-000531-Qb; Thu, 15 Aug 2019 17:14:35 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 3A8AC2742BC7; Thu, 15 Aug 2019 18:14:35 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Andreas Kemnade <andreas@kemnade.info>
Cc:     Adam Ford <aford173@gmail.com>, broonie@kernel.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-pm@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, nm@ti.com, sboyd@kernel.org,
        stable@vger.kernel.org, tony@atomide.com, vireshk@kernel.org
Subject: Applied "regulator: twl: voltage lists for vdd1/2 on twl4030" to the regulator tree
In-Reply-To: <20190814214319.24087-1-andreas@kemnade.info>
X-Patchwork-Hint: ignore
Message-Id: <20190815171435.3A8AC2742BC7@ypsilon.sirena.org.uk>
Date:   Thu, 15 Aug 2019 18:14:35 +0100 (BST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   regulator: twl: voltage lists for vdd1/2 on twl4030

has been applied to the regulator tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-5.3

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From 3829100a63724f6dbf264b2a7f06e7f638ed952d Mon Sep 17 00:00:00 2001
From: Andreas Kemnade <andreas@kemnade.info>
Date: Wed, 14 Aug 2019 23:43:19 +0200
Subject: [PATCH] regulator: twl: voltage lists for vdd1/2 on twl4030

_opp_supported_by_regulators() wrongly ignored errors from
regulator_is_supported_voltage(), so it considered errors as
success. Since
commit 498209445124 ("regulator: core: simplify return value on suported_voltage")
regulator_is_supported_voltage() returns a real boolean, so
errors make _opp_supported_by_regulators() return false.

That reveals a problem with the declaration of the VDD1/2
regulators on twl4030.
The VDD1/VDD2 regulators on twl4030 are neither defined with
voltage lists nor with the continuous flag set, so
regulator_is_supported_voltage() returns false and an error
before above mentioned commit (which was considered success)
The result is that after the above mentioned commit cpufreq
does not work properly e.g. dm3730.

[    2.490997] core: _opp_supported_by_regulators: OPP minuV: 1012500 maxuV: 1012500, not supported by regulator
[    2.501617] cpu cpu0: _opp_add: OPP not supported by regulators (300000000)
[    2.509246] core: _opp_supported_by_regulators: OPP minuV: 1200000 maxuV: 1200000, not supported by regulator
[    2.519775] cpu cpu0: _opp_add: OPP not supported by regulators (600000000)
[    2.527313] core: _opp_supported_by_regulators: OPP minuV: 1325000 maxuV: 1325000, not supported by regulator
[    2.537750] cpu cpu0: _opp_add: OPP not supported by regulators (800000000)

The patch fixes declaration of VDD1/2 regulators by
adding proper voltage lists.

Fixes: 498209445124 ("regulator: core: simplify return value on suported_voltage")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Tested-by: Adam Ford <aford173@gmail.com> #logicpd-torpedo-37xx-devkit
Link: https://lore.kernel.org/r/20190814214319.24087-1-andreas@kemnade.info
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/regulator/twl-regulator.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 6fa15b2d6fb3..866b4dd01da9 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -359,6 +359,17 @@ static const u16 VINTANA2_VSEL_table[] = {
 	2500, 2750,
 };
 
+/* 600mV to 1450mV in 12.5 mV steps */
+static const struct regulator_linear_range VDD1_ranges[] = {
+	REGULATOR_LINEAR_RANGE(600000, 0, 68, 12500)
+};
+
+/* 600mV to 1450mV in 12.5 mV steps, everything above = 1500mV */
+static const struct regulator_linear_range VDD2_ranges[] = {
+	REGULATOR_LINEAR_RANGE(600000, 0, 68, 12500),
+	REGULATOR_LINEAR_RANGE(1500000, 69, 69, 12500)
+};
+
 static int twl4030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
@@ -427,6 +438,8 @@ static int twl4030smps_get_voltage(struct regulator_dev *rdev)
 }
 
 static const struct regulator_ops twl4030smps_ops = {
+	.list_voltage   = regulator_list_voltage_linear_range,
+
 	.set_voltage	= twl4030smps_set_voltage,
 	.get_voltage	= twl4030smps_get_voltage,
 };
@@ -466,7 +479,8 @@ static const struct twlreg_info TWL4030_INFO_##label = { \
 		}, \
 	}
 
-#define TWL4030_ADJUSTABLE_SMPS(label, offset, num, turnon_delay, remap_conf) \
+#define TWL4030_ADJUSTABLE_SMPS(label, offset, num, turnon_delay, remap_conf, \
+		n_volt) \
 static const struct twlreg_info TWL4030_INFO_##label = { \
 	.base = offset, \
 	.id = num, \
@@ -479,6 +493,9 @@ static const struct twlreg_info TWL4030_INFO_##label = { \
 		.owner = THIS_MODULE, \
 		.enable_time = turnon_delay, \
 		.of_map_mode = twl4030reg_map_mode, \
+		.n_voltages = n_volt, \
+		.n_linear_ranges = ARRAY_SIZE(label ## _ranges), \
+		.linear_ranges = label ## _ranges, \
 		}, \
 	}
 
@@ -518,8 +535,8 @@ TWL4030_ADJUSTABLE_LDO(VSIM, 0x37, 9, 100, 0x00);
 TWL4030_ADJUSTABLE_LDO(VDAC, 0x3b, 10, 100, 0x08);
 TWL4030_ADJUSTABLE_LDO(VINTANA2, 0x43, 12, 100, 0x08);
 TWL4030_ADJUSTABLE_LDO(VIO, 0x4b, 14, 1000, 0x08);
-TWL4030_ADJUSTABLE_SMPS(VDD1, 0x55, 15, 1000, 0x08);
-TWL4030_ADJUSTABLE_SMPS(VDD2, 0x63, 16, 1000, 0x08);
+TWL4030_ADJUSTABLE_SMPS(VDD1, 0x55, 15, 1000, 0x08, 68);
+TWL4030_ADJUSTABLE_SMPS(VDD2, 0x63, 16, 1000, 0x08, 69);
 /* VUSBCP is managed *only* by the USB subchip */
 TWL4030_FIXED_LDO(VINTANA1, 0x3f, 1500, 11, 100, 0x08);
 TWL4030_FIXED_LDO(VINTDIG, 0x47, 1500, 13, 100, 0x08);
-- 
2.20.1

