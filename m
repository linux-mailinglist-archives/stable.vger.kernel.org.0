Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A0B6D9567
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238030AbjDFLda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236513AbjDFLc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:32:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5032727;
        Thu,  6 Apr 2023 04:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E28364661;
        Thu,  6 Apr 2023 11:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9FDC4339E;
        Thu,  6 Apr 2023 11:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780749;
        bh=myqHm/MN7G6R3HZTpB1HDaYKPLd2W5Hp9SmjuR0tUOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5UNzJULk3bDVTpKuAHanqGR8AsmeLywy6t7BJdmCpxuwv4pmVUqMVsLKSZJuTz24
         ov3XpThTHurrw0ltLdbUyUcupOZPoO9H16xWx+In/GpFzAmJeRmvR7YgTnZSIvxB+j
         VdgxYuepuo5Oq+vZ4rIm442WPjmqggTHryDH3XTeoFc+iMW7IetOYAoq9wOkDLT4q0
         INb7GMe3dcWrbv55JF7Zlj13QUsEs57ICMgv8QvwbFxVy32AFr+Iv6YRzkIk9eLAVy
         MCxYmDZ0qAaL3Xvdolu8/yp7kZnY9uvclGoW1vuTBvipx2P8+ifWxTvUDtk8XFC34q
         DbzL/wqeKpVxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        got3nks <got3nks@users.noreply.github.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, thomas@weissschuh.net,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 08/17] platform/x86: gigabyte-wmi: add support for B650 AORUS ELITE AX
Date:   Thu,  6 Apr 2023 07:32:02 -0400
Message-Id: <20230406113211.648424-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113211.648424-1-sashal@kernel.org>
References: <20230406113211.648424-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 441d901fbf669f6360566a4437b1e563b854de4a ]

This has been reported as working.

Suggested-by: got3nks <got3nks@users.noreply.github.com>
Link: https://github.com/t-8ch/linux-gigabyte-wmi-driver/issues/15#issuecomment-1483942966
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20230327-gigabyte-wmi-b650-elite-ax-v1-1-d4d645c21d0b@weissschuh.net
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 4dd39ab6ecfa2..5e5b17c50eb67 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -151,6 +151,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550I AORUS PRO AX"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M AORUS PRO-P"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M DS3H"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B650 AORUS ELITE AX"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B660 GAMING X DDR4"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B660I AORUS PRO DDR4"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z390 I AORUS PRO WIFI-CF"),
-- 
2.39.2

