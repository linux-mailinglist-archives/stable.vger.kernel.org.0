Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A803394B58
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 11:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhE2Jih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 05:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhE2Jih (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 05:38:37 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A62C061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 02:37:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v14so4407813pgi.6
        for <stable@vger.kernel.org>; Sat, 29 May 2021 02:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HA6Wji1dco+AwjK+KmQDjn6ZEFYcITfQMsHV0JWLnuY=;
        b=s+jEsYpE+EHy+LC6/vu2txlpP/rSHtr2IJINVhbxIsQPYLgQN/ZX4G01KknZHLhtjk
         divXNQObGqpTE0eatjiHeW0HPiWlZV1RHci028EF5uwEji/S4LcsUJF8eWIuKXzqZ6MM
         7frYKkecc+uy/DIZcTrjl/0QzUW+I+BiUtvNwMyQijNgGzfZBK1jHYNo/CxAuEJyN8RE
         Tg/FMTvWmrdDENvIBY5BRqI/yd7AB9c7s8CQipSd8zWuv9sV1SD4/Rkkg/mlhUgGrbwY
         SZyXFoNonHcN4RMIvkU0SjBXb1n5RkDxgw15SUjKFoYwmxiDfthtP66w6Wn4oPLXDbgQ
         lPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HA6Wji1dco+AwjK+KmQDjn6ZEFYcITfQMsHV0JWLnuY=;
        b=HJDH7MgyxUeefmrSLtoYVhcb22Mp1hulljvBX6fJM4G+md1aCT9UmRSBBFYhILI48E
         Xt+ZlDSgJM7pwwG3rub7RYlA9HZ2B5CrcayWHuIVU6KWEY1On+5bVFvlrCPHxE6W3s1/
         dPY4/H4Dpo3RJSTCY6Cf46qFm11bcyniY7vUwATj8c2+lYpbpkNIt9B8/2cjL8YmvryV
         8oJnvWcHFVaHyYEluRfaSDVirAIEgFzWpPRScegrn+yrV4HH480XZZtoASwIDfJ6WoTL
         w1F4We3LlFMQxD8BG2xtSPygu+ZE0hY5xXZg/06/2S8yxuHdqTMCWMsG/49GiBfQ116T
         DpwA==
X-Gm-Message-State: AOAM531/WtT3S73rGc+vuttvOwOYJeeTVU1wjhIFgKbCUUlO4/x7dWf5
        PJmSTFGEtiUQyjGZk8TL8kbrEJkW5xsrHxGg
X-Google-Smtp-Source: ABdhPJy8v05PWSrrXqbYLl/YgADxFH1YZes6A2WF8mw8mS6hXX58kadQ1RAuoeYRJy1UXjhoQM4m0A==
X-Received: by 2002:a63:7048:: with SMTP id a8mr13353053pgn.194.1622281019311;
        Sat, 29 May 2021 02:36:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r28sm6442784pgm.53.2021.05.29.02.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 02:36:59 -0700 (PDT)
Message-ID: <60b20b3b.1c69fb81.7d149.5af0@mx.google.com>
Date:   Sat, 29 May 2021 02:36:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.234-6-g1a222d55ea8e
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 148 runs,
 1 regressions (v4.14.234-6-g1a222d55ea8e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 148 runs, 1 regressions (v4.14.234-6-g1a222d=
55ea8e)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.234-6-g1a222d55ea8e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.234-6-g1a222d55ea8e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a222d55ea8efe5ad78cc237ca45056e403aba77 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b1df4fa71b6e2c25b3afab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-6-g1a222d55ea8e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-6-g1a222d55ea8e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b1df4fa71b6e2c25b3a=
fac
        failing since 89 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =20
