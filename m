Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62CE5FBA7A
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 20:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiJKSfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 14:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiJKSfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 14:35:42 -0400
Received: from mail1.bemta31.messagelabs.com (mail1.bemta31.messagelabs.com [67.219.246.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F943F320;
        Tue, 11 Oct 2022 11:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1665513337; i=@motorola.com;
        bh=LMQ3jRf7rshL0FGfl/fvT+cEbHI2/1H3uWm3Rs9Dmwo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=CumEUSJ1atqrLlgejs61kfXN6U7fOX1FuUZ974auivDrmUahpMU8ZyaLx6jVbNqZC
         VHBtfO0iIWFaGfw/W5SuFD7CVEg8LPoQ56Qap6pD++7+nUfv/P6Mxh7F8tdFI+Ejj/
         jW1VQRdJzwICkxk9Ih7kMahjBu5ARHn7H3nP4HBKeWhjkNh1IvqGb5GJcUTVAaNWDL
         0w2t1PPpWE+P0lthRjJlE/KLlsD6bfF2kY0UCNJrdOC8K36/FMr04oKwayS/HoZL1W
         zeezEhOinfJxs0RM0KyMsRtV9lviGN6THHYMvMvx+Ce/dapl3uOXRSfmj0oRDRlefb
         Guxx+/el6cQuA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRWlGSWpSXmKPExsWS8eKJqG7Fdtd
  kg6Y9EhbH2p6wWzw50M5o0btsD5tF8+L1bBadE5ewWyxsW8JicXnXHDaLRctamS22tF1hsvjx
  p4/ZYsHGR4wWqxYcYHfg8ZjdMZPVY9OqTjaP/XPXsHss7pvM6tH/18Bjy/7PjB6fN8kFsEexZ
  uYl5VcksGZcnnKHpeCSekXH7z0sDYy7lboYuTiEBKYySdydt4MdwlnLJHFwWTOQw8nBJqAmse
  D1KmYQW0RAVuLwld/MIEXMAreZJSZdWMYGkhAW8JHYdfoamM0ioCrxc+VZJhCbV8BS4tr2PWB
  xCQF5if0Hz4IN4hSwknh9thkozgG0zVLi2DU1iHJBiZMzn7CA2MxA5c1bZzNPYOSdhSQ1C0lq
  ASPTKkbLpKLM9IyS3MTMHF1DAwNdQ0MTXRNdM1O9xCrdRL3SYt3UxOISXUO9xPJivdTiYr3iy
  tzknBS9vNSSTYzASEgpYnHcwbik56feIUZJDiYlUV6VHtdkIb6k/JTKjMTijPii0pzU4kOMMh
  wcShK8miuBcoJFqempFWmZOcCohElLcPAoifC+3wyU5i0uSMwtzkyHSJ1iNOaYOvvffmaOzv1
  dB5iFWPLy81KlxHkLtgKVCoCUZpTmwQ2CJYtLjLJSwryMDAwMQjwFqUW5mSWo8q8YxTkYlYR5
  2bYBTeHJzCuB2/cK6BQmoFNOXnUCOaUkESEl1cDEFfs+jvnYhhcpM8pMPB6v2zPRJfyt4KvkF
  RvmGUqq3o5/mcD2qudn7vUG3n0xB52EU0peZf/cVhd65s7v642BLouW1b1s/ZJs3KEc35S3me
  /TxM3N2te1BP/Oelq04/CjjvpZbcK/lR7mZch/jZT9xVkUXlw46dCX3Hvf+NslpobfWblK51R
  30FtuVbdCx8VP5n+QXHxdefPdx5o/zoiX8D9JbVH6b/7Ie7rK5lj7FbwbXsyLnnr+VfNS1qu7
  3m5d4p7wb1byrBPTTKR19ibxRFYUzPiW94q970vq87LURuE+G15d75syPnveH7Go1nbcbK0ss
  +Dm5T0pW39e1PgVsZXjw91wuYwahaM6M+YFKrEUZyQaajEXFScCAAfLNBWRAwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-3.tower-686.messagelabs.com!1665513336!15096!1
X-Originating-IP: [104.232.228.21]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 4062 invoked from network); 11 Oct 2022 18:35:36 -0000
Received: from unknown (HELO va32lpfpp01.lenovo.com) (104.232.228.21)
  by server-3.tower-686.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 11 Oct 2022 18:35:36 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp01.lenovo.com (Postfix) with ESMTPS id 4Mn4Gc0lxczf6md;
        Tue, 11 Oct 2022 18:35:36 +0000 (UTC)
Received: from p1g3.mot.com (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4Mn4Gb6244zbvDd;
        Tue, 11 Oct 2022 18:35:35 +0000 (UTC)
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
Subject: [PATCH v2 3/3] usb: gadget: uvc: add configfs option for sg support
Date:   Tue, 11 Oct 2022 13:34:35 -0500
Message-Id: <20221011183437.298437-4-w36195@motorola.com>
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

The scatter gather support doesn't appear to work well with some UDC hw.
Add the ability to turn on the feature depending on the controller in
use. Default the feature off since there are transmission problems with
at least one controller, dwc3.

Fixes: e81e7f9a0eb9 ("usb: gadget: uvc: add scatter gather support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>
---
V1 -> V2:
- no change, new patch in series

 Documentation/ABI/testing/configfs-usb-gadget-uvc | 1 +
 Documentation/usb/gadget-testing.rst              | 2 ++
 drivers/usb/gadget/function/f_uvc.c               | 2 ++
 drivers/usb/gadget/function/u_uvc.h               | 1 +
 drivers/usb/gadget/function/uvc_configfs.c        | 2 ++
 drivers/usb/gadget/function/uvc_queue.c           | 4 ++--
 6 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uvc b/Documentation/ABI/testing/configfs-usb-gadget-uvc
index 5dfaa3f7f6a4..839a75fc28ee 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-uvc
+++ b/Documentation/ABI/testing/configfs-usb-gadget-uvc
@@ -9,6 +9,7 @@ Description:	UVC function directory
 		streaming_interval	1..16
 		function_name		string [32]
 		req_int_skip_div	unsigned int
+		sg_supported		0..1
 		===================	=============================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/control
diff --git a/Documentation/usb/gadget-testing.rst b/Documentation/usb/gadget-testing.rst
index f9b5a09be1f4..8e3072d6a590 100644
--- a/Documentation/usb/gadget-testing.rst
+++ b/Documentation/usb/gadget-testing.rst
@@ -796,6 +796,8 @@ The uvc function provides these attributes in its function directory:
 	function_name       name of the interface
 	req_int_skip_div    divisor of total requests to aid in calculating
 			    interrupt frequency, 0 indicates all interrupt
+	sg_supported        allow for scatter gather to be used if the UDC
+			    hw supports it
 	=================== ================================================
 
 There are also "control" and "streaming" subdirectories, each of which contain
diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 75f524c83996..965cf5b48094 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -656,6 +656,7 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 			    (opts->streaming_maxburst + 1));
 
 	uvc->video.req_int_skip_div = opts->req_int_skip_div;
+	uvc->video.queue.use_sg = opts->sg_supported;
 
 	/* Allocate endpoints. */
 	ep = usb_ep_autoconfig(cdev->gadget, &uvc_control_ep);
@@ -875,6 +876,7 @@ static struct usb_function_instance *uvc_alloc_inst(void)
 	opts->streaming_interval = 1;
 	opts->streaming_maxpacket = 1024;
 	opts->req_int_skip_div = 0;
+	opts->sg_supported = 0;
 	snprintf(opts->function_name, sizeof(opts->function_name), "UVC Camera");
 
 	ret = uvcg_attach_configfs(opts);
diff --git a/drivers/usb/gadget/function/u_uvc.h b/drivers/usb/gadget/function/u_uvc.h
index 6f73bd5638ed..5ccced629925 100644
--- a/drivers/usb/gadget/function/u_uvc.h
+++ b/drivers/usb/gadget/function/u_uvc.h
@@ -25,6 +25,7 @@ struct f_uvc_opts {
 	unsigned int					streaming_maxpacket;
 	unsigned int					streaming_maxburst;
 	unsigned int					req_int_skip_div;
+	unsigned int					sg_supported;
 
 	unsigned int					control_interface;
 	unsigned int					streaming_interface;
diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index 419e926ab57e..3784c0e02d01 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -2351,6 +2351,7 @@ UVCG_OPTS_ATTR(streaming_interval, streaming_interval, 16);
 UVCG_OPTS_ATTR(streaming_maxpacket, streaming_maxpacket, 3072);
 UVCG_OPTS_ATTR(streaming_maxburst, streaming_maxburst, 15);
 UVCG_OPTS_ATTR(req_int_skip_div, req_int_skip_div, UINT_MAX);
+UVCG_OPTS_ATTR(sg_supported, sg_supported, 1);
 
 #undef UVCG_OPTS_ATTR
 
@@ -2401,6 +2402,7 @@ static struct configfs_attribute *uvc_attrs[] = {
 	&f_uvc_opts_attr_streaming_maxpacket,
 	&f_uvc_opts_attr_streaming_maxburst,
 	&f_uvc_opts_attr_req_int_skip_div,
+	&f_uvc_opts_attr_sg_supported,
 	&f_uvc_opts_string_attr_function_name,
 	NULL,
 };
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index fc65f8e73732..b11b1e4cfed6 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -149,11 +149,11 @@ int uvcg_queue_init(struct uvc_video_queue *queue, struct device *dev, enum v4l2
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
 	queue->queue.ops = &uvc_queue_qops;
 	queue->queue.lock = lock;
-	if (cdev->gadget->sg_supported) {
+	if (queue->use_sg && cdev->gadget->sg_supported) {
 		queue->queue.mem_ops = &vb2_dma_sg_memops;
-		queue->use_sg = 1;
 	} else {
 		queue->queue.mem_ops = &vb2_vmalloc_memops;
+		queue->use_sg = false;
 	}
 
 	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY
-- 
2.34.1

