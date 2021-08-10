Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21D33E5CD8
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242432AbhHJOP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242352AbhHJOPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:15:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4AE361008;
        Tue, 10 Aug 2021 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604928;
        bh=M4IO3RhlVin1iu3XzP+nfxLyRXRODIc+CtwQNbOT6i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4lyCX84fWxdYVQo2IGhbXo7Vs6ydxEGRGPFnDzwTjcZJ8NX19UBCa8FDVk6VYfw1
         Xdn7PtypcSS0f+FjsY9bbTDsUuSzaMkX4/3vyf+yAYOrK9xGSka025DHrlC5WcaLYo
         QLqYeqC+3JXyNUVJfZhN6sdk+cxJbZm5UzW4Sw84rtxQi9KFNYEm7y88HC+NQHR26T
         Uqk/dL0Lh9XRaVWEB8FOJA3Fl4tW04H+VAxkws0xZDg0PI0DsgS/QfAT3t2S+1M5rJ
         9t4y5zBIBWnfBUpZUhumibUWt/CbFcR9n5MLg3wFE2Q3fDUg5R0BKu3UcNIsHrIaii
         yFYCI2Ul/buDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiu Wenbo <qiuwenbo@kylinos.com.cn>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 17/24] riscv: dts: fix memory size for the SiFive HiFive Unmatched
Date:   Tue, 10 Aug 2021 10:14:58 -0400
Message-Id: <20210810141505.3117318-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141505.3117318-1-sashal@kernel.org>
References: <20210810141505.3117318-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiu Wenbo <qiuwenbo@kylinos.com.cn>

[ Upstream commit d09560435cb712c9ec1e62b8a43a79b0af69fe77 ]

The production version of HiFive Unmatched have 16GB memory.

Signed-off-by: Qiu Wenbo <qiuwenbo@kylinos.com.cn>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
index b1c3c596578f..2e4ea84f27e7 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
@@ -24,7 +24,7 @@ cpus {
 
 	memory@80000000 {
 		device_type = "memory";
-		reg = <0x0 0x80000000 0x2 0x00000000>;
+		reg = <0x0 0x80000000 0x4 0x00000000>;
 	};
 
 	soc {
-- 
2.30.2

