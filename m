Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E4A15C354
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387704AbgBMPkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:40:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729178AbgBMP2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:46 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01C112168B;
        Thu, 13 Feb 2020 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607726;
        bh=LhIMfqNJsxzo3+T6EIszIfsu7stTtmnHYkFApnVyveE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooRUDeY0gwh0yixaZQTavUGlhde46ERnFZUPr8tCKjlRDtifdVRdxnfRU6O2rNaXR
         DpIelyYNdwoh3nA1dOMQvTxJG1BEuUfbgIkm8eSNXl4GhLngPjykbuaRgCUhQsrbX4
         XRDb6ZT7Ecnui6+zb4lu7HK1QjMP/ONN23YPP+ZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.5 055/120] arm64: dts: qcom: msm8998: Fix tcsr syscon size
Date:   Thu, 13 Feb 2020 07:20:51 -0800
Message-Id: <20200213151920.580278284@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

commit 05caa5bf9cab9983dd7a50428c46b7e617ba20d6 upstream.

The tcsr syscon region is really 0x40000 in size.  We need access to the
full region so that we can access the axi resets when managing the
modem subsystem.

Fixes: c7833949564e ("arm64: dts: qcom: msm8998: Add smem related nodes")
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Link: https://lore.kernel.org/r/20191107045948.4341-1-jeffrey.l.hugo@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/qcom/msm8998.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -987,7 +987,7 @@
 
 		tcsr_mutex_regs: syscon@1f40000 {
 			compatible = "syscon";
-			reg = <0x01f40000 0x20000>;
+			reg = <0x01f40000 0x40000>;
 		};
 
 		tlmm: pinctrl@3400000 {


