Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87967EDC32
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 11:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfKDKMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 05:12:41 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35471 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727320AbfKDKMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 05:12:41 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8C33721EAF;
        Mon,  4 Nov 2019 05:12:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 04 Nov 2019 05:12:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1RlZyL
        2uU/4lUzMQmuW032GoddSKeg9gldP2+P/PeTw=; b=NCZC34Tm0QTWmlmL8XTvUE
        KuxwJY6IqXzqUSSAhZ2zNCdlHASkOJsb4X78lqRqPqi9NvhkgOkKaDqICBgS3XKv
        iLTRHQqNthooRv3kZXkFOBK5NfpUToYO8V8t+JeBPHijVNuvnoBZZYs8abSkhZtq
        8xLDaXKCd4bol8ST2FtMgUO3z4UkjFCz6R9Smjo56ZJ0/0AVa+8WJTJbE0VBZqyo
        RLH2RGpqBq/e+Hi+pWhmqrEp1wGeIRcvnFVEa/5wvACvWciY6WQP2f731RNmpjsr
        GsNrAj7yC9B8DKP+T/H9xMa2ByjNeiyfl0xPrmDKkG6sQ40fUyoaleMFJlEfzv/Q
        ==
X-ME-Sender: <xms:l_m_XfLQM2iUl1TLzRRvbmSrvH1-92Z7UjS6akNRRqdZJmL7SGgemg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddufedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:l_m_XSNeSvV15Buj2kB7LsxJSp61nKoSdaR5aodCn2jUUXYfEk_o7g>
    <xmx:l_m_Xd5EDvejOT0crL5tpWesWjhFQMh9Wvu05wDw6ZG9JgQwfb7uew>
    <xmx:l_m_XU7kg3gW09xo38TaPDuODTdTTBngKWCtpjwm94MXHNzMgv9tNA>
    <xmx:mPm_Xe33UdbE_bP7WfoX5FE8BsjTrk28xWK2GzRr6Z0u80Ue718EAg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6324F8005A;
        Mon,  4 Nov 2019 05:12:39 -0500 (EST)
Subject: WTF: patch "[PATCH] drm/panfrost: fix -Wmissing-prototypes warnings" was seriously submitted to be applied to the 5.3-stable tree?
To:     wang.yi59@zte.com.cn, robh@kernel.org, steven.price@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Nov 2019 11:12:37 +0100
Message-ID: <157286235715184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.3-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6f39188c9d5f81af7a3bc687636b7abc9629ee27 Mon Sep 17 00:00:00 2001
From: Yi Wang <wang.yi59@zte.com.cn>
Date: Fri, 25 Oct 2019 09:30:15 +0800
Subject: [PATCH] drm/panfrost: fix -Wmissing-prototypes warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We get these warnings when build kernel W=1:
drivers/gpu/drm/panfrost/panfrost_perfcnt.c:35:6: warning: no previous prototype for ‘panfrost_perfcnt_clean_cache_done’ [-Wmissing-prototypes]
drivers/gpu/drm/panfrost/panfrost_perfcnt.c:40:6: warning: no previous prototype for ‘panfrost_perfcnt_sample_done’ [-Wmissing-prototypes]
drivers/gpu/drm/panfrost/panfrost_perfcnt.c:190:5: warning: no previous prototype for ‘panfrost_ioctl_perfcnt_enable’ [-Wmissing-prototypes]
drivers/gpu/drm/panfrost/panfrost_perfcnt.c:218:5: warning: no previous prototype for ‘panfrost_ioctl_perfcnt_dump’ [-Wmissing-prototypes]
drivers/gpu/drm/panfrost/panfrost_perfcnt.c:250:6: warning: no previous prototype for ‘panfrost_perfcnt_close’ [-Wmissing-prototypes]
drivers/gpu/drm/panfrost/panfrost_perfcnt.c:264:5: warning: no previous prototype for ‘panfrost_perfcnt_init’ [-Wmissing-prototypes]
drivers/gpu/drm/panfrost/panfrost_perfcnt.c:320:6: warning: no previous prototype for ‘panfrost_perfcnt_fini’ [-Wmissing-prototypes]
drivers/gpu/drm/panfrost/panfrost_mmu.c:227:6: warning: no previous prototype for ‘panfrost_mmu_flush_range’ [-Wmissing-prototypes]
drivers/gpu/drm/panfrost/panfrost_mmu.c:435:5: warning: no previous prototype for ‘panfrost_mmu_map_fault_addr’ [-Wmissing-prototypes]

For file panfrost_mmu.c, make functions static to fix this.
For file panfrost_perfcnt.c, include header file can fix this.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: stable@vger.kernel.org
[robh: fixup function parameter alignment]
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1571967015-42854-1-git-send-email-wang.yi59@zte.com.cn

diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index bdd990568476..87e7963b8adf 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -224,9 +224,9 @@ static size_t get_pgsize(u64 addr, size_t size)
 	return SZ_2M;
 }
 
-void panfrost_mmu_flush_range(struct panfrost_device *pfdev,
-			      struct panfrost_mmu *mmu,
-			      u64 iova, size_t size)
+static void panfrost_mmu_flush_range(struct panfrost_device *pfdev,
+				     struct panfrost_mmu *mmu,
+				     u64 iova, size_t size)
 {
 	if (mmu->as < 0)
 		return;
@@ -432,7 +432,8 @@ addr_to_drm_mm_node(struct panfrost_device *pfdev, int as, u64 addr)
 
 #define NUM_FAULT_PAGES (SZ_2M / PAGE_SIZE)
 
-int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as, u64 addr)
+static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
+				       u64 addr)
 {
 	int ret, i;
 	struct panfrost_gem_object *bo;
diff --git a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
index 83c57d325ca8..2dba192bf198 100644
--- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
+++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
@@ -16,6 +16,7 @@
 #include "panfrost_issues.h"
 #include "panfrost_job.h"
 #include "panfrost_mmu.h"
+#include "panfrost_perfcnt.h"
 #include "panfrost_regs.h"
 
 #define COUNTERS_PER_BLOCK		64

