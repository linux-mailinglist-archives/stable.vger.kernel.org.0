Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD4C51A9D8
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357655AbiEDRTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358142AbiEDRPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5564CD57
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1832616AC
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2453C385B2;
        Wed,  4 May 2022 16:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683565;
        bh=FAAqozNX5oGCDnQertXgIhmReyhpy1pleu4khUSF6/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNUuWX1NBKK+gSabAQ9Ze9bOb8AzCljJ5kO2IWvIBsH0TeOy6yCvAjyuf5C5Dm7kk
         qzVyUewXl+92J37sGszlUiEdzzddy6N5w0HW6zmP8AOFw5tJ90hXQPnKVZgVl3od+3
         TDivk9xFaHOlupOZkIHp4aUOKUW+hraFz7vwRTw84a+bSXwq83rdAq8uJM6GVz6t1D
         OdNi/4daA7zVCyzydQhIfsuvL/aYBMG+wk93Yr96/RipQ5tCpkgS10QnruWPtL5uyF
         spwsq1WIe7HPemznuil5KrsBnEqK2UOypoXcyguLARnetVB63RLq5/pMzbhgVj/Nzd
         IKyP5EjT8K1+A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.17 18/19] PCI: aardvark: Drop __maybe_unused from advk_pcie_disable_phy()
Date:   Wed,  4 May 2022 18:58:51 +0200
Message-Id: <20220504165852.30089-19-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165852.30089-1-kabel@kernel.org>
References: <20220504165852.30089-1-kabel@kernel.org>
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

commit 0c36ab437e1d94b6628b006a1d48f05ea3b0b222 upstream.

This function is now always used in driver remove method, drop the
__maybe_unused attribute.

Link: https://lore.kernel.org/r/20220110015018.26359-22-kabel@kernel.org
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 955ce7ef0407..3cbaffe892a4 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1603,7 +1603,7 @@ static int advk_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 		return of_irq_parse_and_map_pci(dev, slot, pin);
 }
 
-static void __maybe_unused advk_pcie_disable_phy(struct advk_pcie *pcie)
+static void advk_pcie_disable_phy(struct advk_pcie *pcie)
 {
 	phy_power_off(pcie->phy);
 	phy_exit(pcie->phy);
-- 
2.35.1

