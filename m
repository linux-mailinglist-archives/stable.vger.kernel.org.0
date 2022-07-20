Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C8257AC14
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbiGTBQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240822AbiGTBPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:15:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7635D65D60;
        Tue, 19 Jul 2022 18:13:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 525B8B81DC0;
        Wed, 20 Jul 2022 01:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EE2C341CB;
        Wed, 20 Jul 2022 01:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279614;
        bh=JdlRO2cFloSXif2TONmk+shGYjLskPPNgPXa7jGM/m8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7hAYxoF5OhtsL8ckOzra0A9969N2+NXLzf9xSB5b7ApHgTKlm2Qvqaq1Y/IeY7vw
         P1jteHW6YlidUkeEMWTpCedhEYy+M79c9EqWF3xRSEok+L7EocxHmlwgISF6vrT/zj
         QgY/GmweWx6nUGj4Wpu32TjE9dBgfqaaCWKhvvmHe1pxoSm73Y1Safl5teLFYhzaU4
         lAZveDe8C5QN3e3RvjZBLGYsrTCSGHRByWn5EU9byrd0REhq338douyigAYLHGyFE7
         F0DQia05nshqGLUsUPLDi9T+YtzLjx4ohN0MSL/qj7N3nQxOrhdPVMnyJUyhjqoqhw
         AGMcGjNzG+g9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?P=C3=A4r=20Eriksson?= <parherman@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, thomas@weissschuh.net,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 47/54] platform/x86: gigabyte-wmi: add support for B660I AORUS PRO DDR4
Date:   Tue, 19 Jul 2022 21:10:24 -0400
Message-Id: <20220720011031.1023305-47-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pär Eriksson <parherman@gmail.com>

[ Upstream commit 5d62261a65698c1ee4e71f00963b269282015b1e ]

Add support for the B660I AORUS PRO DDR4.

Signed-off-by: Pär Eriksson <parherman@gmail.com>
Link: https://lore.kernel.org/r/20220705184407.14181-1-parherman@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 78446b1953f7..ffe842d3e9f3 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -150,6 +150,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M AORUS PRO-P"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M DS3H"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B660 GAMING X DDR4"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B660I AORUS PRO DDR4"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z390 I AORUS PRO WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
-- 
2.35.1

