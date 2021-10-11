Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32CE42901E
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbhJKOFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238626AbhJKOBf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:01:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA7FE611C1;
        Mon, 11 Oct 2021 13:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960651;
        bh=wXHgG+Emv8wQo0dWZqsnbCUUB1p1epBxr0Au5ws00RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgoIxrRs0ZttOjMoozlJFcvy4wlpLfxfuVD6GY2MX7WTJnOWNpYGCyhhOq5205DY/
         WY/zjeWfrubx7u791HcSD+f3as6WrCxFWsGragmAC19cv52JoakGZc6cN5Z+O46Sar
         NfVEphMk+jbWgrHh71/uJpUl7i+2twzTEggQ5LW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.14 033/151] ARM: dts: qcom: apq8064: use compatible which contains chipid
Date:   Mon, 11 Oct 2021 15:45:05 +0200
Message-Id: <20211011134518.921506321@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

commit f5c03f131dae3f06d08464e6157dd461200f78d9 upstream.

Also resolves these kernel warnings for APQ8064:
adreno 4300000.adreno-3xx: Using legacy qcom,chipid binding!
adreno 4300000.adreno-3xx: Use compatible qcom,adreno-320.2 instead.

Tested on Nexus 7 2013, no functional changes.

Cc: <stable@vger.kernel.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20210818065317.19822-1-david@ixit.cz
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1148,7 +1148,7 @@
 		};
 
 		gpu: adreno-3xx@4300000 {
-			compatible = "qcom,adreno-3xx";
+			compatible = "qcom,adreno-320.2", "qcom,adreno";
 			reg = <0x04300000 0x20000>;
 			reg-names = "kgsl_3d0_reg_memory";
 			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
@@ -1163,7 +1163,6 @@
 			    <&mmcc GFX3D_AHB_CLK>,
 			    <&mmcc GFX3D_AXI_CLK>,
 			    <&mmcc MMSS_IMEM_AHB_CLK>;
-			qcom,chipid = <0x03020002>;
 
 			iommus = <&gfx3d 0
 				  &gfx3d 1


