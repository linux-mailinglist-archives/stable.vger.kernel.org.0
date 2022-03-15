Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E964DA183
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 18:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350699AbiCORqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 13:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbiCORqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 13:46:44 -0400
Received: from mail1.bemta31.messagelabs.com (mail1.bemta31.messagelabs.com [67.219.246.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C72E4F9DF;
        Tue, 15 Mar 2022 10:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1647366330; i=@motorola.com;
        bh=5E5zxINeV0hdwni5VHVJAAVrPJoXGXxiqslzNvn1vRQ=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
         Content-Transfer-Encoding;
        b=S/7dLSZKO7q9C3Drqhco+gKO2kfp9BF+Svlq8G0SdZgsZJHJc1GVToJRqEI1bZCRY
         YlXH9bzphBxkPhNhwTDg/m6nGOOjoRwTWPNLsGrEtb0oF1QHVIn4QY0teNXI7ON8+G
         pOTy/kP1gij4k4TCAVbGLB7r13CnOy+wWBloO05N7sqIgJ2SHUcoTgRJvNQ0yJgJFN
         HvwntMXi6NjggcENRzR/Mil/u7X8/iAyxZGbV7HNOi9BHMm1dNovMJ8KHpxJLnibmU
         eoPeE17kes2hYWZqCy9SVOz/6iYt0rfHsZAOYwXfByFqoLZoXUdduA77l66UsrhdJp
         0Ve/mYzI7zaig==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRWlGSWpSXmKPExsUyYU+Ds+6uCwZ
  JBuuULI61PWG3aF68ns2ic+ISdovLu+awWSxa1spssWDjI0YHNo/ZHTNZPTat6mTz2D93DbvH
  501yASxRrJl5SfkVCawZixcXF3zjr5i/4SdbA+Mn3i5GLg4hgWlMEjcP9LBCOEuYJO62r2XvY
  uTkYBNQk1jwehUziC0iICtx+MpvMJtZ4DmjxO9+ZRBbWMBfYseJmYwgNouAqkT77FUsIDavgI
  XEvG9PwOISAvISp5YdZIKIC0qcnPmEBWKOvETz1tnMExi5ZyFJzUKSWsDItIrRIqkoMz2jJDc
  xM0fX0MBA19DQRNdE11wvsUo3Ua+0WDc1sbhE11AvsbxYL7W4WK+4Mjc5J0UvL7VkEyMw9FKK
  WNh3MK7t+al3iFGSg0lJlLew3CBJiC8pP6UyI7E4I76oNCe1+BCjDAeHkgTv7rNAOcGi1PTUi
  rTMHGAcwKQlOHiURHhXHgNK8xYXJOYWZ6ZDpE4x6nI8vXplL7MQS15+XqqUOG/PeaAiAZCijN
  I8uBGwmLzEKCslzMvIwMAgxFOQWpSbWYIq/4pRnINRSZj3EsgUnsy8ErhNr4COYAI6Yp60Hsg
  RJYkIKakGprXfGR7mGBgIzH9fvaX6u6PWlnB/2wkpH1yXhxR8/i2hMeEVq/ZOsUcSh+53JJ0s
  trbk/yTyTEZHbIszT+DfcNOtnewRVaVi775Mrf417f7Tg+l9ikuizes+SDUdr/078/GM2G3zS
  tN7S8I371wwjy3svcRSsaoNnzfbuplI27WZvfn44Iee8aQpMkLmjAvail762ovl+YSszxUt5z
  /vdfvjNj1jfraNQXsf8bpmWpXJs/vtWbXmsqlUFqfX5durYp81ewW5pkrsLVmwZf30yQpJc24
  e9/p9OFPQ/EdBAKvGKaanfUt22cz0UrAOfHamNFrYlL8hWTtNNWaNata7St3XOrIqjCtrwyZd
  K21XYinOSDTUYi4qTgQAkRt2mUQDAAA=
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-5.tower-706.messagelabs.com!1647366329!9570!1
X-Originating-IP: [144.188.128.67]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.9; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 9506 invoked from network); 15 Mar 2022 17:45:29 -0000
Received: from unknown (HELO ilclpfpp01.lenovo.com) (144.188.128.67)
  by server-5.tower-706.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 15 Mar 2022 17:45:29 -0000
Received: from va32lmmrp02.lenovo.com (va32lmmrp02.mot.com [10.62.176.191])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by ilclpfpp01.lenovo.com (Postfix) with ESMTPS id 4KJ15j41nvzfBZq;
        Tue, 15 Mar 2022 17:45:29 +0000 (UTC)
Received: from p1g3.. (unknown [10.45.4.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by va32lmmrp02.lenovo.com (Postfix) with ESMTPSA id 4KJ15j0VzSzf6Wf;
        Tue, 15 Mar 2022 17:45:29 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org, Dan Vacura <w36195@motorola.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: uvc: Fix crash when encoding data for usb request
Date:   Tue, 15 Mar 2022 12:41:46 -0500
Message-Id: <20220315174146.27155-1-w36195@motorola.com>
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

Signed-off-by: Dan Vacura <w36195@motorola.com>
---
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

