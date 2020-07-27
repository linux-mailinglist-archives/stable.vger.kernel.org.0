Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A108722F11A
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbgG0OWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731961AbgG0OWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:22:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F8A52070A;
        Mon, 27 Jul 2020 14:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859773;
        bh=z2IM2Mu9HSt9sLr6cNZQIScq87Wopxln51FoHO14OGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuhFT8eHszO735eA6L8/TTNOI7K1/udlNbBn4JLcm1LHDk3NqbVh0isSwoz03k5Bs
         XxXExW2OMyBwnUe7jI3S1PGYjivLNKSJ04MSjF+og+C5WxuKKLOa6HuO+Zyt4fViuu
         N0jeDDy5R8AotKuFc0FZHecqDMEQueInaiB/BN88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Federico Ricchiuto <fed.ricchiuto@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 100/179] HID: i2c-hid: add Mediacom FlexBook edge13 to descriptor override
Date:   Mon, 27 Jul 2020 16:04:35 +0200
Message-Id: <20200727134937.524689290@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Federico Ricchiuto <fed.ricchiuto@gmail.com>

[ Upstream commit 43e666acb79f3d355dd89bf20f4d25d3b15da13e ]

The Mediacom FlexBook edge13 uses the SIPODEV SP1064 touchpad, which does not
supply descriptors, so it has to be added to the override list.

Signed-off-by: Federico Ricchiuto <fed.ricchiuto@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
index ec142bc8c1daf..35f3bfc3e6f59 100644
--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -373,6 +373,14 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
 		},
 		.driver_data = (void *)&sipodev_desc
 	},
+	{
+		.ident = "Mediacom FlexBook edge 13",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "MEDIACOM"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "FlexBook_edge13-M-FBE13"),
+		},
+		.driver_data = (void *)&sipodev_desc
+	},
 	{
 		.ident = "Odys Winbook 13",
 		.matches = {
-- 
2.25.1



