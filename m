Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3190E312EEB
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhBHKYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:24:41 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52215 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232214AbhBHKWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:22:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3DF51A2E;
        Mon,  8 Feb 2021 05:21:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:21:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5H/lYS
        WQWDj1QwvnPkRER8mfJiCRh3ZaOLf2FOiHETA=; b=lMy1KYloOkp0rwe+hO8eAW
        ppmrvoPyvYhmR7bISF7JNnVucYutfYGclPNXxVs5SIxjOMpEuR/CO4cslv57Armu
        a46jOqE6ot+CazgKoZAzIGmbqmVsGUV+zFWDMdq7N3Bio8A7dBLmQq8j7qrVlCRn
        M6qn4scdGafb+acHtl/rbpuptueEo/UKMT8XxxIE0FkoDHuokJ+1vVE1uQ15Ag5H
        ueGnhgaLWclWM8ub5lRfcL+QuHfJo+H+lnulrYrNbGHUlaBTW3AAVqGURUNIMGhF
        QSWgkHHG+KbVLpWAc2/n046qEbE0zBgWIHN1kcpC5S7nJhyA7zO/PtV/D/6LTcXQ
        ==
X-ME-Sender: <xms:vRAhYIitNb5EeP0wr3mFWLhjRvPiT-bf1UC2ZZAi3kLnMyxZzt9fnw>
    <xme:vRAhYBAvGWjHeLb_iQmqGBW4zwDggSp71yCE7xyStAVAp5Hb5bqPyq2ktAJRsXUUE
    YgngpPkZrTUiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:vRAhYAHCIS3LlsoS0jQmcH6PDXSP_-98E3juFMqiEDNXxBfVyX4ntw>
    <xmx:vRAhYJTse4f98nJaB19_0Fux8dDp6nJD-4sSFoQsMBbBwdUAEMAjWg>
    <xmx:vRAhYFx3BLPdi96dHn5bzfXbrFzet72yWOhNGURZJ5g5LsmvmLqsEw>
    <xmx:vRAhYHthUZGOxJwuG2Y7uefOWt8z19F5j3cORmMtm-yT-zNbCCuNm6UTqiw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 724A8108005C;
        Mon,  8 Feb 2021 05:21:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] libnvdimm/dimm: Avoid race between probe and" failed to apply to 4.14-stable tree
To:     dan.j.williams@intel.com, colyli@suse.com, dave.jiang@intel.com,
        ira.weiny@intel.com, rpalethorpe@suse.com, stable@vger.kernel.org,
        vishal.l.verma@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:21:48 +0100
Message-ID: <16127797084064@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 7018c897c2f243d4b5f1b94bc6b4831a7eab80fb Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 Feb 2021 16:20:40 -0800
Subject: [PATCH] libnvdimm/dimm: Avoid race between probe and
 available_slots_show()

Richard reports that the following test:

(while true; do
     cat /sys/bus/nd/devices/nmem*/available_slots 2>&1 > /dev/null
 done) &

while true; do
     for i in $(seq 0 4); do
         echo nmem$i > /sys/bus/nd/drivers/nvdimm/bind
     done
     for i in $(seq 0 4); do
         echo nmem$i > /sys/bus/nd/drivers/nvdimm/unbind
     done
 done

...fails with a crash signature like:

    divide error: 0000 [#1] SMP KASAN PTI
    RIP: 0010:nd_label_nfree+0x134/0x1a0 [libnvdimm]
    [..]
    Call Trace:
     available_slots_show+0x4e/0x120 [libnvdimm]
     dev_attr_show+0x42/0x80
     ? memset+0x20/0x40
     sysfs_kf_seq_show+0x218/0x410

The root cause is that available_slots_show() consults driver-data, but
fails to synchronize against device-unbind setting up a TOCTOU race to
access uninitialized memory.

Validate driver-data under the device-lock.

Fixes: 4d88a97aa9e8 ("libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver infrastructure")
Cc: <stable@vger.kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Coly Li <colyli@suse.com>
Reported-by: Richard Palethorpe <rpalethorpe@suse.com>
Acked-by: Richard Palethorpe <rpalethorpe@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index b59032e0859b..9d208570d059 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -335,16 +335,16 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(state);
 
-static ssize_t available_slots_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t __available_slots_show(struct nvdimm_drvdata *ndd, char *buf)
 {
-	struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
+	struct device *dev;
 	ssize_t rc;
 	u32 nfree;
 
 	if (!ndd)
 		return -ENXIO;
 
+	dev = ndd->dev;
 	nvdimm_bus_lock(dev);
 	nfree = nd_label_nfree(ndd);
 	if (nfree - 1 > nfree) {
@@ -356,6 +356,18 @@ static ssize_t available_slots_show(struct device *dev,
 	nvdimm_bus_unlock(dev);
 	return rc;
 }
+
+static ssize_t available_slots_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	ssize_t rc;
+
+	nd_device_lock(dev);
+	rc = __available_slots_show(dev_get_drvdata(dev), buf);
+	nd_device_unlock(dev);
+
+	return rc;
+}
 static DEVICE_ATTR_RO(available_slots);
 
 __weak ssize_t security_show(struct device *dev,

