Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E39F681069
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237037AbjA3ODV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbjA3ODD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:03:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE887EB62
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:02:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78C02B80E70
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D361C433EF;
        Mon, 30 Jan 2023 14:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087377;
        bh=R/Kjb4ZXSeF2C4HNIzIgC5BNI0tQG0DW+T6TS+0qdzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaLdMdbEcIoyOxf8wrCFEb+8JVsXeUiT9N30UTNQEqddWOvG+NcPCoLWeeZ2usOA2
         3XqGTmzppmRhdh32P7GwwjG8sCCOfCdE+9vB6Oto8kuWaakV2+fVcr0d19krPxbox1
         +gDmuOGYe9BOI0jMvEpN3hLpIZD0Dw6jXcvkXWjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Henning Schild <henning.schild@siemens.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/313] platform/x86: simatic-ipc: correct name of a model
Date:   Mon, 30 Jan 2023 14:50:22 +0100
Message-Id: <20230130134345.412190863@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henning Schild <henning.schild@siemens.com>

[ Upstream commit ed058eab22d64c00663563e8e1e112989c65c59f ]

What we called IPC427G should be renamed to BX-39A to be more in line
with the actual product name.

Signed-off-by: Henning Schild <henning.schild@siemens.com>
Link: https://lore.kernel.org/r/20221222103720.8546-2-henning.schild@siemens.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/simatic-ipc.c            | 2 +-
 include/linux/platform_data/x86/simatic-ipc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/simatic-ipc.c b/drivers/platform/x86/simatic-ipc.c
index ca76076fc706..2ab1f8da32b0 100644
--- a/drivers/platform/x86/simatic-ipc.c
+++ b/drivers/platform/x86/simatic-ipc.c
@@ -46,7 +46,7 @@ static struct {
 	{SIMATIC_IPC_IPC427D, SIMATIC_IPC_DEVICE_427E, SIMATIC_IPC_DEVICE_NONE},
 	{SIMATIC_IPC_IPC427E, SIMATIC_IPC_DEVICE_427E, SIMATIC_IPC_DEVICE_427E},
 	{SIMATIC_IPC_IPC477E, SIMATIC_IPC_DEVICE_NONE, SIMATIC_IPC_DEVICE_427E},
-	{SIMATIC_IPC_IPC427G, SIMATIC_IPC_DEVICE_227G, SIMATIC_IPC_DEVICE_227G},
+	{SIMATIC_IPC_IPCBX_39A, SIMATIC_IPC_DEVICE_227G, SIMATIC_IPC_DEVICE_227G},
 };
 
 static int register_platform_devices(u32 station_id)
diff --git a/include/linux/platform_data/x86/simatic-ipc.h b/include/linux/platform_data/x86/simatic-ipc.h
index 632320ec8f08..a4a6cba412cb 100644
--- a/include/linux/platform_data/x86/simatic-ipc.h
+++ b/include/linux/platform_data/x86/simatic-ipc.h
@@ -32,7 +32,7 @@ enum simatic_ipc_station_ids {
 	SIMATIC_IPC_IPC477E = 0x00000A02,
 	SIMATIC_IPC_IPC127E = 0x00000D01,
 	SIMATIC_IPC_IPC227G = 0x00000F01,
-	SIMATIC_IPC_IPC427G = 0x00001001,
+	SIMATIC_IPC_IPCBX_39A = 0x00001001,
 };
 
 static inline u32 simatic_ipc_get_station_id(u8 *data, int max_len)
-- 
2.39.0



