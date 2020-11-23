Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B592C0B83
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388818AbgKWNZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:25:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731122AbgKWMcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C255A20728;
        Mon, 23 Nov 2020 12:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134763;
        bh=uv8NaVi5sIeCxzxuF1RmchYY6x10GhsiwPAYJAvbLcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V79hKFReoNf25CnuUlP66L3S4vW5e3qdeE+HTGNAK5VbdBTNZxsTHbZt2NUjzeLGM
         XnaVkC0jqR/MI6Z1L/OGhrc+NtfPIa2lFThFeSyVNs6Snt3VwWbxb5NT2aTuOBQ44e
         Jgadm1orTXP/0MhRMjdmbZfAEzMGNGCjVDYvSWkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Matyukevich <geomatsi@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/91] arm: dts: imx6qdl-udoo: fix rgmii phy-mode for ksz9031 phy
Date:   Mon, 23 Nov 2020 13:22:03 +0100
Message-Id: <20201123121811.407279113@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <geomatsi@gmail.com>

[ Upstream commit 7dd8f0ba88fce98e2953267a66af74c6f4792a56 ]

Commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the
KSZ9031 PHY") fixed micrel phy driver adding proper support for phy
modes. Adapt imx6q-udoo board phy settings : explicitly set required
delay configuration using "rgmii-id".

Fixes: cbd54fe0b2bc ("ARM: dts: imx6dl-udoo: Add board support based off imx6q-udoo")
Signed-off-by: Sergey Matyukevich <geomatsi@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-udoo.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-udoo.dtsi b/arch/arm/boot/dts/imx6qdl-udoo.dtsi
index 4f27861bbb324..4cc9858f7ff80 100644
--- a/arch/arm/boot/dts/imx6qdl-udoo.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-udoo.dtsi
@@ -97,7 +97,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 
-- 
2.27.0



