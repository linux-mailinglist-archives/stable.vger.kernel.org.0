Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B311A83AB
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 17:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731604AbgDNPqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 11:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731196AbgDNPq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 11:46:29 -0400
X-Greylist: delayed 26738 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Apr 2020 08:46:29 PDT
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833B6C061A0C;
        Tue, 14 Apr 2020 08:46:29 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jONlW-0006hB-QJ; Tue, 14 Apr 2020 17:46:22 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 0DA7A1C0086;
        Tue, 14 Apr 2020 17:46:22 +0200 (CEST)
Date:   Tue, 14 Apr 2020 15:46:21 -0000
From:   "tip-bot2 for John Allen" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/microcode/AMD: Increase microcode PATCH_MAX_SIZE
Cc:     John Allen <john.allen@amd.com>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        "v4.14.."@tip-bot2.tec.linutronix.de, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200409152931.GA685273@mojo.amd.com>
References: <20200409152931.GA685273@mojo.amd.com>
MIME-Version: 1.0
Message-ID: <158687918159.28353.7726188053950798556.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     bdf89df3c54518eed879d8fac7577fcfb220c67e
Gitweb:        https://git.kernel.org/tip/bdf89df3c54518eed879d8fac7577fcfb220c67e
Author:        John Allen <john.allen@amd.com>
AuthorDate:    Thu, 09 Apr 2020 10:34:29 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 14 Apr 2020 17:34:46 +02:00

x86/microcode/AMD: Increase microcode PATCH_MAX_SIZE

Future AMD CPUs will have microcode patches that exceed the default 4K
patch size. Raise our limit.

Signed-off-by: John Allen <john.allen@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # v4.14..
Link: https://lkml.kernel.org/r/20200409152931.GA685273@mojo.amd.com
---
 arch/x86/include/asm/microcode_amd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
index 6685e12..7063b5a 100644
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -41,7 +41,7 @@ struct microcode_amd {
 	unsigned int			mpb[0];
 };
 
-#define PATCH_MAX_SIZE PAGE_SIZE
+#define PATCH_MAX_SIZE (3 * PAGE_SIZE)
 
 #ifdef CONFIG_MICROCODE_AMD
 extern void __init load_ucode_amd_bsp(unsigned int family);
