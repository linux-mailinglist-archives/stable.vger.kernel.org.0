Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABA6225E3A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgGTMOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:14:22 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:59029 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728609AbgGTMOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:14:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 904A419410AB;
        Mon, 20 Jul 2020 08:14:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:14:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZdK8lM
        BzRS4Szau0Q0onYNSrJ0bguwKAdqY8r23aVQI=; b=RZ0s+I/RrXZGW6s9et70Iw
        47+N1gVnIhNfT7VHPoEnMQEas65Co10WAADxJ6ypCyfwNRrPoCoOXxNKFY5alRqv
        MsC9FD94ma09vWOZI3qGfC665k/eMzRRRPGUzIfaVAZ7VpKSuWw0lt74LqI6kIvw
        954pErOYxVwZ+6CHw59Alg4XsjrP+F3mJOVOQlYx+O+A0iq9XHtX6Da1FRPRYdWV
        gAu8407k5LXuvu8Pp4EXxt3ZxScdBFkKMklVm5tBkcIXWsmXzoQbCRnFoOlaoge9
        Di6WF5SUJY1R1QtHOKKHcapyunf5NFpOVQkuVQd29+5MlcRVzEAPEiHOr068x2Yg
        ==
X-ME-Sender: <xms:mooVX6IZ7KYte9pQFCuBI-V_eL9576hQ3DfNGi3eS-LagbXPzwqbtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedvvdeiveekueevvedtteeuheejgfffjeehhfejieeiff
    dvueeifffhieelhfetudenucffohhmrghinhepihhnthgvlhdrtghomhenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:mooVXyKS3JaePPNuR9UhE3Fe8gObDjwDCp99LaxteJLpxqvOuErcuA>
    <xmx:mooVX6sc7ZFtqI7tKREWog8sK6Ud0oIXJ_P7jEBv-g3WYZr11Px4tg>
    <xmx:mooVX_ZCPiY3AAgtKVAWreUsIuvT3V7Gq4i7enijCMy_YR_cuGc_Uw>
    <xmx:mooVXz0n4B1wPtDy65YXLchieNiHCCqD9tRizMloKflKZ5ZTqK_UxA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E76893280064;
        Mon, 20 Jul 2020 08:14:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] intel_th: Add driver infrastructure for Intel(R) Trace Hub" failed to apply to 4.9-stable tree
To:     alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:14:20 +0200
Message-ID: <15952472606013@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 39f4034693b7c7bd1fe4cb58c93259d600f55561 Mon Sep 17 00:00:00 2001
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Date: Tue, 22 Sep 2015 15:47:14 +0300
Subject: [PATCH] intel_th: Add driver infrastructure for Intel(R) Trace Hub
 devices

Intel(R) Trace Hub (TH) is a set of hardware blocks (subdevices) that
produce, switch and output trace data from multiple hardware and
software sources over several types of trace output ports encoded
in System Trace Protocol (MIPI STPv2) and is intended to perform
full system debugging.

For these subdevices, we create a bus, where they can be discovered
and configured by userspace software.

