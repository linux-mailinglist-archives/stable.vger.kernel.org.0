Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF7D1147DCF
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388700AbgAXKDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:03:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388865AbgAXKDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:03:21 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6147821556;
        Fri, 24 Jan 2020 10:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860201;
        bh=rzazv8LE6sZxsuFYXM/ksk+icEkwKWnoQ1HBWfMckpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cuO8GvHWvOCwUkKoi2+CSBp8QI/5NX0U4dHlXzv9NFEGa8kNzo61LxdWZODlZd3TL
         wwprpk/o3dLfEzyjkYz/+DE1v1o7N4gNv57k1T/Jc6+IbsucTglEdlxE8P5Z8OTeQY
         hJPqIpdTHu88kBNdDLzGYDbB4dBGheUe1Ipbuevc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 265/343] ARM: dts: stm32: add missing vdda-supply to adc on stm32h743i-eval
Date:   Fri, 24 Jan 2020 10:31:23 +0100
Message-Id: <20200124092954.856172671@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

[ Upstream commit 493e84c5dc4d703d976b5875f5db22dae08a0782 ]

Add missing vdda-supply required by STM32 ADC.

Fixes: 090992a9ca54 ("ARM: dts: stm32: enable ADC on stm32h743i-eval
board")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32h743i-eval.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/stm32h743i-eval.dts b/arch/arm/boot/dts/stm32h743i-eval.dts
index 6c07786e7ddb9..0d98b2865bd77 100644
--- a/arch/arm/boot/dts/stm32h743i-eval.dts
+++ b/arch/arm/boot/dts/stm32h743i-eval.dts
@@ -71,6 +71,7 @@
 };
 
 &adc_12 {
+	vdda-supply = <&vdda>;
 	vref-supply = <&vdda>;
 	status = "okay";
 	adc1: adc@0 {
-- 
2.20.1



