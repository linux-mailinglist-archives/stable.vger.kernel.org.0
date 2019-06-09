Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395A43A4B0
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 12:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfFIKaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 06:30:09 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36555 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727853AbfFIKaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 06:30:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 76F7E3EE;
        Sun,  9 Jun 2019 06:30:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 06:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MKeMCs
        m3PHLpN4mOGB3fZ0A3fQAyIK2rTOyl1+UIijQ=; b=uWo04kwztryR6iZdQR2+gS
        JfrDVGUvJfoEwYMPirseGXuDut72ozIS0C/rhbGVqzN3TrX27OGS0sIbfC9goYDX
        mncHaVpKVuSXA8P7ZV/3r2aK7itlDfKhUJiUApsg3jVaUJAuzcCq+sl5r+12NZcw
        v9JD2rhzL4GEQx+aqhkuKsM5WMSP/1ePP2yookXDFBLCtw1jraFoHuoDX/KTX6pZ
        f2PqkGEuvqQXLohbRJYnGK9yT62l0tt6/i4G9iFI89tE0HNJpPos4G8m2efb5ahc
        9x/ziN1cXyvMc8E/qH+CTXuPHFYfW32GQR6S9s6NjHQVMU7w/XJ6y+XyOa7+gY1Q
        ==
X-ME-Sender: <xms:rt_8XPGq7MOu4S3Jez9onruHqrK7ByTsq-i9U2KGTt5IPE6u-iTHWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:rt_8XIGEE57dnukiug5Whp-8Q1e1eD8Q4U_Ya-Of9F6_VCOzlr2T0Q>
    <xmx:rt_8XD4itXuw2PH6GuNgCaPhUu-gBuw96M-ntJWf6agohlZQawfwsw>
    <xmx:rt_8XDFH8a2ndwd4OXaAzSINEBT7aMlEyAobEExjZxJobMW44DlHpg>
    <xmx:r9_8XOVNUT7hd-kgD_eIybRnqW4yzBv8ZOVS5jSpNMKI81t_9HvVgQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C307B38008A;
        Sun,  9 Jun 2019 06:30:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Maintain consistent documentation subsection" failed to apply to 4.14-stable tree
To:     corbet@lwn.net, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 12:30:03 +0200
Message-ID: <15600762031173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 551bd3368a7b3cfef01edaade8970948d178d40a Mon Sep 17 00:00:00 2001
From: Jonathan Corbet <corbet@lwn.net>
Date: Thu, 23 May 2019 10:06:46 -0600
Subject: [PATCH] drm/i915: Maintain consistent documentation subsection
 ordering

With Sphinx 2.0 (or prior versions with the deprecation warnings fixed) the
docs build fails with:

  Documentation/gpu/i915.rst:403: WARNING: Title level inconsistent:

  Global GTT Fence Handling
  ~~~~~~~~~~~~~~~~~~~~~~~~~

  reST markup error:
  Documentation/gpu/i915.rst:403: (SEVERE/4) Title level inconsistent:

I "fixed" it by changing the subsections in i915.rst, but that didn't seem
like the correct change.  It turns out that a couple of i915 files create
their own subsections in kerneldoc comments using apostrophes as the
heading marker:

  Layout
  ''''''

That breaks the normal subsection marker ordering, and newer Sphinx is
rather more strict about enforcing that ordering.  So fix the offending
comments to make Sphinx happy.

(This is unfortunate, in that kerneldoc comments shouldn't need to be aware
of where they might be included in the heading hierarchy, but I don't see
a better way around it).

Cc: stable@vger.kernel.org  # v4.14+
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index b74824f0b5b1..249d35c12a75 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -35,7 +35,7 @@
  * macros. Do **not** mass change existing definitions just to update the style.
  *
  * Layout
- * ''''''
+ * ~~~~~~
  *
  * Keep helper macros near the top. For example, _PIPE() and friends.
  *
@@ -79,7 +79,7 @@
  * style. Use lower case in hexadecimal values.
  *
  * Naming
- * ''''''
+ * ~~~~~~
  *
  * Try to name registers according to the specs. If the register name changes in
  * the specs from platform to another, stick to the original name.
@@ -97,7 +97,7 @@
  * suffix to the name. For example, ``_SKL`` or ``_GEN8``.
  *
  * Examples
- * ''''''''
+ * ~~~~~~~~
  *
  * (Note that the values in the example are indented using spaces instead of
  * TABs to avoid misalignment in generated documentation. Use TABs in the
diff --git a/drivers/gpu/drm/i915/intel_workarounds.c b/drivers/gpu/drm/i915/intel_workarounds.c
index 9682dd575152..6decd432f4d3 100644
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -37,7 +37,7 @@
  *    costly and simplifies things. We can revisit this in the future.
  *
  * Layout
- * ''''''
+ * ~~~~~~
  *
  * Keep things in this file ordered by WA type, as per the above (context, GT,
  * display, register whitelist, batchbuffer). Then, inside each type, keep the

