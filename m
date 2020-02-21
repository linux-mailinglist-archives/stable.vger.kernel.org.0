Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2441677F8
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgBUHvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:51:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729671AbgBUHvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:51:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D707924656;
        Fri, 21 Feb 2020 07:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271464;
        bh=Z6d6zi/9ewk2kMFLw5AZmpLrk8BYR4zguQyQmM1H/aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vXBZldONaeQD2Lk7j7gvTZfTY+c469T77ClsBb/3QqUAwfkA+p/GxZGXLPGBbPrvI
         A3pGjXmkXGHesPx9qdU54hMEjPpf1XWDfeCuEPZTOH8yGn5tEfzwxqGaKchVE8eSdk
         wdPKIDRk+mUfAnCIgTZerEuS1Fp6HQsnj2eI8kwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 176/399] arm64: dts: qcom: db845c: Enable ath10k 8bit host-cap quirk
Date:   Fri, 21 Feb 2020 08:38:21 +0100
Message-Id: <20200221072419.765100185@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 2e198c395a084ff3015d71896e35de049c40e3a4 ]

The WiFi firmware used on db845c implements the 8bit host-capability
message, so enable the quirk for this.

Reviewed-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20191113232245.4039932-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index d100f46791a62..912ba745c0fc9 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -529,6 +529,8 @@
 	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
 	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+
+	qcom,snoc-host-cap-8bit-quirk;
 };
 
 /* PINCTRL - additions to nodes defined in sdm845.dtsi */
-- 
2.20.1



