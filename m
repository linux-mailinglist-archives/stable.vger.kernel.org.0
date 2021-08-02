Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F883DE006
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 21:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhHBT15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 15:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhHBT1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 15:27:55 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E09EC061760
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 12:27:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b1-20020a17090a8001b029017700de3903so754648pjn.1
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 12:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ta2JDn2zD10Es1fKMNHcJ+hAGS0Uf6XNtRvNVPquB70=;
        b=wNeqXtKa818sr/lGXQXwI+KOxAoomvy+UJjAvWUzmMnVEgzZg80S9ijiBg7VmXnGCn
         oX1YRjB/yfk2MICMgx/gxmE6PnpT3M48wmGXafxO3q8DEp6niD1idc2+x4liqKqUj9bm
         enwaLcgc7smW8ZmG6TQ/zh111WdEoQlOJz1K8uZ43FPeKEaCZ8/jeFI7JCaK10cN2fpU
         NK4eSibqTlpO0Da0nKG7jewjtdaZiPp0UsokFZSjc0NEHgnbMgjPeYF0/z8G1N0oX5sX
         MkoJmEFdARUBDTmPGFMF7MbwjxyYEZJlrP14ovMmgVYPz7sKH1EvxKjToI+VB3wgsv2d
         XNOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ta2JDn2zD10Es1fKMNHcJ+hAGS0Uf6XNtRvNVPquB70=;
        b=pwp5HgTGAOLBS6Eq8RFGYGnI8bFYi04YANOD8TNotCRwfmNY6taPAFegbovgTxFnWX
         x/QvebRyFEd8jJpcOUeclax4ShtQZGyTfeF77thyHBHEqDpEFxaAqGGi1VaJrv1xjYNC
         d/C9JkPP3LkFekOc0pf4kMBuBZ+b7vNMUkYRcn2zg/ahWmeKpvgJErFJtH7Np3viVNQo
         GtK5Ew5QOqX7eItZxSMChS49q86DEOVdI7nEnp4CNxd84CIL7eSN1Nfu3ejFLoayDuDU
         xXsP5SKXq6O+Lu1ZXUkBIBfiLLwdGn4Ce2Dk0WXD4dm+4czz8rLPOpXP42nt0VwAEpcs
         Hyqw==
X-Gm-Message-State: AOAM531Vro98B9fw+8iWRXMNi2G5RjEcA/3GIVgjobOjMnY1/tetg7j4
        CkukYBwhrHZlVQBFszzsE6tL7OnxJawkSQxH
X-Google-Smtp-Source: ABdhPJwJOAU3IGCj4wCYY0JpLZ+bVqQBoDHAq+npqjxiZA9q8J0C6gK7NgIFtZWdaSXmpu3hiNbw1g==
X-Received: by 2002:aa7:8b4a:0:b029:3a9:d493:19fa with SMTP id i10-20020aa78b4a0000b02903a9d49319famr18059038pfd.55.1627932465406;
        Mon, 02 Aug 2021 12:27:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e4sm14289505pgi.94.2021.08.02.12.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 12:27:45 -0700 (PDT)
Message-ID: <61084731.1c69fb81.c9218.836f@mx.google.com>
Date:   Mon, 02 Aug 2021 12:27:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.55-67-gb533974270fb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 126 runs,
 3 regressions (v5.10.55-67-gb533974270fb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 126 runs, 3 regressions (v5.10.55-67-gb53397=
4270fb)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.55-67-gb533974270fb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.55-67-gb533974270fb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b533974270fbdae9e266ea53e515e7e8abebb926 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6108194037ac2c9b9fb136cb

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
67-gb533974270fb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
67-gb533974270fb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6108194037ac2c9b9fb136e3
        failing since 48 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-02T16:11:34.428276  /lava-4307776/1/../bin/lava-test-case
    2021-08-02T16:11:34.444245  <8>[   13.239190] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6108194037ac2c9b9fb136fb
        failing since 48 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-02T16:11:33.020217  /lava-4307776/1/../bin/lava-test-case<8>[  =
 11.813650] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-02T16:11:33.020749  =

    2021-08-02T16:11:33.021169  /lava-4307776/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6108194037ac2c9b9fb136fc
        failing since 48 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-02T16:11:31.982320  /lava-4307776/1/../bin/lava-test-case
    2021-08-02T16:11:31.988210  <8>[   10.793981] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
