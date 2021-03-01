Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB55328043
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbhCAOHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:07:04 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:58297 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234389AbhCAOG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 09:06:57 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B3FD41942248;
        Mon,  1 Mar 2021 09:05:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 09:05:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U4jVr5
        8AgjlTVHdQEcGF7C2+7RS+qJdXlmnIXEU9mE0=; b=liEdn2bGbfrW6B+ZBaeq6D
        kfirL6DBKCtcxOY7r7bZlxhMYTYitdq6O0Bvn++zW11ucyL7cXrp8wt9U2rmaMTw
        nH+Vr0lPh1lsMXpwQok3h/dy7S+xUgvnO9lrvRUHP8UxU6vWPOSBZU4GXl8as32P
        Dcy8tj5I4hsziX/EgmEDy/AvYPSfTU2gp2Ng2NU3+Fx3vsl7YvtOxcHkWMEvzAnS
        M8VVeFQNJHrCVPhTiRvSsiJjHk8X581s1irfTinlAkt/Uh1efo68cgRYLK3YZm8t
        +LHGwgnlXBrIADSk+WSETWA4bQGifSuL20XUOY1Wi1DaIvYlggmCV126UeiRfKCQ
        ==
X-ME-Sender: <xms:u_Q8YCvFF_sm0MlFLrSz0JefJHCmmaOL3FRq0ohVUoV5mnFaqwPsvg>
    <xme:u_Q8YLyAf-9sqVR9oKZ0rzBxrBYm2IZPQHfYwuS_SQceDb1mlAdOAnm-NR6M7zOMQ
    sdqtjbrpSrfdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:u_Q8YM5q1xdb5yNAVXXRhf18907HFL4XFmkxNERFoUXHfbaCphdkVQ>
    <xmx:u_Q8YFWFZ3wIHXmPudhuhiU6Hlj5UPkm07x6pRLVlEW-lerefFdnGA>
    <xmx:u_Q8YI0ruM5v7cOfafI8QnscnwisQ8VfXduWbaDKaPFnwJD0lUSEaQ>
    <xmx:u_Q8YDAS81vEnU7tm4xq2OiLuINEX1WQjCOsCbBdVTeN0p_656jPrQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 56C2424005C;
        Mon,  1 Mar 2021 09:05:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Define guc firmware blob for older Cometlakes" failed to apply to 5.10-stable tree
To:     chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 15:05:38 +0100
Message-ID: <161460753820437@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

