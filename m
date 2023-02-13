Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01466949DA
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjBMPCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjBMPCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:02:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F071E28A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:02:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF194B81261
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EC2C433D2;
        Mon, 13 Feb 2023 15:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300531;
        bh=ORBom2unoyaAbGzQJH1NUd5YW/6wg3L31lZTQ2d3D68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0HETnUz3R+BBoDQLzEFXC92pWc5/N5cq80UyPglsSP1DHcKiYesgFrK0Te2gEz+r7
         tnxVXNrLqMcZtMXHhal+7GUxe9jEGQLo/ilDqdwaniag9xu+PqqFSeaSS0j+LIpJkQ
         UmxUyn64cdJvViuWgyAPzMOEtbeV+cHRHxceADFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Werner Sembach <wse@tuxedocomputers.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/139] Input: i8042 - move __initconst to fix code styling warning
Date:   Mon, 13 Feb 2023 15:49:55 +0100
Message-Id: <20230213144748.348418586@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

[ Upstream commit 95a9916c909f0b1d95e24b4232b4bc38ff755415 ]

Move __intconst from before i8042_dmi_laptop_table[] to after it for
consistent code styling.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220629112725.12922-2-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 9c445d2637c9 ("Input: i8042 - add Clevo PCX0DX to i8042 quirk table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 148a7c5fd0e2..91c6f24b4837 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -791,7 +791,7 @@ static const struct dmi_system_id __initconst i8042_dmi_nopnp_table[] = {
 	{ }
 };
 
-static const struct dmi_system_id __initconst i8042_dmi_laptop_table[] = {
+static const struct dmi_system_id i8042_dmi_laptop_table[] __initconst = {
 	{
 		.matches = {
 			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
-- 
2.39.0



