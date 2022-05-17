Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22A252AABA
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352076AbiEQS1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352065AbiEQS1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:27:51 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2D649F1E;
        Tue, 17 May 2022 11:27:50 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id i8so4157411plr.13;
        Tue, 17 May 2022 11:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qf7lwYbb+YmEy4Sdln94RYRUHzXpgvgkHrp5ukF/qtk=;
        b=bExLHaOgI9hzmShhcx+3FrTFTHywGjHpDNkaL1enjGCdwKtwptC3WJ8JqGRyGb7+i3
         LkdhWIv9iMTvjFZihYAieiUyOJasWm6OMHFQ+GSxr8HgX6fj2aKVLcARvxYJ5ik4oST6
         fkeDy2JqRFFpJKYhXx9TqhwqT1T4ZDmPl052ttR24JfGpVxCrk2uMWKKX7gxx/LjPCVU
         Cb1dKVQKMgGyAtw634vDUaqLkCRIqZ5i+WOkVW0TnRaS69+Ajw9NLnSs0cAdVLrMjt+n
         2LIQprGOCthHvYdBQEF1FY0wFYICUfAMS0RHgU2rmsWDyrA29tv2bjr1ueOFFqCIn626
         Petg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qf7lwYbb+YmEy4Sdln94RYRUHzXpgvgkHrp5ukF/qtk=;
        b=6Tqqi+quEbSAd5/57qDOflaQBRdV0S15VwD3GPr/KcfDE52sCYMRp8zKmfElUmO/wb
         yLVY3Y6wVfevEY79kVZa36I0rpVX7Bj5CJIfsj1U7iqqqE7Fag9gCp+Syte3+D0K+7W9
         KlpdNyzU+JiPw/REF4Oq76KXuVvCE3FJiQ4epsOHZ8hWScvoF3DLRNS/hAvZNjZrKKjK
         Spykicbf+mZslfbrQm6n2QlktM7hwttXOGSeOMj3iyjvSd2QI4qkG9lX3Q2cZoheoHe+
         MsGJ/m35PEqNKU/ne2OCEEd2DcLTkJrI3go+IpdpNb86B2h9Ren77n9sVLFeXVqbb4x/
         u3Vw==
X-Gm-Message-State: AOAM533VdAobdEvwJC/bBLpHjh19CbblQPs+JOAK3tuQz+suV79r7jwM
        TBRSHR/LdbTw0IB7pJ+OC6qdoVuw4ho=
X-Google-Smtp-Source: ABdhPJxtaH8iWUJqH+nTzrJd+eTcXj/31uRvWBWafFUUBsRF+lVpnf52IWewqOlemGArt/JodSHyhA==
X-Received: by 2002:a17:90b:4a42:b0:1dc:6bfa:bc40 with SMTP id lb2-20020a17090b4a4200b001dc6bfabc40mr25770930pjb.215.1652812069527;
        Tue, 17 May 2022 11:27:49 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902d88c00b0015e8d4eb1fasm9538656plz.68.2022.05.17.11.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:27:49 -0700 (PDT)
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
Subject: [PATCH stable 4.14 0/3] MMC timeout back ports
Date:   Tue, 17 May 2022 11:27:43 -0700
Message-Id: <20220517182746.252893-1-f.fainelli@gmail.com>
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
 drivers/mmc/core/mmc_ops.c | 27 ++++++++++++++-------------
 2 files changed, 17 insertions(+), 16 deletions(-)

-- 
2.25.1

