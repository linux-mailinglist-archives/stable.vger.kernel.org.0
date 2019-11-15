Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34BCFDDBA
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 13:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfKOM0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 07:26:23 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:32878 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfKOMZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 07:25:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=immwQu1s4GLBl9d9SM1DbC/YW1vUXocvDwY8FGJGiCY=; b=oR82FhYFqr8f
        xA0DUVdcDhwNVB50yvpHL96TcDazahN8+TjfNU/B6JlWJL8VDX3jY4nIJN0tBhdxqxvpm2UUglRbA
        ZoSBmDkdZ4I3hNBa9y8CQA2vrHtNFJlAHcox8I+Jt6wpQ+aUIFsW9FD2yWgLmJ5bz4jC5HJDPFayN
        nB09c=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iVaes-0000Jz-1K; Fri, 15 Nov 2019 12:25:02 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 64F8E2741609; Fri, 15 Nov 2019 12:25:01 +0000 (GMT)
From:   Mark Brown <broonie@kernel.org>
To:     Jacob Rasmussen <jacobraz@chromium.org>
Cc:     alsa-devel@alsa-project.org, Bard Liao <bardliao@realtek.com>,
        Jacob Rasmussen <jacobraz@google.com>, <jacobraz@google.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Oder Chiou <oder_chiou@realtek.com>,
        Ross Zwisler <zwisler@google.com>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.com>
Subject: Applied "ASoC: rt5645: Fixed typo for buddy jack support." to the asoc tree
In-Reply-To: <20191114232011.165762-1-jacobraz@google.com>
X-Patchwork-Hint: ignore
Message-Id: <20191115122501.64F8E2741609@ypsilon.sirena.org.uk>
Date:   Fri, 15 Nov 2019 12:25:01 +0000 (GMT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: rt5645: Fixed typo for buddy jack support.

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-5.4

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From fe23be2d85b05f561431d75acddec726ea807d2a Mon Sep 17 00:00:00 2001
From: Jacob Rasmussen <jacobraz@chromium.org>
Date: Thu, 14 Nov 2019 16:20:11 -0700
Subject: [PATCH] ASoC: rt5645: Fixed typo for buddy jack support.

Had a typo in e7cfd867fd98 that resulted in buddy jack support not being
fixed.

Fixes: e7cfd867fd98 ("ASoC: rt5645: Fixed buddy jack support.")
Signed-off-by: Jacob Rasmussen <jacobraz@google.com>
Reviewed-by: Ross Zwisler <zwisler@google.com>
Cc: <jacobraz@google.com>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191114232011.165762-1-jacobraz@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/codecs/rt5645.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 902ac98a3fbe..19662ee330d6 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3271,7 +3271,7 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 				    report, SND_JACK_MICROPHONE);
 		return;
 	case 4:
-		val = snd_soc_component_read32(rt5645->component, RT5645_A_JD_CTRL1) & 0x002;
+		val = snd_soc_component_read32(rt5645->component, RT5645_A_JD_CTRL1) & 0x0020;
 		break;
 	default: /* read rt5645 jd1_1 status */
 		val = snd_soc_component_read32(rt5645->component, RT5645_INT_IRQ_ST) & 0x1000;
-- 
2.20.1

