Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74A45EB1AC
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiIZTyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiIZTym (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:54:42 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4672633;
        Mon, 26 Sep 2022 12:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1664222075; i=@motorola.com;
        bh=f5buyJD9b1a+7dOnQI7nPYKKZG9FWbNnRmo7xsmt0a8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=DVdnTkpbfXL/f/mvLVTIIqi/c55as62ut2xpwYpdvteQXqSunkg9wDk7aEfu0VS2e
         yghGOB8nHVflT3qfYNwRjXpydd1B1xDxuIyL8hLnUMFxjmxY7s9GHfLUSBR+RxZw12
         P+zPkicXcAC57g3FqgBGWLWZe0FSGocg6GAN+7G/pUg6myTEKKfW1KkK4cFQH81h39
         OtXq05gxHcJoKxj7aY9JA5/nzcDp2dd4Lc8pgeFyT31Lfh2zFGvAJLTm3xyst0r7h2
         S419NEg2wiHm4tp4GOm/unSBTgJAlww9lBWwC4hYGdTcB6dPX4c+q41o4DyTP/5Vqc
         ZMRjgOq59A0XA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRWlGSWpSXmKPExsUyYU+Di24Vs1G
  ywcTr3BbH2p6wWzQvXs9m0TlxCbvF5V1z2CwWLWtlttjSdoXJYsHGR4wWqxYcYHfg8JjdMZPV
  Y9OqTjaP/XPXsHv0/zXw2LL/M6PH501yAWxRrJl5SfkVCawZd2Y3MBes0ax4uOQ8YwPjLuUuR
  i4OIYEpTBK7u/rZIJwlTBI7H/QAOZwcbAJqEgter2IGsUUEZCUOX/nNDFLELHCYSeL+k1eMIA
  lhAQeJRf2zWboYOThYBFQlZi5jBwnzClhKHJvfBFYiISAvsf/gWbA5nAJWEvemHwazhYBq2tZ
  OYISoF5Q4OfMJC4jNDFTfvHU28wRG3llIUrOQpBYwMq1itE4qykzPKMlNzMzRNTQw0DU0NNG1
  NNM1MrHUS6zSTdQrLdYtTy0u0TXSSywv1kstLtYrrsxNzknRy0st2cQIDO2UooSfOxhX9f/UO
  8QoycGkJMorvs8wWYgvKT+lMiOxOCO+qDQntfgQowwHh5IE71JGo2QhwaLU9NSKtMwcYJzBpC
  U4eJREeJv/ALXyFhck5hZnpkOkTjEac0yd/W8/M0fn/q4DzEIsefl5qVLivNwgkwRASjNK8+A
  GweL/EqOslDAvIwMDgxBPQWpRbmYJqvwrRnEORiVhXhcmoCk8mXklcPteAZ3CBHSKHZ8+yCkl
  iQgpqQamhN+Py6d7MyclpJrP4Al3elVQ4bVVf4NW0YT7Wh9W35t4r8w9PfjvgoN8SqdidwlKM
  iyrjMqymBq8dtuCvVdc5sl53U+0FzldbRSX/HvDzT2Xf+0qbnWIP8sddeJoXMS6zmzxwoNsk9
  /qLhcUmbJnX/y8B2+V3Td/m5wZInL3gg1HyrYXt3NePXg16emsazMVdnmfcVVgMXN94xD6Jy6
  AxYM3+2xm3MXHLmsiGKXnfhYWZQhxibCqeXTAfOv06h9xN3ZtWveG6en1ku++E66eEr885b31
  FrYF+wrSLx9d/OVX0PIXQWKcglMy1duEP2Zszeq7e/283K9fm79EB+S8XVfxcle16+WiczKXY
  wyC+ZVYijMSDbWYi4oTAVHib9N6AwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-23.tower-655.messagelabs.com!1664222073!424503!1
X-Originating-IP: [144.188.128.68]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 19547 invoked from network); 26 Sep 2022 19:54:34 -0000
Received: from unknown (HELO ilclpfpp02.lenovo.com) (144.188.128.68)
  by server-23.tower-655.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Sep 2022 19:54:34 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by ilclpfpp02.lenovo.com (Postfix) with ESMTPS id 4Mbtkd2mNXzfBb2;
        Mon, 26 Sep 2022 19:54:33 +0000 (UTC)
