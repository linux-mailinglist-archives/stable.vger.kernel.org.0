Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4094EE321
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 23:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiCaVPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 17:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbiCaVPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 17:15:06 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647885FD6;
        Thu, 31 Mar 2022 14:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1648761196; i=@motorola.com;
        bh=Oscoe//5oQimSy5iSL2jY5wOLa/t9XXDwFLpzHlYKyA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
         Content-Transfer-Encoding;
        b=Nxqwf7klgQcmTZbCrwzM70Nw+3R9FucqaRz5KOEIs2YTRRLfCxzPxIUzpPrX6X8Hx
         YLyb1PSek+a7J88lNyFfmORbgcFKXzk1VdNjk34zn4dDqi4CDM7yZ/YvJEfj4Dhyu/
         ECg3vNA17WTXfXk+zqYV9TM37FaO6PFjRBKiYdAuTNpI+8elRJ5VUZmxN8iY4JsQ5b
         iXcdQuqvOJEWdBsIV0eFYDhwiTbQppT5gnx8YCWir1k0JI8aX8QR0hmr7xEjN2/efq
         sANN6pKqgi3rIKykciVNsBz9C6a+ieLiOOPPaBPvL+XVIZfSVS9vHhwVEIyeftRYfT
         XcdxTycQDCb6w==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRWlGSWpSXmKPExsWS8eKJqG62pFu
  SwfNZghbH2p6wW8zZHG3x5EA7o0Xz4vVsFp0Tl7BbLGxbwmJxedccNotFy1qZLR7Ovspo8fbO
  dBaLBRsfMTpwe8zumMnqsXmFlsemVZ1sHvvnrmH3WNw3mdXj8yY5j0Pb37AFsEexZuYl5Vcks
  GZcW3qEpeCtRsXn3l6mBsb5Sl2MXBxCAtOZJE6c+80I4Sxlkjiy9gKQw8nBJqAmseD1KmYQW0
  RAVuLwld/MIEXMAguZJd7+fsYKkhAW8JV4++w2C4jNIqAqMWfeRXYQm1fAUmLxhvNgcQkBeYl
  Tyw4yQcQFJU7OfAIWZwaKN2+dzTyBkXsWktQsJKkFjEyrGG2SijLTM0pyEzNzdA0NDHQNDU2A
  tBGQttBLrNJN1Cst1i1PLS7RNdJLLC/WSy0u1iuuzE3OSdHLSy3ZxAgM6pSitLIdjG39P/UOM
  UpyMCmJ8jocck0S4kvKT6nMSCzOiC8qzUktPsQow8GhJMF7QsQtSUiwKDU9tSItMwcYYTBpCQ
  4eJRHeCDGgNG9xQWJucWY6ROoUoy7HpUNX9jILseTl56VKifNySwAVCYAUZZTmwY2ARfslRlk
  pYV5GBgYGIZ6C1KLczBJU+VeM4hyMSsK8ISBTeDLzSuA2vQI6ggnoCP0briBHlCQipKQamK6U
  ZjWbtH7lFTRlsgthXpna7+3Gen2zekPavE/yV+bNqnx6evqdGPmdimd6PR/LGa3MufdoQ9XbM
  yGpR2evSVj11vuw9deJIrrvX3Ae285sXD35JfPHCU76HAt/W9XO+tPqzvp1gkL/zAMXqjZ/Cd
  v8quVz6Nq4O0XHCzqKNrL1/HRsZZzKMM93ubrYqegCjuc+nt0P5BtP6xjOcPf1b9i0I1nsVnC
  EK/+ed7sl5Xe7tFQ6Vc3u23Fmfk3UUddM5TP5GRlmggrxC5tuzC0q0K6eyB0w6YT+rIcWSW9d
  4y5ce6gunODluUPjDrNTu/WN9y3vfy9bHNeXLL9hWiDrJ5Zf/1Z1TiyZ7KQU3sCzTomlOCPRU
  Iu5qDgRAIXdMEBxAwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-6.tower-636.messagelabs.com!1648761194!43693!1
X-Originating-IP: [104.232.228.21]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.85.5; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 10518 invoked from network); 31 Mar 2022 21:13:15 -0000
Received: from unknown (HELO va32lpfpp01.lenovo.com) (104.232.228.21)
  by server-6.tower-636.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 31 Mar 2022 21:13:15 -0000
Received: from va32lmmrp02.lenovo.com (va32lmmrp02.mot.com [10.62.176.191])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp01.lenovo.com (Postfix) with ESMTPS id 4KTwy21XdRzldQp;
        Thu, 31 Mar 2022 21:13:14 +0000 (UTC)
