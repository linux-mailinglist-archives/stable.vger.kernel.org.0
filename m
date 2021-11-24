Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BB945C429
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349992AbhKXNpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:45:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349100AbhKXNo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:44:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13D5A632F9;
        Wed, 24 Nov 2021 12:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758786;
        bh=kTJkctlIB7qi4umI2Ug4hRWDczQzGgxoWdw6dcLY4v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mr2fZdd3ewvH8N7sAajweVIy7I0tAC4qFF1111rnLYDPBEIyftDFq4gKOg87T+yBI
         430gx6bItvma0/8OhSUYSIDEnQuYuZR4IEW6TVI0B95+vfsAjV01ecI4BaC0lOzSk+
         aBFDecD9h+DpdLutVRBf1+MnyY1doDjeC1kXMXhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/279] arm64: dts: qcom: ipq8074: Fix qcom,controlled-remotely property
Date:   Wed, 24 Nov 2021 12:55:16 +0100
Message-Id: <20211124115719.756674305@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 8c97f0ac4dc8f1743eb8e8a49f66189e13ae45e9 ]

Property qcom,controlled-remotely should be boolean.  Fix it.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210829111628.5543-3-shawn.guo@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index db333001df4d6..97f99663c132e 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -220,7 +220,7 @@
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <1>;
-			qcom,controlled-remotely = <1>;
+			qcom,controlled-remotely;
 			status = "disabled";
 		};
 
-- 
2.33.0



