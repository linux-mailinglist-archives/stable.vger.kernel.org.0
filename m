Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8CD683011
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjAaPAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbjAaO7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 09:59:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CFA12F14;
        Tue, 31 Jan 2023 06:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 551066155A;
        Tue, 31 Jan 2023 14:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2636C433EF;
        Tue, 31 Jan 2023 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177189;
        bh=avgIJFoAwkVyXw+pmuHPyUQL4/YLW9nDIp6h6euGxg8=;
        h=From:To:Cc:Subject:Date:From;
        b=UivCP61bV6rgGaNkjexinG1ZNf3njFV1J5iAUvxVnpDSQvLflB827Ja43v3wR41oz
         gvVhZjBjCpZIt7tW89F6pg0pflywVYVjA9B0rLZjuIIULi6EpgYkwfaXKXwgT2RcHR
         /AaWe8Hgg34BSrCHFatj6qMgBGEZgktQxw+cIv+MyiPvRk0Z5TUxiz3+swrkHz0XY6
         ZCwk5V3insS80p0ThHLIj+NPaioZzaVjJSxf/MZIHEF5S7bSuoQcxjHB0tIgZK3nEN
         RAE6HNwHGCbALuEyK/Atw+zsV9nhVt8DG457jpMfgMBKrLTQgtetSWhuCbDaqZsUBe
         25ufjY+trmcuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Sanath S <Sanath.S@amd.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 01/20] i2c: designware-pci: Add new PCI IDs for AMD NAVI GPU
Date:   Tue, 31 Jan 2023 09:59:27 -0500
Message-Id: <20230131145946.1249850-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 2ece0930ac5662bccce0ba4c59b84c98d2437200 ]

Add additional supported PCI IDs for latest AMD NAVI GPU card which
has an integrated Type-C controller and designware I2C with PCI
interface.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Tested-by: Sanath S <Sanath.S@amd.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index e499f96506c5..782fe1ef3ca1 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -396,6 +396,8 @@ static const struct pci_device_id i2_designware_pci_ids[] = {
 	{ PCI_VDEVICE(ATI,  0x73a4), navi_amd },
 	{ PCI_VDEVICE(ATI,  0x73e4), navi_amd },
 	{ PCI_VDEVICE(ATI,  0x73c4), navi_amd },
+	{ PCI_VDEVICE(ATI,  0x7444), navi_amd },
+	{ PCI_VDEVICE(ATI,  0x7464), navi_amd },
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, i2_designware_pci_ids);
-- 
2.39.0

