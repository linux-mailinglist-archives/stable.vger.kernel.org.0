Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B99D261271
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 16:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgIHN6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 09:58:31 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:52125 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729397AbgIHN6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 09:58:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 77EF3BEF;
        Tue,  8 Sep 2020 08:36:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 08:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=L8Itfg
        IKXcUngmivLvILiUbXvw2g4utZfVMWy9ZbKK8=; b=rZbOu02qGDgvbfV1FGa6Ow
        rfUylTh/e9XtcfFI5FqMYzem2bQeeqzkKEdjdUWl9cf7ll4cBqj9qv4v0Y38OusI
        0eqjbWAcFwe2iKu+k6pnzS2tWNfjO0eOfWPyF49Gjkq4DTApk1SSNR1M8cQu0fLm
        fjee2PtTemxa/q2HXsotiA3CKhnHLOW08e90RlMzP7QUyKmrHYMHvKBr5GE3KSRH
        cg54pUPHugtVkv9iKGSPDyAEV2nZAbo/iD641HvAFrDNuzNqU7SfIFd69xbPrB01
        +rdzqzitCbNHSvLA/QzxCpmcRsrs6UPrqTDYfTmgGIJzCpvhj9sSlH9npK4kPpmg
        ==
X-ME-Sender: <xms:wnpXX2apS9S8SOpRL2S5xLtS7KkVKev45-CiiRyC2ML7a_DWSPHUqw>
    <xme:wnpXX5bgZkQAsz5StcA74LYqZ95O8JLMpL0QcKzNkdpsQ-nLAp4CXQcRtTUZjGji8
    trnu3ybG-MkxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:w3pXXw-8PKOgsTUby_Mz6Ed2V_QT-5kYHro23QE_wRG2RW8hTAEJqQ>
    <xmx:w3pXX4r4iLa4mOO52APbGm7WDsWZhl_YM-q8xJynEO2v7XrwlX9t6g>
    <xmx:w3pXXxqTGc_I0NrWbfzZv8dgJk_UNr69AL3YaSvDgrckJkDjSlVzJQ>
    <xmx:w3pXXyc0LiwSKfIMzbmQfqzkHQG1lW5zioUtDLj4HMAOTQhZTS3nWvGKcKk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB13F328005A;
        Tue,  8 Sep 2020 08:36:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Clear the repeater bit on HDCP disable" failed to apply to 5.4-stable tree
To:     seanpaul@chromium.org, chris@chris-wilson.co.uk,
        daniel.vetter@ffwll.ch, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        ramalingam.c@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 14:36:31 +0200
Message-ID: <159956859195159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 57537b4e1d37002ed8cbd0a9be082104749e9d8f Mon Sep 17 00:00:00 2001
From: Sean Paul <seanpaul@chromium.org>
Date: Tue, 18 Aug 2020 11:38:50 -0400
Subject: [PATCH] drm/i915: Clear the repeater bit on HDCP disable

On HDCP disable, clear the repeater bit. This ensures if we connect a
non-repeater sink after a repeater, the bit is in the state we expect.

Fixes: ee5e5e7a5e0f ("drm/i915: Add HDCP framework + base implementation")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.17+
Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Ramalingam C <ramalingam.c@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200818153910.27894-3-sean@poorly.run
(cherry picked from commit 2cc0c7b520bf8ea20ec42285d4e3d37b467eb7f9)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index 6189b7583277..1a0d49af2a08 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -795,6 +795,7 @@ static int _intel_hdcp_disable(struct intel_connector *connector)
 	struct intel_hdcp *hdcp = &connector->hdcp;
 	enum port port = dig_port->base.port;
 	enum transcoder cpu_transcoder = hdcp->cpu_transcoder;
+	u32 repeater_ctl;
 	int ret;
 
 	drm_dbg_kms(&dev_priv->drm, "[%s:%d] HDCP is being disabled...\n",
@@ -810,6 +811,11 @@ static int _intel_hdcp_disable(struct intel_connector *connector)
 		return -ETIMEDOUT;
 	}
 
+	repeater_ctl = intel_hdcp_get_repeater_ctl(dev_priv, cpu_transcoder,
+						   port);
+	intel_de_write(dev_priv, HDCP_REP_CTL,
+		       intel_de_read(dev_priv, HDCP_REP_CTL) & ~repeater_ctl);
+
 	ret = hdcp->shim->toggle_signalling(dig_port, false);
 	if (ret) {
 		drm_err(&dev_priv->drm, "Failed to disable HDCP signalling\n");

