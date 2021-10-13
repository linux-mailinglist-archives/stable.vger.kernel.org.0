Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FD642B2DA
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 04:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbhJMCtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 22:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhJMCtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 22:49:32 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90170C061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 19:47:30 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id g9so790903plo.12
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 19:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HjdZl3YYpmEFmXGmraElndlkxmqddbP8igm9swXPYt4=;
        b=J6AZyatSayL8U6EL7cXSh18Nyal7BMTUW2jWrguPwb/IuQhBXb0Gz+YejaHRcu0Vh1
         69doXDqLF3bQYDlmxcnJ3qHsVBojTA/q97I8tHP9aPaG9ccGDUhJEjit/bDRvZ4nuJtC
         KoOREHY1pwKhjZfk1cceQ3iRrWy39CInC7qNXtayQXUo7lUNosp6MxoilAEgfXfJTaUF
         S6qu9D4GKy7LPWimeut4ntDXnl29YwiPp+vvUpZNnuzPbshqGDrISuLUor+5w5s5O6TQ
         f2iMhaGyFiGE1/Hu7yGSDmuOL6ZQnuCGEsy0ds+F3u9Rk7BygKMrV2R8TT3nyRMus0eq
         F7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HjdZl3YYpmEFmXGmraElndlkxmqddbP8igm9swXPYt4=;
        b=lB06X4tyBe742HOMbk1zIqdyi6iFg9VfLo6Ruqxd8HGdsRjqFjudzZCFGrfJhQwxpq
         VtHRElPxU8uQxPW2x49YlfwRjUPS6Ql8vaRT2z2Hn6NCIyf74ARK+TJ1KhNbmVEQao2y
         oQgsTxcQlioZBAVWqe03rz5rzmji2Z8MROEVMIsoxAJR0FxmpqrToUoYmq+CqVLbtumV
         wm9SS3kHb9nZzYeYxnTDjlzmKfHrvg6ApsS9Men4Fmk4hff7Yr9M9CJCtyKHvnS3IWnu
         5K1dy/rgkLviZtRMMWXrDPaaEj5o8bQAuYhC/RyqqWsPWQdmHqD2h3aJOVlke927Kj6f
         SAVw==
X-Gm-Message-State: AOAM532rqpUFFg3/VYGdi7rU1aQoF0E18nHGknJhQOFdbzBoGsUmxPmN
        ECQBs53iqnL1MdEbpjzA3whLFkB77D8J8Bno
X-Google-Smtp-Source: ABdhPJy5MLO6Cwt+s6uGxrudZ0nDSOCRJyEUHhgjiHV8rnONbQq88RvCsF2IijaItbTQ0LDLjRsi3Q==
X-Received: by 2002:a17:902:ba85:b0:13e:c846:c92e with SMTP id k5-20020a170902ba8500b0013ec846c92emr33379792pls.57.1634093249920;
        Tue, 12 Oct 2021 19:47:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z19sm12147514pfj.156.2021.10.12.19.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 19:47:29 -0700 (PDT)
Message-ID: <616648c1.1c69fb81.b50bc.2643@mx.google.com>
Date:   Tue, 12 Oct 2021 19:47:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.72-82-g29e0360ee4fc
Subject: stable-rc/linux-5.10.y baseline: 98 runs,
 6 regressions (v5.10.72-82-g29e0360ee4fc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 98 runs, 6 regressions (v5.10.72-82-g29e03=
60ee4fc)

Regressions Summary
-------------------

platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 2          =

imx7d-sdb                | arm  | lab-nxp       | gcc-8    | multi_v7_defco=
nfig | 1          =

rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.72-82-g29e0360ee4fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.72-82-g29e0360ee4fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29e0360ee4fccd2090a04f1a772a23a9ab01326b =



Test Regressions
---------------- =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/61660a2c49219cb87708fae2

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-82-g29e0360ee4fc/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-82-g29e0360ee4fc/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61660a2c49219cb=
87708fae6
        new failure (last pass: v5.10.72-83-g0d59553e5bda)
        4 lines

    2021-10-12T22:20:08.476433  kern  :alert : 8<--- cut here ---
    2021-10-12T22:20:08.507559  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-10-12T22:20:08.509552  kern  :alert : pgd =3D b0b8e7a0<8>[   11.46=
6550] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-10-12T22:20:08.509819  =

    2021-10-12T22:20:08.510050  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61660a2c49219cb=
87708fae7
        new failure (last pass: v5.10.72-83-g0d59553e5bda)
        47 lines

    2021-10-12T22:20:08.566400  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-10-12T22:20:08.566913  kern  :emerg : Process kworker/0:4 (pid: 54=
, stack limit =3D 0x6cad2056)
    2021-10-12T22:20:08.567175  kern  :emerg : Stack: (0xc2405d50 to 0xc240=
6000)
    2021-10-12T22:20:08.567402  kern  :emerg : 5d40:                       =
              c3a6d5b0 c3a6d5b4 c3a6d400 c3a6d414
    2021-10-12T22:20:08.567623  kern  :emerg : 5d60: c144b01c c09c78c4 c240=
4000 ef872960 8020001a c3a6d400 000002f3 ad367048
    2021-10-12T22:20:08.568085  kern  :emerg : 5d80: c19c7894 c2001d80 c377=
9a80 ef866f20 c09d51f4 c144b01c c19c7878 ad367048
    2021-10-12T22:20:08.609527  kern  :emerg : 5da0: c19c7894 c3d4bd40 c3ba=
2000 c3a6d400 c3a6d414 c144b01c c19c7878 0000000c
    2021-10-12T22:20:08.610042  kern  :emerg : 5dc0: c19c7894 c09d51c4 c144=
8d44 00000000 c3a6d40c c3a6d400 fffffdfb c2298c10
    2021-10-12T22:20:08.610287  kern  :emerg : 5de0: c3a87dc0 c09aaf0c c3a6=
d400 bf048000 fffffdfb bf044138 c3d4b000 c3bcb108
    2021-10-12T22:20:08.610513  kern  :emerg : 5e00: 00000120 c32bbf40 c3a8=
7dc0 c0a04d40 c3d4b000 c3d4b000 00000040 c3d4b000 =

    ... (36 line(s) more)  =

 =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx7d-sdb                | arm  | lab-nxp       | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61660b8ea63f0cdc3108faaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-82-g29e0360ee4fc/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-82-g29e0360ee4fc/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61660b8ea63f0cdc3108f=
aab
        failing since 0 day (last pass: v5.10.72, first fail: v5.10.72-83-g=
0d59553e5bda) =

 =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/616612793e1867f92408faa6

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-82-g29e0360ee4fc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2-82-g29e0360ee4fc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/616612793e1867f92408fabe
        failing since 119 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-12T22:55:37.857537  /lava-4705491/1/../bin/lava-test-case<8>[  =
 12.967038] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-10-12T22:55:37.857853  =

    2021-10-12T22:55:37.858050  /lava-4705491/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/616612793e1867f92408fad6
        failing since 119 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-12T22:55:36.412913  /lava-4705491/1/../bin/lava-test-case
    2021-10-12T22:55:36.418280  <8>[   11.540701] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/616612793e1867f92408fad7
        failing since 119 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-12T22:55:35.393646  /lava-4705491/1/../bin/lava-test-case
    2021-10-12T22:55:35.399052  <8>[   10.520813] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
