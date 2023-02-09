Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D921690738
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjBILZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjBILZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:25:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259B85D3DD;
        Thu,  9 Feb 2023 03:19:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98949B8210A;
        Thu,  9 Feb 2023 11:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BBAC4339B;
        Thu,  9 Feb 2023 11:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941559;
        bh=eYVsuz7yIS4jkNG98M87pZNda/oClfDzRcrDjEc1DpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLP1x7jVNS3GBsVavhOE9LQ8CBd5qJ4LDcMI3HRne8NWcJtaORs2NwBqhKW91flFE
         vCC4va1FQeErZyikFdRZaH+I3t2/xZKQvTWyy49pWvg6Bl54b8G/M1AOA3VAdTIUHV
         ykVGtsbpYsqtbIg3H9dGVKFvlgZcP9MJOSNT9n6kFLmrnu39mlXAWa1NtPuGJkJlzA
         TMmwmf5UkI348tFTs29ATDRvyoc6NGYnyk6BF8RcMjDrtLBtDQLh5AIrxBSVnlKzOk
         p9P1C1T675xfb4F54lskQg+XfMPb97zCjcnwzr289jGIoiUjiZ841bcK2FXZPfR+RL
         ZUaNdeUujerSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/13] platform/x86: touchscreen_dmi: Add Chuwi Vi8 (CWI501) DMI match
Date:   Thu,  9 Feb 2023 06:18:31 -0500
Message-Id: <20230209111833.1892896-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111833.1892896-1-sashal@kernel.org>
References: <20230209111833.1892896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index bc26acace2c30..b96fbc8dba09d 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1030,6 +1030,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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

