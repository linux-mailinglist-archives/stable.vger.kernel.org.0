Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0628354904A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354423AbiFMMzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357794AbiFMMyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:54:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47B13465E;
        Mon, 13 Jun 2022 04:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69C9760B6E;
        Mon, 13 Jun 2022 11:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A044C3411C;
        Mon, 13 Jun 2022 11:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118801;
        bh=plVLEt9OaQUGl7w2Xcl9A2bkuGQT8eMPuXEdMYK+rY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9iPw+jeOnkPNERMUoKwnNal1Xstc5h1dYm0+U5Ypzyzxr5Ob0qxvSjQcN4toN3Cl
         kJYnZBRHN0WcoMLFrOpViQTuwdy+Zk0gc1KL5otgGUftXwUHpJoGk70G1YjNzgP9E4
         9/sWHiqPd0Pmcpmxq1VY9XHjLIF5w4HJB/7XF1D8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mihai Carabas <mihai.carabas@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/247] pvpanic: Fix typos in the comments
Date:   Mon, 13 Jun 2022 12:08:55 +0200
Message-Id: <20220613094923.940994903@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit cc5b392d0f94f27743583140d819fa35a46899db ]

Fix a few spelling typos in the comments.

Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210829124354.81653-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pvpanic/pvpanic-mmio.c | 2 +-
 drivers/misc/pvpanic/pvpanic.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/pvpanic/pvpanic-mmio.c b/drivers/misc/pvpanic/pvpanic-mmio.c
index be4016084979..61dbff5f0065 100644
--- a/drivers/misc/pvpanic/pvpanic-mmio.c
+++ b/drivers/misc/pvpanic/pvpanic-mmio.c
@@ -100,7 +100,7 @@ static int pvpanic_mmio_probe(struct platform_device *pdev)
 	pi->base = base;
 	pi->capability = PVPANIC_PANICKED | PVPANIC_CRASH_LOADED;
 
-	/* initlize capability by RDPT */
+	/* initialize capability by RDPT */
 	pi->capability &= ioread8(base);
 	pi->events = pi->capability;
 
diff --git a/drivers/misc/pvpanic/pvpanic.c b/drivers/misc/pvpanic/pvpanic.c
index bb7aa6368538..700d7d02c800 100644
--- a/drivers/misc/pvpanic/pvpanic.c
+++ b/drivers/misc/pvpanic/pvpanic.c
@@ -58,7 +58,7 @@ pvpanic_panic_notify(struct notifier_block *nb, unsigned long code,
 
 static struct notifier_block pvpanic_panic_nb = {
 	.notifier_call = pvpanic_panic_notify,
-	.priority = 1, /* let this called before broken drm_fb_helper */
+	.priority = 1, /* let this called before broken drm_fb_helper() */
 };
 
 static void pvpanic_remove(void *param)
-- 
2.35.1



