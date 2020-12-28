Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526702E34ED
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgL1IIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:08:18 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:40937 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgL1IIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:08:18 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 19190559;
        Mon, 28 Dec 2020 03:07:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:07:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lVFDjh
        m/EpsIVxje1tNR65aO6Snj0NSkGYLbapy/ryw=; b=dbcODUueKBjo1a9VvvoFAa
        Fgkdy07N0LiEa94xk4BTInaHxaraaIuEBfRP0VRqQsB7A6fUgFzqwnMlQ1cL9eQa
        kezA4hcm+D6fz6IdCE/PXFEwlMGXg7cLRNZKqbLqYXKKvQ77AQy4xxchubXR0ly0
        tfxkSJ2fUb8fvanJwfA5y7UVhzVKsonMYeYjZi6FNN6rfoYj5Yqjqbp2FTJULMeP
        fJy+tnMruPpRgYVfPzlizAK74YhefzMIze7J0lEYLdvrc7I4FSGa7KR6wDI32/wH
        wkMZWry+Lcrr3UEXQr4MtoBKcI8qPobzRtcDpffJjvyBjl7pYBcTdj6Z7zo8uuJQ
        ==
X-ME-Sender: <xms:Q5LpX7enqog5fGYcLjRQLz10timU9vVl4g4c7LvTtJmxXYKSr-mhsw>
    <xme:Q5LpXxPvARpkPuyQSt0-aWyyXkfDrkwXI7Xil0P3va4W8bYdcMYuXoVqGIb9EPDWm
    zHIBy_ARoV9qA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Q5LpX0g1gqbdFpYHJdI1-j5kuhcd9wKf2P6a8Vm_3w0kKOFx7vm4qA>
    <xmx:Q5LpX8_LkrREH6b4ip-2Wk7N2CRhbWvk4ZQoNN-nVr6LVwMPs-9m8A>
    <xmx:Q5LpX3uFtGYyW7sF2SswIxZd3swYnnYSGYB0kgL_GqjvOtKfaF8j0g>
    <xmx:Q5LpX3K-KvdbO5DU7sA8MJ4YCTzCWh7JaHYYovpLkuGC9kP_0OzbwUcyBc4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B460424005B;
        Mon, 28 Dec 2020 03:07:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: ipu3-cio2: Make the field on subdev format" failed to apply to 5.10-stable tree
To:     sakari.ailus@linux.intel.com, andy.shevchenko@gmail.com,
        bingbu.cao@intel.com, laurent.pinchart@ideasonboard.com,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:08:54 +0100
Message-ID: <160914293422255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

