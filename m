Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F81627829
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 10:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfEWIix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 04:38:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52679 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbfEWIix (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 04:38:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0A2512E8BE;
        Thu, 23 May 2019 04:38:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 23 May 2019 04:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ziuedv
        NKrU1iFooFX5uPLWy1Q7WD6H5JmvhSKLajA9c=; b=O+e/TjMCQMbxl31luv2byW
        5NbPbQG7G4tHahWo9AzS5eUp2JnK6dFprwL6d4924rYScLDCw06kJOVWgA1OJEHC
        06CY0eVngx96jlmw+HEGgsh7cyar466CpsgxHA3lFHbOH8PL695e57mvxjRrvEzs
        XapluDuob1k1Y++naULurI8ymm68Nz4X6IFmRKxjfhqNw4MlcivoQZ/paCgb9oKq
        d7pzs5QN1H0qP5XC8a7K3RDTKqq8szFQz+KkRHmxH5YFw11NZyt0uE8aUnUfYgFB
        LMRF/4Apv50tqazZas4jJ0cNqmx6+Akee3wKPoTr2KbcIHtJ8tm/HsqObj/z3Zcw
        ==
X-ME-Sender: <xms:G1zmXB80dwy7SJbtllPxLVuDr28tbE-1Nu5cILDCnW9GCzQnFGm-dQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:G1zmXJ8ATvclouoidSbdq6rbDw1ABh3f_V5MgTRXMG2QMLhJg7l1RQ>
    <xmx:G1zmXKAKBJcI4LpJKINheoX2Ig0Q_gmo199Ecw572V3oMrUZJGdZ9w>
    <xmx:G1zmXJxPw4gIFySQ2kgj8R8Ew_JWbUDJu783UjFuwhjl1_ddQ8pZZw>
    <xmx:HFzmXBshqLLAgBPoUZntjJV5p9uX_Zqxn8GTSJY0Xb77cA-Qu0po7w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E4F18005A;
        Thu, 23 May 2019 04:38:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] media: i2c: tda1997x: select V4L2_FWNODE" failed to apply to 5.0-stable tree
To:     koen.vandeputte@ncentric.com, hverkuil-cisco@xs4all.nl,
        mchehab+samsung@kernel.org, sakari.ailus@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 10:38:48 +0200
Message-ID: <155860072813326@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5f2efda71c09b12012053f457fac7692f268b72c Mon Sep 17 00:00:00 2001
From: Koen Vandeputte <koen.vandeputte@ncentric.com>
Date: Mon, 18 Mar 2019 12:40:05 -0400
Subject: [PATCH] media: i2c: tda1997x: select V4L2_FWNODE

Building tda1997x fails now unless V4L2_FWNODE is selected:

drivers/media/i2c/tda1997x.o: in function `tda1997x_parse_dt'
undefined reference to `v4l2_fwnode_endpoint_parse'

While at it, also sort the selections alphabetically

Fixes: 9ac0038db9a7 ("media: i2c: Add TDA1997x HDMI receiver driver")

Signed-off-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Cc: stable@vger.kernel.org # v4.17+
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 1a1746b3db91..5f5c36442710 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -60,8 +60,9 @@ config VIDEO_TDA1997X
 	tristate "NXP TDA1997x HDMI receiver"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on SND_SOC
-	select SND_PCM
 	select HDMI
+	select SND_PCM
+	select V4L2_FWNODE
 	help
 	  V4L2 subdevice driver for the NXP TDA1997x HDMI receivers.
 

