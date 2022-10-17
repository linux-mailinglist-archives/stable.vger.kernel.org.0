Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B566004DD
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 03:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiJQBig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 21:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiJQBif (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 21:38:35 -0400
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747E532ABC
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 18:38:33 -0700 (PDT)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id 5F24A6010C
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 10:38:32 +0900 (JST)
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 7C1236010B
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 10:38:31 +0900 (JST)
Received: by mail-pg1-f200.google.com with SMTP id h19-20020a63e153000000b00434dfee8dbaso5652566pgk.18
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 18:38:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ejOrPid2iedh5wLBJ+KG54VdJNk7zWaVxWTRB+6s3sk=;
        b=T2nVaw4EB8i40gKOQ2D/slKD9Ifm8MPxJO57+rgcSgazTFkv9tBqtkD1F4nZD1x6uQ
         hnu2gbiiIq5/956XfQMQGC2yaAT+LeruCMbcLrIa31d+Bpvbm8lLVSiLQir6GGkigDST
         y4PkS8+UfR4UIrrbkJKRRAj5R32xHULNNczqVS6z5hl3Ia6jheTqIe3y2NPrrxhHmAFn
         GeW505FtFbDBrA3dDiI9jWYmh1zGmVg8MNmqb0rQb0AA89NPVTPxHlu+kt38WJpTETlT
         RimtKilRlLBbjI4kZFsKjeuSNYqHiNiK5hReR3FQOOpEVhFJlWz9INw4FCsmeWN9q00R
         wk3g==
X-Gm-Message-State: ACrzQf3qmDnFKB/Ti4DCyD2mdQv1FLgRCWCYOEoO9OMUXEnPhIsVij1+
        T3+FhYkfbadzz+7JtfC3hisKeZocmsqeyrN/8gszHmCZlxPYE1SzpAYy8VQBS0WlNnWsX0YQ/AI
        EspNwPui7GN+Z8TRx/e9i
X-Received: by 2002:a17:903:48e:b0:17e:ea4a:394e with SMTP id jj14-20020a170903048e00b0017eea4a394emr9202365plb.48.1665970710533;
        Sun, 16 Oct 2022 18:38:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7VuDJncsqXX+nkIMaBVt5014GXainRn8ZKFtLqWj+pf4REJomD4SNleaWxQ8oERUSmohzSww==
X-Received: by 2002:a17:903:48e:b0:17e:ea4a:394e with SMTP id jj14-20020a170903048e00b0017eea4a394emr9202353plb.48.1665970710261;
        Sun, 16 Oct 2022 18:38:30 -0700 (PDT)
Received: from pc-0115 (76.125.194.35.bc.googleusercontent.com. [35.194.125.76])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709027e4900b00176ea6ce0efsm5318155pln.109.2022.10.16.18.38.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Oct 2022 18:38:29 -0700 (PDT)
Received: from martinet by pc-0115 with local (Exim 4.96)
        (envelope-from <martinet@pc-0115>)
        id 1okF5H-00090e-1D;
        Mon, 17 Oct 2022 10:38:27 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lukas Wunner <lukas@wunner.de>, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Roosen Henri <Henri.Roosen@ginzinger.com>,
        linux-serial@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.10 0/2] Stable 5.10 backport of RS485 initial polarity fix
Date:   Mon, 17 Oct 2022 10:38:06 +0900
Message-Id: <20221017013807.34614-1-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the backport of the RS485 polarity fixes discussed here:
https://lkml.kernel.org/r/20221010085305.GA32599@wunner.de

It fixes RS485 DE initially set wrong on driver init, blocking other
devices from transmitting on the bus.

Mizobuchi-san did the backport and tested on our imx-based platform, but
we do not have any hardware to test other drivers.


The commits also apply cleanly on 5.15, and for 5.19 the second commit
does (first one has already been picked up), but these have not been
tested so would require more checking.

Kernels older than 5.10 do not have this particular polarity inversion
problem and do not need this as far as I can see.
(there might be other problems this addresses that I am not aware of
though)


Thanks,


Lino Sanfilippo (1):
  serial: core: move RS485 configuration tasks from drivers into core

Lukas Wunner (1):
  serial: Deassert Transmit Enable on probe in driver-specific way

 drivers/tty/serial/8250/8250_omap.c |  3 ++
 drivers/tty/serial/8250/8250_pci.c  |  9 +----
 drivers/tty/serial/8250/8250_port.c | 12 +++---
 drivers/tty/serial/fsl_lpuart.c     |  7 ++--
 drivers/tty/serial/imx.c            |  8 +---
 drivers/tty/serial/serial_core.c    | 61 +++++++++++++++++++++++------
 6 files changed, 65 insertions(+), 35 deletions(-)

-- 
2.35.1


