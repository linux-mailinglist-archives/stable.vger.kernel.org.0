Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92CD48BB6F
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 00:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346836AbiAKXcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 18:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346822AbiAKXcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 18:32:03 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88846C06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 15:32:03 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so1496812pjb.5
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 15:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=33He2hcxGWeVaSmMGERGICKiJ5YzBz9LnOJdcVfZkvc=;
        b=PqqqCA+6++pd3PhtfQ4UVmLYNBJIz2GKu9q5vzdwC1M6CFRcb5pTMEPyLlvhTJlMa1
         kBLLjynqS3EDa2QxKcTSsuO+iaS2n9EwH8q9pZ+jZXLsxnfWHRgN+5JMb4qHcKoDiLwK
         A+9QCVNFpoxo4EGiPTgM4J4+1idwj+rg9IOxDA7j3QlR0WLxXKAWxUWjg3DI2K33zyp9
         OvwwQQIYvpfcxf4tYM6DYJOnPec2hoAL4v88q4KfkQtVmog38ci142yjGYCSr/LHzls8
         vVs/+tC2+8UxlV6O0PC+qaIpAIHU6xzZo+XIngUnALbeHRWkxUQ7i1/GKCAi+uFz3SGv
         n+2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=33He2hcxGWeVaSmMGERGICKiJ5YzBz9LnOJdcVfZkvc=;
        b=ZpLo6plTF2SEb8asPjxqMOaNJ8CwI0tQDmbPRbO8H3b1H2RMci9aGtcTfFC5FfCxfP
         GiVu4lNOFHZs5p4ce3IaEQ3hRljFZ5yFxoUY3Jy8FQyX6Y59YzgzYmS1HsNbQ453HF8K
         XS0u7Wzm/0WirBVeRV1MzmTCTzpCGyEqlczU+vqYgT3aFnfNjpKNeBz7QytBE4Cwu5Ww
         pgGHIwrS5aoH2HkZ07ERM5I+iUcgeEcHjO0rTPhwImVsaJQRyxPs3KPlvPMDr37m0SNz
         fsg9YOkgicOoK77UrfWjYCut4zeF90P6XxLhAbPSPWlles33fDqdr9ylfCH4+WTszwvc
         VKnw==
X-Gm-Message-State: AOAM5301lb141jXIvedy7QFsi497yI6TSRRryubLx1dwbNAkmwF4IBpL
        yJcvXLidn65XNDVyIKDJEKk/cORpYR3XAnBd
X-Google-Smtp-Source: ABdhPJwY1SEJ/DlGOX7FZGqqFVPqXYKaBLpVrSjQqAY9ChHzZHKSRidstUJZEpXP/shJCtxn3tSvCQ==
X-Received: by 2002:a62:e410:0:b0:4bd:bc02:fb52 with SMTP id r16-20020a62e410000000b004bdbc02fb52mr6644307pfh.40.1641943922749;
        Tue, 11 Jan 2022 15:32:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f20sm5440669pfc.108.2022.01.11.15.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 15:32:02 -0800 (PST)
Message-ID: <61de1372.1c69fb81.99b60.e5f6@mx.google.com>
Date:   Tue, 11 Jan 2022 15:32:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.91
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 197 runs, 4 regressions (v5.10.91)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 197 runs, 4 regressions (v5.10.91)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
      | regressions
-------------------------+-------+--------------+----------+---------------=
------+------------
beaglebone-black         | arm   | lab-cip      | gcc-10   | omap2plus_defc=
onfig | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig  | 2          =

sun50i-a64-bananapi-m64  | arm64 | lab-clabbe   | gcc-10   | defconfig     =
      | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.91/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      df395c763ba08b8b4385481af07d5d1c658dd917 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
      | regressions
-------------------------+-------+--------------+----------+---------------=
------+------------
beaglebone-black         | arm   | lab-cip      | gcc-10   | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ddde8d079becad82ef6743

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.91/a=
rm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.91/a=
rm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ddde8d079becad82ef6=
744
        new failure (last pass: v5.10.89) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
      | regressions
-------------------------+-------+--------------+----------+---------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig  | 2          =


  Details:     https://kernelci.org/test/plan/id/61dde29c77a10c1004ef6764

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.91/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboard=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.91/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboard=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61dde29c77a10c1=
004ef6768
        new failure (last pass: v5.10.88)
        4 lines

    2022-01-11T20:03:14.661403  kern  :alert : 8<--- cut here ---
    2022-01-11T20:03:14.661906  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 752f7389
    2022-01-11T20:03:14.662146  kern  :alert : pgd =3D (ptrval)
    2022-01-11T20:03:14.662824  kern  :a<8>[   39.377042] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-01-11T20:03:14.663086  lert : [752f7389] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dde29c77a10c1=
004ef6769
        new failure (last pass: v5.10.88)
        46 lines

    2022-01-11T20:03:14.715165  kern  :emerg : Internal error: Oops: 5 [#1]=
 SMP ARM
    2022-01-11T20:03:14.715677  kern  :emerg : Process kworker/0:6 (pid: 56=
, stack limit =3D 0x(ptrval))
    2022-01-11T20:03:14.715924  kern  :emerg : Stack: (0xc2409d68 to 0xc240=
a000)
    2022-01-11T20:03:14.716153  kern  :emerg : 9d60:                   c39f=
ddb0 c39fddb4 c39fdc00 c39fdc00 c1445cc0 c09e3b64
    2022-01-11T20:03:14.716614  kern  :emerg : 9d80: c2408000 c2001e40 ef86=
c620 c39fdc00 752f7369 c39fd800 c2001a80 ef86bf80
    2022-01-11T20:03:14.717085  kern  :emerg : 9da0: c09f12cc c1445cc0 0000=
000c c399d240 c19c7a10 79d2c3cf 00000001 c3a31fc0
    2022-01-11T20:03:14.758158  kern  :emerg : 9dc0: c3a2f080 c39fdc00 c39f=
dc14 c1445cc0 0000000c c399d240 c19c7a10 c09f12a0
    2022-01-11T20:03:14.758670  kern  :emerg : 9de0: c14439e4 00000000 c39f=
dc00 fffffdfb bf048000 c22d8c10 00000120 c09c7280
    2022-01-11T20:03:14.758916  kern  :emerg : 9e00: c39fdc00 bf044120 c3a3=
1480 c3a73708 c226e8c0 c19c7a2c 00000120 c0a23c70
    2022-01-11T20:03:14.759402  kern  :emerg : 9e20: c3a31480 c3a31480 c223=
2c00 c226e8c0 00000000 c3a31480 c19c7a24 bf0a60a8 =

    ... (36 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
      | regressions
-------------------------+-------+--------------+----------+---------------=
------+------------
sun50i-a64-bananapi-m64  | arm64 | lab-clabbe   | gcc-10   | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/61dde2ece7e3765e7cef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.91/a=
rm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.91/a=
rm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dde2ece7e3765e7cef6=
73e
        new failure (last pass: v5.10.90) =

 =20
