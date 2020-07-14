Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D5521F36A
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgGNOCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:02:41 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:41645 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbgGNOCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 10:02:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 751C19BD7;
        Tue, 14 Jul 2020 10:02:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Jul 2020 10:02:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7Rwg+f
        l+reK0h4vbm8GwGnMY37XgyDmOkUKWWI/r0i4=; b=IBbA3wWyDJtRGXN0S2r6fe
        xE7mCapfGCngW+jNZ6fjeb9er+5/11F3cYEckOj5gEWXHHs/4PtPZuQq7quXX01Q
        gdv2ffIWsn/XDfR9LVP/Zl4UXm8GNH8WCK+f/T3ctMYq0G7i31kBZ6nwZlHLIKTt
        aqepCu3FFjPcp6vVV23GdvwAQsn6pt1a/mUK3DJMeqlI9ojJat8bhXNTljx1KlCe
        uoSVNg6rYxkEMC8sIhEU80kAPAcz2OFZwe58UJ875tvBcZ0eN1SE6Lq4WGuy/gEF
        dByG1/feHxL7OZ6ZXeZK67mzrDZRaKMaV9EYbPTkV4jcepL00GtE+/8UPgh6P6Gg
        ==
X-ME-Sender: <xms:_7oNX2NOx5Q-_nX7Geyl-U46QGnAEzSCz4Ehgj9m04IrQzEr4iV_2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_7oNX09ug87ds6eGR7VbTcsAVjX1DxhHpjsvi33D92YfCis4qC82xQ>
    <xmx:_7oNX9RJRS2JFnjuulhdL0JHq3UDOHx_gp1AgBwFJ-CGJkM1a4KaPA>
    <xmx:_7oNX2tTKLMiEuHrqOrLUYC8nF92TOxDrj3YLkplVhPuuZWDlIYV4A>
    <xmx:ALsNX2lNul7RWQfHrmAoHwY6ZEqpGIvS14wdyM5GuLaobc5idnTEoVDBYes>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 638A43280067;
        Tue, 14 Jul 2020 10:02:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/nouveau/nouveau: fix page fault on device private memory" failed to apply to 5.7-stable tree
To:     rcampbell@nvidia.com, bskeggs@redhat.com, jgg@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Jul 2020 16:02:38 +0200
Message-ID: <15947353588512@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ed710a6ed797430026aa5116dd0ab22378798b69 Mon Sep 17 00:00:00 2001
From: Ralph Campbell <rcampbell@nvidia.com>
Date: Fri, 26 Jun 2020 14:03:37 -0700
Subject: [PATCH] drm/nouveau/nouveau: fix page fault on device private memory

If system memory is migrated to device private memory and no GPU MMU
page table entry exists, the GPU will fault and call hmm_range_fault()
to get the PFN for the page. Since the .dev_private_owner pointer in
struct hmm_range is not set, hmm_range_fault returns an error which
results in the GPU program stopping with a fatal fault.
Fix this by setting .dev_private_owner appropriately.

Fixes: 08ddddda667b ("mm/hmm: check the device private page owner in hmm_range_fault()")
Cc: stable@vger.kernel.org
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index ba9f9359c30e..6586d9d39874 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -562,6 +562,7 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 		.end = notifier->notifier.interval_tree.last + 1,
 		.pfn_flags_mask = HMM_PFN_REQ_FAULT | HMM_PFN_REQ_WRITE,
 		.hmm_pfns = hmm_pfns,
+		.dev_private_owner = drm->dev,
 	};
 	struct mm_struct *mm = notifier->notifier.mm;
 	int ret;

