Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEFF551CCB
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343837AbiFTNYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345317AbiFTNXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:23:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0751183F;
        Mon, 20 Jun 2022 06:09:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1294CE139B;
        Mon, 20 Jun 2022 13:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03FFC3411B;
        Mon, 20 Jun 2022 13:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730504;
        bh=QDZWRKLomtgTCOUp44KOpz7Tt4UYzs/H9LN7NegqbCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+lEu7yEALWWHEokvmL2eGV705QCBRJq5fJ7I9kOxRRMdGJSJZk6NnRcqPHIjNgRF
         54QEBSpyc05zFIp4hL1sQ6kRcgakco23oTpHD8dWDzllHT0NhH0nWfycR5zGMCXvuJ
         d1XsrvqcFl8Q4s8U1He9MCBmdo6D/nbBsg5YVlko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Chmura <chmooreck@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/106] platform/x86: gigabyte-wmi: Add Z690M AORUS ELITE AX DDR4 support
Date:   Mon, 20 Jun 2022 14:51:00 +0200
Message-Id: <20220620124725.603053646@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



