Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B02456C221
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbiGHStA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 14:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239739AbiGHSs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 14:48:59 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A176309
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:48:58 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id o7so8595206lfq.9
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 11:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8rAPQYweY/Yvbw9cJYhSKZPzz+mvOad6dri/BRhoHXA=;
        b=BqHjNfgwPJm2QA7jEcDZq1HyQ0oS5nYrL5rwglcwu7JYu70/jEnqMBH46KPmNC3vg8
         kbY+U9AzC2Vpd4xUpJdxPBXTPpEN2co4lY5tyHjL4PDCDutOJjf5lT2/kC+pVllgzvD4
         QxjBwa4+yXUg7yvUqjAVwcOEGMd9AJrCQktXq0Uac+eElPv7OFSgqtGiw/+H51ZZm/0T
         fK1/OVCZc+S17y6pcoKiFFgcJEHk8NyCBj69DwpL5fYj81j4/U4qWsUkkfGrhCLwJANr
         yQy2AXVR5vXoVWEpNhjRkfm5fA84bepjrayCgMDsERwq/bGwsiZ5utjefII5G9hjiKMG
         tYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8rAPQYweY/Yvbw9cJYhSKZPzz+mvOad6dri/BRhoHXA=;
        b=u0XQEjnpHg6ZSNC8sU48lKGcvlMzXJdx6EHkNLwGEW4T9ASrb0R9mTkEiXY0AH58vR
         VP7WfAhSjV7pwAuWh9xYnXePz73qbAh5XWUWRZjyeSWLYXsT++BNnXB1G8l/+UpOuoR+
         7+58w0k0OYPUuzlrk2u5MfXo4Kh/sjTUIMCyPz5NgGCmbAmQJuQLCEzB+dEL6dkO+wAK
         /bv1nbkGu3Ej0tgtFi8czMuDVascHE3mpq1lznRs+hvGaMGIikswYZ/GfXbxkhPBvYwJ
         s7hvELmYFjlLdnCfbAfIkgPHLKtWUggflVPKG62rt7VQiP7HTi44dSqNmAw2Y5SfK1/B
         V12A==
X-Gm-Message-State: AJIora9RCBjcLGtSgp/Lr7EJceEbIs5LBgV+Eu0I2H8Scd81TSbqeBeL
        L9Z0/mPtMX+xirGhtzJN8qtX5/sD1UiW1A==
X-Google-Smtp-Source: AGRyM1sgIINPFWOoSQkBWkclVFGLDXGwzry5ixJ4F9snj7t7jJAox0XEMWhAd1rUTam5FLydWp6cOQ==
X-Received: by 2002:a05:6512:3b91:b0:47f:769d:4ddc with SMTP id g17-20020a0565123b9100b0047f769d4ddcmr3019155lfv.624.1657306137854;
        Fri, 08 Jul 2022 11:48:57 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id b8-20020a056512218800b0047f7c897b61sm7541684lft.129.2022.07.08.11.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 11:48:57 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 5.15 0/3] can: kvaser_usb: CAN clock frequency regression
Date:   Fri,  8 Jul 2022 20:48:43 +0200
Message-Id: <20220708184846.281174-1-extja@kvaser.com>
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
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 286 ++++++++++--------
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c |   4 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 119 ++++----
 4 files changed, 244 insertions(+), 190 deletions(-)

-- 
2.36.1

