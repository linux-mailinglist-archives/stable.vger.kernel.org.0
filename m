Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255E83C5BD3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 14:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhGLMCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 08:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbhGLMCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 08:02:54 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EC2C0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 05:00:05 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b14-20020a17090a7aceb029017261c7d206so12582430pjl.5
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 05:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M1CextX+As1XDLTNoz+tk50EWoEam5dwS0h+7hjGKis=;
        b=tGCM3mfeXKqqLw6PvWecv5HRSjO3e5iuS1/aOH1wqEy6ktZhqd2cu45jrXOU3eFkPN
         zii2HPvLqw0Y8nae0ngBHqOnQUh3slCru2dKl3HX0yReEeRzEcFbA6XmtsEvw7lZavGU
         566e7orND58hRwbYIVSrONqCWGhumddj3D6xmpTDZ/EypZp5KiG3OxX6enFTCSofzRoK
         q12nAOB9YFBBEDhPiMf2WUrM6xzDt+AXMnfknCvjnBkEEeB082Cw3b702FlZTwXwXloH
         iGZKI43v7PxcHw3IX0kcev/Eyia5OyzFfqjNmTsaLo11JF8NZckJWBbE7QOrdikZP1zm
         QcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M1CextX+As1XDLTNoz+tk50EWoEam5dwS0h+7hjGKis=;
        b=XzlZJtek0+/alkgktcs4qeuUxOw4UGAu56RgKXOgrda60kZ46Aomu6ONyC0F+T1otz
         lnqctqXhyX1IfdkwRchJJgAu41DKO2Zh7O/uyxZWsp3jI9W/ZomVtd0zQJh35+3omUrU
         bNSQ2W6Qd5s05B6kPntS4drf9X3NExp8K4HX8kIR0tFMqheG7qoWkjdEJtdq+B76szQC
         Aj6PqFK4Htjw/6vnOUC79qVWMxcJgl378CtUya5+NL+6jDtY2yPGOz1h7ZYIDVHuyufz
         h5rQfZyu8QwpcPxrhk8azRxpBnomn++ZU4VGf3wJ3eM1ulHaNQBY7Qri0435ZlJXh/BP
         9UHw==
X-Gm-Message-State: AOAM531ywzQgaxCh7eiN1FkpCTkNWECsYXceGlXhbwL+AX6preRWCtPC
        oLcRoSkE7OigGS5zOk9wEl3xLrI3BXa+Syqj
X-Google-Smtp-Source: ABdhPJwMVWppL26h0kL2WFkxn0HNA6qo9LZWOPnK5EWNGdl+OWkYKHCSGKyAh0wHjsCKflLB37NlPQ==
X-Received: by 2002:a17:90b:1102:: with SMTP id gi2mr14126687pjb.75.1626091204482;
        Mon, 12 Jul 2021 05:00:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y4sm17360475pfc.15.2021.07.12.05.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:00:04 -0700 (PDT)
Message-ID: <60ec2ec4.1c69fb81.195ef.12f2@mx.google.com>
Date:   Mon, 12 Jul 2021 05:00:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.239-158-g3e9219de38bd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 100 runs,
 4 regressions (v4.14.239-158-g3e9219de38bd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 100 runs, 4 regressions (v4.14.239-158-g3e92=
19de38bd)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig            =
        | regressions
-----------------+--------+--------------+----------+----------------------=
--------+------------
meson-gxm-q200   | arm64  | lab-baylibre | gcc-8    | defconfig            =
        | 1          =

qemu_i386        | i386   | lab-broonie  | gcc-8    | i386_defconfig       =
        | 1          =

qemu_i386-uefi   | i386   | lab-broonie  | gcc-8    | i386_defconfig       =
        | 1          =

qemu_x86_64-uefi | x86_64 | lab-broonie  | gcc-8    | x86_64_defcon...6-chr=
omebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.239-158-g3e9219de38bd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.239-158-g3e9219de38bd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e9219de38bd7b02979c0bf51277ee08f186e018 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig            =
        | regressions
-----------------+--------+--------------+----------+----------------------=
--------+------------
meson-gxm-q200   | arm64  | lab-baylibre | gcc-8    | defconfig            =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb61dd73a73be590117974

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-g3e9219de38bd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-g3e9219de38bd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb61dd73a73be590117=
975
        failing since 132 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform         | arch   | lab          | compiler | defconfig            =
        | regressions
-----------------+--------+--------------+----------+----------------------=
--------+------------
qemu_i386        | i386   | lab-broonie  | gcc-8    | i386_defconfig       =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb6019c62b75db86117977

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-g3e9219de38bd/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-g3e9219de38bd/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb6019c62b75db86117=
978
        new failure (last pass: v4.14.239-158-g685789d7bbb4) =

 =



platform         | arch   | lab          | compiler | defconfig            =
        | regressions
-----------------+--------+--------------+----------+----------------------=
--------+------------
qemu_i386-uefi   | i386   | lab-broonie  | gcc-8    | i386_defconfig       =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb60185fc629841311796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-g3e9219de38bd/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-g3e9219de38bd/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb60185fc6298413117=
96b
        new failure (last pass: v4.14.239-158-g685789d7bbb4) =

 =



platform         | arch   | lab          | compiler | defconfig            =
        | regressions
-----------------+--------+--------------+----------+----------------------=
--------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie  | gcc-8    | x86_64_defcon...6-chr=
omebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb5f78b25bbd49ac11796f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-g3e9219de38bd/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-g3e9219de38bd/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb5f78b25bbd49ac117=
970
        new failure (last pass: v4.14.239-158-g685789d7bbb4) =

 =20
