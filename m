Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D7D1D841B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732635AbgERSHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733244AbgERSHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:07:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4D02083E;
        Mon, 18 May 2020 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825225;
        bh=+DJRvLsHScqFOnj5mYwjkkqVw5v/93AebKkp5ibkL3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpS8JEiCr1OWuh052La7ooLTPImvZzHhBIn1Ln3kU/MI5++VvcH/2f4Py53+7RE/D
         FEIjCK2DmVm4NT0VkD/tdfkf0yIc6wP4LlGyDJStsypXqPfGx5JAYvuZKOm86qWMYI
         SL7N0te8GFFkhIz0pjed10pCxQv/NrSNpg0k/aks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.6 180/194] arm64: dts: renesas: r8a77980: Fix IPMMU VIP[01] nodes
Date:   Mon, 18 May 2020 19:37:50 +0200
Message-Id: <20200518173546.488386105@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 arch/arm64/boot/dts/renesas/r8a77980.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/renesas/r8a77980.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
@@ -1318,6 +1318,7 @@
 		ipmmu_vip0: mmu@e7b00000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7b00000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 4>;
 			power-domains = <&sysc R8A77980_PD_ALWAYS_ON>;
 			#iommu-cells = <1>;
 		};
@@ -1325,6 +1326,7 @@
 		ipmmu_vip1: mmu@e7960000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7960000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 11>;
 			power-domains = <&sysc R8A77980_PD_ALWAYS_ON>;
 			#iommu-cells = <1>;
 		};


