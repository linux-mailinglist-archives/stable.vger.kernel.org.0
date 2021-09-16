Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791E340E3CC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244180AbhIPQwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345147AbhIPQtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 832226159A;
        Thu, 16 Sep 2021 16:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809673;
        bh=grpqI8sJsgtdBrayXqXN5K8Cvo1phWPDGxjB1M24YFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/gT1Fi5+4ABHqjRHFfNNB/pQCCWz8mQzvguQ6SNHhi6VhiVOJz/nZnpPYd6872X1
         UgO9s4AC0I8oboeujWq4U0iqCZT4HNoK7B4Lhz9kWUUzvZsTrJlQqHEsJpggQKzmhB
         WwqtgUsyxmUCPVp+i3ifbbxDAZ44IeahdC0icGDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 239/380] arm64: dts: qcom: ipq6018: drop 0x from unit address
Date:   Thu, 16 Sep 2021 17:59:56 +0200
Message-Id: <20210916155812.209966259@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 1b91b8ef60e9a67141e66af3cca532c00f4605fe ]

Nodes need not contain '0x' for the unit address. Drop it to fix the
below warning:

arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml: reserved-memory:
'memory@0x60000' does not match any of the regexes

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210308060826.3074234-19-vkoul@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 9fa5b028e4f3..23ee1bfa4318 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -151,7 +151,7 @@ reserved-memory {
 		#size-cells = <2>;
 		ranges;
 
-		rpm_msg_ram: memory@0x60000 {
+		rpm_msg_ram: memory@60000 {
 			reg = <0x0 0x60000 0x0 0x6000>;
 			no-map;
 		};
-- 
2.30.2



