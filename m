Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA592F52E4
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 20:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbhAMS6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 13:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728486AbhAMS6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 13:58:42 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABCBC061575
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 10:58:02 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id c14so1872174qtn.0
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 10:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=R0vScRcOj6vqLz9Se5XHhEJNF1iBeKmfvbbQWWzvk5w=;
        b=vAv17m/Z6dKVtETDddCPNItDNc6YKaDmv3i95/djzwlwoFuI0yioH1g6D/XKqRFVvk
         ZThQjndnfb6wZJDBCmp/MnU56Hv+zFjRbnpkgTOzm7LIRlbv8uReQ3DGERaOMDzm+5t/
         vh8QA6CoLJJiuQoonDoozKjicpyxnQZZ2q8uRVsxdF94wwau3MQZYZDxQbdo//EgzBQB
         3re0GlX1MPK9KEs+C+Im1/qiFgmVCzA1TsfCEf6e1He6JYntALa87lZ64c/y+UTA2iH0
         HNbLecrLw2xTmg69sY1nKa/scg4BagM4nqZSh9oW6u24HYDkLVsJ6ZYO5qRpUHDcTlqH
         DNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=R0vScRcOj6vqLz9Se5XHhEJNF1iBeKmfvbbQWWzvk5w=;
        b=MwTj1FuepIgnpOv7MhgVbzGc6Z3ftO/b51KXVE78JHadQW8Hhh+Xt5DekqEVqu+Ygu
         O+VIIyqOf6DZTsL0gRazm1iN5/2dSh6eo4QjbKWLw6VL2GK7kIeWdJtarV8P6TIEmg6I
         ElyjGe70GUXq43w4wgY5iWbOrcmsHlr69dPpDrkHyIlD+lCom9iFkQ8LTtiJdeowSP66
         JTtF4Gj3r8KSMgW51/zbyDK/zyAA1NyqU6+IywGqeJzQAx2cYPAGba66YNnB1dLRisDo
         N0FJMBM9f914hCNCug8Qan7LXcduai8yGyU1L9Qan04JSrguxytQTUPs6logjyUs0AkF
         CQ0Q==
X-Gm-Message-State: AOAM530kDTMmr1FEDXZmIJuuZUt7KNkkqGjvOHkTD4YEraim3OD/oHF/
        TISlGd4L+MbJjM7MfmsZXCY=
X-Google-Smtp-Source: ABdhPJzaXz1oGlXIvXegs9rz3tl2zLKZ1CQBKzCHsgUT6NZgi0Xepd7VOoWHjE7br+Hna0jC+t7USg==
X-Received: by 2002:ac8:5ed5:: with SMTP id s21mr3788852qtx.114.1610564281441;
        Wed, 13 Jan 2021 10:58:01 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id 16sm1561466qkf.112.2021.01.13.10.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 10:58:00 -0800 (PST)
Date:   Wed, 13 Jan 2021 11:57:58 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Subject: Backports of eff8728fe69880d3f7983bec3fb6cea4c306261f for 4.4 to 5.4
Message-ID: <20210113185758.GA571703@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg and Sasha,

Please apply the attached backports of commit
eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input sections") to
4.4 through 5.4. I tried to make the file names obvious. This fixes a
boot failure on ARCH=arm with LLVM 12.

Cheers,
Nathan

--G4iJoqBmSsgzjUCe
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="eff8728fe6988-5.4-4.14.patch"
Content-Transfer-Encoding: 8bit

From 6afd4a462594ea24bb602350cd95b4b00a2d8f5b Mon Sep 17 00:00:00 2001
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 21 Aug 2020 12:42:47 -0700
Subject: [PATCH 5.4 to 4.14] vmlinux.lds.h: Add PGO and AutoFDO input sections
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit eff8728fe69880d3f7983bec3fb6cea4c306261f upstream.

Basically, consider .text.{hot|unlikely|unknown}.* part of .text, too.

When compiling with profiling information (collected via PGO
instrumentations or AutoFDO sampling), Clang will separate code into
.text.hot, .text.unlikely, or .text.unknown sections based on profiling
information. After D79600 (clang-11), these sections will have a
trailing `.` suffix, ie.  .text.hot., .text.unlikely., .text.unknown..

