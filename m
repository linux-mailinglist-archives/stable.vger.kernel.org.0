Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B5563097B
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbiKSCNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbiKSCMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:12:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48F161777;
        Fri, 18 Nov 2022 18:12:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E3ACACE2349;
        Sat, 19 Nov 2022 02:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABC1C43141;
        Sat, 19 Nov 2022 02:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823928;
        bh=SVxVFJMdTxkytwHAHYD79CQyUxEye1kFmKxTA/Ohvw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dB/w9K3Vlusru/+WQcEnnSx1Ody03ZK74DLOzSR6wWDOgBFK0gLkm1Jtj8C2GjNst
         C0AdzgQLAvxWt/a8dE+vj5qNa+R2BxoNoNNjAmNzbVaZ5pRsFF0Z4Vh+JsFe8ha2VI
         R3CG343P8M8qZIzUkiVBenekUJpMGZo2ykthwo1zZh5WTLf7i8JBdDjD21CN7ClPRA
         TL8+ahjFHPqK4IPr5Wq2WVC3ggGzTbEO0Ndh7gIIiSPnsmqSFhEGi0/98dTSGhBO8F
         p+FoXrMQQ9/YNiIpRSUzOM8RnxAYDS5cSFnvz7aoNgbWJ8kgRTpdS1o9IxnfbJdZS4
         XlmKQXaF09W5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ivan Hu <ivan.hu@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, alex.hung@canonical.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 22/44] platform/x86/intel/hid: Add some ACPI device IDs
Date:   Fri, 18 Nov 2022 21:11:02 -0500
Message-Id: <20221119021124.1773699-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
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

From: Ivan Hu <ivan.hu@canonical.com>

[ Upstream commit a977ece5773b6746b814aac410da4776023db239 ]

Add INTC1076 (JasonLake), INTC1077 (MeteorLake) and INTC1078 (RaptorLake)
devices IDs.

Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
Link: https://lore.kernel.org/r/20221102020548.5225-1-ivan.hu@canonical.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 79cff1fc675c..b6313ecd190c 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -27,6 +27,9 @@ static const struct acpi_device_id intel_hid_ids[] = {
 	{"INTC1051", 0},
 	{"INTC1054", 0},
 	{"INTC1070", 0},
+	{"INTC1076", 0},
+	{"INTC1077", 0},
+	{"INTC1078", 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, intel_hid_ids);
-- 
2.35.1

