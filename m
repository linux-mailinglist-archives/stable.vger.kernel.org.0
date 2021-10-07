Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E32425FF1
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 00:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237282AbhJGWdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 18:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbhJGWdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 18:33:42 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62711C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 15:31:48 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso7554359pjb.4
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 15:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EO9R4M3rXFGz/zE7Aw+2Z73g+x9ge6w+5bRuFzGBDWo=;
        b=ehuAT3ooshaeiYm2ZdYuaJnDcwPHn2uJxODzkHJc79V41mUDk6GmZSG+anFhj3yP67
         du8e82pb3n93m0pilUy2xWMJjUVFrNbed6QXejFvHNdf5Cl+CMlJIVnJumsrxze21T86
         GQJFcH6nJsnkHIFaLGHLUvrCebaNn9qXeM2tzMqxfIdU6OmdBIaxh+UHKNpi/wjKoAqa
         FJvkmr0xniqsaDv20lgTwmmsMrQHNHoJTObiVNm6K/AIT9lJh9zNWh0mUV0VrufnTyba
         zppXdH2WNqshgQR04BE0yfOQvfgTI8ufX7/NzhDzox1N41y09ozb/v8ZkStvMAL/TAzR
         IZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EO9R4M3rXFGz/zE7Aw+2Z73g+x9ge6w+5bRuFzGBDWo=;
        b=03KnMnoxj+ktPsdKW8PSG6tkdf637vNbvvJV346fNmpSrYlw1EZQXstJojnTkllhSw
         CCvetQyS0DYTWiL4nwfWx1XvzWaFXJLX1ZN2+9tJndwdlXFSie38sv6pX1uz2vEerLK3
         RW1Y/xIP7I442+0q7UxwAuIcW1sWOeIjd2taVKGVznIi4pWWsWnVNoHWhkyt+O5beFhm
         jlyPuW/Ce/aByfAqEsnlTk2I8zrZSQnts6zRBora+5yjY50bXoRmqNpDooeEBfbIAjrs
         8SEIf0dMZVQn9LvNvcONMTuvQ2sgrTLRsyAPlYUQY9kJI4fHSW/9zO4VovFAOCYh8cNE
         KNuw==
X-Gm-Message-State: AOAM531rnUottJoUwzTessEFjoXJcFcmiiSklHIcKyvoPa2vhgDeOwzy
        NMHSoiB7qit4SaZfjZyEU/RERWIfYalm5cZf
X-Google-Smtp-Source: ABdhPJxFvbq7G/ey58184I4eb1utQqnrTNc/hfLuKfc1yyxq5Fbr4ny0Sy0L7U4kUBHJX7BEg02WUg==
X-Received: by 2002:a17:90a:47:: with SMTP id 7mr7833248pjb.46.1633645907749;
        Thu, 07 Oct 2021 15:31:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l207sm385192pfd.199.2021.10.07.15.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 15:31:47 -0700 (PDT)
Message-ID: <615f7553.1c69fb81.cfd3.1c0a@mx.google.com>
Date:   Thu, 07 Oct 2021 15:31:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.209-12-g1736f0fa225b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 82 runs,
 2 regressions (v4.19.209-12-g1736f0fa225b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 82 runs, 2 regressions (v4.19.209-12-g1736f0=
fa225b)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.209-12-g1736f0fa225b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.209-12-g1736f0fa225b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1736f0fa225b3d1315c9bb431434b0f2fa1d0c5c =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615f41ee8aa7ea532799a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g1736f0fa225b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g1736f0fa225b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f41ee8aa7ea532799a=
2e4
        failing since 327 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615f41ee8aa7ea532799a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g1736f0fa225b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g1736f0fa225b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f41ee8aa7ea532799a=
2e7
        failing since 327 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
