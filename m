Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CFD603F44
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiJSJbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJSJ2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:28:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75A0E8A8F;
        Wed, 19 Oct 2022 02:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D384561824;
        Wed, 19 Oct 2022 09:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6084C433D6;
        Wed, 19 Oct 2022 09:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170658;
        bh=T//Mq0MV/vPrzN/kQ3SK6QnEFdooxLJ2GbtjTJnDnIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBePdchYV/b/PeI4K4XnG7oxGKRFvIKZSutqii3q8Zoed/2DmzbuhezRbHU77yu+M
         587HUr9O85ebxiw34JFHsUmh8uvVj3P/wV/OQ24yFOortiU4NoiWNr4+hyBpe0Ir07
         xLr4fcvrGluZYnLiIr/7RMOOPnF7q0CsCXGsJkCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 737/862] platform/x86: pmc_atom: Improve quirk message to be less cryptic
Date:   Wed, 19 Oct 2022 10:33:44 +0200
Message-Id: <20221019083322.521820393@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



