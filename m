Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC265B48F8
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiIJVQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiIJVQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:16:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E593B47B88;
        Sat, 10 Sep 2022 14:16:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90EDEB8091F;
        Sat, 10 Sep 2022 21:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57097C433D6;
        Sat, 10 Sep 2022 21:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844586;
        bh=Yhh4HinMSFzDEq0UIYyxqbae+osLFMVeT3vElBCYf0Q=;
        h=From:To:Cc:Subject:Date:From;
        b=LGtwPdBXx/Lxt4bTocuLKhQUdUzhz1UjQBeMtCRJ+sTZT8yOSgmNwNiX7a7Q7nb7j
         olOvDkffQGxKkLTM02343hxCrGDiaCIFVLtNAIVPk8utKZ6aAh8P/1XR1VNGtsbYb2
         Nmnha+DbrVjSdTCyWxnZrxHdi9pml841xliDJfgHdJiOhws3PmtmjyjuOvDGk8KdV2
         8ykPlbhYoBEJpwtFZjBjbVK4qSwEQifLYZg8qvI+V7mSzTMZKSAwNSi3Pw8lqdnFzo
         hWvdfpSInYqpY5pfZPhlLQw51vb71YUMiDg4andwQItF4is5+jkH7qhL1M3NMFN+yF
         11cSz2AUC54OA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Jirman <megi@xff.cz>, Jarrah Gosbell <kernel@undef.tools>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, hadess@hadess.net,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 01/38] Input: goodix - add support for GT1158
Date:   Sat, 10 Sep 2022 17:15:46 -0400
Message-Id: <20220910211623.69825-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Ondrej Jirman <megi@xff.cz>

[ Upstream commit 425fe4709c76e35f93f4c0e50240f0b61b2a2e54 ]

This controller is used by PinePhone and PinePhone Pro. Support for
the PinePhone Pro will be added in a later patch set.

Signed-off-by: Ondrej Jirman <megi@xff.cz>
Signed-off-by: Jarrah Gosbell <kernel@undef.tools>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220809091200.290492-1-kernel@undef.tools
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index aa45a9fee6a01..06d4fcafb7666 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -95,6 +95,7 @@ static const struct goodix_chip_data gt9x_chip_data = {
 
 static const struct goodix_chip_id goodix_chip_ids[] = {
 	{ .id = "1151", .data = &gt1x_chip_data },
+	{ .id = "1158", .data = &gt1x_chip_data },
 	{ .id = "5663", .data = &gt1x_chip_data },
 	{ .id = "5688", .data = &gt1x_chip_data },
 	{ .id = "917S", .data = &gt1x_chip_data },
-- 
2.35.1

