Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E6E5BAAC2
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiIPKZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiIPKXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:23:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4547BB0B24;
        Fri, 16 Sep 2022 03:14:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64F5AB82559;
        Fri, 16 Sep 2022 10:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E79C433D6;
        Fri, 16 Sep 2022 10:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323254;
        bh=hFz289cURpz/2AcKIza+w5U70ny1pNXJNBG5RO5VPdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uru/d+yOyT1LkoB3BLDyeyr8pUsi+XGBOKCqeKpseBItlQmduVuTGS0uUb9c7QEy5
         GJg9qXkO+oE6UPcdXnhtJGp9pFqjqDcfkCgH2j3pXhPNDdlF46B6TRa6tbJcf+T7Ob
         m1a6e3laNuiRZ220515EjeISkZQTAwxmGLlU4KRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 09/38] platform/surface: aggregator_registry: Add support for Surface Laptop Go 2
Date:   Fri, 16 Sep 2022 12:08:43 +0200
Message-Id: <20220916100448.850916681@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



