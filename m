Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC9C296788
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 01:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373240AbgJVXJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 19:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2444502AbgJVXJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:07 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A8E720756;
        Thu, 22 Oct 2020 23:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408146;
        bh=df4qBOzaa2kAvVqXl0IAg44AjLVCVz4Kk0LT95IerHw=;
        h=Date:From:To:Subject:From;
        b=qzqqJV/m26zIgmSezkEEy+w2AriE5/ClvZD8YFyJiYKoVNWhCLqYxK2g14wKeh5kJ
         oOoNjSw+AFF2EN2/xI7V1P4F1CYuZqyLj92INbraCgRIOVSwfb1mO7d6pVry3ruhnY
         EsPdBuvaxozILxkKF14HKFhcAuBGmvFF6z6w7Ja4=
Date:   Thu, 22 Oct 2020 16:09:05 -0700
From:   akpm@linux-foundation.org
To:     fenghua.yu@intel.com, krzk@kernel.org, lkp@intel.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        tony.luck@intel.com
Subject:  [merged] ia64-fix-build-error-with-coredump.patch removed
 from -mm tree
Message-ID: <20201022230905.Qb7woLNUV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ia64: fix build error with !COREDUMP
has been removed from the -mm tree.  Its filename was
     ia64-fix-build-error-with-coredump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: ia64: fix build error with !COREDUMP

Fix linkage error when CONFIG_BINFMT_ELF is selected but CONFIG_COREDUMP
is not:

    ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_phdrs':
    elfcore.c:(.text+0x172): undefined reference to `dump_emit'
    ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_data':
    elfcore.c:(.text+0x2b2): undefined reference to `dump_emit'

Link: https://lkml.kernel.org/r/20200819064146.12529-1-krzk@kernel.org
Fixes: 1fcccbac89f5 ("elf coredump: replace ELF_CORE_EXTRA_* macros by functions")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/Makefile~ia64-fix-build-error-with-coredump
+++ a/arch/ia64/kernel/Makefile
@@ -40,7 +40,7 @@ obj-y				+= esi_stub.o	# must be in kern
 endif
 obj-$(CONFIG_INTEL_IOMMU)	+= pci-dma.o
 
-obj-$(CONFIG_BINFMT_ELF)	+= elfcore.o
+obj-$(CONFIG_ELF_CORE)		+= elfcore.o
 
 # fp_emulate() expects f2-f5,f16-f31 to contain the user-level state.
 CFLAGS_traps.o  += -mfixed-range=f2-f5,f16-f31
_

Patches currently in -mm which might be from krzk@kernel.org are


