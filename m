Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2185F99A0
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiJJHOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiJJHNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:13:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5B05A2C0;
        Mon, 10 Oct 2022 00:08:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D246160E33;
        Mon, 10 Oct 2022 07:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69BDC433D6;
        Mon, 10 Oct 2022 07:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385673;
        bh=FwbwQPKFTF3a8L2qY0gfAa0I4GeaFvNfWc6aR5w3SX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Db1NuTQctZJXfvcKnG5q3TwNamgdzsiaMItNlhWZqr18xwu7V2fgFjCah5lJtU8T5
         VRhi7RxeWaSE+X85cVDmb/ydtdLqo71kZRuZ75RpLUqvyQok4StZDfLXhZvEi3GUtu
         94wk5qYdzE3TKXRVhOPcI6rsXqxnm4y+/QkVGyvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/37] net: marvell: prestera: add support for for Aldrin2
Date:   Mon, 10 Oct 2022 09:05:37 +0200
Message-Id: <20221010070331.753892913@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
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

From: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

[ Upstream commit 9124dbcc2dd6c51e81f97f63f7807118c4eb140a ]

Aldrin2 (98DX8525) is a Marvell Prestera PP, with 100G support.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

V2:
  - retarget to net tree instead of net-next;
  - fix missed colon in patch subject ('net marvell' vs 'net: mavell');
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index a250d394da38..a8d7b889ebee 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -815,6 +815,7 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 static const struct pci_device_id prestera_pci_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xCC1E) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
-- 
2.35.1



