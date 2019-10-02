Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2996C9103
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 20:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfJBSma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 14:42:30 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40414 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJBSm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 14:42:29 -0400
Received: by mail-qt1-f194.google.com with SMTP id f7so27717564qtq.7
        for <stable@vger.kernel.org>; Wed, 02 Oct 2019 11:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g1b91VmMiL2dDCBLT6JYdBj2IBTRwJuzgoJIwLvpnl0=;
        b=MnKIWpWB85Jzf5sM7DHkCM8CV2XyApzLRvUxLgXrJT5UQK+AM9xH/Y32XwffjxASXy
         nlWpx9YWyUyKPdH1GTn0RtFwacJn+VffnMiKkiQxuOOj/IHj87+xIgPjqpJipgfuADS3
         VnuxMqno1aNpK+xxT8/dBQtWgo0JNMcZX91kmUEGtuEQoRbTgWxpDf7IDyuX9LfmcMHa
         WhjadOUb5vWnc88IWXBQ3CfSliXrqfh3TTLSe0jctN5y7epCOcukS5yAVcus6atn/Clk
         Bi7sdJk71pjA01/GxDL0TzreJJLPM+N45mvTyt77CToWkDuIwSeGnN1TAJCKwcXx3Olb
         lFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g1b91VmMiL2dDCBLT6JYdBj2IBTRwJuzgoJIwLvpnl0=;
        b=DPZNcrLEImT6wjNBrkOx8Cadp4nWYFpoOs4O+2TUrvgGjxiBMlkiViDueMmyg48tEo
         fDEtAvQfG3Dbwp2AEOVBye/ZKUMgjcYu5jvFlRstY/iz23pRxTPIgpITNekuuVDS/SB+
         pALKQRxR6p6Iv+LtW1CrXQF8tytqR0ra3Vp3sqcyC4UHe/a2aXc85/6MYzNOxxC+hzK5
         HeD0fgmQ2lkk+bSzyfo2xEF+hKPYYFbu1GLNG5hInQNtnP1347+qEh8qn/zQpK2ySLMF
         dza0Xo/kkgDjf1JI25AHn+Ltt1/3zgnFQZSz22rvC2ansFywBr5gPGt/tjWQ5Aw/vYZu
         p2lQ==
X-Gm-Message-State: APjAAAWjoTkIHQXMWUBUIZg26V6J1YBdXDp0ugMP7zKm0wnsDY08VArS
        YsGeRSwG8QzqBXvp5ZpCljMiNLAy
X-Google-Smtp-Source: APXvYqxG36UsWLA4vIua0XGcDoguy3VTwZF1+FgvvPHFPQ8NmZHj2WhKKEYtZcoGQcUr0fz6baJYNA==
X-Received: by 2002:ac8:3f4c:: with SMTP id w12mr5787735qtk.168.1570041747137;
        Wed, 02 Oct 2019 11:42:27 -0700 (PDT)
Received: from localhost.localdomain ([71.219.73.178])
        by smtp.gmail.com with ESMTPSA id n125sm1178qkn.129.2019.10.02.11.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 11:42:26 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 0/3] amdgpu display fixes for 5.3
Date:   Wed,  2 Oct 2019 13:42:16 -0500
Message-Id: <20191002184219.4011-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some display fixes for vega20 for stable.  Fixes
stability issues with certain combinations of monitors.
Cherry-picked from master.

Alex Deucher (1):
  drm/amdgpu/display: fix 64 bit divide

Charlene Liu (1):
  drm/amd/display: dce11.x /dce12 update formula input

Zhan Liu (1):
  drm/amd/display: Add missing HBM support and raise Vega20's uclk.

 .../dc/clk_mgr/dce110/dce110_clk_mgr.c        | 27 ++++++++++++++++---
 .../drm/amd/display/dc/dce/dce_mem_input.c    |  4 +--
 .../amd/display/dc/dce112/dce112_resource.c   | 16 ++++++-----
 .../amd/display/dc/dce120/dce120_resource.c   | 11 +++++---
 drivers/gpu/drm/amd/display/dc/inc/resource.h |  2 ++
 5 files changed, 45 insertions(+), 15 deletions(-)

-- 
2.20.1

