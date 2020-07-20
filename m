Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B679F2268C1
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732986AbgGTQUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387695AbgGTQKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:10:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBA6220672;
        Mon, 20 Jul 2020 16:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261442;
        bh=Y5bg9Y4GnzcKG6Ap7wWceKNr1KDlKIQK5OveZjreIZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHJv6qeC/l1y53q7hxs+RlvDLYffyUqoxY0vqTSGRyYC46z5y0eGHUMqoHuXxk1Sc
         TW/l2Gudpt4rMuurOD1vqDox6D/Ha/uPnxClaBghmRNejOg0aTtQAlxOfpSnUi6WfZ
         e5BFWfoMPn53FK6bSOSWJwaewPf/6GZ+Io+5t/5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.7 118/244] arm: dts: mt7623: add phy-mode property for gmac2
Date:   Mon, 20 Jul 2020 17:36:29 +0200
Message-Id: <20200720152831.452338153@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
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
 


