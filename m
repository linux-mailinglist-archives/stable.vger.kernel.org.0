Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8369A1220DB
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfLQA6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:58:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34808 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbfLQAvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:37 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003Ku-3F; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0005Wa-Nj; Tue, 17 Dec 2019 00:51:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Max Filippov" <jcmvbkbc@gmail.com>
Date:   Tue, 17 Dec 2019 00:46:38 +0000
Message-ID: <lsq.1576543535.181663094@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 064/136] xtensa: drop EXPORT_SYMBOL for outs*/ins*
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 8b39da985194aac2998dd9e3a22d00b596cebf1e upstream.

Custom outs*/ins* implementations are long gone from the xtensa port,
remove matching EXPORT_SYMBOLs.
This fixes the following build warnings issued by modpost since commit
15bfc2348d54 ("modpost: check for static EXPORT_SYMBOL* functions"):

  WARNING: "insb" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "insw" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "insl" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "outsb" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "outsw" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "outsl" [vmlinux] is a static EXPORT_SYMBOL

Fixes: d38efc1f150f ("xtensa: adopt generic io routines")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/xtensa/kernel/xtensa_ksyms.c | 7 -------
 1 file changed, 7 deletions(-)

--- a/arch/xtensa/kernel/xtensa_ksyms.c
+++ b/arch/xtensa/kernel/xtensa_ksyms.c
@@ -114,13 +114,6 @@ EXPORT_SYMBOL(__invalidate_icache_range)
 // FIXME EXPORT_SYMBOL(screen_info);
 #endif
 
-EXPORT_SYMBOL(outsb);
-EXPORT_SYMBOL(outsw);
-EXPORT_SYMBOL(outsl);
-EXPORT_SYMBOL(insb);
-EXPORT_SYMBOL(insw);
-EXPORT_SYMBOL(insl);
-
 extern long common_exception_return;
 EXPORT_SYMBOL(common_exception_return);
 

