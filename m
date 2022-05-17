Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C5B52AA9C
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352077AbiEQSW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352076AbiEQSWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:22:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3785237E7;
        Tue, 17 May 2022 11:22:16 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l14so7247382pjk.2;
        Tue, 17 May 2022 11:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sk+5mSaR9rPPKXkfYc0/VsJM1xTQzkpsddohoa/KxaY=;
        b=gxvr7cWtIkGeoYMwgPEe6gEz9SSAmtQHdj/bHTvLpd6e8SebYBEENYhmf+eAdY7WiA
         VZn4d5VRAf6u0u4+Qotjv3yxyxcVYDk3WNKr6QZySHM72+qaMiNIeQf+OPvboKyaZqfO
         zcZWamPZB/dtk7qJ7hkaYzrwu42G/dv77iB7485bUbphfN8mwDDmdlsQ9fG4oLyNeJzS
         +sBkVtI08FKfSr7msSFreIokn/qV5vhugITZVsU0AH0DUhG1ARfK80xTQ1lQ6zBg+9gf
         1wCAZR8wG0KHYi+xANC9wFIfp1bkzjFSIMIFpPT3PJ4V1lOP98rAaR10S1S3v5XjyjuE
         vzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sk+5mSaR9rPPKXkfYc0/VsJM1xTQzkpsddohoa/KxaY=;
        b=VisqHyyQtVaOt/IvLMxEs1EPpSFmTZ6NzjG7iGIGynMtKk/Ro4KDbWWNEUx+xEg0zC
         LCTOXnyJ51hzdOFnHXL/UmnkNnQ7tzETmS49ifimUleahtkMmgBcXnSof4WcDLIXXn91
         Eh4GEKDNvXMemkt759Ut3RjfD30qqNc2GFLN8buBNs297mbGZXlm9Wol4CNfxqa4nJDi
         nW/igb6fbWHwUPdPRk+ouYyK1U1oYwbp73rHAhHscjFXHD4GsC4v6tUt2x5U8x/3g0uZ
         rQ912G26T4q+stqzTfgtjE3AZxBZZQQ1MBQ+ejIOujoIMjtYF+xFlHZrGvpTb7dPMBm9
         rBgA==
X-Gm-Message-State: AOAM531BuIIf36+kslYp3Im3Lu3rCku0spIucofYSvLaU/KfDVUPKCf9
        ItHv+GlEERhJeaQDJAQ4s6Lgsc2WdQQ=
X-Google-Smtp-Source: ABdhPJzcLw5tXwXfLYNaJNhDtfK9Pdzu3bYq5ZtApJC2+2raAhiaW0V5hluT0TeLRcKzKmlFia2HbQ==
X-Received: by 2002:a17:902:bc86:b0:161:5f4e:d7d0 with SMTP id bb6-20020a170902bc8600b001615f4ed7d0mr14961198plb.119.1652811735879;
        Tue, 17 May 2022 11:22:15 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x4-20020a17090ad68400b001d7dd00c231sm1998141pju.22.2022.05.17.11.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:22:15 -0700 (PDT)
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
Subject: [PATCH stable 4.19 0/3] MMC timeout back ports
Date:   Tue, 17 May 2022 11:22:08 -0700
Message-Id: <20220517182211.249775-1-f.fainelli@gmail.com>
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

