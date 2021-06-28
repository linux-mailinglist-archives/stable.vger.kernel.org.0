Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0209F3B6026
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbhF1OWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233267AbhF1OVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8D8061C89;
        Mon, 28 Jun 2021 14:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889960;
        bh=6XLJmqLWxWdwkYWDhCSw4LJYmerq5v9OQx7Kgxw41dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxOrwfJT1XySU9iC+SIDNS2MS9k7vY7jszRq3GJmixHiGo7MBH9g0Ka1poKOS+sah
         fy1h3TLEmUILnskdWpH9utlKuijXWTN8LQUBlpIMhTESw6l9eiTchDbvnuqMSCC0iM
         V0y1XzxYQ/i8PlPcIwuglS9voBDGN3QYIcUEfjqmkkKG+affxlh9rG2su71jJAn6wr
         N6genWe49CmRb7Ihxd0dVVRHfK6hUKGJ7Mh7DnujlekLhH2xv/Oq9MsWOYHNt6ZAHx
         DeSWEaJ8jb7qwaSHNlByZP+GVcNAqkrV6uFRBLAS+zZpbvajRJNnLzY9Crn1smetfS
         ekh7/w5rn3XEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 060/110] riscv: dts: fu740: fix cache-controller interrupts
Date:   Mon, 28 Jun 2021 10:17:38 -0400
Message-Id: <20210628141828.31757-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Abdurachmanov <david.abdurachmanov@sifive.com>

[ Upstream commit 7ede12b01b59dc67bef2e2035297dd2da5bfe427 ]

The order of interrupt numbers is incorrect.

The order for FU740 is: DirError, DataError, DataFail, DirFail

From SiFive FU740-C000 Manual:
19 - L2 Cache DirError
20 - L2 Cache DirFail
21 - L2 Cache DataError
22 - L2 Cache DataFail

Signed-off-by: David Abdurachmanov <david.abdurachmanov@sifive.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/sifive/fu740-c000.dtsi b/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
index eeb4f8c3e0e7..d0d206cdb999 100644
--- a/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
+++ b/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
@@ -272,7 +272,7 @@
 			cache-size = <2097152>;
 			cache-unified;
 			interrupt-parent = <&plic0>;
-			interrupts = <19 20 21 22>;
+			interrupts = <19 21 22 20>;
 			reg = <0x0 0x2010000 0x0 0x1000>;
 		};
 		gpio: gpio@10060000 {
-- 
2.30.2