Received: from p1g3.. (unknown [10.45.6.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4Mbtkd1XtLzbvDd;
        Mon, 26 Sep 2022 19:54:33 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Dan Vacura <w36195@motorola.com>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: uvc: fix sg handling in error case
Date:   Mon, 26 Sep 2022 14:53:07 -0500
Message-Id: <20220926195307.110121-2-w36195@motorola.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926195307.110121-1-w36195@motorola.com>
References: <20220926195307.110121-1-w36195@motorola.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If there is a transmission error the buffer will be returned too early,
causing a memory fault as subsequent requests for that buffer are still
queued up to be sent. Refactor the error handling to wait for the final
request to come in before reporting back the buffer to userspace for all
transfer types (bulk/isoc/isoc_sg) to ensure userspace knows if the
frame was successfully sent.

Fixes: e81e7f9a0eb9 ("usb: gadget: uvc: add scatter gather support")
Cc: <stable@vger.kernel.org> # 859c675d84d4: usb: gadget: uvc: consistently use define for headerlen
Cc: <stable@vger.kernel.org> # f262ce66d40c: usb: gadget: uvc: use on returned header len in video_encode_isoc_sg
Cc: <stable@vger.kernel.org> # 61aa709ca58a: usb: gadget: uvc: rework uvcg_queue_next_buffer to uvcg_complete_buffer
Cc: <stable@vger.kernel.org> # 9b969f93bcef: usb: gadget: uvc: giveback vb2 buffer on req complete
Cc: <stable@vger.kernel.org> # aef11279888c: usb: gadget: uvc: improve sg exit condition
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>

---
 drivers/usb/gadget/function/uvc_queue.c |  8 +++++---
 drivers/usb/gadget/function/uvc_queue.h |  2 +-
 drivers/usb/gadget/function/uvc_video.c | 18 ++++++++++++++----
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index ec500ee499ee..72e7ffd9a021 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -304,6 +304,7 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 
 		queue->sequence = 0;
 		queue->buf_used = 0;
+		queue->flags &= ~UVC_QUEUE_MISSED_XFER;
 	} else {
 		ret = vb2_streamoff(&queue->queue, queue->queue.type);
 		if (ret < 0)
@@ -329,10 +330,11 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 void uvcg_complete_buffer(struct uvc_video_queue *queue,
 					  struct uvc_buffer *buf)
 {
-	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
-	     buf->length != buf->bytesused) {
-		buf->state = UVC_BUF_STATE_QUEUED;
+	if ((queue->flags & UVC_QUEUE_MISSED_XFER)) {
+		queue->flags &= ~UVC_QUEUE_MISSED_XFER;
+		buf->state = UVC_BUF_STATE_ERROR;
 		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
+		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
diff --git a/drivers/usb/gadget/function/uvc_queue.h b/drivers/usb/gadget/function/uvc_queue.h
index 41f87b917f6b..741ec58ae9bb 100644
--- a/drivers/usb/gadget/function/uvc_queue.h
+++ b/drivers/usb/gadget/function/uvc_queue.h
@@ -42,7 +42,7 @@ struct uvc_buffer {
 };
 
 #define UVC_QUEUE_DISCONNECTED		(1 << 0)
-#define UVC_QUEUE_DROP_INCOMPLETE	(1 << 1)
+#define UVC_QUEUE_MISSED_XFER 		(1 << 1)
 
 struct uvc_video_queue {
 	struct vb2_queue queue;
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index bb037fcc90e6..e46591b067a8 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -88,6 +88,7 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
 		struct uvc_buffer *buf)
 {
 	void *mem = req->buf;
+	struct uvc_request *ureq = req->context;
 	int len = video->req_size;
 	int ret;
 
@@ -113,13 +114,14 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		list_del(&buf->queue);
-		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
+		ureq->last_buf = buf;
 
 		video->payload_size = 0;
 	}
 
 	if (video->payload_size == video->max_payload_size ||
+	    video->queue.flags & UVC_QUEUE_MISSED_XFER ||
 	    buf->bytesused == video->queue.buf_used)
 		video->payload_size = 0;
 }
@@ -180,7 +182,8 @@ uvc_video_encode_isoc_sg(struct usb_request *req, struct uvc_video *video,
 	req->length -= len;
 	video->queue.buf_used += req->length - header_len;
 
-	if (buf->bytesused == video->queue.buf_used || !buf->sg) {
+	if (buf->bytesused == video->queue.buf_used || !buf->sg ||
+			video->queue.flags & UVC_QUEUE_MISSED_XFER) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		buf->offset = 0;
@@ -195,6 +198,7 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
 		struct uvc_buffer *buf)
 {
 	void *mem = req->buf;
+	struct uvc_request *ureq = req->context;
 	int len = video->req_size;
 	int ret;
 
@@ -209,12 +213,13 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
 
 	req->length = video->req_size - len;
 
-	if (buf->bytesused == video->queue.buf_used) {
+	if (buf->bytesused == video->queue.buf_used ||
+			video->queue.flags & UVC_QUEUE_MISSED_XFER) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		list_del(&buf->queue);
-		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
+		ureq->last_buf = buf;
 	}
 }
 
@@ -255,6 +260,11 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 	case 0:
 		break;
 
+	case -EXDEV:
+		uvcg_info(&video->uvc->func, "VS request missed xfer.\n");
+		queue->flags |= UVC_QUEUE_MISSED_XFER;
+		break;
+
 	case -ESHUTDOWN:	/* disconnect from host. */
 		uvcg_dbg(&video->uvc->func, "VS request cancelled.\n");
 		uvcg_queue_cancel(queue, 1);
-- 
2.34.1

