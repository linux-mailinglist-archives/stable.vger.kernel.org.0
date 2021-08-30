Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8AA3FB4F4
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbhH3MAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236617AbhH3MAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:00:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F1AB61157;
        Mon, 30 Aug 2021 11:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324791;
        bh=/l7/K6eU+TdG16+drP7tph68gqsxwrWiwUWxucC+EKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qt+lkm5vfy8vbp1QaCOfmFAKrVFXZcUy+Z8E0LhH8XXSfAs44IIV6dgNerTYtcpyo
         fElg6yjV6TokKxFTYxqpWpADoW4FvMpc3nJ1JuBIUb5bnrAFts8GScN1VGyR3eO6UY
         GTTneRIye04Gj8T1DdcS0teJCaVxH4RqAQOgwkTnuN+DVKrDq1xgxZPbriiFduOin0
         wPs7vdj8jNDIfdkgGstekWLMG5ifRDkFykQ4dDQ3Eb4FIpBr7FfhDYDyhJzYuXLwjI
         swTIOMdeeqXywb9wr2ICcaLlHpbOkX4az2ep7Tc0S0ATkPEyfI789Vjr9VQdAb18HI
         64KJdWl/eoTXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bin Meng <bin.meng@windriver.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 06/14] riscv: dts: microchip: Add ethernet0 to the aliases node
Date:   Mon, 30 Aug 2021 07:59:34 -0400
Message-Id: <20210830115942.1017300-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830115942.1017300-1-sashal@kernel.org>
References: <20210830115942.1017300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bin Meng <bin.meng@windriver.com>

[ Upstream commit 417166ddec020c4e969aea064e23822591ad54df ]

U-Boot expects this alias to be in place in order to fix up the mac
address of the ethernet node.

Note on the Icicle Kit board, currently only emac1 is enabled so it
becomes the 'ethernet0'.

Signed-off-by: Bin Meng <bin.meng@windriver.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
index ec79944065c9..baea7d204639 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
@@ -14,6 +14,10 @@ / {
 	model = "Microchip PolarFire-SoC Icicle Kit";
 	compatible = "microchip,mpfs-icicle-kit";
 
+	aliases {
+		ethernet0 = &emac1;
+	};
+
 	chosen {
 		stdout-path = &serial0;
 	};
-- 
2.30.2

