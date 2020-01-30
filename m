Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D7D14E1F2
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbgA3Srf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:47:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731383AbgA3Sra (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:47:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86B42205F4;
        Thu, 30 Jan 2020 18:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410050;
        bh=8Fe2iBeciYBwPKPi0FEOt8js/IBKrjykSDBPJL7NGm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivqxBU40T4FTp92GdkLRZ5wpJwWgruRerkqGsgRjI55h72Wp7LBqy6qWHP0KA29Cq
         Z5Q3EFsxKVkvq3m4Z+IPiQCFgy2iT0ZxsgY5UbYdFChOAEpUo2zI1CtyxM0qRhLGfN
         uav2HY0yuqq2JXK45h5AM55VmnUshktEGTB5Dwco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Priit Laes <plaes@plaes.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/55] HID: Add quirk for Xin-Mo Dual Controller
Date:   Thu, 30 Jan 2020 19:39:08 +0100
Message-Id: <20200130183613.660573513@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



