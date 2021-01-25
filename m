Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338263032D9
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbhAZEi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:38:57 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:34005 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729384AbhAYOUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:20:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CCD7CE41;
        Mon, 25 Jan 2021 09:19:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:19:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XfrTMu
        SGiC+abEWvCctV1Q6GyWiBSdliD6ScDPOdk0w=; b=ABqpTGCH7r/a9+jWhq3EzU
        pDfqCjJB5uCmIc49Gh+pd0nXOt+mhgupNOQd9ixrymgNx/54SzuEIho9FedQtm3x
        rnHR6LoTlNtXIewitdc9iyEn7nrjOZ1Xh2xPZKa7exrQBBaE2oU4oJs4sEjX/Yb/
        NP/bZ72HMmSon0X80yY99JWHbQXMJylxJgQzN4xrsuBh+M1X5tF6kjK052QifOah
        aUnsGowiYRM4hPukOzta5fc2+Bsm4j+R/Pmpf3yaMG4nDhUC+AjdNJCpSiwhw4uA
        IwM/XhZl4dswuQDro0KDKvyOoGfpkHsyTubj92RPr5rSJb4SQASA6I8uRbu2gonQ
        ==
X-ME-Sender: <xms:itMOYPY7V-T2ebQig9bVbqCh6IwcSEK_P-kPasj2awtg_z8vCrrtvg>
    <xme:itMOYOanwXvPfbr_2Ro05b1hTzh5o5BKeRU1yMvNrnlnraQ3zST7RXRTLR5UiKCGv
    1h40iQ0kgCcGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:itMOYB95teGrL8TllQhSmSi0TgDO0mGdowBwozdDaw9_mrU1TfKGbg>
    <xmx:itMOYFrYjfTxzunrzsXh7QZP_jZleHdE9PGHeMMUUIXz3hXLunVKVQ>
    <xmx:itMOYKq-AUyBSEnh7ZHV0M2XKewFMtsM0La9MtFjbZXx4JKCSQQ7AA>
    <xmx:itMOYPDUAebfRFQRCJ_VxqI2zc-fgA4LRYOa6jTabDSkI8aeE045IqmPOAQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB697108005B;
        Mon, 25 Jan 2021 09:19:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: udc: core: Use lock when write to soft_connect" failed to apply to 4.4-stable tree
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:19:51 +0100
Message-ID: <1611584391127172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From c28095bc99073ddda65e4f31f6ae0d908d4d5cd8 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 14 Jan 2021 00:09:51 -0800
Subject: [PATCH] usb: udc: core: Use lock when write to soft_connect

Use lock to guard against concurrent access for soft-connect/disconnect
operations when writing to soft_connect sysfs.

Fixes: 2ccea03a8f7e ("usb: gadget: introduce UDC Class")
Cc: stable@vger.kernel.org
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/338ea01fbd69b1985ef58f0f59af02c805ddf189.1610611437.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 6a62bbd01324..ea114f922ccf 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1529,10 +1529,13 @@ static ssize_t soft_connect_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t n)
 {
 	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
+	ssize_t			ret;
 
+	mutex_lock(&udc_lock);
 	if (!udc->driver) {
 		dev_err(dev, "soft-connect without a gadget driver\n");
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 	if (sysfs_streq(buf, "connect")) {
@@ -1543,10 +1546,14 @@ static ssize_t soft_connect_store(struct device *dev,
 		usb_gadget_udc_stop(udc);
 	} else {
 		dev_err(dev, "unsupported command '%s'\n", buf);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
-	return n;
+	ret = n;
+out:
+	mutex_unlock(&udc_lock);
+	return ret;
 }
 static DEVICE_ATTR_WO(soft_connect);
 

