Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5791572BE4
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 05:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiGMD3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 23:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiGMD3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 23:29:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9D7599D1
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 20:29:49 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s27so9297545pga.13
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 20:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4vMehf7QJPpUejfla3VRv6WRFu46tMcInnVFHbBgWWw=;
        b=nor+4J3YDtAoLib10gg23oL2EensA5krMkIdRmQFkcUtUOassBdCQ95u5p7GJnoWmk
         EAbIweQhDinPiMHoIl6QXd+MJbMZep2VjuTW5aKYEo7FtKBlq2Z/4BZuqcLQcyUN7Yd5
         Do17wEp6WNw0BGU+o8EQq36PuYKLsCHfPwNs7/SlZnJLE7rpPYzf4hEia5rkpZAN+B20
         FZx9spuTOWQLQocefMIBbDSQtFdGNcJjIPU0GBsu9goIFLqgYMAObtszUAZsnLXeanlz
         S29wK1FPduUIbMouOOCJpFAU6jaUkU0VlTZk35v3jOdrVhOUyHp133RY3eUw8eAYywro
         JrFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4vMehf7QJPpUejfla3VRv6WRFu46tMcInnVFHbBgWWw=;
        b=UgC45CLLcLou+7RWRyjVOSlXZidjj0qJNJOrOJZVYh7z9Pc6wine2MF/3kQQ7RexBu
         l8/WG7MqpJmNBM5/BYHFmkrlX0snK1PavHeGOIutxJftYtVI/T7WUFB9g8QytwRyrrcJ
         YjpRfr8HyXwbZMCHVPB4Swait56EEc7RVA3EoK98a25TfiNaZLUNRE98EcfzAm9Tk4qT
         OlUFik79X5hru9dhxCifEwkmd6YNK+GwhRVu+KozRVy0QBvlNeuCuqniGTIqKoT+YprZ
         tEvDk4XSTmdjxFY5Aig2Ys9IeNNhpTlElyzBwy/HEYHNj9RuORuY5s9lpoYgaBf3GVI6
         RWAw==
X-Gm-Message-State: AJIora/kr/HdVeJgipsc7mlVLIt+BE9jzHQIK6obvpzJ06+rMGjbPr1E
        ws2MmdRfPy2snkYIZR1exweoEy2rNTGbi/ue
X-Google-Smtp-Source: AGRyM1useiTw6MJw9o8zi3P8bnM9hqUEa6ycIzBn/w+OR6S/bH1PZLzC/k/1MwWCIe7UVIawK+igEQ==
X-Received: by 2002:a05:6a00:170f:b0:525:467c:3516 with SMTP id h15-20020a056a00170f00b00525467c3516mr1319549pfc.22.1657682988612;
        Tue, 12 Jul 2022 20:29:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j23-20020a17090a061700b001f00f6f1b2csm342789pjj.34.2022.07.12.20.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 20:29:48 -0700 (PDT)
Message-ID: <62ce3c2c.1c69fb81.51fe6.0b9c@mx.google.com>
Date:   Tue, 12 Jul 2022 20:29:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.11-62-g18f94637a014
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 94 runs,
 3 regressions (v5.18.11-62-g18f94637a014)
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

stable-rc/linux-5.18.y baseline: 94 runs, 3 regressions (v5.18.11-62-g18f94=
637a014)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
        | regressions
-----------------------+--------+-----------------+----------+-------------=
--------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | imx_v6_v7_de=
fconfig | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig    | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.11-62-g18f94637a014/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.11-62-g18f94637a014
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      18f94637a0141cfc0d428f6acef57d59eb35dd27 =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
        | regressions
-----------------------+--------+-----------------+----------+-------------=
--------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | imx_v6_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce22835c428eb2f0a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
1-62-g18f94637a014/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
1-62-g18f94637a014/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce22835c428eb2f0a39=
bdb
        failing since 11 days (last pass: v5.18.8, first fail: v5.18.8-7-g2=
c9a64b3a872) =

 =



platform               | arch   | lab             | compiler | defconfig   =
        | regressions
-----------------------+--------+-----------------+----------+-------------=
--------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce093f4736c7b2e3a39be7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
1-62-g18f94637a014/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
1-62-g18f94637a014/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce093f4736c7b2e3a39=
be8
        new failure (last pass: v5.18.10) =

 =



platform               | arch   | lab             | compiler | defconfig   =
        | regressions
-----------------------+--------+-----------------+----------+-------------=
--------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce1373920088f7f7a39be0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
1-62-g18f94637a014/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
1-62-g18f94637a014/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce1374920088f7f7a39=
be1
        new failure (last pass: v5.18.10) =

 =20
