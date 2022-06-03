Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CF553C6F8
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 10:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbiFCIik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 04:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiFCIik (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 04:38:40 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A979232EF1
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 01:38:38 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id s6so11499554lfo.13
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 01:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2TvfjTvRt9uRoKCfxpGhfopJLtmCQ0YbhN1NVB6u/Ek=;
        b=F8Juj52hJryMaE24yeHbpbbrL1F0D50a24RfjvF0hqLygiIlCX8rV+85tGxzVU9cBq
         f3/QjWBiJaSSeRrXyWeU+gLOjhiY1sCt3kGsJI+6QI7mXJezaFLlMHRkc9ATmnpl4w73
         a6OAYJIxJUwgUdxjtAaqmCYYfx9HYqBLl007tCYGZYNUbM/37pav5P4QW7Gvp/+LvXeE
         nasg8d2G1z2b4CeV2+kz6w8Kus5OHUbr0jDTAzZrpikmzz4bC9nqZQJzv2hCTRmHk0u/
         b5OqJIh/b9VRtwotNe68/vDw26JNqXQY0SNcatYfRhw5+WHCOjnN14I1Tf7A8gXcaz1/
         Gxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2TvfjTvRt9uRoKCfxpGhfopJLtmCQ0YbhN1NVB6u/Ek=;
        b=T1vJsfMJNen1b2vg6X1/TPaqEl17dh+we02cot8OHyKlIWxSoLw4VczbntDOyfAMzQ
         OrOxmqDCjq4OjWDZlQPC+BYMV3lPfh+Z1CiJWtOurTjMDi0019laQkndzPEdi5cFjFie
         akHpcdHs2qpv8VWl27FVnUpdBfE0VlaC3DIjnrwrs+24XuD90Uksm8/1VXqhJdFutsHO
         fl57eo+/4QvEG5fJTbqIBjJEaL2FXJFajRbnx2KecEB0D+7X2CPU1e6GA4sxbf0C52uf
         5qbi0/3krmmo/bSM1FdW3R1WewXr+29euStMERR8QntjsJYf5ZIcjVXjYRQhFJ7aAI/1
         qkbw==
X-Gm-Message-State: AOAM531JHRC/uXA9Jrin4s/kPjJfY5T8sW4z9pxFurtgzPuSmS3FqKOk
        GwbMCcLuWBS1fpOwJ6achrOczw==
X-Google-Smtp-Source: ABdhPJxrI4fSw0964Upbm0C9DnkNJ0Yge4TBiiE6HqMNfddhnRJn4GFPWJaGx0PYuS+3dbL4u2kWzQ==
X-Received: by 2002:a05:6512:22cf:b0:478:e9b2:7957 with SMTP id g15-20020a05651222cf00b00478e9b27957mr6083444lfu.576.1654245516978;
        Fri, 03 Jun 2022 01:38:36 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id g28-20020a2eb5dc000000b00253dfbe2522sm1169898ljn.100.2022.06.03.01.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 01:38:36 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v2 0/3] can: kvaser_usb: CAN clock frequency regression
Date:   Fri,  3 Jun 2022 10:38:17 +0200
Message-Id: <20220603083820.800246-1-extja@kvaser.com>
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

Changes in v2:
  - Add struct kvaser_usb_driver_info as suggested by Marc Kleine-Budde [1],
    instead of adding dev->card_data.quirks.

[1] https://lore.kernel.org/linux-can/20220602063031.415858-1-extja@kvaser.com/T/#maf9cd66c368ce43eb509a27c69d0323cfc776809

Jimmy Assarsson (3):
  can: kvaser_usb: Replace run-time checks with struct
    kvaser_usb_driver_info
  can: kvaser_usb: kvaser_usb_leaf: Fix CAN clock frequency regression
  can: kvaser_usb: kvaser_usb_leaf: Fix bittiming limits

 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  73 ++++-
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 253 +++++++++---------
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c |  14 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 119 ++++----
 4 files changed, 255 insertions(+), 204 deletions(-)

-- 
2.36.1

