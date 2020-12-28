Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF652E6794
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbgL1Q0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:26:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730978AbgL1NIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:08:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33175207C9;
        Mon, 28 Dec 2020 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160910;
        bh=KyTdHlhqvA3ADKEJ/GXypxElvwVqUxk7Lv+osuPptec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cm7KnQyOFcQSiw1vUG5ILQbJ3ohlwo9VNNzDKSO+bZ0PSdu12WKKb1ZQt/JEUu5Zy
         eYl+tPUoLASaj2DGA41buocqLGO9q8Iabbz2kpYF7YfNT8xbQ2OEWHE09Ify8Gg0op
         DsyUjYM9YXMPRCz+LJtfsq/Bch/NolKpEgPRRx20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timo Witte <timo.witte@gmail.com>,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 009/242] platform/x86: acer-wmi: add automatic keyboard background light toggle key as KEY_LIGHTS_TOGGLE
Date:   Mon, 28 Dec 2020 13:46:54 +0100
Message-Id: <20201228124905.116676832@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timo Witte <timo.witte@gmail.com>

[ Upstream commit 9e7a005ad56aa7d6ea5830c5ffcc60bf35de380b ]

Got a dmesg message on my AMD Renoir based Acer laptop:
"acer_wmi: Unknown key number - 0x84" when toggling keyboard
background light

Signed-off-by: Timo Witte <timo.witte@gmail.com>
Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>
Link: https://lore.kernel.org/r/20200804001423.36778-1-timo.witte@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 1be71f956d5c2..29f6f2bbb5fff 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -124,6 +124,7 @@ static const struct key_entry acer_wmi_keymap[] __initconst = {
 	{KE_KEY, 0x64, {KEY_SWITCHVIDEOMODE} },	/* Display Switch */
 	{KE_IGNORE, 0x81, {KEY_SLEEP} },
 	{KE_KEY, 0x82, {KEY_TOUCHPAD_TOGGLE} },	/* Touch Pad Toggle */
+	{KE_IGNORE, 0x84, {KEY_KBDILLUMTOGGLE} }, /* Automatic Keyboard background light toggle */
 	{KE_KEY, KEY_TOUCHPAD_ON, {KEY_TOUCHPAD_ON} },
 	{KE_KEY, KEY_TOUCHPAD_OFF, {KEY_TOUCHPAD_OFF} },
 	{KE_IGNORE, 0x83, {KEY_TOUCHPAD_TOGGLE} },
-- 
2.27.0



