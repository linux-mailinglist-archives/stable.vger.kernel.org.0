Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F377145628
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgAVNVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:21:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:38534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730256AbgAVNV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:21:28 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846D6205F4;
        Wed, 22 Jan 2020 13:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699288;
        bh=dez6bY75cECNOLPtutvRtSN4Rc+ag1aEluc3e4CHQk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPuy5AM/NQIpR9xxC4rc23bDLkyRL5rp2mxMO2Ir2I+r9AiLv8ZXAvPPneQ+JcNru
         GNyTccdHZi5Vseer4CE5diD4AKACATvy8A+lz/H3kpZk3VFCy3vbxENYk1Gtkj9VPq
         OlYdkogqPyCd7RCW/kRppJtLVhbuLmn6mtKvXWAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 098/222] ARM: dts: imx7: Fix Toradex Colibri iMX7S 256MB NAND flash support
Date:   Wed, 22 Jan 2020 10:28:04 +0100
Message-Id: <20200122092840.757722524@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

commit 4b0b97e651ecf29f20248420b52b6864fbd40bc2 upstream.

Turns out when introducing the eMMC version the gpmi node required for
NAND flash support got enabled exclusively on Colibri iMX7D 512MB.

Fixes: f928a4a377e4 ("ARM: dts: imx7: add Toradex Colibri iMX7D 1GB (eMMC) support")
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx7s-colibri.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm/boot/dts/imx7s-colibri.dtsi
+++ b/arch/arm/boot/dts/imx7s-colibri.dtsi
@@ -49,3 +49,7 @@
 		reg = <0x80000000 0x10000000>;
 	};
 };
+
+&gpmi {
+	status = "okay";
+};


