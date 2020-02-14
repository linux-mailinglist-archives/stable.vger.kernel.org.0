Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F3115F06E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388567AbgBNRyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:54:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388430AbgBNP6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 693C3206D7;
        Fri, 14 Feb 2020 15:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695880;
        bh=F7yV7B9cZ2IEW8ez9zw43MwkFZxqGIZ/+JFHLnfbauw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mA95CccIbGV+GR3VZwB+Uq7Iqcu7UQ+yqSWp/NSjKuviZXxyVwZezt7snONzSdL3d
         3v93TTvLRNr18yL8Xkz91qm6+sqkN4GRBExr0buP3f59psfTp0rZQLfao2ziRsvEQ+
         LMgOvaV3eQhrGU5INOom23iWGhm5o9iW0zJdV7Ls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 424/542] regulator: core: Fix exported symbols to the exported GPL version
Date:   Fri, 14 Feb 2020 10:46:56 -0500
Message-Id: <20200214154854.6746-424-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit 3d7610e8da993539346dce6f7c909fd3d56bf4d5 ]

Change the exported symbols introduced by commit e9153311491da
("regulator: vctrl-regulator: Avoid deadlock getting and setting the voltage")
from EXPORT_SYMBOL() to EXPORT_SYMBOL_GPL(), like is used for all the core
parts.

Fixes: e9153311491da ("regulator: vctrl-regulator: Avoid deadlock getting and setting the voltage")
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20200120123921.1204339-1-enric.balletbo@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e7d167ce326cb..d015d99cb59d9 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3470,7 +3470,7 @@ int regulator_set_voltage_rdev(struct regulator_dev *rdev, int min_uV,
 out:
 	return ret;
 }
-EXPORT_SYMBOL(regulator_set_voltage_rdev);
+EXPORT_SYMBOL_GPL(regulator_set_voltage_rdev);
 
 static int regulator_limit_voltage_step(struct regulator_dev *rdev,
 					int *current_uV, int *min_uV)
@@ -4035,7 +4035,7 @@ int regulator_get_voltage_rdev(struct regulator_dev *rdev)
 		return ret;
 	return ret - rdev->constraints->uV_offset;
 }
-EXPORT_SYMBOL(regulator_get_voltage_rdev);
+EXPORT_SYMBOL_GPL(regulator_get_voltage_rdev);
 
 /**
  * regulator_get_voltage - get regulator output voltage
-- 
2.20.1

