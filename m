Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3105538EB6C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhEXPC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233179AbhEXPAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:00:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 429F161469;
        Mon, 24 May 2021 14:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867799;
        bh=qAcEArfJowDiphG82Df+QPZjdC+ibKj+ovBM/xfGHbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWuVgL5NgUqqRbm3/AYMyxgXfOW4CfNlTAadjhN8+5M+mAx1OdIQnso85SjqtdouN
         0G3UP+t0vKiRB8zamQGuesue9x2sSXj6Ld6N3yo5FL7VmSBd11WCo4dMchrVqPQxve
         reanFg57CqAdk/wosT1XBC2HTgpykoCRohZI6h5qQOO/fOPHybb7qgC/+O649NOWHw
         EMXGnW6NTVrqLfRuo20/F4LiZeFVOXCVuo7i8xE9IpW4l9zLbqlbay5JsIGb4jWVj8
         wzNsR5PWwMtbW4Hlny9cOcx5YE/4qWr2F8yUJWgm4NQhThPNpNEBpPBmUp2xcj58L3
         9JHaZl5byoeqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 46/52] platform/x86: intel_punit_ipc: Append MODULE_DEVICE_TABLE for ACPI
Date:   Mon, 24 May 2021 10:48:56 -0400
Message-Id: <20210524144903.2498518-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit bc1eca606d8084465e6f89fd646cc71defbad490 ]

The intel_punit_ipc driver might be compiled as a module.
When udev handles the event of the devices appearing
the intel_punit_ipc module is missing.

Append MODULE_DEVICE_TABLE for ACPI case to fix the loading issue.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210519101521.79338-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_punit_ipc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel_punit_ipc.c b/drivers/platform/x86/intel_punit_ipc.c
index fa97834fdb78..ccb44f2eb240 100644
--- a/drivers/platform/x86/intel_punit_ipc.c
+++ b/drivers/platform/x86/intel_punit_ipc.c
@@ -328,6 +328,7 @@ static const struct acpi_device_id punit_ipc_acpi_ids[] = {
 	{ "INT34D4", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(acpi, punit_ipc_acpi_ids);
 
 static struct platform_driver intel_punit_ipc_driver = {
 	.probe = intel_punit_ipc_probe,
-- 
2.30.2

