Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA048608940
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbiJVIcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbiJVIa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:30:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7F62E5330;
        Sat, 22 Oct 2022 01:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A909EB82E37;
        Sat, 22 Oct 2022 08:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1220EC433D6;
        Sat, 22 Oct 2022 08:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425752;
        bh=T//Mq0MV/vPrzN/kQ3SK6QnEFdooxLJ2GbtjTJnDnIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SH3oIMEmoLZZm8x0nfu9Tn7ujKk42o3ctivF5T/TKKZmRRAyuo5ejX1bEOfGnl3g4
         A4Yz1ozO1cXlQuGwkktihA9/AADzCmr6VSPLen+Bl97HnQ0xC9JyLdGE0aA4oP6vxS
         hUF8dMOlG4veknDIkzhi7XHzCv6W833OQK2W+MJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 605/717] platform/x86: pmc_atom: Improve quirk message to be less cryptic
Date:   Sat, 22 Oct 2022 09:28:04 +0200
Message-Id: <20221022072525.223941607@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 32c9b75640aeb1b144f9e2963c1640f4cef7c6f2 ]

Not everyone can get what "critclks" means in the message, improve
it to make less cryptic.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220801113734.36131-2-andriy.shevchenko@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/pmc_atom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
index 5c757c7f64de..f4046572a9fe 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -354,7 +354,7 @@ static bool pmc_clk_is_critical = true;
 
 static int dmi_callback(const struct dmi_system_id *d)
 {
-	pr_info("%s critclks quirk enabled\n", d->ident);
+	pr_info("%s: PMC critical clocks quirk enabled\n", d->ident);
 
 	return 1;
 }
-- 
2.35.1



