Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD994F26D6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiDEIFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235613AbiDEH7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3484A64D5;
        Tue,  5 Apr 2022 00:56:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C447661722;
        Tue,  5 Apr 2022 07:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1060C34110;
        Tue,  5 Apr 2022 07:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145369;
        bh=w7dKSlwXBA/ixEwcf1zFa8OnnuZoUm3ObPb+9ezhVoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0befS2QlFaFoKekRvCYEw8lLOwG5yo6q6DUHMBal+056vjS0ZvSXJVitifh+/375T
         2+z2TI6i1jWrvWcLl7Fcgx/m4HoSmQHUmPwNVTWjnka0a7Lfo3umYvGnZUcLlGyqeU
         qOBGIvk/kouIaqTIEa0OAXhb+355lt8SAxmQhaJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0379/1126] arm64: dts: broadcom: Fix sata nodename
Date:   Tue,  5 Apr 2022 09:18:46 +0200
Message-Id: <20220405070418.750323385@linuxfoundation.org>
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

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit 55927cb44db43a57699fa652e2437a91620385dc ]

After converting ahci-platform txt binding to yaml nodename is reported
as not matching the standard:

arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dt.yaml:
ahci@663f2000: $nodename:0: 'ahci@663f2000' does not match '^sata(@.*)?$'

Fix it to match binding.

Fixes: ac9aae00f0fc ("arm64: dts: Add SATA3 AHCI and SATA3 PHY DT nodes for NS2")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi b/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
index 2cfeaf3b0a87..8c218689fef7 100644
--- a/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
+++ b/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
@@ -687,7 +687,7 @@
 			};
 		};
 
-		sata: ahci@663f2000 {
+		sata: sata@663f2000 {
 			compatible = "brcm,iproc-ahci", "generic-ahci";
 			reg = <0x663f2000 0x1000>;
 			dma-coherent;
-- 
2.34.1



