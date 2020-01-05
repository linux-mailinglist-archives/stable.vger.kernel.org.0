Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC1213056A
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 02:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgAEBYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 20:24:19 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:57263 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbgAEBYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 20:24:18 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id A4FFF6BA3;
        Sat,  4 Jan 2020 20:24:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 04 Jan 2020 20:24:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=i9U9QABLYUJVc
        RUEMaC1sX18u3bMrWhbzdwLPT/XxuQ=; b=cCm48MGnRDJGDgnBFe+6YfL49S2ES
        PDNt4lS6MAUOAIkHj0H75nxOxqQUQnrK3l5g8WXjpJaQTlRXaRkt0LUnlmxrFNAI
        EDsVCM64h7Ah859EE1uMaIvU4M7CSzME0gD26PI6ba0+ee5j0//eb9+LJgOwq3uR
        KW+VPEygn4b8PTxYMnY65KkpbJKPe9H2q3ssAbx4QOLgUVei51/il9c3QQy/9We7
        V63lDd03wtt9fQS/KAuwVCAt6ZBq1n+Z+svyrqgssFvMJ1p6mPRSWvs+p49oe+aM
        VZh2kswgIjrXgsVm81lZs7hRwiMjftIy1QiJ1W0HxaKHixj8/6Ka7vYyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=i9U9QABLYUJVcRUEMaC1sX18u3bMrWhbzdwLPT/XxuQ=; b=xvwRI77p
        m0tSOjEby4PXvJOeAdnCPexlXOyxq3DqqKAHLAdprilfKfl/nwAYLhEAqWfu9TVK
        FpYlTCY44aBSl4j6sMOWEEOdpidBecLPGryvxbCPOuyyrQbIIl9q43UoLa9AdEPM
        yzZ6CTeqdi6CUJMOgpX66FBg18A8IQlrUIRAjAzN4wHrnJqYHI977bDjX/+0wCo1
        KuoB1L75KCZzxJd4p2xqztNtU18YPXoEv47aoXAOtKHYFayziHeEhsL89yjmN2K2
        PkYmoPIcU3Kq/6lL5SS69qvLi65vFLu2cD1GfpSOzj2zZSzI8Amteg4fi3W257Hb
        oNLNIapANrLk3Q==
X-ME-Sender: <xms:wToRXjCAq0SiFq3yYTVqOKtmKhMnF1_degg_UcviID60Bumkx4FtNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegiedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucfkph
    epjedtrddufeehrddugeekrdduhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghm
    uhgvlhesshhhohhllhgrnhgurdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:wToRXiepIgRSyjigoolgyclaVvXDSlhZ7lnmly2oRALn3CR1Ol8QYQ>
    <xmx:wToRXnU1Kw9Mba0NoEvrtQMvp0HNN2JaHaNb-1uQ78I15XkHUUjq-w>
    <xmx:wToRXo770i-vkqvWDSEM2kwAJsg4SFb3AlFLOmetFZi8CIAereM-Tg>
    <xmx:wToRXlAh1OzjURRKZTEq-MYHnyMBQsboN3XWEsxVDN75RCrQUtOFdQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id E9B778005A;
        Sat,  4 Jan 2020 20:24:16 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Chen-Yu Tsai <wens@csie.org>, Sebastian Reichel <sre@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Oskari Lemmela <oskari@lemmela.net>,
        Quentin Schulz <quentin.schulz@bootlin.com>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Samuel Holland <samuel@sholland.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/9] power: supply: axp20x_ac_power: Fix reporting online status
Date:   Sat,  4 Jan 2020 19:24:09 -0600
Message-Id: <20200105012416.23296-3-samuel@sholland.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200105012416.23296-1-samuel@sholland.org>
References: <20200105012416.23296-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

AXP803/AXP813 have a flag that enables/disables the AC power supply
input. This flag does not affect the status bits in PWR_INPUT_STATUS.
Its effect can be verified by checking the battery charge/discharge
state (bit 2 of PWR_INPUT_STATUS), or by examining the current draw on
the AC input.

Take this flag into account when getting the ONLINE property of the AC
input, on PMICs where this flag is present.

Fixes: 7693b5643fd2 ("power: supply: add AC power supply driver for AXP813")
Cc: stable@vger.kernel.org
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/power/supply/axp20x_ac_power.c | 31 +++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/power/supply/axp20x_ac_power.c b/drivers/power/supply/axp20x_ac_power.c
index 0d34a932b6d5..ca0a28f72a27 100644
--- a/drivers/power/supply/axp20x_ac_power.c
+++ b/drivers/power/supply/axp20x_ac_power.c
@@ -23,6 +23,8 @@
 #define AXP20X_PWR_STATUS_ACIN_PRESENT	BIT(7)
 #define AXP20X_PWR_STATUS_ACIN_AVAIL	BIT(6)
 
+#define AXP813_ACIN_PATH_SEL		BIT(7)
+
 #define AXP813_VHOLD_MASK		GENMASK(5, 3)
 #define AXP813_VHOLD_UV_TO_BIT(x)	((((x) / 100000) - 40) << 3)
 #define AXP813_VHOLD_REG_TO_UV(x)	\
@@ -40,6 +42,7 @@ struct axp20x_ac_power {
 	struct power_supply *supply;
 	struct iio_channel *acin_v;
 	struct iio_channel *acin_i;
+	bool has_acin_path_sel;
 };
 
 static irqreturn_t axp20x_ac_power_irq(int irq, void *devid)
@@ -86,6 +89,17 @@ static int axp20x_ac_power_get_property(struct power_supply *psy,
 			return ret;
 
 		val->intval = !!(reg & AXP20X_PWR_STATUS_ACIN_AVAIL);
+
+		/* ACIN_PATH_SEL disables ACIN even if ACIN_AVAIL is set. */
+		if (power->has_acin_path_sel) {
+			ret = regmap_read(power->regmap, AXP813_ACIN_PATH_CTRL,
+					  &reg);
+			if (ret)
+				return ret;
+
+			val->intval &= !!(reg & AXP813_ACIN_PATH_SEL);
+		}
+
 		return 0;
 
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
@@ -224,21 +238,25 @@ static const struct power_supply_desc axp813_ac_power_desc = {
 struct axp_data {
 	const struct power_supply_desc	*power_desc;
 	bool				acin_adc;
+	bool				acin_path_sel;
 };
 
 static const struct axp_data axp20x_data = {
-	.power_desc = &axp20x_ac_power_desc,
-	.acin_adc = true,
+	.power_desc	= &axp20x_ac_power_desc,
+	.acin_adc	= true,
+	.acin_path_sel	= false,
 };
 
 static const struct axp_data axp22x_data = {
-	.power_desc = &axp22x_ac_power_desc,
-	.acin_adc = false,
+	.power_desc	= &axp22x_ac_power_desc,
+	.acin_adc	= false,
+	.acin_path_sel	= false,
 };
 
 static const struct axp_data axp813_data = {
-	.power_desc = &axp813_ac_power_desc,
-	.acin_adc = false,
+	.power_desc	= &axp813_ac_power_desc,
+	.acin_adc	= false,
+	.acin_path_sel	= true,
 };
 
 static int axp20x_ac_power_probe(struct platform_device *pdev)
@@ -282,6 +300,7 @@ static int axp20x_ac_power_probe(struct platform_device *pdev)
 	}
 
 	power->regmap = dev_get_regmap(pdev->dev.parent, NULL);
+	power->has_acin_path_sel = axp_data->acin_path_sel;
 
 	platform_set_drvdata(pdev, power);
 
-- 
2.23.0

