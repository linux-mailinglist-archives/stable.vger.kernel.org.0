Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0963C55A3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhGLIL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353825AbhGLIDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE78661970;
        Mon, 12 Jul 2021 07:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076661;
        bh=+Jwy2Y+r3LS7zrL1B3+VLBIKTSRVLsCphhgnIesgfRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7BPJfR420EGz7CN6BBx+rJ8nRL8NcgO8fBwVFot91lHMrIhRaCXEA5s8/grIfR4+
         nFlEHpMfZDkNcO29TKFjdWQf4T62b1wTfdPX6Bqz5xAu+Ry6sTwe41QrqQURQX6qbL
         23pzr8+ecJu8BP9n/Tp7byMYmAsH32kF04JeH6kQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 738/800] ASoC: atmel-i2s: Set symmetric sample bits
Date:   Mon, 12 Jul 2021 08:12:41 +0200
Message-Id: <20210712061045.259495553@linuxfoundation.org>
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

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit 489a830a25e1730aebf7ff53430c170db9a1771b ]

The I2S needs to have the same sample bits for both capture and playback
streams.

Fixes: b543e467d1a9 ("ASoC: atmel-i2s: add driver for the new Atmel I2S controller")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20210618150741.401739-1-codrin.ciubotariu@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index 584656cc7d3c..48c158535ff6 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -542,6 +542,7 @@ static struct snd_soc_dai_driver atmel_i2s_dai = {
 	},
 	.ops = &atmel_i2s_dai_ops,
 	.symmetric_rate = 1,
+	.symmetric_sample_bits = 1,
 };
 
 static const struct snd_soc_component_driver atmel_i2s_component = {
-- 
2.30.2



