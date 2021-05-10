Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007E7379922
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 23:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbhEJV1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 17:27:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39148 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbhEJV1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 17:27:25 -0400
Date:   Mon, 10 May 2021 21:26:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620681978;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=be3M/VI7WmSNKkHBvyRjZ9A4GL1X51BAFA5few+WcDg=;
        b=1ZO3ZV/9AT1d5xVjvesTwm5dVY6a8iUUOBMXmXjyyDd1JQl/Kwjd9csSGWZUj8C2c+drcR
        qPUQfe9XYvDGzOFxSQjjFVuv3MaPso2cLvdct7/AF0Fo3zMaQVGW5wF6/0h8LByJ+tOfSt
        UTb0LGgczpmvhstMr4DMc8Iwhq+RsBp2UihN2XYPYSnqQppLqW5T1W6C2wYWumkAnKC5LK
        VTbWoSBgwfCYx4JCM9lU0pNrLvFFGf4dHBJxCg3f1qPF7ioSA4JPF0njr4/Kc7GHdD4GQZ
        MAfnwKwWa7Tn2n2Jk5KksWaGmkJYv2FTH+FRCe+qrIRIc1V4+2M7XpEEgiT2NA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620681978;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=be3M/VI7WmSNKkHBvyRjZ9A4GL1X51BAFA5few+WcDg=;
        b=b2unN7hxml6h9U8Qnf4CwkiWAdDIIb90re10viaLNjYoFgM8w+hDOQ5KCZ1hkf0dtt0HQN
        bqcm/q93tLG1OBBA==
From:   "tip-bot2 for Eric Dumazet" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] sh: Remove unused variable
Cc:     Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <20210414170517.1205430-1-eric.dumazet@gmail.com>
References: <20210414170517.1205430-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Message-ID: <162068197779.29796.8057893203111183466.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     0d3ae948741ac6d80e39ab27b45297367ee477de
Gitweb:        https://git.kernel.org/tip/0d3ae948741ac6d80e39ab27b45297367ee=
477de
Author:        Eric Dumazet <edumazet@google.com>
AuthorDate:    Wed, 14 Apr 2021 10:05:17 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 10 May 2021 23:23:04 +02:00

sh: Remove unused variable

Removes this annoying warning:

arch/sh/kernel/traps.c: In function =E2=80=98nmi_trap_handler=E2=80=99:
arch/sh/kernel/traps.c:183:15: warning: unused variable =E2=80=98cpu=E2=80=99=
 [-Wunused-variable]
  183 |  unsigned int cpu =3D smp_processor_id();

Fixes: fe3f1d5d7cd3 ("sh: Get rid of nmi_count()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210414170517.1205430-1-eric.dumazet@gmail.c=
om
---
 arch/sh/kernel/traps.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/sh/kernel/traps.c b/arch/sh/kernel/traps.c
index f5beecd..e76b221 100644
--- a/arch/sh/kernel/traps.c
+++ b/arch/sh/kernel/traps.c
@@ -180,7 +180,6 @@ static inline void arch_ftrace_nmi_exit(void) { }
=20
 BUILD_TRAP_HANDLER(nmi)
 {
-	unsigned int cpu =3D smp_processor_id();
 	TRAP_HANDLER_DECL;
=20
 	arch_ftrace_nmi_enter();
