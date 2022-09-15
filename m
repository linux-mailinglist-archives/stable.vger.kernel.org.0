Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90225BA1AB
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 21:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiIOT5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 15:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiIOT5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 15:57:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C2D95AF2;
        Thu, 15 Sep 2022 12:57:40 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FJVEGb001185;
        Thu, 15 Sep 2022 19:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8eyIJiOy/CD2j+mHD4/CiZo6xzX8iNGSkN1rhKIsMW4=;
 b=sMxsm3v/SjmAgQCacrepHCHlEHvrYRJGYAM6jtMjoavhLKVC+Kw7n6w8AAF/OpVpN44e
 EnQet0XFaE7oULCPXpBoKfiXQZIFRDUpoP+50GxMyKlF9rFwTwEjBJlx82FxFLtg0IrX
 OMxzPt1LIl5nPui3dhv6fvub0sn44Fq57upXrCfQFVmVVt+hapD5emR+RyILfIs48yFa
 gwCtYrGXPT04Yuwe2yTh97O9wN3qulVywhv17w7UC7om+VOF43mFzzN2b8yefWDEkYMe
 wPWubtolQL2fZetG2Ko0WzrdJwyeBxtoIhNXLeNiWgLnblr5jK4Yq8+6q4J348iUYKSR rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jma9egs5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 19:57:25 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28FJXU4E016649;
        Thu, 15 Sep 2022 19:57:25 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jma9egs4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 19:57:25 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28FJpOH9024706;
        Thu, 15 Sep 2022 19:57:24 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 3jm91cggkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 19:57:23 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28FJvMND44695874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 19:57:22 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F50FC605A;
        Thu, 15 Sep 2022 19:57:22 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23801C6057;
        Thu, 15 Sep 2022 19:57:21 +0000 (GMT)
Received: from slate16.aus.stglabs.ibm.com (unknown [9.65.211.128])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 15 Sep 2022 19:57:21 +0000 (GMT)
From:   Eddie James <eajames@linux.ibm.com>
To:     jic23@kernel.org
Cc:     lars@metafoo.de, linux-iio@vger.kernel.org, joel@jms.id.au,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        stable@vger.kernel.org, eajames@linux.ibm.com
Subject: [PATCH v8 2/2] iio: pressure: dps310: Reset chip after timeout
Date:   Thu, 15 Sep 2022 14:57:19 -0500
Message-Id: <20220915195719.136812-3-eajames@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220915195719.136812-1-eajames@linux.ibm.com>
References: <20220915195719.136812-1-eajames@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HUFaBY96dM4Iio3VX-FjEhw64BDfopI8
X-Proofpoint-ORIG-GUID: J1ggYdEodygbWU3s8qtfysYFm6uKKic2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209150119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The DPS310 chip has been observed to get "stuck" such that pressure
and temperature measurements are never indicated as "ready" in the
MEAS_CFG register. The only solution is to reset the device and try
again. In order to avoid continual failures, use a boolean flag to
only try the reset after timeout once if errors persist.

Fixes: ba6ec48e76bc ("iio: Add driver for Infineon DPS310")
Cc: <stable@vger.kernel.org>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/iio/pressure/dps310.c | 74 ++++++++++++++++++++++++++++++-----
 1 file changed, 64 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/pressure/dps310.c b/drivers/iio/pressure/dps310.c
index c706a8b423b5..984a3f511a1a 100644
--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -89,6 +89,7 @@ struct dps310_data {
 	s32 c00, c10, c20, c30, c01, c11, c21;
 	s32 pressure_raw;
 	s32 temp_raw;
+	bool timeout_recovery_failed;
 };
 
 static const struct iio_chan_spec dps310_channels[] = {
@@ -393,11 +394,69 @@ static int dps310_get_temp_k(struct dps310_data *data)
 	return scale_factors[ilog2(rc)];
 }
 
+static int dps310_reset_wait(struct dps310_data *data)
+{
+	int rc;
+
+	rc = regmap_write(data->regmap, DPS310_RESET, DPS310_RESET_MAGIC);
+	if (rc)
+		return rc;
+
+	/* Wait for device chip access: 2.5ms in specification */
+	usleep_range(2500, 12000);
+	return 0;
+}
+
+static int dps310_reset_reinit(struct dps310_data *data)
+{
+	int rc;
+
+	rc = dps310_reset_wait(data);
+	if (rc)
+		return rc;
+
+	return dps310_startup(data);
+}
+
+static int dps310_ready_status(struct dps310_data *data, int ready_bit, int timeout)
+{
+	int sleep = DPS310_POLL_SLEEP_US(timeout);
+	int ready;
+
+	return regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready, ready & ready_bit,
+					sleep, timeout);
+}
+
+static int dps310_ready(struct dps310_data *data, int ready_bit, int timeout)
+{
+	int rc;
+
+	rc = dps310_ready_status(data, ready_bit, timeout);
+	if (rc) {
+		if (rc == -ETIMEDOUT && !data->timeout_recovery_failed) {
+			/* Reset and reinitialize the chip. */
+			if (dps310_reset_reinit(data)) {
+				data->timeout_recovery_failed = true;
+			} else {
+				/* Try again to get sensor ready status. */
+				if (dps310_ready_status(data, ready_bit, timeout))
+					data->timeout_recovery_failed = true;
+				else
+					return 0;
+			}
+		}
+
+		return rc;
+	}
+
+	data->timeout_recovery_failed = false;
+	return 0;
+}
+
 static int dps310_read_pres_raw(struct dps310_data *data)
 {
 	int rc;
 	int rate;
-	int ready;
 	int timeout;
 	s32 raw;
 	u8 val[3];
@@ -409,9 +468,7 @@ static int dps310_read_pres_raw(struct dps310_data *data)
 	timeout = DPS310_POLL_TIMEOUT_US(rate);
 
 	/* Poll for sensor readiness; base the timeout upon the sample rate. */
-	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
-				      ready & DPS310_PRS_RDY,
-				      DPS310_POLL_SLEEP_US(timeout), timeout);
+	rc = dps310_ready(data, DPS310_PRS_RDY, timeout);
 	if (rc)
 		goto done;
 
@@ -448,7 +505,6 @@ static int dps310_read_temp_raw(struct dps310_data *data)
 {
 	int rc;
 	int rate;
-	int ready;
 	int timeout;
 
 	if (mutex_lock_interruptible(&data->lock))
@@ -458,10 +514,8 @@ static int dps310_read_temp_raw(struct dps310_data *data)
 	timeout = DPS310_POLL_TIMEOUT_US(rate);
 
 	/* Poll for sensor readiness; base the timeout upon the sample rate. */
-	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
-				      ready & DPS310_TMP_RDY,
-				      DPS310_POLL_SLEEP_US(timeout), timeout);
-	if (rc < 0)
+	rc = dps310_ready(data, DPS310_TMP_RDY, timeout);
+	if (rc)
 		goto done;
 
 	rc = dps310_read_temp_ready(data);
@@ -756,7 +810,7 @@ static void dps310_reset(void *action_data)
 {
 	struct dps310_data *data = action_data;
 
-	regmap_write(data->regmap, DPS310_RESET, DPS310_RESET_MAGIC);
+	dps310_reset_wait(data);
 }
 
 static const struct regmap_config dps310_regmap_config = {
-- 
2.31.1

