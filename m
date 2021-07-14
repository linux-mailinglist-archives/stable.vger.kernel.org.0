Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799363C903D
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241046AbhGNTyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241060AbhGNTuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E62B61405;
        Wed, 14 Jul 2021 19:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292004;
        bh=ivgn6gGnXLOU8c+9hEn4Vbz9N27OOAfn+iY9cWLpStk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilCVW5bAq/jkxfqTdIFmhhcB0h29JG0dBjJz3A87K0FzYHxBBU5Ns+yoge9+rTuFE
         5x/HlfsiFm2JkKjwb5Xcx84BSebRxnGjU/g0kiY+YRULJYYbsY6NsdWI0efUpF7MAL
         VIUu4iTp7/Hb45ioumsGAMrAE4cKhfxdfu36X/1whROHgcGor894K0P73bWfrEungs
         KA0EpXBr1Tzlrz6NnWIaYlGvHiWiaCRhDu9JKqYQyfSzGhSi1UiPwCXAROqNXzu8Qc
         s7hWeZMRKoAv3hy0uy+My5c5L++rQDpPpZWZivfn34VqgM/0USRmXykYiokQfYoG3Z
         oOKBluCL0Lk+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 14/39] ARM: dts: Hurricane 2: Fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:45:59 -0400
Message-Id: <20210714194625.55303-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit a4528d9029e2eda16e4fc9b9da1de1fbec10ab26 ]

This matches nand-controller.yaml requirements.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-hr2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm-hr2.dtsi b/arch/arm/boot/dts/bcm-hr2.dtsi
index dd71ab08136b..30574101471a 100644
--- a/arch/arm/boot/dts/bcm-hr2.dtsi
+++ b/arch/arm/boot/dts/bcm-hr2.dtsi
@@ -179,7 +179,7 @@ amac0: ethernet@22000 {
 			status = "disabled";
 		};
 
-		nand: nand@26000 {
+		nand_controller: nand-controller@26000 {
 			compatible = "brcm,nand-iproc", "brcm,brcmnand-v6.1";
 			reg = <0x26000 0x600>,
 			      <0x11b408 0x600>,
-- 
2.30.2

