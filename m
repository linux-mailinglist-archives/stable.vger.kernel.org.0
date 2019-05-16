Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8120C0E
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfEPQB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:01:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42904 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727043AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImJ-0006zA-8i; Thu, 16 May 2019 16:58:43 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImF-0001TI-CD; Thu, 16 May 2019 16:58:39 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.683740028@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 86/86] x86/bugs: Change L1TF mitigation string to
 match upstream
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Commit 72c6d2db64fa "x86/litf: Introduce vmx status variable" upstream
changed "Page Table Inversion" to "PTE Inversion".  That was part of
the implementation of additional mitigations for VMX which haven't
been applied to this branch.  Just change this string to be consistent
and match documentation.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1225,7 +1225,7 @@ static ssize_t cpu_show_common(struct de
 
 	case X86_BUG_L1TF:
 		if (boot_cpu_has(X86_FEATURE_L1TF_PTEINV))
-			return sprintf(buf, "Mitigation: Page Table Inversion\n");
+			return sprintf(buf, "Mitigation: PTE Inversion\n");
 		break;
 
 	case X86_BUG_MDS:

