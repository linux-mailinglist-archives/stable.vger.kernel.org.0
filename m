Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A7159A170
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349930AbiHSP4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350752AbiHSPzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:55:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0D1107F3D;
        Fri, 19 Aug 2022 08:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3A28B82813;
        Fri, 19 Aug 2022 15:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1633DC433C1;
        Fri, 19 Aug 2022 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924213;
        bh=sufOGxxRGzcDul6F7ze451RApth6tJw02w1Y1Ksf4ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3ebNOGETvWof3Pf4tCDmlf2lCasIHT81Qk/bT8kHqjNkwFjrlmLGjEQsEay2wZS8
         3ypJyaxkd82xtwcahw8K1ItZUap+EYgsZQ0RjjUPwI3SDXvviEzUvNoZF47mLVLJvH
         ++mP4AKVkwbf8I3vQ/jOVFEeO/G9C4dIxQMPuT+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/545] ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks
Date:   Fri, 19 Aug 2022 17:37:45 +0200
Message-Id: <20220819153833.519695471@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 0dd6db359e5f206cbf1dd1fd40dd211588cd2725 ]

Somehow the "ThinkPad X1 Carbon 6th" entry ended up twice in the
struct dmi_system_id acpi_ec_no_wakeup[] array. Remove one of
the entries.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 3f2e5ea9ab6b..7305cfc8e146 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2180,13 +2180,6 @@ static const struct dmi_system_id acpi_ec_no_wakeup[] = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "Thinkpad X1 Carbon 6th"),
 		},
 	},
-	{
-		.ident = "ThinkPad X1 Carbon 6th",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Carbon 6th"),
-		},
-	},
 	{
 		.ident = "ThinkPad X1 Yoga 3rd",
 		.matches = {
-- 
2.35.1



