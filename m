Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 076A3811DA
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfHEF6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:58:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57263 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727300AbfHEF6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:58:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 14A902151C;
        Mon,  5 Aug 2019 01:58:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+sg7FZ
        Kc7n4zoUMJUAAbgNKGzITxDi+g/nJqg4U7HX8=; b=bq3e1oyv+r7Rf3BFjzEs8p
        WWd3BOUDZUqGQGHqqghRC44iwzaWDD5WOPsvDcJJOqvyXWCLrkenp3vnLKSvqBkf
        +hdbp5WiHAS6hziqHKyhE/U4yJpSbd51uPnwiQVylB4KK5FBXrOwO8vtWWuq+Oue
        nxjueBTZoQN4ooFiNHyBggzjIpnA2o3wBn+VfXDW3Sz1EqIZnmVDQu21MH+vqQiM
        AArvvNDf7GaFddk0nOEVSpbVctfNrjpQTcGD25lvGXXgOrMLWIeRpSxJxxu4B+QJ
        xlggra6Md/9Xfzuf/smWO3ZDo9Qsmp9TacQUZgV/ma+4QsCvIPTz7lQAf1/0+X/A
        ==
X-ME-Sender: <xms:c8VHXcs9ZqiJUahzZ_eAV_7lTOp3H0CE6WO8VeiYIZZ6-nt-5o8Iig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgpdhkvghrnhgvlhdroh
    hrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:c8VHXSTu8JrxTvRGHUvpvHu7UdNUsiHkJIFxbDziFQo84EsxdmXIsw>
    <xmx:c8VHXeEFI8MfbF9hgfnhZZAzy9QQY1lXyuGExvgovJPLPhu7gmmgAQ>
    <xmx:c8VHXV0cKghUyE7N-oJlhXkeW6VwxDMy0DMP_8bedzAeOr929AixwA>
    <xmx:dMVHXbCm5QOerEnYb6A7sVGJgm_VcXicalOfx0C8OoCM3cqL04UJQQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 66A0280059;
        Mon,  5 Aug 2019 01:58:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/vbt: Fix VBT parsing for the PSR section" failed to apply to 5.2-stable tree
To:     dhinakaran.pandiyan@intel.com, jani.nikula@intel.com,
        jose.souza@intel.com, kubrick@fgv6.net, rodrigo.vivi@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:58:10 +0200
Message-ID: <156498469082135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 6d61f716a01ec0e134de38ae97e71d6fec5a6ff6 Mon Sep 17 00:00:00 2001
From: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Date: Wed, 17 Jul 2019 15:34:51 -0700
Subject: [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR section
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A single 32-bit PSR2 training pattern field follows the sixteen element
array of PSR table entries in the VBT spec. But, we incorrectly define
this PSR2 field for each of the PSR table entries. As a result, the PSR1
training pattern duration for any panel_type != 0 will be parsed
incorrectly. Secondly, PSR2 training pattern durations for VBTs with bdb
version >= 226 will also be wrong.

Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: stable@vger.kernel.org
Cc: stable@vger.kernel.org #v5.2
Fixes: 88a0d9606aff ("drm/i915/vbt: Parse and use the new field with PSR2 TP2/3 wakeup time")
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111088
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204183
Signed-off-by: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Tested-by: François Guerraz <kubrick@fgv6.net>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190717223451.2595-1-dhinakaran.pandiyan@intel.com
(cherry picked from commit b5ea9c9337007d6e700280c8a60b4e10d070fb53)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index c4710889cb32..3ef4e9f573cf 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -765,7 +765,7 @@ parse_psr(struct drm_i915_private *dev_priv, const struct bdb_header *bdb)
 	}
 
 	if (bdb->version >= 226) {
-		u32 wakeup_time = psr_table->psr2_tp2_tp3_wakeup_time;
+		u32 wakeup_time = psr->psr2_tp2_tp3_wakeup_time;
 
 		wakeup_time = (wakeup_time >> (2 * panel_type)) & 0x3;
 		switch (wakeup_time) {
diff --git a/drivers/gpu/drm/i915/display/intel_vbt_defs.h b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
index 2f4894e9a03d..5ddbe71ab423 100644
--- a/drivers/gpu/drm/i915/display/intel_vbt_defs.h
+++ b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
@@ -478,13 +478,13 @@ struct psr_table {
 	/* TP wake up time in multiple of 100 */
 	u16 tp1_wakeup_time;
 	u16 tp2_tp3_wakeup_time;
-
-	/* PSR2 TP2/TP3 wakeup time for 16 panels */
-	u32 psr2_tp2_tp3_wakeup_time;
 } __packed;
 
 struct bdb_psr {
 	struct psr_table psr_table[16];
+
+	/* PSR2 TP2/TP3 wakeup time for 16 panels */
+	u32 psr2_tp2_tp3_wakeup_time;
 } __packed;
 
 /*

