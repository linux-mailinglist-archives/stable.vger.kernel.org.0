Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC771C3417
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 10:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgEDIJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 04:09:13 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:47461 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbgEDIJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 04:09:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B83C0661;
        Mon,  4 May 2020 04:09:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 May 2020 04:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=D7PBuE
        TZPFumURdhlbOHvvZn7brkW/DRpbLYgpVoJl0=; b=cfHg7aqD1z1NIDpiWTkQdA
        MNuz2komUBX0npDGf5N/lg+z3uxFrcgMz0FIwZ2SujMihkR0TNCvZ2xaa9iRzBvW
        3dSforPBrvmSOuWZzrtvV/8fRQCDfqzjR8rG5lGeNLxS9f8DkH28ZV972/8yGePL
        O4eebHrXnxEx+L9o8VJcA29pFkzfM7L6BfVeFCcWFTQo98PS1jtiTVS30WbyRbJh
        WLNFT8ZB6P7IosE6sW6fkU3d7zIbdziymvnrJUmwhedM+EvE0ry3MxTyMR4e6WfC
        F4nCUq6lp0F6oXwJrf0QQd3RQyIUU78Q3VXba6Rd5JZkg/uA5wE9PNXbJslHIDgg
        ==
X-ME-Sender: <xms:p82vXolaNZbcju_teqD-2WqSoUOk6GPCdNyoSxAHJUzHKgfB-EOMww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeegucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttddtlfenuc
    fhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecu
    ggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduueejhffhgf
    evuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:p82vXjFHbGCwC-HFI7a-d7fODFJtOS0CheprfUm4e2X3bBwjtqVQIg>
    <xmx:p82vXm55mcbgbD6ixjOOnGoq2s7EJzdmqXjEPh18GwSHPKiJMDyvyw>
    <xmx:p82vXiNESP0gkjqGUy_rafnP3FwDiffxWzppWkaA2Nok37RLjFBZMQ>
    <xmx:p82vXlnp4MmomstnE6wNNHfeO-9L_L3p-eljCKxS0VWOMLlkZWiUV2tHayM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F356F328005D;
        Mon,  4 May 2020 04:09:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/qxl: qxl_release use after free" failed to apply to 4.4-stable tree
To:     vvs@virtuozzo.com, kraxel@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 10:09:09 +0200
Message-ID: <158857974932204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

