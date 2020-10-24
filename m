Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C39297CCE
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 16:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761990AbgJXO2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 10:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761989AbgJXO2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 10:28:01 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D0CC0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 07:28:01 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h6so3376649pgk.4
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 07:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YSiU84EOj507B4nbptlqtsF2B/eBetDfdrfUg1CaEcw=;
        b=1XxwePLUE2GoeUNOwlrKVez8A1VoRuvgxAOY8e7awr1Rx5AFOHHuOS50gJuTskomdA
         2e76S5HZcMU0B694P1zrPHUBz1gBt72boSqYtXfgG3hLGayHogKFIjA9tl9IT6G7cqat
         i8DXtmuV7vkIVvyA/QgUCZ6uRFPwIqhaGgmeu9llukRnu6AYCfvLOlXN8kONwvOcgkhB
         QWZWLWC/qph9TTYQjQDvab/Fkcp5ab5EXC75m9LQoy8Fb0XpoGUSGectuVfpfrJJYZSZ
         auP5YLaR9q2HSZU1/bN48Lo8rvcIGrWl8yEd1kP8n1Vsg+0JrE7j5ENzghdi6gLqADYb
         SJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YSiU84EOj507B4nbptlqtsF2B/eBetDfdrfUg1CaEcw=;
        b=KZ+5D1Lc3N6CAfYoeGHobcITBa7Ev9RB3cJ/vYCwNpdrUQYK5gspGqZKT+ThSkLB7R
         WbGcCgFws38Ey0NDkZCVwiWx8tJLXnVUx2lw6M5s0yq0GMbOpadBOE9yO5pt97vZo11O
         w3YIYP3Yw7BHXActCULIil29iSQCESmVeheOTS3IAibF+j1CBcdrUNyoUQ/z1cPUcXqO
         yzW6kgjrXDf62WdFmdY27fRmkth0RfiJ19IzbN3ES4rJXE29r8YnDzEISsZ4Aa6/kgCd
         zozrElXQp4qspVXUDAaAsBDB0IIf1WXzFB7YdM9+7tfpak5dxRmywBdE+mNX3iJDCuQX
         b6kQ==
X-Gm-Message-State: AOAM5305w8qFpUMKyG0/CEwqUcj+MrBxw1Gh20j1uPf3yRAm75cl7kbi
        rdpI8pNRy4EW6CE/QRQoAgJXtuj3dXeHwg==
X-Google-Smtp-Source: ABdhPJzuF8geurvIFhPQqM0JLH62UrqF8NlRRZT38lWhUcPAHFlI1qDqUwGTaMHJQ83VOuAYSFKKPg==
X-Received: by 2002:aa7:94a4:0:b029:151:d786:d5c2 with SMTP id a4-20020aa794a40000b0290151d786d5c2mr3699169pfl.50.1603549680377;
        Sat, 24 Oct 2020 07:28:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e20sm5687474pgr.54.2020.10.24.07.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 07:27:59 -0700 (PDT)
Message-ID: <5f9439ef.1c69fb81.ac392.9e29@mx.google.com>
Date:   Sat, 24 Oct 2020 07:27:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.240-12-g493707a5601a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 135 runs,
 1 regressions (v4.9.240-12-g493707a5601a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 135 runs, 1 regressions (v4.9.240-12-g493707a=
5601a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.240-12-g493707a5601a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.240-12-g493707a5601a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      493707a5601a3129d83e2c064b4fecedbed8afdb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9407f4028a05eff1381044

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
2-g493707a5601a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
2-g493707a5601a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9407f4028a05e=
ff138104b
        new failure (last pass: v4.9.240-5-g556e4f1b1550)
        2 lines =

 =20
