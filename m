Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EE152AAE4
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352223AbiEQScc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352254AbiEQSc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:32:29 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50157515B8;
        Tue, 17 May 2022 11:32:21 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id a11so17672610pff.1;
        Tue, 17 May 2022 11:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DfSZzPRStq2lgHjsq9N6lhXntt9Td2w3Wt1rTuYdWMg=;
        b=BEsilVrnDcq4mvAgesnro2VrGovQTFKDJ7fiZbv4nEH1PoVEKUcokg4XwMATv7jqFt
         CEPXWz9TmOhX117rYKl6QzBVWlAHvlwjIy+/2vHIcRSfTKJurqBAQUHCxPLi4wuMSA3Q
         E+foDM2U5UijFCzkwsCZwbTXi4T0SIk5ddR2oIg4YyzNShM3gA124fffF4cSmYEleQso
         Cjd5i2DymfGfrX958+Ypge43uHWyBvf0QrBaCDSvuK68V6EKEwp+RyVpOsxnfaWsjAxi
         tSA/MZFr1dRYAO3zsh/1vdYlvmiUP4r4eB7Of3kk3nwqo7L2jkKO3+JVdqOcbcXQZdtB
         kFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DfSZzPRStq2lgHjsq9N6lhXntt9Td2w3Wt1rTuYdWMg=;
        b=3ubxpmV1qMciTx/Uia2/nnOkJIkDfT9Zu4OgxeyPVj+I/uomsRn7rHWysYp9w3YnmN
         OigVFQziIqZzhPTO9VcCO7qbx637On+zKvwzovs90PkyQyOIl5I/e/m6zV09Ggg/slDO
         n/yliolcb3rGLUHMLxFLUr92cjj7K22jLPAiFwhkWphrCtm6AvC94VqYdKM00A5ZpLTO
         KYrOWTbr4npqo8b9sybAYVM9MUKp7M4Zwm4GAuQzxNB+IukqcP7S+LaL783medfm75SU
         HID09o6qfuPu8KpBbDw2+WwUfFjM6xoXUjSbiTmB+BWitG0aRKcao6dWOibXFEOMQIfs
         3UXw==
X-Gm-Message-State: AOAM533X/Dyi5pYJ6lke1X6IHZOu4CtCNLyCzV8WOCGOyUrD8hqc7QUN
        gVga3a18ePQ0OJS+gdaO/rm7t0u0q8I=
X-Google-Smtp-Source: ABdhPJxLEibPJLN2OqALmxMCNWk9V8AIgC0wGEbV/nnuZntb+q/ocGVwRvlON7PRAw8RNfhB54CFEA==
X-Received: by 2002:a05:6a00:a0e:b0:4fd:fa6e:95fc with SMTP id p14-20020a056a000a0e00b004fdfa6e95fcmr23767951pfh.17.1652812340533;
        Tue, 17 May 2022 11:32:20 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d26-20020a634f1a000000b003c619f3d086sm8950355pgb.2.2022.05.17.11.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:32:20 -0700 (PDT)
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
Subject: [PATCH stable 4.9 0/3] MMC timeout back ports
Date:   Tue, 17 May 2022 11:32:04 -0700
Message-Id: <20220517183207.258065-1-f.fainelli@gmail.com>
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

 drivers/mmc/card/block.c   | 6 +++---
 drivers/mmc/core/core.c    | 5 ++++-
 drivers/mmc/core/mmc_ops.c | 9 +++++----
 3 files changed, 12 insertions(+), 8 deletions(-)

-- 
2.25.1

