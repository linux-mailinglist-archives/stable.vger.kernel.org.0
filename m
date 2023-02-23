Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2506A09F5
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbjBWNLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbjBWNLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:11:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A55570B6
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:11:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BFE2B81A25
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB2BC4339B;
        Thu, 23 Feb 2023 13:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157870;
        bh=uVog4+eLQsf9qeofd22iYzE0CERGuqS/2mxtMUTXyYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsAf8YID2ta+2l2GdG9cMT9uf+fgwMCxnhMIjWhZ2HLwHt1+Q7wbhyitYlTptbMF7
         HAj9Fw18oQaxc4V+Dpfpx0ksMarlPPpF5pbfC1fFaEJnkeLqul03yLhZuRtLA1dVSP
         MMuqaF/d9nyjdppw9cDD7yqCBYSbBYCiMGXqYIf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lukas Wunner <lukas@wunner.de>,
        Matt Ranostay <mranostay@ti.com>, Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.4 16/18] wifi: mwifiex: Add missing compatible string for SD8787
Date:   Thu, 23 Feb 2023 14:07:01 +0100
Message-Id: <20230223130426.298798258@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130425.680784802@linuxfoundation.org>
References: <20230223130425.680784802@linuxfoundation.org>
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
@@ -58,6 +58,7 @@ static struct memory_type_mapping mem_ty
 };
 
 static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
 	{ }


