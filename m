Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1926C54FB1E
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 18:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiFQQcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 12:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiFQQcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 12:32:21 -0400
Received: from mail1.bemta33.messagelabs.com (mail1.bemta33.messagelabs.com [67.219.247.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C6B443CA;
        Fri, 17 Jun 2022 09:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1655483539; i=@motorola.com;
        bh=4qhNSaWDIEzNmKnIquOhI5GtN3EyttOwc2Krhh8v2vo=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
         Content-Transfer-Encoding;
        b=lN+WWqcbFNChEvGubcO1wl9kVXZyvG+K4LzbODYd+FSOA8JawsqkpD9ufKIToyu0g
         B+Venf+Po+DA7WaSms6kb0OMmuPP6jWEykwgxS3TDXSgL+fMBRlFeypTfUYoKHaYIa
         N/zAQQ9ImkXMWoYDbmFrAOiZZIOPSqHlF8MHCP4qFqm29fyPAzZDKP0WBoBrCHD1es
         e6N6SspHgRBfrcVXvaw/dirvQ4XxcBQaINL406ylPg10yPL+zdNPeSlZVd0R2lvbft
         Yu5fBpsHqynnti8V2+eFjB8Sqb23kVDxddEsktT/LSasL6/RjyTiIlFqFMjq/BtKIf
         qyHUC97VGf21g==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRWlGSWpSXmKPExsUyYU+Di+6kNWu
  SDP6elbc41vaE3aJ58Xo2i86JS9gtLu+aw2axaFkrs8WWtitMFj/+9DFbLNj4iNGBw2N2x0xW
  j02rOtk89s9dw+7R/9fA4/MmuQDWKNbMvKT8igTWjKub37EWbOOt6Phq3MC4n7uLkYtDSGAyk
  8Sr7h9MEM5iJonLdxezdTFycrAJqEkseL2KGcQWEZCVOHzlNzNIEbPAYSaJd5/Ps4MkhAV8JP
  Zu7WQCsVkEVCU2XepnBbF5BSwkds3aBmZLCMhL7D94lhkiLihxcuYTFhCbGSjevHU28wRG7ll
  IUrOQpBYwMq1itE4qykzPKMlNzMzRNTQw0DU0NNE1M9U1MrHUS6zSTdQrLdZNTSwu0TXSSywv
  1kstLtYrrsxNzknRy0st2cQIDNCUIsefOxh7Vv3UO8QoycGkJMpbtnRNkhBfUn5KZUZicUZ8U
  WlOavEhRhkODiUJ3turgXKCRanpqRVpmTnAaIFJS3DwKInwyi4HSvMWFyTmFmemQ6ROMepydO
  7vOsAsxJKXn5cqJc67DGSGAEhRRmke3AhY5F5ilJUS5mVkYGAQ4ilILcrNLEGVf8UozsGoJMy
  bAjKFJzOvBG7TK6AjmICOaNy3AuSIkkSElFQDU4WD58PMQ/nHOgwm+/2riNh5UuP+8tfb1af2
  7qkvDl0my+U6SeDq6udfniazr919YKXc3AXt8kJLxKryrlhfFXjw4rvc8vjLRbw311xYzNmQJ
  thRrZqur+upsb9n5gR7rcpuVo1Zf3Nmngg/3HtiY2OQvtTnp+/4PV9XOd60Wm5m3rtF+ZKfXJ
  RBc6iK0LHCG8dsuLcn5119d3/tyye+C/4eCNeu5DvAGFtqnbdka8tLBpO5DamLMz4Wtws7NFp
  b27X9cXHb1VW+/ewplw7RrZdXSWaHS/RxbCxlWX/SWv39mvvxm8pOqX8+Fd/2ffLfUvW6qM0L
  1zn/2fVlW6vtSrljiy09p3LZRGcX1uyYoMRSnJFoqMVcVJwIAImL4sFXAwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-3.tower-715.messagelabs.com!1655483538!7014!1
X-Originating-IP: [144.188.128.68]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.86.7; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 2923 invoked from network); 17 Jun 2022 16:32:18 -0000
Received: from unknown (HELO ilclpfpp02.lenovo.com) (144.188.128.68)
  by server-3.tower-715.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Jun 2022 16:32:18 -0000
Received: from ilclmmrp02.lenovo.com (ilclmmrp02.mot.com [100.65.83.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by ilclpfpp02.lenovo.com (Postfix) with ESMTPS id 4LPl1t0S4hzbrVK;
        Fri, 17 Jun 2022 16:32:18 +0000 (UTC)
Received: from p1g3.. (unknown [10.45.6.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp02.lenovo.com (Postfix) with ESMTPSA id 4LPl1s5yXSzbrlQ;
        Fri, 17 Jun 2022 16:32:17 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     Dan Vacura <w36195@motorola.com>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] usb: gadget: uvc: fix list double add in uvcg_video_pump
Date:   Fri, 17 Jun 2022 11:31:53 -0500
Message-Id: <20220617163154.16621-1-w36195@motorola.com>
X-Mailer: git-send-email 2.34.1
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

A panic can occur if the endpoint becomes disabled and the
uvcg_video_pump adds the request back to the req_free list after it has
already been queued to the endpoint. The endpoint complete will add the
request back to the req_free list. Invalidate the local request handle
once it's been queued.

<6>[  246.796704][T13726] configfs-gadget gadget: uvc: uvc_function_set_alt(1, 0)
<3>[  246.797078][   T26] list_add double add: new=ffffff878bee5c40, prev=ffffff878bee5c40, next=ffffff878b0f0a90.
<6>[  246.797213][   T26] ------------[ cut here ]------------
<2>[  246.797224][   T26] kernel BUG at lib/list_debug.c:31!
<6>[  246.807073][   T26] Call trace:
<6>[  246.807180][   T26]  uvcg_video_pump+0x364/0x38c
<6>[  246.807366][   T26]  process_one_work+0x2a4/0x544
<6>[  246.807394][   T26]  worker_thread+0x350/0x784
<6>[  246.807442][   T26]  kthread+0x2ac/0x320

Fixes: f9897ec0f6d3 ("usb: gadget: uvc: only pump video data if necessary")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Vacura <w36195@motorola.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
V1 -> V2:
- update logic flow per review recommendation
- add review by for Laurent Pinchart

 drivers/usb/gadget/function/uvc_video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 93f42c7f800d..c00ce0e91f5d 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -428,6 +428,9 @@ static void uvcg_video_pump(struct work_struct *work)
 			uvcg_queue_cancel(queue, 0);
 			break;
 		}
+
+		/* Endpoint now owns the request */
+		req = NULL;
 		video->req_int_count++;
 	}
 
-- 
2.34.1

