Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BB515EDC1
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390168AbgBNQF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:05:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390161AbgBNQF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:05:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30C952187F;
        Fri, 14 Feb 2020 16:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696326;
        bh=lkT4t2JPsfUiREueM4DtSYmWVfxxScuuhymixnWu/xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TF1soRcQa8IrahPQJNZWUyBcNp04RJIyFuP6sjMlFf8bjH8ZfA0j98AV1EQIzBauk
         uFe4b4kAO81tk2kG61IOTqXRXtCXpnP3gxOvQVlCc18cr8xnglDIjsx6kB4st9WC7d
         CupW8MBHCeZUfjcmQAAHL3YYRJzDC0A/kasuNtFA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 165/459] arm64: dts: qcom: msm8998: Fix tcsr syscon size
Date:   Fri, 14 Feb 2020 10:56:55 -0500
Message-Id: <20200214160149.11681-165-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

[ Upstream commit 05caa5bf9cab9983dd7a50428c46b7e617ba20d6 ]

The tcsr syscon region is really 0x40000 in size.  We need access to the
full region so that we can access the axi resets when managing the
modem subsystem.

Fixes: c7833949564e ("arm64: dts: qcom: msm8998: Add smem related nodes")
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Link: https://lore.kernel.org/r/20191107045948.4341-1-jeffrey.l.hugo@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index ffb64fc239ee5..ccd535edbf4e1 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -985,7 +985,7 @@
 
 		tcsr_mutex_regs: syscon@1f40000 {
 			compatible = "syscon";
-			reg = <0x01f40000 0x20000>;
+			reg = <0x01f40000 0x40000>;
 		};
 
 		tlmm: pinctrl@3400000 {
-- 
2.20.1

