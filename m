Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3710653B396
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 08:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiFBGa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 02:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiFBGa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 02:30:57 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439B021482B
        for <stable@vger.kernel.org>; Wed,  1 Jun 2022 23:30:56 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id t25so6256457lfg.7
        for <stable@vger.kernel.org>; Wed, 01 Jun 2022 23:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8XhPz4Gv8/7ZV3KWTFvJSchbAkVHeSex6vxp1lgplOo=;
        b=HOt6+Uotnncc9T0QSvHgCEbCbhssg1CaKBumD9mYYHZL+mz5bsWF8XJy6xzLKqkA7a
         n27hzCuCY+9V0FwHT2HCvQ2RFjJvQS7ySm16hqYrDx+aoFlmoWLvx3DgraVJYlnSkccz
         T/FCN41NlByG0+U3co+P1U9B8aTOTqYgH82Vg9W7hi6dl/mkEImRgUE1HX5W8V1wGRvv
         wIH28h3DdlS/wOHlAP9c/PfpYTlEywlWFpihNFBS04BA6Hk6l53OJRYzjjZs8zN3C8zp
         nQlOKTAdtF/j5uawKTsaFx1aOMWVAT/jAdno7DDPhEzG8YDfAf8lW7qq3urQdR0RwfUh
         OWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8XhPz4Gv8/7ZV3KWTFvJSchbAkVHeSex6vxp1lgplOo=;
        b=xcp/Xss2XOD1Sc/7aEqTtVOIREYHsTbQFpnF4dYBc81/MaerTjg/R/r+Uj9Up1iVDX
         5Lk9t7bb2Dxl8KEM48zumgPdqiBOybBBL2ldMe1SAylM00cMaCJiBX0OvvPCQ9RIkTg9
         jg2xhG9EEpB552qkzgJAK7YqHf0LB+JcNY4yrCdsqZaoZduqQhP/ZTS9hoso0FGPgiVq
         b6i41kyPk1I4E/mc/6/copnZjTw8Dm+xLE43cgD4yN/1TKnWA4VgOjkHQfdj9nQ+nVHr
         ossHHNFfVzT6V3RvjS2j+skZ2CQK6uWRY15dG6TSTURkHmjO4QPosW5ccFLL96c3DKD/
         nmXg==
X-Gm-Message-State: AOAM531akKQM2Ksyf85mh6c2tuI2bpINfpfPyvK6Ua57NJHWcbhpPE8i
        Qjj0bkK+N+PuNwqREPEXJE7ogA==
X-Google-Smtp-Source: ABdhPJysyYhq/AcfF04u5vcQTLs7TeevbRVWn2+ZO6iGno2b2N9G0AfqaoBmG3LkqfHrriruNLDmkg==
X-Received: by 2002:a05:6512:31cd:b0:478:7532:3f42 with SMTP id j13-20020a05651231cd00b0047875323f42mr36451981lfe.627.1654151454651;
        Wed, 01 Jun 2022 23:30:54 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id m16-20020a056512115000b00478f2f2f044sm842476lfg.123.2022.06.01.23.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 23:30:53 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 0/2] can: kvaser_usb: CAN clock frequency regression
Date:   Thu,  2 Jun 2022 08:30:29 +0200
Message-Id: <20220602063031.415858-1-extja@kvaser.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When fixing the CAN clock frequency,
fb12797ab1fe ("can: kvaser_usb: get CAN clock frequency from device"),
I introduced a regression.

For Leaf devices based on M32C, the firmware expects bittiming parameters
calculated for 16MHz clock. Regardless of the actual clock frequency.

This regression affects M32C based Leaf devices with non-16MHz clock.

Also correct the bittiming constants in kvaser_usb_leaf.c, where the limits
are different depending on which firmware/device being used.

Once merged to mainline, I'll backport these fixes for the stable kernels.

Jimmy Assarsson (2):
  can: kvaser_usb: kvaser_usb_leaf: Fix CAN clock frequency regression
  can: kvaser_usb: kvaser_usb_leaf: Fix bittiming limits

 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   | 17 ++++
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 20 +++-
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 14 +--
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 95 +++++++++++--------
 4 files changed, 89 insertions(+), 57 deletions(-)

--
2.36.1

