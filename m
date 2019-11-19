Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09DEA1014FE
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfKSFj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730285AbfKSFj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:39:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D01A4208C3;
        Tue, 19 Nov 2019 05:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141968;
        bh=VnAEBOD27XWMulR9/EeVPCt6n+USTqJyjGRRcoqKhTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uD/ry+kBVYsieQoF4rn+pjwiPmpcumYj/tvyd/DdJNGlq0joSa+n8yRrDn4+YERP7
         wzCspRkpJg0MlEmeIJyhT19LJ4CQ0avx1GKzFdqLMd/k7w1L2A4V2yoRxpHp+2vZKJ
         g2vJQQTvtXSQNmWHMpHn+clwKqmJrgGM7Bq3ExLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 341/422] ARM: dts: imx6ull: update vdd_soc voltage for 900MHz operating point
Date:   Tue, 19 Nov 2019 06:18:58 +0100
Message-Id: <20191119051421.112711980@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 245f880c25dbd8927af0f33aa5d1404370013957 ]

Update VDD_SOC voltage to 1.25V for 900MHz operating point
according to datasheet Rev. 1.3, 08/2018, 25mV is added to
the minimum allowed values to cover power supply ripple.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ull.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ull.dtsi b/arch/arm/boot/dts/imx6ull.dtsi
index cd1776a7015ac..796ed35d4ac9a 100644
--- a/arch/arm/boot/dts/imx6ull.dtsi
+++ b/arch/arm/boot/dts/imx6ull.dtsi
@@ -22,7 +22,7 @@
 	>;
 	fsl,soc-operating-points = <
 		/* KHz	uV */
-		900000	1175000
+		900000	1250000
 		792000	1175000
 		528000	1175000
 		396000	1175000
-- 
2.20.1



