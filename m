Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF84C5A70FC
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 00:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiH3Wno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 18:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiH3Wn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 18:43:29 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304A27FFB8;
        Tue, 30 Aug 2022 15:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661899407; x=1693435407;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=T78uXjMUcdTpdHDsruBB9yEmBihIp9BInOVCLXWNUsU=;
  b=CapujMgLxkPW74ztVOJXY8lpyTlGKWEPtt1t6adKPNxFCA3rDSOaEiBp
   ibWOCeglNTuRK6c/dkt8+G+HW3lsdb/Di4YPKAsx+7xmkZYt0ekbiOlmH
   9gYGrIjF5kDGTE/qoJ+JTZivZaDo+MPl6X7I/2ahYnlDbOmADCCM9OJVE
   44CeQx9MSF+IJYWqr28A7iWv0/qQG0ONd/DVUXjf/HXemk2BZAAzmGn2i
   eX0XGAuh5oL+bJ+wUjv10aFHCljdLSkfjO8JSjwhhdGMnt+XSj5+gAYrz
   oePb647PNn9QRbnuVddcyqb26VDAuO8Jd/qTQzlIvliX7/2M1zbUvuvxa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="381619460"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="381619460"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 15:43:26 -0700
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="645022577"
Received: from skanpuri-mobl1.amr.corp.intel.com (HELO desk) ([10.212.18.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 15:43:25 -0700
Date:   Tue, 30 Aug 2022 15:43:24 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, andrew.cooper3@citrix.com, bp@suse.de,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.14 1/2] x86/cpu: Add Tiger Lake to Intel family
Message-ID: <ec31e22b4f3b079d0da6b60f5899ffcd79d9bea0.1661899117.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gayatri Kammela <gayatri.kammela@intel.com>

[ Upstream commit 6e1c32c5dbb4b90eea8f964c2869d0bde050dbe0 ]

Add the model numbers/CPUIDs of Tiger Lake mobile and desktop to the
Intel family.

Suggested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rahul Tanwar <rahul.tanwar@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190905193020.14707-2-tony.luck@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Patch 2/2 (x86/bugs: Add "unknown" reporting for MMIO Stale) depends on
this patch.

 arch/x86/include/asm/intel-family.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 98823250a521..05d2d7169ab8 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -71,6 +71,9 @@
 #define INTEL_FAM6_ALDERLAKE		0x97
 #define INTEL_FAM6_ALDERLAKE_L		0x9A
 
+#define INTEL_FAM6_TIGERLAKE_L		0x8C
+#define INTEL_FAM6_TIGERLAKE		0x8D
+
 /* "Small Core" Processors (Atom) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */

base-commit: e548869f356fead9fdcb3562f52d2226574f4f41
-- 
2.37.2


