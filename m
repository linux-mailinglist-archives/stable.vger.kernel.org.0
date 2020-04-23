Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AB01B6595
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgDWUkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:19 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD88DC09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:18 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s10so8267215wrr.0
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hVj9mgZA5df4hobjy6TB5RA1EVKQsSMeomsZbby7gR8=;
        b=wY6Ch4wfTP5IHHlN9u6h3Z2PhSAxjNVsnnBEgL+vVSDmdo2nyN+/0jPYi/cNr/mQcu
         5smuQL5YSIo8aSJEkdiBo6oes+5uywa9VvsZfvDppxHw582x/+PMceUKroThj3cecdd5
         YzhCsgBSHER2d8ufbw3gSQymEiJ+imhyjbFUMDJgSxpY0TXB2xjCHFCSOdtlkrI1vFFp
         uWFtBZ/2n7uzfeU7mm3eBCy8Ad/3XE85CO7COoHZ5lYNijIe9kWt24ga16W91isBp0+T
         sd6R0YeexoEqkM14/gyu1+X0x8CptWixHZT2DzcpwwN8gEJPARMZu3O0ngPENcTvIWH9
         LJLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hVj9mgZA5df4hobjy6TB5RA1EVKQsSMeomsZbby7gR8=;
        b=sCTA8OWXYH0FZdm+4/5TO/LPw3DnzfmM/ipMXz/WNc7vR4zjiCkrkvXiKVVALIVC6E
         n+rk5KO4HNW/ZktKv3dTu6tY800aBUCTJYOOnEMamKzJfm6hRCRJ+gVeFKRg92gQVvaC
         RMos8dgZhQzLkXXlGLavfwGyRxOkI9KgN1fH14+exuQgKRJ5/iwwOL+NLeLdeUmbv7R8
         Sewy1uHC7MnssOGVGZOIfWjADDFnVP863SMjzCMI8TGJSq4pk+gfs8KgC4T61evjY7Of
         JaoenWTOuJflW2V+dW3LQ8X0eiaOQmzURopscx+lYhWHnedpKvL225Xh0Fj17A6f56Pq
         EFTw==
X-Gm-Message-State: AGi0Pube8fu3x6d9zOeboOhK6kilaOuRJBlOFkxsCLPse5n4jf2ikZ9o
        ZmqgvQK5ctejKRav3xEUqLUC8pwGfl4=
X-Google-Smtp-Source: APiQypKyzyVA65HCKf3ET8dWELL91fopkOYztw9YXStIu3gxby7LX9aueQIDIGEfSuC9DUPtPRrTfA==
X-Received: by 2002:a5d:404a:: with SMTP id w10mr6753490wrp.397.1587674417323;
        Thu, 23 Apr 2020 13:40:17 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:16 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 00/16] Backported fixes taken from Sony's Vendor tree
Date:   Thu, 23 Apr 2020 21:39:58 +0100
Message-Id: <20200423204014.784944-1-lee.jones@linaro.org>
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

Austin Kim (1):
  mm/vmalloc.c: move 'area->pages' after if statement

Chris Lew (1):
  soc: qcom: smem: Use le32_to_cpu for comparison

Dedy Lansky (2):
  wil6210: fix temperature debugfs
  wil6210: rate limit wil_rx_refill error

Geert Uytterhoeven (2):
  gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants
  clk: Fix debugfs_create_*() usage

Hamad Kadmany (1):
  wil6210: increase firmware ready timeout

Joe Moriarty (1):
  drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem

Markus Elfring (1):
  crypto: talitos - Delete an error message for a failed memory
    allocation in talitos_edesc_alloc()

Mohit Aggarwal (1):
  rtc: pm8xxx: Fix issue in RTC write path

Rob Clark (1):
  drm/msm: stop abusing dma_map/unmap for cache

Rob Herring (1):
  of: fix missing kobject init for !SYSFS && OF_DYNAMIC config

Subhash Jadavani (1):
  scsi: ufs: ufs-qcom: remove broken hci version quirk

Will Deacon (1):
  arm64: traps: Don't print stack or raw PC/LR values in backtraces

Yangtao Li (1):
  serial/sunsu: add missing of_node_put()

 arch/arm64/kernel/process.c                |  9 ++-
 arch/arm64/kernel/traps.c                  | 72 +---------------------
 drivers/base/devres.c                      | 10 ++-
 drivers/clk/clk.c                          | 30 +++++----
 drivers/crypto/talitos.c                   |  1 -
 drivers/gpio/gpiolib.c                     |  8 +--
 drivers/gpu/drm/drm_dp_mst_topology.c      |  8 ++-
 drivers/gpu/drm/msm/msm_gem.c              |  4 +-
 drivers/net/wireless/ath/wil6210/debugfs.c |  7 ++-
 drivers/net/wireless/ath/wil6210/main.c    |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c    |  4 +-
 drivers/of/base.c                          |  3 -
 drivers/rtc/rtc-pm8xxx.c                   | 49 +++++++++++----
 drivers/scsi/ufs/ufs-qcom.c                |  2 +-
 drivers/soc/qcom/smem.c                    |  2 +-
 drivers/tty/serial/sunsu.c                 | 20 ++++--
 mm/vmalloc.c                               |  8 ++-
 17 files changed, 107 insertions(+), 132 deletions(-)

-- 
2.25.1

