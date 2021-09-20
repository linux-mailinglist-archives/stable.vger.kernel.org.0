Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEC8412086
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352185AbhITRzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349811AbhITRxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:53:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C59AF6197A;
        Mon, 20 Sep 2021 17:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157990;
        bh=h08e8F4P8w/l1YEy/TuFnEdjIweC5EMttMZkLs3tubM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jzwUHdHMQsFY0Yuo5pYMFN0isgFHOw0Dh34Vms1yFfOEGHLYbV7HfvOJDCRQYddhF
         h6gJyRJ6FYMecnFmPPhACa0z5Zf5DPNGvupVohPiByTeqpuJijD1+C1OfHgcf0Hx4x
         7pddpldk6bnCkgAlcRBcXHztdR2fe2dhGhzAn35s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 212/293] arm64: dts: qcom: sdm660: use reg value for memory node
Date:   Mon, 20 Sep 2021 18:42:54 +0200
Message-Id: <20210920163940.526016230@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit c81210e38966cfa1c784364e4035081c3227cf5b ]

memory node like other node should be node@reg, which is missing in this
case, so fix it up

arch/arm64/boot/dts/qcom/ipq8074-hk01.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 1073741824, 0, 536870912]]}

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210308060826.3074234-18-vkoul@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
index c13ddee8262b..58acf21d8d33 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
@@ -28,7 +28,7 @@ chosen {
 		stdout-path = "serial0";
 	};
 
-	memory {
+	memory@40000000 {
 		device_type = "memory";
 		reg = <0x0 0x40000000 0x0 0x20000000>;
 	};
-- 
2.30.2



