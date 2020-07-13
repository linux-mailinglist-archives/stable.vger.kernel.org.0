Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E314521D934
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 16:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgGMOv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 10:51:28 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:42671 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730388AbgGMOvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 10:51:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 05B66422;
        Mon, 13 Jul 2020 10:51:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 13 Jul 2020 10:51:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=W68umG
        F3iJU67JPQDWAheHTxnFg6hgLtqz7GYBp3g80=; b=D1rPdoWlTjSOPaXgVAgTG2
        BnPuMkq5kB8FddIp2IbAa5fwlrUNYtaydwYEKd0pfgXwVKdfJxhIF51bluyEbRp1
        GsKsqlrd2R7J8Edv8S7z2SOlsnJ1tDUP6DMbi8yirdKXc/LVm+m7eqtSVkmFr7Qu
        58/i3rGZ618wQ0Tefz9nNHHUn5UM+RdHxfbVGeXDPPhrBCwRw/FBe7xd8z7qhsH0
        m5wZFSO25+zP5WEUcsWbj2BnxS1HJ4+unvRENuYOKm6j/Cw/YQIjbDfcY74PbiYZ
        w+se/fLejcIqua47TqsMGOi1pCeXPZvV5YfG0SjTy0JqFCYbuOVaCcMtBVGJrpRA
        ==
X-ME-Sender: <xms:63QMX_89XPIv_wvmWq8G7lYEz37kPQ9VvK9LOAeub0_c-hcoX9BfVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvdekgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:63QMX7ubA6LZ6e_34I7AEGMOiHKURH4REbPcUTzlF8H5GP5bdy8yQw>
    <xmx:63QMX9CoN-swWDkEQWcsy8rsh1fe5GVEAQvFtUVGkpD73AsLUmuoSQ>
    <xmx:63QMX7csAW0DWvVfAAyXqvhpPINCfhleZVp37P92wpk5j8Z5k_CSmg>
    <xmx:63QMX-13tgKHgSU4W5E8EmbPcXPpcXU3b0qPIvhRJa6I-JTWCtTpghDJAGA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4424D3280064;
        Mon, 13 Jul 2020 10:51:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1: Do not destroy link_wq when the device is shut down" failed to apply to 4.14-stable tree
To:     kaike.wan@intel.com, dennis.dalessandro@intel.com, jgg@nvidia.com,
        mike.marciniszyn@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jul 2020 16:51:16 +0200
Message-ID: <159465187633180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2315ec12ee8e8257bb335654c62e0cae71dc278d Mon Sep 17 00:00:00 2001
From: Kaike Wan <kaike.wan@intel.com>
Date: Tue, 23 Jun 2020 16:40:53 -0400
Subject: [PATCH] IB/hfi1: Do not destroy link_wq when the device is shut down

The workqueue link_wq should only be destroyed when the hfi1 driver is
unloaded, not when the device is shut down.

Fixes: 71d47008ca1b ("IB/hfi1: Create workqueue for link events")
Link: https://lore.kernel.org/r/20200623204053.107638.70315.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 16d6788075f3..cb7ad1288821 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -846,6 +846,10 @@ static void destroy_workqueues(struct hfi1_devdata *dd)
 			destroy_workqueue(ppd->hfi1_wq);
 			ppd->hfi1_wq = NULL;
 		}
+		if (ppd->link_wq) {
+			destroy_workqueue(ppd->link_wq);
+			ppd->link_wq = NULL;
+		}
 	}
 }
 
@@ -1122,14 +1126,10 @@ static void shutdown_device(struct hfi1_devdata *dd)
 		 * We can't count on interrupts since we are stopping.
 		 */
 		hfi1_quiet_serdes(ppd);
-
 		if (ppd->hfi1_wq)
 			flush_workqueue(ppd->hfi1_wq);
-		if (ppd->link_wq) {
+		if (ppd->link_wq)
 			flush_workqueue(ppd->link_wq);
-			destroy_workqueue(ppd->link_wq);
-			ppd->link_wq = NULL;
-		}
 	}
 	sdma_exit(dd);
 }

