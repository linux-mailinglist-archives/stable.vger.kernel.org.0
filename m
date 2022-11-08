Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54EA62208B
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 00:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiKHX6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 18:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiKHX6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 18:58:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A1A606A7;
        Tue,  8 Nov 2022 15:58:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8B40B81CC7;
        Tue,  8 Nov 2022 23:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57727C433C1;
        Tue,  8 Nov 2022 23:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951896;
        bh=GmWaYwFMhvWkGZnCa57g3be9sxwXWpf2RmafuhBCAjQ=;
        h=Date:To:From:Subject:From;
        b=mbonw3ty0uRonczWaNNpSAzq+oWNAh++OhUpM51WbO9N7dpjl96v/bC/lPpCGC6tA
         FqSObt4NqoY0RaA7K+ZM9yn8UNhQ6sI9nwypf1D3/1sp0si0XoN4JFOv9m7vjjqRsP
         z1ijVEQ0z/GRHSR3Vkk+NakAo6nDIBT4NcjXgXbw=
Date:   Tue, 08 Nov 2022 15:58:15 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com, lkp@intel.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb_vmemmap-include-missing-linux-moduleparamh.patch removed from -mm tree
Message-Id: <20221108235816.57727C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: include missing linux/moduleparam.h
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-include-missing-linux-moduleparamh.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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


