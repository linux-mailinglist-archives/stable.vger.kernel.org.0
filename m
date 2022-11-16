Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2609C62CEEE
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 00:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbiKPXmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 18:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbiKPXmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 18:42:35 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E943B70194;
        Wed, 16 Nov 2022 15:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668642088; x=1700178088;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to;
  bh=51lOlSScMtNXt0xN1+cfGR14o3FY+CtRO0z+BQRrxHI=;
  b=XJ11pM1JlWWKR41KpZXdg1sA7VIYNoxlZWl8/310qe8E8ttspsIf6R0L
   +um1SY9khbPNOx+leRn5fKvWpjHW3a9pOUvw05n5J+lFpKdG9KDWpayny
   JMFiQQq7eYm8ZyQWWNSgGXu0DQk2pjyvSzwgzLAAJlatD1qVmKg+N+xXT
   c4zRhJWTPwXkuKAOY+Vvl2x/WWWa8en5bFOiarpPkexFQ84Pyqp8OOwam
   zf6MoEVowldhTduAZflqBAqVOKy9E+PjYlfCLpz95UIUM0yR3viYTOIge
   NLgnLNWHJVk9Jawck8NOt9wqe0VCHH84KY8Eky2lXB/3zOcflaEP0T08h
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="292405779"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="292405779"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:41:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="641848521"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="641848521"
Received: from jjeyaram-mobl1.amr.corp.intel.com (HELO [192.168.1.28]) ([10.212.1.223])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:41:27 -0800
From:   Vishal Verma <vishal.l.verma@intel.com>
Date:   Wed, 16 Nov 2022 16:37:36 -0700
Subject: [PATCH v2 1/2] ACPI: HMAT: remove unnecessary variable initialization
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221116-acpi_hmat_fix-v2-1-3712569be691@intel.com>
References: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
In-Reply-To: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-kernel@vger.kernel.org,
        Chris Piper <chris.d.piper@intel.com>, nvdimm@lists.linux.dev,
        linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Liu Shixin <liushixin2@huawei.com>, stable@vger.kernel.org
X-Mailer: b4 0.11.0-dev-d1636
X-Developer-Signature: v=1; a=openpgp-sha256; l=1117;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=51lOlSScMtNXt0xN1+cfGR14o3FY+CtRO0z+BQRrxHI=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmlpeqV387XKDrnL1W5XHjGteB445I/szYv821ZPCW64y+D
 3t3pHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZjIsXhGhvNT0uw5Flzl3fGsPfR98d
 4lAjamAdlH/XOymz5N+mwr+pWRYUHWnfP5Dnasz87t9dx0IzyqtjtEKoFrn0t7++qta44KcgIA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In hmat_register_target_initiators(), the variable 'best' gets
initialized in the outer per-locality-type for loop. The initialization
just before setting up 'Access 1' targets was unnecessary. Remove it.

Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/numa/hmat.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 23f49a2f4d14..144a84f429ed 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -644,7 +644,6 @@ static void hmat_register_target_initiators(struct memory_target *target)
 	/* Access 1 ignores Generic Initiators */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
 	list_sort(p_nodes, &initiators, initiator_cmp);
-	best = 0;
 	for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 		loc = localities_types[i];
 		if (!loc)

-- 
2.38.1
