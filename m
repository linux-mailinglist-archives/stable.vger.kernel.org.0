Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AFF5F993B
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiJJHJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiJJHIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:08:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF8C5AC66;
        Mon, 10 Oct 2022 00:05:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EF2760E74;
        Mon, 10 Oct 2022 07:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461E4C433C1;
        Mon, 10 Oct 2022 07:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385555;
        bh=6pTTRmUAv0wG9o5dh0evjFMOU1DGy3ZXeepzUNql1x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMJtN88zeGarNDN3wZIpcBLHiTDdEiFQyqAINYxZD6tY1UGCYnd/kTcMd0MBeA7ih
         8kcOsGBxlawnsTAQEYXdSj1sO8hCfvn0VZX2K1WrUYYt9XuPOfb902zjkZLJSeJRTx
         JOtPCwudYhQSx4k6vJVt33kD74ZnEyfEDPAotVsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 21/48] net: marvell: prestera: add support for for Aldrin2
Date:   Mon, 10 Oct 2022 09:05:19 +0200
Message-Id: <20221010070334.257091026@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
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
index f538a749ebd4..59470d99f522 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -872,6 +872,7 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 static const struct pci_device_id prestera_pci_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xCC1E) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
-- 
2.35.1



