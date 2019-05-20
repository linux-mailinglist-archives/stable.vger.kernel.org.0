Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC9B231BB
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 12:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbfETKul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 06:50:41 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56963 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbfETKul (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 06:50:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 26C292463F;
        Mon, 20 May 2019 06:50:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 20 May 2019 06:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eirFIv
        XyFZ1ohjz4gnvyk6NiOG8DsJoIwlSEHW1zTRE=; b=m2wUpFHlIDojvMErcDHPCA
        SccUGfxlJqGrNgOUBbpsqANYrKlWSSpVKgLICp9Ys+miqiML+i1uRbILIxN0rhgc
        eeL6jmHgI77TlB60pYzRhiu8tpUtJ7qkfZ1zpOh2BEOHjV0hHBrKx9VfN4DwgGqT
        p14o7RjncmOsK0WACv1E9VflNNimEg86IbkCkMRuco4WfdYgRyunbJWUB69/OTXj
        8wRZ7CqDEiuMKeqdqq3h4c2TKHA5JbGU72xjfJGzz5lElU+jrPkj4UGdHTPVuVU/
        wb1YYEpd2GrXJQpUpZ6LppovNqxlWHcAFnY25qZQq7JHTX2Jos/5xfBh+SjDUbtQ
        ==
X-ME-Sender: <xms:f4biXOxP7xmIeI833z8i9_b7M9Zn4JyeHyXRQsUmHbjYcxNyEi6jNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtkedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:f4biXHwHtS6vVIp3SvCKuda8kzZFdIgBvou_I5hBFXrlOICYrKBRZw>
    <xmx:f4biXGpYCkTJlYeJRzKsQGqL-bUk4SaTDNqvd49rEm-nHbbqOLiYvA>
    <xmx:f4biXLoIf9hs86zEPfGpky6trY-1edtzLKfKrUfssZIChV477Vl6xg>
    <xmx:f4biXOcNb_JBUV9VBhkrodMME0DSInV33Yk4gzDW4puy_wtBNr0UCg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5758480059;
        Mon, 20 May 2019 06:50:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] libnvdimm/namespace: Fix label tracking error" failed to apply to 4.9-stable tree
To:     dan.j.williams@intel.com, erwin.tsaur@oracle.com,
        jane.chu@oracle.com, jmoyer@redhat.com, jthumshirn@suse.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 12:50:37 +0200
Message-ID: <155834943729195@kroah.com>
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

From c4703ce11c23423d4b46e3d59aef7979814fd608 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 Apr 2019 21:51:21 -0700
Subject: [PATCH] libnvdimm/namespace: Fix label tracking error

Users have reported intermittent occurrences of DIMM initialization
failures due to duplicate allocations of address capacity detected in
the labels, or errors of the form below, both have the same root cause.

    nd namespace1.4: failed to track label: 0
    WARNING: CPU: 17 PID: 1381 at drivers/nvdimm/label.c:863

    RIP: 0010:__pmem_label_update+0x56c/0x590 [libnvdimm]
    Call Trace:
     ? nd_pmem_namespace_label_update+0xd6/0x160 [libnvdimm]
     nd_pmem_namespace_label_update+0xd6/0x160 [libnvdimm]
     uuid_store+0x17e/0x190 [libnvdimm]
     kernfs_fop_write+0xf0/0x1a0
     vfs_write+0xb7/0x1b0
     ksys_write+0x57/0xd0
     do_syscall_64+0x60/0x210

Unfortunately those reports were typically with a busy parallel
namespace creation / destruction loop making it difficult to see the
components of the bug. However, Jane provided a simple reproducer using
the work-in-progress sub-section implementation.

When ndctl is reconfiguring a namespace it may take an existing defunct
/ disabled namespace and reconfigure it with a new uuid and other
parameters. Critically namespace_update_uuid() takes existing address
resources and renames them for the new namespace to use / reconfigure as
it sees fit. The bug is that this rename only happens in the resource
tracking tree. Existing labels with the old uuid are not reaped leading
to a scenario where multiple active labels reference the same span of
address range.

Teach namespace_update_uuid() to flag any references to the old uuid for
reaping at the next label update attempt.

Cc: <stable@vger.kernel.org>
Fixes: bf9bccc14c05 ("libnvdimm: pmem label sets and namespace instantiation")
Link: https://github.com/pmem/ndctl/issues/91
Reported-by: Jane Chu <jane.chu@oracle.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Erwin Tsaur <erwin.tsaur@oracle.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index f3d753d3169c..2030805aa216 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -756,6 +756,17 @@ static const guid_t *to_abstraction_guid(enum nvdimm_claim_class claim_class,
 		return &guid_null;
 }
 
+static void reap_victim(struct nd_mapping *nd_mapping,
+		struct nd_label_ent *victim)
+{
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	u32 slot = to_slot(ndd, victim->label);
+
+	dev_dbg(ndd->dev, "free: %d\n", slot);
+	nd_label_free_slot(ndd, slot);
+	victim->label = NULL;
+}
+
 static int __pmem_label_update(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
 		int pos, unsigned long flags)
@@ -763,9 +774,9 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	struct nd_namespace_common *ndns = &nspm->nsio.common;
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct nd_label_ent *label_ent, *victim = NULL;
 	struct nd_namespace_label *nd_label;
 	struct nd_namespace_index *nsindex;
+	struct nd_label_ent *label_ent;
 	struct nd_label_id label_id;
 	struct resource *res;
 	unsigned long *free;
@@ -834,18 +845,10 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
 		if (!label_ent->label)
 			continue;
-		if (memcmp(nspm->uuid, label_ent->label->uuid,
-					NSLABEL_UUID_LEN) != 0)
-			continue;
-		victim = label_ent;
-		list_move_tail(&victim->list, &nd_mapping->labels);
-		break;
-	}
-	if (victim) {
-		dev_dbg(ndd->dev, "free: %d\n", slot);
-		slot = to_slot(ndd, victim->label);
-		nd_label_free_slot(ndd, slot);
-		victim->label = NULL;
+		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags)
+				|| memcmp(nspm->uuid, label_ent->label->uuid,
+					NSLABEL_UUID_LEN) == 0)
+			reap_victim(nd_mapping, label_ent);
 	}
 
 	/* update index */
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index f293556cbbf6..d0214644e334 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1247,12 +1247,27 @@ static int namespace_update_uuid(struct nd_region *nd_region,
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+		struct nd_label_ent *label_ent;
 		struct resource *res;
 
 		for_each_dpa_resource(ndd, res)
 			if (strcmp(res->name, old_label_id.id) == 0)
 				sprintf((void *) res->name, "%s",
 						new_label_id.id);
+
+		mutex_lock(&nd_mapping->lock);
+		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+			struct nd_namespace_label *nd_label = label_ent->label;
+			struct nd_label_id label_id;
+
+			if (!nd_label)
+				continue;
+			nd_label_gen_id(&label_id, nd_label->uuid,
+					__le32_to_cpu(nd_label->flags));
+			if (strcmp(old_label_id.id, label_id.id) == 0)
+				set_bit(ND_LABEL_REAP, &label_ent->flags);
+		}
+		mutex_unlock(&nd_mapping->lock);
 	}
 	kfree(*old_uuid);
  out:
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index a5ac3b240293..191d62af0e51 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -113,8 +113,12 @@ struct nd_percpu_lane {
 	spinlock_t lock;
 };
 
+enum nd_label_flags {
+	ND_LABEL_REAP,
+};
 struct nd_label_ent {
 	struct list_head list;
+	unsigned long flags;
 	struct nd_namespace_label *label;
 };
 

