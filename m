Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FC04AAD9B
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 04:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381049AbiBFDYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 22:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiBFDYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 22:24:02 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FAAC043186
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 19:24:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y5-20020a17090aca8500b001b8127e3d3aso9975642pjt.3
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 19:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1c2cEyuNQOsp+Z63utIJtwLp5hsYb2Ssrz8WreQXXPM=;
        b=7UIe4gfqjHsEr367Bsv3t6m5XBQ+1GdEuAN+vsiuz38TmE356t08zxwycpR6KhqVF3
         4TnLPBRvg4AMSOUrO6SpBOQ4iI6fSx698BIQVTyP3WC2F7sUFJCsdhkgDX965yed1OCJ
         Oupg0MqvqpR1kY98eJZAKiF6G+CFEXbmuQA4WygWEREsyhweZbqHueg6LxxYw5W454dS
         bn4lSSw6Ey0czZXe+fsNnddkcPpSvmkgFPpqQEo/EFRU7OCO8DIaXbAUpPFe1RXK5y8o
         ZnF1Oa2FWkm27+qSPYCep83gNj5SFW8lCVBk7t2RskSu4wpImX8FTQeZkhdnBm6R9fff
         KGmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1c2cEyuNQOsp+Z63utIJtwLp5hsYb2Ssrz8WreQXXPM=;
        b=I5ujfORGap8fDQB2yK/XfkjtWTlYyIwXqeHnAeZtrX/zGI/BeqsaxwV5yf78c7XU9U
         hDBAMxCYaLVI0LEws/z4aXuci32XOP3A+sNf8RKWLNGH5zSFhQpR03//7i71bBVIhcia
         UBBAqGyr1F9T41sD91CuLR+I3I6wenjmN4rLN9hEzdc0Sm2ajymywtak+2n1k5YbyPlX
         Q8vzMWPB7hyU+2GkT8sSNaiMzFvX+4iMsqY+2rIOGhuz9czDz0iwqbmAJjzEZzjfkWCF
         QEHu9ON048mN8MCnRKBKEfHYTigC4XDCzfR56QnGRqU/uUyfGREakzXAj9m0OVcw5fRG
         JLEA==
X-Gm-Message-State: AOAM531J1+0poxtNhtEeMY1ETXnX7QswIp12UiZAKOQh8HcJ0ZIJAunb
        +vVbLe/eBnZZeTMbhlADapE/fV9BWLtfOA6Q
X-Google-Smtp-Source: ABdhPJwDYLB6ZJXc+jK6omlakpdMnBZXmDE0DAMbBP4o6+P0/N8jVU5hqmzmXJF35itPQnVSdkLeCg==
X-Received: by 2002:a17:903:18b:: with SMTP id z11mr10361109plg.59.1644117840311;
        Sat, 05 Feb 2022 19:24:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 79sm7087136pfv.117.2022.02.05.19.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 19:24:00 -0800 (PST)
Message-ID: <61ff3f50.1c69fb81.b4119.2d62@mx.google.com>
Date:   Sat, 05 Feb 2022 19:24:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.98
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 158 runs, 4 regressions (v5.10.98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 158 runs, 4 regressions (v5.10.98)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 2          =

meson-gxbb-p200          | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =

sun50i-a64-bananapi-m64  | arm64 | lab-clabbe   | gcc-10   | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      12a0a56cbae34596d3cc771d461e73ec95606e91 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/61ff08ce97849211b75d6ef5

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6custombo=
ard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6custombo=
ard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61ff08ce9784921=
1b75d6efc
        new failure (last pass: v5.10.96-26-g847fbfddce32)
        4 lines

    2022-02-05T23:31:16.369023  kern  :alert : 8<--- cut here ---
    2022-02-05T23:31:16.369598  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 752f7389
    2022-02-05T23:31:16.369896  kern  :alert : pgd =3D (ptrval)
    2022-02-05T23:31:16.370485  kern  :a<8>[   39.951133] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-02-05T23:31:16.370777  lert : [752f7389] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ff08ce9784921=
1b75d6efd
        new failure (last pass: v5.10.96-26-g847fbfddce32)
        46 lines

    2022-02-05T23:31:16.422188  kern  :emerg : Internal error: Oops: 5 [#1]=
 SMP ARM
    2022-02-05T23:31:16.422758  kern  :emerg : Process kworker/2:1 (pid: 71=
, stack limit =3D 0x(ptrval))
    2022-02-05T23:31:16.423070  kern  :emerg : Stack: (0xc30fbd68 to 0xc30f=
c000)
    2022-02-05T23:31:16.423355  kern  :emerg : bd60:                   c3b5=
45b0 c3b545b4 c3b54400 c3b54400 c1445d70 c09e438c
    2022-02-05T23:31:16.423608  kern  :emerg : bd80: c30fa000 c1445d70 0000=
000c c3b54400 752f7369 c39e9100 c2001d80 ef86bd20
    2022-02-05T23:31:16.424121  kern  :emerg : bda0: c09f1af4 c1445d70 0000=
000c c228da40 c19c7a10 866fe170 00000001 c3a55d80
    2022-02-05T23:31:16.465296  kern  :emerg : bdc0: c3a59300 c3b54400 c3b5=
4414 c1445d70 0000000c c228da40 c19c7a10 c09f1ac8
    2022-02-05T23:31:16.465868  kern  :emerg : bde0: c1443a94 00000000 c3b5=
4400 fffffdfb bf026000 c22d8c10 00000120 c09c7ab0
    2022-02-05T23:31:16.466160  kern  :emerg : be00: c3b54400 bf022120 c3a5=
5340 c3b91f08 c2276880 c19c7a2c 00000120 c0a24490
    2022-02-05T23:31:16.466419  kern  :emerg : be20: c3a55340 c3a55340 c223=
1400 c2276880 00000000 c3a55340 c19c7a24 bf0482d0 =

    ... (36 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxbb-p200          | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61ff08b5fa07f35f2d5d6f08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ff08b5fa07f35f2d5d6=
f09
        new failure (last pass: v5.10.96-26-g847fbfddce32) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64  | arm64 | lab-clabbe   | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61ff08deaa77f6b4015d6ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
8/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
8/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ff08deaa77f6b4015d6=
ee9
        failing since 1 day (last pass: v5.10.96, first fail: v5.10.96-26-g=
847fbfddce32) =

 =20
