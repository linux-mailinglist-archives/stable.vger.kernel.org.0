Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087231EE08
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbfEOLQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730171AbfEOLQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:16:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99E5521726;
        Wed, 15 May 2019 11:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918972;
        bh=WZlyFhO+JGQg1hUuKPHTcaSqzz/6BThC/cW0P09xH18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9LwnOu2PJbh3ohnPNh4ZWzsJtnk43Z573+anuTaNLVtZNMnvvc0kHaqfBKxYN0lv
         Yk7jGvlE5pSx/3SCaohrwYpTqnYm1Nlt5TctAHVKBd+9AtIuDr4j80FDdIVWIYNFWp
         +b9OQFyl5KyN83Kw0leRD3zXRFf1IfjOb5PusDcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 019/115] clocksource/drivers/oxnas: Fix OX820 compatible
Date:   Wed, 15 May 2019 12:54:59 +0200
Message-Id: <20190515090700.687086131@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index eed6feff8b5f2..30c6f4ce672b3 100644
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



