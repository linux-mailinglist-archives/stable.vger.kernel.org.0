Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AC735B8F4
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 05:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhDLDeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 23:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbhDLDen (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 23:34:43 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DC3C061574;
        Sun, 11 Apr 2021 20:34:13 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id u3so5620700qvj.8;
        Sun, 11 Apr 2021 20:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tylWXA1xPk8RoAKzIzmmSXUT5PkmyoA4fdI3fTO/53k=;
        b=Cf5g0+bgpVx1Wu8ODFgXMDLAeeXHOfgw7WgSyxrWm4/hmxxmkMrpP0+0pnt1K9JKUE
         3P0Ku0ksFolddL7WAdAwbTIjfB3ZzXbjqA6typaQFkNqGAHCSliNzeiN0Y8sX+dGMZfC
         H1OdyEk8UeI7KIcst7A/Oj0IL1bypuM+Dk33nQKnd767ZSCg4fenkDsyOBf2aoYeu8o3
         kkYiDGjrpCQqlUXB6TB9MnFYv0mgy6jFRVWBPyZaETBxTxZclTgbmbU+LpHbBa0j5mSG
         Z+a2u6/5DdLp4BPGuuJ4N1ca94xiws9/HfNz7vL6VrlysglCFwsems/p6JOebuKlR0/+
         k53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=tylWXA1xPk8RoAKzIzmmSXUT5PkmyoA4fdI3fTO/53k=;
        b=eiPYoDsg/NvqdFqvLRxHONjftvaCKjH1efiJ/2uMpK2/Vg7vzWhr7AZar1zFRwNfkG
         OzWjT1nBcC5zeDVtH2lah9GtCjTirUEvmUPhPZX2wZmDQAfgbqUjLdY1nxzRFcUqlJCi
         dQGbdxi7iZG5HrZpYyJx/RFCRWMTAMYY/1GKuE/aIXqMEaz3oeEYBOcUwlN1yvMzYhAd
         45iw0Zdij/jL7S0DTEKZnmRrdYOc/ADdMfr1Nda5UT/ndKVuLjoPPmOsxiEOTMf2RUrk
         FzR6e49Z1HShp3FSxa31Q0tco211r3yboGETOTUL3g+MPJ6dlbfQSLhPJjgkczmcMO/z
         pzmQ==
X-Gm-Message-State: AOAM533x/onamt8iEC9t8wXlppnMD7Wb8shld0nV2Bo3TqsNqnLRRpSH
        Dex0XD43CtPCeFka2ibCRv78GO3oK7Q=
X-Google-Smtp-Source: ABdhPJx+4WjxKTvDX3jaMObTOCxB+UmixJgL/tIEvVR/Ee4+3625VUkZpaZ1pBXlSppejJnNWCWliQ==
X-Received: by 2002:ad4:5e8b:: with SMTP id jl11mr25804869qvb.50.1618198452999;
        Sun, 11 Apr 2021 20:34:12 -0700 (PDT)
Received: from localhost.localdomain ([107.172.207.180])
        by smtp.gmail.com with ESMTPSA id c17sm6772429qtd.71.2021.04.11.20.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 20:34:12 -0700 (PDT)
Sender: Huacai Chen <chenhuacai@gmail.com>
From:   Huacai Chen <chenhuacai@kernel.org>
X-Google-Original-From: Huacai Chen <chenhuacai@loongson.cn>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org
Subject: [PATCH] MIPS: Remove unused and erroneous div64.h
Date:   Mon, 12 Apr 2021 11:34:51 +0800
Message-Id: <20210412033451.215379-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are many errors in div64.h caused by commit c21004cd5b4cb7d479514
("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0."):

1, Only 32bit kernel need __div64_32(), but the above commit makes it
   depend on 64bit kernel by mistake. So div64.h is unused in fact.

2, asm-generic/div64.h should be included after __div64_32() definition.

3, __n should be initialized as *n before use (and "*__n >> 32" should
   be "__n >> 32") in __div64_32() definition.

4, linux/types.h should be included at the first place, otherwise BITS_
   PER_LONG is not defined.

5, As Nikolaus, Yunqiang Su and Yanjie Zhou said, the MIPS-specific
   __div64_32() sometimes produces wrong results, which makes 32bit
   kernel boot fails.

I have tried to fix theses errors but I have failed with the last one.
Yunqiang's tests show that the MIPS-specific __div64_32() has no obvious
advantage than the C version, so I just simply remove div64.h.

Fixes: c21004cd5b4cb7d479514 ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 arch/mips/include/asm/div64.h | 68 -----------------------------------
 1 file changed, 68 deletions(-)
 delete mode 100644 arch/mips/include/asm/div64.h

diff --git a/arch/mips/include/asm/div64.h b/arch/mips/include/asm/div64.h
deleted file mode 100644
index dc5ea5736440..000000000000
--- a/arch/mips/include/asm/div64.h
+++ /dev/null
@@ -1,68 +0,0 @@
-/*
- * Copyright (C) 2000, 2004  Maciej W. Rozycki
- * Copyright (C) 2003, 07 Ralf Baechle (ralf@linux-mips.org)
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-#ifndef __ASM_DIV64_H
-#define __ASM_DIV64_H
-
-#include <asm-generic/div64.h>
-
-#if BITS_PER_LONG == 64
-
-#include <linux/types.h>
-
-/*
- * No traps on overflows for any of these...
- */
-
-#define __div64_32(n, base)						\
-({									\
-	unsigned long __cf, __tmp, __tmp2, __i;				\
-	unsigned long __quot32, __mod32;				\
-	unsigned long __high, __low;					\
-	unsigned long long __n;						\
-									\
-	__high = *__n >> 32;						\
-	__low = __n;							\
-	__asm__(							\
-	"	.set	push					\n"	\
-	"	.set	noat					\n"	\
-	"	.set	noreorder				\n"	\
-	"	move	%2, $0					\n"	\
-	"	move	%3, $0					\n"	\
-	"	b	1f					\n"	\
-	"	 li	%4, 0x21				\n"	\
-	"0:							\n"	\
-	"	sll	$1, %0, 0x1				\n"	\
-	"	srl	%3, %0, 0x1f				\n"	\
-	"	or	%0, $1, %5				\n"	\
-	"	sll	%1, %1, 0x1				\n"	\
-	"	sll	%2, %2, 0x1				\n"	\
-	"1:							\n"	\
-	"	bnez	%3, 2f					\n"	\
-	"	 sltu	%5, %0, %z6				\n"	\
-	"	bnez	%5, 3f					\n"	\
-	"2:							\n"	\
-	"	 addiu	%4, %4, -1				\n"	\
-	"	subu	%0, %0, %z6				\n"	\
-	"	addiu	%2, %2, 1				\n"	\
-	"3:							\n"	\
-	"	bnez	%4, 0b\n\t"					\
-	"	 srl	%5, %1, 0x1f\n\t"				\
-	"	.set	pop"						\
-	: "=&r" (__mod32), "=&r" (__tmp),				\
-	  "=&r" (__quot32), "=&r" (__cf),				\
-	  "=&r" (__i), "=&r" (__tmp2)					\
-	: "Jr" (base), "0" (__high), "1" (__low));			\
-									\
-	(__n) = __quot32;						\
-	__mod32;							\
-})
-
-#endif /* BITS_PER_LONG == 64 */
-
-#endif /* __ASM_DIV64_H */
-- 
2.27.0

