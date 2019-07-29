Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0507927E
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 19:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfG2Ros (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 13:44:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51061 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbfG2Ros (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 13:44:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D4BFA21CFD;
        Mon, 29 Jul 2019 13:44:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 13:44:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EYKA0M
        0ut2yAFEb09Top3hOuHFwSDYtEy4GMiIqoxSY=; b=dQMRT75KDmo/FLxV+kX0ZA
        uwNdMAYX5C9yaMKnmj9+VHjpY8GFBgU37MwMPcStaw0FqQ517/YA8Kqpu3YfzAWw
        CneUkgsXVSKPZosod1G3CUaTW/79d/B5ydBQomL4eSBrpeP42xMy8T9K20FeWYB+
        zkUcW9t8RxihACf6S+x8kv589f0PKI68eHANS2R5/lsT5E6Jbh0h2mM6hGc/lh/D
        mNOmItey6XRW9RtMX/2Ntdb4NF3cghDzbEK0iOwmogYDA6Q9/pYDMGVMVZQdWmQ8
        Ucewrx3mCKknfzWSxMhBIQDQIJDwY7jJKpvgiWWlHWnznWa0WsV6Z13GAzAVhKAA
        ==
X-ME-Sender: <xms:jjA_XfMxp8KBQ8MVzX7izXhJy-e1cC-GsmVgsj73LtZWL8eV13gVWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:jjA_XeOLOX_teZSz8QWRsrQSnYCHRqLJUP6H5pKpHdDMTnzkXffwDw>
    <xmx:jjA_XZRuHXCqScXmw6AO0OedfNJy6s2JLazWYmTmC7fwz3_Yrd4dHg>
    <xmx:jjA_XYAWUIXZUfDYjnVLutRDi5sQG4RieMoRkTX2L_XcUXTwS8aB0Q>
    <xmx:jjA_Xc9ehSqQp54W2HQjb0cUD7MzH1pLrR-R2C6BTO_Pw4ZGeu7nDg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 04C67380076;
        Mon, 29 Jul 2019 13:44:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over" failed to apply to 4.14-stable tree
To:     dan.j.williams@intel.com, jane.chu@oracle.com,
        stable@vger.kernel.org, vishal.l.verma@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jul 2019 19:44:44 +0200
Message-ID: <1564422284197134@kroah.com>
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

From b70d31d054ee3a6fc1034b9d7fc0ae1e481aa018 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jul 2019 18:08:15 -0700
Subject: [PATCH] libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over
 __nd_ioctl()

In preparation for fixing a deadlock between wait_for_bus_probe_idle()
and the nvdimm_bus_list_mutex arrange for __nd_ioctl() without
nvdimm_bus_list_mutex held. This also unifies the 'dimm' and 'bus' level
ioctls into a common nd_ioctl() preamble implementation.

Marked for -stable as it is a pre-requisite for a follow-on fix.

Cc: <stable@vger.kernel.org>
Fixes: bf9bccc14c05 ("libnvdimm: pmem label sets and namespace instantiation")
Cc: Vishal Verma <vishal.l.verma@intel.com>
Tested-by: Jane Chu <jane.chu@oracle.com>
Link: https://lore.kernel.org/r/156341209518.292348.7183897251740665198.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index a3180c28fb2b..a38572bf486b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -73,7 +73,7 @@ static void nvdimm_bus_probe_end(struct nvdimm_bus *nvdimm_bus)
 {
 	nvdimm_bus_lock(&nvdimm_bus->dev);
 	if (--nvdimm_bus->probe_active == 0)
-		wake_up(&nvdimm_bus->probe_wait);
+		wake_up(&nvdimm_bus->wait);
 	nvdimm_bus_unlock(&nvdimm_bus->dev);
 }
 
@@ -341,7 +341,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		return NULL;
 	INIT_LIST_HEAD(&nvdimm_bus->list);
 	INIT_LIST_HEAD(&nvdimm_bus->mapping_list);
-	init_waitqueue_head(&nvdimm_bus->probe_wait);
+	init_waitqueue_head(&nvdimm_bus->wait);
 	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	if (nvdimm_bus->id < 0) {
 		kfree(nvdimm_bus);
@@ -426,6 +426,9 @@ static int nd_bus_remove(struct device *dev)
 	list_del_init(&nvdimm_bus->list);
 	mutex_unlock(&nvdimm_bus_list_mutex);
 
+	wait_event(nvdimm_bus->wait,
+			atomic_read(&nvdimm_bus->ioctl_active) == 0);
+
 	nd_synchronize();
 	device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
 
@@ -885,7 +888,7 @@ void wait_nvdimm_bus_probe_idle(struct device *dev)
 		if (nvdimm_bus->probe_active == 0)
 			break;
 		nvdimm_bus_unlock(&nvdimm_bus->dev);
-		wait_event(nvdimm_bus->probe_wait,
+		wait_event(nvdimm_bus->wait,
 				nvdimm_bus->probe_active == 0);
 		nvdimm_bus_lock(&nvdimm_bus->dev);
 	} while (true);
@@ -1130,24 +1133,10 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	return rc;
 }
 
-static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	long id = (long) file->private_data;
-	int rc = -ENXIO, ro;
-	struct nvdimm_bus *nvdimm_bus;
-
-	ro = ((file->f_flags & O_ACCMODE) == O_RDONLY);
-	mutex_lock(&nvdimm_bus_list_mutex);
-	list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
-		if (nvdimm_bus->id == id) {
-			rc = __nd_ioctl(nvdimm_bus, NULL, ro, cmd, arg);
-			break;
-		}
-	}
-	mutex_unlock(&nvdimm_bus_list_mutex);
-
-	return rc;
-}
+enum nd_ioctl_mode {
+	BUS_IOCTL,
+	DIMM_IOCTL,
+};
 
 static int match_dimm(struct device *dev, void *data)
 {
@@ -1162,31 +1151,62 @@ static int match_dimm(struct device *dev, void *data)
 	return 0;
 }
 
