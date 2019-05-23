Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 208AF2782A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 10:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfEWIiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 04:38:55 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48973 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbfEWIiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 04:38:55 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 368BA2E9C9;
        Thu, 23 May 2019 04:38:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 23 May 2019 04:38:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NhsKdM
        w2qnZ0f2rLFmuIit5cVJxzGqXq6JHI0FwKBio=; b=3jeNoLLmrszfd7iQTcz9WN
        kp92wcQ+1sSgM4eHr3a5sEWLqR5LzDwd2QrkkKk3X8S05Qsm1cZ2FRZBBx7+OS1f
        VMFTPf/MXxGgid+lSKj8t5g0K50nbuS4Y8O5TUFVMh2Em7HgFxPX4dUdcmfD8x64
        97hUK5LBaRbpYudEeMuWiNmn6Jg49lZpwx3A0wxGEHTDMVCpoDI0IkHZxuJvd4Bt
        g8mWlaq0IX/PkMboCT7R/HjBMMLlWTUhonQiHzbtcF7WKwsz49BraiiajF/Ixgk9
        MVQ5cHrYFvzq9p7NfoVM5h5qLjkFJdZlTCmfhRHe1jQOz/S3B+gekWc/YJZhMS5w
        ==
X-ME-Sender: <xms:HlzmXIn1iMD6I3JwCkKOs7dvkNzGIUC7AoemmD_8-uprr7H6U0TL-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:HlzmXPxXLDNpDcClwfg6MJzbuvNXt8-OLXamFtbl9GxXc6-TfHXXFg>
    <xmx:HlzmXN3n41rQvgopi-RepW8GqX2zlh-CbmIcGnRJelNEqYarjkzP-Q>
    <xmx:HlzmXLCk-e90j6il2EL2jWJ3BlN29b4lguW6_NvlFvhQluEeonSTLw>
    <xmx:HlzmXA4CZYBWdwalnTVuuwtY9RJuCJOfWAJMPFkNnXvUObVydcN0Og>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7DEBF80059;
        Thu, 23 May 2019 04:38:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] media: i2c: tda1997x: select V4L2_FWNODE" failed to apply to 4.19-stable tree
To:     koen.vandeputte@ncentric.com, hverkuil-cisco@xs4all.nl,
        mchehab+samsung@kernel.org, sakari.ailus@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 10:38:49 +0200
Message-ID: <1558600729229231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
 

