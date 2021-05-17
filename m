Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF88B382C5A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 14:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237055AbhEQMkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 08:40:51 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:53429 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237044AbhEQMkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 08:40:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 265A3C53;
        Mon, 17 May 2021 08:39:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 May 2021 08:39:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tWaTDq
        WtDuPrHuz910BqnxjlHmtCGps9mPWqCfXobTw=; b=ryqJ/IZZvIYuyREmrZggFO
        wl9GMCXJo8xShBa5WNl5Ze7Gpa+mDno3hbMbe1MfGBT/qALnKCvEJN0mOHiJSxkL
        QaUATUvy9Mfmg3tlQzur8O6jLrPCfX1xBvZJ7ZnUhU5DHBmloQ4fC4skojuA1r5i
        qhuhDEG4UnENpAIQ+ZYJ58Yq4L7VjaZ6OJDALJ5DaIBYboCVpOzP1R9bTfAzljuF
        2lji+E8Ams1vcYm0xn/q7XcoZjFig8eiOtF6Ryu8rX3hGsXCWh/FcMQWPHKPKLBC
        WswtblTAhPlvd9ZU9kDi8X2G23EPiThjP10IAdKPFd/M+wnk7wFtxSPyb1jT47iA
        ==
X-ME-Sender: <xms:BWSiYHxiiwWqI6GuKqSOdg7hPY7L6EX8fjWnFsGLlMR5RnhMUVEriw>
    <xme:BWSiYPRyGjFOdb3IV3l5yMoSlT7N2l-QrKip5KhOPyGk_QwAnaMaOkroAZZ7-HugF
    bSDjzzAO6i8TQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BWSiYBWC2jM6UU3EN-L9KDDAtd-8KNhHUQvlP-ZsE79W172WGLH4WA>
    <xmx:BWSiYBitJ8uM4leguLOuMwbT8MZSIZCylZCuxE7Jq7pAG29Q9Vtjgw>
    <xmx:BWSiYJAHzMNXXZj8co-SmU1XRCCFiSOGsg6ftJIL28mx4thTTqn6bA>
    <xmx:BWSiYIPMOl-ah5vVwnms2wHjgTC-TcM1qXHVVq9UtjGGCTZwZvCe-thiAz0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 08:39:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/overlay: Fix active retire callback alignment" failed to apply to 5.4-stable tree
To:     tvrtko.ursulin@intel.com, chris@chris-wilson.co.uk,
        jani.nikula@intel.com, matthew.auld@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 14:39:27 +0200
Message-ID: <1621255167231244@kroah.com>
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

From a915fe5e9601c632417ef5261af70788d7d23a8a Mon Sep 17 00:00:00 2001
From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Date: Thu, 29 Apr 2021 09:35:29 +0100
Subject: [PATCH] drm/i915/overlay: Fix active retire callback alignment
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

__i915_active_call annotation is required on the retire callback to ensure
correct function alignment.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: a21ce8ad12d2 ("drm/i915/overlay: Switch to using i915_active tracking")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210429083530.849546-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit d8e44e4dd221ee283ea60a6fb87bca08807aa0ab)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_overlay.c b/drivers/gpu/drm/i915/display/intel_overlay.c
index e5dadde422f7..bbaf05515e88 100644
--- a/drivers/gpu/drm/i915/display/intel_overlay.c
+++ b/drivers/gpu/drm/i915/display/intel_overlay.c
@@ -383,7 +383,7 @@ static void intel_overlay_off_tail(struct intel_overlay *overlay)
 		i830_overlay_clock_gating(dev_priv, true);
 }
 
-static void
+__i915_active_call static void
 intel_overlay_last_flip_retire(struct i915_active *active)
 {
 	struct intel_overlay *overlay =

