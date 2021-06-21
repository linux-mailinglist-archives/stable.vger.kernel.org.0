Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9CF3AF2CB
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhFUR4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232070AbhFURzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B367561378;
        Mon, 21 Jun 2021 17:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297977;
        bh=GHk/7znoJ06sxET6U+HlMgG+SebJ6C1htOLeASBDXB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4RCFwqoneSQ7RkkkTG57d0KaKYhdHVZhDZZB2OJRbEzKfcE0EWFPr3Czti5hMD1a
         HkNCbbKqnkdgn5MHfLKaeggL9oamGOcg2nLG9Xa3a0BdZF6RZDXjH+T3fSkcK5fjMP
         l6YG2Hc8dCYe8GgBAuprffg7LiTkxWAm53JJdZE9UCxXZk/gSUL3284KrKVF7/Ort6
         JjxgQhlBACjF1/+MaxO46cSztK5cuQMaqhSojoFDXowqJIYzqeK7Bnig6J9wR/hrU4
         dwePUPYBz8qlRuo/776ji4KyILNEWcsnzGbWoMzYrIRsSn1rVgWNkSwsURcmE3g4Ze
         MGWpc5HZKSBxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 39/39] riscv: dts: fu740: fix cache-controller interrupts
Date:   Mon, 21 Jun 2021 13:51:55 -0400
Message-Id: <20210621175156.735062-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
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
@@ -272,7 +272,7 @@ ccache: cache-controller@2010000 {
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

