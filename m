Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9306452DCFD
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 20:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243920AbiESSpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 14:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbiESSps (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 14:45:48 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36504B84;
        Thu, 19 May 2022 11:45:44 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id m1so5550052plx.3;
        Thu, 19 May 2022 11:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7smDroV+M0g+eSUGaVSh+ksOFMBDyGWLpxKeQhBSYm4=;
        b=fX/g0Rj/Z1tpi7fE15YKk3zx7u08lGiG7kX19aVrQg0PUTrP5l7UpNOt94PWOZ+FcM
         hRsF/RSVcPiQshiJfZqEGfsGZLfeKvYtwZKvSc9laGHIyDEEqRUuqyrCYp1lbAuXTIoF
         IbuLEb7BbdIu3aG5MId9mXfx7UBGVN0p8WIVMMsA13v40aFlSCZwjQSJp19vKxxN8N+5
         sC5SQMmapx8CylulfMVjX+RnR+SLckLpRAChL+D96r+jSDOYR3fDh02aTe2sOH2LHcjK
         Rj8pDeLiV3Ex1dA7gKIjgPKSjHp98Sj3mdTCA/QsLvYgvw+lbrLmOrqTGu12oXQi91c0
         lGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7smDroV+M0g+eSUGaVSh+ksOFMBDyGWLpxKeQhBSYm4=;
        b=6cTZynEXuA56fY1cjMpkN4V8MnnGN6IybpsDz1Xa3lq7O3IbhMNwOwX5Uc2slRRgbq
         HUVoudaN7dstWZeeg4bJzucKwLB0t35mi/lLNcLbqn4Tqcw12F579/qaKdUy0DgqG80f
         e8fAfxUjgBc+DBmXJ1cn48hmjYt69adiQl7lCryld1SpxhVZ/IvxGNjAQKuMmhJbD+bC
         SpW5jcYT9TXogS/lIi7Cy/cBGFNHI77LeSILum331phMdIagKaThYiNWxWhjtc5fTpvG
         I/j9lV/u2g72d3fvn7hP48h8w9QsNVf2xV6zmaZfkkAkanTMVWjilQLyaHLbmbxl9Yq7
         4f5w==
X-Gm-Message-State: AOAM531HpVczC8GwdiwAIHxt1baPbKgMplM84IlL0pElglRGaYcq+HpS
        dIT7qr4HNwRe0MVQuL2wvi+fmRAqbWY=
X-Google-Smtp-Source: ABdhPJyQsXRcHcs9OOIc829bpcvfxegyEVo+FSoVHZaLN4kVczz0PjypkivrASJTfjV5wCFiWC0+RA==
X-Received: by 2002:a17:90b:1955:b0:1df:a48e:4597 with SMTP id nk21-20020a17090b195500b001dfa48e4597mr6482734pjb.187.1652985943438;
        Thu, 19 May 2022 11:45:43 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79245000000b0050dc76281c2sm2965pfp.156.2022.05.19.11.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:45:42 -0700 (PDT)
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
Subject: [PATCH stable 4.19 v2 0/4] MMC timeout back ports
Date:   Thu, 19 May 2022 11:45:32 -0700
Message-Id: <20220519184536.370540-1-f.fainelli@gmail.com>
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

These 4 commits from upstream allow us to have more fine grained control
over the MMC command timeouts and this solves the following timeouts
that we have seen on our systems across suspend/resume cycles:

[   14.907496] usb usb2: root hub lost power or was reset
[   15.216232] usb 1-1: reset high-speed USB device number 2 using
xhci-hcd
[   15.485812] bcmgenet 8f00000.ethernet eth0: Link is Down
[   15.525328] mmc1: error -110 doing runtime resume
[   15.531864] OOM killer enabled.

Thanks!

Changes in v2:

- back port "mmc: core: Cleanup BKOPS support" to remove the unused
  timeout variable in mmc_run_bkops

Ulf Hansson (4):
  mmc: core: Cleanup BKOPS support
  mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
  mmc: block: Use generic_cmd6_time when modifying
    INAND_CMD38_ARG_EXT_CSD
  mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()

 drivers/mmc/core/block.c   |   8 +--
 drivers/mmc/core/card.h    |   6 +-
 drivers/mmc/core/mmc.c     |   6 --
 drivers/mmc/core/mmc_ops.c | 110 ++++++++++---------------------------
 drivers/mmc/core/mmc_ops.h |   3 +-
 5 files changed, 36 insertions(+), 97 deletions(-)

-- 
2.25.1

