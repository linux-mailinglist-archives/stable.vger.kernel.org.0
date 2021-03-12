Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F45339996
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 23:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhCLWSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 17:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbhCLWRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 17:17:55 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280E3C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 14:17:55 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id k188so1012745qkb.5
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 14:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9d5EzMi2Qyza7j5RoXoFBY5ffCk5Fa8WDGdaqKQXcLg=;
        b=uBeZyQlaaTWgEI/g5YQbNNghQJizjeHBNqt9ISLQjhxH3pcnZSI7KwRPvJ0il+dFZS
         PL4ylk+gAQKc5z/54IhR8kXL+BoK7Ph7fnbzBr7ac6q0JCC425MC52xK1csA+c9bvza6
         FGyu3D+N+B4/zLohpiD9AgtF5hGqlDW1tMMfvwRbxoG5OccFDLpE1150Rv3A4Jz9gBxB
         DmcpV8qbRy2Cym1+XCB8l3yecvSMgVwgrf+kim3DXb82Xoz2CmD9TVFgOmk7jUigw+LI
         5ihfJVfHwS03VMSrrknQly6Cp6TgrTLR7MGXl5LfaVeYgHmFHcGbG+7qYwAdzSS+FHHA
         gkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9d5EzMi2Qyza7j5RoXoFBY5ffCk5Fa8WDGdaqKQXcLg=;
        b=qL7VK+qOJ1UnGOnRe6ARq2TBBiQIgeXb7bRgXC1FGK4Y2LTV376SoGzQuzQFi5SNbt
         FwJlnfX0OaBrjovIv2+RW32T6YIrHcJsQwo9RBjmLR2qdmjKtqY3X6T+rAfl74W2PQhJ
         VacL7oc56PaSvyzTCxyzhULjITxVzF1UtUyHu6SJEzmtJnelKOfbbgJTPQ0XpUb8gW7E
         e6+Qqd+oceeSq2muUzWtvug3zWCelnJmc4+/VCPPQemgbfUgyipT8AGh0TqnZLT7lDaN
         8YxszuDpx/MInkAtR8MKqJRZtyL5UFHuPRIDqW4UFKNnGpu1kQ5GqpHeugErbn0ctidb
         a+pA==
X-Gm-Message-State: AOAM533C3Kvv/i7Pb7BZvIOgzAm6VTHx1GhS7zjttTrNi0u3Muu1fGlz
        3+XamDaFFpNWXBsSvxBBRVoVSo7avS5utq5H/U9G2s2BNxduIWDGCtXo2O3q44Zw4aU3oxmunlL
        xC/erYLGzhzryPS1QiM+3/Yx7Jrt5vhvDkboSqfbSvWy7aZZ/6aFJYtJ14DV9tMF2L7DkXM6X
X-Google-Smtp-Source: ABdhPJweH8CkpdLxQ93OgIV7lQU84jwr1AvkKpaFtNiQ6ACynxumkbhemflPxVvimzu04fIn4iycbe9mm6H0eavi
X-Received: from manoj.svl.corp.google.com ([2620:15c:2ce:0:3159:c5f3:85f4:e811])
 (user=manojgupta job=sendgmr) by 2002:a0c:c489:: with SMTP id
 u9mr353843qvi.47.1615587474347; Fri, 12 Mar 2021 14:17:54 -0800 (PST)
Date:   Fri, 12 Mar 2021 14:17:49 -0800
In-Reply-To: <CAH=QcsjHmWdLU6u-imNYWU2v=9ieP8bOk22FLERUd+rVUeqZNw@mail.gmail.com>
Message-Id: <20210312221749.1248947-1-manojgupta@google.com>
Mime-Version: 1.0
References: <CAH=QcsjHmWdLU6u-imNYWU2v=9ieP8bOk22FLERUd+rVUeqZNw@mail.gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v2] scripts/recordmcount.{c,pl}: support -ffunction-sections
 .text.* section names
From:   Manoj Gupta <manojgupta@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        clang-built-linux@googlegroups.com, ndesaulniers@google.com,
        jiancai@google.com, dianders@google.com, llozano@google.com,
        manojgupta@google.com, Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Lawrence <joe.lawrence@redhat.com>

commit 9c8e2f6d3d361439cc6744a094f1c15681b55269 upstream.

When building with -ffunction-sections, the compiler will place each
function into its own ELF section, prefixed with ".text".  For example,
a simple test module with functions test_module_do_work() and
test_module_wq_func():

  % objdump --section-headers test_module.o | awk '/\.text/{print $2}'
  .text
  .text.test_module_do_work
  .text.test_module_wq_func
  .init.text
  .exit.text

Adjust the recordmcount scripts to look for ".text" as a section name
prefix.  This will ensure that those functions will be included in the
__mcount_loc relocations:

  % objdump --reloc --section __mcount_loc test_module.o
  OFFSET           TYPE              VALUE
  0000000000000000 R_X86_64_64       .text.test_module_do_work
  0000000000000008 R_X86_64_64       .text.test_module_wq_func
  0000000000000010 R_X86_64_64       .init.text

Link: http://lkml.kernel.org/r/1542745158-25392-2-git-send-email-joe.lawrence@redhat.com

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

[Manoj: Resolve conflict on 4.4.y/4.9.y because of missing 42c269c88dc1]
Signed-off-by: Manoj Gupta <manojgupta@google.com>
---

Changes v1 -> v2:
  Change "nc" to "Manoj"

 scripts/recordmcount.c  |  2 +-
 scripts/recordmcount.pl | 13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 7250fb38350c..8cba4c44da4c 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -362,7 +362,7 @@ static uint32_t (*w2)(uint16_t);
 static int
 is_mcounted_section_name(char const *const txtname)
 {
-	return strcmp(".text",           txtname) == 0 ||
+	return strncmp(".text",          txtname, 5) == 0 ||
 		strcmp(".ref.text",      txtname) == 0 ||
 		strcmp(".sched.text",    txtname) == 0 ||
 		strcmp(".spinlock.text", txtname) == 0 ||
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index ccd6614ea218..5ca4ec297019 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -138,6 +138,11 @@ my %text_sections = (
      ".text.unlikely" => 1,
 );
 
+# Acceptable section-prefixes to record.
+my %text_section_prefixes = (
+     ".text." => 1,
+);
+
 # Note: we are nice to C-programmers here, thus we skip the '||='-idiom.
 $objdump = 'objdump' if (!$objdump);
 $objcopy = 'objcopy' if (!$objcopy);
@@ -503,6 +508,14 @@ while (<IN>) {
 
 	# Only record text sections that we know are safe
 	$read_function = defined($text_sections{$1});
+	if (!$read_function) {
+	    foreach my $prefix (keys %text_section_prefixes) {
+	        if (substr($1, 0, length $prefix) eq $prefix) {
+	            $read_function = 1;
+	            last;
+	        }
+	    }
+	}
 	# print out any recorded offsets
 	update_funcs();
 
-- 
2.31.0.rc2.261.g7f71774620-goog

