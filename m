Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780A63A13AC
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 14:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhFIME7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 08:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbhFIMDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 08:03:51 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD29C06175F
        for <stable@vger.kernel.org>; Wed,  9 Jun 2021 05:01:44 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e20so7316855pgg.0
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 05:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=psU4UCCRmw07cZuHFHXE4gXWb0Q5tVl6gIln+aYSSh0=;
        b=VSXwu7S7PmLmQ79LwvEEJhIFFiip179zm8wijCdQeGxPunPZKHcUGX6Ryl31/o9Kj6
         CvtKb8TDoD/SnztBQfJngv6eGiuwQ6I841Jl9e55+6nVRKzLUHM0hF6WwqZ3smiUr1LH
         NyHBnXiYKkV7JhGErBC2qu8zT36YzRJxXoEoe3uIYlxq4AKebQW4CNv+9gSVJIXguMbl
         csobPlN4fLgiHAB5NX2OW7k3zm3qOd4DxsfOGqOq/NHhJbX5ovPp0y6emdfqPEenyLUe
         Rxh5HOPfvvcgMQa62EhEu2e0NQqm1JqUWBSbxrRW/WTheizeTXfyyHvMF+jHeVqT9m9+
         p39g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=psU4UCCRmw07cZuHFHXE4gXWb0Q5tVl6gIln+aYSSh0=;
        b=HzDTHAQ5+bDk4qsAEfIBVwQwSlDMjUFMxspp4CCwbeV0mvSmSw2JGeV2w0sdAPlHcf
         AMtlB1hKwUISjOGwLLnbCZmVsRvH2Y85Wcv+NT27M55p4k2/H0qcwsrXHekl1LwM6UXX
         z/+gi8xnidkeQlevpWCtc+xSo0K5vaCOWSTB4cN3pujx3h7jR5jnA1a+9o6cAT/xu+XG
         +6xYTXqR/eZF+LqbWmh2i2qpqxoDKN4SK532bteBl5m9I84ywz6HdNVWq7fwo1s1Z4Oy
         SiReUTC72zOpz5P7oiy3skMOnW6v1OVfm8+qQtCr+RMWFZQa1lfE7VvZOzv5gaCM2Jyc
         buRg==
X-Gm-Message-State: AOAM530opfTFWmw+Tfyuy+r5OMD34BxbyYtJjvYpDIxk1t6KQbP9nliq
        fCXAaUBFf/E7raVT7F1Xt+dXxhu2kOxB/WUK
X-Google-Smtp-Source: ABdhPJzPytqz13U2atAVGCOCaiRwmNkUpSQBeEKr6U/EcBUjXF5A7j6uKs839Au7wbf1L+9CXiMOjQ==
X-Received: by 2002:aa7:8202:0:b029:2d8:c24d:841d with SMTP id k2-20020aa782020000b02902d8c24d841dmr4986579pfi.57.1623240103476;
        Wed, 09 Jun 2021 05:01:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a66sm11510787pfb.162.2021.06.09.05.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 05:01:43 -0700 (PDT)
Message-ID: <60c0ada7.1c69fb81.7935a.2947@mx.google.com>
Date:   Wed, 09 Jun 2021 05:01:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.271-29-ge3174a6e6085
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 113 runs,
 5 regressions (v4.9.271-29-ge3174a6e6085)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 113 runs, 5 regressions (v4.9.271-29-ge3174a6=
e6085)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.271-29-ge3174a6e6085/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.271-29-ge3174a6e6085
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3174a6e6085aaeba9b80c6aaa73bed458b8e7e9 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c07a2bc6332cef580c0e16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-ge3174a6e6085/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-ge3174a6e6085/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c07a2cc6332cef580c0=
e17
        failing since 207 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c07a8bd0beafeeb80c0df9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-ge3174a6e6085/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-ge3174a6e6085/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c07a8bd0beafeeb80c0=
dfa
        failing since 207 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c07a2ac6332cef580c0e10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-ge3174a6e6085/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-ge3174a6e6085/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c07a2ac6332cef580c0=
e11
        failing since 207 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c093498a05c128bc0c0dfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-ge3174a6e6085/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-ge3174a6e6085/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c093498a05c128bc0c0=
dff
        failing since 207 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60c078e6ca111d64240c0e18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-ge3174a6e6085/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-ge3174a6e6085/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c078e6ca111d64240c0=
e19
        new failure (last pass: v4.9.271-29-gf7249899b410) =

 =20
