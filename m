Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305CD4FCB23
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347091AbiDLBDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345029AbiDLA60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:58:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038F12C13D;
        Mon, 11 Apr 2022 17:50:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B500AB815C8;
        Tue, 12 Apr 2022 00:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECEAC385A4;
        Tue, 12 Apr 2022 00:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724626;
        bh=7/b/UtY2wvhVRWF0DbJMQbdrQkzYvWZEV6Tz/mEOxss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSvvQ37V4HOoHJywOKYptictL6Q6T/aWpPl6dthAHOMz7dqZtB1QINoun8Xjvct7X
         At32sRCsege+guIsgHNv4lU/K4VGgKAjjVBVxFOVk3S71ANGptHXqWr/OBaqA9u2iI
         2vDNMki1/nDsh+2QYgCHsX3C7uJBQxBIb9NkEn+450cwcwMaXsVj5pVkskooCLl92D
         gQ+sbp3wTw+PBMK7l7y0hXkTEH3VYK75bDsO+q0x5qlRMlrR6a/2w/MxB2k34qJGW5
         fcemACJPBtdb+HNdbAI1TtixlPC7S3MxL84Wj0/I3k0WxD2M14SRrjM8GnOWEyCJVw
         RcdKOI2X+VG0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Galakhov <agalakhov@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        john.garry@huawei.com, bvanassche@acm.org, yanaijie@huawei.com,
        hare@suse.de, yang.guang5@zte.com.cn, thunder.leizhen@huawei.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/30] scsi: mvsas: Add PCI ID of RocketRaid 2640
Date:   Mon, 11 Apr 2022 20:49:00 -0400
Message-Id: <20220412004906.350678-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004906.350678-1-sashal@kernel.org>
References: <20220412004906.350678-1-sashal@kernel.org>
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
index b03c0f35d7b0..0163a682a049 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -646,6 +646,7 @@ static struct pci_device_id mvs_pci_table[] = {
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
 	{ PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },
+	{ PCI_VDEVICE(TTI, 0x2640), chip_6440 },
 	{ PCI_VDEVICE(TTI, 0x2710), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2720), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2721), chip_9480 },
-- 
2.35.1

