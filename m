Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CB8501C7F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 22:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346207AbiDNUUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 16:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346204AbiDNUT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 16:19:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D31EB0A8;
        Thu, 14 Apr 2022 13:17:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B31761E95;
        Thu, 14 Apr 2022 20:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA500C385A1;
        Thu, 14 Apr 2022 20:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649967450;
        bh=l5nZ9wGBYR6SwJhM3cixZEzGbWgVbsb3LuHKnFxtIaI=;
        h=Date:To:From:Subject:From;
        b=Ms4xNwORA4oaC0jP2Bc0UsaB8EvSCeNmnNdfCODm1V7udOv2eso+Vxdzf46j/1L0x
         0GYXdmSD5qpqv1fHMQAk8LE+bWuaQcwLHD7pc9/ck1rS/lIBjZujCIN0xdLJ3hN785
         Gk6Np+wt7cGMsKu2omWL69kxWJDVsg9ewFhhm0qs=
Date:   Thu, 14 Apr 2022 13:17:29 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shuah@kernel.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-support-xfail-in-mremap_test.patch added to -mm tree
Message-Id: <20220414201729.EA500C385A1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: selftest/vm: support xfail in mremap_test
has been added to the -mm tree.  Its filename is
     selftest-vm-support-xfail-in-mremap_test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-support-xfail-in-mremap_test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-support-xfail-in-mremap_test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: selftest/vm: support xfail in mremap_test

Use ksft_test_result_xfail for the tests which are expected to fail.

Link: https://lkml.kernel.org/r/20220414171529.62058-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/vm/mremap_test.c~selftest-vm-support-xfail-in-mremap_test
+++ a/tools/testing/selftests/vm/mremap_test.c
@@ -268,7 +268,7 @@ static void run_mremap_test_case(struct
 
 	if (remap_time < 0) {
 		if (test_case.expect_failure)
-			ksft_test_result_pass("%s\n\tExpected mremap failure\n",
+			ksft_test_result_xfail("%s\n\tExpected mremap failure\n",
 					      test_case.name);
 		else {
 			ksft_test_result_fail("%s\n", test_case.name);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

selftest-vm-verify-mmap-addr-in-mremap_test.patch
selftest-vm-verify-remap-destination-address-in-mremap_test.patch
selftest-vm-support-xfail-in-mremap_test.patch
selftest-vm-add-skip-support-to-mremap_test.patch
selftest-vm-clarify-error-statement-in-gup_test.patch

