Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A5135F567
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 15:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhDNNrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 09:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347911AbhDNNrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 09:47:49 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9831C061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 06:47:26 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g16so487592pfq.5
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 06:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hoOPBwYsAVBTvEGjGDVccVzpEMKQ5nk1io/ZwHwq1M0=;
        b=YyXVYZjB75VMhg+wbic1L8MDoeXJgyoC24AZNY4/v+srBUKJ0B91Ns4pyI5C3Z0OEf
         uqVDxlGX/xKtzU9ELi7/sWFmOIq065/gT4/eeqE4a9q8Fu3tvGyLNnQpxiOttJ0/pfKO
         TgTASlwxShULIsf8U7TA3QPi2aOzAPMZb2D9xnqWW7lTntiQPRuu8/v8cabc9cICuuEA
         4oZ8JsgkZhor9SlW+8uGL8VzzMiR5rewq9L/rwvJGWz/t0SndOOpF2jjJMc3xjQQNA/t
         AYgxjGpdxB75QmAOviTxnPjzCzncTYPmg9xKlKg3qi3gY5XD7dv3ES6iE46+eZ1QHerO
         y91Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hoOPBwYsAVBTvEGjGDVccVzpEMKQ5nk1io/ZwHwq1M0=;
        b=XtCkT1Daniot5qsUofeLqEOnR0pEjXjCnN444R02o79UlkmoaAFGkCVDhOGZxTgSc/
         WvUd6a8lG8hQ7LWXovARhBittOfNKnmaIUnbViCiM5Z/7FGpbZzMI76honyfl6eOqSZ/
         nn68xJnUBfILFONNjlmzLOSepgMZiqyyAmkhzAyMn8ViMaI6kkNw/D3KYyZj8bJAAO4C
         Hbakw652hjeAg8O37XklcwXzRz/BPQEkFefP1q+To0EMaKbtd1bYClO0BXHIq4Wq4eYo
         zPhv06Pze7b2+Om7Pea+S7w9sQf60g90tAxh16fkVnUxRgDJruz5cAhEcv3aI1quqSSQ
         kLmg==
X-Gm-Message-State: AOAM530gDLjjACAp0GcOgoSkxSkWnpWnxIHmniBohWDCuGHguIE6CpGN
        RSj4C0x6sllogTfWKQ3k/jVapMZNwKwZdw==
X-Google-Smtp-Source: ABdhPJyvhjmszP5MJuaNSYHT4S6rQJLmIdCljcGxPcvwBMT9AAKG+VebWzaF5OIDj61NPnxDPtBdmQ==
X-Received: by 2002:a63:a47:: with SMTP id z7mr34733917pgk.350.1618408046122;
        Wed, 14 Apr 2021 06:47:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13sm7526647pfd.64.2021.04.14.06.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 06:47:25 -0700 (PDT)
Message-ID: <6076f26d.1c69fb81.e6719.3fc2@mx.google.com>
Date:   Wed, 14 Apr 2021 06:47:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.187
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 130 runs, 5 regressions (v4.19.187)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 130 runs, 5 regressions (v4.19.187)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_x86_64          | x86_64 | lab-collabora   | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.187/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.187
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0f1b4cb77d7f5a442b03f8ad597768b422e8ec58 =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076bd5b87578455d3dac6f1

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.187/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.187/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6076bd5b8757845=
5d3dac6f6
        new failure (last pass: v4.19.186)
        2 lines

    2021-04-14 10:00:49.488000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076b8c39820241cb1dac6c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.187/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.187/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076b8c39820241cb1dac=
6c2
        failing since 146 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076b8bd7dee1b84c0dac766

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.187/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.187/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076b8bd7dee1b84c0dac=
767
        failing since 146 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076b85db7fbb5ade1dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.187/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.187/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076b85db7fbb5ade1dac=
6b2
        failing since 146 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-collabora   | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/6076bc9daaa6a7ea54dac6bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.187/=
x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.187/=
x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076bc9daaa6a7ea54dac=
6bd
        new failure (last pass: v4.19.186) =

 =20
