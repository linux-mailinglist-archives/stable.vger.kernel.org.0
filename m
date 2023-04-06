Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF87C6D95E5
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbjDFLig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237725AbjDFLiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:38:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1369EEA;
        Thu,  6 Apr 2023 04:35:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E57064310;
        Thu,  6 Apr 2023 11:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0014EC433EF;
        Thu,  6 Apr 2023 11:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780794;
        bh=ZwUs0C8f92E4m8Pbn3DijvNh+WuhjIMkgNjfhSREa1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgIrsiCcVRR4N3YUHJYTxKJY47eSIhc0XH79zsIbuAXbPcVCCUzPc0CQiaGjMXzzL
         XhRKp2k40+E9UdAM2ElHTuBlyVKjl99OhcYSCCbEWBp+TGRMW1L6pcrvz3+ybBab4H
         OAOWwnVx7lMurB9tMjQKoboaCAYLRuDCCV7b6OHBKrbyYOsNABIUr6XLkYOGoK+Yz/
         hEsAUnwr79bygp1t+ml0qtN/S1rurW3JD5Yt/WrU+FWLn5iGOkBnfxfDyhyu6/5OXH
         q8v0HEIfUu0+qQ3K6VJ+h8x2XYnk1WdxkdPP0J/TNfWC+fN0PZ9VpJz41jagflGvsU
         wSXSF+SZKbIoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Brandon Nielsen <nielsenb@jetfuse.net>,
        Sasha Levin <sashal@kernel.org>, thomas@weissschuh.net,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/11] platform/x86: gigabyte-wmi: add support for X570S AORUS ELITE
Date:   Thu,  6 Apr 2023 07:32:50 -0400
Message-Id: <20230406113250.648634-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113250.648634-1-sashal@kernel.org>
References: <20230406113250.648634-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index aea4f3144b68f..bf1b98dd00b99 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -156,6 +156,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 I AORUS PRO WIFI"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 UD"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570S AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z690M AORUS ELITE AX DDR4"),
 	{ }
 };
-- 
2.39.2

