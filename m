Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA223333E34
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhCJNZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233184AbhCJNZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD95E64FD8;
        Wed, 10 Mar 2021 13:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382702;
        bh=8X32iOgDKlS3S+lKRAQtApS+4qPcMAL1AjuDElNtk/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vzs+QFRrk3X7vttpBfSmhWyXD6EE/uA6WBE09QnAA0FDU5LEJr1sVY9qdBjUG7eDd
         mVvtdIODpp7d8CpWS3LetJp687r3eQnDfI6ZyYsYaL61bMNe9VrwHUP2mDXdfTCXQd
         1zEWXWHu8kh4oJnx5FUg/k7P5QGZuLTZHYIL2lCI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/24] platform/x86: acer-wmi: Add ACER_CAP_KBD_DOCK quirk for the Aspire Switch 10E SW3-016
Date:   Wed, 10 Mar 2021 14:24:25 +0100
Message-Id: <20210310132320.953247914@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.550932445@linuxfoundation.org>
References: <20210310132320.550932445@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit bf753400280d1384abb783efc0b42c491d6deec3 ]

Add the Acer Aspire Switch 10E SW3-016 to the list of models which use the
Acer Switch WMI interface for reporting SW_TABLET_MODE.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201123151625.5530-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 427dd0987338..d27a564389a4 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -511,6 +511,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
+	{
+		.callback = set_force_caps,
+		.ident = "Acer Aspire Switch 10E SW3-016",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire SW3-016"),
+		},
+		.driver_data = (void *)ACER_CAP_KBD_DOCK,
+	},
 	{
 		.callback = set_force_caps,
 		.ident = "Acer Aspire Switch 10 SW5-012",
-- 
2.30.1



