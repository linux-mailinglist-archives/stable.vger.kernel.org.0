Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1010312EE6
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhBHKYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:24:11 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:55633 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232183AbhBHKWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:22:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0040FA68;
        Mon,  8 Feb 2021 05:21:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:21:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=i3NIgq
        s3POWFDhk2iU/rRSh9WjzSAlZPqkGYoYmz9bs=; b=fmawk2D+GlaaOMSrC1ubDN
        bwRb1ONokKDnoTJWyYmp+WpcjlFtAGAtQaDDDugE8KqQ6jlLkpqTATqAZ36FpSlS
        PEEdA6HJfmNwn8MtVD0unO3iI7ZMSQKEScq6fXmDLhPk/r5PruX03RdKkx0jmZGi
        uNITmay28Liawypk1nGsFxVL/PHMKZ2iLqBD6HXq09NRp3UwxUukqA7sdnFRUysy
        wAPjWb99ilegTBERWOxVXS0I8lFmIHKKBoFbumeqd+6/wN0meE72L4Bj1qrKC/2z
        eZKfj2gsBmsavwc5cqx7OTE4cexc4FkXHwkMFYfRZDzdoHGbzIUEunQQoV4uJ76Q
        ==
X-ME-Sender: <xms:jBAhYCQEZBbzlqiyHJNDP2766JRVYBNDBSgzDeoxPN8A5dTOXZHRnQ>
    <xme:jBAhYHw3dLUxv9CWSRjeACoqJu3_jZY6dAnYNByazineETekGzh_PspDfCkSYe7mH
    X8RS9FGlUKHyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:jBAhYP1fBVLhSXf95puFXmHNzRARDl1DjlDzInRbF6jDwSOeCRVrtw>
    <xmx:jBAhYOCYpujUNAamqtJ_UXaA8yr2yOcRMOvy7irG2gRmqV2s_glDyQ>
    <xmx:jBAhYLgbDCcKv-WFR4ruyFRYtj9mjefxYNygp6AYYEox0IjApEZb-A>
    <xmx:jBAhYLdeX0BxwVujQZ6N1ATxzCnGupo3yNcFWt06Sw4rzB8fpK6coxFp7wo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B0221080064;
        Mon,  8 Feb 2021 05:21:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] libnvdimm/dimm: Avoid race between probe and" failed to apply to 4.4-stable tree
To:     dan.j.williams@intel.com, colyli@suse.com, dave.jiang@intel.com,
        ira.weiny@intel.com, rpalethorpe@suse.com, stable@vger.kernel.org,
        vishal.l.verma@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:20:58 +0100
Message-ID: <1612779658250221@kroah.com>
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

