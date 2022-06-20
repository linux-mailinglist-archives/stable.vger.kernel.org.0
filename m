Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598EF551A26
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242711AbiFTM5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243273AbiFTM5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:57:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402B31AD84;
        Mon, 20 Jun 2022 05:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9D7FB811B8;
        Mon, 20 Jun 2022 12:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DFFC341C5;
        Mon, 20 Jun 2022 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729708;
        bh=auP6D/jWIaQ/Z7xaV4u7K4m5SlM2yD1KPaGjIjeAf0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTchcy8KvziMVJ5g+TSTGmtjsOolLP2tRity82AnU+aVkezK+19IXEg/iMiFYbvh9
         +qTIkihebTsc2V13FVsV6MgIcEmqXu1BvdFc828LazqOdnLZHIrT8GctmzKQR8fzUn
         7rwXjyGo4tImgWKI3Y7A0BQ+QXqQmnvaHs0+BeHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Chmura <chmooreck@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 049/141] platform/x86: gigabyte-wmi: Add Z690M AORUS ELITE AX DDR4 support
Date:   Mon, 20 Jun 2022 14:49:47 +0200
Message-Id: <20220620124730.984139414@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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
index e87a931eab1e..05588a47ac38 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -154,6 +154,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 I AORUS PRO WIFI"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 UD"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z690M AORUS ELITE AX DDR4"),
 	{ }
 };
 
-- 
2.35.1



