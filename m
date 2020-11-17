Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DB92B61D4
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731202AbgKQNWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731193AbgKQNWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:22:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B21624686;
        Tue, 17 Nov 2020 13:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619366;
        bh=bl0rta8rZ4nHmfk1/GDLmXaqXmKmzYohkIs5buIPXJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/TzIgDs/MVyF2yocZgj7Yx62fFQlt7O4aSm6s8ow3sDpMMC7CBBxy4gWBVlBeAmZ
         i573ZS3RJBQo99+GZoDbAoIJ1IRih4QJiYeC2cmZrWCvOINjsJAYsow6jZchnve6sK
         HKXwlDlxsBHpQTSQGO/60lTRgBkfN6n12//DsFOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/151] ASoC: codecs: wcd9335: Set digital gain range correctly
Date:   Tue, 17 Nov 2020 14:04:05 +0100
Message-Id: <20201117122122.144631784@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 6d6bc54ab4f2404d46078abc04bf4dee4db01def ]

digital gain range is -84dB min to 40dB max, however this was not
correctly specified in the range.

Fix this by with correct range!

Fixes: 8c4f021d806a ("ASoC: wcd9335: add basic controls")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20201028154340.17090-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index f318403133e96..81906c25e4a87 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -618,7 +618,7 @@ static const char * const sb_tx8_mux_text[] = {
 	"ZERO", "RX_MIX_TX8", "DEC8", "DEC8_192"
 };
 
-static const DECLARE_TLV_DB_SCALE(digital_gain, 0, 1, 0);
+static const DECLARE_TLV_DB_SCALE(digital_gain, -8400, 100, -8400);
 static const DECLARE_TLV_DB_SCALE(line_gain, 0, 7, 1);
 static const DECLARE_TLV_DB_SCALE(analog_gain, 0, 25, 1);
 static const DECLARE_TLV_DB_SCALE(ear_pa_gain, 0, 150, 0);
-- 
2.27.0



