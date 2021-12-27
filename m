Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F76480055
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbhL0Ppq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:45:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40602 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238709AbhL0PnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:43:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CABD6110F;
        Mon, 27 Dec 2021 15:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A42C36AE7;
        Mon, 27 Dec 2021 15:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619802;
        bh=zVJpEgXkH2YJ5sLva/p5MLmO0vuUn3CiKs+T2C17UxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQa9ef01l/tiwwtyAuDCDIamJctuERZnL1gFjBTh+RTB5EXQRFfcEcty1t6kw/RMX
         F1t5YPlV19zsiP/uMMOPXCGe6qBMQUH5qCg2s+E0GPmZC52nRrvmtoZBg4w9qGhlSb
         oBjK13xFJANXJsIGjWfG2914ofciTS6nJW380OFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Thomas Graichen <thomas.graichen@gmail.com>
Subject: [PATCH 5.15 074/128] ASoC: tegra: Add DAPM switches for headphones and mic jack
Date:   Mon, 27 Dec 2021 16:30:49 +0100
Message-Id: <20211227151333.969110066@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit d341b427c3c3fd6a58263ce01e01700d16861c28 upstream.

UCM of Acer Chromebook (Nyan) uses DAPM switches of headphones and mic
jack. These switches were lost by accident during unification of the
machine drivers, restore them.

Cc: <stable@vger.kernel.org>
Fixes: cc8f70f ("ASoC: tegra: Unify ASoC machine drivers")
Reported-by: Thomas Graichen <thomas.graichen@gmail.com> # T124 Nyan Big
Tested-by: Thomas Graichen <thomas.graichen@gmail.com> # T124 Nyan Big
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20211211231146.6137-1-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra_asoc_machine.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/tegra/tegra_asoc_machine.c
+++ b/sound/soc/tegra/tegra_asoc_machine.c
@@ -116,6 +116,8 @@ static const struct snd_kcontrol_new teg
 	SOC_DAPM_PIN_SWITCH("Headset Mic"),
 	SOC_DAPM_PIN_SWITCH("Internal Mic 1"),
 	SOC_DAPM_PIN_SWITCH("Internal Mic 2"),
+	SOC_DAPM_PIN_SWITCH("Headphones"),
+	SOC_DAPM_PIN_SWITCH("Mic Jack"),
 };
 
 int tegra_asoc_machine_init(struct snd_soc_pcm_runtime *rtd)


