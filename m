Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDB6601ABD
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 22:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiJQUzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 16:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiJQUzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 16:55:36 -0400
Received: from mail1.bemta31.messagelabs.com (mail1.bemta31.messagelabs.com [67.219.246.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0185E6C975;
        Mon, 17 Oct 2022 13:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666040129; i=@motorola.com;
        bh=NOhktsFLmQtBuXz/JYn15RmVV9EK16MqKyqGXNDWM9M=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=RSSb7hRksdVVjg4v9ib36feuf8bmLyMaOTJDGUVnqz2Oh3/8ZRm7HmBG2z62K8Gpf
         d8eHiGwRly6MJ6S0j2id3ZRdhbpsNXB/FuGjan3h5OT+LCcfQ5hJNrA+fVrdSVikuu
         GyaHLClH1DU58D8aZNmJXoMxEHvq/Dz1hSWr0WZnPRIkAluMu9txaHFnGRd1butFSD
         MnsxsZyP83KFlAD+qwAniisvlQ/z+NJmtF9ypIFWjIDrQC+eoZUy9tmc1/op7CdX/h
         iK4PfGh6bK/ms2ZX3P1lHWuvxP0I8t+EJD5Ctie7DVO4OZw7emrcN1iWPL9hOOIfo7
         F/vMxuBsQEXFg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRWlGSWpSXmKPExsWS8eKJmK7DQd9
  kg7/7OC2OtT1ht3hyoJ3RonfZHjaL5sXr2Sw6Jy5ht1jYtoTF4vKuOWwWi5a1MltsabvCZPHj
  Tx+zxYKNjxgtVi04wO7A4zG7Yyarx6ZVnWwe++euYfdY3DeZ1aP/r4HHlv2fGT0+b5ILYI9iz
  cxLyq9IYM24NOs+W8FytYrLzy6xNTDeVehi5OIQEpjGJPF9+l9mCGctk0Tz78nsXYycHGwCah
  ILXq9iBrFFBGQlDl/5DVbELNDAIrFy2nlWkISwgLvE/PtTWLoYOThYBFQl5rSkgZi8ApYSM3Y
  EglRICMhL7D94lhkkzClgJbFhqjpIWAioYvOBLWBDeAUEJU7OfMICYjMDlTdvnc08gZF3FpLU
  LCSpBYxMqxhNi1OLylKLdE31kooy0zNKchMzc/QSq3QT9UqLdVMTi0t0DfUSy4v1UouL9Yorc
  5NzUvTyUks2MQKDP6WIccUOxknL/ugdYpTkYFIS5e2Y4ZssxJeUn1KZkVicEV9UmpNafIhRho
  NDSYL35w6gnGBRanpqRVpmDjASYdISHDxKIryd24DSvMUFibnFmekQqVOMuhyd+7sOMAux5OX
  npUqJ8/7YB1QkAFKUUZoHNwKWFC4xykoJ8zIyMDAI8RSkFuVmlqDKv2IU52BUEua9vx9oCk9m
  XgncpldARzABHZGx3wvkiJJEhJRUA1PxzISXEgeEznz4rvecNVG+8aztNO/1vyQsTHQafebVB
  q7bW6Gxagmb2JnaqGX/Oy7wXD6vx/8uWcRh1t67J9adOnhy9jWhnOO+J3pS+VZ/ieqcO/0OY7
  mulviMJ6fTd1xgeJ9+wZB31RLWu992MrmVdBlsltt3cpcYf5VSu3+RTLypjZnjl9JDiuk/bO9
  zZvpOdd+qwuC/8mbxTZ009x9sveeCXy+7zWL59MIm7n0d1hxrWNoUy2dua95YwXq39NZD77na
  UTWCxxVE+1vspW97/r0pPH9ltO6hkPaqb8HbC9NdP5hyHrYtVVC/mH5Bo6957vl3Dq+s40qfN
  htv2nvmLsNnW4av0he9b3Rz2SqxFGckGmoxFxUnAgCBF8NrhQMAAA==
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-26.tower-686.messagelabs.com!1666040127!469899!1
X-Originating-IP: [104.232.228.22]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 11647 invoked from network); 17 Oct 2022 20:55:28 -0000
Received: from unknown (HELO va32lpfpp02.lenovo.com) (104.232.228.22)
  by server-26.tower-686.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Oct 2022 20:55:28 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp02.lenovo.com (Postfix) with ESMTPS id 4Mrq5C5wk0z50GGl;
        Mon, 17 Oct 2022 20:55:27 +0000 (UTC)
Received: from p1g3.mot.com (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4Mrq5C4N2Nzbpxx;
        Mon, 17 Oct 2022 20:55:27 +0000 (UTC)
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
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 3/6] usb: gadget: uvc: fix sg handling in error case
Date:   Mon, 17 Oct 2022 15:54:41 -0500
Message-Id: <20221017205446.523796-4-w36195@motorola.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221017205446.523796-1-w36195@motorola.com>
References: <20221017205446.523796-1-w36195@motorola.com>
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
Cc: <stable@vger.kernel.org> # 859c675d84d4: usb: gadget: uvc: consistently use define for headerlen
Cc: <stable@vger.kernel.org> # f262ce66d40c: usb: gadget: uvc: use on returned header len in video_encode_isoc_sg
Cc: <stable@vger.kernel.org> # 61aa709ca58a: usb: gadget: uvc: rework uvcg_queue_next_buffer to uvcg_complete_buffer
Cc: <stable@vger.kernel.org> # 9b969f93bcef: usb: gadget: uvc: giveback vb2 buffer on req complete
Cc: <stable@vger.kernel.org> # aef11279888c: usb: gadget: uvc: improve sg exit condition
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>
---
V1 -> V2:
- undo error rename
- change uvcg_info to uvcg_dbg
V2 -> V3:
- no changes

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
index 91a58567beac..dd54841b0b3e 100644
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

