Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C8D57EE68
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbiGWKKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239599AbiGWKJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03582CE534;
        Sat, 23 Jul 2022 03:03:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D29DD61263;
        Sat, 23 Jul 2022 10:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB503C341C0;
        Sat, 23 Jul 2022 10:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570582;
        bh=vZOb0znR5b2+sXNreQRuTLxggurukIZ1dLOaYUIDq9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mTHOoyiJcvqBeOzBy1wsd2LpjjIztLOtODOKg4jAILZVUzAHtXQCNrzWtdpPl0Oh
         mBuFdV5E98SdqrOjFseFJBVpJcK1i9Sv/lvi4oQ9lAi/AJR2Y9NePTdgk6v0IpgGlb
         PNiiIi0gP/5N0yfX9reNxnupqniZ++5aws/22a8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Juergen Gross <jgross@suse.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 147/148] tools arch: Update arch/x86/lib/mem{cpy,set}_64.S copies used in perf bench mem memcpy - again
Date:   Sat, 23 Jul 2022 11:55:59 +0200
Message-Id: <20220723095305.473622561@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit fb24e308b6310541e70d11a3f19dc40742974b95 upstream.

To bring in the change made in this cset:

 5e21a3ecad1500e3 ("x86/alternative: Merge include files")

This just silences these perf tools build warnings, no change in the tools:

  Warning: Kernel ABI header at 'tools/arch/x86/lib/memcpy_64.S' differs from latest version at 'arch/x86/lib/memcpy_64.S'
  diff -u tools/arch/x86/lib/memcpy_64.S arch/x86/lib/memcpy_64.S
  Warning: Kernel ABI header at 'tools/arch/x86/lib/memset_64.S' differs from latest version at 'arch/x86/lib/memset_64.S'
  diff -u tools/arch/x86/lib/memset_64.S arch/x86/lib/memset_64.S

Cc: Borislav Petkov <bp@suse.de>
Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/arch/x86/lib/memcpy_64.S                         | 2 +-
 tools/arch/x86/lib/memset_64.S                         | 2 +-
 tools/include/asm/{alternative-asm.h => alternative.h} | 0
 tools/arch/x86/lib/memcpy_64.S      |    2 +-
 tools/arch/x86/lib/memset_64.S      |    2 +-
 tools/include/asm/alternative-asm.h |   10 ----------
 tools/include/asm/alternative.h     |   10 ++++++++++
 4 files changed, 12 insertions(+), 12 deletions(-)
 rename tools/include/asm/{alternative-asm.h => alternative.h} (100%)

--- a/tools/arch/x86/lib/memcpy_64.S
+++ b/tools/arch/x86/lib/memcpy_64.S
@@ -4,7 +4,7 @@
 #include <linux/linkage.h>
 #include <asm/errno.h>
 #include <asm/cpufeatures.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 #include <asm/export.h>
 
 .pushsection .noinstr.text, "ax"
--- a/tools/arch/x86/lib/memset_64.S
+++ b/tools/arch/x86/lib/memset_64.S
@@ -3,7 +3,7 @@
 
 #include <linux/linkage.h>
 #include <asm/cpufeatures.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 #include <asm/export.h>
 
 /*
--- a/tools/include/asm/alternative-asm.h
+++ /dev/null
@@ -1,10 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _TOOLS_ASM_ALTERNATIVE_ASM_H
-#define _TOOLS_ASM_ALTERNATIVE_ASM_H
-
-/* Just disable it so we can build arch/x86/lib/memcpy_64.S for perf bench: */
-
-#define altinstruction_entry #
-#define ALTERNATIVE_2 #
-
-#endif
--- /dev/null
+++ b/tools/include/asm/alternative.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_ASM_ALTERNATIVE_ASM_H
+#define _TOOLS_ASM_ALTERNATIVE_ASM_H
+
+/* Just disable it so we can build arch/x86/lib/memcpy_64.S for perf bench: */
+
+#define altinstruction_entry #
+#define ALTERNATIVE_2 #
+
+#endif


