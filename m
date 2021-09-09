Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045FA4057C0
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353510AbhIINmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349786AbhIIMrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCBB66023D;
        Thu,  9 Sep 2021 11:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188595;
        bh=edGT4Irk0qRRxz1aFw3ZU8mSGoAf1jvEj3/8scOdMvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWOM08obbpocLfZR96bNS4GftxHW1jt8EMmIerJCyLPGbJWKqr6K20TD5ZJ6Sztrk
         AW/4XlNDL78IMSuxW35E4DeW8/U40EuM1G1EYN4pyV81ufhEIGr6rxh7YJS1wsIiZw
         7CeONqFh9nGJ/qH8TwVMx+BcNExx/JncohxdtPcQ1kWglhRflEVQ3mG7JBXHEEaail
         V5IvdzaIBYl5yoL7a06DWwbBCQLpeju1oPOAeMp34JH2ZiZ8OnWkyX8biAEHkC+oJV
         SnuJey0eoFtEUrcMqBWKJHhAPLVMXgo1o62umtbtTivo+1eMX8k09Y5UUxLpYQSYnD
         NJC4UXLgPq3bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.4 069/109] ACPICA: iASL: Fix for WPBT table with no command-line arguments
Date:   Thu,  9 Sep 2021 07:54:26 -0400
Message-Id: <20210909115507.147917-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
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
index 7a58c10ce421..59965982879b 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -671,6 +671,10 @@ struct acpi_table_wpbt {
 	u16 arguments_length;
 };
 
+struct acpi_wpbt_unicode {
+	u16 *unicode_string;
+};
+
 /*******************************************************************************
  *
  * WSMT - Windows SMM Security Migrations Table
-- 
2.30.2