When using -ffunction-sections together with profiling infomation,
either explicitly (FGKASLR) or implicitly (LTO), code may be placed in
sections following the convention:
.text.hot.<foo>, .text.unlikely.<bar>, .text.unknown.<baz>
where <foo>, <bar>, and <baz> are functions.  (This produces one section
per function; we generally try to merge these all back via linker script
so that we don't have 50k sections).

For the above cases, we need to teach our linker scripts that such
sections might exist and that we'd explicitly like them grouped
together, otherwise we can wind up with code outside of the
_stext/_etext boundaries that might not be mapped properly for some
architectures, resulting in boot failures.

If the linker script is not told about possible input sections, then
where the section is placed as output is a heuristic-laiden mess that's
non-portable between linkers (ie. BFD and LLD), and has resulted in many
hard to debug bugs.  Kees Cook is working on cleaning this up by adding
--orphan-handling=warn linker flag used in ARCH=powerpc to additional
architectures. In the case of linker scripts, borrowing from the Zen of
Python: explicit is better than implicit.

Also, ld.bfd's internal linker script considers .text.hot AND
.text.hot.* to be part of .text, as well as .text.unlikely and
.text.unlikely.*. I didn't see support for .text.unknown.*, and didn't
see Clang producing such code in our kernel builds, but I see code in
LLVM that can produce such section names if profiling information is
missing. That may point to a larger issue with generating or collecting
profiles, but I would much rather be safe and explicit than have to
debug yet another issue related to orphan section placement.

Reported-by: Jian Cai <jiancai@google.com>
Suggested-by: Fāng-ruì Sòng <maskray@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Luis Lozano <llozano@google.com>
Tested-by: Manoj Gupta <manojgupta@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: linux-arch@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=add44f8d5c5c05e08b11e033127a744d61c26aee
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=1de778ed23ce7492c523d5850c6c6dbb34152655
Link: https://reviews.llvm.org/D79600
Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1084760
Link: https://lore.kernel.org/r/20200821194310.3089815-7-keescook@chromium.org

Debugged-by: Luis Lozano <llozano@google.com>
[nc: Resolve small conflict due to lack of NOINSTR_TEXT]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 include/asm-generic/vmlinux.lds.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e5e242587595..130f16cc0b86 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -520,7 +520,10 @@
  */
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
-		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely)	\
+		*(.text.hot .text.hot.*)				\
+		*(TEXT_MAIN .text.fixup)				\
+		*(.text.unlikely .text.unlikely.*)			\
+		*(.text.unknown .text.unknown.*)			\
 		*(.text..refcount)					\
 		*(.ref.text)						\
 	MEM_KEEP(init.text*)						\
-- 
2.30.0


--G4iJoqBmSsgzjUCe
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="eff8728fe6988-4.9.patch"
Content-Transfer-Encoding: 8bit

From a017289ff8851b0b219b9b9d755685043ef4e5e3 Mon Sep 17 00:00:00 2001
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 21 Aug 2020 12:42:47 -0700
Subject: [PATCH 4.9] vmlinux.lds.h: Add PGO and AutoFDO input sections
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit eff8728fe69880d3f7983bec3fb6cea4c306261f upstream.

Basically, consider .text.{hot|unlikely|unknown}.* part of .text, too.

When compiling with profiling information (collected via PGO
instrumentations or AutoFDO sampling), Clang will separate code into
.text.hot, .text.unlikely, or .text.unknown sections based on profiling
information. After D79600 (clang-11), these sections will have a
trailing `.` suffix, ie.  .text.hot., .text.unlikely., .text.unknown..

When using -ffunction-sections together with profiling infomation,
either explicitly (FGKASLR) or implicitly (LTO), code may be placed in
sections following the convention:
.text.hot.<foo>, .text.unlikely.<bar>, .text.unknown.<baz>
where <foo>, <bar>, and <baz> are functions.  (This produces one section
per function; we generally try to merge these all back via linker script
so that we don't have 50k sections).

For the above cases, we need to teach our linker scripts that such
sections might exist and that we'd explicitly like them grouped
together, otherwise we can wind up with code outside of the
_stext/_etext boundaries that might not be mapped properly for some
architectures, resulting in boot failures.

If the linker script is not told about possible input sections, then
where the section is placed as output is a heuristic-laiden mess that's
non-portable between linkers (ie. BFD and LLD), and has resulted in many
hard to debug bugs.  Kees Cook is working on cleaning this up by adding
--orphan-handling=warn linker flag used in ARCH=powerpc to additional
architectures. In the case of linker scripts, borrowing from the Zen of
Python: explicit is better than implicit.

Also, ld.bfd's internal linker script considers .text.hot AND
.text.hot.* to be part of .text, as well as .text.unlikely and
.text.unlikely.*. I didn't see support for .text.unknown.*, and didn't
see Clang producing such code in our kernel builds, but I see code in
LLVM that can produce such section names if profiling information is
missing. That may point to a larger issue with generating or collecting
profiles, but I would much rather be safe and explicit than have to
debug yet another issue related to orphan section placement.

Reported-by: Jian Cai <jiancai@google.com>
Suggested-by: Fāng-ruì Sòng <maskray@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Luis Lozano <llozano@google.com>
Tested-by: Manoj Gupta <manojgupta@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: linux-arch@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=add44f8d5c5c05e08b11e033127a744d61c26aee
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=1de778ed23ce7492c523d5850c6c6dbb34152655
Link: https://reviews.llvm.org/D79600
Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1084760
Link: https://lore.kernel.org/r/20200821194310.3089815-7-keescook@chromium.org

Debugged-by: Luis Lozano <llozano@google.com>
[nc: Fix small conflict around lack of NOINSTR_TEXT and .text..refcount]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 include/asm-generic/vmlinux.lds.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 4fdb1d984844..36198563fb8b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -460,7 +460,10 @@
  */
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
-		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely)	\
+		*(.text.hot .text.hot.*)				\
+		*(TEXT_MAIN .text.fixup)				\
+		*(.text.unlikely .text.unlikely.*)			\
+		*(.text.unknown .text.unknown.*)			\
 		*(.ref.text)						\
 	MEM_KEEP(init.text)						\
 	MEM_KEEP(exit.text)						\
