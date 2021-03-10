Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92462333DFA
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhCJNZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232938AbhCJNYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 264B064FF3;
        Wed, 10 Mar 2021 13:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382682;
        bh=eDxca02f5Q3hJ6WcWjxYS3O2tqD2JDskL56ZN7VS4tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLVTUzs7939v6TVxI7VaQeT+uHX9IT5ZSQISDNA4Kqj+o2VhdYvMHYucVexuqHQww
         niBZE+Zp8cA/Y/6837xduVdLrQcys8f0SgrMHbA7rsR19sz8XLOWJBd3vBs1YIRK+p
         6mYxPy6t5zW3KYpPMERWhQz9WvX7Fbb+UD8SFr+g=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/49] platform/x86: acer-wmi: Add ACER_CAP_KBD_DOCK quirk for the Aspire Switch 10E SW3-016
Date:   Wed, 10 Mar 2021 14:23:31 +0100
Message-Id: <20210310132322.595579552@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
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
index 1efca84bc1bd..80983f9dfcd5 100644
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



