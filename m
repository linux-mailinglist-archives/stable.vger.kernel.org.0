Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F31749BC60
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiAYTm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiAYTmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:42:39 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FE6C061747;
        Tue, 25 Jan 2022 11:42:37 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id g20so1006901pgn.10;
        Tue, 25 Jan 2022 11:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64JkX+S1olA3Lwzfo0roarcnEBwBZP0WFc1vdxdvAQ8=;
        b=mpIurYUZAM4amKCDAJR1uTGUixkJnXvVc7yTI9ms62Lqu4hXki88xnOQF+0T1zo2K7
         gmvCwimY+E/8RkATt1slT5Kxr/TZirqXE2iV4REDxrQc4sz/PQApvA4uCrVEdFSIuhhO
         26wM/Nn14Vi+TV1X6rVBw35wgEUHtXj75fIjeGI2ONtSn2ftTebXBaaGa10cVff6CZ4r
         FSztfu3f4BPuFyz3rlSCQxgw4XIenNlYdQ4ZdBiflwEgw/pTu5zv3YIvQRRCdydW6Fx6
         eXIpvn9jeQh8vOO/DpyTPXzDiS4N4yPKWMMzc+/YnP6HufTCrGWNgJy0uC/wn80qaNXY
         fxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64JkX+S1olA3Lwzfo0roarcnEBwBZP0WFc1vdxdvAQ8=;
        b=PnVeZ1XSd2yniEUP4dfKsTmiBFc4hMi5sH/thHJcuTlmPsQuZG/leG0y9gkMuavKeB
         WHUP3ihCudi7kOPK6AUDzDwKsus+X4AaU5mq+Ef6VM0WhVQk7s0Lo+bEcjcB6nKzaibl
         CCrMHpxdaygyLZK+3+0oT+O5WJuXbM00cpwzSq3ZGBwKPP5/G21FeItkoTrqRJ0ml0Xd
         RxuuHuLw+ZCxSAMXQRk/IZGL3yIJpHlYkF6luo1FMIL+6UwoFzbmYvhnvkTOOD+b/yjc
         POMpG4z0itJnmnRmKfpcs5pTbcfc86vMHzIoOlf8Xg9SNHhQ4rQxyAFWm3Ofrd8Pa7aE
         HTrg==
X-Gm-Message-State: AOAM533B9g17mEYBbDpP/AdQYTtOfk/+75Hpd1Chggo6HfjoJyvl8cJg
        numlWO8FaA1CYdev+aCGulDsZKM/NPs=
X-Google-Smtp-Source: ABdhPJwTHXSEy6b/U9jnjefmpyeh3wMALUohR3ey84CK4LtZNpT1Eu98k1J4GqT7nYM7tq98Tx7jpA==
X-Received: by 2002:a63:2210:: with SMTP id i16mr16336467pgi.532.1643139756309;
        Tue, 25 Jan 2022 11:42:36 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a1sm15087343pgm.83.2022.01.25.11.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:42:35 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Phil Elwell <phil@raspberrypi.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-gpio@vger.kernel.org (open list:PIN CONTROL SUBSYSTEM),
        linux-rpi-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE)
Subject: [PATCH stable 5.4 4/7] pinctrl: bcm2835: Match BCM7211 compatible string
Date:   Tue, 25 Jan 2022 11:42:19 -0800
Message-Id: <20220125194222.12783-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220125194222.12783-1-f.fainelli@gmail.com>
References: <20220125194222.12783-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 562c856f96d22ef1204b0a314bc52e85617199b4 upstream

The BCM7211 SoC uses the same pinconf_ops as the ones defined for the
BCM2711 SoC, match the compatible string and use the correct set of
options.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20200531001101.24945-4-f.fainelli@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 061e70ed17a7..e763c680b9c2 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1134,6 +1134,10 @@ static const struct of_device_id bcm2835_pinctrl_match[] = {
 		.compatible = "brcm,bcm2711-gpio",
 		.data = &bcm2711_plat_data,
 	},
+	{
+		.compatible = "brcm,bcm7211-gpio",
+		.data = &bcm2711_plat_data,
+	},
 	{}
 };
 
-- 
2.25.1

