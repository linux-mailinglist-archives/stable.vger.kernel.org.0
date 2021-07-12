Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEE33C5594
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhGLILG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353753AbhGLICu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1697F61D05;
        Mon, 12 Jul 2021 07:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076633;
        bh=SQVjfmZXtgb5jgyoYc2W6HhNyxujFa+RVfFV3/w9Cjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4ayX66t7jI4XJODTypB4JNIg2bw+n0WvPrV9bir4CmvmjocxQde2RkQjUjj02ejr
         DBGWs4A6K61a2n/lyBScDoCiPQrzY2BqbENcFrWfAU9Wma1jmYvZbJ+M32CTCtArc/
         knZtH7KYSCzUHOZdm8FdhEvbYW5dEZmWwLr9LAic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 727/800] ASoC: cs42l42: Correct definition of CS42L42_ADC_PDN_MASK
Date:   Mon, 12 Jul 2021 08:12:30 +0200
Message-Id: <20210712061044.140617272@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit fac165f22ac947b55407cd3a60a2a9824f905235 ]

The definition of CS42L42_ADC_PDN_MASK was incorrectly defined
as the HP_PDN bit.

Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210616135604.19363-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l42.h b/sound/soc/codecs/cs42l42.h
index 36b763f0d1a0..386c40f9ed31 100644
--- a/sound/soc/codecs/cs42l42.h
+++ b/sound/soc/codecs/cs42l42.h
@@ -79,7 +79,7 @@
 #define CS42L42_HP_PDN_SHIFT		3
 #define CS42L42_HP_PDN_MASK		(1 << CS42L42_HP_PDN_SHIFT)
 #define CS42L42_ADC_PDN_SHIFT		2
-#define CS42L42_ADC_PDN_MASK		(1 << CS42L42_HP_PDN_SHIFT)
+#define CS42L42_ADC_PDN_MASK		(1 << CS42L42_ADC_PDN_SHIFT)
 #define CS42L42_PDN_ALL_SHIFT		0
 #define CS42L42_PDN_ALL_MASK		(1 << CS42L42_PDN_ALL_SHIFT)
 
-- 
2.30.2



