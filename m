Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14655413F6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359167AbiFGUJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359080AbiFGUIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:08:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB09F1C4B28;
        Tue,  7 Jun 2022 11:26:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B4D961295;
        Tue,  7 Jun 2022 18:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69899C385A2;
        Tue,  7 Jun 2022 18:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626367;
        bh=voKeWoxAo4WPTzbvPo2ODXGQq48NrtB6KBr1akkVLNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5RayMQfdakeSq8RRFWqR/XhIISyG/kJqtk7APeY3X56zZXymeBvv9gPymbxae6Jm
         zWVqL6sJjfz1T/pwM/UpvcG4Bv26t+cGb4zzdUDtgU9Z7Umuo0druH9jm8dZQCTPJN
         ADManghmSnlITZ+F8yNXhjqotv1Ii4UeQtDR+t88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 354/772] HID: amd_sfh: Modify the bus name
Date:   Tue,  7 Jun 2022 18:59:06 +0200
Message-Id: <20220607164959.450926813@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 206c3c2d85de8847fb732a5fb71443bacd287216 ]

Modifying the amd-sfh bus name to meaningful name.

Fixes: 4b2c53d93a4b ("SFH:Transport Driver to add support of AMD Sensor Fusion Hub (SFH)")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_hid.c | 2 +-
 drivers/hid/amd-sfh-hid/amd_sfh_hid.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_hid.c b/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
index 2bf97b6ac973..6e487e41f4dd 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
@@ -141,7 +141,7 @@ int amdtp_hid_probe(u32 cur_hid_dev, struct amdtp_cl_data *cli_data)
 
 	hid->driver_data = hid_data;
 	cli_data->hid_sensor_hubs[cur_hid_dev] = hid;
-	hid->bus = BUS_AMD_AMDTP;
+	hid->bus = BUS_AMD_SFH;
 	hid->vendor = AMD_SFH_HID_VENDOR;
 	hid->product = AMD_SFH_HID_PRODUCT;
 	snprintf(hid->name, sizeof(hid->name), "%s %04X:%04X", "hid-amdtp",
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_hid.h b/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
index c60abd38054c..cb04f47c8648 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
@@ -12,7 +12,7 @@
 #define AMDSFH_HID_H
 
 #define MAX_HID_DEVICES		5
-#define BUS_AMD_AMDTP		0x20
+#define BUS_AMD_SFH		0x20
 #define AMD_SFH_HID_VENDOR	0x1022
 #define AMD_SFH_HID_PRODUCT	0x0001
 
-- 
2.35.1



