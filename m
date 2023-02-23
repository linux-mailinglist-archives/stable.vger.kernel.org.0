Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94616A09DC
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbjBWNKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234400AbjBWNKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:10:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B994FC9B
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5C5D4CE2020
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B191C433EF;
        Thu, 23 Feb 2023 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157818;
        bh=lmLKNPRH2/15Cdl7QSCHNrM1RC82Fnt/4vlZc6Vr3D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fqt2iANLP7UMQLMbZ92ynVRmasH8QzoxKn6YsmTlhuO0ao9PwK+hIoK6BTRmZwzZJ
         /soTjO4RAL7otcaDPPqzhGonLTLZsmCk7TRMW02H1HvRjL7kCOgb0H8IaTAyLu0Q1i
         nDgW7OlaSX8T7tD6AG2DZaaR6K79fRJmGo0UWfII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lukas Wunner <lukas@wunner.de>,
        Matt Ranostay <mranostay@ti.com>, Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.1 41/46] wifi: mwifiex: Add missing compatible string for SD8787
Date:   Thu, 23 Feb 2023 14:06:48 +0100
Message-Id: <20230223130433.510864234@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 36dd7a4c6226133b0b7aa92b8e604e688d958d0c upstream.

Commit e3fffc1f0b47 ("devicetree: document new marvell-8xxx and
pwrseq-sd8787 options") documented a compatible string for SD8787 in
the devicetree bindings, but neglected to add it to the mwifiex driver.

Fixes: e3fffc1f0b47 ("devicetree: document new marvell-8xxx and pwrseq-sd8787 options")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v4.11+
Cc: Matt Ranostay <mranostay@ti.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/320de5005ff3b8fd76be2d2b859fd021689c3681.1674827105.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -480,6 +480,7 @@ static struct memory_type_mapping mem_ty
 };
 
 static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
 	{ }


