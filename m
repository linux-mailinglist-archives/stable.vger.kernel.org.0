Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B53404F96
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240926AbhIIMVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349041AbhIIMQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:16:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9D9F61A35;
        Thu,  9 Sep 2021 11:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188178;
        bh=GwkVGY/SkE9KPdkryB05t9hJVoEYfjl1SB8+N5pGiCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8O55q7C80w8VvEHrLNz1ICCtM3GNXzo2NEo6Cva8TAk3HGCJ91f/UgyquVM5qOX1
         iu7J+FFdIxNPBNMJ+9pXDpS4gjmoZo6fKx7O7n5xA4wwx443xGgWFaJpcI0sY3rTDv
         AO/JbOstdj/0wB9In/LR242ljHxVDRDSrJGdbdq3Apw/5tBR9bL+3QZbln2P/S8MTi
         kJSzlsHBBG4+EjCXFva8SqP5QS8OonWCooozts7qyxZ9xD1euaMuNGs1dyzb0vboVB
         r8cmSOBu7j5DG4Rn2X+m6OAHnnwvyghevirF2I7uaxMBCBOzSdlm0WSb8zv33t00Y5
         LV9mgrPUi3wHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.13 141/219] ACPICA: iASL: Fix for WPBT table with no command-line arguments
Date:   Thu,  9 Sep 2021 07:45:17 -0400
Message-Id: <20210909114635.143983-141-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

[ Upstream commit 87b8ec5846cb81747088d1729acaf55a1155a267 ]

Handle the case where the Command-line Arguments table field
does not exist.

ACPICA commit d6487164497fda170a1b1453c5d58f2be7c873d6

Link: https://github.com/acpica/acpica/commit/d6487164
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/actbl3.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/acpi/actbl3.h b/include/acpi/actbl3.h
index 86903ac5bbc5..9125e2f16329 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -723,6 +723,10 @@ struct acpi_table_wpbt {
 	u16 arguments_length;
 };
 
+struct acpi_wpbt_unicode {
+	u16 *unicode_string;
+};
+
 /*******************************************************************************
  *
  * WSMT - Windows SMM Security Mitigations Table
-- 
2.30.2