This patch creates this bus infrastructure, three types of devices
(source, output, switch), resource allocation, some callback mechanisms
to facilitate communication between the subdevices' drivers and some
common sysfs attributes.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/Documentation/ABI/testing/sysfs-bus-intel_th-output-devices b/Documentation/ABI/testing/sysfs-bus-intel_th-output-devices
new file mode 100644
index 000000000000..4d48a9451866
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-intel_th-output-devices
@@ -0,0 +1,13 @@
+What:		/sys/bus/intel_th/devices/<intel_th_id>-<device><id>/active
+Date:		June 2015
+KernelVersion:	4.3
+Contact:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
+Description:	(RW) Writes of 1 or 0 enable or disable trace output to this
+		output device. Reads return current status.
+
+What:		/sys/bus/intel_th/devices/<intel_th_id>-msc<msc-id>/port
+Date:		June 2015
+KernelVersion:	4.3
+Contact:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
+Description:	(RO) Port number, corresponding to this output device on the
+		switch (GTH).
diff --git a/Documentation/trace/intel_th.txt b/Documentation/trace/intel_th.txt
new file mode 100644
index 000000000000..f7fc5ba5df8d
--- /dev/null
+++ b/Documentation/trace/intel_th.txt
@@ -0,0 +1,99 @@
+Intel(R) Trace Hub (TH)
+=======================
+
+Overview
+--------
+
+Intel(R) Trace Hub (TH) is a set of hardware blocks that produce,
+switch and output trace data from multiple hardware and software
+sources over several types of trace output ports encoded in System
+Trace Protocol (MIPI STPv2) and is intended to perform full system
+debugging. For more information on the hardware, see Intel(R) Trace
+Hub developer's manual [1].
+
+It consists of trace sources, trace destinations (outputs) and a
+switch (Global Trace Hub, GTH). These devices are placed on a bus of
+their own ("intel_th"), where they can be discovered and configured
+via sysfs attributes.
+
+Currently, the following Intel TH subdevices (blocks) are supported:
+  - Software Trace Hub (STH), trace source, which is a System Trace
+  Module (STM) device,
+  - Memory Storage Unit (MSU), trace output, which allows storing
+  trace hub output in system memory,
+  - Parallel Trace Interface output (PTI), trace output to an external
+  debug host via a PTI port,
+  - Global Trace Hub (GTH), which is a switch and a central component
+  of Intel(R) Trace Hub architecture.
+
+Common attributes for output devices are described in
+Documentation/ABI/testing/sysfs-bus-intel_th-output-devices, the most
+notable of them is "active", which enables or disables trace output
+into that particular output device.
+
+GTH allows directing different STP masters into different output ports
+via its "masters" attribute group. More detailed GTH interface
+description is at Documentation/ABI/testing/sysfs-bus-intel_th-devices-gth.
+
+STH registers an stm class device, through which it provides interface
+to userspace and kernelspace software trace sources. See
+Documentation/tracing/stm.txt for more information on that.
+
+MSU can be configured to collect trace data into a system memory
+buffer, which can later on be read from its device nodes via read() or
+mmap() interface.
+
+On the whole, Intel(R) Trace Hub does not require any special
+userspace software to function; everything can be configured, started
+and collected via sysfs attributes, and device nodes.
+
+[1] https://software.intel.com/sites/default/files/managed/d3/3c/intel-th-developer-manual.pdf
+
+Bus and Subdevices
+------------------
+
+For each Intel TH device in the system a bus of its own is
+created and assigned an id number that reflects the order in which TH
+devices were emumerated. All TH subdevices (devices on intel_th bus)
+begin with this id: 0-gth, 0-msc0, 0-msc1, 0-pti, 0-sth, which is
+followed by device's name and an optional index.
+
+Output devices also get a device node in /dev/intel_thN, where N is
+the Intel TH device id. For example, MSU's memory buffers, when
+allocated, are accessible via /dev/intel_th0/msc{0,1}.
+
+Quick example
+-------------
+
+# figure out which GTH port is the first memory controller:
+
+$ cat /sys/bus/intel_th/devices/0-msc0/port
+0
+
+# looks like it's port 0, configure master 33 to send data to port 0:
+
+$ echo 0 > /sys/bus/intel_th/devices/0-gth/masters/33
+
+# allocate a 2-windowed multiblock buffer on the first memory
+# controller, each with 64 pages:
+
+$ echo multi > /sys/bus/intel_th/devices/0-msc0/mode
+$ echo 64,64 > /sys/bus/intel_th/devices/0-msc0/nr_pages
+
+# enable wrapping for this controller, too:
+
+$ echo 1 > /sys/bus/intel_th/devices/0-msc0/wrap
+
+# and enable tracing into this port:
+
+$ echo 1 > /sys/bus/intel_th/devices/0-msc0/active
+
+# .. send data to master 33, see stm.txt for more details ..
+# .. wait for traces to pile up ..
+# .. and stop the trace:
+
+$ echo 0 > /sys/bus/intel_th/devices/0-msc0/active
+
+# and now you can collect the trace from the device node:
+
+$ cat /dev/intel_th0/msc0 > my_stp_trace
diff --git a/drivers/Kconfig b/drivers/Kconfig
index b6e1cea63f81..709488ae882e 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -190,4 +190,6 @@ source "drivers/nvmem/Kconfig"
 
 source "drivers/hwtracing/stm/Kconfig"
 
+source "drivers/hwtracing/intel_th/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index e71b5e2a2c71..e63542dd7010 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -165,6 +165,7 @@ obj-$(CONFIG_PERF_EVENTS)	+= perf/
 obj-$(CONFIG_RAS)		+= ras/
 obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
 obj-$(CONFIG_CORESIGHT)		+= hwtracing/coresight/
+obj-y				+= hwtracing/intel_th/
 obj-$(CONFIG_STM)		+= hwtracing/stm/
 obj-$(CONFIG_ANDROID)		+= android/
 obj-$(CONFIG_NVMEM)		+= nvmem/
