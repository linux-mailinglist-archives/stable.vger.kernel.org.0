Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DACD156A5D
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgBINCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:02:52 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36459 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:02:52 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3796521368;
        Sun,  9 Feb 2020 08:02:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:02:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=q7++90
        c1N8U3GGoRH316Dt9vjy3wwjN6v2DCPUBBEaM=; b=ZiWDvtQLYDPH4pYVtpPzVI
        +tlu2akhfm9iuuXKc8DnOUthyjJ5H/E4ZrJCa6x9JJlZjdmt14hoLnvqk4RMRDzr
        bC8qEm0M4FYyAljNDmivxK0jf0o41TzlQgl5K5+kq40xj4h4A0zT+Ymphuf4FnsX
        ZB0oXJaJnN5gFjJNJC/UCGvuIl+ag4eomeGZ18yQz3nKAC4ADB8XTlIw+K36CEiz
        QaLD1ND3Xz2lN5shajivVn5sV+2xmkWHdaKgY/XnxaQLK9xNAD6llUvxIgFqE3mk
        +IDNARCGtsLqPCTpWtiJXhywAWkexMVdhgkwxVHmq0U9ohSsr1PBHq0KcQvujjzw
        ==
X-ME-Sender: <xms:_AJAXt4IaHZOv5KTRnuQ2bpDmsCkqEYzHRqip53CNqOH1g0kq5YR8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepfeekrdelke
    drfeejrddufeehnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:_AJAXkuz4QiDbbkD-3zlw3FRLo6YD6GuB6cHmv5KlY1aQt31E5varw>
    <xmx:_AJAXqSsElJ0i5uWL1ZgUgcQJG_SvxKb-8OCESo1QgNMzwMp24qwPg>
    <xmx:_AJAXuIzsAWpV1TZ3lRyRJ8dUu4aZ6GbPAY18iwrCSGunQBv8VmZ3g>
    <xmx:_AJAXmTXE-QToKJIBmV0kEYLURIfbg50SQTvlQ9Ef2_OAvcQrrU0ow>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 13619328005A;
        Sun,  9 Feb 2020 08:02:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm: atmel-hlcdc: enable clock before configuring timing" failed to apply to 4.14-stable tree
To:     claudiu.beznea@microchip.com, boris.brezillon@free-electrons.com,
        sam@ravnborg.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:40:21 +0100
Message-ID: <1581248421244144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2c1fb9d86f6820abbfaa38a6836157c76ccb4e7b Mon Sep 17 00:00:00 2001
From: Claudiu Beznea <claudiu.beznea@microchip.com>
Date: Wed, 18 Dec 2019 14:28:25 +0200
Subject: [PATCH] drm: atmel-hlcdc: enable clock before configuring timing
 engine

Changing pixel clock source without having this clock source enabled
will block the timing engine and the next operations after (in this case
setting ATMEL_HLCDC_CFG(5) settings in atmel_hlcdc_crtc_mode_set_nofb()
will fail). It is recomended (although in datasheet this is not present)
to actually enabled pixel clock source before doing any changes on timing
enginge (only SAM9X60 datasheet specifies that the peripheral clock and
pixel clock must be enabled before using LCD controller).

Fixes: 1a396789f65a ("drm: add Atmel HLCDC Display Controller support")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: <stable@vger.kernel.org> # v4.0+
Link: https://patchwork.freedesktop.org/patch/msgid/1576672109-22707-3-git-send-email-claudiu.beznea@microchip.com

diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
index 5040ed8d0871..721fa88bf71d 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
@@ -73,7 +73,11 @@ static void atmel_hlcdc_crtc_mode_set_nofb(struct drm_crtc *c)
 	unsigned long prate;
 	unsigned int mask = ATMEL_HLCDC_CLKDIV_MASK | ATMEL_HLCDC_CLKPOL;
 	unsigned int cfg = 0;
-	int div;
+	int div, ret;
+
+	ret = clk_prepare_enable(crtc->dc->hlcdc->sys_clk);
+	if (ret)
+		return;
 
 	vm.vfront_porch = adj->crtc_vsync_start - adj->crtc_vdisplay;
 	vm.vback_porch = adj->crtc_vtotal - adj->crtc_vsync_end;
@@ -147,6 +151,8 @@ static void atmel_hlcdc_crtc_mode_set_nofb(struct drm_crtc *c)
 			   ATMEL_HLCDC_VSPSU | ATMEL_HLCDC_VSPHO |
 			   ATMEL_HLCDC_GUARDTIME_MASK | ATMEL_HLCDC_MODE_MASK,
 			   cfg);
+
+	clk_disable_unprepare(crtc->dc->hlcdc->sys_clk);
 }
 
 static enum drm_mode_status

