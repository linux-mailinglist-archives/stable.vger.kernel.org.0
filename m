Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C306238E679
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 14:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhEXMWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 08:22:43 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:51935 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232300AbhEXMWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 08:22:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 45678194023B;
        Mon, 24 May 2021 08:21:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 24 May 2021 08:21:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+qVObr
        5OQ+ZNB5wzeoxSErLMHECxZY5I+wUvO0jjUSA=; b=nVCKQBFdp0K5xu6Rb71KkM
        BD/3AnbhT8vHrs1wHwbITo+NQsdTLVP9A73Jq1gZLIt3BMq8ZxT0eQliftkABW4/
        S8qhzc68v9Ujq7nVbltkHa1Aprnffiw6ezYwfLyUaJoMkJ9NH3ERwQP6KPxuuM77
        neFmGait9u7AcgdqyzyZ61FZrEEt/8oRUGvv/IQBAmw7Y+zBCP8VPw/P/2MMGLYx
        rIyaXHAvs4voXB0QkWau5ZxcPJFvsF61gbhIJipXBtrX5NNVpKY6LBxulZpgGhBw
        0YGVfYRfTBxATfVpXz+YV427U7oZ+/t1pIGuzi1dbrXdrmYIqOQ6XLDPplCjpKjQ
        ==
X-ME-Sender: <xms:OpqrYCQM5YfIcoqGEqw4dbZpHvF1R2r-_pUsoyCKMD4cXvWkVubJrQ>
    <xme:OpqrYHyflFbPYht4soMlyyjn-IzXXopfrH-aUeFPJ5E8EvqiklUa4yvqixV7ixBle
    hF6Fxo9gH_FDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:OpqrYP2nQeqCtchg3Wwyg0Xb9upIsd0M1ctbhLl3tHI3P4JH5pIMZA>
    <xmx:OpqrYOBAAUPLH4BMkLe1w0ffSgU8nCkxxvrfROAA4N2VAj-ECnK92Q>
    <xmx:OpqrYLijlfK9RT5H-Nn9JQFJQdO90y_7EVtCksGERewftM8Hn7Uhxw>
    <xmx:O5qrYIvSi01n5_fMY_mJXfHOmzFVHTliznEJ4Dh623IyanFGjLuGZA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 08:21:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] nvme-multipath: fix double initialization of ANA state" failed to apply to 4.19-stable tree
To:     hch@lst.de, hare@suse.de, kbusch@kernel.org, mwilck@suse.com,
        sagi@grimberg.me
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 14:21:12 +0200
Message-ID: <1621858872112178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5e1f689913a4498e3081093670ef9d85b2c60920 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 29 Apr 2021 14:18:53 +0200
Subject: [PATCH] nvme-multipath: fix double initialization of ANA state

nvme_init_identify and thus nvme_mpath_init can be called multiple
times and thus must not overwrite potentially initialized or in-use
fields.  Split out a helper for the basic initialization when the
controller is initialized and make sure the init_identify path does
not blindly change in-use data structures.

Fixes: 0d0b660f214d ("nvme: add ANA support")
Reported-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 522c9b229f80..762125f2905f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2901,7 +2901,7 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
 		ctrl->hmmaxd = le16_to_cpu(id->hmmaxd);
 	}
 
-	ret = nvme_mpath_init(ctrl, id);
+	ret = nvme_mpath_init_identify(ctrl, id);
 	if (ret < 0)
 		goto out_free;
 
@@ -4364,6 +4364,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 		min(default_ps_max_latency_us, (unsigned long)S32_MAX));
 
 	nvme_fault_inject_init(&ctrl->fault_inject, dev_name(ctrl->device));
+	nvme_mpath_init_ctrl(ctrl);
 
 	return 0;
 out_free_name:
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 0551796517e6..deb14562c96a 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -781,9 +781,18 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 	put_disk(head->disk);
 }
 
