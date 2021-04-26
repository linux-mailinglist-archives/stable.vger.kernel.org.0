Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4181D36B430
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 15:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhDZNnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 09:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhDZNnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 09:43:00 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772F9C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 06:42:19 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so5230946pjh.1
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 06:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7UseeIaMmveu74ZH/Wrc8S3zclR50CG2PtvsCl9zxVc=;
        b=eM+/ioLRk9HA6GecneKeZo5I5YP6460DC1BlYvjLyYe3J3xXGUaQY1jM+LRo67qJqu
         Uu2oP8d1CVVaZ9UHTa/tSwJQYiR2AesalHgDMKUg9D+hzaFG1nKjniwqXrkLrCHvHYUV
         QwlQ7kW6PZHfdhBbG2PLRHmjVLb/pP65J+nb36ll8/tcHJFnHigxfIp3hlCf8jQ5tvu3
         ukkj9O80u6LZXpCljtx8TexX3xPVSs/h3qAezBfnDZZllGkzfJBXxVBilEZwF38/9o1t
         S5NcELNxZ4ThCRDsMU3Dr3HRebzBt8B3rcdP9QUrb41JYvNCHqarjhfVuRYnPAC0jOWG
         auyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7UseeIaMmveu74ZH/Wrc8S3zclR50CG2PtvsCl9zxVc=;
        b=HCEqUaANwt672Gl192eyl8js1UOTen9nFz5sDXtrQaiHrUhmT+5bzD4mKigbtdTe/k
         HeY4N/OK/gQ7mP8bW4Q45tT+EJ6BOuNxkx/wBjPAwmCI7FG6mn2Ay/uMTEle1kRyK7Ct
         /te0Qrtn+mhebO9Ga/rHhAr48XlzEjq8Zti9H46vw3J9gkVYzJuEgbbYU/KF+xek6Py0
         XfqZYvy17B3V26KJ5T6lZmKVeaN3tciWxQjSudk7hJbRJVABB5EzEX5rFvfTiyKtY2Pw
         Xz+5tHipBN1jqUilWwKaLB6+Enw7mk39szMWtIuveB+j605Vk+n9MWvwHydJMPCVK6KK
         tufw==
X-Gm-Message-State: AOAM530n/pTkJqb4ymeW1RvrviaTbnHSu+qqMNv/SrA+Y9vpF8NEYBNH
        YwU8mDyYRWs+ioDY2DxHjueukYkn5B6nxliq
X-Google-Smtp-Source: ABdhPJygFyPuGGTBJTtdAIiHBFe8F4ORF2bG5W6oa4zjJQURWN/cypo0JbqWcdJug2JjTVp89/VQAA==
X-Received: by 2002:a17:903:22cb:b029:ec:c30b:cf69 with SMTP id y11-20020a17090322cbb02900ecc30bcf69mr18712168plg.67.1619444538708;
        Mon, 26 Apr 2021 06:42:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j29sm11201801pgl.30.2021.04.26.06.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 06:42:18 -0700 (PDT)
Message-ID: <6086c33a.1c69fb81.5dd04.0cff@mx.google.com>
Date:   Mon, 26 Apr 2021 06:42:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.114-21-gf9824acd6902
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 146 runs,
 4 regressions (v5.4.114-21-gf9824acd6902)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 146 runs, 4 regressions (v5.4.114-21-gf9824=
acd6902)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.114-21-gf9824acd6902/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.114-21-gf9824acd6902
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9824acd69029477e99bf0757f1589371108dba5 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608690039576b036649b77aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
-21-gf9824acd6902/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
-21-gf9824acd6902/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608690039576b036649b7=
7ab
        failing since 162 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60868e5a720361b2ab9b7795

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
-21-gf9824acd6902/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
-21-gf9824acd6902/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60868e5a720361b2ab9b7=
796
        failing since 162 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60869065f26768e17b9b77b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
-21-gf9824acd6902/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
-21-gf9824acd6902/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60869065f26768e17b9b7=
7b2
        failing since 162 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6086a8cf8815cb60499b77a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
-21-gf9824acd6902/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
-21-gf9824acd6902/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6086a8cf8815cb60499b7=
7aa
        failing since 162 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
