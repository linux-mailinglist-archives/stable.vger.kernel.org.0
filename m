Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335ED22ECC0
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 15:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgG0NDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 09:03:51 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:53643 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728367AbgG0NDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 09:03:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6D4D81940716;
        Mon, 27 Jul 2020 09:03:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Jul 2020 09:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=86PBBI
        DOU71EqeI0/AM/4UzjhOhArIw9uG7nuUWDLRM=; b=aL5hNpqcBkXiI8XSJfJ02e
        ygpAo26ble7aA8lHA+RzG2qL/2nGT2If8z+fcNjQm4QIAVuBw2I1M6REkBFGAj/N
        bBhqiatSjLFWFHkhE42BJmEGZ9MPLh2qpSwZHwxgN6hRlY07RPwp/KIHBtmq8i8a
        qaBBs/BEGSfHmfz+aPq+XbDpRmmcxG7ubf7Y3ROrWmKjfkhLLzWtU9bWPNcEu61q
        vsCL7nJF61NMwZE1bd6LBsTK80EvTROZrT4gIW8uRjqNhfQ+vlI7r6GNRIgESUCu
        BsHuM5UL1FzG9cq0xYae71ctmRN3ojhYFaUfGg4SEJ5TLRBlbeo2sR/N2y2KUO1w
        ==
X-ME-Sender: <xms:tNAeX0MhjOIh0Rf4boXJHNq71o1Cts5lf8lQwYiB4hzGlLAhCVWFqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedtgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecuogfuuhhsphgvtghtffhomhgrihhnucdlgeelmdenuc
    fjughrpefuvffhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhhes
    lhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepfeegue
    eggeekffefgeekveeggeffgeeljeekjeekleeuffegheefieduffekuefhnecuffhomhgr
    ihhnpegrphhpshhpohhtrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:tNAeX693RmeyCLSbit6pMZxxu0vD59ZSsztpynq4ATf3SafAbg6qnQ>
    <xmx:tNAeX7SHPFeJQ1SUb-0Uoz4ZSiya-Wh9kL64nJbk_1lunJsGl9QX6A>
    <xmx:tNAeX8vrhP1zOj3Qd3RxWA0LXPtKP7AdIGCJK7WfCo5QayO7cwgNag>
    <xmx:tdAeX4GFQ4H9g0kWUTX54kGxVRxQsPM-4gROkpKEfXEdp8roz4pEtA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7B1853280068;
        Mon, 27 Jul 2020 09:03:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fbdev: Detect integer underflow at "struct" failed to apply to 4.9-stable tree
To:     penguin-kernel@I-love.SAKURA.ne.jp, daniel.vetter@ffwll.ch,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        syzbot+e5fd3e65515b48c02a30@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jul 2020 15:03:44 +0200
Message-ID: <1595855024210244@kroah.com>
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

From 033724d6864245a11f8e04c066002e6ad22b3fd0 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 15 Jul 2020 10:51:02 +0900
Subject: [PATCH] fbdev: Detect integer underflow at "struct
 fbcon_ops"->clear_margins.

syzbot is reporting general protection fault in bitfill_aligned() [1]
caused by integer underflow in bit_clear_margins(). The cause of this
problem is when and how do_vc_resize() updates vc->vc_{cols,rows}.

If vc_do_resize() fails (e.g. kzalloc() fails) when var.xres or var.yres
is going to shrink, vc->vc_{cols,rows} will not be updated. This allows
bit_clear_margins() to see info->var.xres < (vc->vc_cols * cw) or
info->var.yres < (vc->vc_rows * ch). Unexpectedly large rw or bh will
try to overrun the __iomem region and causes general protection fault.

Also, vc_resize(vc, 0, 0) does not set vc->vc_{cols,rows} = 0 due to

  new_cols = (cols ? cols : vc->vc_cols);
  new_rows = (lines ? lines : vc->vc_rows);

exception. Since cols and lines are calculated as

  cols = FBCON_SWAP(ops->rotate, info->var.xres, info->var.yres);
  rows = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
  cols /= vc->vc_font.width;
  rows /= vc->vc_font.height;
  vc_resize(vc, cols, rows);

in fbcon_modechanged(), var.xres < vc->vc_font.width makes cols = 0
and var.yres < vc->vc_font.height makes rows = 0. This means that

  const int fd = open("/dev/fb0", O_ACCMODE);
  struct fb_var_screeninfo var = { };
  ioctl(fd, FBIOGET_VSCREENINFO, &var);
  var.xres = var.yres = 1;
  ioctl(fd, FBIOPUT_VSCREENINFO, &var);

easily reproduces integer underflow bug explained above.

