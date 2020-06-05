Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D010F1EFDE2
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgFEQ2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbgFEQ0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:21 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA89C08C5C2;
        Fri,  5 Jun 2020 09:26:21 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r10so5335423pgv.8;
        Fri, 05 Jun 2020 09:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h7GMiEUFly34W6euhCTBI4Vi3nlGj61crwNdB4LakO0=;
        b=pViyF2rYBNiOnbRrQNw0NqNvo/69q4GLNmfeA0aVKtGplGv9pTYIpM6fdMn2EZfl+o
         IIbvRII+u8lxX5spmKvpjmY+dSzDsMviDAQPDysQoC5TOMFq3/hjjaQxceiNm9ndGCLr
         7pIPyUhgofmO0C0qjArO0KBDZcUhYFPbnu9ap27mvja4APWiixkF9LbO96lRiz+UHfIw
         Rp0j7iLBe9C+GHbqdBdhd6eSct9OUc6P5Nd4RqFKuEDHvMC2WEjA5VIEWyQyUKnE1lMi
         6/6rkhaQRW110OSjlkbZ8Xv4nWmLkt5GTTIvklS7/c2oflNpxswjSyroyEPUacxN9+UI
         GZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h7GMiEUFly34W6euhCTBI4Vi3nlGj61crwNdB4LakO0=;
        b=JkCYFidI0twzXIN7F/3CVM4qqzeXd4pSH9LwuywK4dR1x4u3L3xT2LImPZ0aEBjmCb
         JmCorgRK7A8bXqCncCk4FrXeyHpt8QPUAXmBS2w2ax+hH3sqIgJXwFgPnZK0pfm0auAE
         73BGRHbd9sKRDjLjRIDluDW1WTAgNKMwwhe8R5DQF1iSeBApNJ7AaaxusG30iYUOULd8
         3/M2kMI+fSTKFgQoFWlK6LsWr4/sHDVwVT6aq9VEaovWjo6fDGRa/Y/9uSJXuloUp8Qj
         iDuN8L0+A+WxQvp1MczXcI4AuKXrjybkAfh7uM3YKEbrnHFqVWnUxBYDOu4/9jSRiT8o
         1ayg==
X-Gm-Message-State: AOAM532kDSXt0ngDUibIiSUUhDCFECfg+69lwJhdqtdXZSTXVf7lFlHN
        Edj6anP8gy6/vhxg4weCb8LZyYhx
X-Google-Smtp-Source: ABdhPJzRIP/gIQo9Dk0GcBQy1zrppFa20rhEprLSvKmfuvBPPCoKOLkwLd5wn1KmtvIs+o+ibZtKtg==
X-Received: by 2002:aa7:9293:: with SMTP id j19mr10050340pfa.96.1591374380248;
        Fri, 05 Jun 2020 09:26:20 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:19 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
X-Google-Original-From: Florian Fainelli <florian.fainelli@broadcom.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure))
Subject: [PATCH stable 4.9 11/21] media: dvb_frontend: cleanup ioctl handling logic
Date:   Fri,  5 Jun 2020 09:25:08 -0700
Message-Id: <20200605162518.28099-12-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit d73dcf0cdb95a47f7e4e991ab63dd30f6eb67b4e upstream

Currently, there are two handlers for ioctls:
 - dvb_frontend_ioctl_properties()
 - dvb_frontend_ioctl_legacy()

Despite their names, both handles non-legacy DVB ioctls.

Besides that, there's no reason why to not handle all ioctls
on a single handler function.

So, merge them into a single function (dvb_frontend_handle_ioctl)
and reorganize the ioctl's to indicate what's the current DVB
API and what's deprecated.

