Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486984A4D73
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 18:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381067AbiAaRnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 12:43:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:11407 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236013AbiAaRnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 12:43:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643651023; x=1675187023;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ojlS5jeRImpDghSEZ2+EoNlrlzO15fhv+eI6HpNMHKI=;
  b=iZCR4yfZpU+tuld0VAR0A7k+XVzsYVEt+Kz4fPJH2XkdYG7543+hkYjr
   +KHiJkBYlgkk2G8asNkDQdgDQX9U7OEV9f3awt6a1U+rlG5LwdUNRXrhh
   8AAtEJZ7WI2P7nSgPzAxF9Pqp256rkW+uYI0PoRLqdKFqhYooRtmdjNlr
   FDp8NsltxL+BfEwFIh570aYYEW9jIVXaAQ6tEt0np6SFyf7ZnGrLpYjh3
   pX7sVd0lJx177Sjyl2PNmxfPPU+iDIsoixfMPTxFvEr9sIBfJW2O7fUYw
   xv6f04LqBLmcpZNhva9D7lhqEMLAM4wxqxfAddBAiNu/88SPNGVyUa1QZ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247285042"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="247285042"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 09:43:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="698081556"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 09:43:43 -0800
From:   Tony Luck <tony.luck@intel.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, bp@suse.de,
        ailin.xu@intel.com, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [v5.10 stable PATCH 1/2] x86/mce: Add Xeon Sapphire Rapids to list of CPUs that support PPIN
Date:   Mon, 31 Jan 2022 09:43:32 -0800
Message-Id: <20220131174333.2000647-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <Yfgd+nHcTbNcSHY0@kroah.com>
References: <Yfgd+nHcTbNcSHY0@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a331f5fdd36dba1ffb0239a4dfaaf1df91ff1aab upstream

New CPU model, same MSRs to control and read the inventory number.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210319173919.291428-1-tony.luck@intel.com
---
 arch/x86/kernel/cpu/mce/intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index 2577d7875781..7cf08c1f082e 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -486,6 +486,7 @@ static void intel_ppin_init(struct cpuinfo_x86 *c)
 	case INTEL_FAM6_BROADWELL_X:
 	case INTEL_FAM6_SKYLAKE_X:
 	case INTEL_FAM6_ICELAKE_X:
+	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 	case INTEL_FAM6_XEON_PHI_KNL:
 	case INTEL_FAM6_XEON_PHI_KNM:
 
-- 
2.31.1

