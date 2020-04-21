Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC721B2652
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgDUMkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728739AbgDUMkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:40:45 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC3AC061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:45 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x4so3399147wmj.1
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UJDJuDx0X0wLkf8WndVzqFNVo1PrFSgUNvEMaXleSPM=;
        b=MfpcRbQ75HQYGqZ36NAeq/AsLnGxzKdLY5gjQeQFI6CMWtfw+jwKWPD8kjwn83ZdFa
         gHqRidw79/wtlefwYc9mDqhpPGaaZaU25unH4LvI7pC/BacEwfYQSzbyilJFZCj3imUG
         ttqHHYRZENMtDB3pskC8jfZSur1dG40DEYZu9Rt+4x63RNhc+YQ8SXjsmR2dAUOzCTYJ
         Szz+aczHpVA1HcRKDsVqPazyb2dTBd/RO0m62/1dsKKJbVbulCwV0v7N8L9hwUwijTkU
         yNgne/m5SLJWtQn20w8WAcvDYk1QHQtt1fikp2xNKRJTxCcGg7Q1IDfQIgM8nDEVYSve
         3UZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UJDJuDx0X0wLkf8WndVzqFNVo1PrFSgUNvEMaXleSPM=;
        b=An9qAjkUzf9wPRBuJPipPIK3I4rjRK4iW8ZPpg8w3Mhreljj1ZrLa67Qga4hRZcOw4
         V/aeZ62LOemPYQxZ4Y9ZSOypRx++HokQjL+z0TyzAR68by42r1IpV9+x7JcNa27LS3a9
         7MDufczXCIDIyKJHdVn81zsozn6A2md29o8TYUKIVDdLYOPJCHRr8qpE6yHj7HeMiops
         JT5HHXO9sQJXrYpC9nv97FvZpbCBGlKXl1DhgbCdobCZgNR1hcprTR86yU81zLL0yJsA
         YrcfLqW2d5CHmM5jvbikhinI+qjHPTy4ENGUbtnXDiBbSoT4b44mLwPtNv3n+guElhBL
         TcVQ==
X-Gm-Message-State: AGi0PuY/yD80SEXnBM/YDnzkuedgQTEzo8u7plAIanom4w/jr7l0AkOY
        G6OV90wCPX/ey2Fpmiu8HrGKfuIFhYE=
X-Google-Smtp-Source: APiQypLVzJOr5dgdefVb5Fn1Ebs48f5y6vL1QTXH43YXjW6qSFr/zHUuMOfQG08YpZ+GpkJNBoQtDg==
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr4783379wmf.77.1587472843971;
        Tue, 21 Apr 2020 05:40:43 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:43 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 00/24] Backported fixes taken from Sony's Vendor tree
Date:   Tue, 21 Apr 2020 13:39:53 +0100
Message-Id: <20200421124017.272694-1-lee.jones@linaro.org>
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

Arvind Yadav (1):
  rpmsg: glink: use put_device() if device_register fail

Austin Kim (1):
  mm/vmalloc.c: move 'area->pages' after if statement

Bjorn Andersson (1):
  rpmsg: glink: smem: Ensure ordering during tx

Chris Lew (1):
  soc: qcom: smem: Use le32_to_cpu for comparison

Dedy Lansky (2):
  wil6210: fix temperature debugfs
  wil6210: rate limit wil_rx_refill error

Geert Uytterhoeven (1):
  clk: Fix debugfs_create_*() usage

Gustavo A. R. Silva (1):
  android: binder: Use true and false for boolean values

Hamad Kadmany (2):
  wil6210: increase firmware ready timeout
  wil6210: abort properly in cfg suspend

Joe Moriarty (1):
  drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem

Lazar Alexei (1):
  wil6210: fix PCIe bus mastering in case of interface down

Lior David (2):
  wil6210: add block size checks during FW load
  wil6210: fix length check in __wmi_send

Mohit Aggarwal (1):
  rtc: pm8xxx: Fix issue in RTC write path

Prasad Sodagudi (1):
  arch_topology: Fix section miss match warning due to
    free_raw_capacity()

Rob Herring (1):
  of: fix missing kobject init for !SYSFS && OF_DYNAMIC config

Subash Abhinov Kasiviswanathan (1):
  net: qualcomm: rmnet: Fix casting issues

Subhash Jadavani (1):
  scsi: ufs: ufs-qcom: remove broken hci version quirk

Timur Tabi (1):
  Revert "gpio: set up initial state from .get_direction()"

Venkat Gopalakrishnan (1):
  scsi: ufs: make sure all interrupts are processed

Wei Yongjun (1):
  rpmsg: glink: Fix missing mutex_init() in qcom_glink_alloc_channel()

Will Deacon (1):
  arm64: traps: Don't print stack or raw PC/LR values in backtraces

Xu YiPing (1):
  arm64: perf: remove unsupported events for Cortex-A73

 arch/arm64/kernel/perf_event.c                |  6 --
 arch/arm64/kernel/process.c                   |  8 +--
 arch/arm64/kernel/traps.c                     | 65 +------------------
 drivers/android/binder.c                      |  6 +-
 drivers/base/arch_topology.c                  |  2 +-
 drivers/clk/clk.c                             | 32 +++++----
 drivers/gpio/gpiolib.c                        | 31 ++-------
 drivers/gpu/drm/drm_dp_mst_topology.c         |  8 ++-
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |  6 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c   |  7 +-
 drivers/net/wireless/ath/wil6210/debugfs.c    |  7 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c     | 58 +++++++++++------
 drivers/net/wireless/ath/wil6210/interrupt.c  | 22 ++++++-
 drivers/net/wireless/ath/wil6210/main.c       |  2 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c   | 24 ++++---
 drivers/net/wireless/ath/wil6210/pm.c         | 10 +--
 drivers/net/wireless/ath/wil6210/txrx.c       |  4 +-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  5 +-
 drivers/net/wireless/ath/wil6210/wmi.c        | 13 +++-
 drivers/of/base.c                             |  3 -
 drivers/rpmsg/qcom_glink_native.c             |  1 +
 drivers/rpmsg/qcom_glink_smem.c               |  6 +-
 drivers/rtc/rtc-pm8xxx.c                      | 49 ++++++++++----
 drivers/scsi/ufs/ufs-qcom.c                   |  2 +-
 drivers/scsi/ufs/ufshcd.c                     | 27 +++++---
 drivers/soc/qcom/smem.c                       |  2 +-
 mm/vmalloc.c                                  |  8 ++-
 27 files changed, 212 insertions(+), 202 deletions(-)

-- 
2.25.1

