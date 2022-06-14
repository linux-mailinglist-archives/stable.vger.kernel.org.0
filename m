Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55F854A504
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352984AbiFNCLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiFNCLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:11:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA943466F;
        Mon, 13 Jun 2022 19:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83F4AB8169A;
        Tue, 14 Jun 2022 02:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75874C34114;
        Tue, 14 Jun 2022 02:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172423;
        bh=QDZWRKLomtgTCOUp44KOpz7Tt4UYzs/H9LN7NegqbCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bi40EH3C+uQF65QH75T+pnTy5+x+xli3T9p1GPQhwN1EYUgiIjg5yJY0x73nW+CD6
         zgCqNEOf4dBmeTrrkAM9ADWtJ9DcYDAQ+LHh6o235RPEh8MDoFLwN0/mShNqBUJyaI
         /VSqTIOEkLdDJY8URtrGmF+1p+blXcFq+2ne/Bj5jDusPhci0JoMlsuz4ITU1FWKI+
         ZftnYq5ZdpDUfmm0EQlQU4hbvMgVR268dtMkSV+Uje1G6gUZvzH8CzBLn3hbVwzPnV
         OiO4r84D72bTjNC0LrQH9mJskqAg3xJv3Ul/62wiDeAfC82wTb1AmnBF4Btxd/ky62
         sK3BGeFc0ppxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Piotr Chmura <chmooreck@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dvhart@infradead.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 41/43] platform/x86: gigabyte-wmi: Add Z690M AORUS ELITE AX DDR4 support
Date:   Mon, 13 Jun 2022 22:06:00 -0400
Message-Id: <20220614020602.1098943-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020602.1098943-1-sashal@kernel.org>
References: <20220614020602.1098943-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Piotr Chmura <chmooreck@gmail.com>

[ Upstream commit 8a041afe3e774bedd3e0a9b96f65e48a1299a595 ]

Add dmi_system_id of Gigabyte Z690M AORUS ELITE AX DDR4 board.
Tested on my PC.

Signed-off-by: Piotr Chmura <chmooreck@gmail.com>
Link: https://lore.kernel.org/r/bd83567e-ebf5-0b31-074b-5f6dc7f7c147@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 658bab4b7964..ad4f789309d6 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -153,6 +153,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 I AORUS PRO WIFI"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 UD"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z690M AORUS ELITE AX DDR4"),
 	{ }
 };
 
-- 
2.35.1

