Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7CA14F2A
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfEFOgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727080AbfEFOgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:36:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFE3821479;
        Mon,  6 May 2019 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153363;
        bh=FJitW7mp+HLHTOIXtA5/0CxI/c+h9quKMYWP1/nyVyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bmCU/qlX6FdkuskaLGhsgQffQe+2JCAekzA9A7+2X9hdjFY6ab1ks9Xpkjazpn6nV
         OuY4F44wmLiIv8SwfxZYr1V/j4QhigMSDuCDLBaobK7FBEzhT9ul6/SbEQfBiC12ws
         V3JuM2NRtwqroNkWjiSSpbw5UJx+3D4fMFRJPURE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 061/122] HID: input: add mapping for Assistant key
Date:   Mon,  6 May 2019 16:31:59 +0200
Message-Id: <20190506143100.462503352@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ce856634af8cda3490947df8ac1ef5843e6356af ]

According to HUTRR89 usage 0x1cb from the consumer page was assigned to
allow launching desktop-aware assistant application, so let's add the
mapping.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 59a5608b8dc0..ff92a7b2fc89 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -995,6 +995,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x1b8: map_key_clear(KEY_VIDEO);		break;
 		case 0x1bc: map_key_clear(KEY_MESSENGER);	break;
 		case 0x1bd: map_key_clear(KEY_INFO);		break;
+		case 0x1cb: map_key_clear(KEY_ASSISTANT);	break;
 		case 0x201: map_key_clear(KEY_NEW);		break;
 		case 0x202: map_key_clear(KEY_OPEN);		break;
 		case 0x203: map_key_clear(KEY_CLOSE);		break;
-- 
2.20.1



