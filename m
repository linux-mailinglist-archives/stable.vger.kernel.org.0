Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617BF4A4CF0
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 18:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350154AbiAaRQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 12:16:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:20109 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350146AbiAaRQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 12:16:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643649385; x=1675185385;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=74mOn2fnRV/bbZzq+Na9zlgTQIhgKj9fm7bFa8xEVM8=;
  b=Pa3lvJ8X+f0hRoSi4YFW/lH5cxTfkrxGHyr9IxojAtojLQySsjjWm/br
   d7vL6bI66Q8Jeoeh20Jr6w2ZXV1lOU6ys0lBR5Nrl7KnjFHvsTXRvKOg4
   vXLt8PLsijUrIJtvAtp1QTJnV24myNJ3ZvZowrg2AWG7/H9nV9+G+g5Uv
   Ktv20ZFrNAmVdY22CnrpbG2/ueYTWzumIuYrVl9vLchJRL7c6g7Y/Pf8b
   xRVGGVxOFXNsqQJt8Du8jhAKUOBwyslEW4IoA5DhbrntBDQ4kGB9WKq9k
   8LGFZQya8SDnfebpp6u9iHLaZWMEPoeXQycjDtfikGHUyyaHK0tBKgo9h
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="271982202"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208,223";a="271982202"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 09:16:25 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208,223";a="534239928"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 09:16:25 -0800
Date:   Mon, 31 Jan 2022 09:16:24 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     gregkh@linuxfoundation.org
Cc:     ailin.xu@intel.com, bp@suse.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/cpu: Add Xeon Icelake-D to list of
 CPUs that support PPIN" failed to apply to 5.10-stable tree
Message-ID: <YfgZaKupZpQobmiA@agluck-desk2.amr.corp.intel.com>
References: <164354605382174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164354605382174@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From 72a73811c4bd53e0ec8284c12180068468d7c733 Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Mon, 31 Jan 2022 09:00:41 -0800
Subject: [PATCH] x86/cpu: Add Sapphire Rapids and Icelake-D to list of CPUs that support PPIN

commit a331f5fdd36dba1ffb0239a4dfaaf1df91ff1aab upstream
commit e464121f2d40eabc7d11823fb26db807ce945df4 upstream

Add Sapphire Rapids and Icelake-D to list of CPUs that support PPIN

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Failed to backport because the sapphire rapids CPU model number
patch had not been backported.  Bundled both together here. But if
that breaks stable rules or scripts, I can redo as two patches one
for each upstream commit.

 arch/x86/kernel/cpu/mce/intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index 2577d7875781..886d4648c9dd 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -486,6 +486,8 @@ static void intel_ppin_init(struct cpuinfo_x86 *c)
 	case INTEL_FAM6_BROADWELL_X:
 	case INTEL_FAM6_SKYLAKE_X:
 	case INTEL_FAM6_ICELAKE_X:
+	case INTEL_FAM6_ICELAKE_D:
+	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 	case INTEL_FAM6_XEON_PHI_KNL:
 	case INTEL_FAM6_XEON_PHI_KNM:
 
-- 
2.31.1

