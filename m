Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF35383102
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237985AbhEQOdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236504AbhEQObk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CB196186A;
        Mon, 17 May 2021 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260928;
        bh=oDdmwiAs4OkF35TIcoVtoX+ScytIn7uyrYIh5qLdz2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPez/X75jb8TqMxtM1H4F2d+aRtIOrRBWDNmyxxJOcrgjhSD31aVO3nadz/ynqPiF
         k3HhRnNdI4/LpcwbWWTAkX2e/gOoK0CyvwKPGnQkOYzSn0Qa5DoewBuGwAY9IxkAet
         3uKiD72L8C2klICtGAx3cKgJseQafIaGtE9RzYFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.12 251/363] sh: Remove unused variable
Date:   Mon, 17 May 2021 16:01:57 +0200
Message-Id: <20210517140311.078763547@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 0d3ae948741ac6d80e39ab27b45297367ee477de upstream.

Removes this annoying warning:

arch/sh/kernel/traps.c: In function ‘nmi_trap_handler’:
arch/sh/kernel/traps.c:183:15: warning: unused variable ‘cpu’ [-Wunused-variable]
  183 |  unsigned int cpu = smp_processor_id();

Fixes: fe3f1d5d7cd3 ("sh: Get rid of nmi_count()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210414170517.1205430-1-eric.dumazet@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sh/kernel/traps.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/sh/kernel/traps.c
+++ b/arch/sh/kernel/traps.c
@@ -180,7 +180,6 @@ static inline void arch_ftrace_nmi_exit(
 
 BUILD_TRAP_HANDLER(nmi)
 {
-	unsigned int cpu = smp_processor_id();
 	TRAP_HANDLER_DECL;
 
 	arch_ftrace_nmi_enter();


