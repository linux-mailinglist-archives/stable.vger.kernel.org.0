Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8F1FCE75
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 20:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKNTJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 14:09:22 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:43007 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfKNTJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 14:09:22 -0500
Received: by mail-il1-f194.google.com with SMTP id n18so6346879ilt.9
        for <stable@vger.kernel.org>; Thu, 14 Nov 2019 11:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aJlTqX3MqyfjXLCncAwsXq4lCz1EaZQPrfo2kGeMxys=;
        b=nMwsgi9Ldl5oVcuBJVDG6vjkLlyAm7KANIbKWmxzWr2ow1HeKmK48ST99X0n+DiSlY
         2OtKaB7zkDvQPL+1a6cEDXYbZhuks0scvxmpVWCOqxl9kE3cZ9SL4vfrU5DMXshAeuTi
         Tb9Xnbuv6AgYw3Mf01HsxRdO3Swt4PnFus7q4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aJlTqX3MqyfjXLCncAwsXq4lCz1EaZQPrfo2kGeMxys=;
        b=TldYuLRKGVkxtJxAfQeptArJKgeqDZzN1eFHnvatZ8GIQciaMZjpHDXPTfbj+L8/wD
         YKEL+vlhJW5OUEIjIoGcnjpT4GOVuZP2nnFR9JSwWXr8HW/eDYuomuqa/YM3Ntd3TZsa
         olYEpCtny9h7vF6hOy2Gn8kMW7oOkZS4RvwAOlOph6hxRBYi8dJxVbPczBm7BTkJf3O5
         01nZmGQpaO12/+GTAsPJPDVecFZOe3aeilTQWeD0GVaWvLS0JiqoAD7EXJW8cxd+QWBF
         nZNB7yinHX1lMaIO19zB22i79GBMu2hO2iEtkcIi1BvGgJh1y3eQSyUQ57nsqh0lLh5J
         1J0w==
X-Gm-Message-State: APjAAAUQJfO2swJa/MS0kQRv3GF99sFndoRevQX7k3Dy4+nfFNBTP8vf
        faTRQ+5X9GLXuns1M95Lz5AIVw==
X-Google-Smtp-Source: APXvYqwe1HDVydnGRLk9ezbGgJTiowfbINKqTqtC5f1FRIEOCuGuQwJ6B0firqVAFlDUi5Vow51/qQ==
X-Received: by 2002:a05:6e02:c8e:: with SMTP id b14mr11794924ile.44.1573758561685;
        Thu, 14 Nov 2019 11:09:21 -0800 (PST)
Received: from localhost ([2620:15c:183:200:2bde:b0e1:a0d8:ffc6])
        by smtp.gmail.com with ESMTPSA id k199sm881586ilk.20.2019.11.14.11.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 11:09:21 -0800 (PST)
From:   Jacob Rasmussen <jacobraz@chromium.org>
X-Google-Original-From: Jacob Rasmussen <jacobraz@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jacob Rasmussen <jacobraz@google.com>,
        Bard Liao <bardliao@realtek.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Oder Chiou <oder_chiou@realtek.com>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        zwisler@google.com, stable@vger.kernel.org
Subject: [PATCH] ASoC: rt5645: Fixed typo for buddy jack support.
Date:   Thu, 14 Nov 2019 12:08:44 -0700
Message-Id: <20191114190844.42484-1-jacobraz@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Had a typo in e7cfd867fd98 that resulted in buddy jack support not being
fixed.

Fixes: e7cfd867fd98 ("ASoC: rt5645: Fixed buddy jack support.")
Cc: <zwisler@google.com>
Cc: <jacobraz@google.com>
CC: stable@vger.kernel.org
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
2.24.0.432.g9d3f5f5b63-goog

