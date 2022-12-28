Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522EE65793E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbiL1O7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbiL1O67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:58:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C644910054
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:58:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63AF461130
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FEFC433EF;
        Wed, 28 Dec 2022 14:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239537;
        bh=KY6EI4QnL0oDLxTOl9x+lSkyQF7MJ5lHNbVGVtlXZVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmT3FNUxH/pq0j0QWoLTeWy7KQ7POZTWe2nLOU72LScujuOG3uxxwoweXEbKRdAbb
         AxtWcyGi4OgmDtzrkCNChnz8PtxjCXjqGmunllrwYxYlrktqA5v1V0ndaFZpyNHBoZ
         AWj6DnFK1a8D82fvk6rwtjVNfTRjJRbUgZcdhTAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0041/1073] arm64: dts: qcom: pm6350: Include header for KEY_POWER
Date:   Wed, 28 Dec 2022 15:27:09 +0100
Message-Id: <20221228144329.243702203@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit f6e2d6914c7c095660a9c7c503328eebab1e2557 ]

Make pm6350.dtsi self-contained by including input.h, needed for the
KEY_POWER constant used to define the power key.

Fixes: d8a3c775d7cd ("arm64: dts: qcom: Add PM6350 PMIC")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221030073232.22726-5-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm6350.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/pm6350.dtsi b/arch/arm64/boot/dts/qcom/pm6350.dtsi
index ecf9b9919182..68245d78d2b9 100644
--- a/arch/arm64/boot/dts/qcom/pm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm6350.dtsi
@@ -3,6 +3,7 @@
  * Copyright (c) 2021, Luca Weiss <luca@z3ntu.xyz>
  */
 
+#include <dt-bindings/input/input.h>
 #include <dt-bindings/spmi/spmi.h>
 
 &spmi_bus {
-- 
2.35.1



