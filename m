Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E413C32D54D
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhCDOao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:30:44 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:58165 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229711AbhCDOaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 09:30:30 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 306C914A6;
        Thu,  4 Mar 2021 09:29:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 04 Mar 2021 09:29:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=As7nXB
        zcMzbgxLc9avslFxFyWpqLu5JpgWz4thETGYI=; b=pmCl/ShYa7R43YnM57nD9Z
        5hDUMO693t/pJGAPSIW0hT2bcJLCTzsI+RY5YJ9N3XgP1RYPKN/lrpem83ZBjkNI
        ZJP88hnJCrAOueLjUZpYElrA9hGfMq0TVuj9tC360eNXdPLSXmZ9a52AJTb1WsP4
        rDHB9LTrZFNdmkrXblYemBOHL3pHnEQsAvK8ghJfUAWDp0sYqxVnGUWutDo4o+Wm
        2OVP44azZTO+YD9d/9Fo1OhKxKYg9P0/KrwgKNbtkcktAJS/riim8ZYH6TEMqb0b
        0ZxKWilhOAIJ7DNAdRvCxGjE1o6Z0XjWi27M8uL2ydSzwczatzM0i/rp2WL+OMcg
        ==
X-ME-Sender: <xms:xO5AYPkCoujJ8I8sGwHpGtrX7I2ee3AsgmcaDdSkOwEZ8epWK2b8eg>
    <xme:xO5AYMesxyJDrVvfoIuYd6mw73EGx3U1cBT_fzKUGNOZ6-cQjJsEtEXFhY4jcxplw
    j4hR2yh5JyX6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:xO5AYFpShb_aCqDlcEzxMdbqwcWxQsAbDtO8UJQPTa4LY0AVOxMtUg>
    <xmx:xO5AYK70Nn_FV8IkKsnZsB-91VrCQmCGrgeGXsJLEJswnwdxpht6sg>
    <xmx:xO5AYLoFbefOj0O4PUV65zpgEPTHvF5Zd6RSOlBYl7WyhT6K7vHx_w>
    <xmx:xO5AYNFtjAY_PWc-u22qsluHYclwJCiBH8U5czznQqilnbqmFM3TMD5khyo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14C9824005A;
        Thu,  4 Mar 2021 09:29:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: zr364xx: fix memory leaks in probe()" failed to apply to 5.10-stable tree
To:     dan.carpenter@oracle.com, hverkuil-cisco@xs4all.nl,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Mar 2021 15:29:22 +0100
Message-ID: <161486816222713@kroah.com>
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

From ea354b6ddd6f09be29424f41fa75a3e637fea234 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 21 Jan 2021 07:44:00 +0100
Subject: [PATCH] media: zr364xx: fix memory leaks in probe()

Syzbot discovered that the probe error handling doesn't clean up the
resources allocated in zr364xx_board_init().  There are several
related bugs in this code so I have re-written the error handling.

1)  Introduce a new function zr364xx_board_uninit() which cleans up
    the resources in zr364xx_board_init().
2)  In zr364xx_board_init() if the call to zr364xx_start_readpipe()
    fails then release the "cam->buffer.frame[i].lpvbits" memory
    before returning.  This way every function either allocates
    everything successfully or it cleans up after itself.
3)  Re-write the probe function so that each failure path goto frees
    the most recent allocation.  That way we don't free anything
    before it has been allocated and we can also verify that
    everything is freed.
4)  Originally, in the probe function the "cam->v4l2_dev.release"
    pointer was set to "zr364xx_release" near the start but I moved
    that assignment to the end, after everything had succeeded.  The
    release function was never actually called during the probe cleanup
    process, but with this change I wanted to make it clear that we
    don't want to call zr364xx_release() until everything is
    allocated successfully.

Next I re-wrote the zr364xx_release() function.  Ideally this would
have been a simple matter of copy and pasting the cleanup code from
probe and adding an additional call to video_unregister_device().  But
there are a couple quirks to note.

1)  The probe function does not call videobuf_mmap_free() and I don't
    know where the videobuf_mmap is allocated.  I left the code as-is to
    avoid introducing a bug in code I don't understand.
2)  The zr364xx_board_uninit() has a call to zr364xx_stop_readpipe()
    which is a change from the original behavior with regards to
    unloading the driver.  Calling zr364xx_stop_readpipe() on a stopped
    pipe is not a problem so this is safe and is potentially a bugfix.

Reported-by: syzbot+b4d54814b339b5c6bbd4@syzkaller.appspotmail.com
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 1e1c6b4d1874..d29b861367ea 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1181,15 +1181,11 @@ static int zr364xx_open(struct file *file)
 	return err;
 }
 
