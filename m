Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846FA15C352
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgBMPkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387789AbgBMP2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:47 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50742206DB;
        Thu, 13 Feb 2020 15:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607727;
        bh=c6sN0RjKAHXORAEcOzdJvGezCrM7RSfLgAmj2j+lqOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbYjraoecTugTPmPJb+/ZelelQvxcvHmN9oOmK47CLRLFV/ySg5c7PKmpeQq39tlQ
         El88PgxENEcTWL6mYvMOPbvwKv5Lr/YdU+/LHqvpbUZCwB94j7di0UWlR69fnpm/Hv
         3NpS3pCL+3gjBdfuKYMXJByOQz42Qa3sWcdl09Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: [PATCH 5.5 057/120] arm64: dts: qcom: msm8998-mtp: Add alias for blsp1_uart3
Date:   Thu, 13 Feb 2020 07:20:53 -0800
Message-Id: <20200213151921.158176607@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit c9ec155b5962233aff3df65210bd6a4788dee21c upstream.

The msm_serial driver has a predefined set of uart ports defined, which
is allocated either by reading aliases or if no match is found a simple
counter, starting at index 0. But there's no logic in place to prevent
these two allocation mechanism from colliding. As a result either none
or all of the active msm_serial instances must be listed as aliases.

Define blsp1_uart3 as "serial1" to mitigate this problem.

Fixes: 4cffb9f2c700 ("arm64: dts: qcom: msm8998-mtp: Enable bluetooth")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Link: https://lore.kernel.org/r/20191119011823.379100-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
@@ -9,6 +9,7 @@
 / {
 	aliases {
 		serial0 = &blsp2_uart1;
+		serial1 = &blsp1_uart3;
 	};
 
 	chosen {


