Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95313A3221
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 19:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFJRcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 13:32:43 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:41883 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhFJRcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 13:32:42 -0400
Received: by mail-pf1-f178.google.com with SMTP id x73so2194309pfc.8
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 10:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pr2ht/jeAn4kQ2w4KB1tHN+N5HXJH+sEW/wHfexG3m0=;
        b=OvmsnUqcjbbsRyHt0QxWRALqCmKHzhbreLeoVsAfoejHTMqHBKefKD5q29zvh3GXP6
         sC+t00EyWOiAihSLa0NowXM685a4iYoXZ5DIEqWs7hrUtef7jUzhcNfobRe+8429tiuj
         llUmFGfGwG3f0vbgrHoXtPhUf9fYhw2xNrzM4eaFItO8cD7313TEaCkr7J21E3inAw1u
         7MmM8r/GHpoL9TKIUlIhTBNR1Jo0z93wxI3uPhTJDVvCoeNCUqEloHIoRfCp7pL19za8
         95GUiJJJ/brw4D7FKSD39PstrYYMp1Lgvj7oxcCrLlKjTGThX9FpNk2CQ958HeNa2Mpa
         bVlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pr2ht/jeAn4kQ2w4KB1tHN+N5HXJH+sEW/wHfexG3m0=;
        b=hHThvrvc73EU0C3JVvy0H2a/T+RohWW+dj/LmM7BKuJ+fsrY4XURhdtkDYUflVBfpp
         6JEqIcK6fYb65u95FDblGqddNXkJGm5eGaObpjmzRfcqeQbNXvprIWCVOSb4deS2NTHA
         kSSeDYC39okKBdxlEGNS9UbqE0xbxOrvR7f7fWuCF3+vvK9taOLckv/sQVeX4v+bnAth
         wKcAGIglmPByqcJLHoTgQeVhOeOaGqOg4ISOk3Hhd/n3oev8Y0HXvKgusk+9oYBP/UXD
         jqxffHyJqAr/3mIiTWUPgpafma9+frvi7R5HZ3D1cIy8h2tqrCOzb+q7+khoiCA6r5gZ
         KByQ==
X-Gm-Message-State: AOAM533kiIncFrLx+OOFsD6S5FEjJg9jqRdRpcQWzTLVR9hM7qWy9uh4
        P5RXgh+B2vMcJrpfqEFYtywzgzU48/HVaKQ/
X-Google-Smtp-Source: ABdhPJyCD+31JaewoOma3Dzu2FkyYpLyDTe3ngJJJSVkshsZQU0WuVxXPwn4TCQejflpsyQa4NiT3A==
X-Received: by 2002:a63:e709:: with SMTP id b9mr5971462pgi.153.1623346186116;
        Thu, 10 Jun 2021 10:29:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r24sm8122427pjz.11.2021.06.10.10.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:29:45 -0700 (PDT)
Message-ID: <60c24c09.1c69fb81.3b3f3.920e@mx.google.com>
Date:   Thu, 10 Jun 2021 10:29:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.235-47-gbc8ebc13e05b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 135 runs,
 1 regressions (v4.14.235-47-gbc8ebc13e05b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 135 runs, 1 regressions (v4.14.235-47-gbc8eb=
c13e05b)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.235-47-gbc8ebc13e05b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.235-47-gbc8ebc13e05b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bc8ebc13e05b3f583cdce535c5fe93c6db7668bb =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c225b86b733987180c0dfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-47-gbc8ebc13e05b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-47-gbc8ebc13e05b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c225b86b733987180c0=
dff
        failing since 101 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
