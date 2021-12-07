Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E13E46AECD
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377955AbhLGAKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357955AbhLGAKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:10:03 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569C0C061746;
        Mon,  6 Dec 2021 16:06:34 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r11so49523499edd.9;
        Mon, 06 Dec 2021 16:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Y9BlW3tW97AkK+vn8PCzzi0aOsH6GB6w8a58eRmyYjc=;
        b=n98sMr+RdacEvvYXsn7f9OhBlVeGv2hXjrLPAAHqo2rpfVj5F01lCK8fizNs0zQGgJ
         64DdvFJp6b/ko/a6DGstyiwFEtuZYUpQDJsL0Xe92Q/hImi/kotTB2Y5N2D6vNuMaKu3
         UCSW196FvvubsS3QsCtj7M9T76MeoqVscv2F79UXcwd/wx1rc8APn7PHgXXJi7tPcOJ6
         SZeVTwoikQbcM879oMhL8pCmUpDjtQhhSCXw03VyzE7JvJAK7dmY2/853lEQEHfEjyrc
         Lwbrz7ZqQs+jB43NUgWthI4FWEZMrRrHXCriFZq8GionOtPdM4Vn04+06A8++v9v2xBJ
         iihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y9BlW3tW97AkK+vn8PCzzi0aOsH6GB6w8a58eRmyYjc=;
        b=cgO0/98N9J6/CyQuxZ252az+w4OHxHqlEapzCogBBMzEwJLAp0DkFPoSbyDdmyj1c5
         4mSdetoQX6LUE/mi+gtLrWDeEwjogadELAD+3RdFvfFRDISqL6pnUTOQ2+tXOkqJv/D5
         //UCIWVAbmUh/RFDcnWi6Lw0bvuHHkQXs+/Xnt8W9Xj3DMzCPm3gVPcSket4KUfHDQzS
         gYp0f2cEowXCX/nHR3+GV1pGFoMCtoUf8uXOCd7AV8ABDCUWsWhe5X70y9DJN4bLT3fK
         8UNa9bSb8BdN1rWN0vuqoMm4JRW8jUF1ZsDYqueTJaemSNiI+wdJAf/SHsBdVT//hfR0
         yn+g==
X-Gm-Message-State: AOAM531RfgMUNN+jnI9dJFg5TEC5c1bgmXwP7hwtnfRTKi51TcwOGkvU
        Qn7iOe3AxHeQYwS9qjAuwhI=
X-Google-Smtp-Source: ABdhPJyToRWxuN4Kb29Mk+9wG4XQx3dJzRyIetHQPSJcO+et4L7HwrNpBjqlg+94u1xp79xjxCT9qQ==
X-Received: by 2002:a17:906:3b84:: with SMTP id u4mr47852666ejf.310.1638835592899;
        Mon, 06 Dec 2021 16:06:32 -0800 (PST)
Received: from piling.lan (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id w18sm8713114edx.55.2021.12.06.16.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:06:32 -0800 (PST)
From:   Ricardo Ribalda <ricardo.ribalda@gmail.com>
X-Google-Original-From: Ricardo Ribalda <ribalda@chromium.org>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        ": Ricardo Ribalda" <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org, stable <stable@vger.kernel.org>
Subject: [PATCH 1/3] Revert "media: uvcvideo: Set unique vdev name based in type"
Date:   Tue,  7 Dec 2021 01:06:27 +0100
Message-Id: <20211207000629.4985-2-ribalda@chromium.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211207000629.4985-1-ribalda@chromium.org>
References: <20211207000629.4985-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A lot of userspace depends on a descriptive name for vdev. Without this
patch, users have a hard time figuring out which camera shall they use
for their video conferencing.

This reverts commit e3f60e7e1a2b451f538f9926763432249bcf39c4.

Cc: <stable@vger.kernel.org>
Fixes: e3f60e7e1a2b ("media: uvcvideo: Set unique vdev name based in type")
Reported-by: Nicolas Dufresne <nicolas@ndufresne.ca>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 7c007426e082..058d28a0344b 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2193,7 +2193,6 @@ int uvc_register_video_device(struct uvc_device *dev,
 			      const struct v4l2_file_operations *fops,
 			      const struct v4l2_ioctl_ops *ioctl_ops)
 {
-	const char *name;
 	int ret;
 
 	/* Initialize the video buffers queue. */
@@ -2222,20 +2221,16 @@ int uvc_register_video_device(struct uvc_device *dev,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	default:
 		vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-		name = "Video Capture";
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
-		name = "Video Output";
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
 		vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
-		name = "Metadata";
 		break;
 	}
 
-	snprintf(vdev->name, sizeof(vdev->name), "%s %u", name,
-		 stream->header.bTerminalLink);
+	strscpy(vdev->name, dev->name, sizeof(vdev->name));
 
 	/*
 	 * Set the driver data before calling video_register_device, otherwise
-- 
2.33.0

