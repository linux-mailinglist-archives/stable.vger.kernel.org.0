Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1AA2186B4E
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 13:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbgCPMoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 08:44:13 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53661 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731011AbgCPMoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 08:44:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B02F486C;
        Mon, 16 Mar 2020 08:44:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 08:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TsLlKD
        S64sVW1+ux8KExEGPqFA4RuBHFSHoJgOhrF2E=; b=tctyPycczmRUqwmsrpEfMw
        vkJQ4V7XmxadfsOxDFs0kl+ESbC1DcdrRHPCk5xRxttmRcDAtkt95raLWXoTVSHo
        rsJD/B9qP4tQw6FOTJPpyxRaOGOjaSrR8tL334cu6M0GpwbWWIui8RGpk11ME9p8
        2/5KT4nNpMHf22vw6aFMfHx9Nt/CKz30h8ABqnH9siruuCkllksujdIGk92Q/fU2
        fuNvDzsEjZDQxpL+1hVr7bSSuE4e2FxRmPGFNStAOm93x7a77Rs9j47iujmuiCrY
        R8Vm2tItHY2Yz/gSSsfj/alia8Hs/trnAE7hUDMdY4CHgmFOj7/DL9DI60IKSVQw
        ==
X-ME-Sender: <xms:mnRvXicn6Z8OADR8m-eaYujyrgp6jt5nanYa5GuIkFRkz6JTIBQkZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:mnRvXk20OBzlMrhGmHG1I4wQTWAwo7o2kK93bqTVcR_DB0KkSBURaQ>
    <xmx:mnRvXn_IXw0KselivRaxOGhnXeyLZvkX3xtWQdXAbFrqbfuEPADLdw>
    <xmx:mnRvXjejzUvTnREJ4Iq39TKlC63RJ5UO62XeZVlRN53o4jxX_S2Yqg>
    <xmx:m3RvXiLAhX7YPTqYQYYU3C6u8k7HPQs3DzhP0c1ryETNx1wP38v71g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 92C42328006B;
        Mon, 16 Mar 2020 08:44:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Close race between cacheline_retire and free" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        matthew.auld@intel.com, mika.kuoppala@linux.intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 13:44:08 +0100
Message-ID: <1584362648224144@kroah.com>
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

From 8ea6bb8e4d47e07518e5dba4f5cb77e210f0df82 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Fri, 6 Mar 2020 15:46:47 +0000
Subject: [PATCH] drm/i915/gt: Close race between cacheline_retire and free

If the cacheline may still be busy, atomically mark it for future
release, and only if we can determine that it will never be used again,
immediately free it.

Closes: https://gitlab.freedesktop.org/drm/intel/issues/1392
Fixes: ebece7539242 ("drm/i915: Keep timeline HWSP allocated until idle across the system")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
Link: https://patchwork.freedesktop.org/patch/msgid/20200306154647.3528345-1-chris@chris-wilson.co.uk
(cherry picked from commit 2d4bd971f5baa51418625f379a69f5d58b5a0450)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index 87716529cd2f..d8d9f1179c2b 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -192,11 +192,15 @@ static void cacheline_release(struct intel_timeline_cacheline *cl)
 
 static void cacheline_free(struct intel_timeline_cacheline *cl)
 {
+	if (!i915_active_acquire_if_busy(&cl->active)) {
+		__idle_cacheline_free(cl);
+		return;
+	}
+
 	GEM_BUG_ON(ptr_test_bit(cl->vaddr, CACHELINE_FREE));
 	cl->vaddr = ptr_set_bit(cl->vaddr, CACHELINE_FREE);
 
-	if (i915_active_is_idle(&cl->active))
-		__idle_cacheline_free(cl);
+	i915_active_release(&cl->active);
 }
 
 int intel_timeline_init(struct intel_timeline *timeline,

