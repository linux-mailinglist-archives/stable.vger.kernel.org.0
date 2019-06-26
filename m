Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42EFB56D7A
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 17:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfFZPTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 11:19:21 -0400
Received: from de-deferred1.bosch-org.com ([139.15.180.216]:60008 "EHLO
        de-deferred1.bosch-org.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbfFZPTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 11:19:21 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2019 11:19:17 EDT
Received: from de-out1.bosch-org.com (unknown [139.15.180.215])
        by si0vms0224.rbdmz01.com (Postfix) with ESMTPS id 45YmlP0PHmzBvZ
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 17:14:09 +0200 (CEST)
Received: from si0vm1947.rbesz01.com (unknown [139.15.230.188])
        by fe0vms0186.rbdmz01.com (Postfix) with ESMTPS id 45YmlM5G3Zz1XLFjd;
        Wed, 26 Jun 2019 17:14:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=de.bosch.com;
        s=key1-intmail; t=1561562047;
        bh=rNreBz9tcS3Q2kVTNLarcOTT5RXq5VFV0bGKMsjq8CU=; l=10;
        h=From:Subject:From:Reply-To:Sender;
        b=ovzrS8gXD1Ad1ouTVj3yW69wPL95pS+UKTZvBhOZBtZz8wZzNyDrirz955K53a7MZ
         w9KEi4vL16wkWJTpAsrYMFRgC4PcEGNXrOjKjN38VQMBJzpiqTSfacPombLetT+UKC
         OQuU50dwgJws+0yPvaC8Aet6IhzJKOk+T6igxNc0=
Received: from fe0vm02900.rbesz01.com (unknown [10.58.172.176])
        by si0vm1947.rbesz01.com (Postfix) with ESMTPS id 45YmlM54K0z6CjR2Y;
        Wed, 26 Jun 2019 17:14:07 +0200 (CEST)
X-AuditID: 0a3aad0c-d19ff700000039d6-eb-5d138bbdf9b6
Received: from fe0vm1652.rbesz01.com ( [10.58.173.29])
        (using TLS with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by fe0vm02900.rbesz01.com (SMG Outbound) with SMTP id D0.A7.14806.DBB831D5; Wed, 26 Jun 2019 17:14:05 +0200 (CEST)
Received: from FE-HUB2000.de.bosch.com (fe-hub2000.de.bosch.com [10.4.103.109])
        by fe0vm1652.rbesz01.com (Postfix) with ESMTPS id 45YmlK5hQ4z5gf;
        Wed, 26 Jun 2019 17:14:05 +0200 (CEST)
Received: from ninja.grb-fir.grb.de.bosch.com (10.19.187.97) by
 FE-HUB2000.de.bosch.com (10.4.103.109) with Microsoft SMTP Server id
 15.1.1713.5; Wed, 26 Jun 2019 17:14:05 +0200
From:   Mark Jonas <mark.jonas@de.bosch.com>
To:     <stable@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Kjetil Aamodt <kjetilaamodt@gmail.com>
CC:     Wang Xin <xin.wang7@cn.bosch.com>,
        Leo Ruan <tingquan.ruan@cn.bosch.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Mark Jonas <mark.jonas@de.bosch.com>
Subject: [PATCH 4.14] commit 9a9e295e7c5c0409c020088b0ae017e6c2b7df6e upstream.
Date:   Wed, 26 Jun 2019 17:14:03 +0200
Message-ID: <20190626151403.10846-1-mark.jonas@de.bosch.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: H4sIAAAAAAAAA21Se0xTVxjn3HtpT5sec7kF+VZ0xusexmWsyB6dsgX+Y1uIS5b9sc1mXuTa
        NqMt6W2JaGI6GUbrA0TGoyFYaYePpZuojAIOscmS1vggHRkwwRnGXKebYUPMkrmxe1ew/WP/
        nHzn9/i+7/xyMM0F1QZsc7hFl0Oo5lVaRrspvPr54YN6s/Hntk2mwdtfqUwnjw0jU6B3BplO
        x/x0KVMe/O5mdvmAf1pdHr8yy5TPn3vybeZ9bUmVWG2rFV0vvL5Na42emM2umS/d+WAhovai
        C8U+pMHAvghtR/ZSPqTFHNtBQWdnXJ26XESQGHtEKSqO7UPQeIEotYrdAJOxCO1DGOeyVvCO
        0YqeZjsQfDwUoBWNnt0CX3wfRErNsE9DT89f//UhbAnEOj5Rpyavgc/PjtApPAfiHbOMUtMs
        wOVkkm5CxJ9B+TOoAKLOoJU7RGOt3bjxVaOx0FUpSruMRYXbnfZzKBWYLoK+CVmiiMWI15FF
        j97MZQu1Up09il7CFJ9HxPOcmVtR6ayqswqS9UOXp1qUeANZNfrmVk7/GJY8lXabJNmcjigC
        TPO55DOBNXOkSqjbJbqcKVsUFWCGzycWvGUrx1oEt/iRKNaIrmV2M8Y8kOM+eYccl2gRd+6w
        VbuXaX41QVlZWdzKTCZzLIU1UVSMdfLsb5UWRKoR7JLNsmR/ImXnltG09Qp6Awf6Qt00DvfL
        J8c4nA7RkE/WKl1YRW/1OB7vYVhF1lXIRF4Gke51F00gOUk9+eOArNHJvzO9AZACJbScJTBt
        2hiSPWyPHpKnSmHiaj+CrsgCgs6W4xQcSPZR8OWlWwwEQ+3ZsHiiXgWJQb8aWn6PqaFhaC+G
        7v4GDBOBRgz7/2nBMPPbCIb2hSENJG/d0MD18V800NXapIXmg7e1MBH6UQtTvcM6CB0+SqC9
        OUzgfOLRCrh05xQLP0w+ZGG06xoHzQOtemg+E86D4FQY4NjfcwV35XQpOd1tDZySrltw/0+6
        S2j6cQYvKlz7a2O99yRdorqRN4LXVax/riYxM3do6nrTvDdufuvP1vEy0/7YB8PPJOjJO754
        VWk98yCyvvjinq/rcNa+2unFw2Vt9w69cn/kMjt6pHdN0dz997o3DxDpU6PnKWn32XuC753x
        fbsryo5uv2q8aXq54fR0/h7p3UHds6/1j/308Fouz0hWoWgD7ZKEfwH2xjRyNgQAAA==
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

Cc: <stable@vger.kernel.org> # 4.14.x
Signed-off-by: Wang Xin <xin.wang7@cn.bosch.com>
Signed-off-by: Mark Jonas <mark.jonas@de.bosch.com>
Signed-off-by: Leo Ruan <tingquan.ruan@cn.bosch.com>
---
 drivers/misc/eeprom/at24.c | 107 ++++++++++++++++++++++++++-----------
 1 file changed, 77 insertions(+), 30 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 4cc0b42f2acc..cfa854077835 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -113,22 +113,6 @@ MODULE_PARM_DESC(write_timeout, "Time (in ms) to try writes (default 25)");
 	((1 << AT24_SIZE_FLAGS | (_flags)) 		\
 	    << AT24_SIZE_BYTELEN | ilog2(_len))
 
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
-#define loop_until_timeout(tout, op_time)				\
-	for (tout = jiffies + msecs_to_jiffies(write_timeout), op_time = 0; \
-	     op_time ? time_before(op_time, tout) : true;		\
-	     usleep_range(1000, 1500), op_time = jiffies)
-
 static const struct i2c_device_id at24_ids[] = {
 	/* needs 8 addresses as A0-A2 are ignored */
 	{ "24c00",	AT24_DEVICE_MAGIC(128 / 8,	AT24_FLAG_TAKE8ADDR) },
@@ -233,7 +217,14 @@ static ssize_t at24_eeprom_read_smbus(struct at24_data *at24, char *buf,
 	if (count > I2C_SMBUS_BLOCK_MAX)
 		count = I2C_SMBUS_BLOCK_MAX;
 
-	loop_until_timeout(timeout, read_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		read_time = jiffies;
+
 		status = i2c_smbus_read_i2c_block_data_or_emulated(client,
 								   offset,
 								   count, buf);
@@ -243,7 +234,9 @@ static ssize_t at24_eeprom_read_smbus(struct at24_data *at24, char *buf,
 
 		if (status == count)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(read_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -283,7 +276,14 @@ static ssize_t at24_eeprom_read_i2c(struct at24_data *at24, char *buf,
 	msg[1].buf = buf;
 	msg[1].len = count;
 
-	loop_until_timeout(timeout, read_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		read_time = jiffies;
+
 		status = i2c_transfer(client->adapter, msg, 2);
 		if (status == 2)
 			status = count;
@@ -293,7 +293,9 @@ static ssize_t at24_eeprom_read_i2c(struct at24_data *at24, char *buf,
 
 		if (status == count)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(read_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -342,11 +344,20 @@ static ssize_t at24_eeprom_read_serial(struct at24_data *at24, char *buf,
 	msg[1].buf = buf;
 	msg[1].len = count;
 
-	loop_until_timeout(timeout, read_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		read_time = jiffies;
+
 		status = i2c_transfer(client->adapter, msg, 2);
 		if (status == 2)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(read_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -373,11 +384,20 @@ static ssize_t at24_eeprom_read_mac(struct at24_data *at24, char *buf,
 	msg[1].buf = buf;
 	msg[1].len = count;
 
-	loop_until_timeout(timeout, read_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		read_time = jiffies;
+
 		status = i2c_transfer(client->adapter, msg, 2);
 		if (status == 2)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(read_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -419,7 +439,14 @@ static ssize_t at24_eeprom_write_smbus_block(struct at24_data *at24,
 	client = at24_translate_offset(at24, &offset);
 	count = at24_adjust_write_count(at24, offset, count);
 
-	loop_until_timeout(timeout, write_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		write_time = jiffies;
+
 		status = i2c_smbus_write_i2c_block_data(client,
 							offset, count, buf);
 		if (status == 0)
@@ -430,7 +457,9 @@ static ssize_t at24_eeprom_write_smbus_block(struct at24_data *at24,
 
 		if (status == count)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(write_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -445,7 +474,14 @@ static ssize_t at24_eeprom_write_smbus_byte(struct at24_data *at24,
 
 	client = at24_translate_offset(at24, &offset);
 
-	loop_until_timeout(timeout, write_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		write_time = jiffies;
+
 		status = i2c_smbus_write_byte_data(client, offset, buf[0]);
 		if (status == 0)
 			status = count;
@@ -455,7 +491,9 @@ static ssize_t at24_eeprom_write_smbus_byte(struct at24_data *at24,
 
 		if (status == count)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(write_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -484,7 +522,14 @@ static ssize_t at24_eeprom_write_i2c(struct at24_data *at24, const char *buf,
 	memcpy(&msg.buf[i], buf, count);
 	msg.len = i + count;
 
-	loop_until_timeout(timeout, write_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		write_time = jiffies;
+
 		status = i2c_transfer(client->adapter, &msg, 1);
 		if (status == 1)
 			status = count;
@@ -494,7 +539,9 @@ static ssize_t at24_eeprom_write_i2c(struct at24_data *at24, const char *buf,
 
 		if (status == count)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(write_time, timeout));
 
 	return -ETIMEDOUT;
 }
-- 
2.17.1

