Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B25C45C7A8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346299AbhKXOoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350144AbhKXOn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 09:43:57 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627CDC0746CC
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 06:05:40 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gt5so2652253pjb.1
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 06:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IpEBDVG8mvoTskZksut71WG8qZUmdBQtVC7g3XKURms=;
        b=A5viWhrXhJRUOc7hTlDC90VZMFWSBNEsumDcL4y1ZXKuIIH0uR15fUBCTTpbfdp1Pl
         p+PVfDno1suNVEiz/P+fgNzpsaqaWnTYsBaPYmNJX00esm9iEAnFfQXmDxrWomSdjN0D
         QqETLgOwBCG6mfFEN7sU+dlXhEJBJmdSIF4IDsQgo7RZ8eFd8USIrWXB8S82F4eKF5z/
         AcL2H094B6STJX+kjhkiEOvqa7ShmoIVyDrKmQ8mmSSCgsi7l5E8wZ7th1A0alBK1zZm
         8Wx9Cb6ssRZaIkv1UNCSBtmsE0dL0I6MwulQn5knKfhzCdApnpX6lS/FfkB6WHmo3ZhJ
         VSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IpEBDVG8mvoTskZksut71WG8qZUmdBQtVC7g3XKURms=;
        b=yoWO+FC4QG6XR8D32TZwcNJ5Ihis2iKucUNK7IwV6kWzeCE5C0/A7b0na1U7GBZUx2
         ObdCwShFI0LtKe/CbFtywEbLxqwja9XrrC5b9Y6eFZPH++hSDih8l7xi28Nade/cNB/V
         nzLQUYiGOS0gYsYb7qTNFo3PdBaOdcO+apbYrD9hkaNsdLby/RKJT5tpr57eGZPIoXva
         5cmn01aXvxe/ux5RST6RW4ELt9W+LTMpFleFLxG0wuqrEgcmLEnpXIe4e/eoruWXR6eV
         W0sA1Np+otJcGcP1MWMCps2R75HtiM6+yzSfhj3wLR7DhlKONDHaUbOSEG5g6pS6mrTn
         8S3g==
X-Gm-Message-State: AOAM532LwuXMZK1UM9r5NGurhAYQFS7J9Gl4kOpPN2tcNsN4/GdHpAGL
        iZkCbhZ4QnonU+RZQZBQgLo42pBphMF3FX9p
X-Google-Smtp-Source: ABdhPJwABP8gfqUmeVIbm8bv55pOWsWfWoTNmCCQH4qcI4+nQ6LGQTqO7JGmEgQ7WaBR07KZ0h3iJg==
X-Received: by 2002:a17:903:11c4:b0:143:d220:9161 with SMTP id q4-20020a17090311c400b00143d2209161mr19609334plh.2.1637762739727;
        Wed, 24 Nov 2021 06:05:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nn15sm5074914pjb.11.2021.11.24.06.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 06:05:39 -0800 (PST)
Message-ID: <619e46b3.1c69fb81.cb317.b52b@mx.google.com>
Date:   Wed, 24 Nov 2021 06:05:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.217-323-ge179aa5db430
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 142 runs,
 2 regressions (v4.19.217-323-ge179aa5db430)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 142 runs, 2 regressions (v4.19.217-323-ge1=
79aa5db430)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-10   | defconfig       =
    | 1          =

panda                 | arm   | lab-collabora | gcc-10   | omap2plus_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.217-323-ge179aa5db430/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.217-323-ge179aa5db430
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e179aa5db4305b8d40f673b5940961c511047086 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-10   | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/619e2580b0217863fef2efcc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-323-ge179aa5db430/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm=
-khadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-323-ge179aa5db430/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm=
-khadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619e2580b0217863fef2e=
fcd
        new failure (last pass: v4.19.217-320-g3675fbb7a6c84) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-10   | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/619e0b6c27527b4edcf2efc9

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-323-ge179aa5db430/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-323-ge179aa5db430/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e0b6c27527b4=
edcf2efcd
        failing since 10 days (last pass: v4.19.216-17-gf1ca790424bd, first=
 fail: v4.19.217)
        2 lines

    2021-11-24T09:52:26.152036  <8>[   21.499328] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T09:52:26.198366  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-11-24T09:52:26.207460  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-24T09:52:26.220873  <8>[   21.569488] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
