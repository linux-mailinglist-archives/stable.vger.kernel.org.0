Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC86825EDA8
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 13:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgIFLc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Sep 2020 07:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgIFLcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Sep 2020 07:32:54 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49DDC061573
        for <stable@vger.kernel.org>; Sun,  6 Sep 2020 04:32:47 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h2so3195669plr.0
        for <stable@vger.kernel.org>; Sun, 06 Sep 2020 04:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q6cm9wV1ZwH8Dd2j4e+kr+akaMDrP9sBYexza1U7wdI=;
        b=0Jubty5vSSb2lkEzAIMkXBTwScxpXxRUqeQCnulFQtl9bM7rbmvMDc3F+D3+dl6hSM
         7z0LAFPbjjJbSChiWHmH3cx9Z8S18JuvVXlCzv2nVf/jKCLNjowVFkmJbdu8EMVlEveb
         bXvnrSWoZYW/8X2ybLJeBOFnOiFYPW6xbjKnYev8W0HvTo4SudGwqv/5JrpvsD5LItBr
         BeZWxGa2gSTepAVGE8CqG0gXuie3MNLWobe8QUQhPvE8chx6G+D30ML5fEiQp/M8myXs
         UE37HgGW6PniIjzRD5oLQNsvO1zxPqeAcT9G/sfSKX/Hh8IWdSum9pYgL04uo7muoMpp
         pPKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q6cm9wV1ZwH8Dd2j4e+kr+akaMDrP9sBYexza1U7wdI=;
        b=GAzDU0rtonQ+KkfwJ8NAf0C9iFY3Da22pKJu3PR+PptTDqaN6oo2ST3mszo0ccLrYA
         VHj6LiKdMlZjGMfsYoMfjsN1kQz+HhuK2iXgOyGxRbD/PR0RMIG8SQeONwetN4oMK4vR
         aoGkHhVCYGMqIKfe+9t1Ny7+HQdQ2scUOOyIr8OFILKNlQGS6JDeD0k/CNJgzS3UAmUj
         Yuvl4Ce+2G8rnJRtVDx+5wQ887XFoj07L/hm803TfW3G91juLPrTmzXWpkJhOyrDOrd6
         FcNIsKUrrNuRDw4+tWKh1RB+B/u+k0G+g7/0t3yl5jr4HCKUgcqa8tjsKNc2KBdq6MS8
         8S6g==
X-Gm-Message-State: AOAM532NGXbCM/4bEh9YvoZUzqU+miTfovnsKXrncJzhaCJReHWUfe4M
        1gLJJ1xZkeTMIbosaWKMe2kKay5yptnbJg==
X-Google-Smtp-Source: ABdhPJxUSsi2Rh2lRyt+Irdt9jlCEICS3o+pHiHRjm16ILClFQsZajTZ+RTbrmzIrsUmVxvIAC1cxg==
X-Received: by 2002:a17:90a:880e:: with SMTP id s14mr15969143pjn.140.1599391962852;
        Sun, 06 Sep 2020 04:32:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n26sm11751807pff.30.2020.09.06.04.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2020 04:32:42 -0700 (PDT)
Message-ID: <5f54c8da.1c69fb81.e4b11.cbc4@mx.google.com>
Date:   Sun, 06 Sep 2020 04:32:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.6.16
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.6.y baseline: 224 runs, 2 regressions (v5.6.16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y baseline: 224 runs, 2 regressions (v5.6.16)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig        | res=
ults
----------------+-------+---------------+----------+------------------+----=
----
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig        | 4/5=
    =

odroid-xu3      | arm   | lab-collabora | gcc-8    | exynos_defconfig | 0/1=
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kern=
el/v5.6.16/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.6.y
  Describe: v5.6.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      960a4cc3ec49f8292d0f837f0a6b28b03c54f042 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig        | res=
ults
----------------+-------+---------------+----------+------------------+----=
----
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig        | 4/5=
    =


  Details:     https://kernelci.org/test/plan/id/5ed79881eee60e39090c5dac

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ed79881eee60e39=
090c5daf
      failing since 0 day (last pass: v5.6.15-178-gc72fcbc7d224, first fail=
: v5.6.15-175-g4ceaad0d95e7)
      2 lines

    2020-06-03 12:32:49.684000  / # =

    2020-06-03 12:32:49.695000  =

    2020-06-03 12:32:49.798000  / # #
    2020-06-03 12:32:49.807000  #
    2020-06-03 12:32:51.066000  / # export SHELL=3D/bin/sh
    2020-06-03 12:32:51.077000  export SHELL=3D/bin/s[   27.744689] hwmon h=
wmon1: Undervoltage detected!
    2020-06-03 12:32:51.077000  h
    2020-06-03 12:32:52.638000  / # . /lava-89950/environment
    2020-06-03 12:32:52.651000  . /lava-89950/environment
    2020-06-03 12:32:55.479000  / # /lava-89950/bin/lava-test-runner /lava-=
89950/0
    ... (11 line(s) more)
      =



platform        | arch  | lab           | compiler | defconfig        | res=
ults
----------------+-------+---------------+----------+------------------+----=
----
odroid-xu3      | arm   | lab-collabora | gcc-8    | exynos_defconfig | 0/1=
    =


  Details:     https://kernelci.org/test/plan/id/5ed79817771232ffab0c5dac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ed79817771232ffab0c5=
dad
      failing since 1 day (last pass: v5.6.13-193-g67346f550ad8, first fail=
: v5.6.15-178-gc72fcbc7d224)  =20
