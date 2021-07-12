Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043803C4FE9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343852AbhGLH2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245309AbhGLH1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:27:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F3D06191E;
        Mon, 12 Jul 2021 07:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074621;
        bh=UQIVo70ZbsShv+zHR3rejdXAT6MmymE00uMqykh+ce0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/QfL5q0+ZCb/7oq0UefZ9lHQ1SDEd3U3RtKmsB8UILuaflfJO08bdYU23nd4OoOe
         CoUpdfbwKB8h5zDyde/Y1+Dj4SFqLH2FvNIzM/iNp0GzdDBlEMpyDMnxvWTxsGj2kV
         3ivOwL/xIyDFeEpcpUk4CPYQf04JCPTEW1dxmmSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 642/700] ASoC: atmel-i2s: Set symmetric sample bits
Date:   Mon, 12 Jul 2021 08:12:05 +0200
Message-Id: <20210712061044.193935081@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 7c6187e41f2b..e43acb54296b 100644
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



