Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0474A3A283E
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 11:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhFJJaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 05:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhFJJaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 05:30:15 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55688C061574;
        Thu, 10 Jun 2021 02:28:19 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4G0zDJ1JgPzQk27;
        Thu, 10 Jun 2021 11:28:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :subject:subject:message-id:from:from:date:date:received; s=
        mail20150812; t=1623317284; bh=4hSIxgHAWpB4uGZWppZafLhGwOCvmS3rz
        GvjZTINgmE=; b=lddhgl0aMot4oG6bqhkJiIiv1ObqUzxsGn3vZZ0QYj/NBDk3o
        TtyjKaXgqVtNdMO5yATKU4PLkhmZCcPSU/xcNiNaiRPZ72KVBIUtmPbWIBuHIFP+
        eJiC9WkvbiCJ2DOJ2wAPBAcY8eWvEaH37zn3wyAlGkL9VmP0Q42noLskUaRZXSIu
        QK8w+T6a8qcUoGm+tNXAC53WkoutZb3ycwiG/phYOJtaXvUX4G5E6cgdrwM/TOky
        Lr8srOWEukVpT20RegdwHOqUEy+7JV4vCjdsfVpWJDkOLmVzft9fkA0s2C4cFbIi
        6UF8xhYex7ApdD9mbqnqtoKN/G2xyuTLuIjXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1623317289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+5/kdhJ1QddJK81vRh3OO6rMlzIyFuqMZwmf8YHz1N4=;
        b=eZkwL6Ao1O2t6K8HTwSLEbKGSyxGwAM3SnhDl5PGzUeZlz7wO/wLkCMe6qDi8YZ6yHe+ew
        qpbWV3AcgmG2xEL03/4oebVmXqfy1mjoI7Q4HlkrOp19c64bZQYVUq6U5TsCL5x8HuSxAN
        bWPXRSyKnH3m48t77d0nF/F68AtcrK7HF+XRL29+1ndPPZ53ksZoiUwZGeVZupdB0d6Dk6
        6x/p4jMwBLq7S59r21tBEKyavloXJhVENE3O7mEZZTiwLRaV3svw9oCaHUsjtPvL62vSt8
        qCFTplzA5vKs0eIKfA8lZSXXycvu5fql7dd5fz69U08WzxwN4slFWRDp4gpUgQ==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id mOch9IlfOmlB; Thu, 10 Jun 2021 11:28:04 +0200 (CEST)
Date:   Thu, 10 Jun 2021 11:28:04 +0200 (CEST)
From:   torvic9@mailbox.org
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>
Message-ID: <214134496.67043.1623317284090@office.mailbox.org>
Subject: [PATCH] x86/Makefile: make -stack-alignment conditional on LLD <
 13.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.56 / 15.00 / 15.00
X-Rspamd-Queue-Id: C9D4117F3
X-Rspamd-UID: 513dc9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since LLVM commit 3787ee4, the '-stack-alignment' flag has been dropped [1],
leading to the following error message when building a LTO kernel with
Clang-13 and LLD-13:

    ld.lld: error: -plugin-opt=-: ld.lld: Unknown command line argument 
    '-stack-alignment=8'.  Try 'ld.lld --help'
    ld.lld: Did you mean '--stackrealign=8'?

It also appears that the '-code-model' flag is not necessary anymore starting
with LLVM-9 [2].

Drop '-code-model' and make '-stack-alignment' conditional on LLD < 13.0.0.

This is for linux-stable 5.12.
Another patch will be submitted for 5.13 shortly (unless there are objections).

Discussion: https://github.com/ClangBuiltLinux/linux/issues/1377
[1]: https://reviews.llvm.org/D103048
[2]: https://reviews.llvm.org/D52322

Signed-off-by: Tor Vic <torvic9@mailbox.org>
---
 arch/x86/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1f2e5bf..2855a1a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -192,8 +192,9 @@ endif
 KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
 
 ifdef CONFIG_LTO_CLANG
-KBUILD_LDFLAGS	+= -plugin-opt=-code-model=kernel \
-		   -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
+ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 130000; echo $$?),0)
+KBUILD_LDFLAGS	+= -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
+endif
 endif
 
 ifdef CONFIG_X86_NEED_RELOCS
-- 
2.32.0
