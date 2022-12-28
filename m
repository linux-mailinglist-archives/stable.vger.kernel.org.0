Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3CA6578B8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbiL1Oxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbiL1Ox0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:53:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE96A10064
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:53:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75A5DB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD68C433D2;
        Wed, 28 Dec 2022 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239203;
        bh=ODsTsYmcglnQCN6gjPfBgID3WIYJsMRdwFXk/NMbGIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcJwDngBabtXeyx1vUNZZj/CUtCjqWAIkE83al0SeGbsnU9ue/ZQ3Cw6wXVrpecWG
         /tp0lZ/5aumKJYocL2Om1gp73NbDOUFGP+zCqsLfXjlpJwKQiJh4GXhaTlLjAZO0Of
         VvNuCQyiW/NAJd1hgrVJv45ALtmD/SNBTOhTjVik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Hurley <jahurley@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Shravan Kumar Ramani <shravankr@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/731] platform/mellanox: mlxbf-pmc: Fix event typo
Date:   Wed, 28 Dec 2022 15:34:07 +0100
Message-Id: <20221228144300.607345401@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: James Hurley <jahurley@nvidia.com>

[ Upstream commit b0b698b80c56b0712f0d4346d51bf0363ba03068 ]

Had a duplicate event typo, so just fixed the 1 character typo.

Fixes: 1a218d312e65 ("platform/mellanox: mlxbf-pmc: Add Mellanox BlueField PMC driver")
Signed-off-by: James Hurley <jahurley@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Link: https://lore.kernel.org/r/aadacdbbd3186c55e74ea9456fe011b77938eb6c.1670535330.git.jahurley@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index 65b4a819f1bd..c2c9b0d3244c 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -358,7 +358,7 @@ static const struct mlxbf_pmc_events mlxbf_pmc_hnfnet_events[] = {
 	{ 0x32, "DDN_DIAG_W_INGRESS" },
 	{ 0x33, "DDN_DIAG_C_INGRESS" },
 	{ 0x34, "DDN_DIAG_CORE_SENT" },
-	{ 0x35, "NDN_DIAG_S_OUT_OF_CRED" },
+	{ 0x35, "NDN_DIAG_N_OUT_OF_CRED" },
 	{ 0x36, "NDN_DIAG_S_OUT_OF_CRED" },
 	{ 0x37, "NDN_DIAG_E_OUT_OF_CRED" },
 	{ 0x38, "NDN_DIAG_W_OUT_OF_CRED" },
-- 
2.35.1



