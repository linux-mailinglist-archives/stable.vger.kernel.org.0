Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDAC19D68B
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403859AbgDCMS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40781 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgDCMS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id a81so7423061wmf.5
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NLqnV4KN7zhdeXXTn2Z4yrMtNOfqIhb+GDFC/pqFhsQ=;
        b=xbOX2bS45hFIWMfXB6YV8gKcNpTqscy4jo8bK+0bwOmoXugQG0J30dRbBZdjoqqnKP
         yeb7cvgJaExexvX5LE8wcU+FetXW3TBM1kYYlTCygu3pXu6CrtUV7XRYhev8FAiXpy8o
         OqiUnJ3U167W/wbvGy65GD3Jo9YSe97EvLSArn1qZLSFP+XWIf2BimB6WCM18VaB/oy0
         m7X8plZj/PjH5Niknaj5sMVOC0Q0Z7Mdn4m7IEnrNEsRSieInIHBClOXuQRY1jpq1T5k
         urMmFoWk5uOs+fKPlv2Vcx9+bpNnhFqEatsLffSDtpWeJsY5/ynUW8nVGwfyfQN0pVdR
         eQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NLqnV4KN7zhdeXXTn2Z4yrMtNOfqIhb+GDFC/pqFhsQ=;
        b=BMISDSf52msk47R44UMiIU3u1lJwNUw2Lqnh3tQ1oA/NOQsUlzlb1pcM/vmIDluscu
         IJnPfyjY/NczrTKgQS80Av1FO65et1e8rOhKsTlVHRLI544b6DBaM1fQEaBvij44uu19
         3wGNPncCGvUGBwfzmDpEYMUpBgrDphrrnJL9bcAtm7lv4+fu9kvEIHeSUodzZLaeHMY7
         Kcf6OIiletZbMjsDIwnzM/TM0hwi2qzzLjA+jGFoFdrBp41eZU/NACqcY81YpbODkA3W
         7PHFcopHflN4X89GDy3ORDItbVti1mv6C63CCzxqfCdXm98HXOj4gjlV4Kq4BUU/st1O
         Q5YA==
X-Gm-Message-State: AGi0PuYAewQBdCQGU2aXBmeMXPajQT/8/eZIade73Ayhzh/QLuCdc+83
        D5p2MRmzKs0uZyEi0dlxBKwFMzddyyk=
X-Google-Smtp-Source: APiQypJG9fDU2qSHhpkU1yAjNWqxZgqIvHJxiBDHTKASd76AA64TCT7n0H3sigMaytRxwrr86Gcmlw==
X-Received: by 2002:a1c:7707:: with SMTP id t7mr8207127wmi.173.1585916305226;
        Fri, 03 Apr 2020 05:18:25 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:24 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 00/13] Backported fixes taken from Sony's Vendor tree
Date:   Fri,  3 Apr 2020 13:18:46 +0100
Message-Id: <20200403121859.901838-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent review of the Sony Xperia Development kernel tree [0] resulted
in the discovery of various patches which have been backported from
Mainline in order to fix an array of issues.  These patches should be
applied to Stable such that everyone can benefit from them.

Note: The review is still on-going (~50%) - more to follow.

[0] https://github.com/sonyxperiadev/kernel

Alexander Shishkin (1):
  perf/core: Reattach a misplaced comment

Alexei Avshalom Lazar (1):
  wil6210: add general initialization/size checks

Arun KS (1):
  arm64: Fix size of __early_cpu_boot_status

Austin Kim (1):
  mm/vmalloc.c: move 'area->pages' after if statement

Chris Lew (1):
  rpmsg: glink: Remove chunk size word align warning

Dedy Lansky (2):
  wil6210: check rx_buff_mgmt before accessing it
  wil6210: make sure Rx ring sizes are correlated

Hans Verkuil (1):
  drm_dp_mst_topology: fix broken
    drm_dp_sideband_parse_remote_dpcd_read()

Karthick Gopalasubramanian (1):
  wil6210: remove reset file from debugfs

Maya Erez (1):
  wil6210: ignore HALP ICR if already handled

Rob Clark (1):
  drm/msm: stop abusing dma_map/unmap for cache

Roger Quadros (1):
  usb: dwc3: don't set gadget->is_otg flag

Taniya Das (1):
  clk: qcom: rcg: Return failure for RCG update

 arch/arm64/kernel/head.S                     |  2 +-
 drivers/clk/qcom/clk-rcg2.c                  |  2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c        |  1 +
 drivers/gpu/drm/msm/msm_gem.c                |  4 +--
 drivers/net/wireless/ath/wil6210/debugfs.c   | 29 ++------------------
 drivers/net/wireless/ath/wil6210/interrupt.c | 12 +++++---
 drivers/net/wireless/ath/wil6210/main.c      |  5 +++-
 drivers/net/wireless/ath/wil6210/txrx.c      |  4 +--
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 14 ++++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h   |  3 +-
 drivers/net/wireless/ath/wil6210/wmi.c       |  2 +-
 drivers/rpmsg/qcom_glink_native.c            |  3 --
 drivers/usb/dwc3/gadget.c                    |  1 -
 kernel/events/core.c                         |  7 ++---
 mm/vmalloc.c                                 |  8 ++++--
 15 files changed, 43 insertions(+), 54 deletions(-)

-- 
2.25.1

