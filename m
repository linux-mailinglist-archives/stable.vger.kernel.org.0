Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63E35219A5
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238867AbiEJNuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245026AbiEJNrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060D462204;
        Tue, 10 May 2022 06:33:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADFCBB81DA2;
        Tue, 10 May 2022 13:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25086C385C2;
        Tue, 10 May 2022 13:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189622;
        bh=DMggDDOU+eaxJXc5upw4OUuvsOsb/HcMaUf15fpdsdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUSfYKACQsJihtwQvQKZzNCieFChRhsv0rikk3pg57SM1g64MqIlyt53KgbKLYko+
         D4L+7jbzEHVbw/1FqPUwnNgudPPB/17yVSIOa5H2VbdRbGIvdUDIgcW6rj9nZ3U7ip
         o4QjP0DwBAzMiQDzdveJ2W22Sze47cU+rxdT/s68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 110/135] PCI: aardvark: Comment actions in driver remove method
Date:   Tue, 10 May 2022 15:08:12 +0200
Message-Id: <20220510130743.561084013@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

commit a4ca7948e1d47275f8f3e5023243440c40561916 upstream.

Add two more comments into the advk_pcie_remove() method.

Link: https://lore.kernel.org/r/20211130172913.9727-6-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1681,11 +1681,13 @@ static int advk_pcie_remove(struct platf
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 	int i;
 
+	/* Remove PCI bus with all devices */
 	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
 	pci_remove_root_bus(bridge->bus);
 	pci_unlock_rescan_remove();
 
+	/* Remove IRQ domains */
 	advk_pcie_remove_msi_irq_domain(pcie);
 	advk_pcie_remove_irq_domain(pcie);
 


