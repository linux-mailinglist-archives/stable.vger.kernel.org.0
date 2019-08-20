Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15BF8954E8
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 05:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfHTDO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 23:14:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:25396 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729142AbfHTDO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 23:14:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 20:14:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,407,1559545200"; 
   d="scan'208";a="329570570"
Received: from ssid-ilbpg3.png.intel.com ([10.88.227.91])
  by orsmga004.jf.intel.com with ESMTP; 19 Aug 2019 20:14:25 -0700
From:   wan.fahim.asqalanix.wan.yusof@intel.com
To:     stable@vger.kernel.org
Cc:     jose.souza@intel.com, tong.liang.chew@intel.com,
        gregkh@linuxfoundation.org, jui.nee.tan@intel.com
Subject: [PATCH] drm/i915/cfl: Add a new CFL PCI ID.
Date:   Tue, 20 Aug 2019 11:14:19 +0800
Message-Id: <1566270859-20963-1-git-send-email-wan.fahim.asqalanix.wan.yusof@intel.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

commit d0e062ebb3a44b56a7e672da568334c76f763552 upstream

One more CFL ID added to spec.

Cc: stable@vger.kernel.org
Cc: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20180803232721.20038-1-rodrigo.vivi@intel.com
(cherry picked from commit d0e062ebb3a44b56a7e672da568334c76f763552)
Signed-off-by: Wan Yusof, Wan Fahim AsqalaniX <wan.fahim.asqalanix.wan.yusof@intel.com>
---
 include/drm/i915_pciids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/drm/i915_pciids.h b/include/drm/i915_pciids.h
index fbf5cfc9b3..fd965ff 100644
--- a/include/drm/i915_pciids.h
+++ b/include/drm/i915_pciids.h
@@ -386,6 +386,7 @@
 	INTEL_VGA_DEVICE(0x3E91, info), /* SRV GT2 */ \
 	INTEL_VGA_DEVICE(0x3E92, info), /* SRV GT2 */ \
 	INTEL_VGA_DEVICE(0x3E96, info), /* SRV GT2 */ \
+	INTEL_VGA_DEVICE(0x3E98, info), /* SRV GT2 */ \
 	INTEL_VGA_DEVICE(0x3E9A, info)  /* SRV GT2 */
 
 /* CFL H */
-- 
2.7.4

