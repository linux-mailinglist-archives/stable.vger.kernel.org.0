Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067D9418B4B
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 23:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhIZVsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 17:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbhIZVsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 17:48:40 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E57C061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 14:47:03 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w11so10355503plz.13
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 14:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V5KrxxNnrimhMnoz5DVnDZ3vFaTgyaC3C8/+Fgqfc4I=;
        b=yuWViLBf93ynDkomHi0EXErsQcyF+8wjsG2XteiyT5Opilo9phEu5/8L4sRxhjIXiQ
         dSZ0vYgJf5mWKO2Tk9ZDu0NzfQb3RIZ0syiDRy4pKfTcqw5nIFp707nTKGNRNRk3+5zb
         OmwWqjiNHpM9uRl3I33ntKczx9s9hV6kWr1wTAHDljHBumVw0kDbB/USCh/LC5ENtlmk
         WYDzZFgTPxPtxGB84LX5qPuX1AsbZgqy17yIi2PJBckEwORKDDo5OiX8I6GxXF3JGTFo
         SrFMiXd08vE1EhHwtS0IsJ3zBmmlc/WBRfuD9MnoFJoH0GYqmbxm9b36h3+AjbE6tCBG
         O5BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V5KrxxNnrimhMnoz5DVnDZ3vFaTgyaC3C8/+Fgqfc4I=;
        b=CM1OfCt3b3i1q3AhDZEUkzegJlV689w2dQZr2UriXJK0YitlsYQiadCn7eT89pKjig
         J88smjFprUpQTP4kAMITqg+3hNH4g/yKhPF0xszKKTYGPBp0P2UZ3QNeTorLXEV7SaQ7
         gr4Qh0ZFYwgKHzxL92omMB0SJiR6XLyi6CYtOtiCcSR7oqnUht0e6faAqpoELM71mvVf
         4wRXFMIMYBs0Eywf7T8sUrVBidNpb1uzT8y5oH1KUIUuShZfRyOmQTaLMEBzrE5bHoIj
         UuCqy9zkcjxbyXurB7K2ouPFRGy8YWtSLbzu1Rm0ATvYXxCSxqiNK33cSbnlKUrJRHh8
         ImYw==
X-Gm-Message-State: AOAM532mgEF3uXHMoM3P3+MkMEQwy8Rri0HsvWalzepfyykpd2NR0iBS
        1pGqIftyRIN6n4QrispZ9sZQTbdMtmiOcAkE
X-Google-Smtp-Source: ABdhPJwjcT3fiRvNPhBem23JnyHoCjN3GJCxgzKZ37tmlRR74SmVvhW0Iqjp2dCvzV9qkNnwfbCcdg==
X-Received: by 2002:a17:902:a406:b029:12b:c50a:4289 with SMTP id p6-20020a170902a406b029012bc50a4289mr19735606plq.56.1632692822783;
        Sun, 26 Sep 2021 14:47:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d22sm16003330pgi.73.2021.09.26.14.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 14:47:02 -0700 (PDT)
Message-ID: <6150ea56.1c69fb81.baca1.60fa@mx.google.com>
Date:   Sun, 26 Sep 2021 14:47:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.283-41-g1f3dccc71142
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 52 runs,
 4 regressions (v4.9.283-41-g1f3dccc71142)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 52 runs, 4 regressions (v4.9.283-41-g1f3dccc7=
1142)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.283-41-g1f3dccc71142/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.283-41-g1f3dccc71142
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1f3dccc7114205e3eb883d1e42e168d46ec2b801 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150b13e9aee2ec21499a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-4=
1-g1f3dccc71142/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-4=
1-g1f3dccc71142/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150b13e9aee2ec21499a=
2ff
        failing since 316 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150b1579aee2ec21499a304

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-4=
1-g1f3dccc71142/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-4=
1-g1f3dccc71142/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150b1579aee2ec21499a=
305
        failing since 316 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150b0d7ebfed0379399a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-4=
1-g1f3dccc71142/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-4=
1-g1f3dccc71142/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150b0d7ebfed0379399a=
2e1
        failing since 316 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150e00fa22692876c99a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-4=
1-g1f3dccc71142/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-4=
1-g1f3dccc71142/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150e00fa22692876c99a=
2f2
        failing since 316 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
