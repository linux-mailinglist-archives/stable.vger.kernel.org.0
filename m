Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326324923BF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 11:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237372AbiARK2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 05:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiARK2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 05:28:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1CFC061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 02:28:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A2F2612AF
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 10:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8871CC00446;
        Tue, 18 Jan 2022 10:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642501684;
        bh=jIeHj3onT+gh9najHuJ/m7RrcwJwaI05XKNO1LsDc70=;
        h=From:To:Cc:Subject:Date:From;
        b=qYn7rRFQMtxk4bfZo5g4YONp0vFHwiVuborxQcFVwqEwgnzZdwDDjYy6+1cBeZ25n
         2bmA358yyRzeZM6Yj11Pl81cuXP+ghna+Rw5vKuBdWLcjCZ4SP658mXX/EoUhZvgpU
         8Zofi4vQx1Q1VWv1W6W4ahxCWzrh4lF7Bv8u4a+pjJdR8rCzQ1gx56naLauQBJ5Hi9
         1yQyV8UemfZ0yOLdBkZW/7LEo7CwNNCMgnlBVBFW8gNPK6WxfaHHc62yVPzJR2h/1S
         7JzCZd+jkOyqnJreja3qs45KwtuqzPi5lZn5jRtKrQq7D1JWQ3PyUL7fjgJ+l1rnA0
         NDKcNeLFDWiHA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux@armlinux.org.uk
Cc:     linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@linaro.org, Ard Biesheuvel <ardb@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: Thumb2: align ALT_UP() sections sufficiently
Date:   Tue, 18 Jan 2022 11:27:56 +0100
Message-Id: <20220118102756.1259149-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1724; h=from:subject; bh=jIeHj3onT+gh9najHuJ/m7RrcwJwaI05XKNO1LsDc70=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh5pYr/pem7zmEkR4ghmuvHWHbIcW9OfNDQVzxOQwf pod3yG6JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYeaWKwAKCRDDTyI5ktmPJJcwC/ 0QVB7q2NkrdPHmoTGEno0mdCFS1c4YsEUjTWogmX9O9PhMR9Q9koME1WNSuClxmA+SiMXvGYin/Ko9 5t0GKuyXUHhGvniUfhXjYGgbgHV6r9xo9v5APzF/uzjLG231KKkof8ZdUc1mz9qCeER9Lr007xXE5O 0LT+pIEj4AHuWtnJV20tIbg3QSrOXotijwLmzVo/0lS3M+hjEUdbgSHQO7W9Qh9DWWPFxGtGUTnd5m vDtYW8eY2TS8F1kGew9rvW70AD+pDJ6b23LwJD4eJ5LL5nXcjLQHgCmpvHS48R20gpPPF8thkC5a4C I+C3TrrGDYvKhMv/xCohVDkEY4rTmLpH9/k0SY3bJ93zGkp/kNoghVM9OprVk/lz/SZNZlRfpRKJNb 9l9VriQHieJTs2hdNQWCTps3Qm4aliSXwjDaINCBkF1fjH1uV6OTuqIAutG+S5ZbIVQHMSLvWuwF3N 1GdSOd7o7a733pa3Xgl/m7PftBLwxI94yn1YIUk3v5mYI=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When building for Thumb2, the .alt.smp.init sections that are emitted by
the ALT_UP() patching code may not be 32-bit aligned, even though the
fixup_smp_on_up() routine expects that. This results in alignment faults
at module load time, which need to be fixed up by the fault handler.

So let's align those sections explicitly, and avoid this from occurring.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/assembler.h | 2 ++
 arch/arm/include/asm/processor.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 5a530e25ea1a..51ae4674ca49 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -261,6 +261,7 @@ THUMB(	fpreg	.req	r7	)
  */
 #define ALT_UP(instr...)					\
 	.pushsection ".alt.smp.init", "a"			;\
+	.align	2						;\
 	.long	9998b - .					;\
 9997:	instr							;\
 	.if . - 9997b == 2					;\
@@ -272,6 +273,7 @@ THUMB(	fpreg	.req	r7	)
 	.popsection
 #define ALT_UP_B(label)					\
 	.pushsection ".alt.smp.init", "a"			;\
+	.align	2						;\
 	.long	9998b - .					;\
 	W(b)	. + (label - 9998b)					;\
 	.popsection
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index 6af68edfa53a..bdc35c0e8dfb 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -96,6 +96,7 @@ unsigned long __get_wchan(struct task_struct *p);
 #define __ALT_SMP_ASM(smp, up)						\
 	"9998:	" smp "\n"						\
 	"	.pushsection \".alt.smp.init\", \"a\"\n"		\
+	"	.align	2\n"						\
 	"	.long	9998b - .\n"					\
 	"	" up "\n"						\
 	"	.popsection\n"
-- 
2.30.2

