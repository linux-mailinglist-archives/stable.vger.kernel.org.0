Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9438E167218
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgBUIAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:00:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729111AbgBUIAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:00:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3EF7206ED;
        Fri, 21 Feb 2020 08:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272010;
        bh=pQXAymyow/dMd9ddSmCJOj/eaUwArnf4PFXihefFwlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEljiZBFZxMhiTIc+l0eV9tfkFp3j5AulzCxkACExHzb3QZ9DVcgLM+yVErgR3XJ3
         eKgO5JbuDl7AnGQkP9c5tthM2CGA/KeixQt2RgDPDDlOnJ96CZt32Hgs8KpJBiqIZo
         Xzs/jxdxVgnkiWyp80E+WI4iUJ0+uF/ABCPxVcpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 382/399] asm-generic/tlb: add missing CONFIG symbol
Date:   Fri, 21 Feb 2020 08:41:47 +0100
Message-Id: <20200221072437.310458796@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 27796d03c9c4b2b937ed4cc2b10f21559ad5a8c9 ]

Without this the symbol will not actually end up in .config files.

Link: http://lkml.kernel.org/r/20200116064531.483522-6-aneesh.kumar@linux.ibm.com
Fixes: a30e32bd79e9 ("asm-generic/tlb: Provide generic tlb_flush() based on flush_tlb_mm()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 208aad1216300..5e907a954532e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -399,6 +399,9 @@ config HAVE_RCU_TABLE_FREE
 config HAVE_MMU_GATHER_PAGE_SIZE
 	bool
 
+config MMU_GATHER_NO_RANGE
+	bool
+
 config HAVE_MMU_GATHER_NO_GATHER
 	bool
 
-- 
2.20.1



