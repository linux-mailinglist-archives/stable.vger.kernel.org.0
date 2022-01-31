Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928384A4D74
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 18:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbiAaRnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 12:43:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:11407 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381062AbiAaRnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 12:43:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643651025; x=1675187025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jTZ1zZZotqiblEWSbQ+lyoBal0tj+0E6ZxSRyflFIzs=;
  b=fZGM3vtYyZ833fhP5GrXGKHpZ1R9HFotAgNOodyOeIZAHqDt5bJ0KiBq
   lPONXX9kKJH8isx5b+LW59gyVUBLKzEziOai4r4/jxYhKEHaD+k03xs2Y
   B7tXnApHoQG3XXTvnE7nWybZqieN5RmuNyfHx11kP0gIiRhJ/jihY/lr1
   rT7k44sdbMYjoFB1ixLPOWOiALyJ+PJyvcuE48kJ+4QiVnZep4rporWWK
   r7ycxYlL7QeW+rcj5J6xLXx33YGVtR/RRNVU8YDDo/fuEY7WEf01U51zl
   9aUajrqb7zxESwc4LVP+4Vw1u59WKk6VEa5xVkc7/1w8oNc/La7W+gsxt
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247285044"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="247285044"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 09:43:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="698081561"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 09:43:43 -0800
From:   Tony Luck <tony.luck@intel.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, bp@suse.de,
        ailin.xu@intel.com, Tony Luck <tony.luck@intel.com>
Subject: [v5.10 stable PATCH 2/2] x86/cpu: Add Xeon Icelake-D to list of CPUs that support PPIN
Date:   Mon, 31 Jan 2022 09:43:33 -0800
Message-Id: <20220131174333.2000647-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220131174333.2000647-1-tony.luck@intel.com>
References: <Yfgd+nHcTbNcSHY0@kroah.com>
 <20220131174333.2000647-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e464121f2d40eabc7d11823fb26db807ce945df4 upstream

Missed adding the Icelake-D CPU to the list. It uses the same MSRs
to control and read the inventory number as all the other models.

Fixes: dc6b025de95b ("x86/mce: Add Xeon Icelake to list of CPUs that support PPIN")
Reported-by: Ailin Xu <ailin.xu@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220121174743.1875294-2-tony.luck@intel.com
---
 arch/x86/kernel/cpu/mce/intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index 7cf08c1f082e..886d4648c9dd 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -486,6 +486,7 @@ static void intel_ppin_init(struct cpuinfo_x86 *c)
 	case INTEL_FAM6_BROADWELL_X:
 	case INTEL_FAM6_SKYLAKE_X:
 	case INTEL_FAM6_ICELAKE_X:
+	case INTEL_FAM6_ICELAKE_D:
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 	case INTEL_FAM6_XEON_PHI_KNL:
 	case INTEL_FAM6_XEON_PHI_KNM:
-- 
2.31.1

