Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB92E479B27
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 15:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhLROHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 09:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhLROHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 09:07:20 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF0CC061574
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 06:07:20 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso5588179pjl.3
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 06:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1S+4baBUNBP8FJ5ZRVb6vEPGPov3l9gVWHpVM8Un1Y8=;
        b=WQrb/QwSeHm3clplfkyWIr8bz0KJotbnUVAMhELPO3ILcC6bBCZvgoks5Fbnii0Xx0
         y2YJEcRWpkQXfYmjUb42+5PLUvy2WzwAPPMle5yrLBspftOH96skLFwwZi/kJ1+RJH3P
         IdsiPfgAx3L1NOWSqjBBKI+8FZDeAxkMZnNu5XbcpuscXpgeSQKqcw781YVS2zE2Nn1w
         59N0Rlaxxqlh/kYUmR5Q+T+8mL42rF5CzKFCmKlcrXHeYnPJcX0jwz8B9dPu7UIfp/V0
         vQav4UuFNsh8J/TVb9yPe4YDMkb+KYuErsR94FcykVOOrPMRgDI56clmL3hbcCKe808f
         23Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1S+4baBUNBP8FJ5ZRVb6vEPGPov3l9gVWHpVM8Un1Y8=;
        b=4PnnyUMLCg53FOvXqcmXDe66pB3UVcTmHKyAxhCL0sGEBYPERC02we8z/Ff29tEaWT
         ZAlh4LTCmh1uu9TFXJpQjwSbpN0cElhyNReAUNXi6E5Ufjk6OPwyPFylFDqOwD9TsbPw
         jfAg1c+lt5o4tYtO9sLNMp3ph5Yb8jsz68UH9scPt8ZTvFJL6ZDJUX7k6A6Dlv9fh1qj
         BxvHfTkdxpURKlh//XWgWClI90J45Gw/HI1WpSRraTMj6YajYx5kl0RxSKqhb2a5cHyW
         Cb26DRZcfnZrjJZn22q5JXOZZCONDDrvvp7j+LqHWezWXsrsT6w8TdKmriN0XL/7tUP0
         tMAg==
X-Gm-Message-State: AOAM5303ZMKaFl3GjKf3dUz/RRkB+Gv2Mh9ociFGgntu20MQy44/B230
        gX4mZo6p0l6K3xZOHNhLaixx929afJm+T0qV
X-Google-Smtp-Source: ABdhPJyYIEF2rLEJV2nrSYtdTnCGYTmSZkyQw2YZGWi/8p67mh/pd/gvlrFp1/CqV8PkJqSctR7VdA==
X-Received: by 2002:a17:902:b197:b0:148:a2f7:9d88 with SMTP id s23-20020a170902b19700b00148a2f79d88mr8207026plr.167.1639836438292;
        Sat, 18 Dec 2021 06:07:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id rm1sm15454092pjb.3.2021.12.18.06.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 06:07:17 -0800 (PST)
Message-ID: <61bdeb15.1c69fb81.5cf1d.9924@mx.google.com>
Date:   Sat, 18 Dec 2021 06:07:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-9-g7d306649b59e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 98 runs,
 1 regressions (v4.4.295-9-g7d306649b59e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 98 runs, 1 regressions (v4.4.295-9-g7d306649b=
59e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.295-9-g7d306649b59e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.295-9-g7d306649b59e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d306649b59e593fab5e47e5e788a7a1dff4ee84 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bdb3ecbdb701b7fa397156

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-9=
-g7d306649b59e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-9=
-g7d306649b59e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bdb3ecbdb701b=
7fa397159
        new failure (last pass: v4.4.295-6-g6cb713214ea5)
        2 lines

    2021-12-18T10:11:36.807488  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-12-18T10:11:36.815513  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
