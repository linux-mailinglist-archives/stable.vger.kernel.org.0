Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C484C156A5E
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBINDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:03:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44869 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727340AbgBINDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:03:01 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1C6DC21368;
        Sun,  9 Feb 2020 08:03:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:03:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mf0Xxd
        5AGRw/iR6NCpKLv0Kzi+t3cmDLoblpyj7lrkw=; b=aVOpgUQ0BFYQfO41NxPLlD
        TNA0/VNy6hgU6mB+jWnJVMzHneQ17MBDQP1V0MQeoquovRt+6KZEPnE/XNv/mRde
        srBudHnoIXqqxbsc8DHQJDMCFWZ/tCdEwOFRz1cHTQf0JvJoNH/DooQLdBw7LQF3
        Sk7VdMuS9V/GNYgR78L16uP6a+371xF/KHck3elWcssEj0HuyGgW1DL3UoL7r8Vp
        frXKrjhgTlfz069gJ4+XMXKwJJ/PBwql0Z0NbyTqYELMRzW81K23D5cR5ITbyUC5
        LXAZ768YM2m1r+TbpKyBlhEkZb4d2xdt8rACAOm924fmvEdew6Xc1W/5aHFZb8rA
        ==
X-ME-Sender: <xms:BANAXuqxdg-qcEqFXBV5NyNmoB86qYdONwJ0WDSd0izjBzamBTv_qQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepfeekrdelke
    drfeejrddufeehnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BANAXg7yPsptSSZHh6xWDo5ZHgiSFlE9w7_uJv9ZCyMZFur3PrCYBA>
    <xmx:BANAXuOQ2LTeMfVyxBXrrxm8uANm73lfakh1zOCPyQjaulJyD2OZwQ>
    <xmx:BANAXiOspAznUXKEeKIBGcODZKuMQmqR7r3y0FjgJzazFLnqJJnFuQ>
    <xmx:BQNAXv7bXkevOPyoyHB6uZLhwzDdymZjED-y3eOF_Xs55zmmjKJOgw>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id D4AEC328005A;
        Sun,  9 Feb 2020 08:02:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm: atmel-hlcdc: enable clock before configuring timing" failed to apply to 4.9-stable tree
To:     claudiu.beznea@microchip.com, boris.brezillon@free-electrons.com,
        sam@ravnborg.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:40:23 +0100
Message-ID: <1581248423255249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

