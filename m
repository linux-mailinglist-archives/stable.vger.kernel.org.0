Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16135278887
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgIYMyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729533AbgIYMyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AF28206DB;
        Fri, 25 Sep 2020 12:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038453;
        bh=Gh6MBL6y1SoosfqQmDFmdcLAAsRSaJWjXIXtmLWOb+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4ngBYSaVCPybiW4BEVMxDtNS1I7XV29Hc/D4jBwWHBeki+iFg79Z/NtBOf0GyQUN
         0xFPcKmeh4NikNdW1C8tQ3HBAG6g8P7xk48JkVvCZFT2eHntnTaunoP9Xq6EAc9Pcy
         6n4rC3nrqGMlhI1Ql4oYBSqUyGwLNp4ED4SKiMog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 24/37] MAINTAINERS: add CLANG/LLVM BUILD SUPPORT info
Date:   Fri, 25 Sep 2020 14:48:52 +0200
Message-Id: <20200925124724.615556511@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 8708e13c6a0600625eea3aebd027c0715a5d2bb2 upstream.

Add keyword support so that our mailing list gets cc'ed for clang/llvm
patches.  We're pretty active on our mailing list so far as code review.
There are numerous Googlers like myself that are paid to support
building the Linux kernel with Clang and LLVM.

Link: http://lkml.kernel.org/r/20190620001907.255803-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3613,6 +3613,14 @@ M:	Miguel Ojeda <miguel.ojeda.sandonis@g
 S:	Maintained
 F:	.clang-format
 
+CLANG/LLVM BUILD SUPPORT
+L:	clang-built-linux@googlegroups.com
+W:	https://clangbuiltlinux.github.io/
+B:	https://github.com/ClangBuiltLinux/linux/issues
+C:	irc://chat.freenode.net/clangbuiltlinux
+S:	Supported
+K:	\b(?i:clang|llvm)\b
+
 CLEANCACHE API
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
 L:	linux-kernel@vger.kernel.org


