Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79BD450F7B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238964AbhKOSbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:31:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231298AbhKOS3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:29:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4CC163449;
        Mon, 15 Nov 2021 17:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999096;
        bh=NayutYZeqWo/u9MSMrykq4rr4dXgJJ3HDQ7zPnoBxHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVQNGYoym5J8jT5LKdXLhG4TVq+WMUdHgqHnlM97Fcxov9oIsdMY9EpoyfU8NxFs5
         tBAQ2ltMKxCJI20aTYz9+on/Dx7O4TGm6V/jTMaZCh/ZJma2dKRfUpqz1P7lIM6PVP
         YyaGa7zPqMDeNFvnFbED6diJgOk/+8g0XK7KAW3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.14 141/849] ASoC: tegra: Set default card name for Trimslice
Date:   Mon, 15 Nov 2021 17:53:44 +0100
Message-Id: <20211115165424.899863956@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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


