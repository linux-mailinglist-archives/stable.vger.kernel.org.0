Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E741F401BDD
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243585AbhIFNAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243079AbhIFM71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 554D261050;
        Mon,  6 Sep 2021 12:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933102;
        bh=HA1DpjQ0I9yUNDwjmc5qY/slPOJxrXMT/MCVIXabKzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmbC0ChnNvSHmRznFG/tYY4h+UKa1e3gWF85D22iX0XIknN68f2r2u+55h1HEuk+c
         KqD7T2H7xEVhW4f3z6rFew7WrtrSms4gAayQUiiIJdhYnx8tUwkqspMJ3GYCG+FGDB
         V/8rBkDIK9rMbYFkF6IyT57S93sq6bg7h2o8WMo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bin Meng <bin.meng@windriver.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 08/24] riscv: dts: microchip: Add ethernet0 to the aliases node
Date:   Mon,  6 Sep 2021 14:55:37 +0200
Message-Id: <20210906125449.390861533@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
References: <20210906125449.112564040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -14,6 +14,10 @@
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



