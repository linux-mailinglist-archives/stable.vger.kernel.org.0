Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05B64995B4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442299AbiAXUyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:54:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49368 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392603AbiAXUvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:51:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C913B810A8;
        Mon, 24 Jan 2022 20:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A41FC340E5;
        Mon, 24 Jan 2022 20:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057495;
        bh=Xp/NUKjRPfqRoCdImG8zwdspMPv1pz8cCQ82YXt0qHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIGPa2h+cU7ixeRzOPSqwXKBwf/Z0kBPlegTiYK/pDROqVj+UmN+Frpz1KkfbhtKZ
         BnaDfeoMOIMNIRutwL28FaY1DU/cSDcMBfEJgXuDE3FgnlzvkHG0Oh0nyEVe5YYFdc
         dYI/3LGYRSuZfZYgfgI0CnXWc3oUgVc8H8SRUyiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 824/846] arm64: dts: qcom: msm8996: drop not documented adreno properties
Date:   Mon, 24 Jan 2022 19:45:41 +0100
Message-Id: <20220124184129.327214534@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -965,9 +965,6 @@
 			nvmem-cells = <&speedbin_efuse>;
 			nvmem-cell-names = "speed_bin";
 
-			qcom,gpu-quirk-two-pass-use-wfi;
-			qcom,gpu-quirk-fault-detect-mask;
-
 			operating-points-v2 = <&gpu_opp_table>;
 
 			status = "disabled";


