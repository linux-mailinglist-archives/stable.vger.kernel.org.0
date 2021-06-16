Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171213AA227
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 19:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFPRNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 13:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhFPRNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 13:13:07 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB07EC061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 10:11:00 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id v7so2538410pgl.2
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 10:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9ZZdwmecg/EgjFJAKdWDancgrKoHui6UZlQ6oo2NYO4=;
        b=o8AS4c7oCMIDPkaVsKG5WPIbE6vfnRUMTCBTtmY7E46puWtIAWbevkFqs1ULuarpOt
         WgvrLrNMdxZich32kB8x4j3XtiL/eQPQtdHKIT7CfbjpWjFuSH5GNuKRNPJcfBu1yO6P
         EOAhqDgCE9mxIJA3Dx5QVkBQOkZAhJm5OSfwi0qhB0IM6050BnobzlpxqnuZhUJXLE9n
         C+N01gTm0wDcR9g5oE7/NO6XwvH+9MK9j3moulAIqnLjaCbgFThokc8lH1+090Mw3eYP
         6quihQLgT9sTjpqnajuyR3wlTnITQGvFyU3alS99GUPlQMpmnGOB+F5awJmkH9QeST8z
         TYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9ZZdwmecg/EgjFJAKdWDancgrKoHui6UZlQ6oo2NYO4=;
        b=eL4TYCuk66qCn8rNtXmBZ2n0GkSvveJA7/ZUGlyS+fAVeGNNGvqqyv0xbZerESoy1/
         Hi67WDcHDYQ5/z+DlmaNHta70Oo5saOkrefzwP9cAlSIj6V6Iwc9lA70DWjzbNBbePOw
         nV4UJnjJBIWeFIbItttTe3n5cqU/37PXHQd2ogzrrVeWQAehHypQoG4BZ1NcKImjQV15
         ljBKnxfZGYbEpBDbUvgd2SsujJ5vc87v5kNsuPt9rgBgD6c5ZW5ELbveEp8ib8cEfrhO
         JLatSxp/5SuJ1qVjpEmrzdQ2unQe80Com32bqriYiJaljT1V4RrpsVG0/pWetl939c3d
         XwXA==
X-Gm-Message-State: AOAM532yEVizQFgNSPL4Ibw8ozwJ/EjZk0EWiFev+6F7Q6u53iu++x3n
        Vi/R8jOnYGIez7V84oa3kMQaaqFCkKY4uWpb
X-Google-Smtp-Source: ABdhPJzDngX48K+a+AxVKELSjYKk0Dj64PRxcxaCnsUTu8Cnd4UkQUwB4uadGqxUINzftsAGIa11yA==
X-Received: by 2002:aa7:8f0d:0:b029:2f5:2b72:2388 with SMTP id x13-20020aa78f0d0000b02902f52b722388mr901882pfr.44.1623863460243;
        Wed, 16 Jun 2021 10:11:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r24sm5764300pjz.11.2021.06.16.10.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 10:10:59 -0700 (PDT)
Message-ID: <60ca30a3.1c69fb81.acc78.0c5c@mx.google.com>
Date:   Wed, 16 Jun 2021 10:10:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 114 runs, 4 regressions (v4.19.195)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 114 runs, 4 regressions (v4.19.195)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.195/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.195
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      eb575cd5d7f60241d016fdd13a9e86d962093c9b =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9fff3363a8a5b4a413299

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.195/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.195/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60c9fff3363a8a5b=
4a41329c
        new failure (last pass: v4.19.194)
        1 lines

    2021-06-16T13:42:50.238951  / # =

    2021-06-16T13:42:50.249455  =

    2021-06-16T13:42:50.352802  / # #
    2021-06-16T13:42:50.361646  #
    2021-06-16T13:42:51.620725  / # export SHELL=3D/bin/sh
    2021-06-16T13:42:51.631141  export [   16.325654] brcmfmac: brcmf_sdio_=
htclk: HT Avail timeout (1000000): clkctl 0x50
    2021-06-16T13:42:51.631370  SHELL=3D/bin/s[   17.096567] hwmon hwmon1: =
Undervoltage detected!
    2021-06-16T13:42:51.631781  h
    2021-06-16T13:42:53.252759  / # . /lava-454973/environment
    2021-06-16T13:42:53.263269  .[   17.256516] Bluetooth: hci0: command 0x=
fc18 tx timeout =

    ... (13 line(s) more)  =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9fd2a48b9348f2041328f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.195/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.195/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9fd2a48b9348f20413=
290
        failing since 209 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9fe83cfb17b2b2041327e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.195/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.195/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9fe83cfb17b2b20413=
27f
        failing since 209 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca0577f1c4aa15c941326a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.195/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.195/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca0577f1c4aa15c9413=
26b
        failing since 209 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
