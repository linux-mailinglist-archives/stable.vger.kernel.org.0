Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAAD817A2
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 12:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfHEKze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 06:55:34 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34319 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727158AbfHEKzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 06:55:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D4FA21785;
        Mon,  5 Aug 2019 06:55:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 06:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SzmGll
        cDDVzce+r/2Q3VWiIzlS8VfsJYgtdv99j/t08=; b=RfjMIMbqCxr3evY5tNgaTQ
        z9AFTqnAnfFwgPnexAwIDciyW70KO+TFaS+WuUnrhM70o51SOTUoGaMnU8qHOIzr
        7EngFpgiEn63gxdPyAZWx6yDHPcsppl1xJ9seNYRY/NknJixeIPHuLbUTO5ceZKM
        jANIdpARDAuWv9hY7apAzGgK+ofXM6Cw7J+aZVQVAgtwojXiCdemQM2XAmpmuKvi
        AZ2G0wz2vHB/PwTT7emGm85n+FYPKxr1ldOED9Q2oE3QREY4JPwaCkBoNQlaXeEu
        lTidypAFsPfeNEW0ENRSgel/zYvJjT5FEScfTwcfSlgg6fz2tbtq9M/vFgg8AI1Q
        ==
X-ME-Sender: <xms:IwtIXdLguE4diKtsnf-0MBi85qVGg3HbbxbiATPrFaRbABKKrWKLhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtjedgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:IwtIXTMKFqPlh_EvVjrDPGt_RkDQGCSAkBpVcv4wdgfDL-UBlipvJA>
    <xmx:IwtIXYmCDS_klaaRVacJ6TvYZTHZEReq8lwq1fewTSOT7kgZsaRY9Q>
    <xmx:IwtIXWWVuBnYp2Y3eUumkQWjz4qMYaYQFrVxJ9Ke2OpKx5TP9uW2_Q>
    <xmx:JAtIXeAGA7PBm9__dCvEYMTqaHvWp6nnKcjpMJg-J9EdjNCEAoARJA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9CC9F80064;
        Mon,  5 Aug 2019 06:55:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/perf: fix ICL perf register offsets" failed to apply to 4.19-stable tree
To:     lionel.g.landwerlin@intel.com, jani.nikula@intel.com,
        kenneth@whitecape.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 12:55:29 +0200
Message-ID: <156500252979126@kroah.com>
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

From 95eef14cdad150fed43147bcd4f29eea3d0a3f03 Mon Sep 17 00:00:00 2001
From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Date: Mon, 10 Jun 2019 11:19:14 +0300
Subject: [PATCH] drm/i915/perf: fix ICL perf register offsets

We got the wrong offsets (could they have changed?). New values were
computed off an error state by looking up the register offset in the
context image as written by the HW.

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Fixes: 1de401c08fa805 ("drm/i915/perf: enable perf support on ICL")
Cc: <stable@vger.kernel.org> # v4.18+
Acked-by: Kenneth Graunke <kenneth@whitecape.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190610081914.25428-1-lionel.g.landwerlin@intel.com
(cherry picked from commit 8dcfdfb4501012a8d36d2157dc73925715f2befb)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index a700c5c3d167..1ae06a1b6749 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -3477,9 +3477,13 @@ void i915_perf_init(struct drm_i915_private *dev_priv)
 			dev_priv->perf.oa.ops.enable_metric_set = gen8_enable_metric_set;
 			dev_priv->perf.oa.ops.disable_metric_set = gen10_disable_metric_set;
 
-			dev_priv->perf.oa.ctx_oactxctrl_offset = 0x128;
-			dev_priv->perf.oa.ctx_flexeu0_offset = 0x3de;
-
+			if (IS_GEN(dev_priv, 10)) {
+				dev_priv->perf.oa.ctx_oactxctrl_offset = 0x128;
+				dev_priv->perf.oa.ctx_flexeu0_offset = 0x3de;
+			} else {
+				dev_priv->perf.oa.ctx_oactxctrl_offset = 0x124;
+				dev_priv->perf.oa.ctx_flexeu0_offset = 0x78e;
+			}
 			dev_priv->perf.oa.gen8_valid_ctx_bit = (1<<16);
 		}
 	}

