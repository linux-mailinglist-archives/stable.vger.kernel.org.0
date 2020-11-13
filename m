Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EFC2B1475
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 03:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgKMCxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 21:53:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgKMCxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 21:53:47 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5185721D46;
        Fri, 13 Nov 2020 02:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605236025;
        bh=7gFkyPD2JXvF0KQ+cov1HtxGtqBkFwtdhogq/Yj31qY=;
        h=Date:From:To:Subject:From;
        b=YevW5T5o729WH74cUM/0pHVUGXt0qpMXnL601j7Da74INZHtABvrFNBk6aEPgnxb0
         Xt9zGAlNx+zx58GElLyzEGajBeeO3cF06Lcq8vzIIFyCQZsrjfQHfHsTokyIT5huN4
         rr05LFqPJiR67lWLovQxsYZKys0J/HYCEIzNOOTo=
Date:   Thu, 12 Nov 2020 18:53:44 -0800
From:   akpm@linux-foundation.org
To:     ansuelsmth@gmail.com, catalin.marinas@arm.com,
        mark.rutland@arm.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, stable@vger.kernel.org, will@kernel.org
Subject:  [alternative-merged]
 arm64-fix-missing-include-in-asm-uaccessh.patch removed from -mm tree
Message-ID: <20201113025344.1CLnIBTM8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: arm64: fix missing include in asm/uaccess.h
has been removed from the -mm tree.  Its filename was
     arm64-fix-missing-include-in-asm-uaccessh.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Ansuel Smith <ansuelsmth@gmail.com>
Subject: arm64: fix missing include in asm/uaccess.h

Fix a compilation error as PF_KTHREAD is defined in linux/sched.h and this
is missing.

[viro@zeniv.linux.org.uk: use linux/uaccess.h]
  Link: https://lkml.kernel.org/r/20201111005826.GY3576660@ZenIV.linux.org.uk
Link: https://lkml.kernel.org/r/20201111004440.8783-1-ansuelsmth@gmail.com
Fixes: df325e05a682 ("arm64: Validate tagged addresses in access_ok() called from kernel threads")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/uaccess.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/include/asm/uaccess.h~arm64-fix-missing-include-in-asm-uaccessh
+++ a/arch/arm64/include/asm/uaccess.h
@@ -7,6 +7,8 @@
 #ifndef __ASM_UACCESS_H
 #define __ASM_UACCESS_H
 
+#include <linux/uaccess.h>
+
 #include <asm/alternative.h>
 #include <asm/kernel-pgtable.h>
 #include <asm/sysreg.h>
_

Patches currently in -mm which might be from ansuelsmth@gmail.com are


