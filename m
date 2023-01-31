Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA7968304A
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbjAaPA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbjAaPAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206084B1B0;
        Tue, 31 Jan 2023 07:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42FCAB81D24;
        Tue, 31 Jan 2023 15:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E96C433A0;
        Tue, 31 Jan 2023 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177213;
        bh=WN5XNCcaUp6nqDzams28+vaOqySgO2F7e2eKuBhrBE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=in/E1p2iaglaubvnBWskqWt8gQlBJrJEKP/KovXal9DBNB2ZWUFNHUzYqj6OImiJX
         CbAuN8yEwxD0j9f9TGPsMw5bfbfqs85xVCMtpRhFYGRyFpd/B8fZf6V+9imxBHhiw9
         Q/E0bMqj9teoPQZytmaxsfIMHMCD85uENuqojBOn+Eoszf0z8aXghrRk/vp341DOql
         wTkvBPsvs+FCiPwsc+Ru1Z8bpfmP/pADNZfsHTDm6IwoRrJ01VJRce/jmJf8YPzPq9
         O3jZHk3VTKXU9L/tvlJw45fVLvub3wtxd0kWjbNYnmnFp1/qtjGA+q0/zQbXq+pRJf
         oqtHGZaPaBWJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Koba Ko <koba.ko@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mjg59@srcf.ucam.org,
        pali@kernel.org, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 13/20] platform/x86: dell-wmi: Add a keymap for KEY_MUTE in type 0x0010 table
Date:   Tue, 31 Jan 2023 09:59:39 -0500
Message-Id: <20230131145946.1249850-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131145946.1249850-1-sashal@kernel.org>
References: <20230131145946.1249850-1-sashal@kernel.org>
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

From: Koba Ko <koba.ko@canonical.com>

[ Upstream commit 83bcf3e52e9cfc727df33f1055ef0618c91719d0 ]

Some platforms send the speaker-mute key from EC. dell-wmi can't
recognize it.

Add a new keymap for KEY_MUTE in type 0x0010 table.

Signed-off-by: Koba Ko <koba.ko@canonical.com>
Link: https://lore.kernel.org/r/20230117123436.200440-1-koba.ko@canonical.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/dell/dell-wmi-base.c b/drivers/platform/x86/dell/dell-wmi-base.c
index 0a259a27459f..502783a7adb1 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -261,6 +261,9 @@ static const struct key_entry dell_wmi_keymap_type_0010[] = {
 	{ KE_KEY,    0x57, { KEY_BRIGHTNESSDOWN } },
 	{ KE_KEY,    0x58, { KEY_BRIGHTNESSUP } },
 
+	/*Speaker Mute*/
+	{ KE_KEY, 0x109, { KEY_MUTE} },
+
 	/* Mic mute */
 	{ KE_KEY, 0x150, { KEY_MICMUTE } },
 
-- 
2.39.0

