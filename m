Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CC2657B97
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbiL1PX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbiL1PXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196E613F55
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8415FCE076E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A17C433D2;
        Wed, 28 Dec 2022 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240996;
        bh=ODsTsYmcglnQCN6gjPfBgID3WIYJsMRdwFXk/NMbGIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGUiALBKENkD+8CkGaOXFgRpXjhQAqUVVg9WGOb8quB4hp8nAilpJwVNYcsv+o1de
         WPC7ECmq9+yIwVOx1BF4DQx4US+Ho12Mqvr8ty3h7GiZNPJqow19UGHR4bGMRONrmf
         y+zdTCXJxpOkuLIVqn+ArLunBhaUvVsB8Bv0OfCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Hurley <jahurley@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Shravan Kumar Ramani <shravankr@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0193/1146] platform/mellanox: mlxbf-pmc: Fix event typo
Date:   Wed, 28 Dec 2022 15:28:52 +0100
Message-Id: <20221228144335.389105088@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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



