Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93B5100817
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfKRPX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:23:58 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53773 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726654AbfKRPX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 10:23:57 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 807DD22691;
        Mon, 18 Nov 2019 10:23:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Nov 2019 10:23:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=y29Gb7
        inFK6Ez7AQf6G35OR7Ig2mnfgFBs8gwOOma8s=; b=YBMv3E9u7JxDuIdiPhdfeA
        3DGi/Y6h2/4iXFE0wq0P+wWloBe8uQlxTkM2Pi+Ov+6Y1PjM+nkTDY4i5UEBrLqz
        bHwWjvqpXljKStCvBBvMWnU+m7dOem1z5XCkPUw3p1BUK7SBDVf7SV0W9UbpgcMX
        S8JKhZMkUKicA2JRrVfk/XuIbm7jc2+NmAsViO8TDG7SpkgDByLU7DO9fkfcvu0/
        2/JzgeY86znteFO2dgtA2eH6oUmbwwMeXht75OLGGys1+C7VpJVWOgKX2y80QkcK
        XuvO/vaRoleOQGEh3yREqKJXmOj2ngOD2eDZWXRDJlN2hqFzqb5+6+qPh2XstP8w
        ==
X-ME-Sender: <xms:jLfSXaSCeLtzOvSiZedFvSGsf6fDKxvg6_C2NUqtZthEok8WC8noHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudegiedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:jLfSXaSfmmknAZCZ6OlwGPz-ieOYCVTM8vsMhbNDwVPAF2qyxFWMYw>
    <xmx:jLfSXUzumIvdszKDnOC-I3XC7nu6XVKr08Iucx1XHXY6uNW9uaHIIA>
    <xmx:jLfSXYuFsofMonswmGhE0TPwCVzPCxYcF1vcfJ3ObnY_0qlnvXZwlw>
    <xmx:jLfSXUICJF_s1u6xEos_VTJf0NvDtfnbpa3eWdG6d_pb4n2cYMBYlA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D0A7A80061;
        Mon, 18 Nov 2019 10:23:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] IB/hfi1: Ensure full Gen3 speed in a Gen4 system" failed to apply to 4.4-stable tree
To:     james.erwin@intel.com, dennis.dalessandro@intel.com,
        jgg@mellanox.com, kaike.wan@intel.com, mike.marciniszyn@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 16:23:54 +0100
Message-ID: <157409063466132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a9c3c4c597704b3a1a2b9bef990e7d8a881f6533 Mon Sep 17 00:00:00 2001
From: James Erwin <james.erwin@intel.com>
Date: Fri, 1 Nov 2019 15:20:59 -0400
Subject: [PATCH] IB/hfi1: Ensure full Gen3 speed in a Gen4 system

If an hfi1 card is inserted in a Gen4 systems, the driver will avoid the
gen3 speed bump and the card will operate at half speed.

This is because the driver avoids the gen3 speed bump when the parent bus
speed isn't identical to gen3, 8.0GT/s.  This is not compatible with gen4
and newer speeds.

Fix by relaxing the test to explicitly look for the lower capability
speeds which inherently allows for gen4 and all future speeds.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20191101192059.106248.1699.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: James Erwin <james.erwin@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 61aa5504d7c3..61362bd6d3ce 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -319,7 +319,9 @@ int pcie_speeds(struct hfi1_devdata *dd)
 	/*
 	 * bus->max_bus_speed is set from the bridge's linkcap Max Link Speed
 	 */
-	if (parent && dd->pcidev->bus->max_bus_speed != PCIE_SPEED_8_0GT) {
+	if (parent &&
+	    (dd->pcidev->bus->max_bus_speed == PCIE_SPEED_2_5GT ||
+	     dd->pcidev->bus->max_bus_speed == PCIE_SPEED_5_0GT)) {
 		dd_dev_info(dd, "Parent PCIe bridge does not support Gen3\n");
 		dd->link_gen3_capable = 0;
 	}

