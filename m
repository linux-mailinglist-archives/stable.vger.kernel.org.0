Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360335FBA76
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 20:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJKSfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 14:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiJKSfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 14:35:34 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F13E3ECF1;
        Tue, 11 Oct 2022 11:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1665513332; i=@motorola.com;
        bh=evEITZy7I0DTnMVz5F/vBcq9MsXeTBrpOLV85p5AA1I=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=UX2kesligIbpfv+YBD7O/9yExg0sBJ6GcfToJNHOxD65vjAuSQo4ng+2CwlgODMpI
         qzY3oe+CI9DignnXd5lH+WoxSgYTpEuixas9XgtTEp/1CT76rCme0y6gNdBgPAqXQk
         QbAKv8wuVFam9nOsg35JVJbp/rDKZP7qD0+SXxAFNUEVEL0kblKYdfIXD5AT4UfJIa
         JS84l+sWaEu7JXsH7Mi0J8Fun1pgR/wenGEaHnJsgPRmFz2So7CbADBBKnnPs//C+l
         6GvkPde8/K51BW09in4tnDLcUaAItKBTNqkv65pRG0PNBYvZ2qlUkqB0390vWzP7wQ
         3plGWGSM7/t7w==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleJIrShJLcpLzFFi42LJePFEXLd4u2u
  ywe4GA4tjbU/YLZ4caGe06F22h82iefF6NovOiUvYLRa2LWGxuLxrDpvFomWtzBZb2q4wWfz4
  08dssWDjI0aLVQsOsDvweMzumMnqsWlVJ5vH/rlr2D0W901m9ej/a+CxZf9nRo/Pm+QC2KNYM
  /OS8isSWDMerfnDWjBBreLArpXsDYxnFLoYuTiEBKYxSax9tYYVwlnLJHHzcS9bFyMnB5uAms
  SC16uYQWwRAVmJw1d+M4MUMQvcZpaYdGEZWJGwgLvEuy+TWUBsFgFVia4Jk1lBbF4BS4m3P2e
  D2RIC8hL7D54FG8QpYCXx+mwzUC8H0DZLiWPX1CDKBSVOznwCNoYZqLx562zmCYy8s5CkZiFJ
  LWBkWsVonVSUmZ5RkpuYmaNraGCga2hoAqSNdM1M9BKrdBP1Sot1y1OLS3SN9BLLi/VSi4v1i
  itzk3NS9PJSSzYxAqMhpSjNYQfjvP6feocYJTmYlER5VXpck4X4kvJTKjMSizPii0pzUosPMc
  pwcChJ8GquBMoJFqWmp1akZeYAIxMmLcHBoyTC+34zUJq3uCAxtzgzHSJ1itGYY+rsf/uZOTr
  3dx1gFmLJy89LlRLnLdgKVCoAUppRmgc3CJYwLjHKSgnzMjIwMAjxFKQW5WaWoMq/YhTnYFQS
  5mXbBjSFJzOvBG7fK6BTmIBOOXnVCeSUkkSElFQDU+tVtq+rlwXbuzTlmAi/9trdGd5br9Tw6
  PK/G8VpQf3ie5O1DCZ+DvFg9H5fVtz5sIHp7MXnWbcu5G+blWr3dOl99id3mA3SHGa3Xr/s+6
  drh9hTkytJvFOfzGA+wLNF6Z1+1pXzDecaG2cwvXm1kcU2kN3yyDzLmw5qlpMnXo3ZfGZOXO3
  6mC++h24UqXM9zrsftCzh05lnvw0ct9cuTlza9OnG5Nb10SEnZA4t1XZzcvThm/9P95dTw86H
  UyYuz2j1Cfr7+2WxV3/DadN+XjZG5m/9burPuUUfLd6c+Kn206OGPM4TE12VoialTzbU+SL1+
  kaAau5Lx0sToi+UlaVM+JtQbb41ql84/6bfCSWW4oxEQy3mouJEABLUyyWTAwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-22.tower-636.messagelabs.com!1665513330!512975!1
X-Originating-IP: [104.232.228.23]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 5318 invoked from network); 11 Oct 2022 18:35:31 -0000
Received: from unknown (HELO va32lpfpp03.lenovo.com) (104.232.228.23)
  by server-22.tower-636.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 11 Oct 2022 18:35:31 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp03.lenovo.com (Postfix) with ESMTPS id 4Mn4GV4v8jz50WfM;
        Tue, 11 Oct 2022 18:35:30 +0000 (UTC)
Received: from p1g3.mot.com (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4Mn4GV34bTzbvDd;
        Tue, 11 Oct 2022 18:35:30 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Dan Vacura <w36195@motorola.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v2 2/3] usb: gadget: uvc: fix sg handling in error case
Date:   Tue, 11 Oct 2022 13:34:34 -0500
Message-Id: <20221011183437.298437-3-w36195@motorola.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221011183437.298437-1-w36195@motorola.com>
References: <20221011183437.298437-1-w36195@motorola.com>
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

 drivers/usb/gadget/function/uvc_queue.c |  8 +++++---
 drivers/usb/gadget/function/uvc_video.c | 18 ++++++++++++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 872d545838ee..fc65f8e73732 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -310,6 +310,7 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 
 		queue->sequence = 0;
 		queue->buf_used = 0;
+		queue->flags &= ~UVC_QUEUE_DROP_INCOMPLETE;
 	} else {
 		ret = vb2_streamoff(&queue->queue, queue->queue.type);
 		if (ret < 0)
@@ -335,10 +336,11 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
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
index 241df42ce0ae..9d76101c699d 100644
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

