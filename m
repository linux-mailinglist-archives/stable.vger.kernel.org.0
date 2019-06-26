Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4865056D92
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 17:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfFZPYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 11:24:18 -0400
Received: from de-deferred2.bosch-org.com ([139.15.180.217]:34542 "EHLO
        de-deferred2.bosch-org.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbfFZPYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 11:24:18 -0400
Received: from de-out1.bosch-org.com (unknown [139.15.180.215])
        by fe0vms0193.rbdmz01.com (Postfix) with ESMTPS id 45Ymlb1KRcz1Wn
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 17:14:19 +0200 (CEST)
Received: from si0vm1947.rbesz01.com (unknown [139.15.230.188])
        by si0vms0216.rbdmz01.com (Postfix) with ESMTPS id 45YmlZ07zyz1XLG7N;
        Wed, 26 Jun 2019 17:14:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=de.bosch.com;
        s=key1-intmail; t=1561562058;
        bh=rNreBz9tcS3Q2kVTNLarcOTT5RXq5VFV0bGKMsjq8CU=; l=10;
        h=From:Subject:From:Reply-To:Sender;
        b=vpZxpdwTGg6ReuEmBQR0Tk8LY4jip7J3onaoidXgq2I8aYd6mKB7Wda+N6JtkjtPL
         j4rsF1Kx+deQ3hdmqWw7xjm2BdUvMSlmfs+utYB6CggQpwgBin10pbLiN6Dvi3BfhI
         YWHU7jN/q4xoHd2H5BdCOj5o+9V3Ge0GlGuVYZHk=
Received: from fe0vm02900.rbesz01.com (unknown [10.58.172.176])
        by si0vm1947.rbesz01.com (Postfix) with ESMTPS id 45YmlY6x36z6CjR2R;
        Wed, 26 Jun 2019 17:14:17 +0200 (CEST)
X-AuditID: 0a3aad0c-d01ff700000039d6-44-5d138bc9cb02
Received: from fe0vm1651.rbesz01.com ( [10.58.173.29])
        (using TLS with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by fe0vm02900.rbesz01.com (SMG Outbound) with SMTP id AE.A7.14806.9CB831D5; Wed, 26 Jun 2019 17:14:17 +0200 (CEST)
Received: from SI-HUB2000.de.bosch.com (si-hub2000.de.bosch.com [10.4.103.108])
        by fe0vm1651.rbesz01.com (Postfix) with ESMTPS id 45YmlY4MGnznqs;
        Wed, 26 Jun 2019 17:14:17 +0200 (CEST)
Received: from ninja.grb-fir.grb.de.bosch.com (10.19.187.97) by
 SI-HUB2000.de.bosch.com (10.4.103.108) with Microsoft SMTP Server id
 15.1.1713.5; Wed, 26 Jun 2019 17:14:17 +0200
From:   Mark Jonas <mark.jonas@de.bosch.com>
To:     <stable@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Kjetil Aamodt <kjetilaamodt@gmail.com>
CC:     Wang Xin <xin.wang7@cn.bosch.com>,
        Leo Ruan <tingquan.ruan@cn.bosch.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Mark Jonas <mark.jonas@de.bosch.com>
Subject: [PATCH 4.19] commit 9a9e295e7c5c0409c020088b0ae017e6c2b7df6e upstream.
Date:   Wed, 26 Jun 2019 17:14:16 +0200
Message-ID: <20190626151416.10997-1-mark.jonas@de.bosch.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: H4sIAAAAAAAAA21SbUwTZxznuTvK06Y3r1eRv4XOeMaY6JSqW1I3Z+CL6ZZskCwLibHqIWd7
        sy94V4i4xBU3p8I2GDIijcIpNShKojUoCpnYZQmY1feXGtzKGFkKybINXzLm2+4s2H7Ylye/
        /F7+z//55cEkq+RYsOgLCJKP93A6A2V4u9u6dKje7LRNXlxqvzByVmfv3P89siunR5H9+GCI
        LKIcHXeGsx3nQz/nOIYuj1GOB5HXS6l1htUVgkesFqTCNZsM7kPKQHZlbMH28KQjiGIFdQhj
        YN6EL47q6pAes0wrAYd+FVO4H8HhBn0dMqi4B8E3tVMvTTpmMdwb7CW17GzGDcFbpOYhmVYE
        tX0KqXnMTAns6fgHaZhiFkJYiREappnVcPVJ58s5wMyDE6cGyBRvgqHWMUrDJANwKZkkGxEd
        ypBCGZKCiC40Z4tgq/baVqyy2ZZJ5YK8w7Z82Wa/N4JSbRl70Y9hVxQxGHFG+kWV2clm89Vy
        jTeK3sIEl0sLZ1gn+1q5v6LGzcvujVKVR5A5C11w7f31rPkVLVeVe0VZFv2+KAJMcrPpozzj
        ZOkKvmaHIPlTsSjKxxSXR7twyXqWcfEBYasgVArSjPoOxhzQ7XXqDiZJcAnbt4iewIzMWWmU
        lZXFzslUMq8lsD6KVmKjevdNbQQtV/JeWXRNx+em4uwMm45eRu9hpSd8hMTd59STpXx+n2DJ
        o+drUxjN767yvdrDUkAv+EAVcjOE9KwJFEdqk2Z6cp/qMapfM70B0PlaaaZpMh1aEVYzzFcm
        SB4rgvhP5xC09T5CcLC5nYB9yR4COsIHsuHF4c91cONCKAea/x7Mgd19uzDElQYMe583Yxj9
        YwDDgUd9ekj+clUPV+6O66GtpdEATfUjBoiHfzNA+Otvaei/cnIWXPz9GAOJe48ZuNYWY6Hp
        fIsZmrq6c+H0RCIPptob8mH/s7/y4WkiUgAPb+yxwpNLw9YJtV1CbXfTblZrN8AH/qfdaTb9
        OEsQ4UR8vq2Qnzu60fvpd1P0rtBDY2xnUVf9Xr+z8hObpy/SWbZqxNtLNisKfkZ+dnBJ8btr
        TcVfTtSOB8fW+sYLidDmecJCkd365xvFDSUJuXF8w87jZbdPCdLg2cS/rh/ED69vaxtuKSkt
        uz/r4+hHwQePI3fWrbzVHzrSZC1ds8jOUbKbX76YlGT+Px3Bb5wzBAAA
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Xin <xin.wang7@cn.bosch.com>

eeprom: at24: fix unexpected timeout under high load

Within at24_loop_until_timeout the timestamp used for timeout checking
is recorded after the I2C transfer and sleep_range(). Under high CPU
load either the execution time for I2C transfer or sleep_range() could
actually be larger than the timeout value. Worst case the I2C transfer
is only tried once because the loop will exit due to the timeout
although the EEPROM is now ready.

To fix this issue the timestamp is recorded at the beginning of each
iteration. That is, before I2C transfer and sleep. Then the timeout
is actually checked against the timestamp of the previous iteration.
This makes sure that even if the timeout is reached, there is still one
more chance to try the I2C transfer in case the EEPROM is ready.

Example:

If you have a system which combines high CPU load with repeated EEPROM
writes you will run into the following scenario.

 - System makes a successful regmap_bulk_write() to EEPROM.
 - System wants to perform another write to EEPROM but EEPROM is still
   busy with the last write.
 - Because of high CPU load the usleep_range() will sleep more than
   25 ms (at24_write_timeout).
 - Within the over-long sleeping the EEPROM finished the previous write
   operation and is ready again.
 - at24_loop_until_timeout() will detect timeout and won't try to write.

Cc: <stable@vger.kernel.org> # 4.19.x
Signed-off-by: Wang Xin <xin.wang7@cn.bosch.com>
Signed-off-by: Mark Jonas <mark.jonas@de.bosch.com>
---
 drivers/misc/eeprom/at24.c | 43 +++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 94836fcbe721..ddfcf4ade7bf 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -106,23 +106,6 @@ static unsigned int at24_write_timeout = 25;
 module_param_named(write_timeout, at24_write_timeout, uint, 0);
 MODULE_PARM_DESC(at24_write_timeout, "Time (in ms) to try writes (default 25)");
 
-/*
- * Both reads and writes fail if the previous write didn't complete yet. This
- * macro loops a few times waiting at least long enough for one entire page
- * write to work while making sure that at least one iteration is run before
- * checking the break condition.
- *
- * It takes two parameters: a variable in which the future timeout in jiffies
- * will be stored and a temporary variable holding the time of the last
- * iteration of processing the request. Both should be unsigned integers
- * holding at least 32 bits.
- */
-#define at24_loop_until_timeout(tout, op_time)				\
-	for (tout = jiffies + msecs_to_jiffies(at24_write_timeout),	\
-	     op_time = 0;						\
-	     op_time ? time_before(op_time, tout) : true;		\
-	     usleep_range(1000, 1500), op_time = jiffies)
-
 struct at24_chip_data {
 	/*
 	 * these fields mirror their equivalents in
@@ -311,13 +294,22 @@ static ssize_t at24_regmap_read(struct at24_data *at24, char *buf,
 	/* adjust offset for mac and serial read ops */
 	offset += at24->offset_adj;
 
-	at24_loop_until_timeout(timeout, read_time) {
+	timeout = jiffies + msecs_to_jiffies(at24_write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		read_time = jiffies;
+
 		ret = regmap_bulk_read(regmap, offset, buf, count);
 		dev_dbg(&client->dev, "read %zu@%d --> %d (%ld)\n",
 			count, offset, ret, jiffies);
 		if (!ret)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(read_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -361,14 +353,23 @@ static ssize_t at24_regmap_write(struct at24_data *at24, const char *buf,
 	regmap = at24_client->regmap;
 	client = at24_client->client;
 	count = at24_adjust_write_count(at24, offset, count);
+	timeout = jiffies + msecs_to_jiffies(at24_write_timeout);
+
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		write_time = jiffies;
 
-	at24_loop_until_timeout(timeout, write_time) {
 		ret = regmap_bulk_write(regmap, offset, buf, count);
 		dev_dbg(&client->dev, "write %zu@%d --> %d (%ld)\n",
 			count, offset, ret, jiffies);
 		if (!ret)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(write_time, timeout));
 
 	return -ETIMEDOUT;
 }
-- 
2.17.1

