Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066943AE7AA
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhFUKyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:54:40 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:55043 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229651AbhFUKyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:54:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id EE5301940246;
        Mon, 21 Jun 2021 06:52:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 21 Jun 2021 06:52:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xgJV8z
        9vOcJM54o6W29N21v/3hD9AziyPkdMcjHStBE=; b=X9l1Etv37ZKBWjG/snTz12
        t0hRkDCG7aFtyOxueKsPA1rkjTBp2/G4yo1HRnHfFtCmE5qoEKsak4kJ5f8FB222
        T3MerZQN4lb3epWfwthLgh/3ISsFob6tYJFzF7wSqdhmyi+6hOh4gDRzwvR28S30
        oS0xyIJcgMyihB120R2SPU9fH5PGBLEuBy7lEne++j8x9IKll7pjYCpipJOZlAjf
        a7haKMSsLy2uPq8Vu0XbE2/942zmAk0wH9TaiREnjd4Ilaq64oelJPJ6iDpJyFZ9
        tkj3O7TCkIjiNji9TQO3fFZopIC8QGmoLZljmKnzUGS/Jy7dNB0Z5+X4nBuJ1YZg
        ==
X-ME-Sender: <xms:Zm_QYCaVRlzq1R2eGXoRlFWj430Idn2A_3_0TspYMBRh5dygGEIGdw>
    <xme:Zm_QYFbBC2-vlRJCpFmTHGyghP0TH1EAEcGeeFtQIWKr06ff5P7i9UzfQcZDrX4Zl
    V6HXUmTfWxTiA>
X-ME-Received: <xmr:Zm_QYM_tXJ4ttYcrOgYFUJKQYpjiT1vynJHBc3Ei_BojKWBm9I13KGph2XlljTzdQ7d7xu-RQeLrC-H6Uj3rc6LBWw76xly6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:Zm_QYEqn8Oxuiwu88JEAs2C4WgNyRfaSAaDshT_YvY6AqM6wrONqqQ>
    <xmx:Zm_QYNp6P7nlEMsaOtIFllzFG5qUCDqApR6yqpkXMmd9f7YF9xrjCA>
    <xmx:Zm_QYCTHRbaOZLRUNi6gNqThWdzM8BkMbK-9BI7ahmli8P2bUPwbIQ>
    <xmx:Zm_QYOCR9UHK8l_1zRE8Bfr5ypCGsoMuuwMUbUcYjaRXfIDABT2chw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:52:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/fpu: Reset state for all signal restore failures" failed to apply to 4.9-stable tree
To:     tglx@linutronix.de, bp@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:52:12 +0200
Message-ID: <162427273238163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From efa165504943f2128d50f63de0c02faf6dcceb0d Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 9 Jun 2021 21:18:00 +0200
Subject: [PATCH] x86/fpu: Reset state for all signal restore failures

If access_ok() or fpregs_soft_set() fails in __fpu__restore_sig() then the
function just returns but does not clear the FPU state as it does for all
other fatal failures.

Clear the FPU state for these failures as well.

Fixes: 72a671ced66d ("x86, fpu: Unify signal handling code paths for x86 and x86_64 kernels")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/87mtryyhhz.ffs@nanos.tec.linutronix.de

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 4ab9aeb9a963..ec3ae3054792 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -307,13 +307,17 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		return 0;
 	}
 
-	if (!access_ok(buf, size))
-		return -EACCES;
+	if (!access_ok(buf, size)) {
+		ret = -EACCES;
+		goto out;
+	}
 
-	if (!static_cpu_has(X86_FEATURE_FPU))
-		return fpregs_soft_set(current, NULL,
-				       0, sizeof(struct user_i387_ia32_struct),
-				       NULL, buf) != 0;
+	if (!static_cpu_has(X86_FEATURE_FPU)) {
+		ret = fpregs_soft_set(current, NULL, 0,
+				      sizeof(struct user_i387_ia32_struct),
+				      NULL, buf);
+		goto out;
+	}
 
 	if (use_xsave()) {
 		struct _fpx_sw_bytes fx_sw_user;
@@ -396,7 +400,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		 */
 		ret = __copy_from_user(&env, buf, sizeof(env));
 		if (ret)
-			goto err_out;
+			goto out;
 		envp = &env;
 	}
 
@@ -426,7 +430,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 
 		ret = copy_user_to_xstate(&fpu->state.xsave, buf_fx);
 		if (ret)
-			goto err_out;
+			goto out;
 
 		sanitize_restored_user_xstate(&fpu->state, envp, user_xfeatures,
 					      fx_only);
@@ -446,7 +450,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		ret = __copy_from_user(&fpu->state.fxsave, buf_fx, state_size);
 		if (ret) {
 			ret = -EFAULT;
-			goto err_out;
+			goto out;
 		}
 
 		sanitize_restored_user_xstate(&fpu->state, envp, user_xfeatures,
@@ -464,7 +468,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 	} else {
 		ret = __copy_from_user(&fpu->state.fsave, buf_fx, state_size);
 		if (ret)
-			goto err_out;
+			goto out;
 
 		fpregs_lock();
 		ret = copy_kernel_to_fregs_err(&fpu->state.fsave);
@@ -475,7 +479,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		fpregs_deactivate(fpu);
 	fpregs_unlock();
 
-err_out:
+out:
 	if (ret)
 		fpu__clear_user_states(fpu);
 	return ret;

