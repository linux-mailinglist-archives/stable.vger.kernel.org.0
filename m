Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31665B48FB
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiIJVQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiIJVQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:16:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F368947B88;
        Sat, 10 Sep 2022 14:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE88CB8093B;
        Sat, 10 Sep 2022 21:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3397C433B5;
        Sat, 10 Sep 2022 21:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844587;
        bh=hFz289cURpz/2AcKIza+w5U70ny1pNXJNBG5RO5VPdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suSPuLN4PNOl22bjsYUqnUMIsW9KhHmLPNc6NZbHsdP9ahXSubXU45EvOAvIHevHt
         JxrWxfBpVlV9mGwtomCAUAEBLtvknpTCgJs5kTnmsKb5INAfehKe8CJEiQ79uXCZC1
         TG5+pV2eqIY3a8xSwaOohArS/ALS31x2hA/SjdGrwDlo84Vg/GBkJvogTJSS5dVLci
         dPKBX+ENtiz/ZbL6opzBTkBAPUId9D50Fv03ERUWV/S88QNhaN0bK7k7kJPJspTFEP
         5gpPt82A0iO9oYDi+vRhGcZMycR06EHBnHHqml1fwIMVYi7SgHkmch7afvup4jpOTQ
         qChZqvedv+2ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 02/38] platform/surface: aggregator_registry: Add support for Surface Laptop Go 2
Date:   Sat, 10 Sep 2022 17:15:47 -0400
Message-Id: <20220910211623.69825-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 84b8e403435c8fb94b872309673764a447961e00 ]

The Surface Laptop Go 2 seems to have the same SAM client devices as the
Surface Laptop Go 1, so re-use its node group.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20220810140133.99087-1-luzmaximilian@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_aggregator_registry.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index ce2bd88feeaa8..08019c6ccc9ca 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -556,6 +556,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Laptop Go 1 */
 	{ "MSHW0118", (unsigned long)ssam_node_group_slg1 },
 
+	/* Surface Laptop Go 2 */
+	{ "MSHW0290", (unsigned long)ssam_node_group_slg1 },
+
 	/* Surface Laptop Studio */
 	{ "MSHW0123", (unsigned long)ssam_node_group_sls },
 
-- 
2.35.1

