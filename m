Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B44A2AB54D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgKIKrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:47:17 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:57743 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729390AbgKIKrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:47:17 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 8D18010ED;
        Mon,  9 Nov 2020 05:47:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 05:47:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Orhk1T
        uooxzsbjJnKCeJWIZgjoA8G36mWJnoyaZxsk8=; b=gAIWjjsJ3LUFkkiFiwEYcv
        KSZSJwCypsFmyAa+JjkEqNw36mkdAln7VKhrjG7cHILyDsWsWyvApkyLYdgDTSUO
        1GD86m1lH/2S01KLo9tfJ264PO8GXHxDpb035FjATJr31flhxoR3G2eL8hzzY9gO
        BLSoNDVCAZRsgloKYta1qoA8U7i05ZYGfM8n1yf9IBnoetRzw93ri++GkxFtJRJV
        3YtdJQJhPwQFdupTNJUDsl/bl4tk4lbA5MuGjkQnz8fgTmbJUkUYFCKTDD9AoGGA
        yqG9Ba7nddbfOJqy4r3hk8nO/illgggWu1R4b8YeBbs2BzmCK9dy37lHDBMDGmDQ
        ==
X-ME-Sender: <xms:Mx6pXyrZqfiFKJrOJUUs0LgqA4p3uAWYMhrC2AwWvs7-6UnuBRuHPw>
    <xme:Mx6pXwpPG2COiL6t4a1oWhPqWrZE19ui3sQma893PwK9ffO2v2R6JWKwnggQRcytw
    ijlB8jrj3pzRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Mx6pX3P7O_VXUJG1y1971XtpMporBXRXwgiYQ6CO1aQELSMLIyRV-A>
    <xmx:Mx6pXx7OWhtOHsB2jzoL6-f4KpwePxAwD3Bx_IUVvQCfiULqTOwUBw>
    <xmx:Mx6pXx57xH5oX7QDvc5HkC_U9xNmCbflwvWcieRKDx6xUdhGdQ2XLQ>
    <xmx:NB6pXzQ_ZnRwmHanEr3RDY3NjNElGzXrI5w9VwOL-H646ZDQIAqCRHrMUts>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 456BE306307C;
        Mon,  9 Nov 2020 05:47:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Flush xcs before tgl breadcrumbs" failed to apply to 5.9-stable tree
To:     chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        rodrigo.vivi@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Nov 2020 11:48:15 +0100
Message-ID: <160491889520960@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e67d01d8494640018b08cd767aeb2824a8e11983 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 2 Nov 2020 22:10:57 +0000
Subject: [PATCH] drm/i915/gt: Flush xcs before tgl breadcrumbs

In a simple test case that writes to scratch and then busy-waits for the
batch to be signaled, we observe that the signal is before the write is
posted. That is bad news.

Splitting the flush + write_dword into two separate flush_dw prevents
the issue from being reproduced, we can presume the post-sync op is not
so post-sync.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/216
Testcase: igt/gem_exec_fence/parallel
Testcase: igt/i915_selftest/live/gt_timelines
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Acked-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201102221057.29626-2-chris@chris-wilson.co.uk
(cherry picked from commit 09212e81e5450743e5b06b27c4e344e4c45b630d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index d12861cf0753..f82c6dd1de18 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -4994,7 +4994,9 @@ gen12_emit_fini_breadcrumb_tail(struct i915_request *request, u32 *cs)
 
 static u32 *gen12_emit_fini_breadcrumb(struct i915_request *rq, u32 *cs)
 {
-	return gen12_emit_fini_breadcrumb_tail(rq, emit_xcs_breadcrumb(rq, cs));
+	/* XXX Stalling flush before seqno write; post-sync not */
+	cs = emit_xcs_breadcrumb(rq, __gen8_emit_flush_dw(cs, 0, 0, 0));
+	return gen12_emit_fini_breadcrumb_tail(rq, cs);
 }
 
 static u32 *

