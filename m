Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965C81B4305
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDVLUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbgDVLUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:02 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D786BC03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:01 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g13so1912207wrb.8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5W/+i/AQMCQefcivNfNvmUQw16DVDZ21B6Yhd9dVGvI=;
        b=HO+pdk4Mz7x+ui4h2CzyI1YAxwqkzZDcpCa6raaNudR6LZkPZ0fIQieS5gh2GgCkGT
         IXiUgS3n5tFxpse3SNrAb2+zAM1i1KZuc+rXdfhuelvQdJSDSHX/S0FwW1tED11y5qgG
         DjC2sAMxZyYW2QNWiVT1Lg6e8r48YvBfrHQX0/BKQOFWDN4UW+TOYCdPGc0P9G1MJu/d
         G6PswPbf4IZ9sLMDZFeRHNZEAB/5X6Bj6Y+Yb+CetdU6jO3QnuOy1SLjnNC31iSQqW9Q
         lHCVuWhAry9Ue8G90dFCb7In6R2+syiUsv1Hv7TW8AX4zPjXy9W1fdvwGeWtCOVHawAf
         yLFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5W/+i/AQMCQefcivNfNvmUQw16DVDZ21B6Yhd9dVGvI=;
        b=CvyHxyiAA6+Fsg6S9liwvu5bsG9SV3AdfLH6hEzN7d8jsEZf5ygn1kJ19ThmXpehdO
         FCTiZafFsLRb7UZ0MD1liQjHguAr14E1wr/fJsjedEtwFBwbqf5WIap6ebsfcDW7STGi
         0rtpavFk8aiJ7hp8UE8qHGd4cb9MA611Gxs8ohMBwVibMQZDtwuSH5qLLRdYKUdRQl2f
         YraM31qBjrkxE/oi++0QTWAgszgF0zosEPEJ9m5rwijxRHskrXjx9nFZWwrRFBvYDSq8
         QyxPHmufCKiL44qW0VC5zzNTou84Jseetg74l2RiL089BxEV9aSxm+x/dwGT+x7fAzUq
         GENg==
X-Gm-Message-State: AGi0PuaO1bULMhReiSsu4hl9y4QoC7B8NboKBHaKxqgcE62gv/k9vCjb
        spW/cFK90TaNaichEUX5Bm4uylbDFw0=
X-Google-Smtp-Source: APiQypJeNs5CYSDF4yd+kL8b1YfEsrxqJCoZZr3AmaWaNptfbAcVNMPAERmrtlSrNi3irDF5G8J69w==
X-Received: by 2002:adf:f34e:: with SMTP id e14mr18266836wrp.193.1587554400241;
        Wed, 22 Apr 2020 04:20:00 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:19:59 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 00/21] Backported fixes taken from Sony's Vendor tree
Date:   Wed, 22 Apr 2020 12:19:36 +0100
Message-Id: <20200422111957.569589-1-lee.jones@linaro.org>
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

Alexey Brodkin (1):
  devres: Align data[] to ARCH_KMALLOC_MINALIGN

Arun KS (1):
  arm64: Fix size of __early_cpu_boot_status

Austin Kim (1):
  mm/vmalloc.c: move 'area->pages' after if statement

Chris Lew (1):
  soc: qcom: smem: Use le32_to_cpu for comparison

Dedy Lansky (2):
  wil6210: fix temperature debugfs
  wil6210: rate limit wil_rx_refill error

Geert Uytterhoeven (1):
  clk: Fix debugfs_create_*() usage

Hamad Kadmany (1):
  wil6210: increase firmware ready timeout

Hans Verkuil (1):
  drm_dp_mst_topology: fix broken
    drm_dp_sideband_parse_remote_dpcd_read()

Joe Moriarty (1):
  drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem

Lior David (1):
  wil6210: fix length check in __wmi_send

Mohit Aggarwal (1):
  rtc: pm8xxx: Fix issue in RTC write path

Rob Clark (1):
  drm/msm: stop abusing dma_map/unmap for cache

Rob Herring (1):
  of: fix missing kobject init for !SYSFS && OF_DYNAMIC config

Roger Quadros (1):
  usb: dwc3: don't set gadget->is_otg flag

Subhash Jadavani (2):
  scsi: ufs: Fix error handing during hibern8 enter
  scsi: ufs: ufs-qcom: remove broken hci version quirk

Taniya Das (1):
  clk: qcom: rcg: Return failure for RCG update

Timur Tabi (1):
  Revert "gpio: set up initial state from .get_direction()"

Venkat Gopalakrishnan (1):
  scsi: ufs: make sure all interrupts are processed

Will Deacon (1):
  arm64: traps: Don't print stack or raw PC/LR values in backtraces

 arch/arm64/kernel/head.S                     |  2 +-
 arch/arm64/kernel/process.c                  |  8 +--
 arch/arm64/kernel/traps.c                    | 74 +-------------------
 drivers/base/devres.c                        | 10 ++-
 drivers/clk/clk.c                            | 30 ++++----
 drivers/clk/qcom/clk-rcg2.c                  |  2 +-
 drivers/gpio/gpiolib.c                       | 31 ++------
 drivers/gpu/drm/drm_dp_mst_topology.c        |  9 ++-
 drivers/gpu/drm/msm/msm_gem.c                |  4 +-
 drivers/net/wireless/ath/wil6210/debugfs.c   |  7 +-
 drivers/net/wireless/ath/wil6210/interrupt.c | 22 +++++-
 drivers/net/wireless/ath/wil6210/main.c      |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c      |  4 +-
 drivers/net/wireless/ath/wil6210/wmi.c       |  2 +-
 drivers/of/base.c                            |  3 -
 drivers/rtc/rtc-pm8xxx.c                     | 49 ++++++++++---
 drivers/scsi/ufs/ufs-qcom.c                  |  2 +-
 drivers/scsi/ufs/ufshcd.c                    | 46 ++++++++----
 drivers/soc/qcom/smem.c                      |  2 +-
 drivers/usb/dwc3/gadget.c                    |  1 -
 mm/vmalloc.c                                 |  8 ++-
 21 files changed, 152 insertions(+), 166 deletions(-)

-- 
2.25.1

