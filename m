Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1892041A776
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238949AbhI1F51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238920AbhI1F5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDAE461209;
        Tue, 28 Sep 2021 05:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808532;
        bh=o1gLY2ZYXf8+Eu+p/sycKXvaHcg7lgTxIaE2Ew7Y0yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLBflSVduhc5FLwifZfTgHMQhblWooZgKxJvWjZtRz9cjWd1Mb7Fph7l2tG6yPTEK
         58c1UPhnYlpPsXTt9OOrwBe4YIWtTvRrLUT419UCGAF9w7NrUSm0/fw65HEBK7UaeC
         ljmYuL8la9ZLaGbqYg3/uc0yDM5ruvLDcLkK5jN3dOwt86P26QQ7amzRDGFbxPqf3K
         trUj2lteXWuMCmqwQQYp1WrNwRU15qfWG2B/8g1ykcYVcSiB8qxpNBitz3Aqg2tmxv
         abt+K+tBI+HljB3KRGZPWjYH48cBMQo64seiueWTlQ2HF+zCegGPk8NU6eQC1ont7R
         ASXYVYr03Jr8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mgross@linux.intel.com,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 12/40] platform/x86: gigabyte-wmi: add support for B550I Aorus Pro AX
Date:   Tue, 28 Sep 2021 01:54:56 -0400
Message-Id: <20210928055524.172051-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

[ Upstream commit 6f6aab1caf6c7fef46852aaab03f4e8250779e52 ]

Tested with a AMD Ryzen 7 5800X.

Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Acked-by: Thomas Weißschuh <thomas@weissschuh.net>
Link: https://lore.kernel.org/r/20210921100702.3838-1-tjakobi@math.uni-bielefeld.de
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 7f3a03f937f6..d53634c8a6e0 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -144,6 +144,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 GAMING X V2"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550I AORUS PRO AX"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M AORUS PRO-P"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M DS3H"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z390 I AORUS PRO WIFI-CF"),
-- 
2.33.0

