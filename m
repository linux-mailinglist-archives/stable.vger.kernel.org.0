Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32630420D2D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhJDNMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235224AbhJDNKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE39C61B66;
        Mon,  4 Oct 2021 13:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352647;
        bh=UqOg3YG077MWEAKuhTpg7+Z+tjJ+USplDtgNYF88NJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zh3v3JpTrOl1maIzOJ+0ALZHOkpczb/092OIbykTMuwUspm+MrZl10QmVPBVWArkR
         A1ZAai0MSKsABvC7pNbkc5Ziwn5WOh/t4/+KIBUpHgOvcGeXceXXzeuwd7v95kCnQ8
         Wj5EMUVCNjw0x0H4KtVz9qU0JvMnVmIdeprgj4WM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 67/95] hwmon: (tmp421) Replace S_<PERMS> with octal values
Date:   Mon,  4 Oct 2021 14:52:37 +0200
Message-Id: <20211004125035.756246221@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b626eb22f9e17fcca4e262a8274e93690068557f ]

Replace S_<PERMS> with octal values.

The conversion was done automatically with coccinelle. The semantic patches
and the scripts used to generate this commit log are available at
https://github.com/groeck/coccinelle-patches/hwmon/.

This patch does not introduce functional changes. It was verified by
compiling the old and new files and comparing text and data sizes.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp421.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index ceb3db6f3fdd..06826a78c0f4 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -187,9 +187,9 @@ static umode_t tmp421_is_visible(const void *data, enum hwmon_sensor_types type,
 	case hwmon_temp_fault:
 		if (channel == 0)
 			return 0;
-		return S_IRUGO;
+		return 0444;
 	case hwmon_temp_input:
-		return S_IRUGO;
+		return 0444;
 	default:
 		return 0;
 	}
-- 
2.33.0



