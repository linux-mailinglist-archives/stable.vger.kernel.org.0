Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF2B3BBFC1
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhGEPdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232521AbhGEPcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2D08601FD;
        Mon,  5 Jul 2021 15:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499004;
        bh=SQQGPPye12kX22cjIWmNRAfoJrfFV/8baIFuMBw2IsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h17ZG431NbcLzBhgSJGOcrHoMlIzmhXoeO4vch2RxHjbw9+h7VQnB+m8dl4yhXIcf
         +7/8wIFDda1tV3RkH/7UpXpdDyS47rtqbHMq/PjecnH/ZuQ/9pOacRByZY1jZZDFBD
         3J3906e1rxAcFGaaS8AGZpfh8KD0XgbJQ7bJi3AmzBL1u5rTdCPFmtk+Iw4c2WiZeH
         mMLLwun4IVOhfyet/gi4Hkkc4sLFha3STtNbjXrr/UHgexWthr62UFKGFNJdBgCUjE
         Xc+sdCGMJ1YsvF1HMYtL7kJ4YfZcPFv6pURikGPLLpz7lZ1rLcLsA431V7IcsVCHvu
         EuzixJmQKwgAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Borislav Petkov <bp@suse.de>, Tero Kristo <kristo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/41] EDAC/ti: Add missing MODULE_DEVICE_TABLE
Date:   Mon,  5 Jul 2021 11:29:22 -0400
Message-Id: <20210705153001.1521447-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153001.1521447-1-sashal@kernel.org>
References: <20210705153001.1521447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 0a37f32ba5272b2d4ec8c8d0f6b212b81b578f7e ]

The module misses MODULE_DEVICE_TABLE() for of_device_id tables and thus
never autoloads on ID matches.

Add the missing declaration.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Tero Kristo <kristo@kernel.org>
Link: https://lkml.kernel.org/r/20210512033727.26701-1-cuibixuan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ti_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/ti_edac.c b/drivers/edac/ti_edac.c
index e7eae20f83d1..169f96e51c29 100644
--- a/drivers/edac/ti_edac.c
+++ b/drivers/edac/ti_edac.c
@@ -197,6 +197,7 @@ static const struct of_device_id ti_edac_of_match[] = {
 	{ .compatible = "ti,emif-dra7xx", .data = (void *)EMIF_TYPE_DRA7 },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ti_edac_of_match);
 
 static int _emif_get_id(struct device_node *node)
 {
-- 
2.30.2

