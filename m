Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFA42581C2
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 21:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgHaT3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 15:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbgHaT3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 15:29:10 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BFF72083E;
        Mon, 31 Aug 2020 19:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598902149;
        bh=O3Rf+g3ynKZiOSSqRf9/52D60foLMEg0MfSNWmzzSAE=;
        h=Date:From:To:Subject:From;
        b=zcpdJ/vPjybYyMMswHEKeFBsmKPdXwjWXHmosrNcF6Fqn6+tMdGtadltnn8PBjt30
         hvLvRvpTOFaBEJkPeQ8XJLPSILy5am7jhtBmSvbDNnpSTHQeG8Xme/9ALHUTIB9i6C
         xXawuiXy/iD17ih9L/9iH6aVKhmEcqCTIzLgled8=
Date:   Mon, 31 Aug 2020 12:29:08 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        christophe.leroy@csgroup.eu
Subject:  +
 selftests-vm-fix-display-of-page-size-in-map_hugetlb.patch added to -mm tree
Message-ID: <20200831192908.avTqq%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix display of page size in map_hugetlb
has been added to the -mm tree.  Its filename is
     selftests-vm-fix-display-of-page-size-in-map_hugetlb.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-fix-display-of-page-size-in-map_hugetlb.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-fix-display-of-page-size-in-map_hugetlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: selftests/vm: fix display of page size in map_hugetlb

The displayed size is in bytes while the text says it is in kB.

Shift it by 10 to really display kBytes.

Link: https://lkml.kernel.org/r/e27481224564a93d14106e750de31189deaa8bc8.1598861977.git.christophe.leroy@csgroup.eu
Fixes: fa7b9a805c79 ("tools/selftest/vm: allow choosing mem size and page size in map_hugetlb")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/map_hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/map_hugetlb.c~selftests-vm-fix-display-of-page-size-in-map_hugetlb
+++ a/tools/testing/selftests/vm/map_hugetlb.c
@@ -83,7 +83,7 @@ int main(int argc, char **argv)
 	}
 
 	if (shift)
-		printf("%u kB hugepages\n", 1 << shift);
+		printf("%u kB hugepages\n", 1 << (shift - 10));
 	else
 		printf("Default size hugepages\n");
 	printf("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

selftests-vm-fix-display-of-page-size-in-map_hugetlb.patch

