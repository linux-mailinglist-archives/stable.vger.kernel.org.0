Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D765AC09C
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 20:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbiICSXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 14:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiICSXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 14:23:13 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251C54E628
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 11:23:12 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id k22so5333442ljg.2
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 11:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=6gtWwN5KvU9IWuR5ZpKgCDwZwZnqNeyrwcvUIdz+jaY=;
        b=LEPUPNAMi2iqI2RVL5MmD+Vhyo2bFOoh2I1PDwY5I+g22uYk9sh8gcT2gy7YC8Wxg7
         +yW9s+mwe6ggou6nuxQM58b4qDNTvD5UUag6CY8wt9H4I0LrTUY6qt+eDs7bm0lM/kQ1
         EQbo04NjBOEHnpvplWFsnUdzKSn0on+XBUHBhQ9bmuNGw0uMnc05TjXkPvfKaFn3mI6S
         v9U+Xny1lTA6rHfwTmN3Smm7FqSO0JK7A6/I9O9c8PKeSg8rBTM+xgFWBUbuVh+slqzn
         5ubrqBfoCKNmERyaSmFAzs7Mu8gB9r2/s3U0oexOOsmoTLNXpY6MLipE5NPquD4qGa6e
         amPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=6gtWwN5KvU9IWuR5ZpKgCDwZwZnqNeyrwcvUIdz+jaY=;
        b=nmXGlyrqJBdlkdqouxu6VbNgyA9L0f2cqqPVU1Sh8QRe0ljlQb5e/UeqUBoLkp0Z+/
         1+jq6mmZCILvJiPHJAa4QjK+ww7pRwOeOVvnl1RMwktCK7FtmDYPXu5hws8OPdCXQeuH
         j1xbpTss97eilobQRpwTVLU0IO58/pkPfY35Zz8tPWET0GxlaOwUcgKSKAnmLO0mpGIT
         9IDZSlxZfzvJFtMKQq2lpS66qm1ok3NGJuQ4axUl7SZq1ugrZK49EBHPfaHpUdclNHzs
         JNxnKiojFc33H88oJf8dfhtBMuhKK0gkyPnTQcg9ozAO3lyiV1c37NoNVddJMrm+HKtn
         pE0g==
X-Gm-Message-State: ACgBeo1MuAhNpkYArehbwlu55RlUTXz1v72TkG4xvS/zScVA0LUm7L8H
        gOfVikffteWMJuB3dEMQpRiZmg==
X-Google-Smtp-Source: AA6agR6ktR7QiY+Ib9VNeWxonin7MvXCYfKw8lnVb5swYnKNybAD+WPDB6bHi8SF3stvLux3EOwsEA==
X-Received: by 2002:a2e:9295:0:b0:267:f8f7:2a0f with SMTP id d21-20020a2e9295000000b00267f8f72a0fmr6228268ljh.41.1662229390512;
        Sat, 03 Sep 2022 11:23:10 -0700 (PDT)
Received: from f6a14fef6d45.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id a6-20020a05651c010600b002688cceee44sm609851ljb.132.2022.09.03.11.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 11:23:10 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v4 00/15] can: kvaser_usb: Various fixes
Date:   Sat,  3 Sep 2022 20:23:29 +0200
Message-Id: <20220903182344.139-1-extja@kvaser.com>
X-Mailer: git-send-email 2.37.3
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

This patch series was originally posted by Anssi Hannula [1].
In v2 I rebased and updated some of the patches [2].

Changes in v4:
 - Add Tested-by: Anssi Hannula to
   [PATCH v4 04/15] can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
 - Update commit message in
   [PATCH v4 04/15] can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device

Changes in v3:
 - Rebase on top of commit
   1d5eeda23f36 ("can: kvaser_usb: advertise timestamping capabilities and add ioctl support")
 - Add Tested-by: Anssi Hannula
 - Add stable@vger.kernel.org to CC.
 - Add my S-o-b to all patches
 - Fix regression introduced in
   [PATCH v2 04/15] can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device,
   found by Anssi Hannula [3]

[1]
https://lore.kernel.org/linux-can/20220516134748.3724796-1-anssi.hannula@bitwise.fi
[2]
https://lore.kernel.org/linux-can/20220708115709.232815-1-extja@kvaser.com
[3]
https://lore.kernel.org/linux-can/b25bc059-d776-146d-0b3c-41aecf4bd9f8@bitwise.fi

Anssi Hannula (10):
  can: kvaser_usb_leaf: Fix overread with an invalid command
  can: kvaser_usb: Fix use of uninitialized completion
  can: kvaser_usb: Fix possible completions during init_completion
  can: kvaser_usb_leaf: Set Warning state even without bus errors
  can: kvaser_usb_leaf: Fix TX queue out of sync after restart
  can: kvaser_usb_leaf: Fix CAN state after restart
  can: kvaser_usb_leaf: Fix improved state not being reported
  can: kvaser_usb_leaf: Fix wrong CAN state after stopping
  can: kvaser_usb_leaf: Ignore stale bus-off after start
  can: kvaser_usb_leaf: Fix bogus restart events

Jimmy Assarsson (5):
  can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
  can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event
    to {leaf,usbcan}_cmd_can_error_event
  can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT
  can: kvaser_usb: Add struct kvaser_usb_busparams
  can: kvaser_usb: Compare requested bittiming parameters with actual
    parameters in do_set_{,data}_bittiming

 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  32 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 118 +++-
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 166 ++++--
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 543 ++++++++++++++++--
 4 files changed, 764 insertions(+), 95 deletions(-)

-- 
2.37.3

