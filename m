Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087F3369AA5
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 21:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbhDWTIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 15:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhDWTIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 15:08:40 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4FAC061574
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 12:08:02 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id m9so36632861wrx.3
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 12:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AZTcrHpF7hvFajIULl6/M32maDopzlQ5eSz6UUFOVfc=;
        b=O6vUqqaqZrQcIpp+a35ASDb9X9tKoqLJnhM2MjcQuQgOC5cQmZO6j02lTE28c26wWe
         vZFjvvqDJfGHUisCglRziU26V3DK2CgROe3szK5wvEiRc01AIKJLVr0C5x2lkvTsNRzo
         7HWo1ie55OqWU3s1vZiWS3j8AETAxBA2v2Kus9JnkY10BN+bILv3QTlSZjA5t9movhSL
         5kKb8pvvoCrdSYjldx9b+ZUFhNBO+Uu2FHu+U9/wEzTKVmcF67ck2G+vfAULjIxErmRS
         bNJBd4aJhLDhEqT6OzPvCsRFp1aArS5zZZjCGfzwXgJ3UIImHYfXhXOTrqJNloI2mXUG
         d6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AZTcrHpF7hvFajIULl6/M32maDopzlQ5eSz6UUFOVfc=;
        b=q9mQ4wYPOijldFK9xCeiMcyuDiOYWZ/F+P0hNlTBlu3s3OQnusWW7sn1FvnMh8Nfi2
         OjnXBI5lv9UxJbmG1OuaigZg3l9I7nYiOS7NaB+0LfPEKhfPD5SrwwvgaXSFuCSy1ajj
         zjKFESBzPss4ANKA9AerpOX5mlViJM+yM/EzuXQhDynLGQuaobO0Xzrc4MPIIZvsuhjf
         JwZ+I8CPn55/8cUQOA7eJZGYoCgUTu8vrDLoEf2iONePOGAbiEozNSY+meRBZRUj+Gji
         GEPkmyrwGH2fjFcIas7aQfwiT80zPaFexWbk213Eabi4QnrObjhKqFGA3mN4YeP194F/
         +LqA==
X-Gm-Message-State: AOAM532VNi9ISny3iCqowQx5i2Mbb/HdjyeGLHs1iAX6FfK+3/dWyVc2
        x17daBPTQSgTfq/+6dunG0DXgtg+5orXyA==
X-Google-Smtp-Source: ABdhPJzvAlYOsCFxk1oBUvtHdpSrbJ7R6spjTm55tFko7Bx8neQ3YSyKRF3kd0d85P1RvGt9Yek9JA==
X-Received: by 2002:adf:f302:: with SMTP id i2mr6176236wro.423.1619204881310;
        Fri, 23 Apr 2021 12:08:01 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id h81sm10333676wmf.41.2021.04.23.12.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 12:08:00 -0700 (PDT)
Date:   Fri, 23 Apr 2021 20:07:59 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mail@anirudhrb.com, davem@davemloft.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net: hso: fix null-ptr-deref during tty
 device unregistration" failed to apply to 4.14-stable tree
Message-ID: <YIMbD19ioXTqm6cp@debian>
References: <161806330327108@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MrP2FNPoI0Nit7xF"
Content-Disposition: inline
In-Reply-To: <161806330327108@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MrP2FNPoI0Nit7xF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sat, Apr 10, 2021 at 04:01:43PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Will also apply for 4.9-stable and 4.4-stable.

--
Regards
Sudip

--MrP2FNPoI0Nit7xF
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-net-hso-fix-null-ptr-deref-during-tty-device-unregis.patch"

From 69dd8d3a3061aa50deec6aa17f9c8da618dd6c21 Mon Sep 17 00:00:00 2001
From: Anirudh Rayabharam <mail@anirudhrb.com>
Date: Wed, 7 Apr 2021 22:57:22 +0530
Subject: [PATCH] net: hso: fix null-ptr-deref during tty device unregistration

commit 8a12f8836145ffe37e9c8733dce18c22fb668b66 upstream

Multiple ttys try to claim the same the minor number causing a double
unregistration of the same device. The first unregistration succeeds
but the next one results in a null-ptr-deref.

The get_free_serial_index() function returns an available minor number
but doesn't assign it immediately. The assignment is done by the caller
later. But before this assignment, calls to get_free_serial_index()
would return the same minor number.

