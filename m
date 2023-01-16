Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5351166C13F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjAPOJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjAPOHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:07:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B881227B3;
        Mon, 16 Jan 2023 06:03:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2981B80F91;
        Mon, 16 Jan 2023 14:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF92BC433D2;
        Mon, 16 Jan 2023 14:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877829;
        bh=77KplAP5lL7akWe6eWM7jdiQX+igqDEEes8wVXMiKQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcheukejpYqtZDW5DGVx6a8SvhcW7EnCvi1LzB2x51Wr+LgUl8bJjFtYtPyvcHAtn
         brMuBQP7LDL4xSX1ZxBvsQZMpROWOGW4y0Mw0tMhv5ST2s/vWeR5jP1BID1nvTVUGN
         36c4f12f+H+FLe6q9lLDnWrED51S0P179rgKMOI4BYlDTsuD1i+OeOZTBjCJYac5Rk
         4XAlJkGnBoIHw4k5EUdTn2YYMHv8qaUjiYVPKqazJ3cldPyjBtF3tN50xtcIpySEck
         IwgQEPOAVdE2RLwoQDWZqVZJk5ga9f17NgfU39LSy/pmOu71jijnazEB53WR4NKwTN
         hMj3qT0UFvt/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Henning Schild <henning.schild@siemens.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        andriy.shevchenko@linux.intel.com,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 50/53] platform/x86: simatic-ipc: add another model
Date:   Mon, 16 Jan 2023 09:01:50 -0500
Message-Id: <20230116140154.114951-50-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henning Schild <henning.schild@siemens.com>

[ Upstream commit d348b1d761e358a4ba03fb34aa7e3dbd278db236 ]

Add IPC PX-39A support.

Signed-off-by: Henning Schild <henning.schild@siemens.com>
Link: https://lore.kernel.org/r/20221222103720.8546-3-henning.schild@siemens.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/simatic-ipc.c            | 1 +
 include/linux/platform_data/x86/simatic-ipc.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/platform/x86/simatic-ipc.c b/drivers/platform/x86/simatic-ipc.c
index 2ab1f8da32b0..b3622419cd1a 100644
--- a/drivers/platform/x86/simatic-ipc.c
+++ b/drivers/platform/x86/simatic-ipc.c
@@ -47,6 +47,7 @@ static struct {
 	{SIMATIC_IPC_IPC427E, SIMATIC_IPC_DEVICE_427E, SIMATIC_IPC_DEVICE_427E},
 	{SIMATIC_IPC_IPC477E, SIMATIC_IPC_DEVICE_NONE, SIMATIC_IPC_DEVICE_427E},
 	{SIMATIC_IPC_IPCBX_39A, SIMATIC_IPC_DEVICE_227G, SIMATIC_IPC_DEVICE_227G},
+	{SIMATIC_IPC_IPCPX_39A, SIMATIC_IPC_DEVICE_NONE, SIMATIC_IPC_DEVICE_227G},
 };
 
 static int register_platform_devices(u32 station_id)
diff --git a/include/linux/platform_data/x86/simatic-ipc.h b/include/linux/platform_data/x86/simatic-ipc.h
index a4a6cba412cb..a48bb5240977 100644
--- a/include/linux/platform_data/x86/simatic-ipc.h
+++ b/include/linux/platform_data/x86/simatic-ipc.h
@@ -33,6 +33,7 @@ enum simatic_ipc_station_ids {
 	SIMATIC_IPC_IPC127E = 0x00000D01,
 	SIMATIC_IPC_IPC227G = 0x00000F01,
 	SIMATIC_IPC_IPCBX_39A = 0x00001001,
+	SIMATIC_IPC_IPCPX_39A = 0x00001002,
 };
 
 static inline u32 simatic_ipc_get_station_id(u8 *data, int max_len)
-- 
2.35.1

