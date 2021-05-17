Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8ED383369
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241220AbhEQO6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241184AbhEQO4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:56:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF99F61999;
        Mon, 17 May 2021 14:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261508;
        bh=mJGn8kKmvzm1L4SpZ5CFOdxDgF+ThAv3gXsHYvLl4Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjw58jpa2PfZakabe0/9++GQMJlg92WXiwn0Lv05bdi9Jnx/Alq14uWFFJiHqWBfA
         Gxy9SluAr9xUDVMPSfYCF3JtGwJjlZsa9z8ftX8bW34bYsBurhgjWf3MAIbgBgDD4y
         O9NVIpEC+1RTGMf64Ykpkly9czmyLhuYNhqOIf3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Sandeep Maheswaram <sanm@codeaurora.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.12 357/363] dt-bindings: phy: qcom,qmp-usb3-dp-phy: move usb3 compatibles back to qcom,qmp-phy.yaml
Date:   Mon, 17 May 2021 16:03:43 +0200
Message-Id: <20210517140314.660253350@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 94c34600b6173a2b9dd7d9694a42d86fb8768e62 upstream.

The commit 724fabf5df13 ("dt-bindings: phy: qcom,qmp-usb3-dp: Add DP phy
information") has support for DP part of USB3+DP combo PHYs. However
this change is not backwards compatible, placing additional requirements
onto qcom,sc7180-qmp-usb3-phy and qcom,sdm845-qmp-usb3-phy device nodes
(to include separate DP part, etc). However the aforementioned nodes do
not inclue DP part, they strictly follow the schema defined in the
qcom,qmp-phy.yaml file. Move those compatibles, leaving
qcom,qmp-usb3-dp-phy.yaml to describe only real "combo" USB3+DP device nodes.

Fixes: 724fabf5df13 ("dt-bindings: phy: qcom,qmp-usb3-dp: Add DP phy information")
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Sandeep Maheswaram <sanm@codeaurora.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210331151614.3810197-2-dmitry.baryshkov@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml         |    2 ++
 Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml
@@ -25,11 +25,13 @@ properties:
       - qcom,msm8998-qmp-pcie-phy
       - qcom,msm8998-qmp-ufs-phy
       - qcom,msm8998-qmp-usb3-phy
+      - qcom,sc7180-qmp-usb3-phy
       - qcom,sc8180x-qmp-ufs-phy
       - qcom,sc8180x-qmp-usb3-phy
       - qcom,sdm845-qhp-pcie-phy
       - qcom,sdm845-qmp-pcie-phy
       - qcom,sdm845-qmp-ufs-phy
+      - qcom,sdm845-qmp-usb3-phy
       - qcom,sdm845-qmp-usb3-uni-phy
       - qcom,sm8150-qmp-ufs-phy
       - qcom,sm8150-qmp-usb3-phy
--- a/Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml
@@ -14,9 +14,7 @@ properties:
   compatible:
     enum:
       - qcom,sc7180-qmp-usb3-dp-phy
-      - qcom,sc7180-qmp-usb3-phy
       - qcom,sdm845-qmp-usb3-dp-phy
-      - qcom,sdm845-qmp-usb3-phy
   reg:
     items:
       - description: Address and length of PHY's USB serdes block.


