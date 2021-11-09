Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6C844B745
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344807AbhKIWdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:33:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344813AbhKIWat (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2CBE61A87;
        Tue,  9 Nov 2021 22:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496461;
        bh=K1siIXcn2UDX39tR/eDohFHQ0q4cdToUEV419aT4pp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LG+BZRH+b8D22AZj5nx5rf8iS9WBHpQZq89tRBs1hD4ldI1h+tvn05nMVSMZh7p26
         KZbWehWwJyVuXijrle/O3285jU25ix2H368rrv6aJId+URRIfqFsSl+rfwdFVH4+8j
         CWutmv3qy0Njx8RaCR1guT97AOlf6qoHh9ytB2xAifBD8c6a4F6wMJvHITzA6mOn2X
         eeJPRRK6F7ybVTG7/T7Tk5c9xs7QL9m5lNHlORml7wzv2ev3w34tNpADyaN3Kc9dGo
         hTSasCSXEO50l9tuXPPD+ctUwPZZfeMm4mievhvCEV4quGXlMxNztmCM5X7Sclo/jL
         JMCI81JJZQhxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Kosina <jkosina@suse.cz>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 75/75] HID: playstation: require multicolor LED functionality
Date:   Tue,  9 Nov 2021 17:19:05 -0500
Message-Id: <20211109221905.1234094-75-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit d7f1f9fec09adc1d77092cb2db0e56e2a4efd262 ]

The driver requires multicolor LED support; express that in Kconfig.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 76937f716fbe1..0a6d1c2861bcd 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -867,6 +867,7 @@ config HID_PLANTRONICS
 config HID_PLAYSTATION
 	tristate "PlayStation HID Driver"
 	depends on HID
+	depends on LEDS_CLASS_MULTICOLOR
 	select CRC32
 	select POWER_SUPPLY
 	help
-- 
2.33.0

