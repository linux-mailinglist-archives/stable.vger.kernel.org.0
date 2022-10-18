Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D7C603537
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 23:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJRVv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 17:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJRVv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 17:51:27 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFC9BE2FA;
        Tue, 18 Oct 2022 14:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666129886; i=@motorola.com;
        bh=sfQAryD/xBgH6Xtqc/fcYqWHp7Ikn2PFWWAT/anYcbM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=aXiY4dEGkp/dNiF7l4HrWCrfgbEP/IqiSPH15ayVN/gcz93V3SIUcFSvjI52RRP70
         vGC1S2ysDOyy/JEv884apnHB2b0RsTTqNV6cqnkX70cNAG239aLyBRhsu+tMTsNoF2
         2NjUunMi9W0McB89Nnea5ofCuzXRouspWTA8R9O4hDTUwRAQ90cncQfCGOZ6RZwQJj
         bZ8atdeRvhyoj1qu9/KOSMDPXtFW2hHGw8VXZA6GrhCvnuAmPXCdUqsTvnrDH58+k4
         G92VIchE73JE8M6ORTrTVmvi5u4ya3nQudpiAx8NlOriEwGCOig4woQrmIWH8IYQzd
         ZmSOiXe5rxFcw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRWlGSWpSXmKPExsWS8eKJhO4def9
  kgyePDCyOtT1ht3hyoJ3RonfZHjaL5sXr2Sw6Jy5ht1jYtoTF4vKuOWwWi5a1MltsabvCZPHj
  Tx+zxYKNjxgtVi04wO7A4zG7Yyarx6ZVnWwe++euYfdY3DeZ1aP/r4HHlv2fGT0+b5ILYI9iz
  cxLyq9IYM3Y9/IgY8E7pYqGi29YGxgvynYxcnEICUxnkjjwqYkFwlnHJDHx0Q0gh5ODTUBNYs
  HrVcwgtoiArMThK7/BbGaBBhaJzdeCQWxhAXeJS70Tgeo5OFgEVCV2dRqAhHkFLCWWvWllBbE
  lBOQl9h88C9bKKWAl0fWwDWy8EFDN49YrrBD1ghInZz5hgRgvL9G8dTbzBEbeWUhSs5CkFjAy
  rWI0LU4tKkst0jXSSyrKTM8oyU3MzNFLrNJN1Cst1i1PLS4ByiSWF+ulFhfrFVfmJuek6OWll
  mxiBIZ/SlHC/B2MU5f+0TvEKMnBpCTKO+ebX7IQX1J+SmVGYnFGfFFpTmrxIUYZDg4lCV5OKf
  9kIcGi1PTUirTMHGAswqQlOHiURHjTZIDSvMUFibnFmekQqVOMuhyd+7sOMAux5OXnpUqJ83L
  LAhUJgBRllObBjYClhUuMslLCvIwMDAxCPAWpRbmZJajyrxjFORiVhHkPgKziycwrgdv0CugI
  JqAjTLf4gRxRkoiQkmpg6uJmX9uk/uOQ4am/sUsuH3GukV14R0X+/Zut387cZUo6dnNmHFPVX
  x9/ia9nk85VSHBoMR3bdks/7XO0RflbTc/u8vkSu092pEyZKm6eK8Ia9KNUdkbhSoH1n01FbB
  fe0mV//NJf+rhqvEySb9j51M07OubHsT01mDxjoafJWd6WAkPuM8cLuBu4X51eFb2nZ/XRbZL
  2O0+UbKh+Ly/LdIQ5YuuW3Qz8lewibaVbXevyIszk/2xc51l+zu3ERYFPeT3lMZZXrzi8F5Od
  /uSyio/llG+OlZ8WBnXdfDbTZemDQm/JK5mtl3/cZuesLWZgkd+zkqFLb5ptl9jMyXXPmNmMA
  xmmbN04yftfvVK8EktxRqKhFnNRcSIATuoq6oYDAAA=
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-18.tower-636.messagelabs.com!1666129883!642373!1
X-Originating-IP: [104.232.228.24]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 30411 invoked from network); 18 Oct 2022 21:51:24 -0000
Received: from unknown (HELO va32lpfpp04.lenovo.com) (104.232.228.24)
  by server-18.tower-636.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Oct 2022 21:51:24 -0000
Received: from va32lmmrp02.lenovo.com (va32lmmrp02.mot.com [10.62.176.191])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp04.lenovo.com (Postfix) with ESMTPS id 4MsSHH5HK9zgK7f;
        Tue, 18 Oct 2022 21:51:23 +0000 (UTC)
Received: from p1g3.mot.com (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by va32lmmrp02.lenovo.com (Postfix) with ESMTPSA id 4MsSHH3S9Jzf6WS;
        Tue, 18 Oct 2022 21:51:23 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <qjv001@motorola.com>,
        Dan Vacura <w36195@motorola.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Elder <paul.elder@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 3/6] usb: gadget: uvc: fix sg handling in error case
Date:   Tue, 18 Oct 2022 16:50:39 -0500
Message-Id: <20221018215044.765044-4-w36195@motorola.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018215044.765044-1-w36195@motorola.com>
References: <20221018215044.765044-1-w36195@motorola.com>
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
transfer types (bulk/isoc/isoc_sg). This ensures userspace knows if the
frame was successfully sent.

Fixes: e81e7f9a0eb9 ("usb: gadget: uvc: add scatter gather support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>
---
V1 -> V2:
- undo error rename
- change uvcg_info to uvcg_dbg
V2 -> V3:
- no changes
V3 -> V4:
- drop extra cc stable cherry-picks, as a request was made to stable

 drivers/usb/gadget/function/uvc_queue.c |  8 +++++---
 drivers/usb/gadget/function/uvc_video.c | 18 ++++++++++++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index ec500ee499ee..0aa3d7e1f3cc 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -304,6 +304,7 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 
 		queue->sequence = 0;
 		queue->buf_used = 0;
+		queue->flags &= ~UVC_QUEUE_DROP_INCOMPLETE;
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
+	if (queue->flags & UVC_QUEUE_DROP_INCOMPLETE) {
+		queue->flags &= ~UVC_QUEUE_DROP_INCOMPLETE;
+		buf->state = UVC_BUF_STATE_ERROR;
 		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
+		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 323977716f5a..5993e083819c 100644
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
+	    video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE ||
 	    buf->bytesused == video->queue.buf_used)
 		video->payload_size = 0;
 }
@@ -180,7 +182,8 @@ uvc_video_encode_isoc_sg(struct usb_request *req, struct uvc_video *video,
 	req->length -= len;
 	video->queue.buf_used += req->length - header_len;
 
-	if (buf->bytesused == video->queue.buf_used || !buf->sg) {
+	if (buf->bytesused == video->queue.buf_used || !buf->sg ||
+			video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE) {
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
+			video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE) {
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
+		uvcg_dbg(&video->uvc->func, "VS request missed xfer.\n");
+		queue->flags |= UVC_QUEUE_DROP_INCOMPLETE;
+		break;
+
 	case -ESHUTDOWN:	/* disconnect from host. */
 		uvcg_dbg(&video->uvc->func, "VS request cancelled.\n");
 		uvcg_queue_cancel(queue, 1);
-- 
2.34.1

