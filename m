Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759622F0E5B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbhAKImC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:42:02 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:38831 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727716AbhAKImC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:42:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6C07D2217;
        Mon, 11 Jan 2021 03:41:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:41:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=51jXb6
        DtD8k85spZU8zpTIifOtGgWr0wXUFnbaymzic=; b=YrM5Hd0SBfhJ4UH1SQjVzc
        QDa7OcOBN/g6UpaFH7VdNiSh2akewwPMPRBfvBWGIN0rJZWDwq//7rEXV5MHU+tW
        eToj3kgejRunLUIKz5N2Djjf0chmthkbC2JCKJvO2gfDDg5UUkDHX3NHSQp+Dx/7
        xFsdFtQRzG7FfnhvsN2MNiSW1OTLJg3hXyQdTiWNfdEcY0PyKRzxMziVptGmtNVt
        8RiA31L9bWCvVqEaFl2wFZHqoLjCSxxw+3Xqxd/LJW0qgpotrhVrV2j3Uqmj9Haf
        A0HuViI3ywx8BzfJXFR3/mgmjo/4XB37IPJN8RF9bXHsTyQcNoNy1lFYJEgGGQkA
        ==
X-ME-Sender: <xms:Kw_8X3CpHIdi8Ro6G778EXNZ4ODHHv2MtRHjhiHaL-ccKlfNOzL5ug>
    <xme:Kw_8X9jgpOKSS22byxT20Z_49mWQQ70oGXs0yEBdNZ-JXggiU2_6uoXe3NSAyBRJq
    U9rPRaMTaSlyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Kw_8XykktjCyOs4JKJbnh4Wjus1xHWhfZlet8GqcpUS6rH2BO_NMyQ>
    <xmx:Kw_8X5ynuYokfYnh4JxhpjKGLgpD2ooOUtt-qG7_7SFDscnxO37EiA>
    <xmx:Kw_8X8RJtuWanZMOXwECTMj54_dFGOX_vD1Kg1T-RZGtMQZLR2kC1A>
    <xmx:LA_8X149KkFe25F5RMIdzqM_O2TsBGFiP_yeg4RIZLxfT1W5UqZ3sLyZ0ww>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5D34240062;
        Mon, 11 Jan 2021 03:41:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] USB: Gadget: dummy-hcd: Fix shift-out-of-bounds bug" failed to apply to 5.4-stable tree
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:42:28 +0100
Message-ID: <161035454814081@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c318840fb2a42ce25febc95c4c19357acf1ae5ca Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 30 Dec 2020 11:20:44 -0500
Subject: [PATCH] USB: Gadget: dummy-hcd: Fix shift-out-of-bounds bug

The dummy-hcd driver was written under the assumption that all the
parameters in URBs sent to its root hub would be valid.  With URBs
sent from userspace via usbfs, that assumption can be violated.

In particular, the driver doesn't fully check the port-feature values
stored in the wValue entry of Clear-Port-Feature and Set-Port-Feature
requests.  Values that are too large can cause the driver to perform
an invalid left shift of more than 32 bits.  Ironically, two of those
left shifts are unnecessary, because they implement Set-Port-Feature
requests that hubs are not required to support, according to section
11.24.2.13 of the USB-2.0 spec.

This patch adds the appropriate checks for the port feature selector
values and removes the unnecessary feature settings.  It also rejects
requests to set the TEST feature or to set or clear the INDICATOR and
C_OVERCURRENT features, as none of these are relevant to dummy-hcd's
root-hub emulation.

CC: <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+5925509f78293baa7331@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20201230162044.GA727759@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index ab5e978b5052..1a953f44183a 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -2118,9 +2118,21 @@ static int dummy_hub_control(
 				dum_hcd->port_status &= ~USB_PORT_STAT_POWER;
 			set_link_state(dum_hcd);
 			break;
-		default:
+		case USB_PORT_FEAT_ENABLE:
+		case USB_PORT_FEAT_C_ENABLE:
+		case USB_PORT_FEAT_C_SUSPEND:
+			/* Not allowed for USB-3 */
+			if (hcd->speed == HCD_USB3)
+				goto error;
+			fallthrough;
+		case USB_PORT_FEAT_C_CONNECTION:
+		case USB_PORT_FEAT_C_RESET:
 			dum_hcd->port_status &= ~(1 << wValue);
 			set_link_state(dum_hcd);
+			break;
+		default:
+		/* Disallow INDICATOR and C_OVER_CURRENT */
+			goto error;
 		}
 		break;
 	case GetHubDescriptor:
@@ -2281,18 +2293,17 @@ static int dummy_hub_control(
 			 */
 			dum_hcd->re_timeout = jiffies + msecs_to_jiffies(50);
 			fallthrough;
+		case USB_PORT_FEAT_C_CONNECTION:
+		case USB_PORT_FEAT_C_RESET:
+		case USB_PORT_FEAT_C_ENABLE:
+		case USB_PORT_FEAT_C_SUSPEND:
+			/* Not allowed for USB-3, and ignored for USB-2 */
+			if (hcd->speed == HCD_USB3)
+				goto error;
+			break;
 		default:
-			if (hcd->speed == HCD_USB3) {
-				if ((dum_hcd->port_status &
-				     USB_SS_PORT_STAT_POWER) != 0) {
-					dum_hcd->port_status |= (1 << wValue);
-				}
-			} else
-				if ((dum_hcd->port_status &
-				     USB_PORT_STAT_POWER) != 0) {
-					dum_hcd->port_status |= (1 << wValue);
-				}
-			set_link_state(dum_hcd);
+		/* Disallow TEST, INDICATOR, and C_OVER_CURRENT */
+			goto error;
 		}
 		break;
 	case GetPortErrorCount:

