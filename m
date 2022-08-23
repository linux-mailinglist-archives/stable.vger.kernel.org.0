Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2852759D75F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351041AbiHWJgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351367AbiHWJfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:35:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1119752E;
        Tue, 23 Aug 2022 01:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C575B81C5A;
        Tue, 23 Aug 2022 08:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978CCC433D7;
        Tue, 23 Aug 2022 08:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243930;
        bh=Iu8/f8WauSIfLfX5/UEApQA6RVWbkuQeUJ2KoIzGL7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+f2Zvvibb9kmDwCr7gl8FinRl1HxspFEfGWSb+QApaK9HCGH1x6U4uALKQHQuD0C
         sBVk3GXESrC41AyH5CmvB43OpsoJmpkCcTaf6ZXeZDkOmcuSrHYs0/LY0uiTaB1B+O
         rpVgyaJtUoIeIVcY4dXBYpsHWHI3Tu+E2nU1+Bgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5.15 010/244] ata: libata-eh: Add missing command name
Date:   Tue, 23 Aug 2022 10:22:49 +0200
Message-Id: <20220823080059.433086337@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit d3122bf9aa4c974f5e2c0112f799757b3a2779da upstream.

Add the missing command name for ATA_CMD_NCQ_NON_DATA to
ata_get_cmd_name().

Fixes: 661ce1f0c4a6 ("libata/libsas: Define ATA_CMD_NCQ_NON_DATA")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-eh.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2130,6 +2130,7 @@ const char *ata_get_cmd_descript(u8 comm
 		{ ATA_CMD_WRITE_QUEUED_FUA_EXT, "WRITE DMA QUEUED FUA EXT" },
 		{ ATA_CMD_FPDMA_READ,		"READ FPDMA QUEUED" },
 		{ ATA_CMD_FPDMA_WRITE,		"WRITE FPDMA QUEUED" },
+		{ ATA_CMD_NCQ_NON_DATA,		"NCQ NON-DATA" },
 		{ ATA_CMD_FPDMA_SEND,		"SEND FPDMA QUEUED" },
 		{ ATA_CMD_FPDMA_RECV,		"RECEIVE FPDMA QUEUED" },
 		{ ATA_CMD_PIO_READ,		"READ SECTOR(S)" },


