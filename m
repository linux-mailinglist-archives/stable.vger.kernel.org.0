Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EBC6D958A
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237974AbjDFLej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbjDFLeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:34:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F88C199;
        Thu,  6 Apr 2023 04:33:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44FD164696;
        Thu,  6 Apr 2023 11:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06D1C4339C;
        Thu,  6 Apr 2023 11:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780777;
        bh=p75sflDLlEpgR3VxnPOI6GdWlxDyLRZMqnxgRx5CbEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETe6O3Ib3VkZqw/OJaYsKNbCYnsp9VEhnEf35my/bI/rrzO4IXXQOJW64fpCl6GVd
         /MIKXbBxi2VoOafQad8tYUVMzJWT0J5+vyIg0r1L3IuH1LrteYe+QJt1mKicvgPmD1
         ZfvVQEa4oe1q1Xut+PsRyFVF+hhM+G84MXd7HnlmVjF9TFGRumwnSPDzPI0qF9xiTB
         oPflXjyRoMjykq5KisVgv77Lad7Ol+RkeiVXD7/SY84cXDSpFS4VfGbbvG2hCp+gjT
         j2yUAmAh2PJF16FJLOt4diKwYchnUEAqf6Nncxphy32VGsfULY1EIXKM/8Cp9Rm0oE
         6+V0IrkPKZ/+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Crawford <frank@crawford.emu.id.au>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, thomas@weissschuh.net,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/11] platform/x86 (gigabyte-wmi): Add support for A320M-S2H V2
Date:   Thu,  6 Apr 2023 07:32:42 -0400
Message-Id: <20230406113250.648634-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113250.648634-1-sashal@kernel.org>
References: <20230406113250.648634-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Crawford <frank@crawford.emu.id.au>

[ Upstream commit b7c994f8c35e916e27c60803bb21457bc1373500 ]

Add support for A320M-S2H V2.  Tested using module force_load option.

Signed-off-by: Frank Crawford <frank@crawford.emu.id.au>
Acked-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20230318091441.1240921-1-frank@crawford.emu.id.au
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 0163e912fafec..aea4f3144b68f 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -140,6 +140,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 	}}
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("A320M-S2H V2-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
-- 
2.39.2

