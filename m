Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFB61DDB54
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgEUXyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:54:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:39714 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728635AbgEUXyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 19:54:01 -0400
IronPort-SDR: 1205/Z00YhtV4tB9QGsx/uOe2HwC+V7F6S0OO6/FnupkuP2IbZKSPiENyocuJLgtZzRqjTc1rl
 PieRSJnsp16Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:00 -0700
IronPort-SDR: uN2JO7VRFCA+BU+ZiUlQtX0aFqBz4P05q3uuqVEjHelJfxM6w40okjP2byV05yOD9ToPqPTWjj
 ++x+te6Tpbsg==
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="309216914"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:00 -0700
Subject: [5.4-stable PATCH 1/7] mm/memremap_pages: Kill unused
 __devm_memremap_pages()
From:   Dan Williams <dan.j.williams@intel.com>
To:     stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, vishal.l.verma@intel.com,
        linux-nvdimm@lists.01.org
Date:   Thu, 21 May 2020 16:37:48 -0700
Message-ID: <159010426892.1062454.14033665233091025420.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 1d0827b75ee7df497f611a2ac412a88135fb0ef5 upstream.

Kill this definition that was introduced in commit 41e94a851304 ("add
devm_memremap_pages") add never used.

Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/158041476158.3889308.4221100673554151124.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/io.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/io.h b/include/linux/io.h
index a59834bc0a11..35e8d84935e0 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -79,8 +79,6 @@ void *devm_memremap(struct device *dev, resource_size_t offset,
 		size_t size, unsigned long flags);
 void devm_memunmap(struct device *dev, void *addr);
 
-void *__devm_memremap_pages(struct device *dev, struct resource *res);
-
 #ifdef CONFIG_PCI
 /*
  * The PCI specifications (Rev 3.0, 3.2.5 "Transaction Ordering and

