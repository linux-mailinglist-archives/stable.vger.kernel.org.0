Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7991217B2
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbfLPSFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:05:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729792AbfLPSFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:05:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D638D207FF;
        Mon, 16 Dec 2019 18:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519514;
        bh=ysAW0hUIdiYdRVVW3+cTKVdQNlITEJ4JZdJUHVhz7DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RP5EdJh5JbOQN3weob5r7SqFwmrVeyuG5UIPzoPIs2LEOtsusPJU684SHn8gmLa5D
         EyoOn0cAH6PpFJyobTJ4fOA+IUo877da5fSk+7zB+aNra4NfJZRuIeb9BXayPYFM5H
         3r19RGJ2A0kHCnX6sYO81LWVpjziqOwrpMskXEt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Rasmussen <jacobraz@google.com>,
        Ross Zwisler <zwisler@google.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 056/140] ASoC: rt5645: Fixed typo for buddy jack support.
Date:   Mon, 16 Dec 2019 18:48:44 +0100
Message-Id: <20191216174803.554986730@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Rasmussen <jacobraz@chromium.org>

commit fe23be2d85b05f561431d75acddec726ea807d2a upstream.

Had a typo in e7cfd867fd98 that resulted in buddy jack support not being
fixed.

Fixes: e7cfd867fd98 ("ASoC: rt5645: Fixed buddy jack support.")
Signed-off-by: Jacob Rasmussen <jacobraz@google.com>
Reviewed-by: Ross Zwisler <zwisler@google.com>
Cc: <jacobraz@google.com>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191114232011.165762-1-jacobraz@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/rt5645.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3308,7 +3308,7 @@ static void rt5645_jack_detect_work(stru
 				    report, SND_JACK_MICROPHONE);
 		return;
 	case 4:
-		val = snd_soc_component_read32(rt5645->component, RT5645_A_JD_CTRL1) & 0x002;
+		val = snd_soc_component_read32(rt5645->component, RT5645_A_JD_CTRL1) & 0x0020;
 		break;
 	default: /* read rt5645 jd1_1 status */
 		val = snd_soc_component_read32(rt5645->component, RT5645_INT_IRQ_ST) & 0x1000;


