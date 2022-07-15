Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F786576A80
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 01:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiGOXQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 19:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbiGOXQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 19:16:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE20190D9D
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 16:16:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o200-20020a2541d1000000b0066ebb148de6so4842624yba.15
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 16:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M/e6KYta8k454tv6cUU3yk3M9/megrk9Osp3qk1WTb8=;
        b=Yy8KCGywfkAAfO3LjSVhSMyG48X/3HF0iUCChpf9Y8VUt0En16Jg9o3VtrbLTNwCWK
         zGKoQG0hSWUBadHVdE+nn/LmkQ08M8Q5oUMXDtcD35KCy2J9+oVqR9Qx1juUTMceIS/O
         y9LuYMIFW9yDdt9KAAcA4h1/DwwTthGWunScqjhTdgrrgIugVfIzlJbioEJI+uPdW34k
         GYB9zkJMk41nojUwjMKtrNBU8QwR0da/N3IpjZq93CEqBbHMB/hqdImpRIigUcsOLxMn
         i4wf7sXCTOmZbr7X1aMuUzC96VbPrtr/Gdkc3BSlebFE5XgJ3FPi55C9fR4FKv9qWiky
         O5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M/e6KYta8k454tv6cUU3yk3M9/megrk9Osp3qk1WTb8=;
        b=OoMg2JGj230tfu9BsUOpc17ZT+uxlLb5z+KWn0Od/3VHCW8IxWbFMqGmlx3yg5j83h
         eQq7soHUn0sN57mcbzsxCqIQ4yywO38BOephrh9AL8LRhlZyuUN0qd6yFge8gXL56d+U
         1z7s2JQE/0On4qdZsmQRVU1l+OdfNqIO1jhXWVM1ejL0uy+ggY3wnCVUOEa2XFwNRqpr
         suyCOWMypPatKaosR+2iewjnKbmeJbSxhX3dNVHbuNBKulyVx9/Ik6ZQmi/VC37mLDuz
         Kt0ANFFUUIYDMZ6vsIaHiVwzyRdSVRuUo37ms/oZyAKlvOKXJqQnmb/+wsP70HLM5fFO
         JxeA==
X-Gm-Message-State: AJIora/+CqKKONojmrMOWJq8b0fqcmRLIuI/2GZI1AB8Xscs00Ekhz00
        MHP8riFYXywKaPXUj9tT0HA9Naw=
X-Google-Smtp-Source: AGRyM1tWaWSx+X7eqUhVHFly73ad79BBhy7HXPKLRigVydfEy/dgfLiDYex/y5itiGR0gWeo/OVcEvU=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a0d:d757:0:b0:31c:87bb:d546 with SMTP id
 z84-20020a0dd757000000b0031c87bbd546mr18029453ywd.472.1657926982067; Fri, 15
 Jul 2022 16:16:22 -0700 (PDT)
Date:   Fri, 15 Jul 2022 23:15:42 +0000
In-Reply-To: <20220715231542.2169650-1-ovt@google.com>
Message-Id: <20220715231542.2169650-3-ovt@google.com>
Mime-Version: 1.0
References: <20220715231542.2169650-1-ovt@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH 2/2] Revert "selftest/vm: verify mmap addr in mremap_test"
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     gregkh@linuxfoundation.org
Cc:     sidhartha.kumar@oracle.com, stable@vger.kernel.org,
        Oleksandr Tymoshenko <ovt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit e8b9989597daac896b3400b7005f24bf15233d9a.

The upstream commit 9c85a9bae267 ("selftest/vm: verify mmap addr in
mremap_test") was backported as commit a17404fcbfd0 ("selftest/vm:
verify mmap addr in mremap_test"). Repeated backport introduced the
duplicate of function get_mmap_min_addr to the file breakign the vm
selftest build.

Fixes: e8b9989597da ("selftest/vm: verify mmap addr in mremap_test")
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
---
 tools/testing/selftests/vm/mremap_test.c | 29 ------------------------
 1 file changed, 29 deletions(-)

diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index efcbf537b3d5..e3ce33a9954e 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -66,35 +66,6 @@ enum {
 	.expect_failure = should_fail				\
 }
 
-/* Returns mmap_min_addr sysctl tunable from procfs */
-static unsigned long long get_mmap_min_addr(void)
-{
-	FILE *fp;
-	int n_matched;
-	static unsigned long long addr;
-
-	if (addr)
-		return addr;
-
-	fp = fopen("/proc/sys/vm/mmap_min_addr", "r");
-	if (fp == NULL) {
-		ksft_print_msg("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
-			strerror(errno));
-		exit(KSFT_SKIP);
-	}
-
-	n_matched = fscanf(fp, "%llu", &addr);
-	if (n_matched != 1) {
-		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
-			strerror(errno));
-		fclose(fp);
-		exit(KSFT_SKIP);
-	}
-
-	fclose(fp);
-	return addr;
-}
-
 /*
  * Returns false if the requested remap region overlaps with an
  * existing mapping (e.g text, stack) else returns true.
-- 
2.37.0.170.g444d1eabd0-goog

