Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DF8521961
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243500AbiEJNtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245074AbiEJNrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767ECAAE04;
        Tue, 10 May 2022 06:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D248B81DA2;
        Tue, 10 May 2022 13:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2FFC385C2;
        Tue, 10 May 2022 13:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189693;
        bh=UmASr+hISXnks5NrTZwJxMMFLlbH+sNHHGWZkhNaW6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1YprPar1HfVJGJjLbY2KBr7KepWbSUvyrPM+NpQbovKD3DhaLj20ofgT3jemEvj/
         N8wZZgj3P9+QFTkb2Jedp1kCBb0HfcoF+jXeOUY4hrvZjPGv8tUz8BKkk8Sg945eu+
         KKmBDwPDrIadIAY4tni8KHcAd83tzn2Uq9HGYiRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 134/135] PCI: aardvark: Drop __maybe_unused from advk_pcie_disable_phy()
Date:   Tue, 10 May 2022 15:08:36 +0200
Message-Id: <20220510130744.239141261@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Marek Behún" <kabel@kernel.org>

commit 0c36ab437e1d94b6628b006a1d48f05ea3b0b222 upstream.

This function is now always used in driver remove method, drop the
__maybe_unused attribute.

Link: https://lore.kernel.org/r/20220110015018.26359-22-kabel@kernel.org
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1605,7 +1605,7 @@ static int advk_pcie_map_irq(const struc
 		return of_irq_parse_and_map_pci(dev, slot, pin);
 }
 
-static void __maybe_unused advk_pcie_disable_phy(struct advk_pcie *pcie)
+static void advk_pcie_disable_phy(struct advk_pcie *pcie)
 {
 	phy_power_off(pcie->phy);
 	phy_exit(pcie->phy);


