Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D881D84F9
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbgERSPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731460AbgERR7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A55B820715;
        Mon, 18 May 2020 17:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824757;
        bh=+DJRvLsHScqFOnj5mYwjkkqVw5v/93AebKkp5ibkL3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+PXnvCEGGHPp6nFlxubQVknK31+0NnRvaDg4r9VzxGh667FzPl8nZGizqUF5+mHt
         U/VVO7/BJdoPRCLS0Tc7iqggc0wCe6DV/9pAdi0PtfY7mOabQvORuhWiz9zYQDB0ve
         Qg6+kFaEJHw7z/FGB9LnBj+NyRmxkIxsYqoaC6Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.4 139/147] arm64: dts: renesas: r8a77980: Fix IPMMU VIP[01] nodes
Date:   Mon, 18 May 2020 19:37:42 +0200
Message-Id: <20200518173530.414072507@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
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


