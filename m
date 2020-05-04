Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C461C3418
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 10:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgEDIJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 04:09:22 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:52949 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbgEDIJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 04:09:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id DBFBE641;
        Mon,  4 May 2020 04:09:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 May 2020 04:09:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aPEW+9
        pPwHD1zgUcvKKnpUlqkh6vtdORblnUIgNkWhg=; b=SWnhgaYoDaN5LKe1mfpSkw
        SHr6i/krT36WR3lzL5hsIZTCRlj/adlJLtihZFc5IDFZBCm8X5bX9JzjtIj5jypG
        QgoG0h73zVQpFT2jjHM6mYbIO0u5Yt5iUUGmfxE8qjqjFL3BsPLEEniGW+kzVvCa
        /ol0Uf6+J/9k/J+NLY5Kb1ZS5mTKty/GBWqUn3/XxVDpSm0/Tjlyw2MprKs56OCt
        wgTQfoalpBZhJmBh9X4RYvclvh3N4ZyCL74LWwTG4+q1Rb7K2xomUTM2NtotUVtH
        fFY3pf9kVrCeTrRJU7tciya+addwWQ2gDFroZYzFGhXfU5gkpMsnq2ddtTt8tfGQ
        ==
X-ME-Sender: <xms:sM2vXn0gy-k_JuYlRZEZXmFKy7UmDdGoluLxxYYuIGzk8EKRY7eUxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeegucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttddtlfenuc
    fhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecu
    ggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduueejhffhgf
    evuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:sM2vXp3oSUeC9HeJUylvjojiQfS1TZ-sx54sW0jN2ztSX1qRFbbjfg>
    <xmx:sM2vXgwleT1DSAf1J8t47FIL0jOp1FV6vcWnfeeK1kxxNXNofc382w>
    <xmx:sM2vXk_15MHWxX4U59Cy-hVmDdE104bIfCvPDEwOQv-6TZIcFLBh5Q>
    <xmx:sM2vXqbgVma_Qan4-H4WLVKcroW6Z5loKk-8mBKdQINKqqz0v42QpxRRVDQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 23B683066011;
        Mon,  4 May 2020 04:09:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/qxl: qxl_release use after free" failed to apply to 4.9-stable tree
To:     vvs@virtuozzo.com, kraxel@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 10:09:10 +0200
Message-ID: <158857975049197@kroah.com>
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

From 933db73351d359f74b14f4af095808260aff11f9 Mon Sep 17 00:00:00 2001
From: Vasily Averin <vvs@virtuozzo.com>
Date: Wed, 29 Apr 2020 12:01:24 +0300
Subject: [PATCH] drm/qxl: qxl_release use after free

qxl_release should not be accesses after qxl_push_*_ring_release() calls:
userspace driver can process submitted command quickly, move qxl_release
into release_ring, generate interrupt and trigger garbage collector.

It can lead to crashes in qxl driver or trigger memory corruption
in some kmalloc-192 slab object

Gerd Hoffmann proposes to swap the qxl_release_fence_buffer_objects() +
qxl_push_{cursor,command}_ring_release() calls to close that race window.

cc: stable@vger.kernel.org
Fixes: f64122c1f6ad ("drm: add new QXL driver. (v1.4)")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Link: http://patchwork.freedesktop.org/patch/msgid/fa17b338-66ae-f299-68fe-8d32419d9071@virtuozzo.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

diff --git a/drivers/gpu/drm/qxl/qxl_cmd.c b/drivers/gpu/drm/qxl/qxl_cmd.c
index fa8762d15d0f..05863b253d68 100644
--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -500,8 +500,8 @@ int qxl_hw_surface_alloc(struct qxl_device *qdev,
 	/* no need to add a release to the fence for this surface bo,
 	   since it is only released when we ask to destroy the surface
 	   and it would never signal otherwise */
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
 
 	surf->hw_surf_alloc = true;
 	spin_lock(&qdev->surf_id_idr_lock);
@@ -543,9 +543,8 @@ int qxl_hw_surface_dealloc(struct qxl_device *qdev,
 	cmd->surface_id = id;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
-
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_SURFACE, false);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index 09583a08e141..91f398d51cfa 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -510,8 +510,8 @@ static int qxl_primary_apply_cursor(struct drm_plane *plane)
 	cmd->u.set.visible = 1;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 
 	return ret;
 
@@ -652,8 +652,8 @@ static void qxl_cursor_atomic_update(struct drm_plane *plane,
 	cmd->u.position.y = plane->state->crtc_y + fb->hot_y;
 
 	qxl_release_unmap(qdev, release, &cmd->release_info);
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 
 	if (old_cursor_bo != NULL)
 		qxl_bo_unpin(old_cursor_bo);
@@ -700,8 +700,8 @@ static void qxl_cursor_atomic_disable(struct drm_plane *plane,
 	cmd->type = QXL_CURSOR_HIDE;
 	qxl_release_unmap(qdev, release, &cmd->release_info);
 
-	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_cursor_ring_release(qdev, release, QXL_CMD_CURSOR, false);
 }
 
 static void qxl_update_dumb_head(struct qxl_device *qdev,
diff --git a/drivers/gpu/drm/qxl/qxl_draw.c b/drivers/gpu/drm/qxl/qxl_draw.c
index f8776d60d08e..3599db096973 100644
--- a/drivers/gpu/drm/qxl/qxl_draw.c
+++ b/drivers/gpu/drm/qxl/qxl_draw.c
@@ -243,8 +243,8 @@ void qxl_draw_dirty_fb(struct qxl_device *qdev,
 	}
 	qxl_bo_kunmap(clips_bo);
 
-	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 	qxl_release_fence_buffer_objects(release);
+	qxl_push_command_ring_release(qdev, release, QXL_CMD_DRAW, false);
 
 out_release_backoff:
 	if (ret)
diff --git a/drivers/gpu/drm/qxl/qxl_ioctl.c b/drivers/gpu/drm/qxl/qxl_ioctl.c
index 8117a45b3610..72f3f1bbb40c 100644
--- a/drivers/gpu/drm/qxl/qxl_ioctl.c
+++ b/drivers/gpu/drm/qxl/qxl_ioctl.c
@@ -261,11 +261,8 @@ static int qxl_process_single_command(struct qxl_device *qdev,
 			apply_surf_reloc(qdev, &reloc_info[i]);
 	}
 
+	qxl_release_fence_buffer_objects(release);
 	ret = qxl_push_command_ring_release(qdev, release, cmd->type, true);
-	if (ret)
-		qxl_release_backoff_reserve_list(release);
-	else
-		qxl_release_fence_buffer_objects(release);
 
 out_free_bos:
 out_free_release:

