Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014983C4CCF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240861AbhGLHIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242366AbhGLHGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:06:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A786610E5;
        Mon, 12 Jul 2021 07:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073429;
        bh=IH4lhPDpvxmWg2bAKUCN01/Ju1RnAolEGFYrWtFY018=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBKtU+GHzBhPTzZld6GmWY6JEffbcrlH0aMQR71W/ywLvU0LRgIwOfafW6Kol/lVm
         /gtNtHPWkyG93fHShKvQrdH3aDgbkiLxxOjxFd/a3Qgtz8Z4S7R8zn6I9kwnmHAp+u
         1XAxe7WxRY3pDeiLP7Xhz/fH6uN3nYBWulsCDaEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 239/700] HID: wacom: Correct base usage for capacitive ExpressKey status bits
Date:   Mon, 12 Jul 2021 08:05:22 +0200
Message-Id: <20210712061000.744992403@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

[ Upstream commit 424d8237945c6c448c8b3f23885d464fb5685c97 ]

The capacitive status of ExpressKeys is reported with usages beginning
at 0x940, not 0x950. Bring our driver into alignment with reality.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 195910dd2154..e3835407e8d2 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -122,7 +122,7 @@
 #define WACOM_HID_WD_TOUCHONOFF         (WACOM_HID_UP_WACOMDIGITIZER | 0x0454)
 #define WACOM_HID_WD_BATTERY_LEVEL      (WACOM_HID_UP_WACOMDIGITIZER | 0x043b)
 #define WACOM_HID_WD_EXPRESSKEY00       (WACOM_HID_UP_WACOMDIGITIZER | 0x0910)
-#define WACOM_HID_WD_EXPRESSKEYCAP00    (WACOM_HID_UP_WACOMDIGITIZER | 0x0950)
+#define WACOM_HID_WD_EXPRESSKEYCAP00    (WACOM_HID_UP_WACOMDIGITIZER | 0x0940)
 #define WACOM_HID_WD_MODE_CHANGE        (WACOM_HID_UP_WACOMDIGITIZER | 0x0980)
 #define WACOM_HID_WD_MUTE_DEVICE        (WACOM_HID_UP_WACOMDIGITIZER | 0x0981)
 #define WACOM_HID_WD_CONTROLPANEL       (WACOM_HID_UP_WACOMDIGITIZER | 0x0982)
-- 
2.30.2



