Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5A41A7F68
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389386AbgDNOSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:18:00 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45013 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389381AbgDNOR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 10:17:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 725F6A6C;
        Tue, 14 Apr 2020 10:17:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 10:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lTr8Yv
        vKgsJOdbQZNnXWW6z/KPrKiCFvX5Whdq9ABc8=; b=DAJMm0ZJF5fqyrTZkNpciv
        eqxaVVuZ2tWMbzDVIrfEZUtHug83nsdGdUQDccmK+2b4Lp2qWNVfqOvUZqrQZzIt
        hceIyVJSBhbVQZQepNbmp7FNWqQD+xvFF0RHvVr5oIxf1tquoBRtIBhDpPLtTQ9+
        nc1lMbxHxyQ+moinNUjo7c8GwGA1Scisv6s1XBwmWVJ/Vm/yDs208ysWNxRLjIvd
        +FIDGo8L9yl11kUxvEpbHdVERNgH6XnLsXUT5eh4WkfSTQBSpEYXppH5/VQqvdph
        jvVC1I9Mln+weX/XAL2fOL92NuyYPURwqbRx7rAW+1rgG9G+JzaMzPnOSbyrLi0Q
        ==
X-ME-Sender: <xms:FMaVXmwzBNWESlMmkXssqyD6JRmug4XpL5L8WHbrzLgNwNoZmMZmSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:FMaVXu9Hb1jFEZDfwEcIyVs_zYgaBCa67jnJq5NWJbLu5EKK95aI2g>
    <xmx:FMaVXhawwZATCrpOe6jJC58So89BEzM3Ol6Ip-slyLC18t3rT_bIkQ>
    <xmx:FMaVXhjrK3Gb6RhFz-bQ5NYH6j6-StLpsuRF7zZbB_AI8yyR5-goTg>
    <xmx:FcaVXqhNhCQkGIr_sV1KgXX5VHHzbHhd-8jsv7T4S-zhWrfXKX08EA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E9C83280065;
        Tue, 14 Apr 2020 10:17:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] remoteproc: qcom_q6v5_mss: Don't reassign mpss region on" failed to apply to 4.19-stable tree
To:     bjorn.andersson@linaro.org, sibis@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 16:17:55 +0200
Message-ID: <15868738752305@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 900fc60df22748dbc28e4970838e8f7b8f1013ce Mon Sep 17 00:00:00 2001
From: Bjorn Andersson <bjorn.andersson@linaro.org>
Date: Thu, 5 Mar 2020 01:17:27 +0530
Subject: [PATCH] remoteproc: qcom_q6v5_mss: Don't reassign mpss region on
 shutdown

Trying to reclaim mpss memory while the mba is not running causes the
system to crash on devices with security fuses blown, so leave it
assigned to the remote on shutdown and recover it on a subsequent boot.

Fixes: 6c5a9dc2481b ("remoteproc: qcom: Make secure world call for mem ownership switch")
Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20200304194729.27979-2-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index a1cc9cbe038f..9fed1b1c203d 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1001,11 +1001,6 @@ static void q6v5_mba_reclaim(struct q6v5 *qproc)
 		writel(val, qproc->reg_base + QDSP6SS_PWR_CTL_REG);
 	}
 
-	ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
-				      false, qproc->mpss_phys,
-				      qproc->mpss_size);
-	WARN_ON(ret);
-
 	q6v5_reset_assert(qproc);
 
 	q6v5_clk_disable(qproc->dev, qproc->reset_clks,
@@ -1095,6 +1090,14 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
 			max_addr = ALIGN(phdr->p_paddr + phdr->p_memsz, SZ_4K);
 	}
 
+	/**
+	 * In case of a modem subsystem restart on secure devices, the modem
+	 * memory can be reclaimed only after MBA is loaded. For modem cold
+	 * boot this will be a nop
+	 */
+	q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm, false,
+				qproc->mpss_phys, qproc->mpss_size);
+
 	mpss_reloc = relocate ? min_addr : qproc->mpss_phys;
 	qproc->mpss_reloc = mpss_reloc;
 	/* Load firmware segments */
@@ -1184,8 +1187,16 @@ static void qcom_q6v5_dump_segment(struct rproc *rproc,
 	void *ptr = rproc_da_to_va(rproc, segment->da, segment->size);
 
 	/* Unlock mba before copying segments */
-	if (!qproc->dump_mba_loaded)
+	if (!qproc->dump_mba_loaded) {
 		ret = q6v5_mba_load(qproc);
+		if (!ret) {
+			/* Reset ownership back to Linux to copy segments */
+			ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
+						      false,
+						      qproc->mpss_phys,
+						      qproc->mpss_size);
+		}
+	}
 
 	if (!ptr || ret)
 		memset(dest, 0xff, segment->size);
@@ -1196,8 +1207,14 @@ static void qcom_q6v5_dump_segment(struct rproc *rproc,
 
 	/* Reclaim mba after copying segments */
 	if (qproc->dump_segment_mask == qproc->dump_complete_mask) {
-		if (qproc->dump_mba_loaded)
+		if (qproc->dump_mba_loaded) {
+			/* Try to reset ownership back to Q6 */
+			q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
+						true,
+						qproc->mpss_phys,
+						qproc->mpss_size);
 			q6v5_mba_reclaim(qproc);
+		}
 	}
 }
 
@@ -1237,10 +1254,6 @@ static int q6v5_start(struct rproc *rproc)
 	return 0;
 
 reclaim_mpss:
-	xfermemop_ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
-						false, qproc->mpss_phys,
-						qproc->mpss_size);
-	WARN_ON(xfermemop_ret);
 	q6v5_mba_reclaim(qproc);
 
 	return ret;

