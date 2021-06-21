Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EABD3AF23E
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhFURr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:47:28 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41942 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbhFURr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 13:47:28 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 15E42219E2;
        Mon, 21 Jun 2021 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624297513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L0zuYLsKw4J+B42t44+3vG7xwklJLQykEdF8JL74JgY=;
        b=LzF+4LR17PhESnGQrpJjtL2u5wb75bpWkW04T584pwX2r3rBNqAcxei/T0qsoQe1p32DFW
        O/L5sizrPGuYM1Izg9qJgWfXy45H4dv0SZglmB6ta/piKh2eXw51gJt0sBX/ImFIES7tTr
        EKbBU9t0QfCwgMPtGksjddWPSdfa3SQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624297513;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L0zuYLsKw4J+B42t44+3vG7xwklJLQykEdF8JL74JgY=;
        b=fMxLPu09IVlOBkd9tJqkhtIwyV9OwPIUgIqzPJKPmUP7yMs2D6ILi6hJYWtoXQjBrJfvIa
        TY/Aw81E+LNReFAA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id EDCC4118DD;
        Mon, 21 Jun 2021 17:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624297513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L0zuYLsKw4J+B42t44+3vG7xwklJLQykEdF8JL74JgY=;
        b=LzF+4LR17PhESnGQrpJjtL2u5wb75bpWkW04T584pwX2r3rBNqAcxei/T0qsoQe1p32DFW
        O/L5sizrPGuYM1Izg9qJgWfXy45H4dv0SZglmB6ta/piKh2eXw51gJt0sBX/ImFIES7tTr
        EKbBU9t0QfCwgMPtGksjddWPSdfa3SQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624297513;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L0zuYLsKw4J+B42t44+3vG7xwklJLQykEdF8JL74JgY=;
        b=fMxLPu09IVlOBkd9tJqkhtIwyV9OwPIUgIqzPJKPmUP7yMs2D6ILi6hJYWtoXQjBrJfvIa
        TY/Aw81E+LNReFAA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id JdMzOijQ0GCiUAAALh3uQQ
        (envelope-from <bp@suse.de>); Mon, 21 Jun 2021 17:45:12 +0000
Date:   Mon, 21 Jun 2021 19:45:02 +0200
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Reset state for all signal
 restore failures" failed to apply to 4.4-stable tree
Message-ID: <YNDQHgGztJAWO2H+@zn.tnic>
References: <162427273275124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <162427273275124@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 12:52:12PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Ok, how's this below?

It should at least capture the gist of what this commit is trying to
achieve as the FPU mess has changed substantially since 4.4 so I'm
really cautious here not to break any existing setups.

I've boot-tested this in a VM but Greg, I'd appreciate running it
through some sort of stable testing framework if you're using one.

Thx.

---
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 9 Jun 2021 21:18:00 +0200
Subject: [PATCH] x86/fpu: Reset state for all signal restore failures

Commit efa165504943f2128d50f63de0c02faf6dcceb0d upstream.

If access_ok() or fpregs_soft_set() fails in __fpu__restore_sig() then the
function just returns but does not clear the FPU state as it does for all
other fatal failures.

Clear the FPU state for these failures as well.

Fixes: 72a671ced66d ("x86, fpu: Unify signal handling code paths for x86 and x86_64 kernels")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/87mtryyhhz.ffs@nanos.tec.linutronix.de
---
 arch/x86/kernel/fpu/signal.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 8fc842dae3b3..9a1489b92782 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -262,15 +262,23 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		return 0;
 	}
 
-	if (!access_ok(VERIFY_READ, buf, size))
+	if (!access_ok(VERIFY_READ, buf, size)) {
+		fpu__clear(fpu);
 		return -EACCES;
+	}
 
 	fpu__activate_curr(fpu);
 
-	if (!static_cpu_has(X86_FEATURE_FPU))
-		return fpregs_soft_set(current, NULL,
-				       0, sizeof(struct user_i387_ia32_struct),
-				       NULL, buf) != 0;
+	if (!static_cpu_has(X86_FEATURE_FPU)) {
+		int ret = fpregs_soft_set(current, NULL, 0,
+					  sizeof(struct user_i387_ia32_struct),
+					  NULL, buf);
+
+		if (ret)
+			fpu__clear(fpu);
+
+		return ret != 0;
+	}
 
 	if (use_xsave()) {
 		struct _fpx_sw_bytes fx_sw_user;
-- 
2.29.2

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
