Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2551544B723
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344507AbhKIWc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344618AbhKIWaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:30:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C75761A78;
        Tue,  9 Nov 2021 22:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496448;
        bh=DYyIzSGTQ8W6spGmBqd+117i5tD1eiwjX3gTuBDc7F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPqaUXvUDMvlmbE99Nj2taaIRsSXyORfr0DA20jU8Ej5lPTfj3Ph1NDQFsxQb+3B4
         EsnCqVTyLLilkjkOvjGJBpqciQlv/fG3VRpEtmdY8U0+1uHi9s3mv23k7MiX/qZjqP
         GjgshVkSh+lDGD7gx8trfm5llc7+CyVUpwk/0eKmdvw0QX6gmu0lg7Tb/m3Iz4pLXT
         Bryh6U1Bues9rNo3e+935e91iExKBmD6aS7jOLlpi86WhbQNMeWrpdFpu6xczUqqwU
         gBW6NxXExHgvdYnzLcw3PkobIFSTH+AJMsu6qxq6z9YTTDSscdm+ckm6HA/ZI2oQYY
         MKFmLya1w6/Bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Nicolas Chauvet <kwizart@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 66/75] memory: tegra20-emc: Add runtime dependency on devfreq governor module
Date:   Tue,  9 Nov 2021 17:18:56 -0500
Message-Id: <20211109221905.1234094-66-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 14b43c20c283de36131da0cb44f3170b9ffa7630 ]

Tegra20 EMC driver uses simple devfreq governor. Add simple devfreq
governor to the list of the Tegra20 EMC driver module softdeps to allow
userspace initramfs tools like dracut to automatically pull the devfreq
module into ramfs image together with the EMC module.

Reported-by: Nicolas Chauvet <kwizart@gmail.com>
Suggested-by: Nicolas Chauvet <kwizart@gmail.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20211019231524.888-1-digetx@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra20-emc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/tegra/tegra20-emc.c b/drivers/memory/tegra/tegra20-emc.c
index c3462dbc8c22b..6fc90f2160e93 100644
--- a/drivers/memory/tegra/tegra20-emc.c
+++ b/drivers/memory/tegra/tegra20-emc.c
@@ -1117,4 +1117,5 @@ module_platform_driver(tegra_emc_driver);
 
 MODULE_AUTHOR("Dmitry Osipenko <digetx@gmail.com>");
 MODULE_DESCRIPTION("NVIDIA Tegra20 EMC driver");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL v2");
-- 
2.33.0