Fix this by modifying get_free_serial_index to assign the minor number
immediately after one is found to be and rename it to obtain_minor()
to better reflect what it does. Similary, rename set_serial_by_index()
to release_minor() and modify it to free up the minor number of the
given hso_serial. Every obtain_minor() should have corresponding
release_minor() call.

Fixes: 72dc1c096c705 ("HSO: add option hso driver")
Reported-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
Tested-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/net/usb/hso.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 0e3d13e192e3..16f81fafde2a 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -626,7 +626,7 @@ static struct hso_serial *get_serial_by_index(unsigned index)
 	return serial;
 }
 
-static int get_free_serial_index(void)
+static int obtain_minor(struct hso_serial *serial)
 {
 	int index;
 	unsigned long flags;
@@ -634,8 +634,10 @@ static int get_free_serial_index(void)
 	spin_lock_irqsave(&serial_table_lock, flags);
 	for (index = 0; index < HSO_SERIAL_TTY_MINORS; index++) {
 		if (serial_table[index] == NULL) {
+			serial_table[index] = serial->parent;
+			serial->minor = index;
 			spin_unlock_irqrestore(&serial_table_lock, flags);
-			return index;
+			return 0;
 		}
 	}
 	spin_unlock_irqrestore(&serial_table_lock, flags);
@@ -644,15 +646,12 @@ static int get_free_serial_index(void)
 	return -1;
 }
 
-static void set_serial_by_index(unsigned index, struct hso_serial *serial)
+static void release_minor(struct hso_serial *serial)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&serial_table_lock, flags);
-	if (serial)
-		serial_table[index] = serial->parent;
-	else
-		serial_table[index] = NULL;
+	serial_table[serial->minor] = NULL;
 	spin_unlock_irqrestore(&serial_table_lock, flags);
 }
 
@@ -2241,6 +2240,7 @@ static int hso_stop_serial_device(struct hso_device *hso_dev)
 static void hso_serial_tty_unregister(struct hso_serial *serial)
 {
 	tty_unregister_device(tty_drv, serial->minor);
+	release_minor(serial);
 }
 
 static void hso_serial_common_free(struct hso_serial *serial)
@@ -2265,25 +2265,23 @@ static int hso_serial_common_create(struct hso_serial *serial, int num_urbs,
 				    int rx_size, int tx_size)
 {
 	struct device *dev;
-	int minor;
 	int i;
 
 	tty_port_init(&serial->port);
 
-	minor = get_free_serial_index();
-	if (minor < 0)
+	if (obtain_minor(serial))
 		goto exit2;
 
 	/* register our minor number */
 	serial->parent->dev = tty_port_register_device_attr(&serial->port,
-			tty_drv, minor, &serial->parent->interface->dev,
+			tty_drv, serial->minor, &serial->parent->interface->dev,
 			serial->parent, hso_serial_dev_groups);
-	if (IS_ERR(serial->parent->dev))
+	if (IS_ERR(serial->parent->dev)) {
+		release_minor(serial);
 		goto exit2;
+	}
 	dev = serial->parent->dev;
 
-	/* fill in specific data for later use */
-	serial->minor = minor;
 	serial->magic = HSO_SERIAL_MAGIC;
 	spin_lock_init(&serial->serial_lock);
 	serial->num_rx_urbs = num_urbs;
@@ -2676,9 +2674,6 @@ static struct hso_device *hso_create_bulk_serial_device(
 
 	serial->write_data = hso_std_serial_write_data;
 
-	/* and record this serial */
-	set_serial_by_index(serial->minor, serial);
-
 	/* setup the proc dirs and files if needed */
 	hso_log_port(hso_dev);
 
@@ -2735,9 +2730,6 @@ struct hso_device *hso_create_mux_serial_device(struct usb_interface *interface,
 	serial->shared_int->ref_count++;
 	mutex_unlock(&serial->shared_int->shared_int_lock);
 
-	/* and record this serial */
-	set_serial_by_index(serial->minor, serial);
-
 	/* setup the proc dirs and files if needed */
 	hso_log_port(hso_dev);
 
@@ -3122,7 +3114,6 @@ static void hso_free_interface(struct usb_interface *interface)
 			cancel_work_sync(&serial_table[i]->async_get_intf);
 			hso_serial_tty_unregister(serial);
 			kref_put(&serial_table[i]->ref, hso_serial_ref_free);
-			set_serial_by_index(i, NULL);
 		}
 	}
 
-- 
2.30.2


--MrP2FNPoI0Nit7xF--
