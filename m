Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9BE5FBA73
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 20:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiJKSfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 14:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiJKSf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 14:35:26 -0400
Received: from mail1.bemta33.messagelabs.com (mail1.bemta33.messagelabs.com [67.219.247.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD1F57275;
        Tue, 11 Oct 2022 11:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1665513322; i=@motorola.com;
        bh=8xAKx9WelUadk1WJptoi1rKhb4SCSiYFaWXHRX9ktkU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=TlCKBTKGxFM3kO2GMj9+I0ydLOJx6Ow+OU0EHKRf32YMT0SgHP5QVCuLLvTzrPggU
         se8Q/GV8W3pBpBz8paZA7ANiNwNZsMKIYBgNLuX04WydpQK2C4MhbVIXkE40mSmBNu
         M4HN8JWEq4uvYepHF2Rowy4rNzLxdL24JR/+FDvwkRvZE+6wx9ZOYTuZM8GFxLP5IA
         1/zsYdZ3D6lhTRpd+RHsfn4AXCevIP/WXoKuPmucNNdBbAKfLDw6shuuu5yrANI5KB
         OOoWWBgrFZTu5CYzdeY4QgokfB9khQvlrYnDRJzU4Kp+TdYI9kE0Ci/d5kDS3Mv+Gy
         9iwZQIvcZbnbQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleJIrShJLcpLzFFi42LJePFEVDdju2u
  ywakjNhbH2p6wWzw50M5o0btsD5tF8+L1bBadE5ewWyxsW8JicXnXHDaLRctamS22tF1hsvjx
  p4/ZYsHGR4wWqxYcYHfg8ZjdMZPVY9OqTjaP/XPXsHss7pvM6tH/18Bjy/7PjB6fN8kFsEexZ
  uYl5VcksGZcuvmaseC+fsWUeVPYGxinaHYxcnEICUxlkuifvZUVwlnLJLHw2nwgh5ODTUBNYs
  HrVcwgtoiArMThK7+ZQYqYBW4zS0y6sIwNJCEsECAx8dABRhCbRUBV4uWXfrBmXgFLiSMrj7O
  A2BIC8hL7D54FG8QpYCXx+mwzUC8H0DZLiWPX1CDKBSVOznwCVs4MVN68dTbzBEbeWUhSs5Ck
  FjAyrWK0TirKTM8oyU3MzNE1NDDQNTQ00TWz1DUyNtNLrNJN1Cst1k1NLC7RNdJLLC/WSy0u1
  iuuzE3OSdHLSy3ZxAiMhpQi1zc7GJ+v+Kl3iFGSg0lJlFelxzVZiC8pP6UyI7E4I76oNCe1+B
  CjDAeHkgSv5kqgnGBRanpqRVpmDjAyYdISHDxKIrzvNwOleYsLEnOLM9MhUqcYjTmmzv63n5m
  jc3/XAWYhlrz8vFQpcd6CrUClAiClGaV5cINgCeMSo6yUMC8jAwODEE9BalFuZgmq/CtGcQ5G
  JWFetm1AU3gy80rg9r0COoUJ6JSTV51ATilJREhJNTDNc/CI1Ty5/+ySNbplnUyqRdM2svfVX
  PUROZ2r3stq/zPcf+ZWjboeScFGzcumAZUqhffWnfBqfBepHa3RsGil+oONS4taH3lnnc+blt
  J8rUD3qEJ6YILR07yvJb/WT/6amXnA6U+Wfsafv5yt5/7Ntkrh1q9rYcxXD+SLcHXs3ZH4Jvy
  j/gO9aQvN5a+4vZm6llGl3CU2fLbAt77etzfmK4ZtXrRWfId65/Ud87YJaBZGn97Bn/WN3yvJ
  8FHg8/sc1tI3702fJPhH5Wy2zKLbCSorTM4fLP8ozpxit3TJdcf9hpPkLsq8mLqg5J2PQrFLk
  G/jixk7rP8ny15u32fT3/PI5MzdhBtHPq9xE1JiKc5INNRiLipOBAC8+gcAkwMAAA==
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-5.tower-635.messagelabs.com!1665513320!35716!1
X-Originating-IP: [104.232.228.21]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 19303 invoked from network); 11 Oct 2022 18:35:20 -0000
Received: from unknown (HELO va32lpfpp01.lenovo.com) (104.232.228.21)
  by server-5.tower-635.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 11 Oct 2022 18:35:20 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp01.lenovo.com (Postfix) with ESMTPS id 4Mn4GJ3Vmkzf6md;
        Tue, 11 Oct 2022 18:35:20 +0000 (UTC)
Received: from p1g3.mot.com (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4Mn4GJ27YPzbvDd;
        Tue, 11 Oct 2022 18:35:20 +0000 (UTC)
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
Subject: [PATCH v2 1/3] usb: gadget: uvc: make interrupt skip logic configurable
Date:   Tue, 11 Oct 2022 13:34:33 -0500
Message-Id: <20221011183437.298437-2-w36195@motorola.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221011183437.298437-1-w36195@motorola.com>
References: <20221011183437.298437-1-w36195@motorola.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some UDC hw may not support skipping interrupts, but still support the
request. Allow the interrupt frequency to be configurable to the user.
Default to not skip interrupts, a value of 0. This fixes a smmu panic
that is occurring on dwc3 hw.

Fixes: fc78941d8169 ("usb: gadget: uvc: decrease the interrupt load to a quarter")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>
---
V1 -> V2:
- no change, new patch in series

 Documentation/ABI/testing/configfs-usb-gadget-uvc | 1 +
 Documentation/usb/gadget-testing.rst              | 2 ++
 drivers/usb/gadget/function/f_uvc.c               | 3 +++
 drivers/usb/gadget/function/u_uvc.h               | 1 +
 drivers/usb/gadget/function/uvc.h                 | 1 +
 drivers/usb/gadget/function/uvc_configfs.c        | 2 ++
 drivers/usb/gadget/function/uvc_queue.c           | 6 ++++++
 drivers/usb/gadget/function/uvc_video.c           | 3 ++-
 8 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uvc b/Documentation/ABI/testing/configfs-usb-gadget-uvc
index 611b23e6488d..5dfaa3f7f6a4 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-uvc
+++ b/Documentation/ABI/testing/configfs-usb-gadget-uvc
@@ -8,6 +8,7 @@ Description:	UVC function directory
 		streaming_maxpacket	1..1023 (fs), 1..3072 (hs/ss)
 		streaming_interval	1..16
 		function_name		string [32]
+		req_int_skip_div	unsigned int
 		===================	=============================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/control
diff --git a/Documentation/usb/gadget-testing.rst b/Documentation/usb/gadget-testing.rst
index 2278c9ffb74a..f9b5a09be1f4 100644
--- a/Documentation/usb/gadget-testing.rst
+++ b/Documentation/usb/gadget-testing.rst
@@ -794,6 +794,8 @@ The uvc function provides these attributes in its function directory:
 			    sending or receiving when this configuration is
 			    selected
 	function_name       name of the interface
+	req_int_skip_div    divisor of total requests to aid in calculating
+			    interrupt frequency, 0 indicates all interrupt
 	=================== ================================================
 
 There are also "control" and "streaming" subdirectories, each of which contain
diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 6e196e06181e..75f524c83996 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -655,6 +655,8 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 		cpu_to_le16(max_packet_size * max_packet_mult *
 			    (opts->streaming_maxburst + 1));
 
+	uvc->video.req_int_skip_div = opts->req_int_skip_div;
+
 	/* Allocate endpoints. */
 	ep = usb_ep_autoconfig(cdev->gadget, &uvc_control_ep);
 	if (!ep) {
@@ -872,6 +874,7 @@ static struct usb_function_instance *uvc_alloc_inst(void)
 
 	opts->streaming_interval = 1;
 	opts->streaming_maxpacket = 1024;
+	opts->req_int_skip_div = 0;
 	snprintf(opts->function_name, sizeof(opts->function_name), "UVC Camera");
 
 	ret = uvcg_attach_configfs(opts);
diff --git a/drivers/usb/gadget/function/u_uvc.h b/drivers/usb/gadget/function/u_uvc.h
index 24b8681b0d6f..6f73bd5638ed 100644
--- a/drivers/usb/gadget/function/u_uvc.h
+++ b/drivers/usb/gadget/function/u_uvc.h
@@ -24,6 +24,7 @@ struct f_uvc_opts {
 	unsigned int					streaming_interval;
 	unsigned int					streaming_maxpacket;
 	unsigned int					streaming_maxburst;
+	unsigned int					req_int_skip_div;
 
 	unsigned int					control_interface;
 	unsigned int					streaming_interface;
diff --git a/drivers/usb/gadget/function/uvc.h b/drivers/usb/gadget/function/uvc.h
index 40226b1f7e14..53175cd564e5 100644
--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -107,6 +107,7 @@ struct uvc_video {
 	spinlock_t req_lock;
 
 	unsigned int req_int_count;
+	unsigned int req_int_skip_div;
 
 	void (*encode) (struct usb_request *req, struct uvc_video *video,
 			struct uvc_buffer *buf);
diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index 4303a3283ba0..419e926ab57e 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -2350,6 +2350,7 @@ UVC_ATTR(f_uvc_opts_, cname, cname)
 UVCG_OPTS_ATTR(streaming_interval, streaming_interval, 16);
 UVCG_OPTS_ATTR(streaming_maxpacket, streaming_maxpacket, 3072);
 UVCG_OPTS_ATTR(streaming_maxburst, streaming_maxburst, 15);
+UVCG_OPTS_ATTR(req_int_skip_div, req_int_skip_div, UINT_MAX);
 
 #undef UVCG_OPTS_ATTR
 
@@ -2399,6 +2400,7 @@ static struct configfs_attribute *uvc_attrs[] = {
 	&f_uvc_opts_attr_streaming_interval,
 	&f_uvc_opts_attr_streaming_maxpacket,
 	&f_uvc_opts_attr_streaming_maxburst,
+	&f_uvc_opts_attr_req_int_skip_div,
 	&f_uvc_opts_string_attr_function_name,
 	NULL,
 };
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index ec500ee499ee..872d545838ee 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -63,6 +63,12 @@ static int uvc_queue_setup(struct vb2_queue *vq,
 	 */
 	nreq = DIV_ROUND_UP(DIV_ROUND_UP(sizes[0], 2), req_size);
 	nreq = clamp(nreq, 4U, 64U);
+	if (0 == video->req_int_skip_div) {
+		video->req_int_skip_div = nreq;
+	} else {
+		video->req_int_skip_div =
+			min_t(unsigned int, nreq, video->req_int_skip_div);
+	}
 	video->uvc_num_requests = nreq;
 
 	return 0;
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index bb037fcc90e6..241df42ce0ae 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -413,7 +413,8 @@ static void uvcg_video_pump(struct work_struct *work)
 		if (list_empty(&video->req_free) ||
 		    buf->state == UVC_BUF_STATE_DONE ||
 		    !(video->req_int_count %
-		       DIV_ROUND_UP(video->uvc_num_requests, 4))) {
+		       DIV_ROUND_UP(video->uvc_num_requests,
+			       video->req_int_skip_div))) {
 			video->req_int_count = 0;
 			req->no_interrupt = 0;
 		} else {
-- 
2.34.1

