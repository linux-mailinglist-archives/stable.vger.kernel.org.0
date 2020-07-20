Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B605C227092
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgGTVh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbgGTVhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:37:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A79F207FC;
        Mon, 20 Jul 2020 21:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281073;
        bh=ouo7TMEz/IqYJUsjvl8B3CXtrHu4eF3BTHFsVDf8JeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTiQu19yL0nn+PqPyeojnWWIeT+61r4z9iZUr1dF5Cn7ej85dKlkNeJl4bLjhGVGm
         IqbkvIjwqdS2ht687rKM8ief80w3P3c/td0ljeFvWYSpMSo6tUfNCHIYRryWQrU4lP
         PvjQothttDAc6DmJ1UroFBsYdpW+v8Ktu/teGk6s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasiliy Kupriakov <rublag-ns@yandex.ru>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 30/40] platform/x86: asus-wmi: allow BAT1 battery name
Date:   Mon, 20 Jul 2020 17:37:05 -0400
Message-Id: <20200720213715.406997-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasiliy Kupriakov <rublag-ns@yandex.ru>

[ Upstream commit 9a33e375d98ece5ea40c576eabd3257acb90c509 ]

The battery on my laptop ASUS TUF Gaming FX706II is named BAT1.
This patch allows battery extension to load.

Signed-off-by: Vasiliy Kupriakov <rublag-ns@yandex.ru>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index cd212ee210e2d..537b824a1ae25 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -432,6 +432,7 @@ static int asus_wmi_battery_add(struct power_supply *battery)
 	 * battery is named BATT.
 	 */
 	if (strcmp(battery->desc->name, "BAT0") != 0 &&
+	    strcmp(battery->desc->name, "BAT1") != 0 &&
 	    strcmp(battery->desc->name, "BATT") != 0)
 		return -ENODEV;
 
-- 
2.25.1

