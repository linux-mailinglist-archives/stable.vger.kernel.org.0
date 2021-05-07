Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF49376C26
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 00:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhEGWLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 18:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhEGWLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 18:11:43 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44AAC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 15:10:43 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id z6-20020a17090a1706b0290155e8a752d8so6236532pjd.4
        for <stable@vger.kernel.org>; Fri, 07 May 2021 15:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/Q+9HPdmuf7JcZP0but/ofew8+JwdBSr4mQGTMGfr68=;
        b=zhtFfwGKpNULHnI42c3gOr2YnsHV9uCaR0L3HCCiqE0vDC65dlObyF7E85hklltmts
         W6PAnRWMtONRh4tb3AJQK9MPO2ade2IWREjhcHn6HW5Jn/nFSz6FXDGHABfvDWV0yzAd
         GK1dkEv1K1/SFmhCFjjfBUjIg51RZqAHvJ9mdtrnQ1FYzZ+WNaCxehPMdMihN7vPtX1F
         ZgFtEUBjKYZC1+o5b1xki6yNb2yXRsGEdaIjVtKAnqkd+iO6loUD2WP42+lYNSOLEcQs
         VESuk8Lzh2T9tu3SwI/V67SSkKv/50qFF/Q/IXGopeh853JkXzy/KG2ZaJ/mqQuWJGuz
         8l2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/Q+9HPdmuf7JcZP0but/ofew8+JwdBSr4mQGTMGfr68=;
        b=IXfb694qIj8iW9MlxldbgBWpXew0ZO03hyun7phEBpAqocqS1G/avMyC1Oj2e3Uwg4
         l82fpRU9uN0h2bnLlZ1tZi6jv4utraGMgm6HsWftQYtRX5GxQvuYQNvdHzxp6sfelAQk
         vwbuc0Z8jVKxVOzbxrHDHKhg30gkOcIu8VAdCFZCA6B9dkUzrx0vQi0tThX11YsX8gho
         CrJR/VgF198U1FFu8LxrV05EFzKXEFPnTWZophgWUzt6EQwgx4gVvJ1aJawtw0G0PSLj
         oSjJG4ugw1tGNyC+6u1NV8GuqVFaqdI4hublgUjx9vAqE8itnsOHbYs84w4AsDK00wsM
         4ARQ==
X-Gm-Message-State: AOAM53010LPv/XfF5WSkKVXyXRuD8oxZi+iP7JSn8dMsojHNFffhNBS2
        tRzZgsSjItTpJqVnWWlH8zeQrVI7SWFNGhB4
X-Google-Smtp-Source: ABdhPJzgpRlUT2Ppig5nASG+ArvuaBsYXvE0Shg7PIUbEGZS4DvB90m7WbM4nYFqd4Y4cH+WofqIVQ==
X-Received: by 2002:a17:90a:650c:: with SMTP id i12mr26324775pjj.204.1620425443092;
        Fri, 07 May 2021 15:10:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g18sm5603704pfb.178.2021.05.07.15.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 15:10:42 -0700 (PDT)
Message-ID: <6095bae2.1c69fb81.71475.1527@mx.google.com>
Date:   Fri, 07 May 2021 15:10:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-15-g03886d347dda5
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 88 runs,
 4 regressions (v4.9.268-15-g03886d347dda5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 88 runs, 4 regressions (v4.9.268-15-g03886d34=
7dda5)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-15-g03886d347dda5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-15-g03886d347dda5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      03886d347dda55f28d466794bd68db52ecd9e570 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609586d687898527776f546c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
5-g03886d347dda5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
5-g03886d347dda5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609586d687898527776f5=
46d
        failing since 174 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609586bb6dd2d9c6416f546d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
5-g03886d347dda5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
5-g03886d347dda5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609586bb6dd2d9c6416f5=
46e
        failing since 174 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609586d6804345b5c46f546d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
5-g03886d347dda5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
5-g03886d347dda5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609586d6804345b5c46f5=
46e
        failing since 174 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60958671c0817012056f5471

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
5-g03886d347dda5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
5-g03886d347dda5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60958671c0817012056f5=
472
        failing since 174 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
