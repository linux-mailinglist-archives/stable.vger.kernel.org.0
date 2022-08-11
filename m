Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5765905A1
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 19:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiHKRRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 13:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235031AbiHKRQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 13:16:25 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152419A97B
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 10:07:52 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 73so17618816pgb.9
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 10:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=yQ6z5gJB1uLwGjfeyC0J7WGlxhQQbowzQ+Fg+eo76uk=;
        b=LTeJ4bNzr6MZPyZ5sZNA3NAc9wd6MmkvZN4AwxLgUEpyD8wr00saSFMFTKNATBN2Hn
         KT3o50Wktvc86aShmAbR12e+zOvd+o2f6DYib7l21zk8/2zhiYHFoQrg3qNwyAl02M9k
         4kGCHguhHXhq1zStzVeBQMWdfeBpyRJHIz7hFlqWlaRcNZiS8P5nTvbBvrLOgdbNimt3
         Jutgm9v4OzpOMEg5xT/FDVh2hpUCQEYFm0YkYoXL7YJkf0ZEmpN0cmV/1uLPnXwDj/27
         NdmkQqutIZAQLCpl7vavHbiWY4UKA966V+FJEcfP+jnjQw1q/4n8AVCl7iSzF/tq/uMy
         czYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=yQ6z5gJB1uLwGjfeyC0J7WGlxhQQbowzQ+Fg+eo76uk=;
        b=IbMwWqZ3JPZQqqEvFGonMNVzvxdtGyFU2gzggITXE4Y0eihnsE2CEsG4tycF+rFnyg
         05VixDPJ6CcNZZv6wa4Rqbm8CCpY964hEoR3ij3OeiJT/7iGXGaWpPKigP4G7BeM43rf
         pQVJDvqhnh0N7C6TBw+q7cQbk0IgBpIPc7V0BwZHlDdcqbIqVrAs7/Y+pTnRmaZF5IWi
         8s0w55B+ZS1Npqp042MNBj8oIwqLumt5MeN6WUSb3F3EkDGYekjLeuVle0y5lwRBowm6
         V9VrVY0gwKRbu5FWEXCMM/ZIJcihjcbZtRChFQqyQ2iQf9jCIM6RDAM1sgTcCSvWXUQp
         xWVA==
X-Gm-Message-State: ACgBeo3uG7177AvRCGnvVxIhFvHAGV5W8EtB9XgV55SAMby1/FBESUM7
        +RzSHCYRsax00n4Nn5OsJVIrx2CEZArE+/KVOpk=
X-Google-Smtp-Source: AA6agR6tHurr7Zbnhwq3en8nAtfBkgyaH3hOdINYpoT32dXvbCa8iOQpsoHeLQm73YSPNg7nKNbmNA==
X-Received: by 2002:a63:2b4d:0:b0:41d:6d37:365 with SMTP id r74-20020a632b4d000000b0041d6d370365mr42877pgr.325.1660237671441;
        Thu, 11 Aug 2022 10:07:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709027fc700b0016d7afee272sm15105692plb.153.2022.08.11.10.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 10:07:51 -0700 (PDT)
Message-ID: <62f53767.170a0220.2a6a9.9276@mx.google.com>
Date:   Thu, 11 Aug 2022 10:07:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.17
Subject: stable/linux-5.18.y baseline: 165 runs, 2 regressions (v5.18.17)
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

stable/linux-5.18.y baseline: 165 runs, 2 regressions (v5.18.17)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =

qemu_mips-malta    | mips | lab-collabora   | gcc-10   | malta_defconfig   =
  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.17/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8de34ce2fdfe56c4dac639011c836ddbb4e37779 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62f505d0ae57868259daf077

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.17/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.17/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f505d0ae57868259daf=
078
        failing since 27 days (last pass: v5.18.11, first fail: v5.18.12) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
qemu_mips-malta    | mips | lab-collabora   | gcc-10   | malta_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f5016eb1cddd3e9fdaf058

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.17/m=
ips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.17/m=
ips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/62f5016eb1cddd3=
e9fdaf060
        new failure (last pass: v5.18.15)
        1 lines

    2022-08-11T13:17:21.195747  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 76d3ef04, epc =3D=3D 801fef18, ra =3D=
=3D 80201bd8
    2022-08-11T13:17:21.225035  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
