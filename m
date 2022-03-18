Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B515C4DE3F8
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 23:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbiCRW0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 18:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiCRW0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 18:26:49 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38905103B9D
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 15:25:30 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id h5so8167018plf.7
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 15:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0cr5J3FOrbNikHuKxVL4FYxpu4Na7dag4r/gDoMcLsE=;
        b=YOJaMylKp9cLJJkfkPcDWg5sbDr3wQMzqDFo7ozGjrjvF1V/JlBYRh8cCxEq6eSraA
         7JPClzvcjkmLhtKyVPiW6YcYoo6HGIbRA7Yi46F03SgabMPbRNbjoQ1PmRpFgxkOjULJ
         L9yPmUZIPLZJLPAqowe8Ani3i5/X/WTmwLK3RMqZ5DxakQ/IzGkJ7DsSXNyxndoQuiVF
         0+X3ckAYEYSW9d4Ypip3i2YT8K9jEYBC2Hrl/BmfYCtbZUn/VMgMSoLuaqmflEpgHvd+
         WV/BFiiPvffmAcJulPfevh97tpK8JQYCKwFoUtwrBJBEOs6/1jz+5fc6H9FP7jRadE7a
         mCuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0cr5J3FOrbNikHuKxVL4FYxpu4Na7dag4r/gDoMcLsE=;
        b=iq7GD08YoIf/HtbhEk8KCQWAOLbwwi0nMiyjtgHYTzwvdF0aYfH4Vydaj+dcJ/qeU6
         VOzWVIBcE1ErAKS7Q2Z5wX/zVR4Bj5NbDBmN/rxH6bu8dukMqeaIVCozJeZCtie/HIQh
         BwdEKrEk2zolD8fazW4GvYkNn5AMul/sOc7tjACDH6G4OBE+0QGwKxjq0wdBWeRSdwY1
         LqmWYWKhbFg8MLdHDxOr+dr12SiptD9seTTAYt1BzgQ8ojjFQW6rGcVntX0voDnQ2seq
         T3z283DI5W8bjpgEku1Nm0ulmoEFxQABjZXAblswDMQ0Zof5z3Ta9s98/Oet2/cUGHoE
         8RMQ==
X-Gm-Message-State: AOAM530ogfi4uJ72XI6u9WlHnEd4d+9QvdsMG7DL2cF8Oj2SjHam/kIH
        KdLFqtRWhmAkzg5TVN+rYwQoCYRudxGPG6YUy8A=
X-Google-Smtp-Source: ABdhPJycozBZ9paEYY2jxjjne4lAKmZ78IQs2hK9+Nqp4Wi/du57Whot0C7VzWdmzxVt77zvjFa5jA==
X-Received: by 2002:a17:90a:7085:b0:1bd:3db8:6597 with SMTP id g5-20020a17090a708500b001bd3db86597mr24019234pjk.86.1647642329486;
        Fri, 18 Mar 2022 15:25:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z22-20020aa78896000000b004f7b0e1b16asm11051164pfe.38.2022.03.18.15.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 15:25:29 -0700 (PDT)
Message-ID: <623506d9.1c69fb81.fd902.e0b8@mx.google.com>
Date:   Fri, 18 Mar 2022 15:25:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.106-22-g0e874f26e379
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 89 runs,
 4 regressions (v5.10.106-22-g0e874f26e379)
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

stable-rc/queue/5.10 baseline: 89 runs, 4 regressions (v5.10.106-22-g0e874f=
26e379)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 2          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-10   | defconfig=
                  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.106-22-g0e874f26e379/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.106-22-g0e874f26e379
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e874f26e379fbb50fe38a6aba01761170d19221 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 2          =


  Details:     https://kernelci.org/test/plan/id/6234cd9be87f98609bf8006b

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.106=
-22-g0e874f26e379/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.106=
-22-g0e874f26e379/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6234cd9be87f986=
09bf8006f
        new failure (last pass: v5.10.106-23-g791a445a0751a)
        10 lines

    2022-03-18T18:21:01.173760  kern  <8>[   16.301765] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D10>
    2022-03-18T18:21:01.174829  :alert :   ESR =3D 0x96000021
    2022-03-18T18:21:01.175905  kern  :alert :   EC =3D 0x25: DABT (current=
 EL), IL =3D 32 bits
    2022-03-18T18:21:01.177011  kern  :alert :   SET =3D 0, FnV =3D 0
    2022-03-18T18:21:01.178076  kern  :alert :   EA =3D 0, S1PTW =3D 0   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6234cd9be87f986=
09bf80070
        new failure (last pass: v5.10.106-23-g791a445a0751a)
        2 lines

    2022-03-18T18:21:01.208333  kern  :alert : Data abort info:
    2022-03-18T18:21:01.210245  kern  :alert :   ISV =3D 0, ISS =3D<8>[   1=
6.329735] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3D=
lines MEASUREMENT=3D2>
    2022-03-18T18:21:01.211390   0x00000021<8>[   16.338099] <LAVA_SIGNAL_E=
NDRUN 0_dmesg 1722582_1.5.2.4.1>
    2022-03-18T18:21:01.212392  kern  :alert :   CM =3D 0, WnR =3D 0
    2022-03-18T18:21:01.213477  kern  :alert : [53cdb4d8d3ac2f2d] address b=
etween user and kernel address ranges
    2022-03-18T18:21:01.214466  kern  :emerg : Internal error: Oops: 960000=
21 [#1] PREEMPT SMP   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6234cb28a041ced22ef800b6

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.106=
-22-g0e874f26e379/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.106=
-22-g0e874f26e379/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6234cb28a041ced22ef800d8
        failing since 10 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-18T18:10:32.262042  <8>[   32.691690] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-18T18:10:33.285428  /lava-5910354/1/../bin/lava-test-case   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6234ce157f4b922fdcf8006f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.106=
-22-g0e874f26e379/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.106=
-22-g0e874f26e379/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6234ce157f4b922fdcf80=
070
        new failure (last pass: v5.10.106-23-g791a445a0751a) =

 =20
