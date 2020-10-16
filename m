Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4103F28FF48
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 09:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404668AbgJPHko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 03:40:44 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:60719 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394562AbgJPHko (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 03:40:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1959211FA;
        Fri, 16 Oct 2020 03:40:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 16 Oct 2020 03:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=j8Afzc
        bCxb4b6zWxHQCB1a8576mIRlma/35m2ZrmY3k=; b=P8ItNjgS82AAtJ+Dxmp6gz
        sZBappr0/RDDI9wNH0fWJF14Ud0j9mY2nr49olXDd4k3mzwfYxYjEC3NX4hLtfFP
        v7jlyL/C9RV208cF9PuyytzM9LzuHqcmp5d/UJYr+zYVTBo8St1A/5FI/4d/udHU
        J2mCKC3P9JDjwgsvZlQngS5sVJYk1lcVWbwlBD4WnXcgdmQJI6bpdzBXH2YPET0/
        rbKJKr2MyMKElqExN31mx9W5KhagZNcAr+WZMr8t7g7CAB4m6SlpWkIMh6aYBRMN
        +ez5BBM113BY70zceruJ8NRY39Mpasll8xWj5X3zieBBFnMbAWn320a3bSDzZMdg
        ==
X-ME-Sender: <xms:eE6JX38hNkIVKZU0oNkK3w__JDytBwc1bs_eAAV9abQvGE3RPYVHlA>
    <xme:eE6JXzt5Lh5YBNkx_bTbnS5On8Uf_7xU9mFfnCoSgzyVXhO6KT_teNVKXqmrw3CIu
    bAJGmIP0APLFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrieeggdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgffhfffffedtkedvkeeiteehheetkefffefhtddvhf
    egudefvddtvedvheegheevnecuffhomhgrihhnpehshiiikhgrlhhlvghrrdgrphhpshhp
    ohhtrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvghes
    khhrohgrhhdrtghomh
X-ME-Proxy: <xmx:eE6JX1D4eH51vjhebQ-y8mpcej3wxFri-zeZFnQR7lgng1QWvvd6jA>
    <xmx:eE6JXzcGPRc8uIN8taIKb6bxLvdBtgEcta8KhJ5_tmDcIw_J2w6r4g>
    <xmx:eE6JX8PTiGFFk_c2anxWfqstW92ApuqYz49pL1r_P2V7LuH2WFmJmg>
    <xmx:eE6JX1Z2IwNsWAwVbU1rwbraA2KFR1hVuHtyLBQcCNcv8kIBwqKnLYDyVxw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DB8E53280064;
        Fri, 16 Oct 2020 03:40:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] vt_ioctl: make VT_RESIZEX behave like VT_RESIZE" failed to apply to 5.8-stable tree
To:     penguin-kernel@i-love.sakura.ne.jp, gregkh@linuxfoundation.org,
        penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org,
        syzbot+16469b5e8e5a72e9131e@syzkaller.appspotmail.com,
        syzbot+b308f5fd049fbbc6e74f@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 16 Oct 2020 09:41:11 +0200
Message-ID: <160283407120483@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 988d0763361bb65690d60e2bc53a6b72777040c3 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date: Sun, 27 Sep 2020 20:46:30 +0900
Subject: [PATCH] vt_ioctl: make VT_RESIZEX behave like VT_RESIZE

syzbot is reporting UAF/OOB read at bit_putcs()/soft_cursor() [1][2], for
vt_resizex() from ioctl(VT_RESIZEX) allows setting font height larger than
actual font height calculated by con_font_set() from ioctl(PIO_FONT).
Since fbcon_set_font() from con_font_set() allocates minimal amount of
memory based on actual font height calculated by con_font_set(),
use of vt_resizex() can cause UAF/OOB read for font data.

VT_RESIZEX was introduced in Linux 1.3.3, but it is unclear that what
comes to the "+ more" part, and I couldn't find a user of VT_RESIZEX.

  #define VT_RESIZE   0x5609 /* set kernel's idea of screensize */
  #define VT_RESIZEX  0x560A /* set kernel's idea of screensize + more */

So far we are not aware of syzbot reports caused by setting non-zero value
to v_vlin parameter. But given that it is possible that nobody is using
VT_RESIZEX, we can try removing support for v_clin and v_vlin parameters.

Therefore, this patch effectively makes VT_RESIZEX behave like VT_RESIZE,
with emitting a message if somebody is still using v_clin and/or v_vlin
parameters.

[1] https://syzkaller.appspot.com/bug?id=32577e96d88447ded2d3b76d71254fb855245837
[2] https://syzkaller.appspot.com/bug?id=6b8355d27b2b94fb5cedf4655e3a59162d9e48e3

Reported-by: syzbot <syzbot+b308f5fd049fbbc6e74f@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+16469b5e8e5a72e9131e@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/4933b81b-9b1a-355b-df0e-9b31e8280ab9@i-love.sakura.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 2ea76a09e07f..0a33b8ababe3 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -772,58 +772,21 @@ static int vt_resizex(struct vc_data *vc, struct vt_consize __user *cs)
 	if (copy_from_user(&v, cs, sizeof(struct vt_consize)))
 		return -EFAULT;
 
-	/* FIXME: Should check the copies properly */
-	if (!v.v_vlin)
-		v.v_vlin = vc->vc_scan_lines;
-
-	if (v.v_clin) {
-		int rows = v.v_vlin / v.v_clin;
-		if (v.v_rows != rows) {
-			if (v.v_rows) /* Parameters don't add up */
-				return -EINVAL;
-			v.v_rows = rows;
-		}
-	}
-
-	if (v.v_vcol && v.v_ccol) {
-		int cols = v.v_vcol / v.v_ccol;
-		if (v.v_cols != cols) {
-			if (v.v_cols)
-				return -EINVAL;
-			v.v_cols = cols;
-		}
-	}
-
-	if (v.v_clin > 32)
-		return -EINVAL;
+	if (v.v_vlin)
+		pr_info_once("\"struct vt_consize\"->v_vlin is ignored. Please report if you need this.\n");
+	if (v.v_clin)
+		pr_info_once("\"struct vt_consize\"->v_clin is ignored. Please report if you need this.\n");
 
+	console_lock();
 	for (i = 0; i < MAX_NR_CONSOLES; i++) {
-		struct vc_data *vcp;
+		vc = vc_cons[i].d;
 
-		if (!vc_cons[i].d)
-			continue;
-		console_lock();
-		vcp = vc_cons[i].d;
-		if (vcp) {
-			int ret;
-			int save_scan_lines = vcp->vc_scan_lines;
-			int save_font_height = vcp->vc_font.height;
-
-			if (v.v_vlin)
-				vcp->vc_scan_lines = v.v_vlin;
-			if (v.v_clin)
-				vcp->vc_font.height = v.v_clin;
-			vcp->vc_resize_user = 1;
-			ret = vc_resize(vcp, v.v_cols, v.v_rows);
-			if (ret) {
-				vcp->vc_scan_lines = save_scan_lines;
-				vcp->vc_font.height = save_font_height;
-				console_unlock();
-				return ret;
-			}
+		if (vc) {
+			vc->vc_resize_user = 1;
+			vc_resize(vc, v.v_cols, v.v_rows);
 		}
-		console_unlock();
 	}
+	console_unlock();
 
 	return 0;
 }

