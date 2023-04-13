Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337916E0442
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjDMChc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjDMCg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:36:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F0672BB;
        Wed, 12 Apr 2023 19:36:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BEC463919;
        Thu, 13 Apr 2023 02:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0867BC433D2;
        Thu, 13 Apr 2023 02:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353396;
        bh=OEalqhz3jQJi98FXcA5XLhVknsL3nGukl8irN8JTk60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7SmN1s55y6WxOUBahSSkNEzPa5wKYD3cSEYdgmMi7B1UQlmxwc2kzd7lHGpwvEkS
         QJDqGCafpxW/xwjM/PTKbbPg03IK7gQHgqMP9ws0ZWjXlOsMh4HVBZxJIB1GyCzdQx
         6CybOq41qseY8F7RrtIwC2KaeNqbNLb7NvI4cV/mIIg8IV4p57OYVvFzgda4xEhjBc
         mS9+FVtN5asMja58DteAhCQWYB8u/0SA1k9Wj1h1DjilX1WJFGa+F3oUxrmoM8lq1J
         u2RmCzL/9VWQolvRCWlHhNZ110kw4I6H/ddbtCX2rToRneA0iY+ULgU6Zp09nSdLae
         Y4i77nPAuhskg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Asbach <asbachb.kernel@impl.it>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, hmh@hmh.eng.br,
        markgross@kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 15/20] platform/x86: thinkpad_acpi: Add missing T14s Gen1 type to s2idle quirk list
Date:   Wed, 12 Apr 2023 22:35:53 -0400
Message-Id: <20230413023601.74410-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023601.74410-1-sashal@kernel.org>
References: <20230413023601.74410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Asbach <asbachb.kernel@impl.it>

[ Upstream commit 9a469c6dfab38326f99f105386db84230be09ee3 ]

From the commit message adding the first s2idle quirks:

> Lenovo laptops that contain NVME SSDs across a variety of generations have
> trouble resuming from suspend to idle when the IOMMU translation layer is
> active for the NVME storage device.
>
> This generally manifests as a large resume delay or page faults. These
> delays and page faults occur as a result of a Lenovo BIOS specific SMI
> that runs during the D3->D0 transition on NVME devices.

Add the DMI ids for another variant of the T14s Gen1, which also needs
the s2idle quirk.

Link: https://lore.kernel.org/all/20220503183420.348-1-mario.limonciello@amd.com/
Link: https://bbs.archlinux.org/viewtopic.php?pid=2084655#p2084655
Signed-off-by: Benjamin Asbach <asbachb.kernel@impl.it>
Tested-by: Benjamin Asbach <asbachb.kernel@impl.it>
Link: https://lore.kernel.org/r/20230331232447.37204-1-asbachb.kernel@impl.it
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 32c10457399e4..7191ff2625b1e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4478,6 +4478,14 @@ static const struct dmi_system_id fwbug_list[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "20UH"),
 		}
 	},
+	{
+		.ident = "T14s Gen1 AMD",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "20UJ"),
+		}
+	},
 	{
 		.ident = "P14s Gen1 AMD",
 		.driver_data = &quirk_s2idle_bug,
-- 
2.39.2

