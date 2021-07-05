Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A894F3BC0B8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhGEPhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233476AbhGEPgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07A7061A2D;
        Mon,  5 Jul 2021 15:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499113;
        bh=kTVddoRfG4DNgDSYwVJCYQv5jeIAYXyncwB1agdGmCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=up1EyCs8gW1ZGpOp1geFcLAnGbzDotyD9ATC3w44ESp6r8lIZqEt8ou9rc9lg5mYV
         Mm7QrZH8iHsOu3hGXVB1fvYR5fxrw4lXYh8J9fMbfOpxyfXh4MnQDZ+eySoU0vuLHz
         AOFY980ejAqzgZ7rCMD9YAGAfhoEXvovYIOZRvWauTq5oWxppeVchNRpoYcOSsgAn1
         crkqLw6+/cLNR82bsqt8LlCL4Q4Gn0ikdKhoDO5Upd8ChTwQoVDzqP4fEJ+5X/rXrT
         d3C7AZ1DpMb3sXhpEa69u/8xH74o+gO8jb3+c2Ji48D5GRgmL4GQbymcT6eMb79af0
         oGq/6BzfSzc5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gerecke <killertofu@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/15] HID: wacom: Correct base usage for capacitive ExpressKey status bits
Date:   Mon,  5 Jul 2021 11:31:35 -0400
Message-Id: <20210705153136.1522245-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153136.1522245-1-sashal@kernel.org>
References: <20210705153136.1522245-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d2fe7af2c152..55b542a6a66b 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -121,7 +121,7 @@
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

