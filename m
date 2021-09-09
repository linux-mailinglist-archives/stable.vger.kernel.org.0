Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74CE404C08
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240613AbhIILza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243171AbhIILx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:53:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E57AE6137F;
        Thu,  9 Sep 2021 11:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187874;
        bh=GwkVGY/SkE9KPdkryB05t9hJVoEYfjl1SB8+N5pGiCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ju4jIkOyeVQqy3eW+TFi9qsnM2OpZU3DP+k18S13nUGVVolIzh7IItozCMMn+Azlc
         +G8t2HXUtHFctU7Fr09azaKa+maoiSFvGBJWmV9vxDZ9vk1WpE9vKMm9Y1FtsGuevZ
         IlOI3edl0Fuzc5sFxEcVLOh5InSQqRDK39GkjJm5K6BvhFk4UO7ga276cfL7XRyXoJ
         5b0krqxGOpt2CAlQ40ZcaBG39bHbHvLyus7FZ9hP4xn+JODYuEKvpK20014GAkN5bk
         UKVs9oEqi409JjrOHDy/UBeOeTiZDdy871EJ6+xN92f/lbcKOo7NfaA0LTCZ7Dzsr3
         wh4Rw43+oMnTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.14 159/252] ACPICA: iASL: Fix for WPBT table with no command-line arguments
Date:   Thu,  9 Sep 2021 07:39:33 -0400
Message-Id: <20210909114106.141462-159-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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

