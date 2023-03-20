Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F3C6C08AE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjCTBmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCTBmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:42:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E26A59DB;
        Sun, 19 Mar 2023 18:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 965B3611E1;
        Mon, 20 Mar 2023 00:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5665FC4339B;
        Mon, 20 Mar 2023 00:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273819;
        bh=DU88Tx7IDZFMgSmR12ipeKxhrIxiH9XLYaW7YR7z40A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGcgko74zF2lma5Pfr0SfIcaDdmv5r62AhoWHVeOsQtbjcltNihUgPTZcd0yCk/Lp
         1Bo7Tm97cIRE/yzVw/A1fM1shmfJwFK5FC+VUDpPYjtauqrYJUdsvGk8yzMbBZZdAF
         0KNXGAfqFbOIyA4aSKcM5ro3NDUbLbcsXjloL0StbjPoZJBj8ARLm1I71V+awjf/qc
         6QQUw+CI1pxVqPqjo96JQiIJZ0KvhG4zqVTw5KlGfC+35jTL1JkFwm3y6ceIhAlbkW
         0e1JzhKskpV5mUF6ABxzfw7VGaZfilzkHsjcDDgKV29c0LR7dgBJlJ3H7J/XoLXIrC
         hpyayKyUqVBoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/12] platform/x86: ISST: Increase range of valid mail box commands
Date:   Sun, 19 Mar 2023 20:56:32 -0400
Message-Id: <20230320005636.1429242-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005636.1429242-1-sashal@kernel.org>
References: <20230320005636.1429242-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 95ecf90158522269749f1b7ce98b1eed66ca087b ]

A new command CONFIG_TDP_GET_RATIO_INFO is added, with sub command type
of 0x0C. The previous range of valid sub commands was from 0x00 to 0x0B.
Change the valid range from 0x00 to 0x0C.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20230227053504.2734214-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_speed_select_if/isst_if_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_speed_select_if/isst_if_common.c b/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
index cf7b6dee82191..13735d7ae6387 100644
--- a/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
@@ -47,7 +47,7 @@ struct isst_cmd_set_req_type {
 
 static const struct isst_valid_cmd_ranges isst_valid_cmds[] = {
 	{0xD0, 0x00, 0x03},
-	{0x7F, 0x00, 0x0B},
+	{0x7F, 0x00, 0x0C},
 	{0x7F, 0x10, 0x12},
 	{0x7F, 0x20, 0x23},
 };
-- 
2.39.2

