Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318F029BAF1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802718AbgJ0PvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802205AbgJ0PqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 578092231B;
        Tue, 27 Oct 2020 15:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813558;
        bh=8q1iBLBaIebp3wRZiThfQ1xCp7msHz/VyOF2lfbaHrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjkfIwzo4AKxCgeaFdyfIajiZBp8q0HkoXQwkiOCbXA0HrZ+VD6FlN3IKs6TSz4B+
         M1Zvc711NiZj3FTlcHa0py8OWyQ+Y70qlzJsUmUrZibpsabwAFvrMU24O5AjIi1/Dt
         LqMEtnHNdmrnYTvQeBfQ7tJ/h7TTnyjtW8hzovOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 593/757] arm64: dts: qcom: sdm845-db845c: Fix hdmi nodes
Date:   Tue, 27 Oct 2020 14:54:03 +0100
Message-Id: <20201027135518.349329167@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit bca4339bda0989e49189c164795b120eb261970c ]

As per binding documentation, we should have dsi as node 0 and hdmi
audio as node 1, so fix it

Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: aef9a119dfb9 ("arm64: dts: qcom: sdm845-db845c: Add hdmi bridge nodes")
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20200828074347.3788518-1-vkoul@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index a2a98680ccf53..99d33955270ec 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -451,16 +451,16 @@ ports {
 			port@0 {
 				reg = <0>;
 
-				lt9611_out: endpoint {
-					remote-endpoint = <&hdmi_con>;
+				lt9611_a: endpoint {
+					remote-endpoint = <&dsi0_out>;
 				};
 			};
 
-			port@1 {
-				reg = <1>;
+			port@2 {
+				reg = <2>;
 
-				lt9611_a: endpoint {
-					remote-endpoint = <&dsi0_out>;
+				lt9611_out: endpoint {
+					remote-endpoint = <&hdmi_con>;
 				};
 			};
 		};
-- 
2.25.1



