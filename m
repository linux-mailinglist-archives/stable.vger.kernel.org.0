Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887E42E34F1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgL1IIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:08:54 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:42377 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgL1IIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:08:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2E402746;
        Mon, 28 Dec 2020 03:07:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:07:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=30eCiF
        5dPKd+GwhNkRtWp6Okzv8Oifk+LZ0RTTsKoys=; b=mmGE7sit5ovCvPFMlhVcMo
        Zw1NV7Ug8wRI6BnwDJuxAMZQH00umWYwQkhZ+oGoNrxsG6iZTnAxeEtAbVtLw+Wv
        7ExmhPoC6bSehOLFfAvrLq9yuaOo7khbHoSpb42EYs1aMYDA4BcBwe64Y/DmZnI1
        d+kh4Wc36zAkk+JQVjDZ/we7Ef3X7ebSlEDJz8yCzdKHvJ1E5WtwPWv622O2t1tf
        sbozmepAw1DDMwW36O0PTP5QMZkH1gVdlhh5rBt70epawpTXRgx9SL7NTqxcOaqJ
        rBR5p1FUqo2YPVvUjqbXIejpeQ1POlHoVTDtynZ7a7nzvjSvSm8w86w+oi4XsKWg
        ==
X-ME-Sender: <xms:U5LpXxry0k-zBg8a6sQZd0MhrpRvTLe0fGmqobma_-22iCBJ47_UOg>
    <xme:U5LpXzqNQoYFTgjafJkg9z-WJ0pXHK-uQGFmy2z_AJt8q5tHNlNEnxPWV9NB6sAyE
    _ueCgnXhVTJvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:U5LpX-OVEGp6EsX0TR9W28RWZxDe96UuZS_pVC2ra1YfNHzoc88kpA>
    <xmx:U5LpX84v4VtFC0wKAWOPUA6yEL_6buCYEsHPOmKNsdzRkuepaDULmQ>
    <xmx:U5LpXw4zAGKh9ha_W38zxkqy2Vh2Fx67ZW9eT1G25K5YTHe8xRVglw>
    <xmx:U5LpX-mzkFAqmD18i_DTnQW9-KJqZHkj990BDztk0zHj5xanrI24hS8JKD8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 779E9240062;
        Mon, 28 Dec 2020 03:07:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: ipu3-cio2: Serialise access to pad format" failed to apply to 4.19-stable tree
To:     sakari.ailus@linux.intel.com, andy.shevchenko@gmail.com,
        bingbu.cao@intel.com, laurent.pinchart@ideasonboard.com,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:09:08 +0100
Message-ID: <1609142948224162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

