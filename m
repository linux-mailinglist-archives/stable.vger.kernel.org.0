Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EA65061B2
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 03:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiDSBcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 21:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbiDSBcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 21:32:21 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692DE2559F
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 18:29:40 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id bg9so22045676pgb.9
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 18:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iolP7zUhZskyCPEfkeFRsGu92podZ1vuJJU4g4ZkJ5o=;
        b=JeiOhLF2kuaRzDdeUhwEi+9MKoAbBS0lYlWsADAGsOzwf6hPD7y0EYzrGdRGPxsqxp
         q5UHziqG0p+JLS0iUe0p3Ln71oprjkGbBeLwwEyXSb5LmdTFXenMzAEENKMqm6LOLsBg
         OunLGNde7SJyoAOB00r3GKQTkFnyLi2lKP72fT3RK4sEjk/4QGVA8rmkm4OCyBpq0zJ5
         vURayu42X3IWZb7KQ73IK9Ugr0QRKgrvvIqexIoQCzu9XE4wD1n5X+Vxqst/0WGbbHhc
         v5T9cOEO/oWtA6JqB+5OFUP9WoTgZ6zQDvYPBTV5FpeEue5ZzOAI3s6CIBHE4XmSHpSB
         ke6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iolP7zUhZskyCPEfkeFRsGu92podZ1vuJJU4g4ZkJ5o=;
        b=Y9ofX4yN7Ta7/0aGR6cwIZPvMAIb/mHx4CLgAbWNBJnqL0G/f7Ny9Dkq6LrplZcpK5
         Rx57qHDvS1Zh6vxEdo7Jg7CH5WLKFPKlFCZG3IEJJmeW3nJbM05hcM1+lsbn2pFg7rr9
         RVIysAkjsMBVzeQX8X363baVV/DE9nnJtY37y4jaRcDTQ0ciigGj7aSAP9JE8EzQ2NHC
         zkrkSL6iQD/tGSoTtskKzBc6prmXy69oAOoNZCc1IJDi/KZSV5XuC2UZxd6alm4jXwjq
         C1AwsXr1YVxIB6G5u/D/fo1/dU3c7XN/rREHseazrGFKO/F1LO4Gz0f8QYhtjrcpJWdT
         B70g==
X-Gm-Message-State: AOAM532iOpibHAc832MfgdIMu1Wxlp6k+6Otj9eV+owuFdgQsnzXZa0r
        EIRfVXSbtxLfg5N6QAErBdb9YnLHPDBgNwX1
X-Google-Smtp-Source: ABdhPJyeQIkzrTE9VDcJsDOAr/ph/Eyb097mR//TVHADe0G1VTzywCoFt5RONE1v7OFZ2a0wGFNHQw==
X-Received: by 2002:a62:ce0d:0:b0:508:b9d1:304 with SMTP id y13-20020a62ce0d000000b00508b9d10304mr15249769pfg.8.1650331779754;
        Mon, 18 Apr 2022 18:29:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7-20020a056a00114700b004f7be3231d6sm14207273pfm.7.2022.04.18.18.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 18:29:39 -0700 (PDT)
Message-ID: <625e1083.1c69fb81.ca0b6.1797@mx.google.com>
Date:   Mon, 18 Apr 2022 18:29:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.3-222-g74c308ff91ae8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 151 runs,
 2 regressions (v5.17.3-222-g74c308ff91ae8)
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

stable-rc/queue/5.17 baseline: 151 runs, 2 regressions (v5.17.3-222-g74c308=
ff91ae8)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =

at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.3-222-g74c308ff91ae8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.3-222-g74c308ff91ae8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      74c308ff91ae87673c729a20504e83bf6167ac32 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/625ddc9cf2790db0f9ae0684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-2=
22-g74c308ff91ae8/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-2=
22-g74c308ff91ae8/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ddc9cf2790db0f9ae0=
685
        failing since 4 days (last pass: v5.17.2-343-g74625fba2cc43, first =
fail: v5.17.3-7-g214113ee8b920) =

 =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/625dddf0060ca56a77ae06a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-2=
22-g74c308ff91ae8/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-2=
22-g74c308ff91ae8/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625dddf0060ca56a77ae0=
6a1
        failing since 4 days (last pass: v5.17.2-339-g22fa848c25c53, first =
fail: v5.17.3-7-g214113ee8b920) =

 =20
