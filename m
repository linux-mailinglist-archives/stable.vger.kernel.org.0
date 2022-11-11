Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6FE62503E
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiKKCeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiKKCeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:34:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBA2F026;
        Thu, 10 Nov 2022 18:33:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 190286199B;
        Fri, 11 Nov 2022 02:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C1FC433C1;
        Fri, 11 Nov 2022 02:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134034;
        bh=K+PxLfZrk+uscT0HgJ1VnwXpGgb/g2yGnLnlZ9mvyFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erfu5rZxE0uYa1hX63ziESplOgQqDSWCIP9gUM9XIt1tyZFoAQTWl3FuWLvnAwETj
         2h4H/3KOBhZrkfQ/vNM4x44LbALq6dUiURzGiBg6OUMpyLKb/Dmqq7m+FGeb7EpxXV
         i+bb/hSjlyoL/3nBNkvj6ZNSt+776Z0uotKJQWqwSVDdQcu5rmN3iA4Ia8VnZSQyi/
         LIMlE7bp9BfzpelBG7x2QQcDaVN2RnzIZ7s87keM/Mzr5CgqwFbIKQSB/MnLxt28l+
         CZpkuQxSb7FrEI7j2xpVNzxtRB9QolubueyRmk+RJ8Jd/7pT1zzsyk81F6H2re4eOw
         GeEx0iQu5llqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Julius Brockmann <mail@juliusbrockmann.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        hdegoede@redhat.com, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 06/30] ACPI: x86: Add another system to quirk list for forcing StorageD3Enable
Date:   Thu, 10 Nov 2022 21:33:14 -0500
Message-Id: <20221111023340.227279-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2124becad797245d49252d2d733aee0322233d7e ]

commit 018d6711c26e4 ("ACPI: x86: Add a quirk for Dell Inspiron 14 2-in-1
for StorageD3Enable") introduced a quirk to allow a system with ambiguous
use of _ADR 0 to force StorageD3Enable.

Julius Brockmann reports that Inspiron 16 5625 suffers that same symptoms.
Add this other system to the list as well.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216440
Reported-and-tested-by: Julius Brockmann <mail@juliusbrockmann.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index d7cdd8406c84..950a93922ca8 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -219,6 +219,12 @@ static const struct dmi_system_id force_storage_d3_dmi[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 14 7425 2-in-1"),
 		}
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 16 5625"),
+		}
+	},
 	{}
 };
 
-- 
2.35.1

