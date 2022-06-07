Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9947F540B06
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbiFGSWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353041AbiFGSRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44565ED70A;
        Tue,  7 Jun 2022 10:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B246B8236C;
        Tue,  7 Jun 2022 17:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED492C34115;
        Tue,  7 Jun 2022 17:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624377;
        bh=dJRqQxMventHtaB8HhkRjPA3pkLwNwa/wlZDVozbFSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kg7yCi8PCX3XseE6Th+ZjTfMgHMyI8w9VPYtfij7uuj8y7rpjKzM6xg/cT6c414Gh
         mCteKMmFmPQtEHrXer1TblcAbe4pYP8RmjIiPViMqg0d/UOHUVM+N6iUCCqH/IR3nB
         Xu6VxmulxH93IC0a1SxUAYX9lnVhCu9Cepo1AaWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 303/667] HID: amd_sfh: Modify the bus name
Date:   Tue,  7 Jun 2022 18:59:28 +0200
Message-Id: <20220607164943.864862512@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
index 5ad1e7acd294..8b8a7c40ed4e 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
@@ -139,7 +139,7 @@ int amdtp_hid_probe(u32 cur_hid_dev, struct amdtp_cl_data *cli_data)
 
 	hid->driver_data = hid_data;
 	cli_data->hid_sensor_hubs[cur_hid_dev] = hid;
-	hid->bus = BUS_AMD_AMDTP;
+	hid->bus = BUS_AMD_SFH;
 	hid->vendor = AMD_SFH_HID_VENDOR;
 	hid->product = AMD_SFH_HID_PRODUCT;
 	snprintf(hid->name, sizeof(hid->name), "%s %04X:%04X", "hid-amdtp",
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_hid.h b/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
index ae2ac9191ba7..741cff350589 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
@@ -10,7 +10,7 @@
 #define AMDSFH_HID_H
 
 #define MAX_HID_DEVICES		5
-#define BUS_AMD_AMDTP		0x20
+#define BUS_AMD_SFH		0x20
 #define AMD_SFH_HID_VENDOR	0x1022
 #define AMD_SFH_HID_PRODUCT	0x0001
 
-- 
2.35.1



