Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782B6414AEA
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 15:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhIVNoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 09:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhIVNoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 09:44:14 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97B2C061756;
        Wed, 22 Sep 2021 06:42:44 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id z24so12054329lfu.13;
        Wed, 22 Sep 2021 06:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2pVmVEzBfv3j4RRyLFyDyz2q0UkyXOkX4Ca5NndLWGQ=;
        b=hRCSeWYyuAGIwYgMIShMmegsmZ6IGA/T4u0loyzF5RBeeQxNnbodpEbSiZs77byGkZ
         Emd0wCzIYVLJiH7UZnSm+vmsx1LJgrFfOr83UACJevZ3Ru/cm//GcKWTKUQAEsPk4TxD
         kXIT0L1BEqK7JeCfnnDFINm7IZ9Mof90OCt1l5rv2r+bvKzDKXPF9kfv3LOZjtZ4WFRz
         u6qJSX7cECehU9KY4wb6mf1oEg+hCOIhuR0Jgx7XIBb8KDnNsVD4xKnuTAbL5BssdXyg
         LpD3bhT7OnX3jdxJxfcVZ//POCSG/vtby5INd7X5PKjw/jL8RbYotwfruHO1yb3k+G9R
         xgVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2pVmVEzBfv3j4RRyLFyDyz2q0UkyXOkX4Ca5NndLWGQ=;
        b=UOZGv4BXtJmeGBOmTOD9hisd/iw8hNUHyGMUG/rvWFS9VLHG/6Vdh5JMdnIhGF+yte
         go/sG1tem7H/jBuJ4e6VoPsnrMKQTmbQYsZ9Evck7k/jS9yMQy6Cv4VBFVNXAzs7yF+N
         mwZBJF68kwaiVK4sHi5WWwGkw3xAf696dn3FUgLiYtKaKoUeOpuDvyKWOtHFRzeaCzlN
         oHwQFFOvCDWmQN5/+Wu2u4yNjCn4+bGEl6p2RS4TMc95FQbUse/Bexv7j+j8UT1TsXT6
         +rVtmzyFp0FnEQIxU8+rSFy5iIYBMGxG7OoM0C1mZD0AghjqUjjtqAzQ1c56OYqEak8R
         Mamg==
X-Gm-Message-State: AOAM530LOo4DWkvXeZnDn65e66ATMoZmmtJEovx8PpeF78Fu4l5OH2GK
        AsGgPaY0PLSyj54F2vco7bS4yZSXTPc=
X-Google-Smtp-Source: ABdhPJxvjCRhlbV6Pf95jFGFqk5kPiAWKflglCSbRdgN7KCHc+pN5MfJUXPiaO7jBWhL+vcnEC8XrQ==
X-Received: by 2002:a05:6512:3d94:: with SMTP id k20mr18072118lfv.359.1632318140015;
        Wed, 22 Sep 2021 06:42:20 -0700 (PDT)
Received: from home.paul.comp (paulfertser.info. [2001:470:26:54b:226:9eff:fe70:80c2])
        by smtp.gmail.com with ESMTPSA id e5sm256943ljj.129.2021.09.22.06.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 06:42:19 -0700 (PDT)
Received: from home.paul.comp (home.paul.comp [IPv6:0:0:0:0:0:0:0:1])
        by home.paul.comp (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTP id 18MDgGtj020807;
        Wed, 22 Sep 2021 16:42:17 +0300
Received: (from paul@localhost)
        by home.paul.comp (8.15.2/8.15.2/Submit) id 18MDgF5Q020806;
        Wed, 22 Sep 2021 16:42:15 +0300
From:   Paul Fertser <fercerpav@gmail.com>
To:     linux-hwmon@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] hwmon: tmp421: handle I2C errors
Date:   Wed, 22 Sep 2021 16:41:52 +0300
Message-Id: <20210922134154.20766-1-fercerpav@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Function i2c_smbus_read_byte_data() can return a negative error number
instead of the data read if I2C transaction failed for whatever reason.

I consider this fix to be stable material as lack of error checking here
leads to serious issues on production hardware. Errors treated as
temperatures produce spurious critical temperature-crossed-threshold
errors in BMC logs for OCP server hardware. The patch was tested with
Mellanox OCP Mezzanine card emulating TMP421 protocol for temperature
sensing which sometimes leads to I2C protocol error during early boot up
stage.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/hwmon/tmp421.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index ede66ea6a730..6175ed4b10bd 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -93,7 +93,7 @@ struct tmp421_data {
 	struct hwmon_channel_info temp_info;
 	const struct hwmon_channel_info *info[2];
 	struct hwmon_chip_info chip;
-	char valid;
+	int last_errno;
 	unsigned long last_updated;
 	unsigned long channels;
 	u8 config;
@@ -128,20 +128,30 @@ static struct tmp421_data *tmp421_update_device(struct device *dev)
 	mutex_lock(&data->update_lock);
 
 	if (time_after(jiffies, data->last_updated + (HZ / 2)) ||
-	    !data->valid) {
-		data->config = i2c_smbus_read_byte_data(client,
-			TMP421_CONFIG_REG_1);
+	    data->last_errno) {
+		data->last_errno = i2c_smbus_read_byte_data(client,
+							    TMP421_CONFIG_REG_1);
+		if (data->last_errno < 0)
+			goto exit;
+		data->config =  data->last_errno;
 
 		for (i = 0; i < data->channels; i++) {
-			data->temp[i] = i2c_smbus_read_byte_data(client,
-				TMP421_TEMP_MSB[i]) << 8;
-			data->temp[i] |= i2c_smbus_read_byte_data(client,
-				TMP421_TEMP_LSB[i]);
+			data->last_errno = i2c_smbus_read_byte_data(client,
+								    TMP421_TEMP_MSB[i]);
+			if (data->last_errno < 0)
+				goto exit;
+			data->temp[i] = data->last_errno << 8;
+			data->last_errno = i2c_smbus_read_byte_data(client,
+								    TMP421_TEMP_LSB[i]);
+			if (data->last_errno < 0)
+				goto exit;
+			data->temp[i] |= data->last_errno;
 		}
 		data->last_updated = jiffies;
-		data->valid = 1;
+		data->last_errno = 0;
 	}
 
+exit:
 	mutex_unlock(&data->update_lock);
 
 	return data;
@@ -152,6 +162,9 @@ static int tmp421_read(struct device *dev, enum hwmon_sensor_types type,
 {
 	struct tmp421_data *tmp421 = tmp421_update_device(dev);
 
+	if (tmp421->last_errno)
+		return tmp421->last_errno;
+
 	switch (attr) {
 	case hwmon_temp_input:
 		if (tmp421->config & TMP421_CONFIG_RANGE)
-- 
2.17.1

