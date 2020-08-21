Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B735024E2A0
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 23:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHUVWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 17:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgHUVWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 17:22:04 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82D4C061573;
        Fri, 21 Aug 2020 14:22:04 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t11so1447725plr.5;
        Fri, 21 Aug 2020 14:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QimYEzUuomzeKu0NnkOLnMzXVUForH/gC/W/tgKlANk=;
        b=eUPfuHlYHn4QUpOqHvIkTvx4flkuFY5SNfF23C0Mzp2BgnP32eQQlaPlWuwmcYdY4j
         J3FTH7/IN3FtAa+S43XPyXJ/zj1i/4//eVGfTMufluAE8M8ZiiC+qsWUTWzULHAR6kM/
         2eCsh2m2yAdVJO0ulJgtnw4VxhtlUyFg9Yh0+L/SHNlZKxRp8Uxkj5nnuDLo+Dhcryyj
         PLB8TnG7WORO0n+kcRWOeVt3S4+yeX+TbmEpH8AMGACTupVHqqbzo1G9QWGfLgipRqAA
         CPkTaoU8kCNtTDO2QL3CpR+ctQuonf8GduPletTvLC14IZyYk9HfH/ZMS5kbnpBum5Q7
         5ZeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QimYEzUuomzeKu0NnkOLnMzXVUForH/gC/W/tgKlANk=;
        b=XJSI+VJSanmBpBZmr0qsZR2ytWC8ilEgMMxsLe1fP4BsjidNd2JkJXlaMesnkd6ZbN
         vSylSuwYxjWUtZpV1XCJJ2DQH7VBzwNDpZdmIRmJQpal2kzdqwzxNr2dIMEz0a08CAaH
         2qUnQsf6xzzGEbqBImT4xF7dzewS3v9LLEi2uBx6kAj0k46bZEs3OOqqnoXKRcaUueFc
         TpjPWFs/UhMnzYCKIT5CHbLmvtIjXfGr9wddQXBRmxUZbNzlaZbUzusZLAu2PTQ2t6kF
         puyUMYa2gjew3EuENBtyu3LGKeVDfz58AxIh3GVhUkYp1xF/chNt9L8mvx2Dfr2Dx8xs
         1zvQ==
X-Gm-Message-State: AOAM532kVG0QnK9VHB4hyUEqWUMDpamO4hPImjUzHN+h/wLdpzjvTtPA
        leO57oTHck6Vi63DhiZ+Vjg=
X-Google-Smtp-Source: ABdhPJwin3w2mHVeJsBaU2ANWx4MczQvrGtxU+UpJumLeadqEZd9WWXaz7Wvn/1uCifDCZ0uW6071g==
X-Received: by 2002:a17:902:b205:: with SMTP id t5mr3932345plr.7.1598044924289;
        Fri, 21 Aug 2020 14:22:04 -0700 (PDT)
Received: from localhost.localdomain.com ([2605:e000:160b:911f:722f:a74:437d:fd3c])
        by smtp.gmail.com with ESMTPSA id d81sm3488611pfd.174.2020.08.21.14.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 14:22:03 -0700 (PDT)
From:   Chris Healy <cphealy@gmail.com>
X-Google-Original-From: Chris Healy <cphealy@gmail.com
To:     srinivas.kandagatla@linaro.org, robh+dt@kernel.org,
        shawnguo@kernel.org, andrew.smirnov@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, stefan@agner.ch,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        festevam@gmail.com
Cc:     Chris Healy <cphealy@gmail.com>
Subject: [PATCH v3 2/2] ARM: dts: vfxxx: Add syscon compatible with OCOTP
Date:   Fri, 21 Aug 2020 14:21:02 -0700
Message-Id: <20200821212102.137991-2-cphealy@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821212102.137991-1-cphealy@gmail.com>
References: <20200821212102.137991-1-cphealy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Healy <cphealy@gmail.com>

Add syscon compatibility with Vybrid OCOTP node. This is required to
access the UID.

Fixes: fa8d20c8dbb77 ("ARM: dts: vfxxx: Add node corresponding to OCOTP")
Cc: stable@vger.kernel.org
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Chris Healy <cphealy@gmail.com>
---
Changes in v2:
 - Add Fixes line to commit message
Changes in v3:
 - Add Reviewed-by tags
---
 arch/arm/boot/dts/vfxxx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index 0fe03aa0367f..2259d11af721 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -495,7 +495,7 @@ edma1: dma-controller@40098000 {
 			};
 
 			ocotp: ocotp@400a5000 {
-				compatible = "fsl,vf610-ocotp";
+				compatible = "fsl,vf610-ocotp", "syscon";
 				reg = <0x400a5000 0x1000>;
 				clocks = <&clks VF610_CLK_OCOTP>;
 			};
-- 
2.26.2

