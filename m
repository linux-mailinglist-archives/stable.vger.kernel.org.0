Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849D015D0C
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfEGFcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbfEGFcr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:32:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2B0F20C01;
        Tue,  7 May 2019 05:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207166;
        bh=0xkmY+x/LWBgmQJRP7hmHrxNnMVOYXi0CvZ+usvLCds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmJUyEpo5AFEkDVF/iaCmghLL8FtBnIixcdG74YYFKnnHJ1batTQR3kG2gnqrtCIg
         pl5aTBwItx0yYhmrl6xgSE7HNKxoRCYmnC2p9QptB4tJA4nrmAv0S5xRMmNcf2HCoP
         EhxDxBd8KC886aZ9oBnUlmvpLZxnFuI1S5KCUkKU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 07/99] HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys
Date:   Tue,  7 May 2019 01:31:01 -0400
Message-Id: <20190507053235.29900-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
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
index f55bfcabd718..a985d55e3510 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -908,6 +908,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
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

