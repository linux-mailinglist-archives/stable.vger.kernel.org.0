Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE7E2CD740
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437075AbgLCNcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:32:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436918AbgLCNbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:31:15 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Verevkin <me@maxverevkin.tk>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/14] platform/x86: intel-vbtn: Support for tablet mode on HP Pavilion 13 x360 PC
Date:   Thu,  3 Dec 2020 08:30:10 -0500
Message-Id: <20201203133010.931600-14-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203133010.931600-1-sashal@kernel.org>
References: <20201203133010.931600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Verevkin <me@maxverevkin.tk>

[ Upstream commit 8b205d3e1bf52ab31cdd5c55f87c87a227793d84 ]

The Pavilion 13 x360 PC has a chassis-type which does not indicate it is
a convertible, while it is actually a convertible. Add it to the
dmi_switches_allow_list.

Signed-off-by: Max Verevkin <me@maxverevkin.tk>
Link: https://lore.kernel.org/r/20201124131652.11165-1-me@maxverevkin.tk
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 1e6b4661c7645..3aba207ee1745 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -197,6 +197,12 @@ static const struct dmi_system_id dmi_switches_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Stream x360 Convertible PC 11"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion 13 x360 PC"),
+		},
+	},
 	{} /* Array terminator */
 };
 
-- 
2.27.0

