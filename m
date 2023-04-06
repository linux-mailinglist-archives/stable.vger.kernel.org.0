Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3BF6D954B
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbjDFLc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237905AbjDFLcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:32:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6509EDD;
        Thu,  6 Apr 2023 04:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B086064668;
        Thu,  6 Apr 2023 11:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF5EC433A0;
        Thu,  6 Apr 2023 11:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780728;
        bh=YimFVwDeaW+TGuGRJmmcI1SbAKhZF5qTQM8vXf4U8XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9BQQsFoqKB5c2urwuk/08HOm/lnOfAzqFkLSoSINQRs4oADoyAmOldmQaTIsCd1h
         e0/OVyMJBYepCq3dWFX6RokutIAVEEXkaVHmtUlzqT2woh+33uL0aSGl6Kty56wrS9
         xGMwMe4YhpkxPVQiQvDqgqSsfT/rigCVRP1uJF9qIH1BaPPgXPhVWVKqorm4IN6cxE
         5a+dHrwsYHETyy+xJFb1NTI3Xub35OZZ10sOC4PH2tcNcx3CqHBErDNLyxuUpCZNw1
         78BWJgQh3k3JEox/hEJXITf+X92vCW+hiWKVnovqyvOylj1vVLJlLB363jwpLq1sw8
         7DzXnM7dLOu4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Brandon Nielsen <nielsenb@jetfuse.net>,
        Sasha Levin <sashal@kernel.org>, thomas@weissschuh.net,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 15/17] platform/x86: gigabyte-wmi: add support for X570S AORUS ELITE
Date:   Thu,  6 Apr 2023 07:31:29 -0400
Message-Id: <20230406113131.648213-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113131.648213-1-sashal@kernel.org>
References: <20230406113131.648213-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 52f91e51944808d83dfe2d5582601b5e84e472cc ]

Add "X570S AORUS ELITE" to known working boards

Reported-by: Brandon Nielsen <nielsenb@jetfuse.net>
Link: https://lore.kernel.org/r/20230331014902.7864-1-nielsenb@jetfuse.net
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 5e5b17c50eb67..2a426040f749e 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -161,6 +161,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 I AORUS PRO WIFI"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 UD"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570S AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z690M AORUS ELITE AX DDR4"),
 	{ }
 };
-- 
2.39.2

