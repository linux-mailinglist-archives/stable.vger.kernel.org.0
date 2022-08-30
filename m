Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C855A7152
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 01:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiH3XC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 19:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiH3XCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 19:02:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009E595E5D;
        Tue, 30 Aug 2022 16:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661900545; x=1693436545;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=7FuT3vbL3dMCmOkNCr0MvByJHvFwQiNqKsGQA29tuIM=;
  b=O++2NICWw1aXt2gp5pAt48I02etVV3NS7ttzlGUGnqjB8I2S7gClGQ7/
   wLMOGrolZbO2F4JWFZF7giMBt2JUkFieyJc/PcOBXYR+6nMAx8hQCnBki
   TkHL+aZFMQJnFCfSXmSyhiL0u2u0Y/wMCl3d4eAEkL1nn3S6zJOcXxozb
   OEdpXnai7RISLEO2jmgPApCJfPCOFyiYElFjiKDxW47hUyoit2SBdPsDB
   4owP8GiSK3hNZ6WUjKG0RY4GEwADYcml66+Po3QKkC3PuNd7f5HSN0JqV
   +tKzxZrtZJxiah1loe/kVEk9cMijnAQI4L1soXQoEH6o8PWrqe46oo+EM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="296605021"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="296605021"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 16:02:24 -0700
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="940226447"
Received: from skanpuri-mobl1.amr.corp.intel.com (HELO desk) ([10.212.18.137])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 16:02:23 -0700
Date:   Tue, 30 Aug 2022 16:02:23 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, andrew.cooper3@citrix.com, bp@suse.de,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.9 1/2] x86/cpu: Add Tiger Lake to Intel family
Message-ID: <81f08c055ed116d80a1b139b41f1b663867368b5.1661899974.git.pawan.kumar.gupta@linux.intel.com>
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
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/include/asm/intel-family.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 8b6c01774ca2..aadb91d43eef 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -70,6 +70,9 @@
 #define INTEL_FAM6_ALDERLAKE		0x97
 #define INTEL_FAM6_ALDERLAKE_L		0x9A
 
+#define INTEL_FAM6_TIGERLAKE_L		0x8C
+#define INTEL_FAM6_TIGERLAKE		0x8D
+
 /* "Small Core" Processors (Atom) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */

base-commit: c97531caf70f2b533fa1944bf64dd06ac20edad6
-- 
2.37.2


