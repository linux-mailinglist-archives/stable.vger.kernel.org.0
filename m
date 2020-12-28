Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF7A2E4254
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405797AbgL1OBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408200AbgL1OBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1198E207A9;
        Mon, 28 Dec 2020 14:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164053;
        bh=GnfBOWqUeiVeX8mRqWn6LTBk0ob7tvEbWtFvYA7Hoec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4aV1LNvbhJ34u9vhEEO/BrSty9DrOVvJwZF4h/r41eJMY2QJM9Miw0G8sLTURAm0
         oVlCgiJMiutq1gdCy0zJ8FfXR3I13jOamuL80HECvl7Q3Ul7hx13O/BfG4U2I0Nmvb
         /kYtLY+ewrzqjmSCh9ARsMNeWmKbPR5dw/TfhKMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kathiravan T <kathirav@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/717] arm64: dts: ipq6018: update the reserved-memory node
Date:   Mon, 28 Dec 2020 13:40:10 +0100
Message-Id: <20201228125021.576184853@linuxfoundation.org>
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

From: Kathiravan T <kathirav@codeaurora.org>

[ Upstream commit 4af5c6dc255ca64e5263a5254bb7553f05bb682c ]

Memory region reserved for the TZ is changed long back. Let's
update the same to align with the corret region. Its size also
increased to 4MB from 2MB.

Along with that, bump the Q6 region size to 85MB.

Fixes: 1e8277854b49 ("arm64: dts: Add ipq6018 SoC and CP01 board support")
Signed-off-by: Kathiravan T <kathirav@codeaurora.org>
Link: https://lore.kernel.org/r/1602690377-21304-1-git-send-email-kathirav@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 59e0cbfa22143..cdc1e3d60c58e 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -156,8 +156,8 @@
 			no-map;
 		};
 
-		tz: tz@48500000 {
-			reg = <0x0 0x48500000 0x0 0x00200000>;
+		tz: memory@4a600000 {
+			reg = <0x0 0x4a600000 0x0 0x00400000>;
 			no-map;
 		};
 
@@ -167,7 +167,7 @@
 		};
 
 		q6_region: memory@4ab00000 {
-			reg = <0x0 0x4ab00000 0x0 0x02800000>;
+			reg = <0x0 0x4ab00000 0x0 0x05500000>;
 			no-map;
 		};
 	};
-- 
2.27.0



