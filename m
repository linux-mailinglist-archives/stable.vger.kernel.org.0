Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AE35519B7
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbiFTM5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243423AbiFTM5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:57:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B60E1A825;
        Mon, 20 Jun 2022 05:55:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2874D614B7;
        Mon, 20 Jun 2022 12:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EB9C3411B;
        Mon, 20 Jun 2022 12:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729711;
        bh=7NUMHzQlN+H4b3c+QV6ZaAVLc79YAd+yAe4WU2xah7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezTInej09ZDVm5czNvBle1CgVfXWjD1JaAd4XncaTvluoYLXB2xVm1rMi7rNhSSGi
         ofW1XM1BqKgLlz+RytYrmmOgehdq03nyk7YSj8dbmTey4cN8/Oeo8SAHaCXN2wHgSy
         rNPkzMeJg1JEy9vLIimcYG2+dZcMExakcHIOKHP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, August Wikerfors <git@augustwikerfors.se>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 050/141] platform/x86: gigabyte-wmi: Add support for B450M DS3H-CF
Date:   Mon, 20 Jun 2022 14:49:48 +0200
Message-Id: <20220620124731.013625484@linuxfoundation.org>
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

From: August Wikerfors <git@augustwikerfors.se>

[ Upstream commit c6bc7e8ee90845556a90faf8b043cbefd77b8903 ]

Tested and works on my system.

Signed-off-by: August Wikerfors <git@augustwikerfors.se>
Link: https://lore.kernel.org/r/20220608212028.28307-1-git@augustwikerfors.se
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 05588a47ac38..78446b1953f7 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -140,6 +140,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 	}}
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE AX V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
-- 
2.35.1



