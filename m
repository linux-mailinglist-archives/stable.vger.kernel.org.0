Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7CDDA015
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395553AbfJPWHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438087AbfJPV6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:00 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 677FD21A4C;
        Wed, 16 Oct 2019 21:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263079;
        bh=lwj8Z/2nygbJ7/eWoiA323ECTy2uOmJ/S1DN8KyBuZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzDS7AQlNbeqTNLWnQGqQTA6BC3AxxylmncUlSdy5hd88WEDTNxfGMiQ6LoWmsKZY
         7toNEy+0HastHmaHi9lPpWnQVm9HVy1nvI01BUdDUPFLEc8QblsdBeD4IgvH617jtg
         VP0Q5aLeRC1CVFDgootF5unIUnu3ijioQ2Egdr/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 78/81] hwmon: Fix HWMON_P_MIN_ALARM mask
Date:   Wed, 16 Oct 2019 14:51:29 -0700
Message-Id: <20191016214848.434882027@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit 30945d31e5761436d9eba6b8cff468a5f7c9c266 upstream.

Both HWMON_P_MIN_ALARM and HWMON_P_MAX_ALARM were using
BIT(hwmon_power_max_alarm).

Fixes: aa7f29b07c870 ("hwmon: Add support for power min, lcrit, min_alarm and lcrit_alarm")
CC: <stable@vger.kernel.org>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20190924124945.491326-2-nuno.sa@analog.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/hwmon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -225,7 +225,7 @@ enum hwmon_power_attributes {
 #define HWMON_P_LABEL			BIT(hwmon_power_label)
 #define HWMON_P_ALARM			BIT(hwmon_power_alarm)
 #define HWMON_P_CAP_ALARM		BIT(hwmon_power_cap_alarm)
-#define HWMON_P_MIN_ALARM		BIT(hwmon_power_max_alarm)
+#define HWMON_P_MIN_ALARM		BIT(hwmon_power_min_alarm)
 #define HWMON_P_MAX_ALARM		BIT(hwmon_power_max_alarm)
 #define HWMON_P_LCRIT_ALARM		BIT(hwmon_power_lcrit_alarm)
 #define HWMON_P_CRIT_ALARM		BIT(hwmon_power_crit_alarm)


