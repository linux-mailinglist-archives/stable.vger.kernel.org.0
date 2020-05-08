Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169F81CAD0F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgEHMyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728555AbgEHMyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:54:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A12F424967;
        Fri,  8 May 2020 12:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942446;
        bh=D8HBYvqN8U0qNF6YRjF1ddtQqDwXEOnlQVXgEm9b1W0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuAnPH8lEM0JrVgz+ABGYXLAECa8TosWPA6/x7vWmbUocg2YLly0DO+BjPn889uGj
         owzz/pbuRGH257abTnhg/sebI2QP2RPYuDr1LPk2qR49K5yU0vTjptr0E1KHMDO1fk
         2eA3N5ocaL8QaIch/s/mKGGGtaVO+rBloRF1YeIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Amanieu dAntras <amanieu@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 48/50] tools headers UAPI: Sync copy of arm64s asm/unistd.h with the kernel sources
Date:   Fri,  8 May 2020 14:35:54 +0200
Message-Id: <20200508123049.599715301@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit c75bec79fc080039e4575a0f239ea7b111aabe88 upstream.

To get the changes in:

  3e3c8ca5a351 ("arm64: Move __ARCH_WANT_SYS_CLONE3 definition to uapi headers")

Silencing this tools/perf/ build warning:

  Warning: Kernel ABI header at 'tools/arch/arm64/include/uapi/asm/unistd.h' differs from latest version at 'arch/arm64/include/uapi/asm/unistd.h'
  diff -u tools/arch/arm64/include/uapi/asm/unistd.h arch/arm64/include/uapi/asm/unistd.h

Which will probably end up enabling the use of "clone3" in 'perf trace -e',
haven't checked the build with this change on an arm64 system.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Amanieu d'Antras <amanieu@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/arch/arm64/include/uapi/asm/unistd.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/arch/arm64/include/uapi/asm/unistd.h
+++ b/tools/arch/arm64/include/uapi/asm/unistd.h
@@ -19,5 +19,6 @@
 #define __ARCH_WANT_NEW_STAT
 #define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_TIME32_SYSCALLS
+#define __ARCH_WANT_SYS_CLONE3
 
 #include <asm-generic/unistd.h>


