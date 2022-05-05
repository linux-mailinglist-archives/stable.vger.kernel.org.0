Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7455F51B654
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 05:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiEEDN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 23:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiEEDN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 23:13:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D575419A5
        for <stable@vger.kernel.org>; Wed,  4 May 2022 20:09:49 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id x18so3191024plg.6
        for <stable@vger.kernel.org>; Wed, 04 May 2022 20:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qaXn1ZcSFbfDbH3Jz/WNb1/eHHjgXhf0S3E2M4mYV6k=;
        b=Xfsrg3duuRwtUFFxssVJ95HAU2LBS6lq4QMnrWeDHMkOvIBEWM3SAjCdT7dzKI8GOS
         vLsdiLnin/VNEdYSe7crVGsLiIoRIMIKpDnEO+pGiwspVrO1z5lQLW9rRIA4MLBS1f1s
         X1MNBzLk5WvPseka3Ty/lWFHTzHB9XlI7gYIDNUlyCD663fj/DXu/cgU6AbZR0fbd3b8
         ea7KbIep+apF5I1LOk4yH7OtAF+Kd2PRZKj+LN4EBciDS7iL+HcEafaSjqD7JkGrgYMm
         aj8zv6jKFVpsKxdjXnHCxJ9oUwMHcJ7iAeEtA8hRjt8o6VxC1QpJBGB2FmUnPbo7Aufr
         6E2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qaXn1ZcSFbfDbH3Jz/WNb1/eHHjgXhf0S3E2M4mYV6k=;
        b=IbJWO2426g6Jdn1/MnU52mXJYbmE0D51RXZbt9cOIrLVksNPoYO4kBXogkTGWMlpb3
         vHzHssPusOpAwHMIdpEogCHpM+dBoeje0DqhK17qmYdtBzOY0jWECOAUGK382nSEPkV2
         9lVvKoH2NaO6d7n1Zn07/EsTjojhP3OqLMCNCILS8pwrlqAFVnoU/03YmSVyXxC6Kr9P
         /XOf/QYMreITphSqpi/Uo4Dna5jQd+L4sYz2wf4DTDKEBTXo4UM0cjl3At/eBjFFuXoj
         hyATHk6xbdmgfh0R4A/VJRwpeBhcMy1kff02VftfmonnV90nlJfIrlIzqJcFGr9C8P8u
         th+g==
X-Gm-Message-State: AOAM533qvMtMsTMtV7QDBo9jYSSqLMFtyEUOdaqFD9mYWEgqzVT8D2tI
        xx9oZsxFPmr3686YWXwcBwxyoZ4vpm76YK3IYtk=
X-Google-Smtp-Source: ABdhPJx17eh9PMBMBL5IXOANus+aJHZ0tHiRs1R9DWUvU2SyZsuMuSv+TY7qVTHs79+Ap/bx/nFblA==
X-Received: by 2002:a17:902:b789:b0:15b:5d52:7542 with SMTP id e9-20020a170902b78900b0015b5d527542mr25300193pls.26.1651720188977;
        Wed, 04 May 2022 20:09:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r11-20020a170902be0b00b0015e8d4eb1f0sm253300pls.58.2022.05.04.20.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 20:09:48 -0700 (PDT)
Message-ID: <62733ffc.1c69fb81.3e1d7.0e0e@mx.google.com>
Date:   Wed, 04 May 2022 20:09:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.37-177-g7b6e96fc83bc
Subject: stable-rc/queue/5.15 baseline: 146 runs,
 3 regressions (v5.15.37-177-g7b6e96fc83bc)
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

stable-rc/queue/5.15 baseline: 146 runs, 3 regressions (v5.15.37-177-g7b6e9=
6fc83bc)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
beagle-xm           | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g        | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =

rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.37-177-g7b6e96fc83bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.37-177-g7b6e96fc83bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b6e96fc83bc8fadf753f38d5218792de2f70b48 =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
beagle-xm           | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g        | 1          =


  Details:     https://kernelci.org/test/plan/id/627320cdfbded4dd3c8f5760

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
177-g7b6e96fc83bc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
177-g7b6e96fc83bc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627320cdfbded4dd3c8f5=
761
        failing since 35 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62730da346980752bc8f57a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
177-g7b6e96fc83bc/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
177-g7b6e96fc83bc/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62730da346980752bc8f5=
7a3
        new failure (last pass: v5.15.37-174-g3e309972807a) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627314f8a8c56d9c268f575b

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
177-g7b6e96fc83bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
177-g7b6e96fc83bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627314f8a8c56d9c268f577d
        failing since 58 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-05T00:06:07.729882  <8>[   32.612643] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-05T00:06:08.760169  /lava-6267118/1/../bin/lava-test-case
    2022-05-05T00:06:08.771139  <8>[   33.654229] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
