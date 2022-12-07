Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A27A645452
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 08:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiLGHCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 02:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiLGHCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 02:02:12 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE70D4E6B6
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 23:02:10 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id kw15so8318285ejc.10
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 23:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g0OMH3/N2QbztcHxPQ3+EuNjD+/CCotRZcAuSRV3UA0=;
        b=mIz+RC10fPjMELBE69bAkZ5I3X0bf4Fa41hQ0qt8UUyco2XxQVQjiCdxDYmuepKzHm
         GjuQ6S9wRaSxglFs9chXFYdxEDMav1G13Re8ipqmppK3l6k9gxCY0I7ERHA2GlUvWZ0I
         UesYr69hikTAePDToZRbypsk7KQUMHRRDbGLLoCfJ5Ia4+7rdPC8nnZA7ozbncZPNpFS
         nc6LRuS3kCfzlfNw2/9PFLiUfHa/7npGQr//NhpGTYK/QCEG7zS/+Qsx660NcP647fxd
         6JEaj9s9pBzmaWgk1Iv/y06TtccSy+EfSLY0j8UDPEmuJY84cHKggqkwiqMonfSDKGtH
         Mfpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g0OMH3/N2QbztcHxPQ3+EuNjD+/CCotRZcAuSRV3UA0=;
        b=kqFkmIxad9QP89zF0c58dBWes6T0daMb2j5/JSf0S7eYo/0bIwha7Nd5zXoLjP357V
         YMpgGf9bEFM7Wj5yG7OLkpryRpo1bdOEzBOdzj7npsg3iBLx0oAlaR+s6Gfmez0ym5Jx
         p3g9gkWdUf4cQP/knoL2t9wgblhBsyhB2asmROE4Zv5iJwMzWcRTD5YFxwJvGbF7j4cW
         yN/FKWbsB88OXv6zKNEtEDlDZPvJSW1m4ExMiVoWAcSBsZhfBqqDP8ZpryL2rogSFvms
         UzFGxhZnr9Y0up0Io1RZgTNSiX2o2dFKP3G3wkOhm1976xFy0LiDHC9c6n0YF2Bytlhb
         VrQA==
X-Gm-Message-State: ANoB5plXGranoSIqZ0Evu45dxN3Z2CY29ZqRfc3rJ19LlDBC62lDsjfQ
        HB/h8OKUd260YDNLzY7DFjM2a7rCHqo=
X-Google-Smtp-Source: AA0mqf6spmqeMaF9o9CMEFtgeZdG4Zda0GgIBPuXc9eo5K8p0tj95QkazQugOIhRr8XMffDBvdc+6Q==
X-Received: by 2002:a17:907:9253:b0:7c0:e984:e74e with SMTP id kb19-20020a170907925300b007c0e984e74emr11476326ejb.238.1670396529268;
        Tue, 06 Dec 2022 23:02:09 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090623e900b007bf24b8f80csm8159881ejg.63.2022.12.06.23.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 23:02:08 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH linux-5.4.y only] Revert "net: dsa: b53: Fix valid setting for MDB entries"
Date:   Wed,  7 Dec 2022 08:01:55 +0100
Message-Id: <20221207070155.12389-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This reverts commit 1fae6eb0fc91d3ecb539e03f9e4dcd1c53ada553.

Upstream commit was a fix for an overlook of setting "ent.is_valid"
twice after 5d65b64a3d97 ("net: dsa: b53: Add support for MDB").

Since MDB support was not backported to stable kernels (it's not a bug
fix) there is nothing to fix there. Backporting this commit resulted in
"env.is_valid" not being set at all.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/b53/b53_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 825d840cdb8c..1458416f4f91 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1551,6 +1551,7 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 
 	memset(&ent, 0, sizeof(ent));
 	ent.port = port;
+	ent.is_valid = is_valid;
 	ent.vid = vid;
 	ent.is_static = true;
 	memcpy(ent.mac, addr, ETH_ALEN);
-- 
2.34.1

