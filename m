Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC8A66CC19
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbjAPRW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbjAPRVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:21:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40752DE67
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:59:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50C2F60F61
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67788C433EF;
        Mon, 16 Jan 2023 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888377;
        bh=RIdrWSLUdogJN2okeNKNzkmbRe0WeVdge4lOZv8yBM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SL4MjCziWw8mFUbrRsaNflsPQQWvTgcfEni4ZH+KCQS+hmjriXLZe7Evs2VNmuyoG
         B5AP11u+oD90nVUC9hFKV9qP0DkLLkDshuKVExS7LsToxoCdJjjRALgMFguW0mtcVV
         OB54AiZbMzdAlyfYt3kO2Z1c1bIg7ZIhH+WmIZV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eran Ben Elisha <eranbe@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 506/521] net/mlx5: Rename ptp clock info
Date:   Mon, 16 Jan 2023 16:52:48 +0100
Message-Id: <20230116154909.825971920@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit aac2df7f022eccb5d117f07b1e231410db1a863a ]

Fix a typo in ptp_clock_info naming: mlx5_p2p -> mlx5_ptp.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Stable-dep-of: fe91d57277ee ("net/mlx5: Fix ptp max frequency adjustment range")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 0fd62510fb27..3ef63103d33f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -395,7 +395,7 @@ static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 
 static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.owner		= THIS_MODULE,
-	.name		= "mlx5_p2p",
+	.name		= "mlx5_ptp",
 	.max_adj	= 100000000,
 	.n_alarm	= 0,
 	.n_ext_ts	= 0,
-- 
2.35.1



