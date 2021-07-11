Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660CF3C3CB1
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhGKNES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:04:18 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:36815 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232789AbhGKNES (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 11 Jul 2021 09:04:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 6C3501AC057C;
        Sun, 11 Jul 2021 09:01:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 09:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lQaTk5
        VQ2RAHn2QIYmZCctgl1KkgLl56+t7k09gyCl4=; b=hH1AdOLIIeK1+CG1RLTmE+
        FWAvZyy8YelvGdhz+O1YIqH+a7UoM/mCm704wOS0EZ6FI8qRlL63o2fSIIRgdbcH
        pRYAEgLWaI6BHFgNuCaIsOWQjj/n/EY/KJRV2RU0KVq6z8vrtAAA5ffZDwF0x23X
        6dyeLY/SCrEaMbqQWkYP8CMmBHkJf+YK7fL4olpKRhLreBnQ2uOrW4P8Dn7NZjzU
        6yfxM3nlDm+CYd3Ut3FKnPRzd8TmEpvpwb71YXub1zDFytsubqm2zxLhmf8aE0CP
        QrzMNYx7BvBENuVR0Aqg1OavvgGGRjJpD6aM/xiREsANYS5jpvODkBDO5ZW9jMlg
        ==
X-ME-Sender: <xms:qevqYJxul4Sn5CTyq5D8wWJQIJCpHCVcBWqYEO7Vgj58XB1omjzuQg>
    <xme:qevqYJRcoAn8PC_1voYNYIACHMJSiSzDqTTYYxi8PH_T6b3VJFLfLAVJB1OO2ncH5
    QWdjYa0cF3TnA>
X-ME-Received: <xmr:qevqYDW7RNQ-GZE3kcfpO4lR8vBlKq924xWfJYK175KPWozsHR7BVe7g4MBuczzlqW1lYirgqeOEOSa8R8f8iBnOZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeefieeutdeuhffghffhueeklefgjeetteeuteehudegve
    effefhiedvhffhteektdenucffohhmrghinhepsghoshgthhdqshgvnhhsohhrthgvtgdr
    tghomhdpohgtthhophgrrhhtrdgtohhmpdhkvghrnhgvlhdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:qevqYLi_NPFW1Ug1lW7nTwdvYGEG9QgVPbEWleGImWBKOSzRVNQBQQ>
    <xmx:qevqYLC1mKH-1tRvHjXjXLdlhF4Grh6X_zDDgF7Jt8_M1UBxyewa9w>
    <xmx:qevqYEIYaKAeH3_flSEyN3-wnoq7_YarUgo8r1JborpKE9sfNv5oYw>
    <xmx:q-vqYG9U3dx7I7ezVBucBfrs_rnyAHQMVmYtgOD4xpC6Jc9SEO9xvBKq3_M>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 09:01:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: accel: bma180: Fix BMA25x bandwidth register values" failed to apply to 5.4-stable tree
To:     stephan@gerhold.net, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, linus.walleij@linaro.org, pmeerw@pmeerw.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 15:01:27 +0200
Message-ID: <1626008487114116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8090d67421ddab0ae932abab5a60200598bf0bbb Mon Sep 17 00:00:00 2001
From: Stephan Gerhold <stephan@gerhold.net>
Date: Wed, 26 May 2021 11:44:07 +0200
Subject: [PATCH] iio: accel: bma180: Fix BMA25x bandwidth register values
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 4a07e60c0e21..e7c6b3096cb7 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -55,7 +55,7 @@ struct bma180_part_info {
 
 	u8 int_reset_reg, int_reset_mask;
 	u8 sleep_reg, sleep_mask;
-	u8 bw_reg, bw_mask;
+	u8 bw_reg, bw_mask, bw_offset;
 	u8 scale_reg, scale_mask;
 	u8 power_reg, power_mask, lowpower_val;
 	u8 int_enable_reg, int_enable_mask;
@@ -127,6 +127,7 @@ struct bma180_part_info {
 
 #define BMA250_RANGE_MASK	GENMASK(3, 0) /* Range of accel values */
 #define BMA250_BW_MASK		GENMASK(4, 0) /* Accel bandwidth */
+#define BMA250_BW_OFFSET	8
 #define BMA250_SUSPEND_MASK	BIT(7) /* chip will sleep */
 #define BMA250_LOWPOWER_MASK	BIT(6)
 #define BMA250_DATA_INTEN_MASK	BIT(4)
@@ -143,6 +144,7 @@ struct bma180_part_info {
 
 #define BMA254_RANGE_MASK	GENMASK(3, 0) /* Range of accel values */
 #define BMA254_BW_MASK		GENMASK(4, 0) /* Accel bandwidth */
+#define BMA254_BW_OFFSET	8
 #define BMA254_SUSPEND_MASK	BIT(7) /* chip will sleep */
 #define BMA254_LOWPOWER_MASK	BIT(6)
 #define BMA254_DATA_INTEN_MASK	BIT(4)
@@ -287,7 +289,8 @@ static int bma180_set_bw(struct bma180_data *data, int val)
 	for (i = 0; i < data->part_info->num_bw; ++i) {
 		if (data->part_info->bw_table[i] == val) {
 			ret = bma180_set_bits(data, data->part_info->bw_reg,
-				data->part_info->bw_mask, i);
+				data->part_info->bw_mask,
+				i + data->part_info->bw_offset);
 			if (ret) {
 				dev_err(&data->client->dev,
 					"failed to set bandwidth\n");
@@ -880,6 +883,7 @@ static const struct bma180_part_info bma180_part_info[] = {
 		.sleep_mask = BMA250_SUSPEND_MASK,
 		.bw_reg = BMA250_BW_REG,
 		.bw_mask = BMA250_BW_MASK,
+		.bw_offset = BMA250_BW_OFFSET,
 		.scale_reg = BMA250_RANGE_REG,
 		.scale_mask = BMA250_RANGE_MASK,
 		.power_reg = BMA250_POWER_REG,
@@ -909,6 +913,7 @@ static const struct bma180_part_info bma180_part_info[] = {
 		.sleep_mask = BMA254_SUSPEND_MASK,
 		.bw_reg = BMA254_BW_REG,
 		.bw_mask = BMA254_BW_MASK,
+		.bw_offset = BMA254_BW_OFFSET,
 		.scale_reg = BMA254_RANGE_REG,
 		.scale_mask = BMA254_RANGE_MASK,
 		.power_reg = BMA254_POWER_REG,

