Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9497C89214
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 16:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfHKOz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 10:55:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45049 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726453AbfHKOz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 10:55:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2D05221650;
        Sun, 11 Aug 2019 10:55:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Aug 2019 10:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0Vxzwz
        bu0GLbT5BPXm39XutfusOuhuwfJid0X8t9SeY=; b=BGeCMlunyX3foerNIEpIYk
        3VhLGSwAcQE11ZlfbepSfudwVj3AQ3t3sQzEDnGJcefYSQbphfEwU8MwkbPU0IvY
        6BtBMq4t6oAye+TDZmtS/cgcLjnMgSzsoXAlGVgN0wwLE2LHq/Q97ZroZbOKCLvd
        jO98I7Ou+2oW0JBwsnnml1NuGXARwWz/Mc0xSUaKt7umjWqZ6eKFvcMeOyrJgcA0
        89mLPsAziPWFH6eVCnB/5vEXnFIp8Qb0zgj8DB6cGjdO1o09N8cjMqaRMC4wHALO
        p6S7ud1SgMBfpwJASigxc/p/MZ4bpoHh7rk66YfFp+WkEPVeRMY1KGne6omawJeQ
        ==
X-ME-Sender: <xms:eixQXQ_xQSQ2RhGSR2oYdPDOlUs0ZXfCIJ9Vy4cv2kmPxWc0I1TuqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvvddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpegrthhtrhdrnhgrmhgvpdhkvghrnhgvlhdrohhrghenucfkph
    epkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvghes
    khhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:eixQXdrSB_jOWFIVsszCm118BHDuhHOPKciyz1IlSXYQUn1gdr1LEw>
    <xmx:eixQXaTSPJFnY4l1A55Wzs2l3icigl9hEEhQeN9TT_2UYnlFwHKPpg>
    <xmx:eixQXQO-9vStWRMds7_yF-sQCDIzryKPNBBdEtTWDss5OOBQI9MUpA>
    <xmx:eyxQXckNDnBkMYiJ-paSovrgR3lt6dHkV6J6VshDlOk46JzB5nYhsg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4BD508005C;
        Sun, 11 Aug 2019 10:55:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] coresight: Fix DEBUG_LOCKS_WARN_ON for uninitialized" failed to apply to 5.2-stable tree
To:     suzuki.poulose@arm.com, gregkh@linuxfoundation.org,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Aug 2019 16:55:52 +0200
Message-ID: <1565535352123167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5511c0c309db4c526a6e9f8b2b8a1483771574bc Mon Sep 17 00:00:00 2001
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Date: Thu, 1 Aug 2019 11:23:23 -0600
Subject: [PATCH] coresight: Fix DEBUG_LOCKS_WARN_ON for uninitialized
 attribute

While running the linux-next with CONFIG_DEBUG_LOCKS_ALLOC enabled,
I get the following splat.

 BUG: key ffffcb5636929298 has not been registered!
 ------------[ cut here ]------------
 DEBUG_LOCKS_WARN_ON(1)
 WARNING: CPU: 1 PID: 53 at kernel/locking/lockdep.c:3669 lockdep_init_map+0x164/0x1f0
 CPU: 1 PID: 53 Comm: kworker/1:1 Tainted: G        W         5.2.0-next-20190712-00015-g00ad4634222e-dirty #603
 Workqueue: events amba_deferred_retry_func
 pstate: 60c00005 (nZCv daif +PAN +UAO)
 pc : lockdep_init_map+0x164/0x1f0
 lr : lockdep_init_map+0x164/0x1f0

 [ trimmed ]

 Call trace:
  lockdep_init_map+0x164/0x1f0
  __kernfs_create_file+0x9c/0x158
  sysfs_add_file_mode_ns+0xa8/0x1d0
  sysfs_add_file_to_group+0x88/0xd8
  etm_perf_add_symlink_sink+0xcc/0x138
  coresight_register+0x110/0x280
  tmc_probe+0x160/0x420

 [ trimmed ]

 ---[ end trace ab4cc669615ba1b0 ]---

Fix this by initialising the dynamically allocated attribute properly.

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Fixes: bb8e370bdc14 ("coresight: perf: Add "sinks" group to PMU directory")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[Fixed a typograhic error in the changelog]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20190801172323.18359-2-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index 5c1ca0df5cb0..84f1dcb69827 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -544,6 +544,7 @@ int etm_perf_add_symlink_sink(struct coresight_device *csdev)
 	/* See function coresight_get_sink_by_id() to know where this is used */
 	hash = hashlen_hash(hashlen_string(NULL, name));
 
+	sysfs_attr_init(&ea->attr.attr);
 	ea->attr.attr.name = devm_kstrdup(dev, name, GFP_KERNEL);
 	if (!ea->attr.attr.name)
 		return -ENOMEM;

