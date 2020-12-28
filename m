Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949D62E34F2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgL1IJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:09:24 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:36863 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgL1IJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:09:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3C068724;
        Mon, 28 Dec 2020 03:07:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:07:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qdyvxJ
        h33zcsQTEWmovmDP8aiukB5AVbepLGkKhTI48=; b=kVcWmHD1FDyuJ6jMoSipCU
        MB07p3N1vmLNOd+Q50ZoXClYB6x9IDXmuEP436aJfoqx9Bx/iPqbfyCL3Qk2MMWn
        87vm2OdikLF4zFBr3dwEvkRTcmhl/lPDhxazS3cvSqiY2PbtO+NJ6R6JDeJSUT1F
        Em5O21XpkiNbXZQCX49qKM3WrXecAcFjGkEYh0S13BBG5aCmhSnS9QhtmLRXCCzT
        dKQNHtN+Kh6uJqMvL+fzNXOYGGHuptoi6XTxSQAKRlzQc/tPs5VcuUYOMdMzRNMB
        hbObcYnMeEWQ0fUAZ9SdAWrfKyLOtsac/chgaxF3/lB2+2Kd63jdHbCDEJ1VoYaw
        ==
X-ME-Sender: <xms:VZLpXz0DQl5naeDuUcsn4Zh4dnSFIgV5zo0S6r6OgrYfl4rS-XyuaA>
    <xme:VZLpXyFLNptOVJuH6TVtpWsofi98jwAgiTjVDPAD1tvDIlnqcYtoZ2V_Tjl6nB8tH
    eM40wXHDc3GoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:VZLpXz77abWnN7JN_u3972nbkKV5CTxscxvvdZqVFSPeTlBj4BaZ0A>
    <xmx:VZLpX40Z5RvvhVn5HZDcM98muFXUCG5yGP1R_3yvGgWKKdqJYoQudg>
    <xmx:VZLpX2FTwMVIvbub3vvlNepaNpskOdxrx35G6PQ96q4Dd8GoFPSaGQ>
    <xmx:VZLpXyC9C3BFz38zjuUNJFqC0VmjyKVow2n_qWqz6PXBVrhFAD49NEETgVs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3AFDE1080063;
        Mon, 28 Dec 2020 03:07:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: ipu3-cio2: Serialise access to pad format" failed to apply to 5.4-stable tree
To:     sakari.ailus@linux.intel.com, andy.shevchenko@gmail.com,
        bingbu.cao@intel.com, laurent.pinchart@ideasonboard.com,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:09:08 +0100
Message-ID: <160914294826220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 55a6c6b2be3d6670bf5772364d8208bd8dc17da4 Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Thu, 8 Oct 2020 21:29:38 +0200
Subject: [PATCH] media: ipu3-cio2: Serialise access to pad format

Pad format can be accessed from user space. Serialise access to it.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable@vger.kernel.org # v4.16 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index afa472026ba4..b3a08196e08c 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1233,11 +1233,15 @@ static int cio2_subdev_get_fmt(struct v4l2_subdev *sd,
 {
 	struct cio2_queue *q = container_of(sd, struct cio2_queue, subdev);
 
+	mutex_lock(&q->subdev_lock);
+
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
 		fmt->format = *v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 	else
 		fmt->format = q->subdev_fmt;
 
+	mutex_unlock(&q->subdev_lock);
+
 	return 0;
 }
 
@@ -1261,6 +1265,8 @@ static int cio2_subdev_set_fmt(struct v4l2_subdev *sd,
 	if (fmt->pad == CIO2_PAD_SOURCE)
 		return cio2_subdev_get_fmt(sd, cfg, fmt);
 
+	mutex_lock(&q->subdev_lock);
+
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
 	} else {
@@ -1271,6 +1277,8 @@ static int cio2_subdev_set_fmt(struct v4l2_subdev *sd,
 		fmt->format = q->subdev_fmt;
 	}
 
+	mutex_unlock(&q->subdev_lock);
+
 	return 0;
 }
 
@@ -1529,6 +1537,7 @@ static int cio2_queue_init(struct cio2_device *cio2, struct cio2_queue *q)
 
 	/* Initialize miscellaneous variables */
 	mutex_init(&q->lock);
+	mutex_init(&q->subdev_lock);
 
 	/* Initialize formats to default values */
 	fmt = &q->subdev_fmt;
@@ -1645,6 +1654,7 @@ static int cio2_queue_init(struct cio2_device *cio2, struct cio2_queue *q)
 fail_subdev_media_entity:
 	cio2_fbpt_exit(q, &cio2->pci_dev->dev);
 fail_fbpt:
+	mutex_destroy(&q->subdev_lock);
 	mutex_destroy(&q->lock);
 
 	return r;
@@ -1657,6 +1667,7 @@ static void cio2_queue_exit(struct cio2_device *cio2, struct cio2_queue *q)
 	v4l2_device_unregister_subdev(&q->subdev);
 	media_entity_cleanup(&q->subdev.entity);
 	cio2_fbpt_exit(q, &cio2->pci_dev->dev);
+	mutex_destroy(&q->subdev_lock);
 	mutex_destroy(&q->lock);
 }
 
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.h b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
index 549b08f88f0c..146492383aa5 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.h
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
@@ -335,6 +335,7 @@ struct cio2_queue {
 
 	/* Subdev, /dev/v4l-subdevX */
 	struct v4l2_subdev subdev;
+	struct mutex subdev_lock; /* Serialise acces to subdev_fmt field */
 	struct media_pad subdev_pads[CIO2_PADS];
 	struct v4l2_mbus_framefmt subdev_fmt;
 	atomic_t frame_sequence;

