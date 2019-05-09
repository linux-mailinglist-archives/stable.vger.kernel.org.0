Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 787E819287
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbfEISou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbfEISot (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:44:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAF86217D6;
        Thu,  9 May 2019 18:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427489;
        bh=R0xt+Mboz/16FYJp6o4XhcEQyCvEqcf/6RPQv/EjdVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqO4aO3vH0ILK/rVsgxtKhO9ZeRi21vXaU+KruIdxO74HVm12oIcrGrtc6uXoIEJY
         9gac5jtf08Q7CH/PtqUdSmH8lzmvGjKiRWdxWkOk3PzV7FgFP2WeHdzpjl1+UKfz/o
         rSl8BKMg9roj1MXIziyIdE2r/aJ/Q9DcWrwMNCwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Annaliese McDermond <nh6z@nh6z.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 08/28] ASoC: tlv320aic32x4: Fix Common Pins
Date:   Thu,  9 May 2019 20:42:00 +0200
Message-Id: <20190509181251.995196533@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181247.647767531@linuxfoundation.org>
References: <20190509181247.647767531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c63adb28f6d913310430f14c69f0a2ea55eed0cc ]

The common pins were mistakenly not added to the DAPM graph.
Adding these pins will allow valid graphs to be created.

Signed-off-by: Annaliese McDermond <nh6z@nh6z.net>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 28fdfc5ec5443..c27e3476848a8 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -316,6 +316,8 @@ static const struct snd_soc_dapm_widget aic32x4_dapm_widgets[] = {
 	SND_SOC_DAPM_INPUT("IN2_R"),
 	SND_SOC_DAPM_INPUT("IN3_L"),
 	SND_SOC_DAPM_INPUT("IN3_R"),
+	SND_SOC_DAPM_INPUT("CM_L"),
+	SND_SOC_DAPM_INPUT("CM_R"),
 };
 
 static const struct snd_soc_dapm_route aic32x4_dapm_routes[] = {
-- 
2.20.1



