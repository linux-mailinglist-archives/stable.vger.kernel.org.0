Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E50382C49
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 14:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhEQMiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 08:38:02 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:39817 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229734AbhEQMiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 08:38:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B2E91BE8;
        Mon, 17 May 2021 08:36:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 17 May 2021 08:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6HdbuZ
        yzUFnPphgFrNd/gyjsDtU4b+s0MifpBt/0+Wo=; b=LxC3337+fI1MkqMG0zLu7x
        af3uJBEQ/AexMTuzuGvl3dHuz9s69whl4zs5sIpzteMTO1atzAK0hSVv6reQHBz/
        v141UGRE/B8BKFjOC/ADcbVfulEbyegynMQlntYovE3jxszM8JtOJLOVyRaLG29y
        WhspKpkyqzH6Qp4wqULlI69uB716B5ImrVp4TDh2nwxraoXoOsn1cW9wVSwKGKWy
        8ArNOZUGyKuHHkPcClujHZcIpsnl87SCNzBYIRDfU1Ac0lTeSIVq+4MuIkQJmvuP
        8c+p4f8/yQZ2tLUYrAn+gfOQpr67DIg4cnCKwjvRyBqe/MF6RRb3sg8dxHfIONSQ
        ==
X-ME-Sender: <xms:W2OiYCwZwDZ9iOqlukQ_brwb6usHVnB0GkNW6-GCEEGVsP__SjGilg>
    <xme:W2OiYORb7oq06tsr1VmdyoL-yGj1XzUZ72Ald_v4kZD5qayO5NXMp31rtmDIjcf9w
    9iU8r4NkfryxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:W2OiYEVQnLNxOpu0zbHjngU-YcgEjc_uCcE8BQlwPyALUBKkOrdxnA>
    <xmx:W2OiYIiXKwRwGrS9UXAEjrsAfHrEvvHNuxISMeOefi4W6z53FiCDMQ>
    <xmx:W2OiYEB5V85vk_OqDANt0E0LYVcyIeCnc4cGUZFTSwffpjAdpTwdsA>
    <xmx:XGOiYN4LuxavwHl8edMKLHY-4izn6KNBxFM0SomAcBjRbvUiRvGDMyCXnDQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 08:36:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Read C0DRB3/C1DRB3 as 16 bits again" failed to apply to 5.4-stable tree
To:     ville.syrjala@linux.intel.com, chris@chris-wilson.co.uk,
        jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 14:36:40 +0200
Message-ID: <1621255000234135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

From 04d019961fd15de92874575536310243a0d4c5c5 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Wed, 21 Apr 2021 18:33:59 +0300
Subject: [PATCH] drm/i915: Read C0DRB3/C1DRB3 as 16 bits again
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We've defined C0DRB3/C1DRB3 as 16 bit registers, so access them
as such.

Fixes: 1c8242c3a4b2 ("drm/i915: Use unchecked writes for setting up the fences")
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210421153401.13847-3-ville.syrjala@linux.intel.com
(cherry picked from commit f765a5b48c667bdada5e49d5e0f23f8c0687b21b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
index e72b7a0dc316..8a322594210c 100644
--- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
@@ -653,8 +653,8 @@ static void detect_bit_6_swizzle(struct i915_ggtt *ggtt)
 		 * banks of memory are paired and unswizzled on the
 		 * uneven portion, so leave that as unknown.
 		 */
-		if (intel_uncore_read(uncore, C0DRB3) ==
-		    intel_uncore_read(uncore, C1DRB3)) {
+		if (intel_uncore_read16(uncore, C0DRB3) ==
+		    intel_uncore_read16(uncore, C1DRB3)) {
 			swizzle_x = I915_BIT_6_SWIZZLE_9_10;
 			swizzle_y = I915_BIT_6_SWIZZLE_9;
 		}

