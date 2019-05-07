Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4EA15A44
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbfEGFmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbfEGFmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:42:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88F9120675;
        Tue,  7 May 2019 05:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207742;
        bh=SY72FXt4VRR5BigBs5hw/ACuvbf0sHK2BSz3iZ3X4hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5QJZOwycC9vRfUfd3jZXgmbaWvSM03XBvw9LSt7yprPKMoS9qG5efGHvadnyWgTi
         /RFWiOZUIMBnKe9b+DKU2athU11X8nNf/QKuPgFaPAxqWu+L43TLUrQw3+XKVJ+kkN
         d7FnMYYm0lmjd1K28LdwEvmMN5hZRQqmjKmteKps=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 03/14] HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys
Date:   Tue,  7 May 2019 01:42:05 -0400
Message-Id: <20190507054218.340-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507054218.340-1-sashal@kernel.org>
References: <20190507054218.340-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 7975a1d6a7afeb3eb61c971a153d24dd8fa032f3 ]

According to HUTRR73 usages 0x79, 0x7a and 0x7c from the consumer page
correspond to Brightness Up/Down/Toggle keys, so let's add the mappings.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 01b41ff43056..ee3c66c02043 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -783,6 +783,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x074: map_key_clear(KEY_BRIGHTNESS_MAX);		break;
 		case 0x075: map_key_clear(KEY_BRIGHTNESS_AUTO);		break;
 
+		case 0x079: map_key_clear(KEY_KBDILLUMUP);	break;
+		case 0x07a: map_key_clear(KEY_KBDILLUMDOWN);	break;
+		case 0x07c: map_key_clear(KEY_KBDILLUMTOGGLE);	break;
+
 		case 0x082: map_key_clear(KEY_VIDEO_NEXT);	break;
 		case 0x083: map_key_clear(KEY_LAST);		break;
 		case 0x084: map_key_clear(KEY_ENTER);		break;
-- 
2.20.1

