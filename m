Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF6F14763F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbgAXBSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:18:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730816AbgAXBR6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A428021D7D;
        Fri, 24 Jan 2020 01:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828677;
        bh=8Fe2iBeciYBwPKPi0FEOt8js/IBKrjykSDBPJL7NGm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4i0vFAwbCzRswYWIvt02R853RU3yI5PNYOSvSa7ALYzc5GaRJezqWVs3D1PTModo
         zc9OPBOc1QL/8W8f0h463CKNVSh7tYEmcQo5aBdi7mb/BdqnZ/vXj6rUKd09CKJNqU
         z+J99CDZLmiGSHaGk5QvFYNixdIj47+HkRRBH9IY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Priit Laes <plaes@plaes.org>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/11] HID: Add quirk for Xin-Mo Dual Controller
Date:   Thu, 23 Jan 2020 20:17:44 -0500
Message-Id: <20200124011747.18575-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011747.18575-1-sashal@kernel.org>
References: <20200124011747.18575-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Priit Laes <plaes@plaes.org>

[ Upstream commit c62f7cd8ed066a93a243643ebf57ca99f754388e ]

Without the quirk, joystick shows up as single controller
for both first and second player pads/pins.

Signed-off-by: Priit Laes <plaes@plaes.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 57d6fe9ed4163..b9529bed4d763 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -175,6 +175,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_SIRIUS_BATTERY_FREE_TABLET), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP_LTD2, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS), HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_QUAD_USB_JOYPAD), HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_XIN_MO, USB_DEVICE_ID_XIN_MO_DUAL_ARCADE), HID_QUIRK_MULTI_INPUT },
 
 	{ 0 }
 };
-- 
2.20.1

