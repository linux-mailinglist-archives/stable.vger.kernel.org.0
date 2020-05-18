Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3FF1D8420
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732959AbgERSJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730517AbgERSGt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:06:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 042DF20853;
        Mon, 18 May 2020 18:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825209;
        bh=niMoW/NcqlytDsJs9MnEpxBRpo4qzbQDc39I//L98n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYtnHaiN8vKcjY/MmSgeUl5J6+XAN1M4CZNsQE12bFnhZwNpZJqjrug0WEETgt957
         HXbzi3Evsel8zHbn4QJx2C0NAyIm6YqcljoQD7dNPBpHUFzJIj8qhwY8CrSubhu6jc
         zfW3FLriQmioV3A5Hl4GKlFWsXW1KXTZcYNaUgf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.6 174/194] arm64: dts: qcom: msm8996: Reduce vdd_apc voltage
Date:   Mon, 18 May 2020 19:37:44 +0200
Message-Id: <20200518173546.124111884@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 28810eecae08f9458a44831978e36f14ed182c80 upstream.

Some msm8996 based devices are unstable when run with VDD_APC of 1.23V,
which is listed as the maximum voltage in "Turbo" mode. Given that the
CPU cluster is not run in "Turbo" mode, reduce this to 0.98V - the
maximum voltage for nominal operation.

Tested-by: Loic Poulain <loic.poulain@linaro.org>
Fixes: 7a2a2231ef22 ("arm64: dts: apq8096-db820c: Fix VDD core voltage")
Cc: Loic Poulain <loic.poulain@linaro.org>
Link: https://lore.kernel.org/r/20200318054442.3066726-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
@@ -658,8 +658,8 @@
 	s11 {
 		qcom,saw-leader;
 		regulator-always-on;
-		regulator-min-microvolt = <1230000>;
-		regulator-max-microvolt = <1230000>;
+		regulator-min-microvolt = <980000>;
+		regulator-max-microvolt = <980000>;
 	};
 };
 


