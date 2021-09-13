Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9FA409539
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344315AbhIMOjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345024AbhIMOhG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:37:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60C3661BE6;
        Mon, 13 Sep 2021 13:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541258;
        bh=q1lh6W6UNl2ryR+ZZnrhK7It/hl2XEqy2ckAqm4ZRLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssKbKlqFGJqALAw4Dpq2ma6/2YFAWSr1pYTYIpS6uGGksQVKx+WYVJfGkOxlxTopk
         elrpUjVo8LlvI6J0QXyGszazWD7AcreGeMcFBLD0OhVI/muEbPV+eF4hE2xrEsg4Sm
         eAJ+OkOfY8+yE82S1x0BQeVMZxBrNeclXYNIuUTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 226/334] hwmon: remove amd_energy driver in Makefile
Date:   Mon, 13 Sep 2021 15:14:40 +0200
Message-Id: <20210913131121.055638654@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit b3a7ab2d4376726178909e27b6956c012277ac4e ]

Commit 9049572fb145 ("hwmon: Remove amd_energy driver") removes the driver,
but misses to adjust the Makefile.

Hence, ./scripts/checkkconfigsymbols.py warns:

SENSORS_AMD_ENERGY
Referencing files: drivers/hwmon/Makefile

Remove the missing piece of this driver removal.

Fixes: 9049572fb145 ("hwmon: Remove amd_energy driver")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Link: https://lore.kernel.org/r/20210817084811.10673-1-lukas.bulwahn@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index d712c61c1f5e..0241ed84b692 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -45,7 +45,6 @@ obj-$(CONFIG_SENSORS_ADT7462)	+= adt7462.o
 obj-$(CONFIG_SENSORS_ADT7470)	+= adt7470.o
 obj-$(CONFIG_SENSORS_ADT7475)	+= adt7475.o
 obj-$(CONFIG_SENSORS_AHT10)	+= aht10.o
-obj-$(CONFIG_SENSORS_AMD_ENERGY) += amd_energy.o
 obj-$(CONFIG_SENSORS_APPLESMC)	+= applesmc.o
 obj-$(CONFIG_SENSORS_ARM_SCMI)	+= scmi-hwmon.o
 obj-$(CONFIG_SENSORS_ARM_SCPI)	+= scpi-hwmon.o
-- 
2.30.2



