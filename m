Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5426356C339
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239733AbiGHSsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 14:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239731AbiGHSsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 14:48:37 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D2864ED
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:48:36 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id t19so37100931lfl.5
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 11:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NCdrXXw4OIFVN2T2yq7UtG+zJ8BpWvZk3Tva/wkAXMM=;
        b=oyUmWb2U+W6Kf5eSkdf/PaCKsZgMwjbxesppqFvRVos7kKB7Y/WTRNyWy75p1xRNgY
         Tay6T3ESpCN1nga64OewMLU7n84BgDJqkRt3Xr3dXGCZQTenChCXXhhXdn0eGTx905LS
         0ZplMCSAkUYi+MPGzycaybjqYQDd0nRRzPtsrdbPAMC0fx8RwZwxNW8j6gRBgFRrQ2IB
         Swz+iz3QfSCM1SzdvEHilEMvKHfD1xLkHWyeO+9NrhKYXrjCfmViJz0cwn7y05ootKYo
         xVQk6mHk07/4FuEAtX18QTIsqh2TZQZqa+8A7VealE1jtgvvoVU2opBEytdYhbAmKBPy
         Qoxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NCdrXXw4OIFVN2T2yq7UtG+zJ8BpWvZk3Tva/wkAXMM=;
        b=hNvqyLm4JayT640jRD4mv6q557/0t0EaVGeBg7sf6ZDK32GNPNzdBfgkkFr8c3f2IJ
         qqZlY5OoB7KbVK4LJ2SSuIaGMoCsefCCvyxFDGHkzhMytsCmHcecvycFEDFWRpoWg2A8
         5r4+9ZpHXPM/vkgol4JFHi56pCtbxzX1FTeY7bzoyhX2Si8FDezmgCIs0emsy6SGVnSO
         fZqBCDQM2Pld8bYZJTjivBNBKhgAQX7MVMOH18mvqPJxf37gjjnY3TOoOVZkR1q1yw0H
         evyJplUnT2YSAJbiyZGDfsDE5yEmma3xPstVgUl2xSd3AHCzy+t1VHrQUKdSVBuaKwhT
         aXLA==
X-Gm-Message-State: AJIora+J68QkuHUpz/lIc+Py4KToyu5Ccs/9na0zBigj8TFSTVgpuCvX
        9BKaeicQhPv3gqQLgeRhFRsVnHe1SlhJsg==
X-Google-Smtp-Source: AGRyM1uMGSaoEW+MkCg7sQJFyiQeIdk+F/UYka5fX6N/3oLgpcO62efkAFTuULkbizz/sDTeEa8fXA==
X-Received: by 2002:a05:6512:11d2:b0:47f:7ca3:c533 with SMTP id h18-20020a05651211d200b0047f7ca3c533mr3186169lfr.388.1657306114587;
        Fri, 08 Jul 2022 11:48:34 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id u19-20020ac258d3000000b0048639c05ffdsm1618605lfo.107.2022.07.08.11.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 11:48:34 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 5.10 0/3] can: kvaser_usb: CAN clock frequency regression
Date:   Fri,  8 Jul 2022 20:48:16 +0200
Message-Id: <20220708184819.281103-1-extja@kvaser.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport of upstream patch series [1].

When fixing the CAN clock frequency,
fb12797ab1fe ("can: kvaser_usb: get CAN clock frequency from device"),
I introduced a regression.

For Leaf devices based on M32C, the firmware expects bittiming parameters
calculated for 16MHz clock. Regardless of the actual clock frequency.

This regression affects M32C based Leaf devices with non-16MHz clock.

Also correct the bittiming constants in kvaser_usb_leaf.c, where the
limits are different depending on which firmware/device being used.

[1]
https://lore.kernel.org/linux-can/20220603083820.800246-1-extja@kvaser.com/

Jimmy Assarsson (3):
  can: kvaser_usb: replace run-time checks with struct
    kvaser_usb_driver_info
  can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
  can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits

 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  25 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 255 ++++++++++--------
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c |   4 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 119 ++++----
 4 files changed, 226 insertions(+), 177 deletions(-)

-- 
2.36.1

