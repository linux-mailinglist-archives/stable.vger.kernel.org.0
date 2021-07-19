Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2687E3CDCC5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbhGSOxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245372AbhGSOmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78FFD6124B;
        Mon, 19 Jul 2021 15:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708102;
        bh=j6Ij0b5nvRXasnWOrQRVVYr1NDjcq+LQJnP1oSila7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFL3n/Htm8tCoU4K1aVRtO6OFGspREkaPiCBKdNsJpelkxasCjACL56DhnGCXtpMY
         J6+6MxWIJ1jl3iImuzXSfJCDXyLR1Erx1XqiltMqz44muJsHgx36R7h2Nv6uwLXS1/
         POHjGgStSbA+rVW4iU4emzZH/rKK65pK+MSuceR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 147/315] ASoC: cs42l42: Correct definition of CS42L42_ADC_PDN_MASK
Date:   Mon, 19 Jul 2021 16:50:36 +0200
Message-Id: <20210719144947.723052110@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
index 3d5fa343db96..72d3778e10ad 100644
--- a/sound/soc/codecs/cs42l42.h
+++ b/sound/soc/codecs/cs42l42.h
@@ -81,7 +81,7 @@
 #define CS42L42_HP_PDN_SHIFT		3
 #define CS42L42_HP_PDN_MASK		(1 << CS42L42_HP_PDN_SHIFT)
 #define CS42L42_ADC_PDN_SHIFT		2
-#define CS42L42_ADC_PDN_MASK		(1 << CS42L42_HP_PDN_SHIFT)
+#define CS42L42_ADC_PDN_MASK		(1 << CS42L42_ADC_PDN_SHIFT)
 #define CS42L42_PDN_ALL_SHIFT		0
 #define CS42L42_PDN_ALL_MASK		(1 << CS42L42_PDN_ALL_SHIFT)
 
-- 
2.30.2



