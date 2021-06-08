Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312A43A00A9
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbhFHSqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235498AbhFHSn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:43:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3894F61444;
        Tue,  8 Jun 2021 18:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177385;
        bh=sphQtZmJ55ypiQBg7PymMgg2iqrVSJ3ENghBukVBfSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGBOhLUEYPwHhTVO76IOgzwAeqNKuzxX58U0cZF4vS3H8wFlwS6NwxC1uDhN7Ba9q
         kZQqD9DBlAhg7Aw/Gm0OBv44UJS0czaM1hRQ0nOtOFRIq+fRqJbYfzQhe0KRdfsuMi
         qk0IzI51OxRNkIwaJCGcabQiNslGCb2ecr+RfOvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/78] arm64: dts: zii-ultra: fix 12V_MAIN voltage
Date:   Tue,  8 Jun 2021 20:27:00 +0200
Message-Id: <20210608175936.321873232@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit ac0cbf9d13dccfd09bebc2f8f5697b6d3ffe27c4 ]

As this is a fixed regulator on the board there was no harm in the wrong
voltage being specified, apart from a confusing reporting to userspace.

Fixes: 4a13b3bec3b4 ("arm64: dts: imx: add Zii Ultra board support")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi b/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
index 32ce14936b01..f385b143b308 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
@@ -45,8 +45,8 @@
 	reg_12p0_main: regulator-12p0-main {
 		compatible = "regulator-fixed";
 		regulator-name = "12V_MAIN";
-		regulator-min-microvolt = <5000000>;
-		regulator-max-microvolt = <5000000>;
+		regulator-min-microvolt = <12000000>;
+		regulator-max-microvolt = <12000000>;
 		regulator-always-on;
 	};
 
-- 
2.30.2



