Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509C63D2D96
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 22:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhGVTlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 15:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhGVTlu (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 22 Jul 2021 15:41:50 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DFFC061575
        for <Stable@vger.kernel.org>; Thu, 22 Jul 2021 13:22:23 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id z8so18092wru.7
        for <Stable@vger.kernel.org>; Thu, 22 Jul 2021 13:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=f0bjo4i4hvUeRx41emkuNSrVsVgHPF3k6b3/H9yltMQ=;
        b=VlHGP5JuPs0MgW/C7s6ShZZ8iRCIiuDLxEiwxjegLoZHyrJKdJW4OxmDi4760l9sLX
         dVL7V0ukh2j76Mm7VqW2h8sUNiz3Jd/RQncRPYXtGBUtOZLfJGoAHGmdPXAjb9CJb3gu
         6heYS1isC+VeEfzigrcjyJ2de2PxJzE8Yg3BZtTSrs+BF0nDfmtlM2dI7UBPi002gw1d
         dI8dVTt5aDt8/NC5drd8lP4Lpmo4jbPza76XY4UfiZls6GJHKaEWACJEFrHwo3AKSA/P
         dAamEhhkQU+jKtvVJjmnnukv09nC+QEnuwz3Tdg7FpVfCts0f+VRELLuRTrHTU1Qt99Q
         hNtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=f0bjo4i4hvUeRx41emkuNSrVsVgHPF3k6b3/H9yltMQ=;
        b=CC7xnanZVsznulM4j/xpcpOjDI4UQ7JrQ10trpEkXFL5xYxw2u2J/E/E3bQ8z9MEK0
         9sJWolqg0WZ1B0h7SDC6xzPe52C02NrcTqd9yPbYT5ECBJPhY1kUm3NtuO3VZX4ku98X
         RsCCwUBL23FUSYXeRdYTjsy0JTN6lG8ezOtYA5kG/uBfX9wuSkiN87/cwN3tVge1ziNT
         cU0xUR6x6W5muSAjhi91B5u5WlDqmCu8r4+MSmAVGhiUNkLtoL0r8c/iuJW1XL1kRO1j
         sdpNajQ29DpZ4MLf4CtZoObEqVR/EKngGxBrA1QIWbzRQleAzJILVDzr99EOj7R+2NYb
         cv2g==
X-Gm-Message-State: AOAM531bc3lPJYX0heDVbFPgFC5orm8Brbe31oGGXo/a9bCNdGamijWB
        h064araiCyERcz+rfhNE0AU=
X-Google-Smtp-Source: ABdhPJzRuxOisuLFQ+Cb2BsIQAGSbRr0vdYwyi4LQcKhA7zSTy4szyYo8pJFUIv7n9M+N1ku7DB3yw==
X-Received: by 2002:a5d:644c:: with SMTP id d12mr1655596wrw.129.1626985342383;
        Thu, 22 Jul 2021 13:22:22 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id r4sm31356321wre.84.2021.07.22.13.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 13:22:21 -0700 (PDT)
Date:   Thu, 22 Jul 2021 21:22:20 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     stephan@gerhold.net, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, linus.walleij@linaro.org, pmeerw@pmeerw.net
Subject: Re: FAILED: patch "[PATCH] iio: accel: bma180: Fix BMA25x bandwidth
 register values" failed to apply to 5.4-stable tree
Message-ID: <YPnTfOMe1xP5p+ly@debian>
References: <1626008487114116@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yuXHB9ceN+H28p7d"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1626008487114116@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yuXHB9ceN+H28p7d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Jul 11, 2021 at 03:01:27PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport along with 9436abc40139 ("iio: accel: bma180: Use
explicit member assignment") which makes the backporting a little easier.
This will apply to all branches till 4.4-stable.


--
Regards
Sudip

--yuXHB9ceN+H28p7d
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-iio-accel-bma180-Use-explicit-member-assignment.patch"

From 1ed1fa336683b5866b1accd67dc5bd126c9d014e Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 11 Dec 2019 22:38:18 +0100
Subject: [PATCH 1/2] iio: accel: bma180: Use explicit member assignment

commit 9436abc40139503a7cea22a96437697d048f31c0 upstream

This uses the C99 explicit .member assignment for the
variant data in struct bma180_part_info. This makes it
easier to understand and add new variants.

Cc: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/iio/accel/bma180.c | 68 ++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 24 deletions(-)

diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index aa301c606346..196111c91627 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -633,32 +633,52 @@ static const struct iio_chan_spec bma250_channels[] = {
 
 static const struct bma180_part_info bma180_part_info[] = {
 	[BMA180] = {
-		bma180_channels, ARRAY_SIZE(bma180_channels),
-		bma180_scale_table, ARRAY_SIZE(bma180_scale_table),
-		bma180_bw_table, ARRAY_SIZE(bma180_bw_table),
-		BMA180_CTRL_REG0, BMA180_RESET_INT,
-		BMA180_CTRL_REG0, BMA180_SLEEP,
-		BMA180_BW_TCS, BMA180_BW,
-		BMA180_OFFSET_LSB1, BMA180_RANGE,
-		BMA180_TCO_Z, BMA180_MODE_CONFIG, BMA180_LOW_POWER,
-		BMA180_CTRL_REG3, BMA180_NEW_DATA_INT,
-		BMA180_RESET,
-		bma180_chip_config,
-		bma180_chip_disable,
+		.channels = bma180_channels,
+		.num_channels = ARRAY_SIZE(bma180_channels),
+		.scale_table = bma180_scale_table,
+		.num_scales = ARRAY_SIZE(bma180_scale_table),
+		.bw_table = bma180_bw_table,
+		.num_bw = ARRAY_SIZE(bma180_bw_table),
+		.int_reset_reg = BMA180_CTRL_REG0,
+		.int_reset_mask = BMA180_RESET_INT,
+		.sleep_reg = BMA180_CTRL_REG0,
+		.sleep_mask = BMA180_SLEEP,
+		.bw_reg = BMA180_BW_TCS,
+		.bw_mask = BMA180_BW,
+		.scale_reg = BMA180_OFFSET_LSB1,
+		.scale_mask = BMA180_RANGE,
+		.power_reg = BMA180_TCO_Z,
+		.power_mask = BMA180_MODE_CONFIG,
+		.lowpower_val = BMA180_LOW_POWER,
+		.int_enable_reg = BMA180_CTRL_REG3,
+		.int_enable_mask = BMA180_NEW_DATA_INT,
+		.softreset_reg = BMA180_RESET,
+		.chip_config = bma180_chip_config,
+		.chip_disable = bma180_chip_disable,
 	},
 	[BMA250] = {
-		bma250_channels, ARRAY_SIZE(bma250_channels),
-		bma250_scale_table, ARRAY_SIZE(bma250_scale_table),
-		bma250_bw_table, ARRAY_SIZE(bma250_bw_table),
-		BMA250_INT_RESET_REG, BMA250_INT_RESET_MASK,
-		BMA250_POWER_REG, BMA250_SUSPEND_MASK,
-		BMA250_BW_REG, BMA250_BW_MASK,
-		BMA250_RANGE_REG, BMA250_RANGE_MASK,
-		BMA250_POWER_REG, BMA250_LOWPOWER_MASK, 1,
-		BMA250_INT_ENABLE_REG, BMA250_DATA_INTEN_MASK,
-		BMA250_RESET_REG,
-		bma250_chip_config,
-		bma250_chip_disable,
+		.channels = bma250_channels,
+		.num_channels = ARRAY_SIZE(bma250_channels),
+		.scale_table = bma250_scale_table,
+		.num_scales = ARRAY_SIZE(bma250_scale_table),
+		.bw_table = bma250_bw_table,
+		.num_bw = ARRAY_SIZE(bma250_bw_table),
+		.int_reset_reg = BMA250_INT_RESET_REG,
+		.int_reset_mask = BMA250_INT_RESET_MASK,
+		.sleep_reg = BMA250_POWER_REG,
+		.sleep_mask = BMA250_SUSPEND_MASK,
+		.bw_reg = BMA250_BW_REG,
+		.bw_mask = BMA250_BW_MASK,
+		.scale_reg = BMA250_RANGE_REG,
+		.scale_mask = BMA250_RANGE_MASK,
+		.power_reg = BMA250_POWER_REG,
+		.power_mask = BMA250_LOWPOWER_MASK,
+		.lowpower_val = 1,
+		.int_enable_reg = BMA250_INT_ENABLE_REG,
+		.int_enable_mask = BMA250_DATA_INTEN_MASK,
+		.softreset_reg = BMA250_RESET_REG,
+		.chip_config = bma250_chip_config,
+		.chip_disable = bma250_chip_disable,
 	},
 };
 
-- 
2.30.2


--yuXHB9ceN+H28p7d
Content-Type: text/x-diff; charset=iso-8859-1
Content-Disposition: attachment;
	filename="0002-iio-accel-bma180-Fix-BMA25x-bandwidth-register-value.patch"
Content-Transfer-Encoding: 8bit

From a56bbb39c183206a3093b8d9ee09b89cc6a45589 Mon Sep 17 00:00:00 2001
From: Stephan Gerhold <stephan@gerhold.net>
Date: Wed, 26 May 2021 11:44:07 +0200
Subject: [PATCH 2/2] iio: accel: bma180: Fix BMA25x bandwidth register values
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit 8090d67421ddab0ae932abab5a60200598bf0bbb upstream

According to the BMA253 datasheet [1] and BMA250 datasheet [2] the
bandwidth value for BMA25x should be set as 01xxx:

  "Settings 00xxx result in a bandwidth of 7.81 Hz; [...]
   It is recommended [...] to use the range from ´01000b´ to ´01111b´
   only in order to be compatible with future products."

However, at the moment the drivers sets bandwidth values from 0 to 6,
which is not recommended and always results into 7.81 Hz bandwidth
according to the datasheet.

Fix this by introducing a bw_offset = 8 = 01000b for BMA25x,
so the additional bit is always set for BMA25x.

[1]: https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bma253-ds000.pdf
[2]: https://datasheet.octopart.com/BMA250-Bosch-datasheet-15540103.pdf

Cc: Peter Meerwald <pmeerw@pmeerw.net>
Fixes: 2017cff24cc0 ("iio:bma180: Add BMA250 chip support")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210526094408.34298-2-stephan@gerhold.net
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/iio/accel/bma180.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 196111c91627..acf1cc2bee07 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -47,7 +47,7 @@ struct bma180_part_info {
 
 	u8 int_reset_reg, int_reset_mask;
 	u8 sleep_reg, sleep_mask;
-	u8 bw_reg, bw_mask;
+	u8 bw_reg, bw_mask, bw_offset;
 	u8 scale_reg, scale_mask;
 	u8 power_reg, power_mask, lowpower_val;
 	u8 int_enable_reg, int_enable_mask;
@@ -103,6 +103,7 @@ struct bma180_part_info {
 
 #define BMA250_RANGE_MASK	GENMASK(3, 0) /* Range of accel values */
 #define BMA250_BW_MASK		GENMASK(4, 0) /* Accel bandwidth */
+#define BMA250_BW_OFFSET	8
 #define BMA250_SUSPEND_MASK	BIT(7) /* chip will sleep */
 #define BMA250_LOWPOWER_MASK	BIT(6)
 #define BMA250_DATA_INTEN_MASK	BIT(4)
@@ -241,7 +242,8 @@ static int bma180_set_bw(struct bma180_data *data, int val)
 	for (i = 0; i < data->part_info->num_bw; ++i) {
 		if (data->part_info->bw_table[i] == val) {
 			ret = bma180_set_bits(data, data->part_info->bw_reg,
-				data->part_info->bw_mask, i);
+				data->part_info->bw_mask,
+				i + data->part_info->bw_offset);
 			if (ret) {
 				dev_err(&data->client->dev,
 					"failed to set bandwidth\n");
@@ -669,6 +671,7 @@ static const struct bma180_part_info bma180_part_info[] = {
 		.sleep_mask = BMA250_SUSPEND_MASK,
 		.bw_reg = BMA250_BW_REG,
 		.bw_mask = BMA250_BW_MASK,
+		.bw_offset = BMA250_BW_OFFSET,
 		.scale_reg = BMA250_RANGE_REG,
 		.scale_mask = BMA250_RANGE_MASK,
 		.power_reg = BMA250_POWER_REG,
-- 
2.30.2


--yuXHB9ceN+H28p7d--
