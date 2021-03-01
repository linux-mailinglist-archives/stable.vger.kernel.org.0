Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD46328042
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhCAOGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:06:43 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:40733 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhCAOG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 09:06:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1570D194225F;
        Mon,  1 Mar 2021 09:05:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 09:05:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zMWB4G
        aHdeG5g4GC+p5XCh/FPq6+nKIrVMrpMc1575c=; b=CgWHW6LkmP4buEPhoJ9C6u
        DiGx2I1sEylYhAblUTVEsu/c9QCC97zVqPWJ7vKtKkPrnq9RNV3kgm0JJjRhcS4p
        OwPc9T08FkP4bFBBQOgQaaXuHZNnDihBs7PWFWTBfg+UaLqlCEQpyeOssAmeM+Lg
        gN2f8tQFLomtK4HrKnImbMny67au/3PjpBEIdTaWpga6NrSHCXNDc/BISp6ZKNu9
        cwZmdTFi4o0UTvtQi97yVKyVeqs7fkE3A4CLbpCTR9KOz+S6oK4awNTfAQHv/mVH
        fITgSVBJJt3xxpD4cwOV28i01M49qLnMxxj9w7lYC5p4FHPPj7Jl5KXUcovALZCA
        ==
X-ME-Sender: <xms:s_Q8YHJAHMGSgR2NFgxoQiFP_JlSMKynUpOadr21Xz5hn-w_y-zyLQ>
    <xme:s_Q8YLL4-yfhQQoE0ndn-1IBNBOR574HKHGoEdNLqHqEU2KyBKFpyy5XZvM25PF9-
    M5fVBHxMUbQzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:s_Q8YPsnMf_N95Y55W9r0L-SnBuvrFPwGVvkESpEW2YsOV2iN0KLUQ>
    <xmx:s_Q8YAb0IJz161K0ZwEyrZNdf1Zs4utwzOTG7_iPQH4XYeZCfy7yRg>
    <xmx:s_Q8YOYOEXs9owWutZ_1kv9Un4NrY4n0aiFtWvtWkxe-y3eQrDigTQ>
    <xmx:tPQ8YHApv0HiPVtvhzICq07gdNh7IkBx2WwJTOZFAqlDXkzXEK_ygg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C5B924005A;
        Mon,  1 Mar 2021 09:05:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Define guc firmware blob for older Cometlakes" failed to apply to 5.11-stable tree
To:     chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 15:05:37 +0100
Message-ID: <161460753716775@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 70960ab27542d8dc322f909f516391f331fbd3f1 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 29 Dec 2020 12:08:28 +0000
Subject: [PATCH] drm/i915/gt: Define guc firmware blob for older Cometlakes

When splitting the Coffeelake define to also identify Cometlakes, I
missed the double fw_def for Coffeelake. That is only newer Cometlakes
use the cml specific guc firmware, older Cometlakes should use kbl
firmware.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2859
Fixes: 5f4ae2704d59 ("drm/i915: Identify Cometlake platform")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.9+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201229120828.29931-1-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
index 180c23e2e25e..602f1a0bc587 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
@@ -53,6 +53,7 @@ void intel_uc_fw_change_status(struct intel_uc_fw *uc_fw,
 	fw_def(ELKHARTLAKE, 0, guc_def(ehl, 49, 0, 1), huc_def(ehl,  9, 0, 0)) \
 	fw_def(ICELAKE,     0, guc_def(icl, 49, 0, 1), huc_def(icl,  9, 0, 0)) \
 	fw_def(COMETLAKE,   5, guc_def(cml, 49, 0, 1), huc_def(cml,  4, 0, 0)) \
+	fw_def(COMETLAKE,   0, guc_def(kbl, 49, 0, 1), huc_def(kbl,  4, 0, 0)) \
 	fw_def(COFFEELAKE,  0, guc_def(kbl, 49, 0, 1), huc_def(kbl,  4, 0, 0)) \
 	fw_def(GEMINILAKE,  0, guc_def(glk, 49, 0, 1), huc_def(glk,  4, 0, 0)) \
 	fw_def(KABYLAKE,    0, guc_def(kbl, 49, 0, 1), huc_def(kbl,  4, 0, 0)) \