Despite the big diff, the handling logic for each ioctl is the
same as before.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 328 +++++++++++++-------------
 1 file changed, 158 insertions(+), 170 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c446f51be21a..5b06ac91420f 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1296,10 +1296,8 @@ static int dtv_get_frontend(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int dvb_frontend_ioctl_legacy(struct file *file,
-			unsigned int cmd, void *parg);
-static int dvb_frontend_ioctl_properties(struct file *file,
-			unsigned int cmd, void *parg);
+static int dvb_frontend_handle_ioctl(struct file *file,
+				     unsigned int cmd, void *parg);
 
 static int dtv_property_process_get(struct dvb_frontend *fe,
 				    const struct dtv_frontend_properties *c,
@@ -1801,12 +1799,12 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		break;
 	case DTV_VOLTAGE:
 		c->voltage = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
+		r = dvb_frontend_handle_ioctl(file, FE_SET_VOLTAGE,
 			(void *)c->voltage);
 		break;
 	case DTV_TONE:
 		c->sectone = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
+		r = dvb_frontend_handle_ioctl(file, FE_SET_TONE,
 			(void *)c->sectone);
 		break;
 	case DTV_CODE_RATE_HP:
@@ -1913,14 +1911,13 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	return r;
 }
 
-static int dvb_frontend_ioctl(struct file *file,
-			unsigned int cmd, void *parg)
+static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	int err = -EOPNOTSUPP;
+	int err;
 
 	dev_dbg(fe->dvb->device, "%s: (%d)\n", __func__, _IOC_NR(cmd));
 	if (down_interruptible(&fepriv->sem))
@@ -1938,121 +1935,13 @@ static int dvb_frontend_ioctl(struct file *file,
 		return -EPERM;
 	}
 
-	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
-		err = dvb_frontend_ioctl_properties(file, cmd, parg);
-	else {
-		c->state = DTV_UNDEFINED;
-		err = dvb_frontend_ioctl_legacy(file, cmd, parg);
-	}
+	c->state = DTV_UNDEFINED;
+	err = dvb_frontend_handle_ioctl(file, cmd, parg);
 
 	up(&fepriv->sem);
 	return err;
 }
 
-static int dvb_frontend_ioctl_properties(struct file *file,
-			unsigned int cmd, void *parg)
-{
-	struct dvb_device *dvbdev = file->private_data;
-	struct dvb_frontend *fe = dvbdev->priv;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int err, i;
-
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
-
-	switch(cmd) {
-	case FE_SET_PROPERTY: {
-		struct dtv_properties *tvps = parg;
-		struct dtv_property *tvp = NULL;
-
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
-			__func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
-			__func__, tvps->props);
-
-		/*
-		 * Put an arbitrary limit on the number of messages that can
-		 * be sent at once
-		 */
-		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
-			return -EINVAL;
-
-		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
-		if (IS_ERR(tvp))
-			return PTR_ERR(tvp);
-
-		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_set(fe, tvp + i, file);
-			if (err < 0) {
-				kfree(tvp);
-				return err;
-			}
-			(tvp + i)->result = err;
-		}
-
-		if (c->state == DTV_TUNE)
-			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
-
-		kfree(tvp);
-		break;
-	}
-	case FE_GET_PROPERTY: {
-		struct dtv_properties *tvps = parg;
-		struct dtv_property *tvp = NULL;
-		struct dtv_frontend_properties getp = fe->dtv_property_cache;
-
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
-			__func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
-			__func__, tvps->props);
-
-		/*
-		 * Put an arbitrary limit on the number of messages that can
-		 * be sent at once
-		 */
-		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
-			return -EINVAL;
-
-		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
-		if (IS_ERR(tvp))
-			return PTR_ERR(tvp);
-
-		/*
-		 * Let's use our own copy of property cache, in order to
-		 * avoid mangling with DTV zigzag logic, as drivers might
-		 * return crap, if they don't check if the data is available
-		 * before updating the properties cache.
-		 */
-		if (fepriv->state != FESTATE_IDLE) {
-			err = dtv_get_frontend(fe, &getp, NULL);
-			if (err < 0) {
-				kfree(tvp);
-				return err;
-			}
-		}
-		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_get(fe, &getp, tvp + i, file);
-			if (err < 0) {
-				kfree(tvp);
-				return err;
-			}
-			(tvp + i)->result = err;
-		}
-
-		if (copy_to_user((void __user *)tvps->props, tvp,
-				 tvps->num * sizeof(struct dtv_property))) {
-			kfree(tvp);
-			return -EFAULT;
-		}
-		kfree(tvp);
-		break;
-	}
-	default:
-		return -ENOTSUPP;
-	} /* switch */
-	return 0;
-}
-
 static int dtv_set_frontend(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -2190,16 +2079,105 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 }
 
 
-static int dvb_frontend_ioctl_legacy(struct file *file,
-			unsigned int cmd, void *parg)
+static int dvb_frontend_handle_ioctl(struct file *file,
+				     unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int err = -EOPNOTSUPP;
+	int i, err;
+
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+
+	switch(cmd) {
+	case FE_SET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
+
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
+
+		for (i = 0; i < tvps->num; i++) {
+			err = dtv_property_process_set(fe, tvp + i, file);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+			(tvp + i)->result = err;
+		}
+
+		if (c->state == DTV_TUNE)
+			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
+
+		kfree(tvp);
+		break;
+	}
+	case FE_GET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
+		struct dtv_frontend_properties getp = fe->dtv_property_cache;
+
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
+
+		/*
+		 * Let's use our own copy of property cache, in order to
+		 * avoid mangling with DTV zigzag logic, as drivers might
+		 * return crap, if they don't check if the data is available
+		 * before updating the properties cache.
+		 */
+		if (fepriv->state != FESTATE_IDLE) {
+			err = dtv_get_frontend(fe, &getp, NULL);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+		}
+		for (i = 0; i < tvps->num; i++) {
+			err = dtv_property_process_get(fe, &getp, tvp + i, file);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+			(tvp + i)->result = err;
+		}
+
+		if (copy_to_user((void __user *)tvps->props, tvp,
+				 tvps->num * sizeof(struct dtv_property))) {
+			kfree(tvp);
+			return -EFAULT;
+		}
+		kfree(tvp);
+		break;
+	}
 
