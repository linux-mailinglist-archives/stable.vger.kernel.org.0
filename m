Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C483CF237
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 04:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhGTCLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 22:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbhGTCFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 22:05:20 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B12C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 19:45:58 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o8so10730606plg.11
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 19:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=831GFGNjqbXsvuC9DeMMhQjctGPHmdoBoB7CulrWMkk=;
        b=IcJf4e22dyvukQBu9fFH51VDv8SqS/m0OEAzyNos9SAowJNvOoktKeMbMxLB3nlcN6
         1GOLB2513vw13J2oqEeK2Up5DYPYns3FVoduqf0+THgj0tIpoSz7eJvjyax52paEvJPw
         z5G2ZLsVxdbp3AgibeAjcZp3TN8RGXQ2H7PyROUhfaipaj359eTmwkUSEtJuiKG7qNuw
         AnB5tKK3Eu5N1n9lofoRhJTLFEep2y16EN3BkJ9H7jyl3EhzgvzP0AH469YPTkQ/Ffgq
         Xe7P2elsJWFr1UHnjwaPXjZKsR2Vy+5OByxo4yeWFW8OLlSbizK0iG/dTqxcfbSmIlfS
         uZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=831GFGNjqbXsvuC9DeMMhQjctGPHmdoBoB7CulrWMkk=;
        b=bpnJqf2joeXCA9yDtG5xr8WFLpb5L8bCfpoMz3hqbNieP34ctVbHlCfr7j4F3Bx80s
         g0PdHSFiRbbfvZHhe8l/V+9NL7ENSFtfb6p0LdBc6q9yJFLPLTjjn50f+hGXPl1wTOyu
         qQDEFI8k9736Mwtmy6j37r47utmq5QbiXtuO0bDI/EeLaObIzvDRn49CconQjj2rc+Nc
         gS7iOus37WoLzB6vrnTfSUsYT3tGLgw/Nof1/V7fXZDOCPl8zj3+WOBUxVt0EBPcQ5+B
         zEpodWKrJ8avFeMdt4/xs/wxpdb+cA/4plNQ184meLln3vndI/chb4fHzom1VU3MA8qx
         Nu7w==
X-Gm-Message-State: AOAM530skNxtKU8wUdRxaZpoKedGS+9RqVh2uvUSJh7Ws0b55X3HJ62r
        dqwAEWWr1QOqjVZrfVVI068InJPVHZMcYA==
X-Google-Smtp-Source: ABdhPJyk5xu3cCp+hDvLTuNXSAJUBB++gcHt8dVvgzn/pxBgrSUIppQawA/Ab6f5BCZLg1joZ6MjMw==
X-Received: by 2002:a17:902:d113:b029:12a:dd22:40c7 with SMTP id w19-20020a170902d113b029012add2240c7mr21956606plw.19.1626749158135;
        Mon, 19 Jul 2021 19:45:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13sm22388907pfd.11.2021.07.19.19.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 19:45:57 -0700 (PDT)
Message-ID: <60f638e5.1c69fb81.c68c1.4003@mx.google.com>
Date:   Mon, 19 Jul 2021 19:45:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.275-245-g2d0ea12363fe0
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 129 runs,
 6 regressions (v4.9.275-245-g2d0ea12363fe0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 129 runs, 6 regressions (v4.9.275-245-g2d0ea1=
2363fe0)

Regressions Summary
-------------------

platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
at91-sama5d4_xplained      | arm  | lab-baylibre    | gcc-8    | sama5_defc=
onfig     | 1          =

imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig  | 1          =

qemu_arm-versatilepb       | arm  | lab-baylibre    | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-broonie     | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-cip         | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-collabora   | gcc-8    | versatile_=
defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.275-245-g2d0ea12363fe0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.275-245-g2d0ea12363fe0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d0ea12363fe09e9489d913944f1ee5d61850fbd =



Test Regressions
---------------- =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
at91-sama5d4_xplained      | arm  | lab-baylibre    | gcc-8    | sama5_defc=
onfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5ffe91f65e0a7011160ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5ffe91f65e0a701116=
0af
        failing since 263 days (last pass: v4.9.240-139-gd719c4ad8056, firs=
t fail: v4.9.240-139-g65bd9a74252c) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5fe1384e4b3f68d11609c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx=
27-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx=
27-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5fe1384e4b3f68d116=
09d
        new failure (last pass: v4.9.275-166-g89c4717776ca) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-baylibre    | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5fb6cbd561a94ba1160b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5fb6cbd561a94ba116=
0b5
        failing since 247 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-broonie     | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5fb79551b0f7be411609b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5fb79551b0f7be4116=
09c
        failing since 247 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-cip         | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5fb7abd561a94ba1160b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5fb7abd561a94ba116=
0ba
        failing since 247 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-collabora   | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f609b9b69f43557311609a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
45-g2d0ea12363fe0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f609b9b69f435573116=
09b
        failing since 247 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
