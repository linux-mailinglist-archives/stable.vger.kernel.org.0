Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1B34FCB1E
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346902AbiDLBDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349796AbiDLA7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:59:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49181275EF;
        Mon, 11 Apr 2022 17:53:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 960B6B80E9B;
        Tue, 12 Apr 2022 00:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB878C385A3;
        Tue, 12 Apr 2022 00:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724784;
        bh=sNno4EtBAliDgozzOpAWH0kapXXQuaF4DBpGUMYbEC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvpOaFoJYLZhKVlDH7PcJ44oKiCaDen6RDwejep7YMORpvIChdwZ4XXRWirkL5Io+
         vR72KPL7td1hkA89J1eQ7Kr1CNCkzj2cjFvW0zEb0tDW/Ewo/ljMU8/cOqSOP3o0GX
         PSwKz1pMbtd4n6ZA9n48tSwgIICuXEXqqhfPTyMGrnzwdefgKhSU4ZixOgIHX5K8W6
         6bBaasRshGqp0YMydicltqB+QvBdbIvFSwSoIOhvMU5+uXdwzjlsHbfL7bAaMRvD28
         nCkSq9VuZR4vzg2mQy1KmRy/jFyK5vii/083/zokT+kJKHogQei867KMZCaerymoCG
         EoVyfmuxk6QEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Galakhov <agalakhov@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        john.garry@huawei.com, bvanassche@acm.org,
        davidcomponentone@gmail.com, johannes.thumshirn@wdc.com,
        yuyufen@huawei.com, thunder.leizhen@huawei.com,
        yang.guang5@zte.com.cn, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 6/7] scsi: mvsas: Add PCI ID of RocketRaid 2640
Date:   Mon, 11 Apr 2022 20:52:47 -0400
Message-Id: <20220412005248.351701-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005248.351701-1-sashal@kernel.org>
References: <20220412005248.351701-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Alexey Galakhov <agalakhov@gmail.com>

[ Upstream commit 5f2bce1e222028dc1c15f130109a17aa654ae6e8 ]

The HighPoint RocketRaid 2640 is a low-cost SAS controller based on Marvell
chip. The chip in question was already supported by the kernel, just the
PCI ID of this particular board was missing.

Link: https://lore.kernel.org/r/20220309212535.402987-1-agalakhov@gmail.com
Signed-off-by: Alexey Galakhov <agalakhov@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvsas/mv_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 8280046fd1f0..b29542b82c8a 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -679,6 +679,7 @@ static struct pci_device_id mvs_pci_table[] = {
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
 	{ PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },
+	{ PCI_VDEVICE(TTI, 0x2640), chip_6440 },
 	{ PCI_VDEVICE(TTI, 0x2710), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2720), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2721), chip_9480 },
-- 
2.35.1

