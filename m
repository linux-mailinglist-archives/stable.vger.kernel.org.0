Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E0618B4EE
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgCSNOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbgCSNOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:14:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59CC921556;
        Thu, 19 Mar 2020 13:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623640;
        bh=+IjVORKh/seQrNgXksEThu2KTYNq7FzrhANnMv4hTSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liHulxlMT+8Z5TQSv1auUwVD+Hidl2XCrNFJ2/3R+8ICe2Wo540rQlgO//CF0PJ+Y
         5Kah3F+YklVWoIgJgTv+qQSJVr0/GhGeM7W87IPUocVONGM4lRmWYAZKMrxgyfX6VA
         zQAQ/f5pK9rWd7j4FZq0gH1cXYLwDS62uRNkLa5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 81/90] HID: i2c-hid: add Trekstor Surfbook E11B to descriptor override
Date:   Thu, 19 Mar 2020 14:00:43 +0100
Message-Id: <20200319123953.375432978@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit be0aba826c4a6ba5929def1962a90d6127871969 ]

The Surfbook E11B uses the SIPODEV SP1064 touchpad, which does not supply
descriptors, so it has to be added to the override list.

BugLink: https://bugs.launchpad.net/bugs/1858299
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
index 10af8585c820d..95052373a8282 100644
--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -341,6 +341,14 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
 		},
 		.driver_data = (void *)&sipodev_desc
 	},
+	{
+		.ident = "Trekstor SURFBOOK E11B",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "TREKSTOR"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "SURFBOOK E11B"),
+		},
+		.driver_data = (void *)&sipodev_desc
+	},
 	{
 		.ident = "Direkt-Tek DTLAPY116-2",
 		.matches = {
-- 
2.20.1



