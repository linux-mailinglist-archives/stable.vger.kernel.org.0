Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81ACB2E68AA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgL1Qjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:39:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729366AbgL1M74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:59:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC3DF22582;
        Mon, 28 Dec 2020 12:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160356;
        bh=mVeXhq4sJ2hihUK43w8WVwVZbrqDMGkLZY7ds9Ra2Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbFkbGNNjSyarhvHPck62oxgIT2/i+IkgRckqLpvhSCQVV6Ddy5i6C47e9OBm6rvW
         rUGYv19b4OLLYoTMJ1b1Y3g3zWiMWXDBTWcqm9atuZB8dBVeI6H9I4GwIxxdoyce8T
         XdK0uSPSOiHKvIHe7g7kojKX5vKFStLq+S0Np74I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timo Witte <timo.witte@gmail.com>,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 006/175] platform/x86: acer-wmi: add automatic keyboard background light toggle key as KEY_LIGHTS_TOGGLE
Date:   Mon, 28 Dec 2020 13:47:39 +0100
Message-Id: <20201228124853.555789949@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 1515c9480f89f..90015e2cce9bf 100644
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



