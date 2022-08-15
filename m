Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A68593BA0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347314AbiHOU1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347530AbiHOUZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:25:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F1E357CE;
        Mon, 15 Aug 2022 12:03:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B3B161296;
        Mon, 15 Aug 2022 19:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109D6C433D6;
        Mon, 15 Aug 2022 19:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590192;
        bh=XBYd5KmOyO7N25HDSPYLqT45ga2LwnRyBjaXX8A/4ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5xLvD7zErpaUOEfC+spg+kPlzmI0giqLLOE//KaJ751RKEazSPcuUEDQ2vuEm4ZI
         MGFuxbDtk8ubgxPZ8xQno3KVU4Oq5w7OuJGjzVSQgm+bcpZ5SqCBHk9eoh2gdKcos4
         8g8jA72velU8SRgarUl0kiv/y7G6av9ocCvKzFSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0164/1095] ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks
Date:   Mon, 15 Aug 2022 19:52:43 +0200
Message-Id: <20220815180436.367559933@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index a1b871a418f8..f6a022892ee0 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2207,13 +2207,6 @@ static const struct dmi_system_id acpi_ec_no_wakeup[] = {
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