Received: from p1g3.. (unknown [10.45.4.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by va32lmmrp02.lenovo.com (Postfix) with ESMTPSA id 4KTwy159SZzf6Wh;
        Thu, 31 Mar 2022 21:13:13 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     Dan Vacura <w36195@motorola.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Carlos Bilbao <bilbao@vt.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] usb: gadget: uvc: allow changing interface name via configfs
Date:   Thu, 31 Mar 2022 16:11:50 -0500
Message-Id: <20220331211155.412906-1-w36195@motorola.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a configfs entry, "function_name", to change the iInterface field
for VideoControl. This name is used on host devices for user selection,
useful when multiple cameras are present. The default will remain "UVC
Camera".

Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Dan Vacura <w36195@motorola.com>
---
 .../ABI/testing/configfs-usb-gadget-uvc       |  1 +
 Documentation/usb/gadget-testing.rst          |  1 +
 drivers/usb/gadget/function/f_uvc.c           |  4 +-
 drivers/usb/gadget/function/u_uvc.h           |  1 +
 drivers/usb/gadget/function/uvc_configfs.c    | 41 +++++++++++++++++++
 5 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uvc b/Documentation/ABI/testing/configfs-usb-gadget-uvc
index 889ed45be4ca..611b23e6488d 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-uvc
+++ b/Documentation/ABI/testing/configfs-usb-gadget-uvc
@@ -7,6 +7,7 @@ Description:	UVC function directory
 		streaming_maxburst	0..15 (ss only)
 		streaming_maxpacket	1..1023 (fs), 1..3072 (hs/ss)
 		streaming_interval	1..16
+		function_name		string [32]
 		===================	=============================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/control
diff --git a/Documentation/usb/gadget-testing.rst b/Documentation/usb/gadget-testing.rst
index c6d034abce3a..1c37159fa171 100644
--- a/Documentation/usb/gadget-testing.rst
+++ b/Documentation/usb/gadget-testing.rst
@@ -787,6 +787,7 @@ The uvc function provides these attributes in its function directory:
 	streaming_maxpacket maximum packet size this endpoint is capable of
 			    sending or receiving when this configuration is
 			    selected
+	function_name       name of the interface
 	=================== ================================================
 
 There are also "control" and "streaming" subdirectories, each of which contain
diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 71bb5e477dba..50e6e7a58b41 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -44,7 +44,7 @@ MODULE_PARM_DESC(trace, "Trace level bitmask");
 #define UVC_STRING_STREAMING_IDX		1
 
 static struct usb_string uvc_en_us_strings[] = {
-	[UVC_STRING_CONTROL_IDX].s = "UVC Camera",
+	/* [UVC_STRING_CONTROL_IDX].s = DYNAMIC, */
 	[UVC_STRING_STREAMING_IDX].s = "Video Streaming",
 	{  }
 };
@@ -676,6 +676,7 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 	uvc_hs_streaming_ep.bEndpointAddress = uvc->video.ep->address;
 	uvc_ss_streaming_ep.bEndpointAddress = uvc->video.ep->address;
 
+	uvc_en_us_strings[UVC_STRING_CONTROL_IDX].s = opts->function_name;
 	us = usb_gstrings_attach(cdev, uvc_function_strings,
 				 ARRAY_SIZE(uvc_en_us_strings));
 	if (IS_ERR(us)) {
@@ -866,6 +867,7 @@ static struct usb_function_instance *uvc_alloc_inst(void)
 
 	opts->streaming_interval = 1;
 	opts->streaming_maxpacket = 1024;
+	snprintf(opts->function_name, sizeof(opts->function_name), "UVC Camera");
 
 	ret = uvcg_attach_configfs(opts);
 	if (ret < 0) {
diff --git a/drivers/usb/gadget/function/u_uvc.h b/drivers/usb/gadget/function/u_uvc.h
index 9a01a7d4f17f..24b8681b0d6f 100644
--- a/drivers/usb/gadget/function/u_uvc.h
+++ b/drivers/usb/gadget/function/u_uvc.h
@@ -27,6 +27,7 @@ struct f_uvc_opts {
 
 	unsigned int					control_interface;
 	unsigned int					streaming_interface;
+	char						function_name[32];
 
 	/*
 	 * Control descriptors array pointers for full-/high-speed and
diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index 77d64031aa9c..63b8d3758b38 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -2425,10 +2425,51 @@ UVCG_OPTS_ATTR(streaming_maxburst, streaming_maxburst, 15);
 
 #undef UVCG_OPTS_ATTR
 
+#define UVCG_OPTS_STRING_ATTR(cname, aname)				\
+static ssize_t f_uvc_opts_string_##cname##_show(struct config_item *item,\
+					 char *page)			\
+{									\
+	struct f_uvc_opts *opts = to_f_uvc_opts(item);			\
+	int result;							\
+									\
+	mutex_lock(&opts->lock);					\
+	result = snprintf(page, sizeof(opts->aname), "%s", opts->aname);\
+	mutex_unlock(&opts->lock);					\
+									\
+	return result;							\
+}									\
+									\
+static ssize_t f_uvc_opts_string_##cname##_store(struct config_item *item,\
+					  const char *page, size_t len)	\
+{									\
+	struct f_uvc_opts *opts = to_f_uvc_opts(item);			\
+	int ret = 0;							\
+									\
+	mutex_lock(&opts->lock);					\
+	if (opts->refcnt) {						\
+		ret = -EBUSY;						\
+		goto end;						\
+	}								\
+									\
+	ret = snprintf(opts->aname, min(sizeof(opts->aname), len),	\
+			"%s", page);					\
+									\
+end:									\
+	mutex_unlock(&opts->lock);					\
+	return ret;							\
+}									\
+									\
+UVC_ATTR(f_uvc_opts_string_, cname, aname)
+
+UVCG_OPTS_STRING_ATTR(function_name, function_name);
+
+#undef UVCG_OPTS_STRING_ATTR
+
 static struct configfs_attribute *uvc_attrs[] = {
 	&f_uvc_opts_attr_streaming_interval,
 	&f_uvc_opts_attr_streaming_maxpacket,
 	&f_uvc_opts_attr_streaming_maxburst,
+	&f_uvc_opts_string_attr_function_name,
 	NULL,
 };
 
-- 
2.32.0

