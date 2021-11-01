Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBB0441866
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhKAJrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233024AbhKAJpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:45:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BA9C610D2;
        Mon,  1 Nov 2021 09:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759000;
        bh=oCgXbVO73DRENdVLc+lSUjsNBQit6j959w5MLvAygFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7NQWHJevoniX0pR4Vj9Q0vG6DE8NAhInG+jP5mpq9tB+mjwAVx5xPkFB7Nu76d3q
         ymlwfqP+Cm4JliAsmdqiHw5tNMVQ6nozF+0tO+bhop1SclaD0OX5Ud0SP3EKsYMsPj
         2d5ka63RPBvT2FsSdWK02DZuJx19cxL4YHwWjdmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.14 040/125] arm64: dts: imx8mm-kontron: Set lower limit of VDD_SNVS to 800 mV
Date:   Mon,  1 Nov 2021 10:16:53 +0100
Message-Id: <20211101082540.767207009@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit 256a24eba7f897c817fb0103dac73467d3789202 upstream.

According to the datasheet the typical value for VDD_SNVS should be
800 mV, so let's make sure that this is within the range of the
regulator.

Fixes: 8668d8b2e67f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
@@ -150,7 +150,7 @@
 
 			reg_vdd_snvs: LDO2 {
 				regulator-name = "ldo2";
-				regulator-min-microvolt = <850000>;
+				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <900000>;
 				regulator-boot-on;
 				regulator-always-on;


