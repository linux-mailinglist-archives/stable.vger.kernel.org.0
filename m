Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F06F1F081
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbfEOLop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732139AbfEOL0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:26:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6CBB20818;
        Wed, 15 May 2019 11:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919583;
        bh=bBVkt7ke+7BX2VBGJQpe2SV4R2dH9B1EORuNlsATUiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lh9e3ERrEPgkt+2My3HORAscAd+zNq620WN/UZmOcg4/69tCn0J9tou9WHeZXvfRY
         hO2XUay2vVdRwt2WmTHI62eA4L/MLFz5AdeIs9m1QOWkXfhQsKQPRMTTfLO3LjM+x5
         LomzdgnDneqaOcA1Zj7lKPaYC6E+Dr0X2QJ1APkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 017/137] HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys
Date:   Wed, 15 May 2019 12:54:58 +0200
Message-Id: <20190515090654.564437644@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7975a1d6a7afeb3eb61c971a153d24dd8fa032f3 ]

According to HUTRR73 usages 0x79, 0x7a and 0x7c from the consumer page
correspond to Brightness Up/Down/Toggle keys, so let's add the mappings.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 468da6f6765db..290efac7e6bfd 100644
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



