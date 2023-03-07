Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A80F6AEA33
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjCGRbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjCGRbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:31:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AF49DE3F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:26:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8FB87CE1C1B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9E3C433D2;
        Tue,  7 Mar 2023 17:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209997;
        bh=hLyJt667Aw4j4PzIorJ6E01MWCKul67qH0QIoSd4E+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGJSk2NNbOLHISP4k+oNnaQBYhRjfA6KQIamZlmZcSOqBESKtFfSfwahAe5nm/Ozd
         yxZxS5A/dWlGX1qpaMw2e3zy0beN7TkzG7NF83tjgaQxLDaEdxdBDcjEh3/LOxMxg7
         C+cPQiO5CS7yUtKQ1u1ZD8IDHCPB+YaqVZQWQTh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
        Rob Herring <robh@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0400/1001] dt-bindings: display: mediatek: Fix the fallback for mediatek,mt8186-disp-ccorr
Date:   Tue,  7 Mar 2023 17:52:52 +0100
Message-Id: <20230307170038.684921758@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen-KH Cheng <allen-kh.cheng@mediatek.com>

[ Upstream commit 137272ef1b0f17a1815fec00d583515a0163f85e ]

The mt8186-disp-ccorr is not fully compatible with the mt8183-disp-ccorr
implementation. It causes a crash when system resumes if it binds to the
device.

We should use mt8192-disp-ccorr as fallback of mt8186-disp-ccorr.

Fixes: 8a26ea19d4dc ("dt-bindings: display: mediatek: add MT8186 SoC binding")
Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20230118091829.755-10-allen-kh.cheng@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/display/mediatek/mediatek,ccorr.yaml    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/display/mediatek/mediatek,ccorr.yaml b/Documentation/devicetree/bindings/display/mediatek/mediatek,ccorr.yaml
index 63fb02014a56a..117e3db43f84a 100644
--- a/Documentation/devicetree/bindings/display/mediatek/mediatek,ccorr.yaml
+++ b/Documentation/devicetree/bindings/display/mediatek/mediatek,ccorr.yaml
@@ -32,7 +32,7 @@ properties:
       - items:
           - enum:
               - mediatek,mt8186-disp-ccorr
-          - const: mediatek,mt8183-disp-ccorr
+          - const: mediatek,mt8192-disp-ccorr
 
   reg:
     maxItems: 1
-- 
2.39.2



