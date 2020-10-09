Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6062289A00
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 22:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390856AbgJIUuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 16:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgJIUuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 16:50:37 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6083C0613D2
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 13:50:35 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g10so7847564pfc.8
        for <stable@vger.kernel.org>; Fri, 09 Oct 2020 13:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Lwof0IAHSBV4FdUEFt0AdlRiTJBwlFLigJlIVyyTtR0=;
        b=SeLM/3LxGsC4YTC4+3lFhxhRIT+pFszq408fxCkCBesxmJveGYQksRUKgRBesyPWzE
         y/S3Jo09ukFcON86Citkrzbm0tAY3MIk/uacScYA9xcMobggsle8k2eVSvDbR3/iJbhl
         UmiYhYxUY03XtFZnNsoS/kYYFD6YHvpBH2sdCqmDmb8Ten4C4UCXX1PLml4RHIOa+rvS
         yX1ADBPcOGVP1lnKk/Qw5J8YolTWNR7R46jov0yCqcgmHWnZGyH4Nq2XHKD2Yvsoe+3I
         y8IBfC5GOmLLgSqdksqhwzQfF0KJsATeL/56QwQXnekZZzsblN/c9KbAybiYtW9MDDOI
         kSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Lwof0IAHSBV4FdUEFt0AdlRiTJBwlFLigJlIVyyTtR0=;
        b=Z3kuxHATU2xJuGDpfRCZ/Og0VSp/YTJttwi/2xKlsHrS6g9k5lm9FTqkTATLs4q4Zs
         A0q1wZLqgzlAmp3IEFrmI9W7THQl1WiR4rJv/fPm6fkK2k/egABEeQiXswtRTOihN6Dg
         Bp2NGzFLQdA1VznH5S79epXkHSpu3VQigw7csIrkQxH63ldECI38QuQvILKsFr+sDXVu
         mlOYHwyGdMLZAP1Z4h94SxZJH2WugUuOhfYa3S1ZurGF9Gk0gFLkVlzFw10vT92g1QdU
         gGm5vz/6qopKCj2rhIJZMlZ1SRHJQTLgNlX2h1bKFG74uqWkmcDf3V35vf4SwxRyUFdV
         RNkg==
X-Gm-Message-State: AOAM531Q03cU1wlJyE77zXZYl8U2DTD38z/wbxb8eszHT1KfI0dLeUxV
        qerOVDMYKshsStxMxAquQE8PRpPQd5wq0w==
X-Google-Smtp-Source: ABdhPJznyoqSUgJn4ZzXSNcvJ89lpc2DsYk5IkBFZAIKhz0Msm76Ku0OmRmfXKIJr/zgD0wWrfRgUA==
X-Received: by 2002:a63:d50a:: with SMTP id c10mr4903139pgg.26.1602276635094;
        Fri, 09 Oct 2020 13:50:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v1sm13109531pjd.7.2020.10.09.13.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 13:50:34 -0700 (PDT)
Message-ID: <5f80cd1a.1c69fb81.34689.7b38@mx.google.com>
Date:   Fri, 09 Oct 2020 13:50:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.14-25-gc00d9216fd6b
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 125 runs,
 1 regressions (v5.8.14-25-gc00d9216fd6b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 125 runs, 1 regressions (v5.8.14-25-gc00d9216=
fd6b)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.14-25-gc00d9216fd6b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.14-25-gc00d9216fd6b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c00d9216fd6b1140b33f2df5fa21938e6e884f8d =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f806acfc1c341ffef4ff3f6

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.14-25=
-gc00d9216fd6b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.14-25=
-gc00d9216fd6b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f806acfc1c341ff=
ef4ff3fa
      new failure (last pass: v5.8.13-90-g46814e92c3f4)
      1 lines

    2020-10-09 13:49:09.854000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-09 13:49:09.855000  (user:khilman) is already connected
    2020-10-09 13:49:25.129000  =00
    2020-10-09 13:49:25.130000  =

    2020-10-09 13:49:25.130000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-09 13:49:25.130000  =

    2020-10-09 13:49:25.130000  DRAM:  948 MiB
    2020-10-09 13:49:25.145000  RPI 3 Model B (0xa02082)
    2020-10-09 13:49:25.233000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-09 13:49:25.266000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (381 line(s) more)
      =20
