Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842062D4655
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 17:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgLIQH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 11:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgLIQH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 11:07:57 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B518BC0613CF
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 08:07:17 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m5so1194005pjv.5
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 08:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3hPDkfi9ZwII8tG7kv+QAhQYXqGfpwiSDWg/v3+u4DY=;
        b=uQBcIp0epzU0sLdASpKw8FV9aCeRCCF58kRTJYjIvnn26J0BPOeTHiLWITDWHE4vXT
         DDt5WA0Qaz0AicRna/VlLCttanXLshIr7r7ZLuXaPBv2cVidxNcpt9d4R87h2WoUMbVF
         fv88PAueGmOEEqe29s+k8wOGrPOuCaI8u4Wu9gtHCrnxoEyAyUjVZiUPiSsWqXceyfwV
         odZcK9L1OP13zogSL5oQv3iTUEB7kQATLX/He7lLGl8DuoBEhP0Fhy5482L7oQDyLvQM
         lYUb6STzkCbFT3TUIy3hqJqppDvABqbLRJZy7TNNYPZ01pL8+sTnmNLRp+yfDTHDKINw
         AGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3hPDkfi9ZwII8tG7kv+QAhQYXqGfpwiSDWg/v3+u4DY=;
        b=YYeM3bCtLea2j5LLXw4UIyW9byAFHnWRF3XO/GVbd0Ox1gonBOpydRgP+9K2SX2Ksd
         vmxvPF2Cu0oPx9erZq9jkr/igq4I9dJOgz3lBD5aFwxa/xy3BnZEk5kzB2Cb5q3SCsZ1
         uASDZZ2wYIS540O/nj/+kNQwYm0sEnYyLqtlwuZ4Nf0rXTEGLihKVDEMlSIIZdy97brX
         cloOkW+EewWt4z6mLF8wqLqH8i0jjHCLqudkn40nJJUpvKTGL/51kNPzzZvV5K6WB5vu
         lQQLziy042xxdQjV9Wu3fqyJKfFRQjZkzc9rs3DuIwEc5jj5U9vvQOM4M6xAVIPfx1Um
         HYWw==
X-Gm-Message-State: AOAM533BNrTzXuSUezaFE1ikR+qZeq6aIMWep4edKbDJjlULI9IPfHJ/
        2Wv7IdYJDX5lyqZ/VGmBf909jFQ7JvbfGA==
X-Google-Smtp-Source: ABdhPJxC7+4OYGADHLTMBIYTowx3EDnPXdyW0/r7NmX2VtkNaVbEO3VU//29mZxQwA/60ZGk/Ye1UQ==
X-Received: by 2002:a17:90a:a786:: with SMTP id f6mr2899377pjq.104.1607530037008;
        Wed, 09 Dec 2020 08:07:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y9sm2534885pjj.8.2020.12.09.08.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 08:07:16 -0800 (PST)
Message-ID: <5fd0f634.1c69fb81.f947d.47ff@mx.google.com>
Date:   Wed, 09 Dec 2020 08:07:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.82-36-gc45075765dae
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 150 runs,
 5 regressions (v5.4.82-36-gc45075765dae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 150 runs, 5 regressions (v5.4.82-36-gc45075=
765dae)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
   | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.82-36-gc45075765dae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.82-36-gc45075765dae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c45075765dae2dc3a30538e422fc7477437ff641 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0c442ea1a682294c94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
36-gc45075765dae/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
36-gc45075765dae/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0c442ea1a682294c94=
cdd
        failing since 241 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
hifive-unleashed-a00  | riscv | lab-baylibre | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0c46be3d6b62e5ec94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
36-gc45075765dae/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
36-gc45075765dae/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0c46be3d6b62e5ec94=
cce
        failing since 19 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm   | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0c1230f550ac7f7c94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
36-gc45075765dae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
36-gc45075765dae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0c1230f550ac7f7c94=
cca
        failing since 24 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm   | lab-broonie  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0c132d0759a66c1c94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
36-gc45075765dae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
36-gc45075765dae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0c132d0759a66c1c94=
ce5
        failing since 24 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm   | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0c139d0759a66c1c94ce9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
36-gc45075765dae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82-=
36-gc45075765dae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0c139d0759a66c1c94=
cea
        failing since 24 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
