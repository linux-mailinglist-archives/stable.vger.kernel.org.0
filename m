Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2761389F4
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 04:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbgAMDxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 22:53:13 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53451 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387494AbgAMDxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jan 2020 22:53:13 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 418C421C1E;
        Sun, 12 Jan 2020 22:53:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 12 Jan 2020 22:53:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=m4PaaL1uSYSw4
        MJXUFb/Hne13RaJ0dX5yeTCgehScLE=; b=AatXWb4iAOlWuYpCHWxYKhzBu031b
        a3UcZsvV9x/Qh/JxeSMG4YcukEpYcWMP9o8L5LhENM1ajFowudpTQrQB8qdVvq5j
        TVFKgky1ZUOcWvNphMTbNRvAFyFXI37X2fxCx2GX5iyY15TOG1DO6NXxTFyPVGzF
        04Y7srUIuVFMvsU6zJlPxeVuQc70cUeyKYAjeYDnUdTCUSpQb0PnzvCalAK/I4FM
        awjWbalm6FqfXdSPs88lKvBX2hSWYwoo9U2Rch2N8K++rlRQlzbGUJ5wd1nMM6WY
        nxMnRs2iDm6eEfUMiC0lsxB+mTaIi9PWkdM42Nm9l+pGelh3ufOHWXjoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=m4PaaL1uSYSw4MJXUFb/Hne13RaJ0dX5yeTCgehScLE=; b=gflvmVMs
        2HLOEIj0Fbr+WRqUsM39j/MKmq/8SjUkxlOjZSQNdYCUHH8Bp2YA+AJY6fUCRs6q
        7RP50/tWf4HO7yyhQVk6cOv1uAdt8CEd9Nh79BKzkrqzpQJqAIJcV/WWifN3zLuy
        xGOJYLKGivuJfBButcVpiLvofNzWdLqJdiI3a2eDAcGW9C2wwKtjvOdoQDGaeaDb
        oAgaSX25Vu8OjoYsxOkkZphl33WjKzvtFI5qCU3LDIk0hHU3m3qlFGvYIzPkL5Ff
        eMGcbXf9DABRoPDjuDIeRkY2Sn9otlCXmKD0U7onCj+vKKzH/c7QTMwKowk2JjlW
        pavBcnAFJGxC7Q==
X-ME-Sender: <xms:qOkbXrrCkR29pmi6t3HcTNX-cznYZm7CqFVQTfSev7STqhlh7hzikQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiledgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucfkph
    epjedtrddufeehrddugeekrdduhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghm
    uhgvlhesshhhohhllhgrnhgurdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:qOkbXtUdbMJsqq-W__VU_izvYsEbnIahqnxuMt9W0Grgjb_8KXwNeQ>
    <xmx:qOkbXib-RB1VKU1s_kdEZl8vGjlHYewnkjIV3nzybAjE07Y_0OxT2g>
    <xmx:qOkbXuFdSeTkFzSAAbuQlxOxigCGfc_sxntXYuoroV1tPSqJhBLwXQ>
    <xmx:qOkbXqetzqGkmg42jdwM8jE3fmCiN5IrkwWFR33NaWBSgalU5heQpA>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3A0580062;
        Sun, 12 Jan 2020 22:53:11 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Chen-Yu Tsai <wens@csie.org>, Sebastian Reichel <sre@kernel.org>,
        Oskari Lemmela <oskari@lemmela.net>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Samuel Holland <samuel@sholland.org>,
        stable@vger.kernel.org
Subject: [PATCH v3 1/8] power: supply: axp20x_ac_power: Fix reporting online status
Date:   Sun, 12 Jan 2020 21:53:03 -0600
Message-Id: <20200113035310.18950-2-samuel@sholland.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200113035310.18950-1-samuel@sholland.org>
References: <20200113035310.18950-1-samuel@sholland.org>
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
index 0d34a932b6d5..f74b0556bb6b 100644
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
+		if (val->intval && power->has_acin_path_sel) {
+			ret = regmap_read(power->regmap, AXP813_ACIN_PATH_CTRL,
+					  &reg);
+			if (ret)
+				return ret;
+
+			val->intval = !!(reg & AXP813_ACIN_PATH_SEL);
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