-	switch (cmd) {
 	case FE_GET_INFO: {
 		struct dvb_frontend_info* info = parg;
 
@@ -2263,42 +2241,6 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		break;
 	}
 
-	case FE_READ_BER:
-		if (fe->ops.read_ber) {
-			if (fepriv->thread)
-				err = fe->ops.read_ber(fe, (__u32 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
-	case FE_READ_SIGNAL_STRENGTH:
-		if (fe->ops.read_signal_strength) {
-			if (fepriv->thread)
-				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
-	case FE_READ_SNR:
-		if (fe->ops.read_snr) {
-			if (fepriv->thread)
-				err = fe->ops.read_snr(fe, (__u16 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
-	case FE_READ_UNCORRECTED_BLOCKS:
-		if (fe->ops.read_ucblocks) {
-			if (fepriv->thread)
-				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
 	case FE_DISEQC_RESET_OVERLOAD:
 		if (fe->ops.diseqc_reset_overload) {
 			err = fe->ops.diseqc_reset_overload(fe);
@@ -2350,6 +2292,23 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		}
 		break;
 
+	case FE_DISEQC_RECV_SLAVE_REPLY:
+		if (fe->ops.diseqc_recv_slave_reply)
+			err = fe->ops.diseqc_recv_slave_reply(fe, (struct dvb_diseqc_slave_reply*) parg);
+		break;
+
+	case FE_ENABLE_HIGH_LNB_VOLTAGE:
+		if (fe->ops.enable_high_lnb_voltage)
+			err = fe->ops.enable_high_lnb_voltage(fe, (long) parg);
+		break;
+
+	case FE_SET_FRONTEND_TUNE_MODE:
+		fepriv->tune_mode_flags = (unsigned long) parg;
+		err = 0;
+		break;
+
+	/* DEPRECATED dish control ioctls */
+
 	case FE_DISHNETWORK_SEND_LEGACY_CMD:
 		if (fe->ops.dishnetwork_send_legacy_command) {
 			err = fe->ops.dishnetwork_send_legacy_command(fe,
@@ -2414,16 +2373,46 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		}
 		break;
 
-	case FE_DISEQC_RECV_SLAVE_REPLY:
-		if (fe->ops.diseqc_recv_slave_reply)
-			err = fe->ops.diseqc_recv_slave_reply(fe, (struct dvb_diseqc_slave_reply*) parg);
+	/* DEPRECATED statistics ioctls */
+
+	case FE_READ_BER:
+		if (fe->ops.read_ber) {
+			if (fepriv->thread)
+				err = fe->ops.read_ber(fe, (__u32 *) parg);
+			else
+				err = -EAGAIN;
+		}
 		break;
 
-	case FE_ENABLE_HIGH_LNB_VOLTAGE:
-		if (fe->ops.enable_high_lnb_voltage)
-			err = fe->ops.enable_high_lnb_voltage(fe, (long) parg);
+	case FE_READ_SIGNAL_STRENGTH:
+		if (fe->ops.read_signal_strength) {
+			if (fepriv->thread)
+				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
+			else
+				err = -EAGAIN;
+		}
+		break;
+
+	case FE_READ_SNR:
+		if (fe->ops.read_snr) {
+			if (fepriv->thread)
+				err = fe->ops.read_snr(fe, (__u16 *) parg);
+			else
+				err = -EAGAIN;
+		}
+		break;
+
+	case FE_READ_UNCORRECTED_BLOCKS:
+		if (fe->ops.read_ucblocks) {
+			if (fepriv->thread)
+				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
+			else
+				err = -EAGAIN;
+		}
 		break;
 
+	/* DEPRECATED DVBv3 ioctls */
+
 	case FE_SET_FRONTEND:
 		err = dvbv3_set_delivery_system(fe);
 		if (err)
@@ -2450,11 +2439,10 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		err = dtv_get_frontend(fe, &getp, parg);
 		break;
 	}
-	case FE_SET_FRONTEND_TUNE_MODE:
-		fepriv->tune_mode_flags = (unsigned long) parg;
-		err = 0;
-		break;
-	}
+
+	default:
+		return -ENOTSUPP;
+	} /* switch */
 
 	return err;
 }
-- 
2.17.1

