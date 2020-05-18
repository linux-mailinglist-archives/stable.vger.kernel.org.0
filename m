Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C861D85A2
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731121AbgERRxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731117AbgERRxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:53:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE73220715;
        Mon, 18 May 2020 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824398;
        bh=BFpFtldCLwGRs/hMvTE3Xer8bN8X8knuqYNfGb5Age0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qAESdU8h8IP8BpBWoKc6AUh5sZ4OAd/4m9dXjWVRVKSwee34vj7tM+fwbQz6kjvtw
         ZauaDXGUbUWM7E3k7y8nx2eeEDNi5EU2cz16AZ3meIWB77pe/oB5oHRDKdW2VQGF19
         yw9YsnKj1n1I9KQyFVibo9agvorz8KRHn//1bUHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 4.19 77/80] arm64: dts: renesas: r8a77980: Fix IPMMU VIP[01] nodes
Date:   Mon, 18 May 2020 19:37:35 +0200
Message-Id: <20200518173506.179630060@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
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
@@ -454,6 +454,7 @@
 		ipmmu_vip0: mmu@e7b00000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7b00000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 4>;
 			power-domains = <&sysc R8A77980_PD_ALWAYS_ON>;
 			#iommu-cells = <1>;
 		};
@@ -461,6 +462,7 @@
 		ipmmu_vip1: mmu@e7960000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7960000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 11>;
 			power-domains = <&sysc R8A77980_PD_ALWAYS_ON>;
 			#iommu-cells = <1>;
 		};