-- 
2.30.0


--G4iJoqBmSsgzjUCe
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="eff8728fe6988-4.4.patch"
Content-Transfer-Encoding: 8bit

From 43398bda7eafc0c5a79fbf9dfd593f106fd7f013 Mon Sep 17 00:00:00 2001
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 21 Aug 2020 12:42:47 -0700
Subject: [PATCH 4.4] vmlinux.lds.h: Add PGO and AutoFDO input sections
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit eff8728fe69880d3f7983bec3fb6cea4c306261f upstream.

Basically, consider .text.{hot|unlikely|unknown}.* part of .text, too.

When compiling with profiling information (collected via PGO
instrumentations or AutoFDO sampling), Clang will separate code into
.text.hot, .text.unlikely, or .text.unknown sections based on profiling
information. After D79600 (clang-11), these sections will have a
trailing `.` suffix, ie.  .text.hot., .text.unlikely., .text.unknown..

When using -ffunction-sections together with profiling infomation,
either explicitly (FGKASLR) or implicitly (LTO), code may be placed in
sections following the convention:
.text.hot.<foo>, .text.unlikely.<bar>, .text.unknown.<baz>
where <foo>, <bar>, and <baz> are functions.  (This produces one section
per function; we generally try to merge these all back via linker script
so that we don't have 50k sections).

For the above cases, we need to teach our linker scripts that such
sections might exist and that we'd explicitly like them grouped
together, otherwise we can wind up with code outside of the
_stext/_etext boundaries that might not be mapped properly for some
architectures, resulting in boot failures.

If the linker script is not told about possible input sections, then
where the section is placed as output is a heuristic-laiden mess that's
non-portable between linkers (ie. BFD and LLD), and has resulted in many
hard to debug bugs.  Kees Cook is working on cleaning this up by adding
--orphan-handling=warn linker flag used in ARCH=powerpc to additional
architectures. In the case of linker scripts, borrowing from the Zen of
Python: explicit is better than implicit.

Also, ld.bfd's internal linker script considers .text.hot AND
.text.hot.* to be part of .text, as well as .text.unlikely and
.text.unlikely.*. I didn't see support for .text.unknown.*, and didn't
see Clang producing such code in our kernel builds, but I see code in
LLVM that can produce such section names if profiling information is
missing. That may point to a larger issue with generating or collecting
profiles, but I would much rather be safe and explicit than have to
debug yet another issue related to orphan section placement.

Reported-by: Jian Cai <jiancai@google.com>
Suggested-by: Fāng-ruì Sòng <maskray@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Luis Lozano <llozano@google.com>
Tested-by: Manoj Gupta <manojgupta@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: linux-arch@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=add44f8d5c5c05e08b11e033127a744d61c26aee
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=1de778ed23ce7492c523d5850c6c6dbb34152655
Link: https://reviews.llvm.org/D79600
Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1084760
Link: https://lore.kernel.org/r/20200821194310.3089815-7-keescook@chromium.org

Debugged-by: Luis Lozano <llozano@google.com>
[nc: Fix conflicts around lack of TEXT_MAIN, NOINSTR_TEXT, and
     .text..refcount]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 include/asm-generic/vmlinux.lds.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a461b6604fd9..c8535bc1826f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -422,7 +422,10 @@
  * during second ld run in second ld pass when generating System.map */
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
-		*(.text.hot .text .text.fixup .text.unlikely)		\
+		*(.text.hot .text.hot.*)				\
+		*(.text .text.fixup)					\
+		*(.text.unlikely .text.unlikely.*)			\
+		*(.text.unknown .text.unknown.*)			\
 		*(.ref.text)						\
 	MEM_KEEP(init.text)						\
 	MEM_KEEP(exit.text)						\
-- 
2.30.0


--G4iJoqBmSsgzjUCe--
