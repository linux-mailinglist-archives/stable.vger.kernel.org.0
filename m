Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BC15A062B
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiHYBjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbiHYBix (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:38:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFCD9A9E0;
        Wed, 24 Aug 2022 18:37:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 542CFB826E4;
        Thu, 25 Aug 2022 01:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280DAC43141;
        Thu, 25 Aug 2022 01:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391423;
        bh=qaGWRXXdhMgX4uVqbIv+GfrpRRG4U00ealeLwHrPfkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irj7g8+2mslxz33Bcfo47RF61C614TZTjnqZT7FDrjgQ70ht0DyqTnSMC+wppSTHg
         qg7/k55w74XWpdYgY6nc9dzinwbbVR3/eWJkQrBmvBB9RQD/NegQq4UC6uLdz2vxVp
         9JPbWJqeoyz6FjcpjAoANb0eWIck99kDw9IYrq0Ccg/kVyp4AxFT1+iALWNjKO4aux
         h0ueTojk+GesvYPzrQ7iGqMnwieE7FlyNNcUd69RnC7u9GXvILTOgo8D//0VwAnPe4
         K4uabTFmkCAfxSYC1t2tGRmT/sRqcz9pg3DPK0tF35VA+bJXnlZxqgIyASG98rCwXw
         JU7CRcw15X2Hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Tanure <tanureal@opensource.cirrus.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        hdegoede@redhat.com, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 33/38] platform/x86: serial-multi-instantiate: Add CLSA0101 Laptop
Date:   Wed, 24 Aug 2022 21:33:56 -0400
Message-Id: <20220825013401.22096-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
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

From: Lucas Tanure <tanureal@opensource.cirrus.com>

[ Upstream commit 88392a0dd0ab263edb4ca416ebdecabd8289158a ]

The device CLSA0101 has two instances of CS35L41
connected by I2C.

Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220727095924.80884-5-tanureal@opensource.cirrus.com
Link: https://lore.kernel.org/r/20220816194639.13870-1-cam@neo-zeon.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/serial-multi-instantiate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/serial-multi-instantiate.c b/drivers/platform/x86/serial-multi-instantiate.c
index 1e8063b7c169..e98007197cf5 100644
--- a/drivers/platform/x86/serial-multi-instantiate.c
+++ b/drivers/platform/x86/serial-multi-instantiate.c
@@ -329,6 +329,7 @@ static const struct acpi_device_id smi_acpi_ids[] = {
 	{ "CSC3551", (unsigned long)&cs35l41_hda },
 	/* Non-conforming _HID for Cirrus Logic already released */
 	{ "CLSA0100", (unsigned long)&cs35l41_hda },
+	{ "CLSA0101", (unsigned long)&cs35l41_hda },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, smi_acpi_ids);
-- 
2.35.1

