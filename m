Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD77366C4A1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjAPP4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjAPP42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:56:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1712227B2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:56:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AF896102A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A108DC433D2;
        Mon, 16 Jan 2023 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884587;
        bh=zgWuZHm0L3Rn5ONZWLTU9T5wxD4w9q34r89Agk7OXlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09cVDPLwM1O8/eeCVM4S6jklGFfUDRKrNdTHLhaovRe3Uave3gRYiprYJGmYyynv6
         E7RwDltU8KvYDogLUOZa/UTBQ9WBrH07Xxfx5/wIPmGrlEQezXJgzsBRNngGOg/gyE
         vGQd+W1GwK8b2JdoqEeKxlaNaVeVDu4vj/1bdwNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.1 062/183] dt-bindings: msm: dsi-phy-28nm: Add missing qcom, dsi-phy-regulator-ldo-mode
Date:   Mon, 16 Jan 2023 16:49:45 +0100
Message-Id: <20230116154805.976039460@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit be79f805a1e1b95605c825f1c513bdd2c8b167ed upstream.

Add in missing qcom,dsi-phy-regulator-ldo-mode to the 28nm DSI PHY.
When converting from .txt to .yaml we missed this one.

Fixes: 4dbe55c97741 ("dt-bindings: msm: dsi: add yaml schemas for DSI bindings")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/516205/
Link: https://lore.kernel.org/r/20221229124438.504770-2-bryan.odonoghue@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml
@@ -34,6 +34,10 @@ properties:
   vddio-supply:
     description: Phandle to vdd-io regulator device node.
 
+  qcom,dsi-phy-regulator-ldo-mode:
+    type: boolean
+    description: Indicates if the LDO mode PHY regulator is wanted.
+
 required:
   - compatible
   - reg


