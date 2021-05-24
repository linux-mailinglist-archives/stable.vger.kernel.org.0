Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C2938EC48
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhEXPN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234453AbhEXPHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:07:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F008761625;
        Mon, 24 May 2021 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867888;
        bh=GvlQdk9QCCLzZXEPL977abyqEv1/ZvCdrDypFc/1g1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jW31B/EX9HgrJln2Wqun+MLzPePhBr15S7bbQ3pCjJxQaU5FB22bWDncY6Z2mWVfH
         T/JkRJMz3K2zxL12EphJiyZNnNnuG7IV5YYsCR36303gqgci3UOo0cADLNHMea//qd
         bvI5HLTSqqQ6sSIFG3mFd7sEikpHD01mROd3Cami2wLGaNoEFZJMKgzSLkBFPaReZT
         VM5eq8A454030ucxmGxtiPCSGeePdsgMSS9B2+c6dgvWK0nI7qv5coRxG2GEyjCd/Y
         bwREAFgsOYebWedIR0I0ZBh7pWgF3vST+ypZZtMnXik+sBYyWqCCiUprfH+UaNqGqx
         X5XUyzuZHMxtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 18/19] platform/x86: intel_punit_ipc: Append MODULE_DEVICE_TABLE for ACPI
Date:   Mon, 24 May 2021 10:51:05 -0400
Message-Id: <20210524145106.2499571-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145106.2499571-1-sashal@kernel.org>
References: <20210524145106.2499571-1-sashal@kernel.org>
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
index b7dfe06261f1..9865d11eda75 100644
--- a/drivers/platform/x86/intel_punit_ipc.c
+++ b/drivers/platform/x86/intel_punit_ipc.c
@@ -330,6 +330,7 @@ static const struct acpi_device_id punit_ipc_acpi_ids[] = {
 	{ "INT34D4", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(acpi, punit_ipc_acpi_ids);
 
 static struct platform_driver intel_punit_ipc_driver = {
 	.probe = intel_punit_ipc_probe,
-- 
2.30.2

