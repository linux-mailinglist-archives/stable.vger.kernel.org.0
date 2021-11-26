Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C019A45E48D
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357671AbhKZCfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357709AbhKZCdc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:33:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20FBE61152;
        Fri, 26 Nov 2021 02:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893820;
        bh=eYeR2AiRtnXUp0I5517HQ+Gpur9yMYWVi2QmjpMPfxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6BdHzYg8J7ORf+1V7H8LPdEtNXjeASi5vjn7xXGQsyee1T15K1iOYiYa6TP4qVb1
         fQYCARrxzL2zbOvbG3BRgQSHDtV0L1Oe+HCewBwOSoNUq7kpfbCx+2/s3mVSa+VFvo
         QH38TSxzI8+MyTsnnFCyA8VoQDXTZ4kB1a88mtfTlbdorIXJnh5BMqlFuUcwiuWsh8
         WtnlkfJeHHuc6e9T2LawC4NCPL7qjy7+3Wp21sboUocRkUaWXq/jvVwawJnkbiymaJ
         rYPJ/HbnqN07WCxzWuJ5gcSe9qAVFL5eJER8f9A2NVok8KiZ4c9hyLA4vRzvuwpSeQ
         SJWIvL3BPC3PA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, bin.meng@windriver.com, atish.patra@wdc.com,
        devicetree@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 3/7] riscv: dts: microchip: fix board compatible
Date:   Thu, 25 Nov 2021 21:30:02 -0500
Message-Id: <20211126023006.440839-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023006.440839-1-sashal@kernel.org>
References: <20211126023006.440839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit fd86dd2a5dc5ff1044423c19fef3907862f591c4 ]

According to bindings, the compatible must include microchip,mpfs.  This
fixes dtbs_check warning:

  arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dt.yaml: /: compatible: ['microchip,mpfs-icicle-kit'] is too short

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts | 2 +-
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi           | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
index b254c60589a1c..be0d77624cf53 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
@@ -12,7 +12,7 @@ / {
 	#address-cells = <2>;
 	#size-cells = <2>;
 	model = "Microchip PolarFire-SoC Icicle Kit";
-	compatible = "microchip,mpfs-icicle-kit";
+	compatible = "microchip,mpfs-icicle-kit", "microchip,mpfs";
 
 	aliases {
 		ethernet0 = &emac1;
diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
index 9d2fbbc1f7778..446f41d6a87e9 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
@@ -6,8 +6,8 @@
 / {
 	#address-cells = <2>;
 	#size-cells = <2>;
-	model = "Microchip MPFS Icicle Kit";
-	compatible = "microchip,mpfs-icicle-kit";
+	model = "Microchip PolarFire SoC";
+	compatible = "microchip,mpfs";
 
 	chosen {
 	};
-- 
2.33.0

