Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2384521CF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245596AbhKPBGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245376AbhKOTUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0284463462;
        Mon, 15 Nov 2021 18:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001216;
        bh=NayutYZeqWo/u9MSMrykq4rr4dXgJJ3HDQ7zPnoBxHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=il6ZWDrdl5pafajJ7LS18ypqokE9YrXaoZJzqOQYhsmBTTufeZvYBjKf/V/w3PSdp
         VSsc0sPmkf65ITtBwbRgG2f+mNsSNZO8/o7DO2DvFGgG0JCD2rb0XvC/FA1r4JyQuE
         6UUOR/CnkmCMRTQ4rXtAoUDjE0asqQLLq9lJ4lh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 106/917] ASoC: tegra: Set default card name for Trimslice
Date:   Mon, 15 Nov 2021 17:53:21 +0100
Message-Id: <20211115165432.354614411@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 824edd866a13db7dbb0d8e26d2142f10271b6460 upstream.

The default card name for Trimslice device should be "tegra-trimslice".
It got lost by accident during unification of machine sound drivers,
fix it.

Cc: <stable@vger.kernel.org>
Fixes: cc8f70f56039 ("ASoC: tegra: Unify ASoC machine drivers")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20211024192853.21957-2-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra_asoc_machine.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/tegra/tegra_asoc_machine.c
+++ b/sound/soc/tegra/tegra_asoc_machine.c
@@ -686,6 +686,7 @@ static struct snd_soc_dai_link tegra_tlv
 };
 
 static struct snd_soc_card snd_soc_tegra_trimslice = {
+	.name = "tegra-trimslice",
 	.components = "codec:tlv320aic23",
 	.dai_link = &tegra_tlv320aic23_dai,
 	.num_links = 1,