-static long nvdimm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
+		enum nd_ioctl_mode mode)
+
 {
-	int rc = -ENXIO, ro;
-	struct nvdimm_bus *nvdimm_bus;
+	struct nvdimm_bus *nvdimm_bus, *found = NULL;
+	long id = (long) file->private_data;
+	struct nvdimm *nvdimm = NULL;
+	int rc, ro;
 
 	ro = ((file->f_flags & O_ACCMODE) == O_RDONLY);
 	mutex_lock(&nvdimm_bus_list_mutex);
 	list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
-		struct device *dev = device_find_child(&nvdimm_bus->dev,
-				file->private_data, match_dimm);
-		struct nvdimm *nvdimm;
-
-		if (!dev)
-			continue;
+		if (mode == DIMM_IOCTL) {
+			struct device *dev;
+
+			dev = device_find_child(&nvdimm_bus->dev,
+					file->private_data, match_dimm);
+			if (!dev)
+				continue;
+			nvdimm = to_nvdimm(dev);
+			found = nvdimm_bus;
+		} else if (nvdimm_bus->id == id) {
+			found = nvdimm_bus;
+		}
 
-		nvdimm = to_nvdimm(dev);
-		rc = __nd_ioctl(nvdimm_bus, nvdimm, ro, cmd, arg);
-		put_device(dev);
-		break;
+		if (found) {
+			atomic_inc(&nvdimm_bus->ioctl_active);
+			break;
+		}
 	}
 	mutex_unlock(&nvdimm_bus_list_mutex);
 
+	if (!found)
+		return -ENXIO;
+
+	nvdimm_bus = found;
+	rc = __nd_ioctl(nvdimm_bus, nvdimm, ro, cmd, arg);
+
+	if (nvdimm)
+		put_device(&nvdimm->dev);
+	if (atomic_dec_and_test(&nvdimm_bus->ioctl_active))
+		wake_up(&nvdimm_bus->wait);
+
 	return rc;
 }
 
+static long bus_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return nd_ioctl(file, cmd, arg, BUS_IOCTL);
+}
+
+static long dimm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return nd_ioctl(file, cmd, arg, DIMM_IOCTL);
+}
+
 static int nd_open(struct inode *inode, struct file *file)
 {
 	long minor = iminor(inode);
@@ -1198,16 +1218,16 @@ static int nd_open(struct inode *inode, struct file *file)
 static const struct file_operations nvdimm_bus_fops = {
 	.owner = THIS_MODULE,
 	.open = nd_open,
-	.unlocked_ioctl = nd_ioctl,
-	.compat_ioctl = nd_ioctl,
+	.unlocked_ioctl = bus_ioctl,
+	.compat_ioctl = bus_ioctl,
 	.llseek = noop_llseek,
 };
 
 static const struct file_operations nvdimm_fops = {
 	.owner = THIS_MODULE,
 	.open = nd_open,
-	.unlocked_ioctl = nvdimm_ioctl,
-	.compat_ioctl = nvdimm_ioctl,
+	.unlocked_ioctl = dimm_ioctl,
+	.compat_ioctl = dimm_ioctl,
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 391e88de3a29..6cd470547106 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -17,10 +17,11 @@ extern struct workqueue_struct *nvdimm_wq;
 
 struct nvdimm_bus {
 	struct nvdimm_bus_descriptor *nd_desc;
-	wait_queue_head_t probe_wait;
+	wait_queue_head_t wait;
 	struct list_head list;
 	struct device dev;
 	int id, probe_active;
+	atomic_t ioctl_active;
 	struct list_head mapping_list;
 	struct mutex reconfig_mutex;
 	struct badrange badrange;

