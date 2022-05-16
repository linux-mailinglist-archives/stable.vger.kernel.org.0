Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5547529079
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245752AbiEPUEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351057AbiEPUB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8E447579;
        Mon, 16 May 2022 12:57:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E8B4B81611;
        Mon, 16 May 2022 19:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C51C385AA;
        Mon, 16 May 2022 19:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731056;
        bh=LtglKuDIcoTD0hbZVEoanwLub+zngdfuc7BctvOC8uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6El1o94BGUWCcUfbB72xlhQYyc2e1Nz14KDPvpHH9m66do9BK2vY+t7kGd9tsQ/u
         nG92MlGATcmwbL4JTcYnv6b74NNXHOSUZs3lYv01k5Fie/nssMEIGTBPmumfhokrG/
         ASwJMDuFCMzQooYPl5S3ffUyrhT6A2weLQ6p6pFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Pauk <pauk.denis@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 049/114] hwmon: (asus_wmi_sensors) Fix CROSSHAIR VI HERO name
Date:   Mon, 16 May 2022 21:36:23 +0200
Message-Id: <20220516193626.902382589@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit 4fd45cc8568e6086272d3036f2c29d61e9b776a1 ]

CROSSHAIR VI HERO motherboard is incorrectly named as
ROG CROSSHAIR VI HERO.

Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Link: https://lore.kernel.org/r/20220403193455.1363-1-pauk.denis@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus_wmi_sensors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/asus_wmi_sensors.c b/drivers/hwmon/asus_wmi_sensors.c
index c80eee874b6c..49784a6ea23a 100644
--- a/drivers/hwmon/asus_wmi_sensors.c
+++ b/drivers/hwmon/asus_wmi_sensors.c
@@ -71,7 +71,7 @@ static const struct dmi_system_id asus_wmi_dmi_table[] = {
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("PRIME X399-A"),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("PRIME X470-PRO"),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VI EXTREME"),
-	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VI HERO"),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("CROSSHAIR VI HERO"),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VI HERO (WI-FI AC)"),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VII HERO"),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VII HERO (WI-FI)"),
-- 
2.35.1



