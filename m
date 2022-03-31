Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731564EE0D0
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 20:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbiCaSoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 14:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbiCaSo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 14:44:26 -0400
Received: from mail1.bemta31.messagelabs.com (mail1.bemta31.messagelabs.com [67.219.246.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51404235771;
        Thu, 31 Mar 2022 11:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1648752157; i=@motorola.com;
        bh=I0ILUk5Y0W7A0emDc9iHMdTkNtmNc0vpgg9nFCU/qeE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
         Content-Transfer-Encoding;
        b=rjHnYntgkh0QMw8W/7WG/tuxNt2MgjW/hiXKdpFVPlo5STwmwikah1n3SQ8TaySb6
         siJddTotE2VHpNEoWcIm/1LSSckbWhhX5lNTKgVhq1I58lAuIle0ZW6kSsgFJ/OePp
         +PqCrCDQOsqdStkTk/XV1uZTqr6Lp5VIgg+Eh17KdDolkBzgcFKBgue66k4V56xzuF
         8nhWcRx8jDBdiSFOWkTKoZZp1J3wVglbM1YRxFtkpy6YjeUVG84q9MKGwYHPRav+Gh
         5EkD3ivBgwpl69EDt3wj/Vq3MlO7KXG81eSz/LelrXTL3YN1cxeciotSKiAcNRhIFR
         /ftjy06ksuMNg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRWlGSWpSXmKPExsWS8eKJhK7MN9c
  kg6ttkhbH2p6wW6xefJXJonnxejaLzolL2C0u75rDZrFoWSuzxYKNjxgd2D1md8xk9di0qpPN
  Y//cNeweT3/sZfb4vEkugDWKNTMvKb8igTVj9+3dzAWrBCteX/nG1MDYyd/FyMkhJDCVSeL6V
  JYuRi4gewmTxKLvLewgCTYBNYkFr1cxg9giArISh6/8BrOZBSYwSXzckwJiCwsESRxY+w+snk
  VAVeJs5zwmEJtXwELizpIlYPUSAvISp5YdhIoLSpyc+YQFYo68RPPW2cwTGLlnIUnNQpJawMi
  0itEiqSgzPaMkNzEzR9fQwEDX0NBE10TXXC+xSjdRr7RYNzWxuETXUC+xvFgvtbhYr7gyNzkn
  RS8vtWQTIzAgU4pY2Hcwru35qXeIUZKDSUmU1+GQa5IQX1J+SmVGYnFGfFFpTmrxIUYZDg4lC
  V7ez0A5waLU9NSKtMwcYHTApCU4eJREeK+9BkrzFhck5hZnpkOkTjHqcjy9emUvsxBLXn5eqp
  Q4r/VXoCIBkKKM0jy4EbBIvcQoKyXMy8jAwCDEU5BalJtZgir/ilGcg1FJmNcbZApPZl4J3KZ
  XQEcwAR2hfwPsiJJEhJRUA5Nqqby9MHtgvv+hOy5l4bYNdYd+swj8WbKSZ/oC4wDH5Hnq3I1H
  Np60vnLn5LOn5ofEDgo0vHueECW+roahJ3OjUEysStrTe7oXDjbdM0t2VPqVpsF2o/DUeo/1b
  cknfRVY23QOy1+wuXlcknnnTJOzu70YPot88llwc/lOEZu7MVeet7lMXxW911t/03eH6Xf6OL
  66a1tcn3D98e3Ag5+uzHM6I7ev7uXNAwzO6044ZCcYcX5t5Pv2SNsl5avWy1hH1jCJmP1xOxy
  SLvNVPr0QXP4i4q2zKGOVQvXxisq7T79e5BP/uDJw+lOhx8xslV5cobM33WKVXWip9WrX5YTC
  x2/mJegXt+2uFz0f3qTEUpyRaKjFXFScCABxs+hITwMAAA==
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-15.tower-706.messagelabs.com!1648752156!5014!1
X-Originating-IP: [104.232.228.24]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.85.5; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 2705 invoked from network); 31 Mar 2022 18:42:36 -0000
Received: from unknown (HELO va32lpfpp04.lenovo.com) (104.232.228.24)
  by server-15.tower-706.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 31 Mar 2022 18:42:36 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp04.lenovo.com (Postfix) with ESMTPS id 4KTscD0zcyzbbbK;
        Thu, 31 Mar 2022 18:42:36 +0000 (UTC)
Received: from p1g3.. (unknown [10.45.4.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4KTscC65fkzbvDd;
        Thu, 31 Mar 2022 18:42:35 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     Dan Vacura <w36195@motorola.com>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] usb: gadget: uvc: Fix crash when encoding data for usb request
Date:   Thu, 31 Mar 2022 13:40:23 -0500
Message-Id: <20220331184024.23918-1-w36195@motorola.com>
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

During the uvcg_video_pump() process, if an error occurs and
uvcg_queue_cancel() is called, the buffer queue will be cleared out, but
the current marker (queue->buf_used) of the active buffer (no longer
active) is not reset. On the next iteration of uvcg_video_pump() the
stale buf_used count will be used and the logic of min((unsigned
int)len, buf->bytesused - queue->buf_used) may incorrectly calculate a
nbytes size, causing an invalid memory access.

[80802.185460][  T315] configfs-gadget gadget: uvc: VS request completed
with status -18.
[80802.185519][  T315] configfs-gadget gadget: uvc: VS request completed
with status -18.
...
uvcg_queue_cancel() is called and the queue is cleared out, but the
marker queue->buf_used is not reset.
...
[80802.262328][ T8682] Unable to handle kernel paging request at virtual
address ffffffc03af9f000
...
...
[80802.263138][ T8682] Call trace:
[80802.263146][ T8682]  __memcpy+0x12c/0x180
[80802.263155][ T8682]  uvcg_video_pump+0xcc/0x1e0
[80802.263165][ T8682]  process_one_work+0x2cc/0x568
[80802.263173][ T8682]  worker_thread+0x28c/0x518
[80802.263181][ T8682]  kthread+0x160/0x170
[80802.263188][ T8682]  ret_from_fork+0x10/0x18
[80802.263198][ T8682] Code: a8c12829 a88130cb a8c130

Fixes: d692522577c0 ("usb: gadget/uvc: Port UVC webcam gadget to use videobuf2 framework")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>

---
Changes in v3:
- Cc stable
Changes in v2:
- Add Fixes tag

 drivers/usb/gadget/function/uvc_queue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index d852ac9e47e7..2cda982f3765 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -264,6 +264,8 @@ void uvcg_queue_cancel(struct uvc_video_queue *queue, int disconnect)
 		buf->state = UVC_BUF_STATE_ERROR;
 		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
+	queue->buf_used = 0;
+
 	/* This must be protected by the irqlock spinlock to avoid race
 	 * conditions between uvc_queue_buffer and the disconnection event that
 	 * could result in an interruptible wait in uvc_dequeue_buffer. Do not
-- 
2.32.0

