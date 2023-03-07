Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D476ADA72
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCGJe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCGJew (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:34:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A49B37F21
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:34:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1733DB8169F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D8BC433D2;
        Tue,  7 Mar 2023 09:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678181688;
        bh=GbLFPfv/YnEC9MgCdi30uiu0oOdA+zaRRbnE+TfNxNA=;
        h=Subject:To:Cc:From:Date:From;
        b=KgeXY4UKC5KShKY1kZCv0q9c3aZzU3vJTqhUVP1+r2QcKhHNdWSLl2UJyXKRkYZDU
         +EmjKnO6pcG+UcgKTC17r3P5oBTOCT1V1jiDcFfNUDkYG2uuF53su/ihVec3OAqIgk
         KWWH8zpcIpgIDAv921HV7LwbQ6kM5mWfCOjL8C7U=
Subject: FAILED: patch "[PATCH] cxl/pmem: Fix nvdimm registration races" failed to apply to 5.15-stable tree
To:     dan.j.williams@intel.com, dave.jiang@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:34:45 +0100
Message-ID: <1678181685158238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x f57aec443c24d2e8e1f3b5b4856aea12ddda4254
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678181685158238@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

f57aec443c24 ("cxl/pmem: Fix nvdimm registration races")
4a0079bc7aae ("nvdimm: Replace lockdep_mutex with local lock classes")
3b6c6c039707 ("nvdimm/region: Delete nd_blk_region infrastructure")
84bd3690bf54 ("nvdimm/namespace: Delete nd_namespace_blk")
fadc38a6672a ("nvdimm/namespace: Delete blk namespace consideration in shared paths")
d9d290d7e659 ("nvdimm/region: Fix default alignment for small regions")
60b8f17215de ("cxl/pmem: Translate NVDIMM label commands to CXL label commands")
12f3856ad42d ("cxl/mbox: Add exclusive kernel command support")
ff56ab9e164d ("cxl/mbox: Convert 'enabled_cmds' to DECLARE_BITMAP")
4faf31b43468 ("cxl/mbox: Move mailbox and other non-PCI specific infrastructure to the core")
4cb35f1ca05a ("cxl/pci: Drop idr.h")
b64955a92929 ("cxl/mbox: Introduce the mbox_send operation")
13e7749d06b3 ("cxl/pci: Clean up cxl_mem_get_partition_info()")
99e222a5f1b6 ("cxl/pci: Make 'struct cxl_mem' device type generic")
5af96835e4da ("libnvdimm/labels: Introduce CXL labels")
540ccaa2e4dd ("libnvdimm/label: Define CXL region labels")
42e192aa9891 ("libnvdimm/labels: Introduce the concept of multi-range namespace labels")
8172db92527c ("libnvdimm/label: Add a helper for nlabel validation")
d1c6e08e7503 ("libnvdimm/labels: Add uuid helpers")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f57aec443c24d2e8e1f3b5b4856aea12ddda4254 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Feb 2023 17:01:05 -0800
Subject: [PATCH] cxl/pmem: Fix nvdimm registration races

A loop of the form:

    while true; do modprobe cxl_pci; modprobe -r cxl_pci; done

...fails with the following crash signature:

    BUG: kernel NULL pointer dereference, address: 0000000000000040
    [..]
    RIP: 0010:cxl_internal_send_cmd+0x5/0xb0 [cxl_core]
    [..]
    Call Trace:
     <TASK>
     cxl_pmem_ctl+0x121/0x240 [cxl_pmem]
     nvdimm_get_config_data+0xd6/0x1a0 [libnvdimm]
     nd_label_data_init+0x135/0x7e0 [libnvdimm]
     nvdimm_probe+0xd6/0x1c0 [libnvdimm]
     nvdimm_bus_probe+0x7a/0x1e0 [libnvdimm]
     really_probe+0xde/0x380
     __driver_probe_device+0x78/0x170
     driver_probe_device+0x1f/0x90
     __device_attach_driver+0x85/0x110
     bus_for_each_drv+0x7d/0xc0
     __device_attach+0xb4/0x1e0
     bus_probe_device+0x9f/0xc0
     device_add+0x445/0x9c0
     nd_async_device_register+0xe/0x40 [libnvdimm]
     async_run_entry_fn+0x30/0x130

...namely that the bottom half of async nvdimm device registration runs
after the CXL has already torn down the context that cxl_pmem_ctl()
needs. Unlike the ACPI NFIT case that benefits from launching multiple
nvdimm device registrations in parallel from those listed in the table,
CXL is already marked PROBE_PREFER_ASYNCHRONOUS. So provide for a
synchronous registration path to preclude this scenario.

Fixes: 21083f51521f ("cxl/pmem: Register 'pmem' / cxl_nvdimm devices")
Cc: <stable@vger.kernel.org>
Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 08bbbac9a6d0..71cfa1fdf902 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -76,6 +76,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 		return rc;
 
 	set_bit(NDD_LABELING, &flags);
+	set_bit(NDD_REGISTER_SYNC, &flags);
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
 	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index b38d0355b0ac..5ad49056921b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -508,7 +508,7 @@ static void nd_async_device_unregister(void *d, async_cookie_t cookie)
 	put_device(dev);
 }
 
-void nd_device_register(struct device *dev)
+static void __nd_device_register(struct device *dev, bool sync)
 {
 	if (!dev)
 		return;
@@ -531,11 +531,24 @@ void nd_device_register(struct device *dev)
 	}
 	get_device(dev);
 
-	async_schedule_dev_domain(nd_async_device_register, dev,
-				  &nd_async_domain);
+	if (sync)
+		nd_async_device_register(dev, 0);
+	else
+		async_schedule_dev_domain(nd_async_device_register, dev,
+					  &nd_async_domain);
+}
+
+void nd_device_register(struct device *dev)
+{
+	__nd_device_register(dev, false);
 }
 EXPORT_SYMBOL(nd_device_register);
 
+void nd_device_register_sync(struct device *dev)
+{
+	__nd_device_register(dev, true);
+}
+
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode)
 {
 	bool killed;
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 1fc081dcf631..6d3b03a9fa02 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -624,7 +624,10 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 	nvdimm->sec.ext_flags = nvdimm_security_flags(nvdimm, NVDIMM_MASTER);
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &nvdimm_key);
-	nd_device_register(dev);
+	if (test_bit(NDD_REGISTER_SYNC, &flags))
+		nd_device_register_sync(dev);
+	else
+		nd_device_register(dev);
 
 	return nvdimm;
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index cc86ee09d7c0..845408f10655 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -107,6 +107,7 @@ int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nd_synchronize(void);
 void nd_device_register(struct device *dev);
+void nd_device_register_sync(struct device *dev);
 struct nd_label_id;
 char *nd_label_gen_id(struct nd_label_id *label_id, const uuid_t *uuid,
 		      u32 flags);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index af38252ad704..e772aae71843 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -41,6 +41,9 @@ enum {
 	 */
 	NDD_INCOHERENT = 7,
 
+	/* dimm provider wants synchronous registration by __nvdimm_create() */
+	NDD_REGISTER_SYNC = 8,
+
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,
 	ND_CMD_MAX_ELEM = 5,

