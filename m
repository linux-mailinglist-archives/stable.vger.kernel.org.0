Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C382159BB
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbfEGFix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbfEGFiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:38:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44C9A20578;
        Tue,  7 May 2019 05:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207532;
        bh=GWtj5sn6eGmzf83hUA+j2TSsuO+I8LbeQZWZRL+aPgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bng8Se3XXmsuL/dpVF47O7oPGuTlWuVqFhizAI0/DWHl03f4aQPrRvfBo36xL1X2i
         vlgttxBjeI3IM1ezo5Fp7fq4outTFlQmKm5e4PVDuxX35af9pIAhJDftfqxWfhTfV3
         sA2eqr6Tolt9ex6I6VUg9fydBHem+Kg+pmabAM48=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 14/95] clocksource/drivers/oxnas: Fix OX820 compatible
Date:   Tue,  7 May 2019 01:37:03 -0400
Message-Id: <20190507053826.31622-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit fbc87aa0f7c429999dc31f1bac3b2615008cac32 ]

The OX820 compatible is wrong is the driver, fix it.

Fixes: 2ea3401e2a84 ("clocksource/drivers/oxnas: Add OX820 compatible")
Reported-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-oxnas-rps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-oxnas-rps.c b/drivers/clocksource/timer-oxnas-rps.c
index eed6feff8b5f..30c6f4ce672b 100644
--- a/drivers/clocksource/timer-oxnas-rps.c
+++ b/drivers/clocksource/timer-oxnas-rps.c
@@ -296,4 +296,4 @@ static int __init oxnas_rps_timer_init(struct device_node *np)
 TIMER_OF_DECLARE(ox810se_rps,
 		       "oxsemi,ox810se-rps-timer", oxnas_rps_timer_init);
 TIMER_OF_DECLARE(ox820_rps,
-		       "oxsemi,ox820se-rps-timer", oxnas_rps_timer_init);
+		       "oxsemi,ox820-rps-timer", oxnas_rps_timer_init);
-- 
2.20.1

