Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D8D44B64A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243170AbhKIW0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:26:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343986AbhKIWYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:24:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38DB561A08;
        Tue,  9 Nov 2021 22:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496341;
        bh=5UcTKxKfdMXTSehu63DUjp112pHP5C78pHzegeLtesQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJ0PJ5yRo/Na0kmwErOzg7yqzwp1Ujio4hJRNvAbNYUWDgTbJTnNGhlDI37chzn2n
         bnBZhSUXWn9fiinDeGL+unEo+R4ejr/j6VlHyP+RpHU5EvZgD+tzfOupR1DzfSmtLE
         uo7yOt71v0W0D6jF/N3os9RnO8ZBEzY3IYja0skU26oxXRXmX0/YwzhtiXfT3YYEkB
         g2gdfn+leXvrbAEn+ZvMpWqjPkIeHaSis4Vyfv/Nk27qss+vMspeQta3PM+1QkqDYl
         btrvmYONHCKR91IDF3JWQzA/dr1zFKd05xoVvgs1fLe9+jehYbfCyXEkXDkHNqon9e
         rsgwbxBgMRhrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Kosina <jkosina@suse.cz>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 82/82] HID: playstation: require multicolor LED functionality
Date:   Tue,  9 Nov 2021 17:16:40 -0500
Message-Id: <20211109221641.1233217-82-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
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
index 3c33bf572d6d3..d78b1c1fb97e9 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -868,6 +868,7 @@ config HID_PLANTRONICS
 config HID_PLAYSTATION
 	tristate "PlayStation HID Driver"
 	depends on HID
+	depends on LEDS_CLASS_MULTICOLOR
 	select CRC32
 	select POWER_SUPPLY
 	help
-- 
2.33.0

