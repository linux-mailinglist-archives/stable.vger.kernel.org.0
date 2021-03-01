Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A16D327F7A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhCAN2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:28:13 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:53697 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235736AbhCAN2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:28:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 59E8A1941D78;
        Mon,  1 Mar 2021 08:27:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:27:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eDPr12
        zImi4Hvfn/tFbrpjWbqg4NnX+YuT9nAx4neLI=; b=m2QmIkqJqoFOil7Cd8OgeK
        qemYv034yAyNxXnVlDLErDexnmKOsudp+1AyVlsTajZyMiqvtAEgFPCfyjL8/Z1D
        MynbmpwIW3Aumjgb2wujsazTSL9HyNsG1O7M7dZCkLz25EZTxY/+xLYTV0ozvqxz
        oqCVuMTo6nDT66MdybCIFKAafxhChvzcQakO/KhL2zmMpv1CvV2tUoB+LnaYoGBJ
        X4DIJgKH6UeBNIhgQ/SfB3UyTvVuzTICae9OlAM9Y9SyFKY6DwIXVoa+jXIUN5aP
        3y52cWe04W+RCxEcpHhBqp/XRHStvPDUhpMXS/XNPdCbBOeDqN+d9e/Gj6dbhtSw
        ==
X-ME-Sender: <xms:tes8YAKD-_Dps8EzwJIQMzicMzS75P-wEJJ7uN7xGmuIDrdlNv83mA>
    <xme:tes8YFFJLyLXudjdfVCN559rmdVdxfa-LRogPI8S6qQwjSoSbevdOGOVg3muq3ZcW
    iupWD4O0eqhGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:tes8YE8tLWC3puYUVwc1dOA1VeEOvZwTqjVHq1AXTouBpoC8gdsawg>
    <xmx:tes8YNL6ZuJKZJZLtHspRlQtPzOt31YIBHujq3kJFt-30q3Clop5tw>
    <xmx:tes8YKtz0AmpIRMrjPpB6zLgFfTgALo5-CMhPe8tp3VDwMMGY84Zrg>
    <xmx:tes8YO_sQ8hiRG8jJvyrChKzwM7gJSGwvICuw6NyOncnrq2fKy8SKA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B171B1080063;
        Mon,  1 Mar 2021 08:27:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] mei: bus: block send with vtag on non-conformat FW" failed to apply to 5.10-stable tree
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:27:14 +0100
Message-ID: <16146052346243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b398d53cd421454d64850f8b1f6d609ede9042d9 Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Mon, 8 Feb 2021 17:06:48 +0200
Subject: [PATCH] mei: bus: block send with vtag on non-conformat FW

Block data send with vtag if either transport layer or
FW client are not supporting vtags.

Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210208150649.141358-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 580074e32599..935acc6bbf3c 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -61,6 +61,13 @@ ssize_t __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length, u8 vtag,
 		goto out;
 	}
 
+	if (vtag) {
+		/* Check if vtag is supported by client */
+		rets = mei_cl_vt_support_check(cl);
+		if (rets)
+			goto out;
+	}
+
 	if (length > mei_cl_mtu(cl)) {
 		rets = -EFBIG;
 		goto out;

