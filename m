Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E2369BD8C
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 23:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBRWoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 17:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBRWoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 17:44:06 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8710B125AD;
        Sat, 18 Feb 2023 14:44:05 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id y41so510070ljq.5;
        Sat, 18 Feb 2023 14:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OszOCijG/p5iaPYxbmUtU8TwmY3BccM9/PpC7rZG5O4=;
        b=o8fEem/p5ufwZZIjf6O4/1NQ7ayrOwvqaQTBifuRM3Anp5hxVO9xDPgLaTezsKNZDx
         UGIU4nQu/v6un+RqEGw1P79HZOR2ZIQGShZbNS7WXb1VcYU+ZfbQNZ0UimCsbd6tjfg5
         rtp0a2FifSckSUGCXqsMy6wkXamFYug+oaXYrSPgwQP+2n26IdOp2RGkTdmTcm5Q4Cmf
         M+CWpo8h/oDvo82hDJzvbUYI5KOUPRAFaHKRj1VWR39FnBa9ErQW8miF2ph+HXwPdFm8
         xhTA+zuSg9n4h5z/GtanrfrjTHJjDf/4+g5lJdeKzy2Lmo9ZLlBt5EJ0u7fXYFqSU1YH
         UWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OszOCijG/p5iaPYxbmUtU8TwmY3BccM9/PpC7rZG5O4=;
        b=7sWdZX7vg7+rGxfKZ3jFg+0hgepEUGdY1WuLlboDBzYBvy6TLog3H/ZQ03LABHwC9/
         GLhLj+5u2froKtYDelHdmEpQPrl7ToxTuwRAxRsQjTX3CC8+W2Gio3QTF3O+9ph/rGao
         BS7zt0UUbnfeNtQj9C3vEAoezy9IuxfNQTZzG5xErTsi6DarBZkKu4KKmAuXdhOiq0Vk
         Vjo2Z8ZWqWdoYW0MFNW6NWFpPHZ1Dfx73vc0dRON6FZSBc15IxtRCaoT1g5fPeUnqijX
         pnhZUdQRFZSsEJr2joEWNxBobharDNmDbMbrk32RhfyOTu0/TuPvy+/QLOKqMNpuASr6
         nQ9Q==
X-Gm-Message-State: AO0yUKVeO2JdN8wwSbGeM+Zj1FtvW/QPdkWEVG1DxwvM/wfhxPGjW2xI
        IbblvphYEJ77QETs4K4TQSxdZpbHNndU0w==
X-Google-Smtp-Source: AK7set8EcE06V+CX/t1geSQACNxysUOqGl+9Xd3S1u2sF+rTGZl8VNIOlD4WG404w6HT1tAw2GFCaA==
X-Received: by 2002:a2e:978f:0:b0:293:4fed:737 with SMTP id y15-20020a2e978f000000b002934fed0737mr1474393lji.18.1676760243732;
        Sat, 18 Feb 2023 14:44:03 -0800 (PST)
Received: from akathisia (c-276fe655.022-307-6762674.bbcust.telenor.se. [85.230.111.39])
        by smtp.gmail.com with ESMTPSA id u12-20020a2e844c000000b002935d75761dsm1027401ljh.4.2023.02.18.14.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 14:44:03 -0800 (PST)
Date:   Sat, 18 Feb 2023 23:43:59 +0100
From:   Elvira Khabirova <lineprinter0@gmail.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "Dmitry V. Levin" <ldv@strace.io>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Andreas Henriksson <ah@debian.org>
Subject: [PATCH] mips: fix syscall_get_nr
Message-ID: <20230218233212.1fed456b@akathisia>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The implementation of syscall_get_nr on mips used to ignore the task
argument and return the syscall number of the calling thread instead of
the target thread.

The bug was exposed to user space by commit 201766a20e30f ("ptrace: add
PTRACE_GET_SYSCALL_INFO request") and detected by strace test suite.

Link: https://github.com/strace/strace/issues/235
Fixes: c2d9f1775731 ("MIPS: Fix syscall_get_nr for the syscall exit tracing.")
Cc: <stable@vger.kernel.org> # v3.19+
Co-developed-by: Dmitry V. Levin <ldv@strace.io>
Signed-off-by: Dmitry V. Levin <ldv@strace.io>
Signed-off-by: Elvira Khabirova <lineprinter0@gmail.com>
---
 arch/mips/include/asm/syscall.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/syscall.h b/arch/mips/include/asm/syscall.h
index 25fa651c937d..ebdf4d910af2 100644
--- a/arch/mips/include/asm/syscall.h
+++ b/arch/mips/include/asm/syscall.h
@@ -38,7 +38,7 @@ static inline bool mips_syscall_is_indirect(struct task_struct *task,
 static inline long syscall_get_nr(struct task_struct *task,
 				  struct pt_regs *regs)
 {
-	return current_thread_info()->syscall;
+	return task_thread_info(task)->syscall;
 }
 
 static inline void mips_syscall_update_nr(struct task_struct *task,
-- 

