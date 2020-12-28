Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EABD2E36C4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgL1Luf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:50:35 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52193 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbgL1Luf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:50:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 228B977D;
        Mon, 28 Dec 2020 06:49:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:49:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9/2fS+
        NsNQT6KfUTYUVXid3+0kfFP0m9GiblROugShg=; b=Dyps8tww5l5z0xPkuURUho
        /5JQO+t3tN1icxoBCFYj51cR58u2OUNOGjZAC3PySddXxW4rIXvZbwleaFrvDSho
        Yr4usNVZRiuomizjawkIBMNrgpV1xTY1NnH3tFsV+pQu6HqZW997zUNl1kenqwtB
        2qDzrsTiorXicvmihM7CzanUHEGkeJDKzWsEIEdGQpNBfMy0yyLAlCiqdQYIr/TE
        da/PO+Y57ooArlIJV1mtxr3WAVxTSg81y+ZMidXYQKMDOSgz+I/BF4HapsU3pKlm
        7pjUHVQbM+cLMYJ4XU2jr5TlThVN7CKcxsmpPpIBp6Iw7IomsGGJRGnN2o89drqw
        ==
X-ME-Sender: <xms:XMbpX34RqhcgsaNX8Bgt70XxXXyP6ultVplqlM2VTYPxVVSDLIoKng>
    <xme:XMbpX87CPovsZA07VH338TDaDGJejZ_lKdJwqsibpQAN6Y5myI0gXGMzbcbwzin1U
    p5IQeVrWXna-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:XMbpX-ddBt6uVDuODg0ECdwu6ZTfoln1_wp1kF9xKmRPCsJEPu7OZw>
    <xmx:XMbpX4Lx6mgrX23do2no7MuCEsotUZ1LWBvKfM3MhkSNJUta1tP35g>
    <xmx:XMbpX7JkH13fRHrDjuXqNoYUFlABJCJvPYtNERd7NJalyckdl87eEQ>
    <xmx:XMbpXyWWG1lPiDrSXwBCBZ6zvrSzf0g30Goa-Cucm10SWSgSPX7YKfzT3hc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D54141080057;
        Mon, 28 Dec 2020 06:49:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] libnvdimm/namespace: Fix reaping of invalidated" failed to apply to 4.9-stable tree
To:     dan.j.williams@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, stable@vger.kernel.org,
        vishal.l.verma@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:51:10 +0100
Message-ID: <160915627095183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 2dd2a1740ee19cd2636d247276cf27bfa434b0e2 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Nov 2020 08:50:07 -0800
Subject: [PATCH] libnvdimm/namespace: Fix reaping of invalidated
 block-window-namespace labels

A recent change to ndctl to attempt to reconfigure namespaces in place
uncovered a label accounting problem in block-window-type namespaces.
The ndctl "create.sh" test is able to trigger this signature:

 WARNING: CPU: 34 PID: 9167 at drivers/nvdimm/label.c:1100 __blk_label_update+0x9a3/0xbc0 [libnvdimm]
 [..]
 RIP: 0010:__blk_label_update+0x9a3/0xbc0 [libnvdimm]
 [..]
 Call Trace:
  uuid_store+0x21b/0x2f0 [libnvdimm]
  kernfs_fop_write+0xcf/0x1c0
  vfs_write+0xcc/0x380
  ksys_write+0x68/0xe0

When allocated capacity for a namespace is renamed (new UUID) the labels
with the old UUID need to be deleted. The ndctl behavior to always
destroy namespaces on reconfiguration hid this problem.

The immediate impact of this bug is limited since block-window-type
namespaces only seem to exist in the specification and not in any
shipping products. However, the label handling code is being reused for
other technologies like CXL region labels, so there is a benefit to
making sure both vertical labels sets (block-window) and horizontal
label sets (pmem) have a functional reference implementation in
libnvdimm.

Fixes: c4703ce11c23 ("libnvdimm/namespace: Fix label tracking error")
Cc: <stable@vger.kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 47a4828b8b31..6f2be7a34598 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -980,6 +980,15 @@ static int __blk_label_update(struct nd_region *nd_region,
 		}
 	}
 
+	/* release slots associated with any invalidated UUIDs */
+	mutex_lock(&nd_mapping->lock);
+	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list)
+		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags)) {
+			reap_victim(nd_mapping, label_ent);
+			list_move(&label_ent->list, &list);
+		}
+	mutex_unlock(&nd_mapping->lock);
+
 	/*
 	 * Find the resource associated with the first label in the set
 	 * per the v1.2 namespace specification.

