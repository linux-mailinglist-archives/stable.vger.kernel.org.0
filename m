Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37F537C571
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbhELPkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:40:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:15163 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235040AbhELPfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:35:12 -0400
IronPort-SDR: J4s4b557qQhajDVUzW4Tr/XrSOsUG+yN3BphbxlvuR7P10MsA/H8wFN2yo41JB0uNCy+pTR+0V
 DFDt6EX5fCLA==
X-IronPort-AV: E=McAfee;i="6200,9189,9982"; a="263662726"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="263662726"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 08:32:45 -0700
IronPort-SDR: 5dWTnPTF6i20GWZXTqA7Qlb8PTp12bwmP/kOXmBqD18brWyfq87CX6JTBIdP8qJ9Zn8MSw/VTy
 X+Jkt2092nVw==
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="625442439"
Received: from lucas-s2600cw.jf.intel.com ([10.165.21.202])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 08:32:43 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 1/2] drm/i915/gt: Define guc firmware blob for older Cometlakes
Date:   Wed, 12 May 2021 08:32:22 -0700
Message-Id: <20210512153223.1554474-2-lucas.demarchi@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512153223.1554474-1-lucas.demarchi@intel.com>
References: <20210512153223.1554474-1-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

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
(cherry picked from commit 557862535c2cad6de6f6fb12312b7a6d09c06407)
---
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
index 180c23e2e25e4..602f1a0bc5871 100644
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
