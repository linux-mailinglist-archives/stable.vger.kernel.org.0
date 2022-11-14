Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5674A6280A3
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbiKNNHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237901AbiKNNHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE412B1AC
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A076B80EA5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCB6C433D6;
        Mon, 14 Nov 2022 13:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431253;
        bh=OPh17+63pU4oLwr+vtfQ/uTMTgRb7sCEwkU5bQzsd1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwTBRL4ghaexVBJFkICFnwfMAAmDLxMcgbZ+qzGlmZzbeb14G5RdQ/dxSZtEFiBcv
         eBhq8BR8pOPRWAT/5u6/qFdK9iME/l0ZGeREGZFps0NB8B8/aAcwIzEH1HxzNM5Otp
         eDma7WjKjW5/eMWizOcbndh4ArmT607SWcst7mBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vasily Gorbik <gor@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 157/190] mm: hugetlb_vmemmap: include missing linux/moduleparam.h
Date:   Mon, 14 Nov 2022 13:46:21 +0100
Message-Id: <20221114124505.678809529@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit db5e8d84319bcdb51e1d3cfa42b410291d6d1cfa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb_vmemmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
 #include <linux/pgtable.h>
+#include <linux/moduleparam.h>
 #include <linux/bootmem_info.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>


