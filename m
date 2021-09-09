Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DE24051DA
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352590AbhIIMjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353801AbhIIMe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48AE761B66;
        Thu,  9 Sep 2021 11:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188426;
        bh=gYGP+lBgp+/fJQ0hr24sNsSQuoVa74V7p4oNeSu/hr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5uK/P+ZAzXG5Ndp3vXdxj1WAmuS6BAd4PdRgWsDUknDAFE0Z0Pc7G8gyN7Yl6BOQ
         HTDnhy2FCLHmTQvojgJYrEehtkgUdOgLMKQKg6HB3tc2UAfTOWehC3b1eBfG6kXsbi
         pFeD+pWRJkx71UyNIFB5LXaRyZysaoVl+a5Omryk2z47bRj94t1Pflv4CEm2RbpD0J
         ca9Q7w/HmdY97lY/6nYxIL2S9knYViXHzZpainyMzPw09pOE3ZI34qWlYDsOiNlD/w
         YrJ9SDnCFS+LDpuBVj/2ddXhWksaxnX809SMdavv0G92ppLzcPmPGyyJIhH5hmtjI9
         uam0HJoVCvBtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.10 114/176] ACPICA: iASL: Fix for WPBT table with no command-line arguments
Date:   Thu,  9 Sep 2021 07:50:16 -0400
Message-Id: <20210909115118.146181-114-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index bdcac69fa6bd..5d0583ef5208 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -678,6 +678,10 @@ struct acpi_table_wpbt {
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

