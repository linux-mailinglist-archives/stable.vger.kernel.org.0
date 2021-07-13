Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DF33C6992
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 06:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhGMFCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 01:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhGMFCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 01:02:25 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E60EC0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 21:59:35 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id v7so20567732pgl.2
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 21:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z6CNUa0RzCCmbyYVpdb5W5bgU8+mf/u6o/+f9Q39jfQ=;
        b=F7aBqxDEGd71wrcZ+GXq3/31fqEgcoYqzhdbfnEV3kQIsno/oV/VMOo0g5fujQTttQ
         xW1thqp8Zmt6WsmDHpiqzeH3mY2YXy1Fm8L3jWGTlsHLTPs7RhVf7C0M7eWMndRiLvif
         c2rsvcshL3fXMKrhatxBpwGN7i5bV82toCpMIyf78cA5F6RRrS9JSCODGxmjP9dgUN5R
         UGQgZTfVHz3DXRM8Nm8+Ih/Atdclv0AvGl9zmk7BWUFQ18Pgc71arPbpBfssbHFrXgmU
         AKL9GfOTghEJK5tSgjQa5K8yBlm0225ySOm8EfUaKHTMzc/mT7TUrGuX/Nx2XwFDyd9g
         ZCmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z6CNUa0RzCCmbyYVpdb5W5bgU8+mf/u6o/+f9Q39jfQ=;
        b=QkLIQNmb87UJOEdVGl6INNF4kZUbz4JL77DGM9Aj48VTOFc7MpLl9SxZQ2QvsnoHJ+
         WSQ7mhOk/t3bXwPzsJZyKCqF9Ony299pcudlxoycLmq/rFSccM3wo+0ggjWCjB7hCXUZ
         AxIuvQWZiDdAZW6AH4sQx4M0zszjj6IiZJlVfpjfr1PlKqKslluhoq0CnGgXMbVID3I/
         +NPZu2Nhd9PYDhxvyVqOIFXYbKKMzI90ZJcJ4xITzmhIR0mZiZbLgKwayQ7a6LOSo39t
         NnCZoHgEa52ImOVbo3Sj3PjJvl3ztsZjXSB3qS1bxitzjkd5zttK6f7NfmA05y+JMfnD
         BzRw==
X-Gm-Message-State: AOAM530BMfoWQjXBNTnNfPi5EBdqi1gT+yu4OvLwNH79Gv3kO3hbJBae
        X+1iH0OboY327Z1hvV2yQ+o5sGSVqoOmIjGq
X-Google-Smtp-Source: ABdhPJyFbW1rOIGn+iCf17GfwVwyA+rngBwKwBInWgHJiotMOoM9TLMHHl/f1aSsiuI9hGkcibYSaw==
X-Received: by 2002:a63:ed0a:: with SMTP id d10mr2616349pgi.82.1626152374640;
        Mon, 12 Jul 2021 21:59:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h76sm18644460pfe.77.2021.07.12.21.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 21:59:34 -0700 (PDT)
Message-ID: <60ed1db6.1c69fb81.d8aef.737d@mx.google.com>
Date:   Mon, 12 Jul 2021 21:59:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.1-805-g949241ad55a91
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 194 runs,
 4 regressions (v5.13.1-805-g949241ad55a91)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 194 runs, 4 regressions (v5.13.1-805-g9492=
41ad55a91)

Regressions Summary
-------------------

platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre | gcc-8    | bcm2835_defconfig  =
          | 1          =

d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =

d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig   =
          | 1          =

r8a77960-ulcb      | arm64  | lab-baylibre | gcc-8    | defconfig          =
          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.1-805-g949241ad55a91/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.1-805-g949241ad55a91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      949241ad55a91465aea61c7afa51c1ec7540d5d7 =



Test Regressions
---------------- =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre | gcc-8    | bcm2835_defconfig  =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ece5a379a62e56f8117971

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-805-g949241ad55a91/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-805-g949241ad55a91/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ece5a379a62e56f8117=
972
        failing since 1 day (last pass: v5.13.1-783-g664307fdb480, first fa=
il: v5.13.1-802-gfce173dc9c592) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60ece728266ba8f11811797c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-805-g949241ad55a91/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-805-g949241ad55a91/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ece728266ba8f118117=
97d
        failing since 1 day (last pass: v5.13.1, first fail: v5.13.1-783-g6=
64307fdb480) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig   =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ece87d11fa079edb117999

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-805-g949241ad55a91/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-805-g949241ad55a91/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ece87d11fa079edb117=
99a
        failing since 1 day (last pass: v5.13.1, first fail: v5.13.1-783-g6=
64307fdb480) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
r8a77960-ulcb      | arm64  | lab-baylibre | gcc-8    | defconfig          =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ece5cb9233af0515117978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-805-g949241ad55a91/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ul=
cb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-805-g949241ad55a91/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ul=
cb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ece5cb9233af0515117=
979
        new failure (last pass: v5.13.1-783-g664307fdb480) =

 =20
