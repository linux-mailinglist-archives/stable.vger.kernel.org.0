Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3467C2E34EF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgL1IIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:08:48 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:37673 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgL1IIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:08:48 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D9F7F731;
        Mon, 28 Dec 2020 03:07:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:07:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Lnk5NF
        P7AYv2t9SbwIpgUSe3lBRy06acZC9D5Vzf7co=; b=IGxzoVn1CDJhieiQCQPp9C
        u4bHho82TuBiwX8nJJo2u7WALs6Il8wCWkYxrgC+CErU6UPgaylMxFxq0ZdTQ3GM
        FQsCs20oZinRdwkRWjRzRtdnR8jSovxWKl+Bs8mxoCja/UUo0h7RUwn2xEYVpVtj
        PO6WvE8KPeKllKyew2oQ183+jT0jrI0zsEf6YfcURzfZBxvxRfTfe9425qtvOl0u
        wWDt63q63jvMB/0z7RxcrRdUAEmXjUakeupvD7pvA/+HL1cIc0c65fc5itID0ryP
        GsLl69pHCDT0QZZl4zClRI24ovqZkwjoWE4mVHf5EdjGYIfdwQkppPHYckWhzn5g
        ==
X-ME-Sender: <xms:TZLpX7yfRVqB8e6Bn_FVJS9Syiu-dBb3sgFU-Be4zKPiYQzUrGvAdQ>
    <xme:TZLpXzQHbo7aQJtX6h8ZcZqoPKCPbOJXy4hm3WuUEHhYRJU6lNMWQQKHTARij_cMx
    vCwU6NjySfl2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:TZLpX1UhojL2D4TykW1ZlMEhFNPotVfeUMTsOFu_0UpUSdjsW5m9DA>
    <xmx:TZLpX1j7Oe4mFQFHDh2uO-MtXm5MxZnqbrHh3BOWBkTYfLjzpVaRSw>
    <xmx:TZLpX9DY5MeUvfF7ABd7nUHfmABIQ8ETShyT1kQ4jqiWAX0xTbfTaw>
    <xmx:TZLpX8MsrpKu1SmBMEjKip8ZHuVkbSNDtqAB2r5pqYQmPtGByKUEA5GZVco>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED90D24005C;
        Mon, 28 Dec 2020 03:07:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: ipu3-cio2: Make the field on subdev format" failed to apply to 4.19-stable tree
To:     sakari.ailus@linux.intel.com, andy.shevchenko@gmail.com,
        bingbu.cao@intel.com, laurent.pinchart@ideasonboard.com,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:08:55 +0100
Message-ID: <160914293515289@kroah.com>
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

