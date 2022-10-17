Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EAD601ABC
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 22:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiJQUze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 16:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiJQUzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 16:55:33 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46C46E8B2;
        Mon, 17 Oct 2022 13:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666040128; i=@motorola.com;
        bh=Ex2jg7i2bG94BEXDOq/m475Z4guiOCxEfIaotzGbp84=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=eK4yvnqPNqKzIF/2PxeF668O/IhpuwLYUVQFsXXIgtfskYjdCNovIx8A/HpHYnMGP
         rDPjSZ94qT2qJdKnfk+jnKxfkD+z40BqN1ae2cPGj1ws1Skc4VgnqlcmYv3CqpnXPN
         9lqhcwGkCZRgFuu9TlqVRiw2BQoquIoJPZ4oaGOTvMLNm4C94oi3Txq5tgUiU6eQMw
         43R4l6yd72fD5UJStN6PNWSLIOmIbNfhbrY6Snc3r+qjvaNj3ye2MaTRBJRbN9eKiF
         b8+i6t6XKTg538YgwSLlVVTS4JFue0II9QUphuC7FQN7KEpsE8u4v+XPJL7y9371lX
         1wgOT8pJ2I33Q==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleJIrShJLcpLzFFi42LJePFEVNf+oG+
  ywZJb3BbH2p6wWzw50M5o0btsD5tF8+L1bBadE5ewWyxsW8JicXnXHDaLRctamS22tF1hsvjx
  p4/ZYsHGR4wWqxYcYHfg8ZjdMZPVY9OqTjaP/XPXsHss7pvM6tH/18Bjy/7PjB6fN8kFsEexZ
  uYl5VcksGb8mDWRteCndEXf1xesDYyTJboYuTiEBKYySSz+tJ+li5ETyFnLJHF8nhCIzSagJr
  Hg9SpmEFtEQFbi8JXfzCANzAINLBKXe66DNQgLxEt8PNXNBGKzCKhKHF/2ix3E5hWwlFjztA+
  sWUJAXmL/wbNANgcHp4CVxIap6hC7LCU2H9jCClEuKHFy5hOwkcxA5c1bZzNPYOSdhSQ1C0lq
  ASPTKkbT4tSistQiXUO9pKLM9IyS3MTMHL3EKt1EvdJi3fLU4hJdI73E8mK91OJiveLK3OScF
  L281JJNjMDwTylKfb6D8e2SP3qHGCU5mJREeTtm+CYL8SXlp1RmJBZnxBeV5qQWH2KU4eBQku
  D9uQMoJ1iUmp5akZaZA4xFmLQEB4+SCG/nNqA0b3FBYm5xZjpE6hSjPcf5nfv3MnNMnf1vPzP
  HcjA582vbAWYhlrz8vFQpcd4f+4DaBEDaMkrz4IbCUsclRlkpYV5GBgYGIZ6C1KLczBJU+VeM
  4hyMSsK89/cDTeHJzCuB2/0K6CwmoLMy9nuBnFWSiJCSamA6c0y5Y26JxoE93dEq03yiGtwuP
  FNRWKIVZFTC7zHJ6DEHq0nu6ZfauVlsfuY9H6KYQ4TZXsbuOlSjrBvzfIXBhRUfNjB+Kr7EYs
  eRfpOtoXXCH74H4ScuT5v0sfLP2Xtf5bbuTXFmyLh1fPFenicz7rbODlmWNZ2h5YXC0qro6t4
  3D1/zTvZxfXInNFAh0tVjb/nekGvzpzx7nbViz25jmYXsMUcj3H+nMx060eyWt6U1bGPCuUzt
  IrNG+d0Wymqr9/3qsfKYsvqOsJ6ZkKhuw+cNPFmOfblH936e/17qtN0TY4tl6XWsJyzWKN94Y
  LxWKjH9cUrqHp97ScstOhi4Ki4vsZi3bsvs/Qs4pl1VYinOSDTUYi4qTgQAlmaWwpgDAAA=
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-12.tower-655.messagelabs.com!1666040126!107223!1
X-Originating-IP: [104.232.228.21]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 14467 invoked from network); 17 Oct 2022 20:55:27 -0000
Received: from unknown (HELO va32lpfpp01.lenovo.com) (104.232.228.21)
  by server-12.tower-655.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Oct 2022 20:55:27 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp01.lenovo.com (Postfix) with ESMTPS id 4Mrq5B0bKWzhSZf;
        Mon, 17 Oct 2022 20:55:26 +0000 (UTC)
Received: from p1g3.mot.com (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4Mrq596lv4zbpxx;
        Mon, 17 Oct 2022 20:55:25 +0000 (UTC)
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
Subject: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of release after missed isoc
Date:   Mon, 17 Oct 2022 15:54:40 -0500
Message-Id: <20221017205446.523796-3-w36195@motorola.com>
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

