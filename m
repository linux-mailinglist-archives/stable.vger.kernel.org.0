Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923F12D45F2
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgLIPyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:22 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:40897 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731232AbgLIPyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:17 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C06EA1943998;
        Wed,  9 Dec 2020 03:38:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:38:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KO0Esv
        UX01urVaTMD0UtLu7V96ypT2j5yv4KoqRQn8M=; b=egv5yEGaa33cPcS3lhSip7
        vDdLnpFli4gs+VqZhuhZ8Do4zghMGZXUwnz0DQ1FUO0W5jUaGi9OKxI9H6jPAJt+
        7JO2JQUkowgMln0K0BHnQUat3KzAeSmuwXSOY09NpwTxFWCbC4K72NUOd+j+p05Z
        34UhTPk7Y4+GgjIMrerxOBECdsPtechvjh7wAXD1/j2nzS71u56iyvuOw7XJX3hG
        xvaPOO8Hz6Bi1Z8dG4NUhJqvkXCYh9UGQIzZBQBfjmmLzuDfOc+LA1JQfnB2NZKH
        N4ss/bR+RfXQmOCQDGOVEaM435HVCcTkW+W/6H4RGK/5DjpQi+lLyezUS8Pz0nWA
        ==
X-ME-Sender: <xms:Eo3QX6WvGhA4_JELmZcQZixlMc6nxske-p6odv7K49k8C-QCj9fsJw>
    <xme:Eo3QX2kjPR_0fgc8uWq0_lY61sKqVlPrpGByBYrn2xxSKxSNmmxMRsiOp4e2jlq74
    1oB-kcToL9bUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpedvffegjeejiedtieffjeeijeffgfehvdeiudejhe
    efgeevhffhvedvfeeuheekleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Eo3QX-bBBOUAdInb6G3INb0bvh2FdNhvcwy9fEuK8mLuwE91URa0CQ>
    <xmx:Eo3QXxWfJkIsR7g_NpbFSiNlS31aaOPXTNm7QqSr2JnWhxOdbma3Uw>
    <xmx:Eo3QX0le_vaPfPZH2ezmr1dFdk8p8MyGwzBO-AKrqeXrCghbSV9ZtA>
    <xmx:Eo3QX5yLsYfdOL3irAuHcw1VbMBrC0w5Rvp7qAZ2B8LbjJoX3df8uw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 69D201080057;
        Wed,  9 Dec 2020 03:38:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Program mocs:63 for cache eviction on gen9" failed to apply to 4.9-stable tree
To:     chris@chris-wilson.co.uk, jason@jlekstrand.net,
        rodrigo.vivi@intel.com, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:39:57 +0100
Message-ID: <1607503197153151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

