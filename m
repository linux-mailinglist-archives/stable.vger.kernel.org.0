Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBAA2F0EB1
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 10:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbhAKJBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 04:01:25 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:42943 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728222AbhAKJBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 04:01:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 619A325E2;
        Mon, 11 Jan 2021 03:59:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:59:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=MeBzV+
        ZyXSnQSfBa6uu5WDtTIIw4/flszyATN6X6UqM=; b=ABHDu6r/VH7YX3m8rDXTv2
        q6JHjTz/kxtmr+rRqAxVknRSs1T8U4l5fKZQ4gJl1s2iFDSvNMAidKcJN+p91tAO
        5M1Ajg/1ZQlhaAMJpV7fxBaKm+8xdhKFf72VKNfwMVaZz+A+JyZiTthXnP22yCzh
        NTz//xb/klD+DG5stFT6F/qj6Qc9b0uCQe74Pp+URS7935bU33pLo8gov0uUlu/1
        JJiGkYogPVTlvIjRjNW/9yH/0cupm95d9NIu1jdZ19xiZE/wrkA/MZdM0TeQ0PHT
        F2uX9BXgsZCGAYTjtq5QAPmJ5IFOy0ApsMFw8iLI9ClqMFs7cSnYGz6mzGq3tsUg
        ==
X-ME-Sender: <xms:dxP8X-aQFrLcdIXkelclP4lsnQrBPKUT6PFZWCDFrMSZ99uytnd0VQ>
    <xme:dxP8XxZyyGks1Fd8K4BGX_6HEJ-sKsaB_pA3jo-4n7EtzEbg0YEe03JqKMhpWEP1c
    i_zsJUTWetJRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeehnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dxP8X4-vgFhd0wLJP2PdtDAc4nEoK_q8fzQUdy64SvBi6atp-EObEw>
    <xmx:dxP8XwqmPGuRSH06ej2Dj3TTmFd_9gZfG2ojE4edZg7AEx6d9gHmkg>
    <xmx:dxP8X5pyex_WM94Yy4_ZGpZlWPhzJ0aeoMs_m8TcO-ImNufTY54TwQ>
    <xmx:eBP8X6Cous5gFjtS-bVly3BER3XPos6K5soVEEoFU59dm8xNrHNRVUB3HJU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8EB6F240062;
        Mon, 11 Jan 2021 03:59:35 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Define guc firmware blob for older Cometlakes" failed to apply to 5.10-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        mika.kuoppala@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 10:00:48 +0100
Message-ID: <1610355648136118@kroah.com>
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

From 557862535c2cad6de6f6fb12312b7a6d09c06407 Mon Sep 17 00:00:00 2001
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
(cherry picked from commit 70960ab27542d8dc322f909f516391f331fbd3f1)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

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

