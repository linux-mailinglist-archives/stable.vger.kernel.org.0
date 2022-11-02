Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326CF615825
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiKBCqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiKBCqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:46:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E30A20F7B
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:45:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B05A617C7
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DADFC433D6;
        Wed,  2 Nov 2022 02:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357158;
        bh=J1BpyigVeoA98NlMDXcjuvnyM2J+3kXNcp9YwoxetEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TN6Kvq6SIqw+zzHkDw2ixQD2vR8dUkx9qS739Vfhy9Up5GSrAdex+LLO5aq7Il/4e
         BnklO2UVBGlJyYRKX78RTcBS/uWXBnOlNOJ/KNxRArPbnapuoTZRhO6vLuB8Ra+LSm
         HYsADib3i1Zk4SRJYnDhbNBq3S7H7/gBd+B0Gc9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
        Michal Simek <michal.simek@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.0 094/240] Revert "dt-bindings: pinctrl-zynqmp: Add output-enable configuration"
Date:   Wed,  2 Nov 2022 03:31:09 +0100
Message-Id: <20221102022113.521742409@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>

commit ff8356060e3a5e126abb5e1f6b6e9931c220dec2 upstream.

This reverts commit 133ad0d9af99bdca90705dadd8d31c20bfc9919f.

On systems with older PMUFW (Xilinx ZynqMP Platform Management Firmware)
using these pinctrl properties can cause system hang because there is
missing feature autodetection.
When this feature is implemented, support for these two properties should
bring back.

Cc: stable@vger.kernel.org
Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20221017130303.21746-3-sai.krishna.potthuri@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../devicetree/bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml      | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml
index 1e2b9b627b12..2722dc7bb03d 100644
--- a/Documentation/devicetree/bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml
@@ -274,10 +274,6 @@ patternProperties:
           slew-rate:
             enum: [0, 1]
 
-          output-enable:
-            description:
-              This will internally disable the tri-state for MIO pins.
-
           drive-strength:
             description:
               Selects the drive strength for MIO pins, in mA.
-- 
2.38.1



