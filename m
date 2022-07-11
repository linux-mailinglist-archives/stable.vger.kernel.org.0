Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9971056FD7A
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbiGKJ4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiGKJza (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:55:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FB833A27;
        Mon, 11 Jul 2022 02:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AFA62CE1268;
        Mon, 11 Jul 2022 09:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A330EC34115;
        Mon, 11 Jul 2022 09:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531574;
        bh=zwrZQNaTn0ZHycoDdEB+Kr7r7722XnecbnkQ7TC4xjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shat7RjuUYsb9M+wyDKV25WkBmzxtJt06iTEqKIOccky24QH+4PhJF8xJsPLEosF1
         7QoBOpONcJPgJLT5TVwjYPycti/J6s3/4OTtiB7ORJtk0fyijaQF0mtbq1ZXUv2PCV
         6mZ8KuAKFEAfGtOvZ6crHbwmTrXn+B1GgNOQWaOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Lypak <vladimir.lypak@gmail.com>,
        Adam Skladowski <a_skl39@protonmail.com>,
        Sireesh Kodali <sireeshkodali1@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/230] dt-bindings: soc: qcom: smd-rpm: Add compatible for MSM8953 SoC
Date:   Mon, 11 Jul 2022 11:06:50 +0200
Message-Id: <20220711090608.429338303@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Lypak <vladimir.lypak@gmail.com>

[ Upstream commit 96c42812f798c5e48d55cd6fc2101ce99af19608 ]

Document compatible for MSM8953 SoC.

Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Signed-off-by: Adam Skladowski <a_skl39@protonmail.com>
Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210825165943.19415-1-sireeshkodali1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml
index cc3fe5ed7421..77963b86b714 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml
@@ -34,6 +34,7 @@ properties:
       - qcom,rpm-ipq6018
       - qcom,rpm-msm8226
       - qcom,rpm-msm8916
+      - qcom,rpm-msm8953
       - qcom,rpm-msm8974
       - qcom,rpm-msm8976
       - qcom,rpm-msm8996
@@ -57,6 +58,7 @@ if:
           - qcom,rpm-apq8084
           - qcom,rpm-msm8916
           - qcom,rpm-msm8974
+          - qcom,rpm-msm8953
 then:
   required:
     - qcom,smd-channels
-- 
2.35.1



