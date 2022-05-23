Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B858653125C
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbiEWPIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237628AbiEWPIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:08:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6FA5C752
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:08:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BB5C61269
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A601C385A9;
        Mon, 23 May 2022 15:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653318512;
        bh=xOPseEn1duZlBr9XWjzzLehzaQK8tjSZRL2p8wRb78Q=;
        h=Subject:To:Cc:From:Date:From;
        b=dNvuEjN1eK7Pv5cq2NgArjB827qwsK4XSxdpcRvf8ukU7hJgnTjfERwu2mjmWdnPT
         TsFTu5Ho9l0l0iFhWz9mXO3Zn47RNmm0yaiuwq5MjyzoE/EA03+zuRqJHDwBFu/g5t
         Ij+4W1uXBxZb2/p9mJTGoDMzmBblh9oa3U5xTHPE=
Subject: FAILED: patch "[PATCH] dt-bindings: pinctrl: aspeed-g6: remove FWQSPID group" failed to apply to 5.4-stable tree
To:     quic_jaehyoo@quicinc.com, andrew@aj.id.au, joel@jms.id.au,
        robh@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 May 2022 17:08:29 +0200
Message-ID: <165331850910996@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a29c96a4053dc3c1d39353b61089882f81c6b23d Mon Sep 17 00:00:00 2001
From: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
Date: Tue, 29 Mar 2022 10:39:28 -0700
Subject: [PATCH] dt-bindings: pinctrl: aspeed-g6: remove FWQSPID group

FWQSPID is not a group of FWSPID so remove it.

Fixes: 7488838f2315 ("dt-bindings: pinctrl: aspeed: Document AST2600 pinmux")
Signed-off-by: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20220329173932.2588289-4-quic_jaehyoo@quicinc.com
Signed-off-by: Joel Stanley <joel@jms.id.au>

diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
index 57b68d6c7c70..eb6e2f2dc9eb 100644
--- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
@@ -58,7 +58,7 @@ patternProperties:
           $ref: "/schemas/types.yaml#/definitions/string"
           enum: [ ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15, ADC2,
                   ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, EMMCG1, EMMCG4,
-                  EMMCG8, ESPI, ESPIALT, FSI1, FSI2, FWSPIABR, FWSPID, FWQSPID, FWSPIWP,
+                  EMMCG8, ESPI, ESPIALT, FSI1, FSI2, FWSPIABR, FWSPID, FWSPIWP,
                   GPIT0, GPIT1, GPIT2, GPIT3, GPIT4, GPIT5, GPIT6, GPIT7, GPIU0, GPIU1,
                   GPIU2, GPIU3, GPIU4, GPIU5, GPIU6, GPIU7, HVI3C3, HVI3C4, I2C1, I2C10,
                   I2C11, I2C12, I2C13, I2C14, I2C15, I2C16, I2C2, I2C3, I2C4, I2C5,

