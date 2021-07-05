Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CF33BC066
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbhGEPfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232651AbhGEPel (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86083619AF;
        Mon,  5 Jul 2021 15:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499077;
        bh=qhTj9uSII5ZOyscOWtIA1ByZou17aKyjeerJ5d4Q/6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ee0w3n/uAhhJgS3K5UD9qVZCANDFnUbewneqjsgAk7+uRnjUmI3O8xTRQBsB5t0Xz
         G4XbyTYJcNd65mYFE7Jk2gs79n5/xWbvJqzIPGhNl1nk6uPYKr8VbBQzLs1sL4tNWp
         A5msFCGOfHwK2I2YzceMZuOLSNW66es3FJW/5zwTenisaZIxiRU9tGLA8tfYulEbau
         yRY3Cyw4szwykFDn5hkG+7hmcLC94BDYFmnQJQakj6gflUH1PP8AsVt6uV8vltgmOi
         AG4S8SIqt1MC4GiYY6saYfTyaWlLCXvodebe88kMr4YbSS9SR4FhfZ02sWTqUjO9EA
         gmdUrd+uf1DTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Borislav Petkov <bp@suse.de>, Tero Kristo <kristo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/17] EDAC/ti: Add missing MODULE_DEVICE_TABLE
Date:   Mon,  5 Jul 2021 11:30:58 -0400
Message-Id: <20210705153114.1522046-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153114.1522046-1-sashal@kernel.org>
References: <20210705153114.1522046-1-sashal@kernel.org>
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
index 324768946743..9ab9fa0a911b 100644
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

