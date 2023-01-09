Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E2E663251
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237991AbjAIVKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237799AbjAIVKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 16:10:16 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626FF8D5FA
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 13:02:33 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id b17so3429053pld.7
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 13:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0tNxcK2iGtNS5qxE0e6867nHATjHJNSmWHPb+VSgy0=;
        b=Kfv5mfT29muj5zuwTU9SxCKaSKfN5MtHBTrlxU5ahfo5hi6gpyGepiDlpQMcjV6uQ+
         AghorDP8SVsirHBgPxZMiXD84gqUDRrZLV7beb6p7xGYd0XT9d74B5W7jO9isyVTXGQb
         IRBig2IYUpok/HpQjxCvTJ5V3l/n6ps3642esFYRJ5pETCCPhQEGKMi9I7cS8PIb4acr
         rspz1tGFMrB+L8ovuYp6TpRKm9W9uqiiCiWSQ/mJUmE0f/ZfnJH5ZGSNBHYU+6xpjQMo
         WRu/PI8l6YcW/TnFnbiJh2WIxmnYCPq5RL08JqMHGe17pkM7fnannI24a+untrqIavM9
         teKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0tNxcK2iGtNS5qxE0e6867nHATjHJNSmWHPb+VSgy0=;
        b=tz6x4q6LYqXmjm8s9PzcMfdPdnZD8AMr+PoyxKb7HKahZZY6LaGKhLMat4xKk3P33q
         U0k2ezGk8xb3HmUrZMaxFKstEYy1Sbc8h6960HVPtWI0Leq7CYCz7uy/gf0CVosLsv9s
         ZQMovbK8rIDRA84yERzV1cuAcz7skA/CjzXukFc86BVfqQUZAFCCHFYWJfc+J6j6oPDu
         TDsuSbzYO1Y/c8B1bx1uSeHm9ZrSVsdLmyRcnHvtWeKfxNFZZPYYGO7MMgUVx/5eFm7L
         GdOSDqD5VcQwZzku3JkH7Qtm5MUOn5/DyW686RMfhbhBirBJnNEMM9Pfz1wK6Wpwj6lj
         jyiA==
X-Gm-Message-State: AFqh2kr2bYbWVwmD7AmNY4Vzb6rLBmdsN7XdC98GlCzHxCNBABMKxEle
        a6kI8Yasrl4r+dvm+s3/PrnfSAnAW119jyhsnRQ=
X-Google-Smtp-Source: AMrXdXtXb1flKAVk+aTc71OlYvzHG0/SEBtPce/FRvtsBr/ehJE/gJnpnQYL+rz19gC99wwWua613g==
X-Received: by 2002:a05:6a20:e61a:b0:ac:a4fd:f5bf with SMTP id my26-20020a056a20e61a00b000aca4fdf5bfmr81997488pzb.50.1673298152591;
        Mon, 09 Jan 2023 13:02:32 -0800 (PST)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm5559482pgp.71.2023.01.09.13.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 13:02:32 -0800 (PST)
From:   Kyle Huey <me@kylehuey.com>
X-Google-Original-From: Kyle Huey <khuey@kylehuey.com>
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Kyle Huey <me@kylehuey.com>
Subject: [PATCH 5.15 1/6] x86/fpu: Take task_struct* in copy_sigframe_from_user_to_xstate()
Date:   Mon,  9 Jan 2023 13:02:09 -0800
Message-Id: <20230109210214.71068-2-khuey@kylehuey.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109210214.71068-1-khuey@kylehuey.com>
References: <20230109210214.71068-1-khuey@kylehuey.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Huey <me@kylehuey.com>

commit 6a877d2450ac upstream

This will allow copy_sigframe_from_user_to_xstate() to grab the address of
thread_struct's pkru value in a later patch.

Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-2-khuey%40kylehuey.com
---
 arch/x86/include/asm/fpu/xstate.h | 2 +-
 arch/x86/kernel/fpu/signal.c      | 2 +-
 arch/x86/kernel/fpu/xstate.c      | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 109dfcc75299..b98b302c2751 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -137,7 +137,7 @@ extern void __init update_regset_xstate_info(unsigned int size,
 void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
 int xfeature_size(int xfeature_nr);
 int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf);
-int copy_sigframe_from_user_to_xstate(struct xregs_state *xsave, const void __user *ubuf);
+int copy_sigframe_from_user_to_xstate(struct task_struct *tsk, const void __user *ubuf);
 
 void xsaves(struct xregs_state *xsave, u64 mask);
 void xrstors(struct xregs_state *xsave, u64 mask);
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 7f71bd4dcd0d..7f76cb099e66 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -370,7 +370,7 @@ static int __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 	fpregs_unlock();
 
 	if (use_xsave() && !fx_only) {
-		ret = copy_sigframe_from_user_to_xstate(&fpu->state.xsave, buf_fx);
+		ret = copy_sigframe_from_user_to_xstate(tsk, buf_fx);
 		if (ret)
 			return ret;
 	} else {
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index c8def1b7f8fb..e1b717427955 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1169,10 +1169,10 @@ int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf)
  * XSAVE[S] format and copy to the target thread. This is called from the
  * sigreturn() and rt_sigreturn() system calls.
  */
-int copy_sigframe_from_user_to_xstate(struct xregs_state *xsave,
+int copy_sigframe_from_user_to_xstate(struct task_struct *tsk,
 				      const void __user *ubuf)
 {
-	return copy_uabi_to_xstate(xsave, NULL, ubuf);
+	return copy_uabi_to_xstate(&tsk->thread.fpu.state.xsave, NULL, ubuf);
 }
 
 static bool validate_xsaves_xrstors(u64 mask)
-- 
2.25.1

