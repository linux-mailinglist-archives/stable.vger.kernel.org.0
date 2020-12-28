Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1A82E34EE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgL1II0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:08:26 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44331 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726361AbgL1II0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:08:26 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0A4556BF;
        Mon, 28 Dec 2020 03:07:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:07:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7jDx7n
        um0qo8ODoyuo6YfMm5e9WObCi99hbUbLYlJ/w=; b=n/HNv1KZV5lFXttzesHy0F
        izowMzRHV1FPOL81wPuG/t2vvv8KbM++BNJUxajegRBAS06Wrt9JyK9sLIkjaBfY
        RlXCMx697YffyAy/dDi46CYqhmJoqh2kKDp7n7JU61U+b5Jd0Sr0ZhgQpqhNprTr
        h3qSw4CFAYiy+dOL69CpvQC4m1wxSjF7tj7E4ariiHdkFgdyrc7noopVgLiTUrwm
        u/FECVJcl0sbWHS+05258xxjuvGQvT4T3gcR2dqoK0tasY89ErrOA5V5xHNlJecE
        7O2NigDZCLduIsBitcVxnoE6zaQrkeeSeTlDqdg8UC7hmR6J6kqn9fI56aO+vQXg
        ==
X-ME-Sender: <xms:S5LpX_avdMuVEvL6W0ebHh5mcWHV-vLRxvAuVOEJQWXK8YsT5cg1-A>
    <xme:S5LpX-YLhEn_X_h4XiLEPYrW97obdSpa2u-TM9jmTfHXiZuk-F7z5H_k7YKvZTQ4S
    HkyBKeFLeNKqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:S5LpXx8NUlMX-UaPbK3T9fHvVh8LQS5WwKC2TC4ugN7vMN7q-VDhiw>
    <xmx:S5LpX1rcMHG2GMoDCKNZDMoDnMDmRdPxsZBhvHIjPtI4fUKjlenjrA>
    <xmx:S5LpX6pyAoMzaY-KCVJ9NFDUU2OjliADAJ5HXW6tDR1M_XdZeAlr_w>
    <xmx:S5LpX9WypTzIQq9mhHYwNT5NFDEUrl4jLeSUlUMMZUsNO-6Z-3tCz3UHoNk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 201A0108005C;
        Mon, 28 Dec 2020 03:07:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: ipu3-cio2: Make the field on subdev format" failed to apply to 5.4-stable tree
To:     sakari.ailus@linux.intel.com, andy.shevchenko@gmail.com,
        bingbu.cao@intel.com, laurent.pinchart@ideasonboard.com,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:08:54 +0100
Message-ID: <160914293461125@kroah.com>
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

From 219a8b9c04e54872f9a4d566633fb42f08bcbe2a Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Fri, 9 Oct 2020 15:56:05 +0200
Subject: [PATCH] media: ipu3-cio2: Make the field on subdev format
 V4L2_FIELD_NONE

The ipu3-cio2 doesn't make use of the field and this is reflected in V4L2
buffers as well as the try format. Do this in active format, too.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org # v4.16 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 72095f8a4d46..87d040e176f7 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1285,6 +1285,7 @@ static int cio2_subdev_set_fmt(struct v4l2_subdev *sd,
 	fmt->format.width = min_t(u32, fmt->format.width, CIO2_IMAGE_MAX_WIDTH);
 	fmt->format.height = min_t(u32, fmt->format.height,
 				   CIO2_IMAGE_MAX_LENGTH);
+	fmt->format.field = V4L2_FIELD_NONE;
 
 	mutex_lock(&q->subdev_lock);
 	*mbus = fmt->format;

