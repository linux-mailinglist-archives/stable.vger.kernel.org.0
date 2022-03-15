Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6BA4DA09B
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 17:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346711AbiCOQ6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 12:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245084AbiCOQ6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 12:58:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F8A57481
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 09:57:07 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mr24-20020a17090b239800b001bf0a375440so2813767pjb.4
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 09:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sZYOe+A3oC1fCNmMc9UqSewRIWLOsh6xjndXGY2xoNQ=;
        b=F66OOnf5YxYSQPa4Ft9NT8XE/vImYLd6gqhpRTNTTxeHTjEhdWe04IgrOtV2rzjDd0
         emgWslL4rZi8lRHu6TJTRTCN58AFPsS98P3xqsNVnmge1OiQr+KLY0fblAda+3L62VJb
         VGCV7Q8WA8oshFXVNK6kzTGveJ87rujbii9Zex/kvMdtTYWvhyJKI8jnrwDuFTW8Ug85
         NCArB/m7jDdcncUxgtGSVzXg+taFwgTviiCrC9oCIKXfluePt1rZ7tyGHB8ygR4mbavZ
         i63EGZYGcwuQV9MYAk6QwuCkgsEZU+0LsL3/0lrJnN9S2q0grSr9aS8LqtSeUwj02JEj
         dYgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sZYOe+A3oC1fCNmMc9UqSewRIWLOsh6xjndXGY2xoNQ=;
        b=xnUH5/B4Pt+gpC8pbfFm3XrFwUMWhlLYsyaRyJPEA2CKt+Z1YxnH7zkI44RUPIjShi
         xtBAdaC+9mrI6Owk/ZeGHAj97otQWsG09Xbz205KpkJOKYve2/SOtxTy2l03qYWpD/oN
         Muy7oIZApfv3NQfrYSfIuXwHqArXNRJ+Fy9MF7ZFOSa8aofFFPlOv6vFXga8XobNh4RW
         31MGdkcYC0pIOM3nd4NwELtv8mR84EdtagOzKTfU28rbz+XEWw48NzcyHQ6kWpgTdGBs
         QUZyxt0LHm1Ua7WrooNLlrA2SNMQiUv6tuTJriZGVk6eUiHNZMN1A8nYOuZ1jdaVLyZu
         qNDg==
X-Gm-Message-State: AOAM533S1gjlboO0KRWNopZee/+tJsZIkik+xSdajBGcAAjQiuuJTXPu
        qXk8dxLpAGWL2mVCqnGtJhY=
X-Google-Smtp-Source: ABdhPJyfChb4/6khUHa/0Gd/YGba2eBXMUPIeZKQ91T5JOQbSyRIJmsREVHsJOK9n+7DxGl8vK4y7w==
X-Received: by 2002:a17:90b:4f8e:b0:1bf:8b95:da05 with SMTP id qe14-20020a17090b4f8e00b001bf8b95da05mr5666557pjb.216.1647363427230;
        Tue, 15 Mar 2022 09:57:07 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:3e36:8008:b94b:774d])
        by smtp.gmail.com with ESMTPSA id l10-20020a056a00140a00b004c55d0dcbd1sm24835809pfu.120.2022.03.15.09.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 09:57:06 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     miquel.raynal@bootlin.com
Cc:     linux-mtd@lists.infradead.org,
        Tokunori Ikegami <ikegami.t@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org
Subject: [PATCH v3 3/3] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Wed, 16 Mar 2022 01:56:07 +0900
Message-Id: <20220315165607.390070-4-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220315165607.390070-1-ikegami.t@gmail.com>
References: <20220315165607.390070-1-ikegami.t@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As pointed out by this bug report [1], the buffered write is now broken on
S29GL064N. The reason is that changed the buffered write to use chip_good
instead of chip_ready. One way to solve the issue is to revert the change
partially to use chip_ready for S29GL064N since the way of least surprise.

[1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/

Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: linux-mtd@lists.infradead.org
Cc: stable@vger.kernel.org
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 8f3f0309dc03..fa11db066c99 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -867,10 +867,20 @@ static int __xipram chip_good(struct map_info *map, struct flchip *chip,
 	return chip_check(map, chip, addr, &expected);
 }
 
+static bool __xipram cfi_use_chip_ready_for_write(struct map_info *map)
+{
+	struct cfi_private *cfi = map->fldrv_priv;
+
+	return cfi->mfr == CFI_MFR_AMD && cfi->id == S29GL064N_MN12;
+}
+
 static int __xipram chip_good_for_write(struct map_info *map,
 					struct flchip *chip, unsigned long addr,
 					map_word expected)
 {
+	if (cfi_use_chip_ready_for_write(map))
+		return chip_ready(map, chip, addr);
+
 	return chip_good(map, chip, addr, expected);
 }
 
-- 
2.32.0

