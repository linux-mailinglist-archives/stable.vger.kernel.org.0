Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD68C56C3B7
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbiGHSqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 14:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239656AbiGHSq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 14:46:26 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6863B76EAA
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:46:25 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id q7so4556796lji.12
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 11:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y3gPXAEkv18xbXKqUBZx3ebsYNTyie97iCVskpJUSUA=;
        b=qRrDqp/pAbYlShyDBhh1V0jlAiv42A8ea4bAzGqlaow+34AdwboicBl8XvlQ4j5tKl
         bB9BPhc5COd0G7R1dxZv6Eirzx2lPQmPcZXGC4xqrro58FuIoTJ0up3bv1YMj6AN9Y4/
         W0VpkI/tZ/nerRSmKIT+0SaLbIjMYttvY8CjJ1CFYbhpPgEej6m+gTXK49XO64ZfgCKN
         YQZb6GeT1cijKdzDtGKcZy742M5pdyz+PEUNlVZ9pcFq745QnDpAQ0HWbFsnj7qFupHF
         BMuML1cgr3F1pDvlLa2b9O+IlTxD9L7wyELa3vtw9lEefeSnvsSkKOtdz+kb8lY8kIBP
         xI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y3gPXAEkv18xbXKqUBZx3ebsYNTyie97iCVskpJUSUA=;
        b=dSGnwEuIsmTVpQ4cUuMCdtAJYPiDUrXMbY73I3s4/gniV5y95mTSnBha6/5qrWLiHM
         QFVmcDH709oZYvQn+5qDZMaM0yxs9n79jjPwboE+nlXrzb8VlbezIeA7ytn6GTswuVYG
         DxSSvSn4zLY/U+WTmMBkGWeBdTZaQ2Jk11CJNhlk4CoHIqBnPaF3LIl7Z585pmfTQbQ7
         RJqq6o1ojgWXqcjhHvusk7fLHzwR7E3IEcina0ra0R7hhIvyYF/EvJKEteBegNsKAGOg
         47GpEp7ZOam3l0iuZjhGH9F31Gex54g609YK/tYg0Aywx3EnUDxanfERrNn0iW5GznuI
         LOqg==
X-Gm-Message-State: AJIora/4IusTVWxESnLmNGmn6O2J5aB9ZneGazLWIqXbc45JvfvFcM1o
        ZGjL/TD4gSIq4GFwVnQS4XEhQCXd3/lI1A==
X-Google-Smtp-Source: AGRyM1smPgtVmmvQJY0zs950fbNLF2zTnIjE+k4suN9Ev8Mb/Hvjym1i64+pzo60/QpDUBqqtIiIpQ==
X-Received: by 2002:a2e:91d9:0:b0:25a:6fe6:cc15 with SMTP id u25-20020a2e91d9000000b0025a6fe6cc15mr2660534ljg.187.1657305983763;
        Fri, 08 Jul 2022 11:46:23 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id 23-20020a2e1557000000b0025d4d4b4edbsm1159917ljv.34.2022.07.08.11.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 11:46:23 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 4.9 0/4] can: kvaser_usb: CAN clock frequency regression
Date:   Fri,  8 Jul 2022 20:45:52 +0200
Message-Id: <20220708184556.280751-1-extja@kvaser.com>
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

Note: The patch "[PATCH 4.9 1/4] can: kvaser_usb: Add struct kvaser_usb_dev_cfg"
      is added for this backport, and was not part of the original series.

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

Jimmy Assarsson (4):
  can: kvaser_usb: Add struct kvaser_usb_dev_cfg
  can: kvaser_usb: replace run-time checks with struct
    kvaser_usb_driver_info
  can: kvaser_usb: fix CAN clock frequency regression
  can: kvaser_usb: fix bittiming limits

 drivers/net/can/usb/kvaser_usb.c | 325 +++++++++++++++++++------------
 1 file changed, 201 insertions(+), 124 deletions(-)

-- 
2.36.1

