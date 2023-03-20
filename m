Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6506C07AE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjCTBAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjCTBAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64812196E;
        Sun, 19 Mar 2023 17:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F326B80D49;
        Mon, 20 Mar 2023 00:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75902C4339E;
        Mon, 20 Mar 2023 00:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273699;
        bh=q6oKTicYSUqNjiy9CZym+1WZwIBDCosXhXY6XGe2MNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZ1D5GF9zJxHP6zCH7mRN0/jsEBOkBXNBn5F2qhdrrfkKfGE30fIfPQF+rpKQZ7sa
         bYYZtiiTvRCLstE1ZVKU0SbeljUbhL2a0QlqspIzCqYu3jMQfPWeQn6yKR47nySa90
         ILFZnD3d4bOzGETpiXocOAUKwA5wBZAjptq/d4vs3NUQwygnxLLYGnZU7N690igW2u
         xyRnbpt5PLCWwuhKff3xB0XttMgypH64/xLWeJQBZw1bLIK9PTvHiW5P0XKyW8yyxZ
         EWuCw0Xx1Ol7Wwf8Ud71pTv3aoydA8XmWnlIpC8M4HXn3gTK3iRAOxFf6QpLIr5C5d
         PsfajiVwexe9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 22/29] platform/x86: ISST: Increase range of valid mail box commands
Date:   Sun, 19 Mar 2023 20:54:04 -0400
Message-Id: <20230320005413.1428452-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005413.1428452-1-sashal@kernel.org>
References: <20230320005413.1428452-1-sashal@kernel.org>
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
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index fd102678c75f6..a1d89f5a44bef 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -47,7 +47,7 @@ struct isst_cmd_set_req_type {
 
 static const struct isst_valid_cmd_ranges isst_valid_cmds[] = {
 	{0xD0, 0x00, 0x03},
-	{0x7F, 0x00, 0x0B},
+	{0x7F, 0x00, 0x0C},
 	{0x7F, 0x10, 0x12},
 	{0x7F, 0x20, 0x23},
 	{0x94, 0x03, 0x03},
-- 
2.39.2

