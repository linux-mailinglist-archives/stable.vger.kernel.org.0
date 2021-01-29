Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6F7308ECE
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 21:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbhA2Uub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 15:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbhA2UtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 15:49:07 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACE5C0613D6
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 12:48:27 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id u11so5933843plg.13
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 12:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ta5yJArXkFXjjCOPXJbCL6F4cc6QV0zHmjBUcVCafcg=;
        b=HQC4yiTwzZskmgqUOrPwIhWL37EROHxA1orhg4LdZenjqU9Rp+LYRb9Q+3GN0UosrO
         cSJ3bB0jQ2tBNnCTUiXpnBDgLEyYwEJhDz1eBGoP8BL59B9TuPkF+sWtyonX4al6X7V3
         rAg/E67Y9FgRZ5Srq95Y87SVnig6q4rBrcac9QmbQbUj8w9SXerp6fTC+Ikc9dl7Ve02
         /j/HXJAUuSvF1hYTv7IQke1VCZlOSVL3kRdGdirVWL5SdUdc83tyTxGFbCkk4fC64b1W
         XGsQYdWuj28mNjALlf55eJTSx87HrvYpQgi3zG+I1FzfyP5qGAgY31kgE/2KSvdvX7wv
         KBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ta5yJArXkFXjjCOPXJbCL6F4cc6QV0zHmjBUcVCafcg=;
        b=X2+YkmtItwm0jdEc+MzVaoS8Vl9DpXacVsp3XwK1QhRji3pWTUvnMLwEOV2b5ANvlK
         9QLP9OV/ernbl2ch4pHXrDz/82f1xBnGh2qYV6BZQF4FWO9VgKtLF2ZmB4wvrxgsKOBb
         B/iTZdiFcKhgTEgn6mNoxo60aXc3TZLmNCqAJ6K2kAwGJ6UTq3t/AkcT3lY6UtLayfHs
         mc4S5+DkQw3jXwSWjyAJgKnATLU5ZVVQGeZtyO6PovqgEu/wq/tklkTL/xgKvwm0DGS7
         jPC9EcqH/I0l0gDyRV1QnxeQopXKhuMQcIoyctEB1daEUtMFBhA6Co6xAIMorcW0qmoF
         rEeQ==
X-Gm-Message-State: AOAM532hu6FxMo5hCA/sQbZwNW5XL3cxT5Bh8ESJs1qjNwnoeY1HWkgj
        akcoBK9iXfeqKzv3eUB7jIi8PjUKCEFdhw==
X-Google-Smtp-Source: ABdhPJzBSr81qemOJhOXsR2rpd2gQ2Dvx7D7M+dvjWiB7zcKgesz9dqWjJKNiZegeBKiFxEJSVgvDw==
X-Received: by 2002:a17:902:82cb:b029:e1:2b0f:da57 with SMTP id u11-20020a17090282cbb02900e12b0fda57mr1094716plz.33.1611953306307;
        Fri, 29 Jan 2021 12:48:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15sm9285613pfb.30.2021.01.29.12.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 12:48:25 -0800 (PST)
Message-ID: <60147499.1c69fb81.e7528.77c5@mx.google.com>
Date:   Fri, 29 Jan 2021 12:48:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.11-32-g8f959d40b497
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 195 runs,
 4 regressions (v5.10.11-32-g8f959d40b497)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 195 runs, 4 regressions (v5.10.11-32-g8f959d=
40b497)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
imx6q-var-dt6customboard   | arm   | lab-baylibre | gcc-8    | multi_v7_def=
config | 2          =

imx8mp-evk                 | arm64 | lab-nxp      | gcc-8    | defconfig   =
       | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-8    | defconfig   =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.11-32-g8f959d40b497/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.11-32-g8f959d40b497
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f959d40b4976e80c3090acc22567dd3d4661783 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
imx6q-var-dt6customboard   | arm   | lab-baylibre | gcc-8    | multi_v7_def=
config | 2          =


  Details:     https://kernelci.org/test/plan/id/601444234b4dd9ba31d3dfcd

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.11-=
32-g8f959d40b497/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.11-=
32-g8f959d40b497/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/601444234b4dd9b=
a31d3dfd1
        new failure (last pass: v5.10.11-2-g966747d2a376)
        4 lines

    2021-01-29 17:21:29.489000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-01-29 17:21:29.489000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-01-29 17:21:29.490000+00:00  kern  :alert : [<8>[   42.491931] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-01-29 17:21:29.490000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/601444234b4dd9b=
a31d3dfd2
        new failure (last pass: v5.10.11-2-g966747d2a376)
        26 lines

    2021-01-29 17:21:29.542000+00:00  kern  :emerg : Process kworker/1:1 (p=
id: 52, stack limit =3D 0x(ptrval))
    2021-01-29 17:21:29.542000+00:00  kern  :emerg : Stack: (0xc244feb0 to<=
8>[   42.538252] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-01-29 17:21:29.542000+00:00   0xc2450000)
    2021-01-29 17:21:29.543000+00:00  kern  :emerg : fea0<8>[   42.549724] =
<LAVA_SIGNAL_ENDRUN 0_dmesg 652473_1.5.2.4.1>
    2021-01-29 17:21:29.543000+00:00  :                                    =
 3ec50267 ef7aa600 c38f0c80 cec60217   =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
imx8mp-evk                 | arm64 | lab-nxp      | gcc-8    | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6014431d9439e2a102d3dfd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.11-=
32-g8f959d40b497/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.11-=
32-g8f959d40b497/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6014431d9439e2a102d3d=
fd5
        failing since 2 days (last pass: v5.10.10-199-g7697e1eb59f82, first=
 fail: v5.10.10-203-g7b2d1845e2139) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-8    | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/601442986ede7712afd3dfdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.11-=
32-g8f959d40b497/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.11-=
32-g8f959d40b497/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601442986ede7712afd3d=
fe0
        new failure (last pass: v5.10.11-2-g966747d2a376) =

 =20
