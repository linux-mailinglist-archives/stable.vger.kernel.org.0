Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D49615AFC
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiKBDpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiKBDpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:45:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86EC767A
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:45:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93FCAB80DA8
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811E0C433C1;
        Wed,  2 Nov 2022 03:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360727;
        bh=7lVFfXI40poPAwUPCHJ5uQM0xkMFJX0LOVoItrXr1fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9zDF3fLmHOQ84mnFg/8IH2MetAUMj8g4riRhEU1R9C5sDWPJ2klPU3TbfZu+cU83
         m0a84rc9Aj91/eCEUGere9R17ufZLXs4Rzb7P0bAdF1cFUMyjIfh5MN/uF6iWHtex2
         WGiAgN47ZlQyzwAaUUKdmIcbPhXhx055lOWnC1eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Fabio Estevam <festevam@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.9 03/44] ata: ahci-imx: Fix MODULE_ALIAS
Date:   Wed,  2 Nov 2022 03:34:49 +0100
Message-Id: <20221102022049.136790634@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 979556f1521a835a059de3b117b9c6c6642c7d58 upstream.

'ahci:' is an invalid prefix, preventing the module from autoloading.
Fix this by using the 'platform:' prefix and DRV_NAME.

Fixes: 9e54eae23bc9 ("ahci_imx: add ahci sata support on imx platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci_imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -691,4 +691,4 @@ module_platform_driver(imx_ahci_driver);
 MODULE_DESCRIPTION("Freescale i.MX AHCI SATA platform driver");
 MODULE_AUTHOR("Richard Zhu <Hong-Xing.Zhu@freescale.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ahci:imx");
+MODULE_ALIAS("platform:" DRV_NAME);


