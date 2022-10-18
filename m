Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255E7603534
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 23:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJRVv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 17:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJRVvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 17:51:25 -0400
Received: from mail1.bemta33.messagelabs.com (mail1.bemta33.messagelabs.com [67.219.247.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A79C787A;
        Tue, 18 Oct 2022 14:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666129883; i=@motorola.com;
        bh=bO+t7UqaqxmwmRshsqfK3GUaZZgmxlkHrl4GFIHl+m0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=E8KVIrfs2WLt4NdbBdlWMqX90JZZU7oUlBjrgFQSaJPPRGmRD16ML/7FbiUJFMmwd
         ZJogW+YuK0VFl+MJh6y+Els9dy00fjPR6TdfwsW0U/3HCrdt/WlQk6h8bawRLhpswi
         78Lf+JHx8JUISKqGegWxwo38+kaL+maNWYrE+xfMEQEw0ZcS8ZdSgOn0prPWpfJmeU
         q+a9Usrm6e6ovviezHraZNCUsvGxvkUHFxIOemue8kr4SS7zxmih6YxQ9IDbRBAYlX
         NQPD4hNSixqSCANBMtGD3APFHCkzKqNcgWq8vxE6MJMtYr01jsTfJXCC/6SEBrEFtD
         Hk/yPQ6v6G0lw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleJIrShJLcpLzFFi42LJePFEXPemvH+
  ywetNxhbH2p6wWzw50M5o0btsD5tF8+L1bBadE5ewWyxsW8JicXnXHDaLRctamS22tF1hsvjx
  p4/ZYsHGR4wWqxYcYHfg8ZjdMZPVY9OqTjaP/XPXsHss7pvM6tH/18Bjy/7PjB6fN8kFsEexZ
  uYl5VcksGY8PptY0C9TcbnlEnsD42KJLkYuDiGBGUwSLRv2sEM465gk7m7+yNLFyMnBJqAmse
  D1KmYQW0RAVuLwld/MIEXMAg0sEpd7rgMVcXAIC8RLbNkkAFLDIqAqceZPDyuIzStgKdHyYDs
  jiC0hIC+x/+BZsDmcAlYSXQ/bwOYLAdU8br0CVS8ocXLmE7A4M1B989bZzBMYeWchSc1CklrA
  yLSK0aw4tagstUjXyEAvqSgzPaMkNzEzRy+xSjdRr7RYNzWxuETXSC+xvFgvtbhYr7gyNzknR
  S8vtWQTIzACUoocLHcwTlz2R+8QoyQHk5Io75xvfslCfEn5KZUZicUZ8UWlOanFhxhlODiUJH
  g5pfyThQSLUtNTK9Iyc4DRCJOW4OBREuFNkwFK8xYXJOYWZ6ZDpE4x2nOc37l/LzPH1Nn/9jN
  zLAeTM7+2HWAWYsnLz0uVEufllgVqEwBpyyjNgxsKSx6XGGWlhHkZGRgYhHgKUotyM0tQ5V8x
  inMwKgnzHgBZzpOZVwK3+xXQWUxAZ5lu8QM5qyQRISXVwNS/50VyWLZ1Ut+HADHvkIMtEYoTn
  73Zu+/9sbQgsczi5a+5Oyd6628x6wndtlyhOKg9sZbP/a05y4I9tUJSpzkuOxaftZF7n6OzNT
  Zmbl2ofbtSWUMDU0roYoWTjFv2HE8+JMym/S10wp038RJzONbwXnq7/XmJUaHTt6dHv8ziYUz
  49eZf04uWG+LvX4qIXdq5NnzlCbGJC9gtn1fsOLht6zKFbudbLF3tLPNPWb1rWbr3PnPYx7rO
  L5WGBpevynqoHQlfZr/mXPfUuN0M3Cu/zJ2c555jzB2zV0Fe4cMJ3eeJepsC9ut63F2kUHl+x
  6TXDQ/dy/LOrDV5JeJ5b9Kpe1vV8xQsk/U2s2xb9kSJpTgj0VCLuag4EQCoZ8qWmQMAAA==
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-12.tower-715.messagelabs.com!1666129881!57521!1
X-Originating-IP: [104.232.228.23]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.100.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 19892 invoked from network); 18 Oct 2022 21:51:21 -0000
Received: from unknown (HELO va32lpfpp03.lenovo.com) (104.232.228.23)
  by server-12.tower-715.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Oct 2022 21:51:21 -0000
Received: from va32lmmrp02.lenovo.com (va32lmmrp02.mot.com [10.62.176.191])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp03.lenovo.com (Postfix) with ESMTPS id 4MsSHF30MPz50WfM;
        Tue, 18 Oct 2022 21:51:21 +0000 (UTC)
Received: from p1g3.mot.com (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by va32lmmrp02.lenovo.com (Postfix) with ESMTPSA id 4MsSHF12rwzf6WS;
        Tue, 18 Oct 2022 21:51:21 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <qjv001@motorola.com>, stable@vger.kernel.org,
        Dan Vacura <w36195@motorola.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 2/6] usb: dwc3: gadget: cancel requests instead of release after missed isoc
Date:   Tue, 18 Oct 2022 16:50:38 -0500
Message-Id: <20221018215044.765044-3-w36195@motorola.com>
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

From: Jeff Vanhoof <qjv001@motorola.com>

arm-smmu related crashes seen after a Missed ISOC interrupt when
no_interrupt=1 is used. This can happen if the hardware is still using
the data associated with a TRB after the usb_request's ->complete call
has been made.  Instead of immediately releasing a request when a Missed
ISOC interrupt has occurred, this change will add logic to cancel the
request instead where it will eventually be released when the
END_TRANSFER command has completed. This logic is similar to some of the
cleanup done in dwc3_gadget_ep_dequeue.

Fixes: 6d8a019614f3 ("usb: dwc3: gadget: check for Missed Isoc from event status")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jeff Vanhoof <qjv001@motorola.com>
Co-developed-by: Dan Vacura <w36195@motorola.com>
Signed-off-by: Dan Vacura <w36195@motorola.com>
---
V1 -> V3:
- no change, new patch in series
V3 -> V4:
- no change

 drivers/usb/dwc3/core.h   |  1 +
 drivers/usb/dwc3/gadget.c | 38 ++++++++++++++++++++++++++------------
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 8f9959ba9fd4..9b005d912241 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -943,6 +943,7 @@ struct dwc3_request {
 #define DWC3_REQUEST_STATUS_DEQUEUED		3
 #define DWC3_REQUEST_STATUS_STALLED		4
 #define DWC3_REQUEST_STATUS_COMPLETED		5
+#define DWC3_REQUEST_STATUS_MISSED_ISOC		6
 #define DWC3_REQUEST_STATUS_UNKNOWN		-1
 
 	u8			epnum;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 079cd333632e..411532c5c378 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2021,6 +2021,9 @@ static void dwc3_gadget_ep_cleanup_cancelled_requests(struct dwc3_ep *dep)
 		case DWC3_REQUEST_STATUS_STALLED:
 			dwc3_gadget_giveback(dep, req, -EPIPE);
 			break;
+		case DWC3_REQUEST_STATUS_MISSED_ISOC:
+			dwc3_gadget_giveback(dep, req, -EXDEV);
+			break;
 		default:
 			dev_err(dwc->dev, "request cancelled with wrong reason:%d\n", req->status);
 			dwc3_gadget_giveback(dep, req, -ECONNRESET);
@@ -3402,21 +3405,32 @@ static bool dwc3_gadget_endpoint_trbs_complete(struct dwc3_ep *dep,
 	struct dwc3		*dwc = dep->dwc;
 	bool			no_started_trb = true;
 
-	dwc3_gadget_ep_cleanup_completed_requests(dep, event, status);
+	if (status == -EXDEV) {
+		struct dwc3_request *tmp;
+		struct dwc3_request *req;
 
-	if (dep->flags & DWC3_EP_END_TRANSFER_PENDING)
-		goto out;
+		if (!(dep->flags & DWC3_EP_END_TRANSFER_PENDING))
+			dwc3_stop_active_transfer(dep, true, true);
 
-	if (!dep->endpoint.desc)
-		return no_started_trb;
+		list_for_each_entry_safe(req, tmp, &dep->started_list, list)
+			dwc3_gadget_move_cancelled_request(req,
+					DWC3_REQUEST_STATUS_MISSED_ISOC);
+	} else {
+		dwc3_gadget_ep_cleanup_completed_requests(dep, event, status);
 
-	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
-		list_empty(&dep->started_list) &&
-		(list_empty(&dep->pending_list) || status == -EXDEV))
-		dwc3_stop_active_transfer(dep, true, true);
-	else if (dwc3_gadget_ep_should_continue(dep))
-		if (__dwc3_gadget_kick_transfer(dep) == 0)
-			no_started_trb = false;
+		if (dep->flags & DWC3_EP_END_TRANSFER_PENDING)
+			goto out;
+
+		if (!dep->endpoint.desc)
+			return no_started_trb;
+
+		if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
+			list_empty(&dep->started_list) && list_empty(&dep->pending_list))
+			dwc3_stop_active_transfer(dep, true, true);
+		else if (dwc3_gadget_ep_should_continue(dep))
+			if (__dwc3_gadget_kick_transfer(dep) == 0)
+				no_started_trb = false;
+	}
 
 out:
 	/*
-- 
2.34.1

