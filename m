Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7F74F26D5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiDEIF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiDEH7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62BA642C;
        Tue,  5 Apr 2022 00:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 515736179A;
        Tue,  5 Apr 2022 07:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBBDC340EE;
        Tue,  5 Apr 2022 07:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145382;
        bh=TUKxNNvhBlzZY1A9EPC3C6qsVhspfXYFcLCwTCMQ0j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlRIDIEhW/iAtpHkToEC/rVEpVqon2PhrsT2hJLpcDf69+CwvrsvIa2dt1WcQVo7r
         +iYKPrinL07Zvc/SA+rbHHtqj7X6I+qf2HH+g3pFt/WOqi07VfMJVBKedvd7YabiBc
         QggismvZYRFMa2vfE8bsZfhfqfplfHxHyUdOkDe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0347/1126] ARM: dts: qcom: sdx55: Fix the address used for PCIe EP local addr space
Date:   Tue,  5 Apr 2022 09:18:14 +0200
Message-Id: <20220405070417.814547657@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit c8a8f755170719dde7964d5172a145dd27e107ec ]

Fix the address range used for mapping the PCIe host memory in the DDR.

Fixes: e6b69813283f ("ARM: dts: qcom: sdx55: Add support for PCIe EP")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220208175222.415762-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index 8ac0492c7659..40f11159f061 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -413,7 +413,7 @@
 			      <0x40000000 0xf1d>,
 			      <0x40000f20 0xc8>,
 			      <0x40001000 0x1000>,
-			      <0x40002000 0x10000>,
+			      <0x40200000 0x100000>,
 			      <0x01c03000 0x3000>;
 			reg-names = "parf", "dbi", "elbi", "atu", "addr_space",
 				    "mmio";
-- 
2.34.1



