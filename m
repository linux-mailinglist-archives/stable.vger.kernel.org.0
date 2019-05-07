Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B674715B75
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfEGFyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728667AbfEGFia (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:38:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B772B2087F;
        Tue,  7 May 2019 05:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207510;
        bh=HtjpE101QbK9gW+OtJSdPiOgOJv26Q+FNS6nJPvoi+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06Gm+cveueb/1/OmhyQVt5sCsWm6lEsIZb5lxbW48NuqbnalZZ41PB5U1e/B83t/y
         yOT7Xcl1F5OozUdF2a1fOuD23yp6lUOg6DSifCLnP75HEAVM2Y4C7Ou4814c3g/FPV
         2pWR2guGvFyukMfU4ufKuaNnIQangB+bc8hl/VQI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/95] HID: input: add mapping for Expose/Overview key
Date:   Tue,  7 May 2019 01:36:52 -0400
Message-Id: <20190507053826.31622-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 96dd86871e1fffbc39e4fa61c9c75ec54ee9af0f ]

According to HUTRR77 usage 0x29f from the consumer page is reserved for
the Desktop application to present all running user’s application windows.
Linux defines KEY_SCALE to request Compiz Scale (Expose) mode, so let's
add the mapping.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d146a9b545ee..35422c419f52 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1016,6 +1016,8 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x2cb: map_key_clear(KEY_KBDINPUTASSIST_ACCEPT);	break;
 		case 0x2cc: map_key_clear(KEY_KBDINPUTASSIST_CANCEL);	break;
 
+		case 0x29f: map_key_clear(KEY_SCALE);		break;
+
 		default: map_key_clear(KEY_UNKNOWN);
 		}
 		break;
-- 
2.20.1

