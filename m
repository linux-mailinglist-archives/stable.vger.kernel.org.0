Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EAA616F4E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 22:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiKBVB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 17:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiKBVB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 17:01:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D5DDEB0;
        Wed,  2 Nov 2022 14:01:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 195BDB824F7;
        Wed,  2 Nov 2022 21:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4349C433C1;
        Wed,  2 Nov 2022 21:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667422883;
        bh=aQq+cyVtMbeIgLlYSHZEdBPWZyIZDLyl4Owce8UYD5Y=;
        h=Date:To:From:Subject:From;
        b=KnG4oXKi3NGTTXWIRLL8y0pKVH7m66ocySQjy3vgIl0smTZqS4svWrKNE7hKuC/NE
         w1cVjgqQR3XmwvPSxf/teygbeTEP3amyC2JyI4IRNzsa5Zt15ufb07Tn7at0SLzcR8
         DLmGBEvVfgXamCOd54czJU5lxe5nEK2bHBySh00g=
Date:   Wed, 02 Nov 2022 14:01:22 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com, lkp@intel.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-include-missing-linux-moduleparamh.patch added to mm-hotfixes-unstable branch
Message-Id: <20221102210123.B4349C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: include missing linux/moduleparam.h
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-include-missing-linux-moduleparamh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-include-missing-linux-moduleparamh.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vasily Gorbik <gor@linux.ibm.com>
Subject: mm: hugetlb_vmemmap: include missing linux/moduleparam.h
Date: Wed, 2 Nov 2022 19:09:17 +0100

The kernel test robot reported build failures with a 'randconfig' on s390:
>> mm/hugetlb_vmemmap.c:421:11: error: a function declaration without a
prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
   core_param(hugetlb_free_vmemmap, vmemmap_optimize_enabled, bool, 0);
             ^

Link: https://lore.kernel.org/linux-mm/202210300751.rG3UDsuc-lkp@intel.com/
Link: https://lkml.kernel.org/r/patch.git-296b83ca939b.your-ad-here.call-01667411912-ext-5073@work.hours
Fixes: 30152245c63b ("mm: hugetlb_vmemmap: replace early_param() with core_param()")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-include-missing-linux-moduleparamh
+++ a/mm/hugetlb_vmemmap.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
 #include <linux/pgtable.h>
+#include <linux/moduleparam.h>
 #include <linux/bootmem_info.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
_

Patches currently in -mm which might be from gor@linux.ibm.com are

mm-hugetlb_vmemmap-include-missing-linux-moduleparamh.patch

