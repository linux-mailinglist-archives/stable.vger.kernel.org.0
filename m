Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014E52E3CFE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438863AbgL1OJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:09:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438858AbgL1OJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:09:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1CF220715;
        Mon, 28 Dec 2020 14:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164544;
        bh=PxpCqsORoWBd9g0ukpv1T8hXjvpFzUJYAMljAEUVp0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYXjCr14uV2ydEhFRB3okgKlXv9RF24SnPsWgIkv6W1ETZkOk5u4N+NoRU6y6dYrN
         wg0gnGHgW/19j76FZ8MhgIbEFTqJMmboR76ESCrpbUwksOWVhDWWaDAewDX9vofVBF
         36EoHL2UWdxxUVI2F0G2iTfj8pSautXwFZJGUfos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/717] arm64: dts: qcom: sm8250: correct compatible for sm8250-mtp
Date:   Mon, 28 Dec 2020 13:43:00 +0100
Message-Id: <20201228125029.684579722@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d371a931540bc36fd1199de3ec365a1187b7b282 ]

Qualcomm boards should define two compatible strings: one for board,
anoter one for SoC family. sm8250-mtp.dts lists just the board
compatible, which makes it incompatible with qcom.yaml schema.

Reviewed-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 60378f1a171e ("arm64: dts: qcom: sm8250: Add sm8250 dts file")
Link: https://lore.kernel.org/r/20200930112133.2091505-1-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
index fd194ed7fbc86..98675e1f8204f 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
@@ -14,7 +14,7 @@
 
 / {
 	model = "Qualcomm Technologies, Inc. SM8250 MTP";
-	compatible = "qcom,sm8250-mtp";
+	compatible = "qcom,sm8250-mtp", "qcom,sm8250";
 
 	aliases {
 		serial0 = &uart12;
-- 
2.27.0



