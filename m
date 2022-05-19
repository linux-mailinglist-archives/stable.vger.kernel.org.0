Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62D452DD49
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 21:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241336AbiESTAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 15:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241043AbiESTAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 15:00:37 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8F7AE257;
        Thu, 19 May 2022 12:00:36 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a23-20020a17090acb9700b001df4e9f4870so6054180pju.1;
        Thu, 19 May 2022 12:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=98ewg5Kz+dWz3gt2JKMvme66iQECu+1Q7V9dYYaZ9KE=;
        b=amCmmMtZcqbbF0h5rrZdf07kdygT/Burx3U5RkyuoiiVxnITLHeuOYxRzMzjRLqvq1
         8OHzZ4xF5U0HWVv3mBoKTFWv/Xjx4MNnii1sV/lYNCToMY/mAdKOvcAZcvb1sKPhx+Ig
         TGslsUZV46ocj6dRIjJlRXP1QV3eb/+h1ICzP2phVZ3VctyxUOSkPRSgvQdalW7saXuL
         bCk9ZtqhJ9WIpLLss0qK6aSQvKP825Iz26PLkf9J6ba9wo7DYcKdIs7NusHx1bFB0EwC
         6IxvtaoLcKDHytJzc6CNrx6QU/nLEpe0WRPt4ejDt2oyXFVQCqcg+HO5AL8B3UT7qxW7
         KorQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=98ewg5Kz+dWz3gt2JKMvme66iQECu+1Q7V9dYYaZ9KE=;
        b=uonU5/iQz1TPfC8wlc9gq4l2utOf01ucdBR5qRQBjQ3POtkPcCqHQ4i0tP/NTc9PwZ
         HHZNlaoe+poZ8kB5bQt/+ncTUPN8EQTmg8lxWNpjJDIAiFJ6HoU73Nz47uaj0WfX9ztp
         wC1KTk59tLctmDksphpCHO6cRwEKe/USZtdNl6hH2t9T78gqnO3R8aJNVD+rhtM+uDdI
         YHGJpNF59PVHtGrtXyrI2R8L84ov4ZtRLCP+VwhtElECHWihNmFsbMXPjp8YuPQ8aX9w
         mA2MWMOyN0NQNQRJEMN/oF9wYahBJGge7Kj+dU73DJrJslZ2VVieTsyuM11nfA3GJWDM
         bYRg==
X-Gm-Message-State: AOAM53294Gmn6okPmPw4cqS7GDReshC9OdxWm+SIaUrugu7R9kKzQotI
        5p9fNfAcs2Gj03WocDcBtV+uAtq2zTs=
X-Google-Smtp-Source: ABdhPJxIbKml7cPKlizP7FsCWD/xM3YslMtheO8LrUQylnUd1tqO1yIA7VXL0TnnG2K9uV7O66bkEw==
X-Received: by 2002:a17:902:ce8b:b0:161:8d76:6689 with SMTP id f11-20020a170902ce8b00b001618d766689mr6150475plg.153.1652986835632;
        Thu, 19 May 2022 12:00:35 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902d48b00b001618b70dcc9sm4199358plg.101.2022.05.19.12.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 12:00:34 -0700 (PDT)
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
Subject: [PATCH stable 4.14 v2 0/3] MMC timeout back ports
Date:   Thu, 19 May 2022 12:00:27 -0700
Message-Id: <20220519190030.377695-1-f.fainelli@gmail.com>
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

Changes in v2:

- assign timeout to  MMC_BKOPS_TIMEOUT_MS in mmc_start_bkops to avoid
  making timeout unused and changing the existing logic

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

