Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64704405682
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359829AbhIINU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354866AbhIINNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:13:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 186E8632D9;
        Thu,  9 Sep 2021 12:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188906;
        bh=kw+87E31RZ85fYuuhkoeOG4iT5h7BnRknItOmWN+zqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1kQIQDxVxSmABmF+Rl/wjMBsXgf4tYUcxDCEjgK7uxAL74R3q2SltcoXD9dbFOS8
         jpHsKiufqr7Qrb8k7s+x8nkfZS7BdLft81cUS6gBupONG9z/fBjYKfzyfWL6NQ1nFe
         3YXOXTL26iBpyKBCUtcLKS95lnzdcSdw4iOg+DV/GgkSPO+RpagTqABtW9UDDXwEzm
         ONfEgvpMrwJ+sGVeWbvxcluXeaGhZ2JaTTja4XPgyhbv+tnrFgYUGIVxfAEZwuhcX9
         xlvTqqPnXtjzkqLlCnc5I+OMPZDyL1cJXAiXvaHBrmU01LFb6Nq7o+qZSzkPY/GVxj
         kVh10rb0U3jhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.4 24/35] ACPICA: iASL: Fix for WPBT table with no command-line arguments
Date:   Thu,  9 Sep 2021 08:01:05 -0400
Message-Id: <20210909120116.150912-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120116.150912-1-sashal@kernel.org>
References: <20210909120116.150912-1-sashal@kernel.org>
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
index 1df891660f43..81d5ebc886f5 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -738,6 +738,10 @@ struct acpi_table_wpbt {
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

