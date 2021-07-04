Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66D43BB258
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhGDXPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232677AbhGDXNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:13:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 884196193E;
        Sun,  4 Jul 2021 23:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440146;
        bh=n/WkJqG640sU3Rw25PR1ZhW2yBejxV5O1AiUCuchfeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRttW0RBhQyCbyi707ftYA6f7o2OEX+oP1TiwZOIMB/HsqJcEHfGmOV4risyVmSgo
         6CPQzFRWr7X5Xkjp5BMiH/kWwSxC3w8uPri2l/gh+i3UJZyedX8JsGAKDlk6Jm8/Qx
         4qj1ZwqtZgVfrF2Z00ibdA1BWIS68ZuOp+I92u/tzrlE6KBurp2TZ1rdIH2GEEql22
         UJCqqg9Vr0LOBcrsodxs0J81QEkEG9R3NMT5oR18NVgT6cG08unf9plT8xvNWZkftA
         jcu1mnBRzdfE3rF4zsnSyVyGBpwoh9F31SWyDzJNW7VuGRSFzJShmav8fgSCFw/EUX
         0fKYI59mazJmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        kernel test robot <lkp@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 46/70] mmc: sdhci-sprd: use sdhci_sprd_writew
Date:   Sun,  4 Jul 2021 19:07:39 -0400
Message-Id: <20210704230804.1490078-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 961470820021e6f9d74db4837bd6831a1a30341b ]

The sdhci_sprd_writew() was defined by never used in sdhci_ops:

    drivers/mmc/host/sdhci-sprd.c:134:20: warning: unused function 'sdhci_sprd_writew'

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210601095403.236007-2-krzysztof.kozlowski@canonical.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-sprd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index 19cbb6171b35..9cd8862e6cbd 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -393,6 +393,7 @@ static void sdhci_sprd_request_done(struct sdhci_host *host,
 static struct sdhci_ops sdhci_sprd_ops = {
 	.read_l = sdhci_sprd_readl,
 	.write_l = sdhci_sprd_writel,
+	.write_w = sdhci_sprd_writew,
 	.write_b = sdhci_sprd_writeb,
 	.set_clock = sdhci_sprd_set_clock,
 	.get_max_clock = sdhci_sprd_get_max_clock,
-- 
2.30.2

