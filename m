Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A84A4090E4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243745AbhIMN4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245357AbhIMNyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:54:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4B576113E;
        Mon, 13 Sep 2021 13:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540113;
        bh=qfLG/+uYzBK2kpN4pN92bya68ASLApMwVowqFUntsCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sejJO44BrOCaQpTg1tGiy5qwfm9moQev/bhoVSSkODeVaphH+mfCCtlRa1rnbBPqE
         u2MZcv5rZe4LJ7OvZ6mTDTTrYl+hB6Wzo77SaGmg8op+5Ui3R2u8J1RddM8p8k2hkO
         b2VjHvF9ZMstCTVMuN3WMrpyOR1NVPrJ0fieap1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 024/300] power: supply: max17042_battery: fix typo in MAx17042_TOFF
Date:   Mon, 13 Sep 2021 15:11:25 +0200
Message-Id: <20210913131110.122633042@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit ed0d0a0506025f06061325cedae1bbebd081620a ]

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17042_battery.c | 2 +-
 include/linux/power/max17042_battery.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index ce2041b30a06..215e77d3b6d9 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -748,7 +748,7 @@ static inline void max17042_override_por_values(struct max17042_chip *chip)
 	struct max17042_config_data *config = chip->pdata->config_data;
 
 	max17042_override_por(map, MAX17042_TGAIN, config->tgain);
-	max17042_override_por(map, MAx17042_TOFF, config->toff);
+	max17042_override_por(map, MAX17042_TOFF, config->toff);
 	max17042_override_por(map, MAX17042_CGAIN, config->cgain);
 	max17042_override_por(map, MAX17042_COFF, config->coff);
 
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index d55c746ac56e..e00ad1cfb1f1 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -69,7 +69,7 @@ enum max17042_register {
 	MAX17042_RelaxCFG	= 0x2A,
 	MAX17042_MiscCFG	= 0x2B,
 	MAX17042_TGAIN		= 0x2C,
-	MAx17042_TOFF		= 0x2D,
+	MAX17042_TOFF		= 0x2D,
 	MAX17042_CGAIN		= 0x2E,
 	MAX17042_COFF		= 0x2F,
 
-- 
2.30.2



