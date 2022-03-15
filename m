Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49654D9ED8
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 16:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349626AbiCOPjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 11:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbiCOPjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 11:39:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252D01132
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 08:38:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 638EE21117;
        Tue, 15 Mar 2022 15:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647358683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QL4GPiAR0VHl+4iUn1Z3Xj2tgA5D2zAOqp+dvz/HRbI=;
        b=jg5XPVOcMmaUKIbMB92BWcR4D9flEiSvcdsL8pMMHG53UW/j1S2+9XRp8mJpf+qVi0yKVb
        JVEnAFlocRn5wuSdHYBICDNsTD8b5KhTG8G8pGjdni77pQ7W9JIYZVEAGcyB4u6VB9b0y1
        1YEHWm6N1QT9sN/qC9MNTkj/YIbA/ig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647358683;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QL4GPiAR0VHl+4iUn1Z3Xj2tgA5D2zAOqp+dvz/HRbI=;
        b=RRntq9P64rXoAnYbJfabK3+xU1roxSXZnpTOBWrYCB5PNtJxlZyR8vWzctBwFk0/b2y/MO
        A0c7vzjDbL1weCAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 573B013B4E;
        Tue, 15 Mar 2022 15:38:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FoxCFduyMGL9KgAAMHmgww
        (envelope-from <bp@suse.de>); Tue, 15 Mar 2022 15:38:03 +0000
Date:   Tue, 15 Mar 2022 16:37:56 +0100
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     peterz@infradead.org, mbenes@suse.cz, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/module: Fix the paravirt vs
 alternative order" failed to apply to 5.15-stable tree
Message-ID: <YjCy1FHTo6Cpw8Hk@zn.tnic>
References: <1647245046133115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1647245046133115@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 09:04:06AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 5adf349439d29f92467e864f728dfc23180f3ef9 Mon Sep 17 00:00:00 2001

I guess something like this:

From 8fb38dd5ae4b4f94e5944651965d4b2e8168d46a Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 3 Mar 2022 12:23:23 +0100
Subject: [PATCH] x86/module: Fix the paravirt vs alternative order

Commit 5adf349439d29f92467e864f728dfc23180f3ef9 upstream.

Ever since commit

  4e6292114c74 ("x86/paravirt: Add new features for paravirt patching")

there is an ordering dependency between patching paravirt ops and
patching alternatives, the module loader still violates this.

Fixes: 4e6292114c74 ("x86/paravirt: Add new features for paravirt patching")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220303112825.068773913@infradead.org
---
 arch/x86/kernel/module.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 867a341a0c7e..32e546e41629 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -270,6 +270,14 @@ int module_finalize(const Elf_Ehdr *hdr,
 			orc_ip = s;
 	}
 
+	/*
+	 * See alternative_instructions() for the ordering rules between the
+	 * various patching types.
+	 */
+	if (para) {
+		void *pseg = (void *)para->sh_addr;
+		apply_paravirt(pseg, pseg + para->sh_size);
+	}
 	if (alt) {
 		/* patch .altinstructions */
 		void *aseg = (void *)alt->sh_addr;
@@ -283,11 +291,6 @@ int module_finalize(const Elf_Ehdr *hdr,
 					    tseg, tseg + text->sh_size);
 	}
 
-	if (para) {
-		void *pseg = (void *)para->sh_addr;
-		apply_paravirt(pseg, pseg + para->sh_size);
-	}
-
 	/* make jump label nops */
 	jump_label_apply_nops(me);
 
-- 
2.29.2

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Ivo Totev, HRB 36809, AG Nürnberg
