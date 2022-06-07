Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7970D540BC4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350859AbiFGSbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351413AbiFGS32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B8517856D;
        Tue,  7 Jun 2022 10:55:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8252617E1;
        Tue,  7 Jun 2022 17:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C3DC385A5;
        Tue,  7 Jun 2022 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624515;
        bh=+UBMaOkH/rDx4NAaBtUx2K/VsqF7mQcqX0QNcmyUFeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsj7csibKOZQQtpeBRlt+Gq2iyMHEjJwtzAA3pGHSmtsm58aadd89VDmHuO4Q2yV9
         XVabm+qoFf+rBJ5Wnh2NBN97mnzCy6lJbYXmzUY3jhBlW91wkOEtqqfEJiwmIy5hFA
         pYyC1PXuHuvzU1j6Ze9Op8xNP8pQeIBWCdZOnUPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 304/667] HID: amd_sfh: Modify the hid name
Date:   Tue,  7 Jun 2022 18:59:29 +0200
Message-Id: <20220607164943.894842846@linuxfoundation.org>
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

[ Upstream commit 10f865cdcf37d26ae5e9595a7b4f9e06538e84e5 ]

Modifying the amd-sfh hid name to meaningful name.

Fixes: 4b2c53d93a4b ("SFH:Transport Driver to add support of AMD Sensor Fusion Hub (SFH)")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_hid.c b/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
index 8b8a7c40ed4e..a4bda2ac713e 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
@@ -142,7 +142,7 @@ int amdtp_hid_probe(u32 cur_hid_dev, struct amdtp_cl_data *cli_data)
 	hid->bus = BUS_AMD_SFH;
 	hid->vendor = AMD_SFH_HID_VENDOR;
 	hid->product = AMD_SFH_HID_PRODUCT;
-	snprintf(hid->name, sizeof(hid->name), "%s %04X:%04X", "hid-amdtp",
+	snprintf(hid->name, sizeof(hid->name), "%s %04X:%04X", "hid-amdsfh",
 		 hid->vendor, hid->product);
 
 	rc = hid_add_device(hid);
-- 
2.35.1



