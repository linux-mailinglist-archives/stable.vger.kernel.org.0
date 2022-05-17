Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D9452AA26
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348560AbiEQSJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351885AbiEQSJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:09:16 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543454EF70;
        Tue, 17 May 2022 11:09:15 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so2318909pjb.1;
        Tue, 17 May 2022 11:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sk+5mSaR9rPPKXkfYc0/VsJM1xTQzkpsddohoa/KxaY=;
        b=iGPK/GwXeGKXb+JpJA46iSyhnPvw8ykFkQnXHIOb+nnJMZMZNEpCOO5aAaPTON9dL0
         /arpk5OBwqIkFqJYwu8moP1z3ie3HWE4S9Su3w+237xAGMDlSsrMPNk684b19W459JFh
         TeukQRXDrrk607aSndZ/R1d9EAiqRw/hzyxU+Bl78iiOCytDyNbfOmVKdwl9G9ZbtL94
         IT2LRNjS3SgdiT5EcB4zjn0d1SS6f3ngmYD2l7LVkaXOxa8kYtEBKXCdxZUYp3Z5Nw4M
         5B/QLrscfUylDB+CXuodZ4cgJAjI57t7M+Zb171soqJXr+iVLY4nd84qfn9iB26jTmyv
         Rc/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sk+5mSaR9rPPKXkfYc0/VsJM1xTQzkpsddohoa/KxaY=;
        b=trBJ58vCc0eRdjN/MnvENKhAbmz51iysFfGD6wnGvZoajGGbM4wjrdtZV/ibi/lzC9
         QsSrKtnTykuyROV2rPU49Gw+ny8yRXbe3BFphoGH7CtegBygNd1K9ZsqsyWfBBG0MmdP
         7b938tlhC90W3BUfMpcnUPbGfxFBQ+A6gLV5xtDkMm8xeyv3qUWM1JsdEAxxwIaQ6PDg
         m+fIMVblpusTBUd63m8EHX6eBUTobiuDqcUw60hrxCoJp41VU9wiAJpsPHctQkVlOm+H
         Ep7RMiPFH2rP6K94xgUfd7PlqgFzIHDWnyMV/SFlKKud46uqQHo0jMxDA+vJToKYzNIC
         Km+w==
X-Gm-Message-State: AOAM533xzE7adj4MSwESiUwG6Yxhr4P1Qeeuw6GhXthsPJsqdVCa5BQn
        7L/n2H0cBhYqeExqAXkKjMacBd8Jt4Q=
X-Google-Smtp-Source: ABdhPJzpEwYEZEmjNkNxL3JHREQJ8h2a9XP7Q653MwGhOMDaN/ejTYzEuPprsM0feUFY+7Epvc+R8g==
X-Received: by 2002:a17:90a:7e94:b0:1da:3b47:b00e with SMTP id j20-20020a17090a7e9400b001da3b47b00emr38237513pjl.222.1652810954452;
        Tue, 17 May 2022 11:09:14 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5-20020a056a00224500b0050dc7628160sm46854pfu.58.2022.05.17.11.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:09:14 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        =?UTF-8?q?Christian=20L=C3=B6hle?= <CLoehle@hyperstone.com>,
        linux-mmc@vger.kernel.org (open list:MULTIMEDIA CARD (MMC), SECURE
        DIGITAL (SD) AND...), linux-kernel@vger.kernel.org (open list),
        alcooperx@gmail.com, kdasu.kdev@gmail.com
Subject: [PATCH stable 5.4 0/3] MMC timeout back ports
Date:   Tue, 17 May 2022 11:09:08 -0700
Message-Id: <20220517180911.246016-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
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

These 3 commits from upstream allow us to have more fine grained control
over the MMC command timeouts and this solves the following timeouts
that we have seen on our systems across suspend/resume cycles:

[   14.907496] usb usb2: root hub lost power or was reset
[   15.216232] usb 1-1: reset high-speed USB device number 2 using
xhci-hcd
[   15.485812] bcmgenet 8f00000.ethernet eth0: Link is Down
[   15.525328] mmc1: error -110 doing runtime resume
[   15.531864] OOM killer enabled.

Thanks!

Ulf Hansson (3):
  mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
  mmc: block: Use generic_cmd6_time when modifying
    INAND_CMD38_ARG_EXT_CSD
  mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()

 drivers/mmc/core/block.c   |  6 +++---
 drivers/mmc/core/mmc_ops.c | 25 +++++++++++++------------
 2 files changed, 16 insertions(+), 15 deletions(-)

-- 
2.25.1

