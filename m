Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B5A1F2E05
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgFHXNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbgFHXN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49E9221501;
        Mon,  8 Jun 2020 23:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658009;
        bh=53hf1uz8lRodea9WxTNtIUA0Ing2SP3IUDfkzRMcjXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmgQ0rFUyMxZiZ7B4LGS2LP+bVz/ItUcraQam6iln6pbrepgLRFAGtkFdM8soECuN
         vQ7KYSf58lAj5rs8EsGXNAG5FgK0Xb+zLbeKcpZw86ZuiCCiOqKZASJtTqKz8fv+8N
         Mb1bYZVMBXdvKHxV7J2ZfxFxESbNROxkjBpjqh6M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 064/606] arm64: dts: renesas: r8a77980: Fix IPMMU VIP[01] nodes
Date:   Mon,  8 Jun 2020 19:03:09 -0400
Message-Id: <20200608231211.3363633-64-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit f4d71c6ea9e58c07dd4d02d09c5dd9bb780ec4b1 upstream.

Missing the renesas,ipmmu-main property on ipmmu_vip[01] nodes.

Fixes: 55697cbb44e4 ("arm64: dts: renesas: r8a779{65,80,90}: Add IPMMU devices nodes)
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1587108543-23786-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/renesas/r8a77980.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a77980.dtsi b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
index b340fb469999..1692bc95129e 100644
--- a/arch/arm64/boot/dts/renesas/r8a77980.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
@@ -1318,6 +1318,7 @@ ipmmu_vi0: mmu@febd0000 {
 		ipmmu_vip0: mmu@e7b00000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7b00000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 4>;
 			power-domains = <&sysc R8A77980_PD_ALWAYS_ON>;
 			#iommu-cells = <1>;
 		};
@@ -1325,6 +1326,7 @@ ipmmu_vip0: mmu@e7b00000 {
 		ipmmu_vip1: mmu@e7960000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7960000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 11>;
 			power-domains = <&sysc R8A77980_PD_ALWAYS_ON>;
 			#iommu-cells = <1>;
 		};
-- 
2.25.1