-static void zr364xx_release(struct v4l2_device *v4l2_dev)
+static void zr364xx_board_uninit(struct zr364xx_camera *cam)
 {
-	struct zr364xx_camera *cam =
-		container_of(v4l2_dev, struct zr364xx_camera, v4l2_dev);
 	unsigned long i;
 
-	v4l2_device_unregister(&cam->v4l2_dev);
-
-	videobuf_mmap_free(&cam->vb_vidq);
+	zr364xx_stop_readpipe(cam);
 
 	/* release sys buffers */
 	for (i = 0; i < FRAMES; i++) {
@@ -1200,9 +1196,19 @@ static void zr364xx_release(struct v4l2_device *v4l2_dev)
 		cam->buffer.frame[i].lpvbits = NULL;
 	}
 
-	v4l2_ctrl_handler_free(&cam->ctrl_handler);
 	/* release transfer buffer */
 	kfree(cam->pipe->transfer_buffer);
+}
+
+static void zr364xx_release(struct v4l2_device *v4l2_dev)
+{
+	struct zr364xx_camera *cam =
+		container_of(v4l2_dev, struct zr364xx_camera, v4l2_dev);
+
+	videobuf_mmap_free(&cam->vb_vidq);
+	v4l2_ctrl_handler_free(&cam->ctrl_handler);
+	zr364xx_board_uninit(cam);
+	v4l2_device_unregister(&cam->v4l2_dev);
 	kfree(cam);
 }
 
@@ -1376,11 +1382,14 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 	/* start read pipe */
 	err = zr364xx_start_readpipe(cam);
 	if (err)
-		goto err_free;
+		goto err_free_frames;
 
 	DBG(": board initialized\n");
 	return 0;
 
+err_free_frames:
+	for (i = 0; i < FRAMES; i++)
+		vfree(cam->buffer.frame[i].lpvbits);
 err_free:
 	kfree(cam->pipe->transfer_buffer);
 	cam->pipe->transfer_buffer = NULL;
@@ -1409,12 +1418,10 @@ static int zr364xx_probe(struct usb_interface *intf,
 	if (!cam)
 		return -ENOMEM;
 
-	cam->v4l2_dev.release = zr364xx_release;
 	err = v4l2_device_register(&intf->dev, &cam->v4l2_dev);
 	if (err < 0) {
 		dev_err(&udev->dev, "couldn't register v4l2_device\n");
-		kfree(cam);
-		return err;
+		goto free_cam;
 	}
 	hdl = &cam->ctrl_handler;
 	v4l2_ctrl_handler_init(hdl, 1);
@@ -1423,7 +1430,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	if (hdl->error) {
 		err = hdl->error;
 		dev_err(&udev->dev, "couldn't register control\n");
-		goto fail;
+		goto unregister;
 	}
 	/* save the init method used by this camera */
 	cam->method = id->driver_info;
@@ -1496,7 +1503,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	if (!cam->read_endpoint) {
 		err = -ENOMEM;
 		dev_err(&intf->dev, "Could not find bulk-in endpoint\n");
-		goto fail;
+		goto unregister;
 	}
 
 	/* v4l */
@@ -1507,10 +1514,11 @@ static int zr364xx_probe(struct usb_interface *intf,
 
 	/* load zr364xx board specific */
 	err = zr364xx_board_init(cam);
-	if (!err)
-		err = v4l2_ctrl_handler_setup(hdl);
 	if (err)
-		goto fail;
+		goto unregister;
+	err = v4l2_ctrl_handler_setup(hdl);
+	if (err)
+		goto board_uninit;
 
 	spin_lock_init(&cam->slock);
 
@@ -1525,16 +1533,21 @@ static int zr364xx_probe(struct usb_interface *intf,
 	err = video_register_device(&cam->vdev, VFL_TYPE_VIDEO, -1);
 	if (err) {
 		dev_err(&udev->dev, "video_register_device failed\n");
-		goto fail;
+		goto free_handler;
 	}
+	cam->v4l2_dev.release = zr364xx_release;
 
 	dev_info(&udev->dev, DRIVER_DESC " controlling device %s\n",
 		 video_device_node_name(&cam->vdev));
 	return 0;
 
-fail:
+free_handler:
 	v4l2_ctrl_handler_free(hdl);
+board_uninit:
+	zr364xx_board_uninit(cam);
+unregister:
 	v4l2_device_unregister(&cam->v4l2_dev);
+free_cam:
 	kfree(cam);
 	return err;
 }

