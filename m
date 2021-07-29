Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77653D9E6E
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 09:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbhG2H3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 03:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbhG2H3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 03:29:51 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E361C061757
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 00:29:49 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j18-20020a17090aeb12b029017737e6c349so5047505pjz.0
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 00:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J5tm2gENtXSAGcn/ou7ZB5/B4vLgFYXvzEdWwEZqbg8=;
        b=WZrp3nkh4VNda0QhkRnc9VuP0pPDlnH1aWSyxrOuEfHHCsj8RQMBCNerCPaOAuQQFX
         Qy5k/W1a04RGAW1Gleu4G1ir0JjhRRqzAulCZ3s0hFc1yU3OHpEtwDpb/FZtqzjHQJRK
         g62faxhSes6EO+qlblOixo0a8nUL4BivpGj/1ln/UMvaACafLgl+SoZXTJf5RjjgN0NB
         2zXwYyzdd/Pkz6930P5AN8WzFnrgMMasEnWu9yHxC9tQUHEM2OzE+1goX3sB6q0lu7FQ
         L4KkrQb1uKbCNPzDA3ayAOp+0OeWZvgyFbB13e+cikPCTC3YcM3sZjGtoOz0OUcM17Kb
         GzbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J5tm2gENtXSAGcn/ou7ZB5/B4vLgFYXvzEdWwEZqbg8=;
        b=c0MyYdluJ+DsC2abm8QpVUtOg5haafIXus7GLul5/1mRuhiCW6YwIvciKcanFZNrwN
         mABBCfMItT65kH9BrQIAMg2lvPgK5t51Y1cklBtwcZFpQEBz8EOvxsdDSN2k4sipdp2P
         m48Eq33nI3qlUw539ywZfdY7JDuTZ468wGNwFNsAjaMzMRxAhFyDSxiEKybPQN/GsD2v
         gI9pnaYEVnhT67kxg72BA4JpCTE0fbFJEie6I1GolMCb/6TlcoVp8vtDMUonBH/UWIHS
         ZGiOdBETjYx5prXZCEAtjhzkD0tUlVL7clJUQLdvuBHBnQzgw5Jebqi3Nnn2d4tCgK5e
         1WEw==
X-Gm-Message-State: AOAM531nWYSo5VVuTCtP7fOAHxBbDWd2vaJmIiqYauG5dtj+iHvqU0ch
        xym5V75+2WSxnc4cXE7PRVMTSnmXx+UKE83I
X-Google-Smtp-Source: ABdhPJzqkDpzLA7oM6zTbipEC7+6Y4eLGvpSO2GWPYvZMVQ2adnI69illLSesxHsDVMHirR8vWlj3Q==
X-Received: by 2002:a17:90b:158:: with SMTP id em24mr4011733pjb.174.1627543788711;
        Thu, 29 Jul 2021 00:29:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm8107444pjd.35.2021.07.29.00.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:29:48 -0700 (PDT)
Message-ID: <610258ec.1c69fb81.60c03.93af@mx.google.com>
Date:   Thu, 29 Jul 2021 00:29:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.277-2-gaf4b7daff4d2
Subject: stable-rc/queue/4.9 baseline: 87 runs,
 3 regressions (v4.9.277-2-gaf4b7daff4d2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 87 runs, 3 regressions (v4.9.277-2-gaf4b7daff=
4d2)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.277-2-gaf4b7daff4d2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.277-2-gaf4b7daff4d2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af4b7daff4d2d9e077f8658f07c91ac38dca0961 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61021c14b1673ca1085018ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
-gaf4b7daff4d2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
-gaf4b7daff4d2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61021c14b1673ca108501=
8cf
        failing since 257 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61021c0a70476ecd6d5018c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
-gaf4b7daff4d2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
-gaf4b7daff4d2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61021c0a70476ecd6d501=
8ca
        failing since 257 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610247b056e9fe87bc501997

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
-gaf4b7daff4d2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
-gaf4b7daff4d2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610247b056e9fe87bc501=
998
        failing since 257 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
