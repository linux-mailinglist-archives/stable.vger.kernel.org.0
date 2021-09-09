Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8231405643
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356837AbhIINTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358652AbhIINJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05211632AA;
        Thu,  9 Sep 2021 12:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188858;
        bh=g/nPY3ZDoXclTMFRBvIEb8zHry+e4YgWYfCi5WeYZwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0RxWgZW8TS4pmT34jwXxNT+FBN86gn2vwCvrDOuTE0jeR/pdGwRqqAt/NmyLktuQ
         +6xZQy4xIjNrZEWYecByZxUAEzxWX0yADPQ1eQoDuIsvx7pkVOLB5kQd9h2xq2++o3
         Ggds6SJQkDNEr9B0o2xvvK6rRl+fWNh1r+cHZYee9JY08e/XPh92LzK8t6D+t77ij0
         aIjsO1cq1oCGIGq/qctDRr7ORvcU4WCU8g9PQyOAXpR8RvZdLFBBldTi00OhgKF0Eo
         GDzozwjB/0iSsZ/V0+L+yQj8Pc5iCvBQZtKCLsBCuUr1Rvdd9SX6GuXRK1ujoCKmwJ
         ykUQ4hrm+wq8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.9 34/48] ACPICA: iASL: Fix for WPBT table with no command-line arguments
Date:   Thu,  9 Sep 2021 08:00:01 -0400
Message-Id: <20210909120015.150411-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
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
index ebc1f4f9fe66..1a503ac15caf 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -764,6 +764,10 @@ struct acpi_table_wpbt {
 	u16 arguments_length;
 };
 
+struct acpi_wpbt_unicode {
+	u16 *unicode_string;
+};
+
 /*******************************************************************************
  *
  * XENV - Xen Environment Table (ACPI 6.0)
-- 
2.30.2

