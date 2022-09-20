Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104DC5BEECC
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 22:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiITUzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 16:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiITUzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 16:55:00 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F8B386A6
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 13:54:59 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id w20so3602341ply.12
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 13:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=gWwHiHUzGQ/1FIMtEGyTsySrxijr94IP6083Era/knU=;
        b=cSRZewepneBxiAvUiE6UCbbiv1n6UWqfXi7HmkfsiUCUHhkF0SeJmJh7nuBTjSWmvc
         0hClLso/5B+oznDf30WnGM7kiRmoDEtAslgYnY8fpEHzNgy84j2iEN8X21gjRH6+2S6K
         kVg3abJDo+ZcHjOhmVDJ0UqQtRK9DbiNM0gkYP1i1Ul2MSoThyKwFy2HzHk6IkdFewrr
         NLUjrTVggp1Vyps66BnqZxz8vnyUp+3dX31enBecw+xo84EPtxCJqAxI/dpiabbP2Er+
         rCBfTVgBwwNAlJnEI1dEsCHKjqDv+rZlEHeYGcy3aGDJdTsHutNEwtFct0BPPZhfr2em
         NJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=gWwHiHUzGQ/1FIMtEGyTsySrxijr94IP6083Era/knU=;
        b=Ia86+F89dYoufTx45YyjMV69TOJfH5wVXpR53dnQKiIX1d6n1i3X6784JyKOHdKAXh
         2ff2zZQ+yl1ACzDWr9Ec7oVKAYwXjd1wWA0WMpdbOkTC/4+Qk0Onm+pbFLyz1NdJOkQk
         vctw2uXoxilGJCdbVA1J14hUFP18ddLTeQVmyyQND/TtVpaA8SaJTS19BJCEM398+Uoe
         5oG3e4CYhBq761xWF4ze7+Ks2+BklCcDn7wTD2qoTEIEQ646GicyIZV2zugg3KmFBgkA
         kytEQyeBRbPLinRaIkZr1QyvK0qUJ56BrJcHw5PwWrxAQXMo2JxIVgq0tSlqnpiYu7Gu
         iOUw==
X-Gm-Message-State: ACrzQf1ZsMC5xKlYoxtpwtwFbpYBqLM72SGwXJp9lRJDnamThqvD3k3F
        kNyj9wd6VsXljhxYhOEq4WcVLj5AWzP0Gv7D7CQ=
X-Google-Smtp-Source: AMsMyM5FJ6tuQyQrPmJXgiF/QcyB2C1Cb0YjhwH39rxGn5CJSwqnVGYTHKTjobHvQU4bG0+udmotYw==
X-Received: by 2002:a17:902:aa8b:b0:178:8f1d:6936 with SMTP id d11-20020a170902aa8b00b001788f1d6936mr1423693plr.168.1663707298405;
        Tue, 20 Sep 2022 13:54:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902da8600b00172f6726d8esm305664plx.277.2022.09.20.13.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 13:54:57 -0700 (PDT)
Message-ID: <632a28a1.170a0220.3d033.0c7b@mx.google.com>
Date:   Tue, 20 Sep 2022 13:54:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.69
Subject: stable/linux-5.15.y baseline: 162 runs, 4 regressions (v5.15.69)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 162 runs, 4 regressions (v5.15.69)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
at91sam9g20ek      | arm   | lab-broonie  | gcc-10   | at91_dt_defconfig  |=
 1          =

at91sam9g20ek      | arm   | lab-broonie  | gcc-10   | multi_v5_defconfig |=
 1          =

kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig          |=
 1          =

panda              | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.69/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.69
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      820b689b4a7a6ca1b4fdabf26a17196a2e379a97 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
at91sam9g20ek      | arm   | lab-broonie  | gcc-10   | at91_dt_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6329f493a1348d351835566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.69/a=
rm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.69/a=
rm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329f493a1348d3518355=
66c
        new failure (last pass: v5.15.67) =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
at91sam9g20ek      | arm   | lab-broonie  | gcc-10   | multi_v5_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6329f50b9ff0d179ad355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.69/a=
rm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.69/a=
rm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329f50b9ff0d179ad355=
659
        new failure (last pass: v5.15.67) =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6329f950d91a5b3f4f355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.69/a=
rm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.69/a=
rm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329f950d91a5b3f4f355=
664
        new failure (last pass: v5.15.67) =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
panda              | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6329f89b803274068d355672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.69/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.69/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329f89b803274068d355=
673
        failing since 34 days (last pass: v5.15.59, first fail: v5.15.61) =

 =20
