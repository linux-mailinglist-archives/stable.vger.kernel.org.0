Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CAE46AF3C
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378511AbhLGAmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378482AbhLGAmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:42:13 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82EBC0613FE
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 16:38:43 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g14so49504960edb.8
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 16:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HW2THPIGQU7U7w3HiaVAhz55D3C1VtaWNt3sB9bzjBM=;
        b=VjISuCkRmkEwkw0aCS1nal12zxgwzdL/qVV7/oy2LMN5us+IIRXeJ0MtBPY6A0K8Aw
         7fWVRaG9P8Hj8xp5O5Z/23Cb+t+l20BBXq/yTsvUVnvvF8NLN1mi5BosriyM1F5Lg3Dt
         OWs7Ga5gOpgjQA3pxqD7RMpODEV4/xjyUKGcw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HW2THPIGQU7U7w3HiaVAhz55D3C1VtaWNt3sB9bzjBM=;
        b=x+MYEBQh2b1VpaQ804FuEClFrnaNZWqc8jvfrsckKZwUXXOOcMv8rU3A2PrQBDz0dw
         Iq20QiOGa4BHG2TBGdiZG8Nru6QE4XsqavpH4a16PMMRBFDcelz2nuUhyGCFO8dUItvP
         tQeQZ+GTHgRcMhqEwKlKXAq/exAcRLoCruSpM/8C0+IiihogpEW2yjRUBDnllHmywaDF
         LxgZBWYZTYr7rlpzkOpO8P+JVjXe+Xc2M01DGNc8IisARSgtaWdvxQFt9t2VDMly6DVd
         Iw16/8b5exvxPlR1ZAZtPgeolnHnb0kndYIqkB2rWvWKZxpKhENG/bV5G3NkguJXhLL0
         2X1g==
X-Gm-Message-State: AOAM530BcOt1Djkq2sK1+u9pAPqZNGbled3pPrxzB4eAIiWKO1aTnmLU
        U6+ruStCJKZ93dAYMY8+g/zi/Q==
X-Google-Smtp-Source: ABdhPJyq2gqJBj1sAf+6WXUmHXxg2S2oQ7eiYZl+6T0NnMOfBdTQ5l8aMhxHziByasPlso/1QbjJnA==
X-Received: by 2002:a17:906:1697:: with SMTP id s23mr50370251ejd.60.1638837522481;
        Mon, 06 Dec 2021 16:38:42 -0800 (PST)
Received: from alco.lan (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id hg19sm7422531ejc.1.2021.12.06.16.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:38:42 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/4] Revert "media: uvcvideo: Set unique vdev name based in type"
Date:   Tue,  7 Dec 2021 01:38:37 +0100
Message-Id: <20211207003840.1212374-2-ribalda@chromium.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207003840.1212374-1-ribalda@chromium.org>
References: <20211207003840.1212374-1-ribalda@chromium.org>
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
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
2.34.1.400.ga245620fadb-goog

