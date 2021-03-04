Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B20F32D54E
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhCDOap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:30:45 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:60415 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231216AbhCDOak (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 09:30:40 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 7F082142F;
        Thu,  4 Mar 2021 09:29:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 04 Mar 2021 09:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ukpb5m
        nsG4zDG+7AcEai3pIOuLfV73a/anvr58/baV8=; b=QAbOiUAbpWH43uGL7EsEwG
        +JrDR4IqasKYYI+SG/uyHQ9vZBQseF5uZlCReU7B1hj4fZ3U6M6rtoQXhjadocQq
        zyQYJbuhnpo+h7vMNKa8HhMnPAmoBGHTsWp/+HYRsfUmbBvYT5GQXeH6cmQAeOqL
        altZCcMXKzD6xACkw+ckQb0OBQjjEywuHc7yvae9tjRmSzvIIQgDEVsjS9fLGASC
        kjCkysjXzclx2XkI75gp3z+LHNgtBLhCMlleANsxivKWG32jen/ZtH4l7za7jalz
        KdOR/o/EPKkL+YAOj5ugpwfYSDtBj9WYH9ThXYta/Qvj8OwSECNdsN4qPxhzY+ZA
        ==
X-ME-Sender: <xms:ze5AYCvegx_2f7b-FFrkcFXx6BWEJ5EHy8_hlNaVU82T3Ucqp9i5Fg>
    <xme:ze5AYJelhnqyIm0gX_kwcLrhe22V-8eDJIcHpiHLQZ-aOg9sAsaBce3SjgHAgZdP3
    74wr2jX1r-sxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:ze5AYHKswyXfVHqRZIufmtppQv8_w36R2IkwBnxOuMyMeRm3_Fhk0A>
    <xmx:ze5AYPbNe1fGGl2xKGY5rvxdZyHxXUyWs833Fbq1mff-UqpSh1LaJg>
    <xmx:ze5AYKuiNG8OiClPA-D5qbmMcyWUXDt6fE4xluUcHdmObLqlrj3M7w>
    <xmx:zu5AYGOX0zOzcDUsjzDnBE6Dh9Xtu4-oULu0awfL1C8rE5iJygZ0nIaE5Jw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9464424005E;
        Thu,  4 Mar 2021 09:29:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: zr364xx: fix memory leaks in probe()" failed to apply to 5.4-stable tree
To:     dan.carpenter@oracle.com, hverkuil-cisco@xs4all.nl,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Mar 2021 15:29:24 +0100
Message-ID: <1614868164252207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

