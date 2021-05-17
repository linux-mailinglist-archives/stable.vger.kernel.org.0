Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50249383D44
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbhEQT2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbhEQT2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:28:36 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1EFC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:27:19 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id i5so5373096pgm.0
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ieEeLnPOtnQgH2UR9y6NMwBTyoMD6Wk4D9GW0ZBZLRw=;
        b=ObW6l4RrdAmdrWCuDGXcNqrRnmBkLQD9W4ly3YxTTZcdVG7+CVnvi+SwnkoTMtJ8Ol
         b7ugn1uzPHRDSdaxOCKGLhWc9BW6ThKvQVWkA9ZHvq9Wh7ecJDMfWAFvaC3YYORDB9y8
         Ly1SZKN9/OYaom897WynVQsf68uDcr7HrzhVEaxB4qw087f1Z3EzvQmmmw/eRAHRWhWV
         iD12RKs5+WQFkp54jgo5lj8e2Kas7ruBLkYJT1p2h8//67AUK2dWLpreP/ro4hidsSeP
         y42nqIn54fTmWHr5OOfHqDcb/Mg/ZO5TufIYbKqBsH6AXGSY93JcZ4mNCe8W0Cs4iuok
         K1tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ieEeLnPOtnQgH2UR9y6NMwBTyoMD6Wk4D9GW0ZBZLRw=;
        b=iXg6/QAmY/Uw3s8RxoT6dLA5Sg2K9GL8BV0xuoYFaWwscAFfVQfBpf7y0c4mB2IKX2
         epuCV2VrNb/s8qYIv9hCpr+yMFzULFCwaaPXXS5kf7x+5gwmQqiGc3IdjyFheF715KXs
         GHm0J3A7rWNlrDbEHk1xaqmLzY29UMOyq9xLHJ+CU8g7E0XJ10jo75NKjN4nr140+K4+
         rbBVZTIf4COSf6M46IbBaa6Ai5KpJOClhqbuBmVg3ICfp3WvOHYhffRQCkbJM1W4HE9e
         I51xUFOjbmc2rxJ/Ws/gX9X+zVzzSG09EILL/qmWFrCyxXAjCRJVBYXZQRNMSaNbfFwk
         L8xA==
X-Gm-Message-State: AOAM530rG7r3XL6cHupHy/gs1Pv6zCq+T9X2avP+xfHXXndCS1YkNaMw
        y+kefnpwDMuRM7BU2NNxbftbgNhiL3Cooz8Y
X-Google-Smtp-Source: ABdhPJwPdu4Dy3bW0Tec4Rdz7Dlh3FgFiHYudxtVdr6NFIkiIXbW1OFDcgv01SIx/+760M4/Hh3gUQ==
X-Received: by 2002:a05:6a00:24d4:b029:2da:8e01:f07f with SMTP id d20-20020a056a0024d4b02902da8e01f07fmr1157642pfv.44.1621279639124;
        Mon, 17 May 2021 12:27:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q24sm11170259pjp.6.2021.05.17.12.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 12:27:18 -0700 (PDT)
Message-ID: <60a2c396.1c69fb81.35577.5510@mx.google.com>
Date:   Mon, 17 May 2021 12:27:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-394-g77a168e6bc05
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 118 runs,
 3 regressions (v4.19.190-394-g77a168e6bc05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 118 runs, 3 regressions (v4.19.190-394-g77a1=
68e6bc05)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-394-g77a168e6bc05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-394-g77a168e6bc05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77a168e6bc05d5aab68bcb4060645bf8eb914594 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a28e2127601e4c70b3afc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g77a168e6bc05/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g77a168e6bc05/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a28e2127601e4c70b3a=
fc6
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a28e2632d691dc2fb3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g77a168e6bc05/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g77a168e6bc05/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a28e2632d691dc2fb3a=
fa5
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a28e2e32d691dc2fb3afad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g77a168e6bc05/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-394-g77a168e6bc05/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a28e2e32d691dc2fb3a=
fae
        failing since 184 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
