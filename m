Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227AD22662A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732459AbgGTQA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732455AbgGTQAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:00:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C576120773;
        Mon, 20 Jul 2020 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260855;
        bh=Y5bg9Y4GnzcKG6Ap7wWceKNr1KDlKIQK5OveZjreIZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGUd/SII92LL81yL3Q7jw9pFzd4MI+TKKSivEu92YxMGyyeFdPAl85C+TgIZcGyxT
         q2oSvzMa4KhB6PpspAkZIm3tb759/c7zYrw/XQwMuxDhKHDcNGjp1sfAUNSkDKMaXU
         WCefGbv7Yz6TU9mINDhXLwFbKcQ9Gl4PX7vAprqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.4 120/215] arm: dts: mt7623: add phy-mode property for gmac2
Date:   Mon, 20 Jul 2020 17:36:42 +0200
Message-Id: <20200720152825.906964168@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

commit ff5b89c2858f28006f9f9c0a88c55a679488192c upstream.

Add phy-mode property required by phylink on gmac2

Fixes: b8fc9f30821e ("net: ethernet: mediatek: Add basic PHYLINK support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://lore.kernel.org/r/70e3eff31ecd500ed4862d9de28325a4dbd15105.1583648927.git.sean.wang@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/mt7623n-rfb-emmc.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/mt7623n-rfb-emmc.dts
+++ b/arch/arm/boot/dts/mt7623n-rfb-emmc.dts
@@ -138,6 +138,7 @@
 	mac@1 {
 		compatible = "mediatek,eth-mac";
 		reg = <1>;
+		phy-mode = "rgmii";
 		phy-handle = <&phy5>;
 	};
 


