Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265793BC049
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbhGEPfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233050AbhGEPeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F3A2619C5;
        Mon,  5 Jul 2021 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499065;
        bh=IH4lhPDpvxmWg2bAKUCN01/Ju1RnAolEGFYrWtFY018=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eo7wqFym4gQUFkQAusXBaNlY+3z3mD1KN1bu3aG8UI/GyYTy44PdWYJuzFDv0iMry
         TCu+1k28OZuJ7A/VukO8EGmikthLDvXZjn0VvUwj2TMf/brJqKS8mr5jjlPoINOyL6
         An5AFqH8ICKL065siREp0CaVtvtbRlt2RgeC64LFpWoUyFO3QCWDykhW0BWyHJ3/Hh
         5IKDcGsVbzhc9sluX0o7yuJCYRb7FhAwS9isFg73+iJzc3fsgEA5HY5l0dz0w5zGnj
         zlRfjrvZbq5suzMum7Q7ABXm4T1gOwZ2P2PUxb/O0W6pORrFS8ikSgze8jcfP29QFM
         IiJmUit5/oRcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gerecke <killertofu@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/26] HID: wacom: Correct base usage for capacitive ExpressKey status bits
Date:   Mon,  5 Jul 2021 11:30:34 -0400
Message-Id: <20210705153039.1521781-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
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

