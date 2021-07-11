Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54913C3FCF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 00:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhGKWtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 18:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKWtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 18:49:51 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456BCC0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 15:47:03 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b14-20020a17090a7aceb029017261c7d206so11606446pjl.5
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 15:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L8VyC6eL0L0BRxK/1GyVCCO1Z8b94m7j6DxvZPoK0d0=;
        b=SE80vnQ3MqFlRUD5wdtPYw4Yh3bahT3pn0omZ68Z1FjqloGj6kfC02xbJvMYvkyIFK
         A+n5GnbiwAndExFy6k9EoTC6Zu4sue3P0apZ0ZA4bdD/iyEPxbF6I1b1ft33SpzVcSBX
         bjpWtuLddHd3Sa0FokxY0BgY3VitHklQFU9zoSXEz/ie7eZZok88qZaS71MHZzNaT30u
         EjQ5KiV/gghvWBRqO2OaEPfa5iyV3ONJv4dqgXmFvT5BvWD0uuwkaJnVsFLSm0OvHksz
         /DJxpmKsstPL1RKP5el++iI7CrBbVfc3pJ51l1lh5d1h//tVkRyZEoAHUeV2ttoWJVL+
         24+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L8VyC6eL0L0BRxK/1GyVCCO1Z8b94m7j6DxvZPoK0d0=;
        b=eUIt96wv4ThMfB9A3cbqZTlIrlqS4ssWIa2QAR9sF/YVrYs57leH79S1eEgXEcMya0
         Ztr+g0QH8gJUR9Ke91kp/xdTOVqtaA6kpBf8E+eTUBCPxjBygKXxWgFhIGsMjC8leyWL
         CS1UCUlPtX62ZxisaW+qbVOnPzQhBqDYO+lnIKHp7//1yyX7r0y2HZEJr0R53/mk48gL
         aA9decEZIFnYR7zIeivL6WZlEq5WLCTpQQck4vW/wnYoC8nboHERKN1FJEfDcXfDu2fm
         ALWDl92fgr6apBUta4RGF8Ya60TTsVISiGZgNEOrpIbYlBhyJ/H01vSFRFtJ6nQtg0/P
         uWyQ==
X-Gm-Message-State: AOAM53019TV4dNdYN7cEOdx+/6LMEXxeRUYEuYJs/IoA2TcDG9V68XtA
        lITSeYvufHQjHPQKZgMAL0YQuDCdlofBO215
X-Google-Smtp-Source: ABdhPJx6NQdIXUg2gSQa/3S1mMmnNhLs76zhzQ10AJx3qeb7VBuNEoD4oJctNEgF/Hokdhz4peBRag==
X-Received: by 2002:a17:90a:7349:: with SMTP id j9mr11091198pjs.235.1626043622663;
        Sun, 11 Jul 2021 15:47:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 2sm15325677pgz.26.2021.07.11.15.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 15:47:02 -0700 (PDT)
Message-ID: <60eb74e6.1c69fb81.d62c6.da6c@mx.google.com>
Date:   Sun, 11 Jul 2021 15:47:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.16-701-g2f79637ed64b2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 185 runs,
 4 regressions (v5.12.16-701-g2f79637ed64b2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 185 runs, 4 regressions (v5.12.16-701-g2f796=
37ed64b2)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =

d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig=
             | 1          =

hip07-d05            | arm64  | lab-collabora | gcc-8    | defconfig       =
             | 1          =

meson-g12b-odroid-n2 | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.16-701-g2f79637ed64b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.16-701-g2f79637ed64b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f79637ed64b291bfb619ef4238a419b1f4f041a =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb45374f0513e35311799b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g2f79637ed64b2/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g2f79637ed64b2/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb45374f0513e353117=
99c
        failing since 0 day (last pass: v5.12.15-11-g1a88438d15d2, first fa=
il: v5.12.16-682-g36eea3662e2d) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb468c5ed9dd48de11796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g2f79637ed64b2/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g2f79637ed64b2/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb468c5ed9dd48de117=
96b
        failing since 0 day (last pass: v5.12.15-11-g1a88438d15d2, first fa=
il: v5.12.16-682-g36eea3662e2d) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
hip07-d05            | arm64  | lab-collabora | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb5615fb5e6ef4f8117974

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g2f79637ed64b2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g2f79637ed64b2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb5615fb5e6ef4f8117=
975
        failing since 10 days (last pass: v5.12.13-109-g5add6842f3ea, first=
 fail: v5.12.13-109-g47e1fda87919) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
meson-g12b-odroid-n2 | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb44a5121419ce3711796c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g2f79637ed64b2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-o=
droid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
701-g2f79637ed64b2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-o=
droid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb44a5121419ce37117=
96d
        new failure (last pass: v5.12.16-682-g36eea3662e2d) =

 =20
