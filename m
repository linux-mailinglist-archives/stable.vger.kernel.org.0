Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5530C1AA3CA
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506130AbgDONMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:12:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49297 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2897056AbgDOLfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:35:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 799455C01BB;
        Wed, 15 Apr 2020 07:35:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:35:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/mM2SU
        3DNTrULjipI3B4lHu8dUK8WJ25IzRa0RC8JYg=; b=yljTMeUo8VPKKTwJp9iKPL
        oNfXNQqusK2vHh/WWWUhQdoF0DDR9SN2JwBqDaqAzMNfhKF2LJkeeBTUArX2/Avc
        +p5EH6+6ay52fAee+cSkWyXxQxpdfh2iVgX8QYaqjt2jcDyHl837PJt64uAHpiYI
        4n6OWxU0q4tqEMaz5AgKwaGDw88ngPh0YikXCtmhGZpmOYJZ5gm55AQ+7nDYY7Ys
        wI4hiA+PgnokRD8VHjyi2pbT0SWUGdSUVr7wLetWCP/oaztah2OExbcVLv1o8VFN
        7O0V71i/er/FwfNjAcuwKsFhWJZ8C5d9qoneKU1k91jwttAGnPiNaE/6JvP9K9hw
        ==
X-ME-Sender: <xms:g_GWXpOeDHMQL8tGnicKaZjnU9i1xKJZ0DbFHChb-wTGrZmWU_ctCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:g_GWXncpbp96rHioCDZRifE14Tu0uK78dtoSuB1D3xl5APu__vLLgA>
    <xmx:g_GWXuu7fcynl4QtC1QulMwMa86KUuv6Q_7JLtPxrmAzTFblduB8wQ>
    <xmx:g_GWXgniF0R4BuLjdwr5Ab55XS0RyObZKS16ZtTMyX2JZJIlHbxPMg>
    <xmx:g_GWXqX_1rJiXaL-v8pONKOG_WC63Xxotzq0gqOLkUupzj9yDKff2Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 13C6D3280067;
        Wed, 15 Apr 2020 07:35:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/icl+: Don't enable DDI IO power on a TypeC port in" failed to apply to 5.4-stable tree
To:     imre.deak@intel.com, jose.souza@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:35:21 +0200
Message-ID: <158695052113996@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 6e8a36c13382b7165d23928caee8d91c1b301142 Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Mon, 30 Mar 2020 18:22:44 +0300
Subject: [PATCH] drm/i915/icl+: Don't enable DDI IO power on a TypeC port in
 TBT mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The DDI IO power well must not be enabled for a TypeC port in TBT mode,
ensure this during driver loading/system resume.

This gets rid of error messages like
[drm] *ERROR* power well DDI E TC2 IO state mismatch (refcount 1/enabled 0)

and avoids leaking the power ref when disabling the output.

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200330152244.11316-1-imre.deak@intel.com
(cherry picked from commit f77a2db27f26c3ccba0681f7e89fef083718f07f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 73d0f4648c06..5202fdec8e0a 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -1869,7 +1869,11 @@ static void intel_ddi_get_power_domains(struct intel_encoder *encoder,
 		return;
 
 	dig_port = enc_to_dig_port(encoder);
-	intel_display_power_get(dev_priv, dig_port->ddi_io_power_domain);
+
+	if (!intel_phy_is_tc(dev_priv, phy) ||
+	    dig_port->tc_mode != TC_PORT_TBT_ALT)
+		intel_display_power_get(dev_priv,
+					dig_port->ddi_io_power_domain);
 
 	/*
 	 * AUX power is only needed for (e)DP mode, and for HDMI mode on TC

