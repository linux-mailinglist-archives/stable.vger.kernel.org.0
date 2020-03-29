Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9ECB196A95
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 04:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgC2CMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 22:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgC2CMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Mar 2020 22:12:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB49206E6;
        Sun, 29 Mar 2020 02:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585447971;
        bh=llfM1alr93MAb0ZAy7xfHEFwDhM43W8Ao6lavXy/rq0=;
        h=Date:From:To:Subject:From;
        b=R877ZCi9ZGNNv5oyCJdS9jOqPd3mdYBbTjif/ZcrBAfNC16LW+CTR3juUYqlE3GtZ
         U4U5dGxwJxv25dRKPRnK+QEdAaQCqLIeAwhYp1Qpo14wR4ttPPWc70Pc/Tmq193AN+
         fEV2abd+e0vsisZ/iPuMt/y0g/lBo0T86YZ1917E=
Date:   Sat, 28 Mar 2020 19:12:50 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, bhe@redhat.com,
        dan.j.williams@intel.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richardw.yang@linux.intel.com,
        rppt@linux.ibm.com, sachinp@linux.vnet.ibm.com,
        stable@vger.kernel.org
Subject:  [folded-merged]
 mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch removed
 from -mm tree
Message-ID: <20200329021250.8PmoLdGwm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2
has been removed from the -mm tree.  Its filename was
     mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch

This patch was dropped because it was folded into mm-sparse-fix-kernel-crash-with-pfn_section_valid-check.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2

add comment

Link: http://lkml.kernel.org/r/20200326133235.343616-1-aneesh.kumar@linux.ibm.com
Fixes: d41e2f3bd546 ("mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2
+++ a/mm/sparse.c
@@ -781,7 +781,11 @@ static void section_deactivate(unsigned
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-		/* Mark the section invalid */
+		/*
+		 * Mark the section invalid so that valid_section()
+		 * return false. This prevents code from dereferencing
+		 * ms->usage array.
+		 */
 		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
 	}
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-sparse-fix-kernel-crash-with-pfn_section_valid-check.patch

