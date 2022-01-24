Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34FC499BB8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346598AbiAXVyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:54:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53064 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445711AbiAXVnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:43:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46E9AB8121C;
        Mon, 24 Jan 2022 21:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCD9C340E4;
        Mon, 24 Jan 2022 21:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060619;
        bh=GGcYcClawHlbWWb5kpfU7Hq1ToMG9DJgl8z6mCAN5VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nDw1BJcMIcKN2uaUX5lwtFamKB0G3jQwM4K+0Z+3FBcUBgOOIVg+srXrpqUYp4AL
         gmy4UT81oFQE8KVswX011myPy6rUelkItRueiT1YJ+Xfbjm4jrKK7TmYMA82pzcT58
         37/vMVp7Co32/WULNxa1ZQR8w09HH/KchmWdg5Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.16 1007/1039] arm64: dts: qcom: msm8996: drop not documented adreno properties
Date:   Mon, 24 Jan 2022 19:46:36 +0100
Message-Id: <20220124184159.140727335@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

commit c41910f257a22dc406c60d8826b4a3b5398003a3 upstream.

These properties aren't documented nor implemented in the driver.
Drop them.

Fixes warnings as:
$ make dtbs_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/display/msm/gpu.yaml
...
arch/arm64/boot/dts/qcom/msm8996-mtp.dt.yaml: gpu@b00000: 'qcom,gpu-quirk-fault-detect-mask', 'qcom,gpu-quirk-two-pass-use-wfi' do not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: Documentation/devicetree/bindings/display/msm/gpu.yaml
...

Fixes: 69cc3114ab0f ("arm64: dts: Add Adreno GPU definitions")
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211030100413.28370-1-david@ixit.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -987,9 +987,6 @@
 			nvmem-cells = <&speedbin_efuse>;
 			nvmem-cell-names = "speed_bin";
 
-			qcom,gpu-quirk-two-pass-use-wfi;
-			qcom,gpu-quirk-fault-detect-mask;
-
 			operating-points-v2 = <&gpu_opp_table>;
 
 			status = "disabled";


