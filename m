Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B013415B54
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 11:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbhIWJtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 05:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240175AbhIWJtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 05:49:45 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4B9C061574;
        Thu, 23 Sep 2021 02:48:14 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id b20so24437510lfv.3;
        Thu, 23 Sep 2021 02:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UBHRISYX5sJ3rKkVZbPtnHeROJdfEmrdq6wDSGD15ag=;
        b=ZQJ6PPNyX5STFkJ8pY4vROvAqK6GffaLq6NCxWShm8M1v6Nyp6GFd6fBVJEs5aOg3y
         WviRMGjXt5LPM9h1PJzexIx2xe7TEkP3DB0NGAVT/tsiYzlo++svSkuYuDGANUqv5m9p
         8+ab3RZQvwQG9YiX0uXAy5LBC0PeLtXcqbu369otazypWo5v2aQnfer1TRMbkCn6GmqP
         FBkJsbyv4n4H+X13/CofhkH25GA4iuSNDUdQQ9LuaLg+i0QQQ74z/SPq0B0w9qx4t54L
         YWeqeYyO8rSjUFABbOdl3NVVCQ8IK1vzpx5+U0S7L5cjtNu2lc/pMvegal+IWPDOMkw2
         ctdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UBHRISYX5sJ3rKkVZbPtnHeROJdfEmrdq6wDSGD15ag=;
        b=2Y19dQVay8cRE7ezsXOL2e4FDNECAd+MkAFkp6558NlzjAUcohbheyL9yAqgieXaOB
         tQUbsKpUiYG1/h4sncDPdl5CbT1S7iEIfZazUVKlyeYuGAu/jTpRE6lsGU7hJZe26xSn
         C10mM3hxJNfO/tKKUY0dWRHEMjpGEipo7OIG1YHjDR5b2QDfW9xMZlQ78sxI2N2i/TBu
         puwz5uCg3O2oyvp7qgaHH3mAQ3usXUOczoSFfIvM3PSJfD3Ni40XUzKSN3Dh04M27mWZ
         t8DTn6f30/CLgWl2WUlaHf5HU7rG/s4axzyqtORKYu9upKqVHkvT/ksfdS5KOFSpi8ff
         g0Mg==
X-Gm-Message-State: AOAM530OCffDX2W7rGsmpqaiF/g2xZc1tO2eP4/Sw0cPrsQmN4uocuSb
        xqRVAwALW0ZnFbz2ee5G2HxiQc+r2e0=
X-Google-Smtp-Source: ABdhPJyEJ7BFLLJxTjCTRWXcEnoJUmuUgYXuw5NSqRL+PFUzZgPM6THoSAKxgTAVsVPx1yvv3nEYGQ==
X-Received: by 2002:a05:651c:b12:: with SMTP id b18mr4041560ljr.512.1632390492639;
        Thu, 23 Sep 2021 02:48:12 -0700 (PDT)
Received: from home.paul.comp (paulfertser.info. [2001:470:26:54b:226:9eff:fe70:80c2])
        by smtp.gmail.com with ESMTPSA id 26sm411297lfy.144.2021.09.23.02.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 02:48:12 -0700 (PDT)
Received: from home.paul.comp (home.paul.comp [IPv6:0:0:0:0:0:0:0:1])
        by home.paul.comp (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTP id 18N9m9PR023373;
        Thu, 23 Sep 2021 12:48:10 +0300
Received: (from paul@localhost)
        by home.paul.comp (8.15.2/8.15.2/Submit) id 18N9m8jL023372;
        Thu, 23 Sep 2021 12:48:08 +0300
From:   Paul Fertser <fercerpav@gmail.com>
To:     linux-hwmon@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/3] hwmon: tmp421: handle I2C errors
Date:   Thu, 23 Sep 2021 12:47:59 +0300
Message-Id: <20210923094801.23332-1-fercerpav@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210922155323.GA3205709@roeck-us.net>
References: <20210922155323.GA3205709@roeck-us.net>
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

Changes from v1:
 - Reorganise code following excellent suggestion by Guenter Roeck
   to use tagged errors consistently

 drivers/hwmon/tmp421.c | 45 +++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index ede66ea6a730..63cb6badb478 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -93,7 +93,7 @@ struct tmp421_data {
 	struct hwmon_channel_info temp_info;
 	const struct hwmon_channel_info *info[2];
 	struct hwmon_chip_info chip;
-	char valid;
+	bool valid;
 	unsigned long last_updated;
 	unsigned long channels;
 	u8 config;
@@ -119,38 +119,59 @@ static int temp_from_u16(u16 reg)
 	return (temp * 1000 + 128) / 256;
 }
 
-static struct tmp421_data *tmp421_update_device(struct device *dev)
+static int tmp421_update_device(struct tmp421_data *data)
 {
-	struct tmp421_data *data = dev_get_drvdata(dev);
 	struct i2c_client *client = data->client;
+	int ret = 0;
 	int i;
 
 	mutex_lock(&data->update_lock);
 
 	if (time_after(jiffies, data->last_updated + (HZ / 2)) ||
 	    !data->valid) {
-		data->config = i2c_smbus_read_byte_data(client,
-			TMP421_CONFIG_REG_1);
+		ret = i2c_smbus_read_byte_data(client,
+					       TMP421_CONFIG_REG_1);
+		if (ret < 0)
+			goto exit;
+		data->config = ret;
 
 		for (i = 0; i < data->channels; i++) {
-			data->temp[i] = i2c_smbus_read_byte_data(client,
-				TMP421_TEMP_MSB[i]) << 8;
-			data->temp[i] |= i2c_smbus_read_byte_data(client,
-				TMP421_TEMP_LSB[i]);
+			ret = i2c_smbus_read_byte_data(client,
+						       TMP421_TEMP_MSB[i]);
+			if (ret < 0)
+				goto exit;
+			data->temp[i] = ret << 8;
+
+			ret = i2c_smbus_read_byte_data(client,
+						       TMP421_TEMP_LSB[i]);
+			if (ret < 0)
+				goto exit;
+			data->temp[i] |= ret;
 		}
 		data->last_updated = jiffies;
-		data->valid = 1;
+		data->valid = true;
 	}
 
+exit:
 	mutex_unlock(&data->update_lock);
 
-	return data;
+	if (ret < 0) {
+		data->valid = false;
+		return ret;
+	}
+
+	return 0;
 }
 
 static int tmp421_read(struct device *dev, enum hwmon_sensor_types type,
 		       u32 attr, int channel, long *val)
 {
-	struct tmp421_data *tmp421 = tmp421_update_device(dev);
+	struct tmp421_data *tmp421 = dev_get_drvdata(dev);
+	int ret = 0;
+
+	ret = tmp421_update_device(tmp421);
+	if (ret)
+		return ret;
 
 	switch (attr) {
 	case hwmon_temp_input:
-- 
2.17.1