diff --git a/drivers/hwtracing/intel_th/Kconfig b/drivers/hwtracing/intel_th/Kconfig
new file mode 100644
index 000000000000..0cb01ee9090e
--- /dev/null
+++ b/drivers/hwtracing/intel_th/Kconfig
@@ -0,0 +1,24 @@
+config INTEL_TH
+	tristate "Intel(R) Trace Hub controller"
+	help
+	  Intel(R) Trace Hub (TH) is a set of hardware blocks (subdevices) that
+	  produce, switch and output trace data from multiple hardware and
+	  software sources over several types of trace output ports encoded
+	  in System Trace Protocol (MIPI STPv2) and is intended to perform
+	  full system debugging.
+
+	  This option enables intel_th bus and common code used by TH
+	  subdevices to interact with each other and hardware and for
+	  platform glue layers to drive Intel TH devices.
+
+	  Say Y here to enable Intel(R) Trace Hub controller support.
+
+if INTEL_TH
+
+config INTEL_TH_DEBUG
+	bool "Intel(R) Trace Hub debugging"
+	depends on DEBUG_FS
+	help
+	  Say Y here to enable debugging.
+
+endif
diff --git a/drivers/hwtracing/intel_th/Makefile b/drivers/hwtracing/intel_th/Makefile
new file mode 100644
index 000000000000..dfd7906462da
--- /dev/null
+++ b/drivers/hwtracing/intel_th/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_INTEL_TH)		+= intel_th.o
+intel_th-y			:= core.o
+intel_th-$(CONFIG_INTEL_TH_DEBUG) += debug.o
diff --git a/drivers/hwtracing/intel_th/core.c b/drivers/hwtracing/intel_th/core.c
new file mode 100644
index 000000000000..165d3001c301
--- /dev/null
+++ b/drivers/hwtracing/intel_th/core.c
@@ -0,0 +1,692 @@
+/*
+ * Intel(R) Trace Hub driver core
+ *
+ * Copyright (C) 2014-2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/sysfs.h>
+#include <linux/kdev_t.h>
+#include <linux/debugfs.h>
+#include <linux/idr.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+
+#include "intel_th.h"
+#include "debug.h"
+
+static DEFINE_IDA(intel_th_ida);
+
+static int intel_th_match(struct device *dev, struct device_driver *driver)
+{
+	struct intel_th_driver *thdrv = to_intel_th_driver(driver);
+	struct intel_th_device *thdev = to_intel_th_device(dev);
+
+	if (thdev->type == INTEL_TH_SWITCH &&
+	    (!thdrv->enable || !thdrv->disable))
+		return 0;
+
+	return !strcmp(thdev->name, driver->name);
+}
+
+static int intel_th_child_remove(struct device *dev, void *data)
+{
+	device_release_driver(dev);
+
+	return 0;
+}
+
+static int intel_th_probe(struct device *dev)
+{
+	struct intel_th_driver *thdrv = to_intel_th_driver(dev->driver);
+	struct intel_th_device *thdev = to_intel_th_device(dev);
+	struct intel_th_driver *hubdrv;
+	struct intel_th_device *hub = NULL;
+	int ret;
+
+	if (thdev->type == INTEL_TH_SWITCH)
+		hub = thdev;
+	else if (dev->parent)
+		hub = to_intel_th_device(dev->parent);
+
+	if (!hub || !hub->dev.driver)
+		return -EPROBE_DEFER;
+
+	hubdrv = to_intel_th_driver(hub->dev.driver);
+
+	ret = thdrv->probe(to_intel_th_device(dev));
+	if (ret)
+		return ret;
+
+	if (thdev->type == INTEL_TH_OUTPUT &&
+	    !intel_th_output_assigned(thdev))
+		ret = hubdrv->assign(hub, thdev);
+
+	return ret;
+}
+
+static int intel_th_remove(struct device *dev)
+{
+	struct intel_th_driver *thdrv = to_intel_th_driver(dev->driver);
+	struct intel_th_device *thdev = to_intel_th_device(dev);
+	struct intel_th_device *hub = to_intel_th_device(dev->parent);
+	int err;
+
+	if (thdev->type == INTEL_TH_SWITCH) {
+		err = device_for_each_child(dev, thdev, intel_th_child_remove);
+		if (err)
+			return err;
+	}
+
+	thdrv->remove(thdev);
+
+	if (intel_th_output_assigned(thdev)) {
+		struct intel_th_driver *hubdrv =
+			to_intel_th_driver(dev->parent->driver);
+
+		if (hub->dev.driver)
+			hubdrv->unassign(hub, thdev);
+	}
+
+	return 0;
+}
+
+static struct bus_type intel_th_bus = {
+	.name		= "intel_th",
+	.dev_attrs	= NULL,
+	.match		= intel_th_match,
+	.probe		= intel_th_probe,
+	.remove		= intel_th_remove,
+};
+
+static void intel_th_device_free(struct intel_th_device *thdev);
+
+static void intel_th_device_release(struct device *dev)
+{
+	intel_th_device_free(to_intel_th_device(dev));
+}
+
+static struct device_type intel_th_source_device_type = {
+	.name		= "intel_th_source_device",
+	.release	= intel_th_device_release,
+};
+
+static char *intel_th_output_devnode(struct device *dev, umode_t *mode,
+				     kuid_t *uid, kgid_t *gid)
+{
+	struct intel_th_device *thdev = to_intel_th_device(dev);
+	char *node;
+
+	if (thdev->id >= 0)
+		node = kasprintf(GFP_KERNEL, "intel_th%d/%s%d", 0, thdev->name,
+				 thdev->id);
+	else
+		node = kasprintf(GFP_KERNEL, "intel_th%d/%s", 0, thdev->name);
+
+	return node;
+}
+
+static ssize_t port_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct intel_th_device *thdev = to_intel_th_device(dev);
+
+	if (thdev->output.port >= 0)
+		return scnprintf(buf, PAGE_SIZE, "%u\n", thdev->output.port);
+
+	return scnprintf(buf, PAGE_SIZE, "unassigned\n");
+}
+
+static DEVICE_ATTR_RO(port);
+
+static int intel_th_output_activate(struct intel_th_device *thdev)
+{
+	struct intel_th_driver *thdrv = to_intel_th_driver(thdev->dev.driver);
+
+	if (thdrv->activate)
+		return thdrv->activate(thdev);
+
+	intel_th_trace_enable(thdev);
+
+	return 0;
+}
+
+static void intel_th_output_deactivate(struct intel_th_device *thdev)
+{
+	struct intel_th_driver *thdrv = to_intel_th_driver(thdev->dev.driver);
+
+	if (thdrv->deactivate)
+		thdrv->deactivate(thdev);
+	else
+		intel_th_trace_disable(thdev);
+}
+
+static ssize_t active_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct intel_th_device *thdev = to_intel_th_device(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", thdev->output.active);
+}
+
+static ssize_t active_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t size)
+{
+	struct intel_th_device *thdev = to_intel_th_device(dev);
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (!!val != thdev->output.active) {
+		if (val)
+			ret = intel_th_output_activate(thdev);
+		else
+			intel_th_output_deactivate(thdev);
+	}
+
+	return ret ? ret : size;
+}
+
+static DEVICE_ATTR_RW(active);
+
+static struct attribute *intel_th_output_attrs[] = {
+	&dev_attr_port.attr,
+	&dev_attr_active.attr,
+	NULL,
+};
+
+ATTRIBUTE_GROUPS(intel_th_output);
+
+static struct device_type intel_th_output_device_type = {
+	.name		= "intel_th_output_device",
+	.groups		= intel_th_output_groups,
+	.release	= intel_th_device_release,
+	.devnode	= intel_th_output_devnode,
+};
+
+static struct device_type intel_th_switch_device_type = {
+	.name		= "intel_th_switch_device",
+	.release	= intel_th_device_release,
+};
+
+static struct device_type *intel_th_device_type[] = {
+	[INTEL_TH_SOURCE]	= &intel_th_source_device_type,
+	[INTEL_TH_OUTPUT]	= &intel_th_output_device_type,
+	[INTEL_TH_SWITCH]	= &intel_th_switch_device_type,
+};
+
+int intel_th_driver_register(struct intel_th_driver *thdrv)
+{
+	if (!thdrv->probe || !thdrv->remove)
+		return -EINVAL;
+
+	thdrv->driver.bus = &intel_th_bus;
+
+	return driver_register(&thdrv->driver);
+}
+EXPORT_SYMBOL_GPL(intel_th_driver_register);
+
+void intel_th_driver_unregister(struct intel_th_driver *thdrv)
+{
+	driver_unregister(&thdrv->driver);
+}
+EXPORT_SYMBOL_GPL(intel_th_driver_unregister);
+
+static struct intel_th_device *
+intel_th_device_alloc(struct intel_th *th, unsigned int type, const char *name,
+		      int id)
+{
+	struct device *parent;
+	struct intel_th_device *thdev;
+
+	if (type == INTEL_TH_SWITCH)
+		parent = th->dev;
+	else
+		parent = &th->hub->dev;
+
+	thdev = kzalloc(sizeof(*thdev) + strlen(name) + 1, GFP_KERNEL);
+	if (!thdev)
+		return NULL;
+
+	thdev->id = id;
+	thdev->type = type;
+
+	strcpy(thdev->name, name);
+	device_initialize(&thdev->dev);
+	thdev->dev.bus = &intel_th_bus;
+	thdev->dev.type = intel_th_device_type[type];
+	thdev->dev.parent = parent;
+	thdev->dev.dma_mask = parent->dma_mask;
+	thdev->dev.dma_parms = parent->dma_parms;
+	dma_set_coherent_mask(&thdev->dev, parent->coherent_dma_mask);
+	if (id >= 0)
+		dev_set_name(&thdev->dev, "%d-%s%d", th->id, name, id);
+	else
+		dev_set_name(&thdev->dev, "%d-%s", th->id, name);
+
+	return thdev;
+}
+
+static int intel_th_device_add_resources(struct intel_th_device *thdev,
+					 struct resource *res, int nres)
+{
+	struct resource *r;
+
+	r = kmemdup(res, sizeof(*res) * nres, GFP_KERNEL);
+	if (!r)
+		return -ENOMEM;
+
+	thdev->resource = r;
+	thdev->num_resources = nres;
+
+	return 0;
+}
+
+static void intel_th_device_remove(struct intel_th_device *thdev)
+{
+	device_del(&thdev->dev);
+	put_device(&thdev->dev);
+}
+
+static void intel_th_device_free(struct intel_th_device *thdev)
+{
+	kfree(thdev->resource);
+	kfree(thdev);
+}
+
+/*
+ * Intel(R) Trace Hub subdevices
+ */
+static struct intel_th_subdevice {
+	const char		*name;
+	struct resource		res[3];
+	unsigned		nres;
+	unsigned		type;
+	unsigned		otype;
+	int			id;
+} intel_th_subdevices[TH_SUBDEVICE_MAX] = {
+	{
+		.nres	= 1,
+		.res	= {
+			{
+				.start	= REG_GTH_OFFSET,
+				.end	= REG_GTH_OFFSET + REG_GTH_LENGTH - 1,
+				.flags	= IORESOURCE_MEM,
+			},
+		},
+		.name	= "gth",
+		.type	= INTEL_TH_SWITCH,
+		.id	= -1,
+	},
+	{
+		.nres	= 2,
+		.res	= {
+			{
+				.start	= REG_MSU_OFFSET,
+				.end	= REG_MSU_OFFSET + REG_MSU_LENGTH - 1,
+				.flags	= IORESOURCE_MEM,
+			},
+			{
+				.start	= BUF_MSU_OFFSET,
+				.end	= BUF_MSU_OFFSET + BUF_MSU_LENGTH - 1,
+				.flags	= IORESOURCE_MEM,
+			},
+		},
+		.name	= "msc",
+		.id	= 0,
+		.type	= INTEL_TH_OUTPUT,
+		.otype	= GTH_MSU,
+	},
+	{
+		.nres	= 2,
+		.res	= {
+			{
+				.start	= REG_MSU_OFFSET,
+				.end	= REG_MSU_OFFSET + REG_MSU_LENGTH - 1,
+				.flags	= IORESOURCE_MEM,
+			},
+			{
+				.start	= BUF_MSU_OFFSET,
+				.end	= BUF_MSU_OFFSET + BUF_MSU_LENGTH - 1,
+				.flags	= IORESOURCE_MEM,
+			},
+		},
+		.name	= "msc",
+		.id	= 1,
+		.type	= INTEL_TH_OUTPUT,
+		.otype	= GTH_MSU,
+	},
+	{
+		.nres	= 2,
+		.res	= {
+			{
+				.start	= REG_STH_OFFSET,
+				.end	= REG_STH_OFFSET + REG_STH_LENGTH - 1,
+				.flags	= IORESOURCE_MEM,
+			},
+			{
+				.start	= TH_MMIO_SW,
+				.end	= 0,
+				.flags	= IORESOURCE_MEM,
+			},
+		},
+		.id	= -1,
+		.name	= "sth",
+		.type	= INTEL_TH_SOURCE,
+	},
+	{
+		.nres	= 1,
+		.res	= {
+			{
+				.start	= REG_PTI_OFFSET,
+				.end	= REG_PTI_OFFSET + REG_PTI_LENGTH - 1,
+				.flags	= IORESOURCE_MEM,
+			},
+		},
+		.id	= -1,
+		.name	= "pti",
+		.type	= INTEL_TH_OUTPUT,
+		.otype	= GTH_PTI,
+	},
+	{
+		.nres	= 1,
+		.res	= {
+			{
+				.start	= REG_DCIH_OFFSET,
+				.end	= REG_DCIH_OFFSET + REG_DCIH_LENGTH - 1,
+				.flags	= IORESOURCE_MEM,
+			},
+		},
+		.id	= -1,
+		.name	= "dcih",
+		.type	= INTEL_TH_OUTPUT,
+	},
+};
+
+static int intel_th_populate(struct intel_th *th, struct resource *devres,
+			     unsigned int ndevres, int irq)
+{
+	struct resource res[3];
+	unsigned int req = 0;
+	int i, err;
+
+	/* create devices for each intel_th_subdevice */
+	for (i = 0; i < ARRAY_SIZE(intel_th_subdevices); i++) {
+		struct intel_th_subdevice *subdev = &intel_th_subdevices[i];
+		struct intel_th_device *thdev;
+		int r;
+
+		thdev = intel_th_device_alloc(th, subdev->type, subdev->name,
+					      subdev->id);
+		if (!thdev) {
+			err = -ENOMEM;
+			goto kill_subdevs;
+		}
+
+		memcpy(res, subdev->res,
+		       sizeof(struct resource) * subdev->nres);
+
+		for (r = 0; r < subdev->nres; r++) {
+			int bar = TH_MMIO_CONFIG;
+
+			/*
+			 * Take .end == 0 to mean 'take the whole bar',
+			 * .start then tells us which bar it is. Default to
+			 * TH_MMIO_CONFIG.
+			 */
+			if (!res[r].end && res[r].flags == IORESOURCE_MEM) {
+				bar = res[r].start;
+				res[r].start = 0;
+				res[r].end = resource_size(&devres[bar]) - 1;
+			}
+
+			if (res[r].flags & IORESOURCE_MEM) {
+				res[r].start	+= devres[bar].start;
+				res[r].end	+= devres[bar].start;
+
+				dev_dbg(th->dev, "%s:%d @ %pR\n",
+					subdev->name, r, &res[r]);
+			} else if (res[r].flags & IORESOURCE_IRQ) {
+				res[r].start	= irq;
+			}
+		}
+
+		err = intel_th_device_add_resources(thdev, res, subdev->nres);
+		if (err) {
+			put_device(&thdev->dev);
+			goto kill_subdevs;
+		}
+
+		if (subdev->type == INTEL_TH_OUTPUT) {
+			thdev->dev.devt = MKDEV(th->major, i);
+			thdev->output.type = subdev->otype;
+			thdev->output.port = -1;
+		}
+
+		err = device_add(&thdev->dev);
+		if (err) {
+			put_device(&thdev->dev);
+			goto kill_subdevs;
+		}
+
+		/* need switch driver to be loaded to enumerate the rest */
+		if (subdev->type == INTEL_TH_SWITCH && !req) {
+			th->hub = thdev;
+			err = request_module("intel_th_%s", subdev->name);
+			if (!err)
+				req++;
+		}
+
+		th->thdev[i] = thdev;
+	}
+
+	return 0;
+
+kill_subdevs:
+	for (i-- ; i >= 0; i--)
+		intel_th_device_remove(th->thdev[i]);
+
+	return err;
+}
+
+static int match_devt(struct device *dev, void *data)
+{
+	dev_t devt = (dev_t)(unsigned long)data;
+
+	return dev->devt == devt;
+}
+
+static int intel_th_output_open(struct inode *inode, struct file *file)
+{
+	const struct file_operations *fops;
+	struct intel_th_driver *thdrv;
+	struct device *dev;
+	int err;
+
+	dev = bus_find_device(&intel_th_bus, NULL,
+			      (void *)(unsigned long)inode->i_rdev,
+			      match_devt);
+	if (!dev || !dev->driver)
+		return -ENODEV;
+
+	thdrv = to_intel_th_driver(dev->driver);
+	fops = fops_get(thdrv->fops);
+	if (!fops)
+		return -ENODEV;
+
+	replace_fops(file, fops);
+
+	file->private_data = to_intel_th_device(dev);
+
+	if (file->f_op->open) {
+		err = file->f_op->open(inode, file);
+		return err;
+	}
+
+	return 0;
+}
+
+static const struct file_operations intel_th_output_fops = {
+	.open	= intel_th_output_open,
+	.llseek	= noop_llseek,
+};
+
+/**
+ * intel_th_alloc() - allocate a new Intel TH device and its subdevices
+ * @dev:	parent device
+ * @devres:	parent's resources
+ * @ndevres:	number of resources
+ * @irq:	irq number
+ */
+struct intel_th *
+intel_th_alloc(struct device *dev, struct resource *devres,
+	       unsigned int ndevres, int irq)
+{
+	struct intel_th *th;
+	int err;
+
+	th = kzalloc(sizeof(*th), GFP_KERNEL);
+	if (!th)
+		return ERR_PTR(-ENOMEM);
+
+	th->id = ida_simple_get(&intel_th_ida, 0, 0, GFP_KERNEL);
+	if (th->id < 0) {
+		err = th->id;
+		goto err_alloc;
+	}
+
+	th->major = __register_chrdev(0, 0, TH_POSSIBLE_OUTPUTS,
+				      "intel_th/output", &intel_th_output_fops);
+	if (th->major < 0) {
+		err = th->major;
+		goto err_ida;
+	}
+	th->dev = dev;
+
+	err = intel_th_populate(th, devres, ndevres, irq);
+	if (err)
+		goto err_chrdev;
+
+	return th;
+
+err_chrdev:
+	__unregister_chrdev(th->major, 0, TH_POSSIBLE_OUTPUTS,
+			    "intel_th/output");
+
+err_ida:
+	ida_simple_remove(&intel_th_ida, th->id);
+
+err_alloc:
+	kfree(th);
+
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(intel_th_alloc);
+
+void intel_th_free(struct intel_th *th)
+{
+	int i;
+
+	for (i = 0; i < TH_SUBDEVICE_MAX; i++)
+		if (th->thdev[i] != th->hub)
+			intel_th_device_remove(th->thdev[i]);
+
+	intel_th_device_remove(th->hub);
+
+	__unregister_chrdev(th->major, 0, TH_POSSIBLE_OUTPUTS,
+			    "intel_th/output");
+
+	ida_simple_remove(&intel_th_ida, th->id);
+
+	kfree(th);
+}
+EXPORT_SYMBOL_GPL(intel_th_free);
+
+/**
+ * intel_th_trace_enable() - enable tracing for an output device
+ * @thdev:	output device that requests tracing be enabled
+ */
+int intel_th_trace_enable(struct intel_th_device *thdev)
+{
+	struct intel_th_device *hub = to_intel_th_device(thdev->dev.parent);
+	struct intel_th_driver *hubdrv = to_intel_th_driver(hub->dev.driver);
+
+	if (WARN_ON_ONCE(hub->type != INTEL_TH_SWITCH))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(thdev->type != INTEL_TH_OUTPUT))
+		return -EINVAL;
+
+	hubdrv->enable(hub, &thdev->output);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(intel_th_trace_enable);
+
+/**
+ * intel_th_trace_disable() - disable tracing for an output device
+ * @thdev:	output device that requests tracing be disabled
+ */
+int intel_th_trace_disable(struct intel_th_device *thdev)
+{
+	struct intel_th_device *hub = to_intel_th_device(thdev->dev.parent);
+	struct intel_th_driver *hubdrv = to_intel_th_driver(hub->dev.driver);
+
+	WARN_ON_ONCE(hub->type != INTEL_TH_SWITCH);
+	if (WARN_ON_ONCE(thdev->type != INTEL_TH_OUTPUT))
+		return -EINVAL;
+
+	hubdrv->disable(hub, &thdev->output);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(intel_th_trace_disable);
+
+int intel_th_set_output(struct intel_th_device *thdev,
+			unsigned int master)
+{
+	struct intel_th_device *hub = to_intel_th_device(thdev->dev.parent);
+	struct intel_th_driver *hubdrv = to_intel_th_driver(hub->dev.driver);
+
+	if (!hubdrv->set_output)
+		return -ENOTSUPP;
+
+	return hubdrv->set_output(hub, master);
+}
+EXPORT_SYMBOL_GPL(intel_th_set_output);
+
+static int __init intel_th_init(void)
+{
+	intel_th_debug_init();
+
+	return bus_register(&intel_th_bus);
+}
+subsys_initcall(intel_th_init);
+
+static void __exit intel_th_exit(void)
+{
+	intel_th_debug_done();
+
+	bus_unregister(&intel_th_bus);
+}
+module_exit(intel_th_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Intel(R) Trace Hub controller driver");
+MODULE_AUTHOR("Alexander Shishkin <alexander.shishkin@linux.intel.com>");
diff --git a/drivers/hwtracing/intel_th/debug.c b/drivers/hwtracing/intel_th/debug.c
new file mode 100644
index 000000000000..788a1f0a97ad
--- /dev/null
+++ b/drivers/hwtracing/intel_th/debug.c
@@ -0,0 +1,36 @@
+/*
+ * Intel(R) Trace Hub driver debugging
+ *
+ * Copyright (C) 2014-2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/debugfs.h>
+
+#include "intel_th.h"
+#include "debug.h"
+
+struct dentry *intel_th_dbg;
+
+void intel_th_debug_init(void)
+{
+	intel_th_dbg = debugfs_create_dir("intel_th", NULL);
+	if (IS_ERR(intel_th_dbg))
+		intel_th_dbg = NULL;
+}
+
+void intel_th_debug_done(void)
+{
+	debugfs_remove(intel_th_dbg);
+	intel_th_dbg = NULL;
+}
diff --git a/drivers/hwtracing/intel_th/debug.h b/drivers/hwtracing/intel_th/debug.h
new file mode 100644
index 000000000000..88311bad3ba4
--- /dev/null
+++ b/drivers/hwtracing/intel_th/debug.h
@@ -0,0 +1,34 @@
+/*
+ * Intel(R) Trace Hub driver debugging
+ *
+ * Copyright (C) 2014-2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __INTEL_TH_DEBUG_H__
+#define __INTEL_TH_DEBUG_H__
+
+#ifdef CONFIG_INTEL_TH_DEBUG
+extern struct dentry *intel_th_dbg;
+
+void intel_th_debug_init(void);
+void intel_th_debug_done(void);
+#else
+static inline void intel_th_debug_init(void)
+{
+}
+
+static inline void intel_th_debug_done(void)
+{
+}
+#endif
+
+#endif /* __INTEL_TH_DEBUG_H__ */
diff --git a/drivers/hwtracing/intel_th/intel_th.h b/drivers/hwtracing/intel_th/intel_th.h
new file mode 100644
index 000000000000..57fd72b20fae
--- /dev/null
+++ b/drivers/hwtracing/intel_th/intel_th.h
@@ -0,0 +1,244 @@
+/*
+ * Intel(R) Trace Hub data structures
+ *
+ * Copyright (C) 2014-2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __INTEL_TH_H__
+#define __INTEL_TH_H__
+
+/* intel_th_device device types */
+enum {
+	/* Devices that generate trace data */
+	INTEL_TH_SOURCE = 0,
+	/* Output ports (MSC, PTI) */
+	INTEL_TH_OUTPUT,
+	/* Switch, the Global Trace Hub (GTH) */
+	INTEL_TH_SWITCH,
+};
+
+/**
+ * struct intel_th_output - descriptor INTEL_TH_OUTPUT type devices
+ * @port:	output port number, assigned by the switch
+ * @type:	GTH_{MSU,CTP,PTI}
+ * @multiblock:	true for multiblock output configuration
+ * @active:	true when this output is enabled
+ *
+ * Output port descriptor, used by switch driver to tell which output
+ * port this output device corresponds to. Filled in at output device's
+ * probe time by switch::assign(). Passed from output device driver to
+ * switch related code to enable/disable its port.
+ */
+struct intel_th_output {
+	int		port;
+	unsigned int	type;
+	bool		multiblock;
+	bool		active;
+};
+
+/**
+ * struct intel_th_device - device on the intel_th bus
+ * @dev:		device
+ * @resource:		array of resources available to this device
+ * @num_resources:	number of resources in @resource array
+ * @type:		INTEL_TH_{SOURCE,OUTPUT,SWITCH}
+ * @id:			device instance or -1
+ * @output:		output descriptor for INTEL_TH_OUTPUT devices
+ * @name:		device name to match the driver
+ */
+struct intel_th_device {
+	struct device	dev;
+	struct resource	*resource;
+	unsigned int	num_resources;
+	unsigned int	type;
+	int		id;
+
+	/* INTEL_TH_OUTPUT specific */
+	struct intel_th_output	output;
+
+	char		name[];
+};
+
+#define to_intel_th_device(_d)				\
+	container_of((_d), struct intel_th_device, dev)
+
+/**
+ * intel_th_device_get_resource() - obtain @num'th resource of type @type
+ * @thdev:	the device to search the resource for
+ * @type:	resource type
+ * @num:	number of the resource
+ */
+static inline struct resource *
+intel_th_device_get_resource(struct intel_th_device *thdev, unsigned int type,
+			     unsigned int num)
+{
+	int i;
+
+	for (i = 0; i < thdev->num_resources; i++)
+		if (resource_type(&thdev->resource[i]) == type && !num--)
+			return &thdev->resource[i];
+
+	return NULL;
+}
+
+/**
+ * intel_th_output_assigned() - if an output device is assigned to a switch port
+ * @thdev:	the output device
+ *
+ * Return:	true if the device is INTEL_TH_OUTPUT *and* is assigned a port
+ */
+static inline bool
+intel_th_output_assigned(struct intel_th_device *thdev)
+{
+	return thdev->type == INTEL_TH_OUTPUT &&
+		thdev->output.port >= 0;
+}
+
+/**
+ * struct intel_th_driver - driver for an intel_th_device device
+ * @driver:	generic driver
+ * @probe:	probe method
+ * @remove:	remove method
+ * @assign:	match a given output type device against available outputs
+ * @unassign:	deassociate an output type device from an output port
+ * @enable:	enable tracing for a given output device
+ * @disable:	disable tracing for a given output device
+ * @fops:	file operations for device nodes
+ *
+ * Callbacks @probe and @remove are required for all device types.
+ * Switch device driver needs to fill in @assign, @enable and @disable
+ * callbacks.
+ */
+struct intel_th_driver {
+	struct device_driver	driver;
+	int			(*probe)(struct intel_th_device *thdev);
+	void			(*remove)(struct intel_th_device *thdev);
+	/* switch (GTH) ops */
+	int			(*assign)(struct intel_th_device *thdev,
+					  struct intel_th_device *othdev);
+	void			(*unassign)(struct intel_th_device *thdev,
+					    struct intel_th_device *othdev);
+	void			(*enable)(struct intel_th_device *thdev,
+					  struct intel_th_output *output);
+	void			(*disable)(struct intel_th_device *thdev,
+					   struct intel_th_output *output);
+	/* output ops */
+	void			(*irq)(struct intel_th_device *thdev);
+	int			(*activate)(struct intel_th_device *thdev);
+	void			(*deactivate)(struct intel_th_device *thdev);
+	/* file_operations for those who want a device node */
+	const struct file_operations *fops;
+
+	/* source ops */
+	int			(*set_output)(struct intel_th_device *thdev,
+					      unsigned int master);
+};
+
+#define to_intel_th_driver(_d)					\
+	container_of((_d), struct intel_th_driver, driver)
+
+static inline struct intel_th_device *
+to_intel_th_hub(struct intel_th_device *thdev)
+{
+	struct device *parent = thdev->dev.parent;
+
+	if (!parent)
+		return NULL;
+
+	return to_intel_th_device(parent);
+}
+
+struct intel_th *
+intel_th_alloc(struct device *dev, struct resource *devres,
+	       unsigned int ndevres, int irq);
+void intel_th_free(struct intel_th *th);
+
+int intel_th_driver_register(struct intel_th_driver *thdrv);
+void intel_th_driver_unregister(struct intel_th_driver *thdrv);
+
+int intel_th_trace_enable(struct intel_th_device *thdev);
+int intel_th_trace_disable(struct intel_th_device *thdev);
+int intel_th_set_output(struct intel_th_device *thdev,
+			unsigned int master);
+
+enum {
+	TH_MMIO_CONFIG = 0,
+	TH_MMIO_SW = 2,
+	TH_MMIO_END,
+};
+
+#define TH_SUBDEVICE_MAX	6
+#define TH_POSSIBLE_OUTPUTS	8
+#define TH_CONFIGURABLE_MASTERS 256
+#define TH_MSC_MAX		2
+
+/**
+ * struct intel_th - Intel TH controller
+ * @dev:	driver core's device
+ * @thdev:	subdevices
+ * @hub:	"switch" subdevice (GTH)
+ * @id:		this Intel TH controller's device ID in the system
+ * @major:	device node major for output devices
+ */
+struct intel_th {
+	struct device		*dev;
+
+	struct intel_th_device	*thdev[TH_SUBDEVICE_MAX];
+	struct intel_th_device	*hub;
+
+	int			id;
+	int			major;
+#ifdef CONFIG_INTEL_TH_DEBUG
+	struct dentry		*dbg;
+#endif
+};
+
+/*
+ * Register windows
+ */
+enum {
+	/* Global Trace Hub (GTH) */
+	REG_GTH_OFFSET		= 0x0000,
+	REG_GTH_LENGTH		= 0x2000,
+
+	/* Software Trace Hub (STH) [0x4000..0x4fff] */
+	REG_STH_OFFSET		= 0x4000,
+	REG_STH_LENGTH		= 0x2000,
+
+	/* Memory Storage Unit (MSU) [0xa0000..0xa1fff] */
+	REG_MSU_OFFSET		= 0xa0000,
+	REG_MSU_LENGTH		= 0x02000,
+
+	/* Internal MSU trace buffer [0x80000..0x9ffff] */
+	BUF_MSU_OFFSET		= 0x80000,
+	BUF_MSU_LENGTH		= 0x20000,
+
+	/* PTI output == same window as GTH */
+	REG_PTI_OFFSET		= REG_GTH_OFFSET,
+	REG_PTI_LENGTH		= REG_GTH_LENGTH,
+
+	/* DCI Handler (DCIH) == some window as MSU */
+	REG_DCIH_OFFSET		= REG_MSU_OFFSET,
+	REG_DCIH_LENGTH		= REG_MSU_LENGTH,
+};
+
+/*
+ * GTH, output ports configuration
+ */
+enum {
+	GTH_NONE = 0,
+	GTH_MSU,	/* memory/usb */
+	GTH_CTP,	/* Common Trace Port */
+	GTH_PTI = 4,	/* MIPI-PTI */
+};
+
+#endif

