Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B7D4DDF53
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239365AbiCRQuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239301AbiCRQuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:50:12 -0400
Received: from mail1.bemta31.messagelabs.com (mail1.bemta31.messagelabs.com [67.219.246.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEA62F09FF;
        Fri, 18 Mar 2022 09:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1647622129; i=@motorola.com;
        bh=4tTrL6MoObzkg36pxyIJNl57VWNIKMGSOhfyf5Pe+90=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
         Content-Transfer-Encoding;
        b=knoeRLLqLfIxUJLrusdgHQqTv9tvfsTTnjFwq3zg8NoU0692rxt9KwThX0qJyofzq
         pR6graiEnGOUmEham3VHXJruvU/v2CGAZEHwoohOvDDcJqj84j2SlR31JTEen8hCSb
         HqGTUgUXWJyuJRI+Uik54w475Lo46DWXgXW86+G8zv0CifvjLEgJE64SNMRAxvnE/N
         I2ownRTONTtUIFbFA6SdiV6waPGB2jzqhDbzPF9BnkFsNvrCxx3ppGnVynlMRx3BqX
         c+Nl2N0vcr5gu2c0CbhXq42z6jcO/7hmCupJK8zw+E5JMCWPGEYsueAL5+WPpGW5kL
         MBf2Rx+WPPHxQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRWlGSWpSXmKPExsUyYU+Ds+6H7SZ
  JBse/ilkca3vCbrF68VUmi+bF69ksOicuYbe4vGsOm8WiZa3MFgs2PmJ0YPeY3TGT1WPTqk42
  j/1z17B7PP2xl9nj8ya5ANYo1sy8pPyKBNaMBbfWsRd8Eqi4uGATYwPjTb4uRi4OIYEpTBIbl
  21kg3CWMEl07lvN3sXIycEmoCax4PUqZhBbREBW4vCV38wgRcwCE5gkGjqOMYIkhAWCJJZd3s
  AGYrMIqEpcf/EMLM4rYCGx6cQaVhBbQkBe4tSyg0wQcUGJkzOfsIDYzEDx5q2zmScwcs9Ckpq
  FJLWAkWkVo2VSUWZ6RkluYmaOrqGBga6hoYmuqa6FpV5ilW6iXmmxbmpicYmuoV5iebFeanGx
  XnFlbnJOil5easkmRmBYphSxRu5gnN3zU+8QoyQHk5Ior8hykyQhvqT8lMqMxOKM+KLSnNTiQ
  4wyHBxKErxiW4BygkWp6akVaZk5wBiBSUtw8CiJ8IaCpHmLCxJzizPTIVKnGHU5nl69spdZiC
  UvPy9VSpx34VagIgGQoozSPLgRsHi9xCgrJczLyMDAIMRTkFqUm1mCKv+KUZyDUUmYVxtkCk9
  mXgncpldARzABHdEoYARyREkiQkqqgUmNWefIbWUufSaTlQca9xgfYVSeKCYSo1Gglnz5t4Nk
  54yNcskCys2igaWruvguBd9aujLJyif6NAv3sX6266KvLuQs9mNc99fMaXXAHUvxGSz+3T0Sp
  TUbFDpc+M/WXnS5oWgwuyaVx31yjl29r7Oo6LScKe7lTY+6d8j+e1PMqfLbjV1xlqmwtbV5VJ
  vek6LMeyu1L32/euJEw2HdItaA2EXl3x78XNJcNi/kzi+V7VazNkTvEol0uMOy8FaMy61iafd
  ckenzpJ//5JcWe3/8mlPgaovnd365qkbpbphqNdPPRk12TbP1mljzRUvmLe6V3id07tEfyT+c
  fXMEUzdGCf/Myql+P9f9xd4pSizFGYmGWsxFxYkAtr3+/lIDAAA=
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-31.tower-706.messagelabs.com!1647622128!4665!1
X-Originating-IP: [144.188.128.67]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.10; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 22957 invoked from network); 18 Mar 2022 16:48:48 -0000
Received: from unknown (HELO ilclpfpp01.lenovo.com) (144.188.128.67)
  by server-31.tower-706.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Mar 2022 16:48:48 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by ilclpfpp01.lenovo.com (Postfix) with ESMTPS id 4KKqhv6gmRzfBZq;
        Fri, 18 Mar 2022 16:48:47 +0000 (UTC)
Received: from p1g3.. (unknown [10.45.4.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4KKqhv5b7yzbvDd;
        Fri, 18 Mar 2022 16:48:47 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org, Dan Vacura <w36195@motorola.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] usb: gadget: uvc: Fix crash when encoding data for usb request
Date:   Fri, 18 Mar 2022 11:47:06 -0500
Message-Id: <20220318164706.22365-1-w36195@motorola.com>
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
Signed-off-by: Dan Vacura <w36195@motorola.com>

---
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

