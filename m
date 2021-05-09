Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0A33776BC
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 15:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhEINJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 09:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhEINJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 09:09:41 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05630C061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 06:08:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id l10-20020a17090a850ab0290155b06f6267so8580698pjn.5
        for <stable@vger.kernel.org>; Sun, 09 May 2021 06:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MMzEohzNI8s0YGtCes80Ykark4Tub3OCFPENyA6b0kk=;
        b=hrRmxG0DaWrKdBSPC8nBpfZ8NTDCbJinQdanMCspt/BypgLFhM7MmDcwo0dS8XahOG
         0XAx34XJ8qhHK3upt9oV2/mQaQS7kpZ/swMUb+27lSM3TJ0CuILg5I3k/iKN2Rf5vUB5
         cQwzACoMWtWKw8noKqn+ejXhiQS2AJsvNkBiWhUJLVEg3pyVmOeE/SrsDHMlbo0I7e+Z
         EQ6exrNsgT7D+Ks2ZypKYA+Zihv8VH2TBJzIuCmgbaqQx6gfulwaiJIwwfarnWenmWt+
         ACfiPJCWII6abnNW7a6IowsFsmxrrdDPsMVpw330C3CMgtuOgaYCdT4JLFx09XYB3oaW
         ekSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MMzEohzNI8s0YGtCes80Ykark4Tub3OCFPENyA6b0kk=;
        b=b87asF28+IwDkeV55jXTKiZld9d4NiZImbJPgOghMzMyzr+z9pipRsCesi6/stwBBO
         UAXZC+lGhripu4650O5raDlKEFq/wm0yOD7RXvIW7jmttPvQPPU25VvopBj6eEsOfsmQ
         nbAt35LE2JJMbu4QmV93tmdv+vKqUtt3i2PfAQM6cZ7oYs4cuOLZCZQ5SMWH3J1Yw7si
         fPtROp6vzZDWxsjR6q/PW6lWBorVpwIqNMtXZ6nNodwTywlH+7y8Teby392/rzYfIbIo
         OWrfCjsFhocxZT+7iHO06FS0Wbmi2r9jeF5soa9vWf8Y43yfspTLP6vZzgjZutC3cfVj
         AaeQ==
X-Gm-Message-State: AOAM53234FKQmUYwHNRrJ1j0Fow8osCmKaiPTF+h024QPMoPmCCWnGs7
        +jiSmtnCeUB3nma9luLb9OI+rOCx+x5Q5v9P
X-Google-Smtp-Source: ABdhPJyDPOiKciFSgjvC0oY5wRoocT2SN+7X1jj+NN48ZEJinwpYbVUJMhq+HA7NweHupbkMe/ovCw==
X-Received: by 2002:a17:903:18b:b029:ee:d430:6c4d with SMTP id z11-20020a170903018bb02900eed4306c4dmr20250950plg.34.1620565718273;
        Sun, 09 May 2021 06:08:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k7sm8974408pfc.16.2021.05.09.06.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 06:08:37 -0700 (PDT)
Message-ID: <6097ded5.1c69fb81.ca70e.b416@mx.google.com>
Date:   Sun, 09 May 2021 06:08:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.2-284-g66353c8ef656
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 105 runs,
 2 regressions (v5.12.2-284-g66353c8ef656)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 105 runs, 2 regressions (v5.12.2-284-g6635=
3c8ef656)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.2-284-g66353c8ef656/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.2-284-g66353c8ef656
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      66353c8ef656711854711ba664e3fc4d6adc00ab =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/6097a9e4fd3947260e6f5483

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
-284-g66353c8ef656/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
-284-g66353c8ef656/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6097a9e4fd39472=
60e6f5487
        new failure (last pass: v5.12.2)
        4 lines

    2021-05-09 09:22:21.823000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000f44
    2021-05-09 09:22:21.824000+00:00  <8>[   13.496266] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2021-05-09 09:22:21.825000+00:00  kern  :alert : pgd =3D 809c4910   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6097a9e4fd39472=
60e6f5488
        new failure (last pass: v5.12.2)
        14 lines

    2021-05-09 09:22:21.867000+00:00  kern  :emerg : Internal error: Oops: =
817 [#1] ARM
    2021-05-09 09:22:21.868000+00:00  kern  :emerg : Process udevd (pid: 10=
4, stack limit =3D 0x53d1d12a)
    2021-05-09 09:22:21.869000+00:00  ke<8>[   13.537978] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D14>
    2021-05-09 09:22:21.870000+00:00  rn  :emerg : Stack: (0xc<8>[   13.548=
792] <LAVA_SIGNAL_ENDRUN 0_dmesg 302100_1.5.2.4.1>   =

 =20
