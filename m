Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3D70AA853
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388642AbfIEQSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:18:21 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:44887 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388504AbfIEQSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:17 -0400
Received: by mail-pf1-f182.google.com with SMTP id q21so2054524pfn.11
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ny7YX6BxIHZBg/a0IXvofczDmYcoW0RMjpIj9iNxGYI=;
        b=YlFW1oYkgedY1H7kdvtntMbQozGn3kOxCMqp2NIumUNGka9YZY56mm/5JnjNo8a6sg
         BpG6Faq+3L6/s3liaVWlfJHdXuBMamArc6Tke+yxoc3WFo/JaJ3GGn7dtJ+2eGI/ZSPm
         WmOtxGPCrHlhUdg0lKZxrCxzFFciRcVyZ4C2H/w5nX6/ePlCd5vC7MVmOunp7NW+n+KY
         kwRBcBObjxbXwA0p2AO+21wka8/782dXgpI6hfmtYJ3uAgtu6VJVYXFKQIJ0U+B9Jx+a
         cnY4OkG7/6sBLkpOWgOpybs5Q6WX+6CfltrwCTUB6XO+nb6zY7AjGP6RiFK/d+51XXVM
         jSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ny7YX6BxIHZBg/a0IXvofczDmYcoW0RMjpIj9iNxGYI=;
        b=f46bLWL7BJmk0O++ZSt65lHHh6QSODjQs6hqUUVtRsL+LCJE570CcAYFXE+81d6FCD
         915gn+CqIBPAD664tVohRMS1g5gp+aG6KphQWiHTIvaOIg3uA48UW2jW4NY3B5WX4z9b
         FpHuAC6dhunj2peDH/VyHpRd8PsMZ0UDlOIZ7Ub6v0iT8XtYoiI+oe68Ht9g/4OSWaGG
         1pyqhO8YIlzXv0vdWx4V6O1vJM4aK20jh8yxuH7mhoOjrh7RdGC361mW7mwUWk4BbcsW
         eFCMG99zX8QemyUnyxvXdKAw5JziXeB09KXjWrDfIsPSzY0pZ/UdoxphlCYf8rlPPGZM
         HwAQ==
X-Gm-Message-State: APjAAAXb2ZipL47FuPO1OmZYY7zeTXTkOpmbgsQKUUbEbjuGikKNZpZY
        PWfEerlsyCPVzHr2TzhtXR5d7fcnRNE=
X-Google-Smtp-Source: APXvYqwKA9IK1vUfcaYpjMN+OcoAuPYIhWjw5YDLjt28SgdQJQGNYVmg1+PKFIED4Sz9PCGNnWl8iw==
X-Received: by 2002:aa7:920b:: with SMTP id 11mr4734304pfo.231.1567700296683;
        Thu, 05 Sep 2019 09:18:16 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:16 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 13/18] ASoC: tlv320dac31xx: mark expected switch fall-through
Date:   Thu,  5 Sep 2019 10:17:54 -0600
Message-Id: <20190905161759.28036-14-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>

commit 09fc38c1af4cb888255e9ecf267bf9757c12885d upstream

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 1195220
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 sound/soc/codecs/tlv320aic31xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320aic31xx.c b/sound/soc/codecs/tlv320aic31xx.c
index d3bd0bf15ddb..cc95c15ceceb 100644
--- a/sound/soc/codecs/tlv320aic31xx.c
+++ b/sound/soc/codecs/tlv320aic31xx.c
@@ -941,7 +941,7 @@ static int aic31xx_set_dai_fmt(struct snd_soc_dai *codec_dai,
 	case SND_SOC_DAIFMT_I2S:
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
-		dsp_a_val = 0x1;
+		dsp_a_val = 0x1; /* fall through */
 	case SND_SOC_DAIFMT_DSP_B:
 		/*
 		 * NOTE: This CODEC samples on the falling edge of BCLK in
-- 
2.17.1

