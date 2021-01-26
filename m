Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97303304BE9
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbhAZV5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:57:37 -0500
Received: from www.linuxtv.org ([130.149.80.248]:51896 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394545AbhAZSR6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 13:17:58 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l4Sts-00F4EL-JR; Tue, 26 Jan 2021 18:17:12 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 26 Jan 2021 18:14:33 +0000
Subject: [git:media_tree/fixes] media: v4l2-subdev.h: BIT() is not available in userspace
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l4Sts-00F4EL-JR@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: v4l2-subdev.h: BIT() is not available in userspace
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Mon Jan 18 16:37:00 2021 +0100

The BIT macro is not available in userspace, so replace BIT(0) by
0x00000001.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 6446ec6cbf46 ("media: v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 include/uapi/linux/v4l2-subdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index 00850b98078a..a38454d9e0f5 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -176,7 +176,7 @@ struct v4l2_subdev_capability {
 };
 
 /* The v4l2 sub-device video device node is registered in read-only mode. */
-#define V4L2_SUBDEV_CAP_RO_SUBDEV		BIT(0)
+#define V4L2_SUBDEV_CAP_RO_SUBDEV		0x00000001
 
 /* Backwards compatibility define --- to be removed */
 #define v4l2_subdev_edid v4l2_edid
