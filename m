Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651D966C553
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjAPQE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjAPQEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:04:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB7B23C71
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:02:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86514B80FEA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0E8C433D2;
        Mon, 16 Jan 2023 16:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884974;
        bh=+Xg6VNqi33GeaIkwSMykubx4nUmPRrWrWGFxFztmAHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjhXhm6IEMr86e7TZYhFtfIcMozWV+A9ZjZXXleaxlc5QJ9E2ZgvcFkpLowBFPY4z
         cVw0WXvZgs3aFl3MhNbaX9j2qwrutKXdc+O2cDdbIGgvcnqFakMwKU/DuGVf2H/Czj
         0EiFKvebMSKaKeBoub1SZ8sMeeQD8oZ6ZvhtPTTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 5.15 26/86] dt-bindings: msm: dsi-controller-main: Fix description of core clock
Date:   Mon, 16 Jan 2023 16:51:00 +0100
Message-Id: <20230116154748.190806746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

commit 654ffe4b793b42ed6b5909daff0b91809916d94e upstream.

There's a typo in describing the core clock as an 'escape' clock. The
accurate description is 'core'.

Fixes: 4dbe55c97741 ("dt-bindings: msm: dsi: add yaml schemas for DSI bindings")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/515938/
Link: https://lore.kernel.org/r/20221223021025.1646636-4-bryan.odonoghue@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
@@ -31,7 +31,7 @@ properties:
       - description: Display byte clock
       - description: Display byte interface clock
       - description: Display pixel clock
-      - description: Display escape clock
+      - description: Display core clock
       - description: Display AHB clock
       - description: Display AXI clock
 


