Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D341CAD22
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgEHMwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729939AbgEHMwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:52:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CF9A2495C;
        Fri,  8 May 2020 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942330;
        bh=99e2e49jVyP6KgaTxONJgD6vclc1pSQXLVl2yYtOBrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sejnadb/0bygnd/QPW78hwt+aFa2cj6/b7ORqbf8FL7Q4CMRyXLHt5QVI51M3paBk
         InigjfAL4PqzTlysPuXZrYibAbAN2Zp2jfEHhMyuyxWoW7OYNqaCIc1msHupWcipMD
         mfCLuOhT3jk+PUavF9Cjdq3p5vFOHjUUC7sLbQtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Brian Cain <bcain@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tuowen Zhao <ztuowen@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Will Deacon <will@kernel.org>,
        Richard Fontana <rfontana@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 27/32] hexagon: define ioremap_uc
Date:   Fri,  8 May 2020 14:35:40 +0200
Message-Id: <20200508123038.844529381@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123034.886699170@linuxfoundation.org>
References: <20200508123034.886699170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 7312b70699252074d753c5005fc67266c547bbe3 upstream.

Similar to commit 38e45d81d14e ("sparc64: implement ioremap_uc") define
ioremap_uc for hexagon to avoid errors from
-Wimplicit-function-definition.

Link: http://lkml.kernel.org/r/20191209222956.239798-2-ndesaulniers@google.com
Link: https://github.com/ClangBuiltLinux/linux/issues/797
Fixes: e537654b7039 ("lib: devres: add a helper function for ioremap_uc")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Brian Cain <bcain@codeaurora.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Tuowen Zhao <ztuowen@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexios Zavras <alexios.zavras@intel.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: Will Deacon <will@kernel.org>
Cc: Richard Fontana <rfontana@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/hexagon/include/asm/io.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/include/asm/io.h
+++ b/arch/hexagon/include/asm/io.h
@@ -188,6 +188,7 @@ static inline void writel(u32 data, vola
 
 void __iomem *ioremap(unsigned long phys_addr, unsigned long size);
 #define ioremap_nocache ioremap
+#define ioremap_uc(X, Y) ioremap((X), (Y))
 
 
 static inline void iounmap(volatile void __iomem *addr)


