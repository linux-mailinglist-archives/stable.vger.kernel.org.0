Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D992D4601
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbgLIPyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:51 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:58313 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731291AbgLIPyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3B7B01943981;
        Wed,  9 Dec 2020 03:38:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:38:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cu1XEO
        lgW377BUy9bMmgPX0LvZem52e/q4Y+AFAquHc=; b=ojq43pnaZ0d5w8ewANIjDl
        40yPIThjTpEXvEuD64tYDXz5n5uHp49cPCpsfXjjBSYOSZroVr+KB/RZZGpA+r9Q
        AfEBUxnK0P7buCbwY0u1QEDhFB/OgaNKsdJEPwdJWISszgFdeBeyriB/VB6bD8S9
        P8+2HdkDo4suKOizg9tA8kiFWbpx5fJI+/NsRiXdBZiL5MmysPEf78cFpwiZ1phG
        WbCKTqd6QkPnZfuuZJs3u6ptSPK2LhRYZvo+7P6tMKN8LfK+sr+etmsrZswT+1rB
        kb7+w0+RygAcDpBEESGOw/iYhmdLBmUclos1kcFsvOhFIADvu3DHIn6YH86mm2Kg
        ==
X-ME-Sender: <xms:EY3QX2x-munQOqgWVKW6lNX_HDoIZkZSI6e7lLtLscN02yQXvpBvEw>
    <xme:EY3QXyT44r_l2YIJg-XrJfyY8w3Qb2VwL9vb-nxnVUgcy9bU_2dvQTE-BQRiXxHQO
    8yPUBZVFG3YSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpedvffegjeejiedtieffjeeijeffgfehvdeiudejhe
    efgeevhffhvedvfeeuheekleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:EY3QX4VXJI-YP8gL14MiuBEeou51shJeS3yH_Ezya3cO3O-pnOWm5A>
    <xmx:EY3QX8gtmuLiKa_JB4WsgzU0mG_0mpwHcsX5wcI8qYSobd_X4rZS4Q>
    <xmx:EY3QX4DyauHn8KB0rU1ZhFpY9B4aIcr9HgTvNwIgmK4aReranK6LpA>
    <xmx:EY3QX7PPscRf-hiAaE98Gfa6QEWOy_wSp3LmPqiMjCDMIZeKoNGhag>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C1604240067;
        Wed,  9 Dec 2020 03:38:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Program mocs:63 for cache eviction on gen9" failed to apply to 4.14-stable tree
To:     chris@chris-wilson.co.uk, jason@jlekstrand.net,
        rodrigo.vivi@intel.com, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:39:57 +0100
Message-ID: <16075031977995@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 777a7717d60ccdc9b84f35074f848d3f746fc3bf Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 26 Nov 2020 14:08:41 +0000
Subject: [PATCH] drm/i915/gt: Program mocs:63 for cache eviction on gen9
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Ville noticed that the last mocs entry is used unconditionally by the HW
when it performs cache evictions, and noted that while the value is not
meant to be writable by the driver, we should program it to a reasonable
value nevertheless.

As it turns out, we can change the value of mocs:63 and the value we
were programming into it would cause hard hangs in conjunction with
atomic operations.

v2: Add details from bspec about how it is used by HW

Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2707
Fixes: 3bbaba0ceaa2 ("drm/i915: Added Programming of the MOCS")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: <stable@vger.kernel.org> # v4.3+
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201126140841.1982-1-chris@chris-wilson.co.uk
(cherry picked from commit 977933b5da7c16f39295c4c1d4259a58ece65dbe)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
index 313e51e7d4f7..4f74706967fd 100644
--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -131,7 +131,19 @@ static const struct drm_i915_mocs_entry skl_mocs_table[] = {
 	GEN9_MOCS_ENTRIES,
 	MOCS_ENTRY(I915_MOCS_CACHED,
 		   LE_3_WB | LE_TC_2_LLC_ELLC | LE_LRUM(3),
-		   L3_3_WB)
+		   L3_3_WB),
+
+	/*
+	 * mocs:63
+	 * - used by the L3 for all of its evictions.
+	 *   Thus it is expected to allow LLC cacheability to enable coherent
+	 *   flows to be maintained.
+	 * - used to force L3 uncachable cycles.
+	 *   Thus it is expected to make the surface L3 uncacheable.
+	 */
+	MOCS_ENTRY(63,
+		   LE_3_WB | LE_TC_1_LLC | LE_LRUM(3),
+		   L3_1_UC)
 };
 
 /* NOTE: the LE_TGT_CACHE is not used on Broxton */