-int nvme_mpath_init(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
+void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl)
 {
-	int error;
+	mutex_init(&ctrl->ana_lock);
+	timer_setup(&ctrl->anatt_timer, nvme_anatt_timeout, 0);
+	INIT_WORK(&ctrl->ana_work, nvme_ana_work);
+}
+
+int nvme_mpath_init_identify(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
+{
+	size_t max_transfer_size = ctrl->max_hw_sectors << SECTOR_SHIFT;
+	size_t ana_log_size;
+	int error = 0;
 
 	/* check if multipath is enabled and we have the capability */
 	if (!multipath || !ctrl->subsys ||
@@ -795,37 +804,31 @@ int nvme_mpath_init(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	ctrl->nanagrpid = le32_to_cpu(id->nanagrpid);
 	ctrl->anagrpmax = le32_to_cpu(id->anagrpmax);
 
-	mutex_init(&ctrl->ana_lock);
-	timer_setup(&ctrl->anatt_timer, nvme_anatt_timeout, 0);
-	ctrl->ana_log_size = sizeof(struct nvme_ana_rsp_hdr) +
-		ctrl->nanagrpid * sizeof(struct nvme_ana_group_desc);
-	ctrl->ana_log_size += ctrl->max_namespaces * sizeof(__le32);
-
-	if (ctrl->ana_log_size > ctrl->max_hw_sectors << SECTOR_SHIFT) {
+	ana_log_size = sizeof(struct nvme_ana_rsp_hdr) +
+		ctrl->nanagrpid * sizeof(struct nvme_ana_group_desc) +
+		ctrl->max_namespaces * sizeof(__le32);
+	if (ana_log_size > max_transfer_size) {
 		dev_err(ctrl->device,
-			"ANA log page size (%zd) larger than MDTS (%d).\n",
-			ctrl->ana_log_size,
-			ctrl->max_hw_sectors << SECTOR_SHIFT);
+			"ANA log page size (%zd) larger than MDTS (%zd).\n",
+			ana_log_size, max_transfer_size);
 		dev_err(ctrl->device, "disabling ANA support.\n");
-		return 0;
+		goto out_uninit;
 	}
-
-	INIT_WORK(&ctrl->ana_work, nvme_ana_work);
-	kfree(ctrl->ana_log_buf);
-	ctrl->ana_log_buf = kmalloc(ctrl->ana_log_size, GFP_KERNEL);
-	if (!ctrl->ana_log_buf) {
-		error = -ENOMEM;
-		goto out;
+	if (ana_log_size > ctrl->ana_log_size) {
+		nvme_mpath_stop(ctrl);
+		kfree(ctrl->ana_log_buf);
+		ctrl->ana_log_buf = kmalloc(ctrl->ana_log_size, GFP_KERNEL);
+		if (!ctrl->ana_log_buf)
+			return -ENOMEM;
 	}
-
+	ctrl->ana_log_size = ana_log_size;
 	error = nvme_read_ana_log(ctrl);
 	if (error)
-		goto out_free_ana_log_buf;
+		goto out_uninit;
 	return 0;
-out_free_ana_log_buf:
-	kfree(ctrl->ana_log_buf);
-	ctrl->ana_log_buf = NULL;
-out:
+
+out_uninit:
+	nvme_mpath_uninit(ctrl);
 	return error;
 }
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 05f31a2c64bb..0015860ec12b 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -712,7 +712,8 @@ void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
 void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id);
 void nvme_mpath_remove_disk(struct nvme_ns_head *head);
-int nvme_mpath_init(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id);
+int nvme_mpath_init_identify(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id);
+void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl);
 void nvme_mpath_uninit(struct nvme_ctrl *ctrl);
 void nvme_mpath_stop(struct nvme_ctrl *ctrl);
 bool nvme_mpath_clear_current_path(struct nvme_ns *ns);
@@ -780,7 +781,10 @@ static inline void nvme_mpath_check_last_path(struct nvme_ns *ns)
 static inline void nvme_trace_bio_complete(struct request *req)
 {
 }
-static inline int nvme_mpath_init(struct nvme_ctrl *ctrl,
+static inline void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl)
+{
+}
+static inline int nvme_mpath_init_identify(struct nvme_ctrl *ctrl,
 		struct nvme_id_ctrl *id)
 {
 	if (ctrl->subsys->cmic & NVME_CTRL_CMIC_ANA)

