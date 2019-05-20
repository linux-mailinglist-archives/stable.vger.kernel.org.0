Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7375E23511
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390196AbfETMcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390035AbfETMcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:32:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C89E720645;
        Mon, 20 May 2019 12:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355568;
        bh=xxLEzmsGULtUDU3Io0agV8eEWFU+4vqzpgbIFY8kxKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taPYH1olIIlE3qRaFQqK3oJK2xwLp1LtJuEA9YG9IvxJmmolBDyJ5HqEm5oms2s0q
         hjTeby32HAZmt3k1a08S4W2Y5cSjXObTpkM4y4ZoAK/TupHxiaZpEZ/VZjYWYlNawx
         cbiViUdphgFjWKln6tdvlmrgAWa6mFDum9KC8yfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stuart Menefy <stuart.menefy@mathembedded.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.1 008/128] ARM: dts: exynos: Fix interrupt for shared EINTs on Exynos5260
Date:   Mon, 20 May 2019 14:13:15 +0200
Message-Id: <20190520115250.009565716@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stuart Menefy <stuart.menefy@mathembedded.com>

commit b7ed69d67ff0788d8463e599dd5dd1b45c701a7e upstream.

Fix the interrupt information for the GPIO lines with a shared EINT
interrupt.

Fixes: 16d7ff2642e7 ("ARM: dts: add dts files for exynos5260 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Stuart Menefy <stuart.menefy@mathembedded.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos5260.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos5260.dtsi
+++ b/arch/arm/boot/dts/exynos5260.dtsi
@@ -223,7 +223,7 @@
 			wakeup-interrupt-controller {
 				compatible = "samsung,exynos4210-wakeup-eint";
 				interrupt-parent = <&gic>;
-				interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
 			};
 		};
 


