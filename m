Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E195B1FB5
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 15:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiIHNzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 09:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiIHNzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 09:55:21 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861327333F
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 06:55:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g4so2831845pgc.0
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 06:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=occhOK1+wIf8TQRxjhGzEFkZSqra7uC8JHrJgco2GD4=;
        b=dv/PMmQM02dtfw0Q+VYJaZNwXTXdDmOBZbKPCskPbZ6AQYEZgxoK8NSk72Ggsq34q4
         1GpNI+61glVvFW4NGfc3bEBRGRntu7KA8B/3Hi2n+gI/UtPBAe3HWYSqm81IUuO5Ufm5
         eRM+vBUyM38udADK3Rh4bo+C+DksiqBsiDqMmXGytF5q3dVJ8g5evCShwIoFN+Fp/7qj
         1aa3x64ITZ5pTuwFaar/s3KNm4GIEg+em4CreiU/AFtmEfKkcpa/b2mg3uh1+/+RZWY9
         svzsjsiyVnIF9MXK4Mih0Ey6OriD4JOFLc1DTUhquDywTDdM5DIqI4Dnje9MmcLQw0dd
         J5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=occhOK1+wIf8TQRxjhGzEFkZSqra7uC8JHrJgco2GD4=;
        b=ORvJzu/nnCI/k8K1q6apETnQfa0414va044bm3maoNEqhVtw32T0Z+NRj/1FNyqDDq
         wjCsFuiB6vWqAVblKBFIU6cSJmNBYBVAREx4dXS3h3Fg6yhrmg7YnvNMc0hKLdg3rUNL
         jb9pT+NI2WJlCs/dnfJK7Uevywf3xKxJf+6hVz02EAF3K/klwyt0Xi8NmmTg872IhNFX
         0ADvn8nEcc6ehcCkZJuQnYELdNfdC+ErQ79V2Q04JvWUe6rW6CkREV9hb3guDuWjONp4
         6fAMUPB7zaF1ucodWG3Eg9YBIKacTyq+nLumtXnBzqWwFtbtSB5IYOxaJkxRbfwCZUNG
         QP4Q==
X-Gm-Message-State: ACgBeo2oJuqfJw1YmS7WIy76p5ii+FwPlw7F3CXpmNLYnhDDLgaRUarP
        LfzFjVuB3keLAT+NGi5vLQ9j8sXymSpmFaAzDls=
X-Google-Smtp-Source: AA6agR5MUzR8QGs2c/UmaTDIU5zSfkvqtUim3xLbvkj5eMWzW5BAsk8uj4SGsxj908hkiH7Zt0rbcw==
X-Received: by 2002:aa7:8e05:0:b0:536:5dda:e634 with SMTP id c5-20020aa78e05000000b005365ddae634mr9012380pfr.35.1662645318731;
        Thu, 08 Sep 2022 06:55:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m14-20020a170902bb8e00b0017519b86996sm14404351pls.218.2022.09.08.06.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:55:18 -0700 (PDT)
Message-ID: <6319f446.170a0220.d9013.6ba4@mx.google.com>
Date:   Thu, 08 Sep 2022 06:55:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.4-389-gf2d8facb7bd4
Subject: stable-rc/queue/5.19 baseline: 126 runs,
 4 regressions (v5.19.4-389-gf2d8facb7bd4)
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

stable-rc/queue/5.19 baseline: 126 runs, 4 regressions (v5.19.4-389-gf2d8fa=
cb7bd4)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =

imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defco=
nfig | 1          =

rk3399-roc-pc        | arm64 | lab-clabbe      | gcc-10   | defconfig      =
     | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.4-389-gf2d8facb7bd4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.4-389-gf2d8facb7bd4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f2d8facb7bd40ac9a6c7b8b62efc8fbe35913c99 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6319bfb608460c1848355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-3=
89-gf2d8facb7bd4/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-3=
89-gf2d8facb7bd4/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319bfb608460c1848355=
643
        new failure (last pass: v5.19.4-318-gb22688ea1c79) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6319d161cb340a3455355685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-3=
89-gf2d8facb7bd4/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-3=
89-gf2d8facb7bd4/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319d161cb340a3455355=
686
        failing since 22 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
rk3399-roc-pc        | arm64 | lab-clabbe      | gcc-10   | defconfig      =
     | 2          =


  Details:     https://kernelci.org/test/plan/id/6319c236c14789dc11355650

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-3=
89-gf2d8facb7bd4/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-3=
89-gf2d8facb7bd4/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6319c236c14789d=
c11355654
        new failure (last pass: v5.19.4-233-g65485bdafd38)
        11 lines

    2022-09-08T10:21:35.726508  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 0000000000000078
    2022-09-08T10:21:35.728011  kern  :alert : Mem abort info:
    2022-09-08T10:21:35.728369  kern  :alert :   ESR =3D 0x0000000096000004
    2022-09-08T10:21:35.729570  kern  :alert :   EC =3D 0x25: DABT (current=
 EL), IL =3D 32 bits
    2022-09-08T10:21:35.731074  kern  :alert :   SET =3D 0, FnV =3D 0
    2022-09-08T10:21:35.731513  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2022-09-08T10:21:35.732599  kern  :alert :   FSC =3D 0x04: level 0 tran=
slation fault
    2022-09-08T10:21:35.734464  kern  :alert : Data abort info:
    2022-09-08T10:21:35.735006  kern  :alert :   ISV =3D 0, ISS =3D 0x00000=
004
    2022-09-08T10:21:35.735764  kern  :alert :   CM =3D 0, WnR =3D 0 =

    ... (2 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6319c236c14789d=
c11355655
        new failure (last pass: v5.19.4-233-g65485bdafd38)
        2 lines

    2022-09-08T10:21:35.746089  kern  :emerg : Internal error: Oops: 960000=
04 [#1] PREEMPT SMP
    2022-09-08T10:21:35.747420  kern  :emerg : Code: f940a6c0 f9402023 9103=
7015 295be001 (f9403c77) =

    2022-09-08T10:21:35.752818  <8>[   25.519888] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2022-09-08T10:21:35.753282  + set +x   =

 =20