Of course, callers of vc_resize() are not handling vc_do_resize() failure
is bad. But we can't avoid vc_resize(vc, 0, 0) which returns 0. Therefore,
as a band-aid workaround, this patch checks integer underflow in
"struct fbcon_ops"->clear_margins call, assuming that
vc->vc_cols * vc->vc_font.width and vc->vc_rows * vc->vc_font.heigh do not
cause integer overflow.

[1] https://syzkaller.appspot.com/bug?id=a565882df74fa76f10d3a6fec4be31098dbb37c6

Reported-and-tested-by: syzbot <syzbot+e5fd3e65515b48c02a30@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200715015102.3814-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/video/fbdev/core/bitblit.c b/drivers/video/fbdev/core/bitblit.c
index ca935c09a261..35ebeeccde4d 100644
--- a/drivers/video/fbdev/core/bitblit.c
+++ b/drivers/video/fbdev/core/bitblit.c
@@ -216,7 +216,7 @@ static void bit_clear_margins(struct vc_data *vc, struct fb_info *info,
 	region.color = color;
 	region.rop = ROP_COPY;
 
-	if (rw && !bottom_only) {
+	if ((int) rw > 0 && !bottom_only) {
 		region.dx = info->var.xoffset + rs;
 		region.dy = 0;
 		region.width = rw;
@@ -224,7 +224,7 @@ static void bit_clear_margins(struct vc_data *vc, struct fb_info *info,
 		info->fbops->fb_fillrect(info, &region);
 	}
 
-	if (bh) {
+	if ((int) bh > 0) {
 		region.dx = info->var.xoffset;
 		region.dy = info->var.yoffset + bs;
 		region.width = rs;
diff --git a/drivers/video/fbdev/core/fbcon_ccw.c b/drivers/video/fbdev/core/fbcon_ccw.c
index dfa9a8aa4509..78f3a5621478 100644
--- a/drivers/video/fbdev/core/fbcon_ccw.c
+++ b/drivers/video/fbdev/core/fbcon_ccw.c
@@ -201,7 +201,7 @@ static void ccw_clear_margins(struct vc_data *vc, struct fb_info *info,
 	region.color = color;
 	region.rop = ROP_COPY;
 
-	if (rw && !bottom_only) {
+	if ((int) rw > 0 && !bottom_only) {
 		region.dx = 0;
 		region.dy = info->var.yoffset;
 		region.height = rw;
@@ -209,7 +209,7 @@ static void ccw_clear_margins(struct vc_data *vc, struct fb_info *info,
 		info->fbops->fb_fillrect(info, &region);
 	}
 
-	if (bh) {
+	if ((int) bh > 0) {
 		region.dx = info->var.xoffset + bs;
 		region.dy = 0;
                 region.height = info->var.yres_virtual;
diff --git a/drivers/video/fbdev/core/fbcon_cw.c b/drivers/video/fbdev/core/fbcon_cw.c
index ce08251bfd38..fd098ff17574 100644
--- a/drivers/video/fbdev/core/fbcon_cw.c
+++ b/drivers/video/fbdev/core/fbcon_cw.c
@@ -184,7 +184,7 @@ static void cw_clear_margins(struct vc_data *vc, struct fb_info *info,
 	region.color = color;
 	region.rop = ROP_COPY;
 
-	if (rw && !bottom_only) {
+	if ((int) rw > 0 && !bottom_only) {
 		region.dx = 0;
 		region.dy = info->var.yoffset + rs;
 		region.height = rw;
@@ -192,7 +192,7 @@ static void cw_clear_margins(struct vc_data *vc, struct fb_info *info,
 		info->fbops->fb_fillrect(info, &region);
 	}
 
-	if (bh) {
+	if ((int) bh > 0) {
 		region.dx = info->var.xoffset;
 		region.dy = info->var.yoffset;
                 region.height = info->var.yres;
diff --git a/drivers/video/fbdev/core/fbcon_ud.c b/drivers/video/fbdev/core/fbcon_ud.c
index 1936afc78fec..e165a3fad29a 100644
--- a/drivers/video/fbdev/core/fbcon_ud.c
+++ b/drivers/video/fbdev/core/fbcon_ud.c
@@ -231,7 +231,7 @@ static void ud_clear_margins(struct vc_data *vc, struct fb_info *info,
 	region.color = color;
 	region.rop = ROP_COPY;
 
-	if (rw && !bottom_only) {
+	if ((int) rw > 0 && !bottom_only) {
 		region.dy = 0;
 		region.dx = info->var.xoffset;
 		region.width  = rw;
@@ -239,7 +239,7 @@ static void ud_clear_margins(struct vc_data *vc, struct fb_info *info,
 		info->fbops->fb_fillrect(info, &region);
 	}
 
-	if (bh) {
+	if ((int) bh > 0) {
 		region.dy = info->var.yoffset;
 		region.dx = info->var.xoffset;
                 region.height  = bh;

