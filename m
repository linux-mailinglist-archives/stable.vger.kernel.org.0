Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0C869CDA3
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjBTNvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjBTNvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:51:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988581E2AC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:51:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53054B80D44
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A213CC433D2;
        Mon, 20 Feb 2023 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901072;
        bh=naImJaZsiojPbuOfCQcRFmzenQ6rb8bPJhVkAssPUXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XY4xeOgA1TC+gSUdmInrMV7vIt4KxAer56EtB2OnuroYUlRTcW9+gvQPRLmDp4hR0
         5x+9fZXRrDcdwaGxwxs/UW7Ht5KevRg0uTUPYiPVrg3MEu5fa+0BCUQukgNefkNvRa
         NqzgKHZka8lWGsYokoyjGORXxC8rg5VurNiG0epg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/83] platform/x86: touchscreen_dmi: Add Chuwi Vi8 (CWI501) DMI match
Date:   Mon, 20 Feb 2023 14:35:52 +0100
Message-Id: <20230220133554.370648588@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit eecf2acd4a580e9364e5087daf0effca60a240b7 ]

Add a DMI match for the CWI501 version of the Chuwi Vi8 tablet,
pointing to the same chuwi_vi8_data as the existing CWI506 version
DMI match.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230202103413.331459-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 93671037fd598..69ba2c5182610 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1073,6 +1073,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_DATE, "05/07/2016"),
 		},
 	},
+	{
+		/* Chuwi Vi8 (CWI501) */
+		.driver_data = (void *)&chuwi_vi8_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "i86"),
+			DMI_MATCH(DMI_BIOS_VERSION, "CHUWI.W86JLBNR01"),
+		},
+	},
 	{
 		/* Chuwi Vi8 (CWI506) */
 		.driver_data = (void *)&chuwi_vi8_data,
-- 
2.39.0



