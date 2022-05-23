Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789A1531AE8
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbiEWRaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242800AbiEWR2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744E08CB34;
        Mon, 23 May 2022 10:24:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 395A6608C0;
        Mon, 23 May 2022 17:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42429C385A9;
        Mon, 23 May 2022 17:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326615;
        bh=P7ifuMvgfCQC7c5AuL095K8fyYyVN8m4teyXLs5ZboM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnlbLvvnw/IPzNWJlI870VHIgiiGGFde5dtSmqlevo/Yf3o0cknqD2E3MS6I6+it0
         WHI0JYj/PdJgVjEZH8YqDpsRFS+zh+sMMhaxj0zJrHYayduTvD+QJUh6gb+BLtM+hV
         VGJhvEVqRCfmNzRD1Hw+G1MRnrjIypl6ZpsciLZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jae Hyun Yoo <quic_jaehyoo@quicinc.com>,
        Rob Herring <robh@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>, Joel Stanley <joel@jms.id.au>
Subject: [PATCH 5.15 129/132] dt-bindings: pinctrl: aspeed-g6: remove FWQSPID group
Date:   Mon, 23 May 2022 19:05:38 +0200
Message-Id: <20220523165845.083615959@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>

commit a29c96a4053dc3c1d39353b61089882f81c6b23d upstream.

FWQSPID is not a group of FWSPID so remove it.

Fixes: 7488838f2315 ("dt-bindings: pinctrl: aspeed: Document AST2600 pinmux")
Signed-off-by: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20220329173932.2588289-4-quic_jaehyoo@quicinc.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


