Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393046C0749
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjCTA4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjCTA4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:56:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7B1166DE;
        Sun, 19 Mar 2023 17:54:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A844BB80D3F;
        Mon, 20 Mar 2023 00:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F8AC4339B;
        Mon, 20 Mar 2023 00:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273630;
        bh=H1tR2yD4c9ycqm5QTk9a8AHQejQOSN5qo7cZ/Jx6/QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5jwydAvwbOLj/Xj5zunxvUTu5CngriI76NBy0GJ80nUyw0LcO0rJyEovH2amUmYM
         ovJOKYAYxl/5SL2g2LoA+RveGjqY7qWiRufwtuCWQgXWIdBFBC7jbTf0sdVfISmz91
         vojzjpFlP1oLg1zvehGdDMLqyNF5K8FEfOLBiu03sakIBhoUxDoHtbjOgmp9cylX1G
         jMDuLLrof3Vo4LgEJyH8M5NYkHZDfbGkubdbEkoSrL0m8uhK5ViLIz7VbU9SX5lL/U
         iaiVk6cFDeI5skDJJaT8sz1dfuhA/8ccziGF03NjNZGbusiHpfSu7KINCVn4KfG3r8
         eppmcgSzIYZAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 23/30] platform/x86: ISST: Increase range of valid mail box commands
Date:   Sun, 19 Mar 2023 20:52:48 -0400
Message-Id: <20230320005258.1428043-23-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
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
index a7e02b24a87ad..0829e793a8fce 100644
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

