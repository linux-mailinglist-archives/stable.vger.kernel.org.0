Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4B85F5845
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 18:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJEQ3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 12:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiJEQ3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 12:29:50 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69BF65DA
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 09:29:48 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id c7so15668475pgt.11
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 09:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=TShFEeX/kYWx+DrO9EUDg6Dfwr0W26274ooC5uHWeQg=;
        b=eUjn3WP6dwppi+DczKaA/NaI9XwMXXuPICt/z+LnDYqYNExvTwdo+0S4zNkmnlv3OQ
         gcjezxOAiTRBjzkUvWl/5gRzG5euhXJshQc4XQ6e8CxOwwN7btIZzECu1Bylmjxv3kmh
         zfv9CUmqUdTh4Gz30GLr4nF1RK/kLuWIhFMaQupmHlXShUeFiU7j3YCB37xuwEEPBsHj
         fJkV7t5bZomIj9IvlWo3n7abjajgpMZlq8YdG98K9/K9oMmRAJgZVpdiSb1nVvWJbDVs
         0AettGvAnpy3CzJZljB3pJxvkliJJouXMC1FKlT5Sor1PYI5DwmyqQn1BMnpO9moFS0u
         QWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=TShFEeX/kYWx+DrO9EUDg6Dfwr0W26274ooC5uHWeQg=;
        b=Y3J8WUHWAa7vmNO7+TdtuMKVGHTaboW8oaFNT/lb0zKrDd7fUzAuIax/0VFLopXi3v
         dW2cawu4kIEZRt9bkLz9t++HaHljQVIrHOKPVfYyFcvEQaiQKizuv7upFdaTuuokfAUH
         vyV0AtkPfEPY9FPTISfzcVBz//niAsHSI2EGktw5jVctiNoyhhkgb87y3dHLUUrVlc/o
         yiV2Aj+QyJRFRkrLtOyIog39eBq7kEHVSOOoc5TCQBvYJRznsNU45xMj8WlIK4DQHWh5
         /QI+maaUgQM5IQh5eYJdczIdALaBHNP0elMl5hjdRv3RTWjEk/67nzaS9tDk58HUHFpE
         8+vg==
X-Gm-Message-State: ACrzQf3nBdFIsSScc22KuoD70JcO/TES/cUrlOevlSu6UYBdTHmsxQSq
        baSh3uANFuWCoxfRE3FSIpVZjwae4ypwt7J/UKM=
X-Google-Smtp-Source: AMsMyM5OadchDYK6jtyboVyo16GwbNr8TYMiGyIzCqTErISREXMcsHc30Jo15bU2NR8TjPD2Hf8bKw==
X-Received: by 2002:a63:e516:0:b0:434:9462:69cd with SMTP id r22-20020a63e516000000b00434946269cdmr476302pgh.503.1664987388080;
        Wed, 05 Oct 2022 09:29:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 30-20020a630f5e000000b00459a36795cbsm729290pgp.42.2022.10.05.09.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 09:29:47 -0700 (PDT)
Message-ID: <633db0fb.630a0220.4e844.15a2@mx.google.com>
Date:   Wed, 05 Oct 2022 09:29:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.12-110-g30c780ac0f9fc
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.19.y baseline: 104 runs,
 4 regressions (v5.19.12-110-g30c780ac0f9fc)
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

stable-rc/linux-5.19.y baseline: 104 runs, 4 regressions (v5.19.12-110-g30c=
780ac0f9fc)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

meson-gxm-khadas-vim2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 2          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.12-110-g30c780ac0f9fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.12-110-g30c780ac0f9fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30c780ac0f9fc09160790cf58f07ef3b92097ceb =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633d7d9e4e7f7f4509cab619

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
2-110-g30c780ac0f9fc/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-un=
leashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
2-110-g30c780ac0f9fc/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-un=
leashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d7d9e4e7f7f4509cab=
61a
        failing since 8 days (last pass: v5.19.11-208-gf962b265cecbb, first=
 fail: v5.19.11-208-gddfc037235223) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 2          =


  Details:     https://kernelci.org/test/plan/id/633d7e554c94a94394cab657

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
2-110-g30c780ac0f9fc/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm=
-khadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
2-110-g30c780ac0f9fc/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm=
-khadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/633d7e554c94a94=
394cab65e
        new failure (last pass: v5.19.12-102-g0d49bf6408c4)
        2 lines

    2022-10-05T12:53:30.795604  kern  :alert :   FSC =3D 0x06: level 2 tran=
slation fault
    2022-10-05T12:53:30.835066  kern  :alert : Data abort info:
    2022-10-05T12:53:30.835319  kern  :alert :   ISV =3D 0, ISS =3D 0x00000=
006
    2022-10-05T12:53:30.835544  kern  :alert :   CM =3D 0, WnR =3D 0
    2022-10-05T12:53:30.835979  kern  :alert : user pgtable: 4k pages, 48-b=
it VAs, pgdp=3D000<8>[   19.830511] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dem=
erg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2022-10-05T12:53:30.836204  00000bdbfc000
    2022-10-05T12:53:30.836434  kern  :a<8>[   19.840055] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 2617540_1.5.2.4.1>
    2022-10-05T12:53:30.836640  lert : [0000000000000328] pgd=3D08000000bdb=
fd003, p4d=3D08000000bdbfd003, pud=3D08000000bdbfe003, pmd=3D00000000000000=
00   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/633d7e554c94a94=
394cab65f
        new failure (last pass: v5.19.12-102-g0d49bf6408c4)
        12 lines

    2022-10-05T12:53:30.792284  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 0000000000000328
    2022-10-05T12:53:30.792764  kern  :alert : Mem abort inf<8>[   19.78761=
7] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines M=
EASUREMENT=3D12>
    2022-10-05T12:53:30.792997  o:
    2022-10-05T12:53:30.793213  kern  :alert :   ESR =3D 0x0000000096000006
    2022-10-05T12:53:30.793422  kern  :alert :   EC =3D 0x25: DABT (current=
 EL), IL =3D 32 bits
    2022-10-05T12:53:30.793630  kern  :alert :   SET =3D 0, FnV =3D 0
    2022-10-05T12:53:30.793830  kern  :alert :   EA =3D 0, S1PTW =3D 0   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633d7f96dccda36d41cab609

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
2-110-g30c780ac0f9fc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
2-110-g30c780ac0f9fc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d7f96dccda36d41cab=
60a
        failing since 11 days (last pass: v5.19.10-40-g8d4fd61ab089, first =
fail: v5.19.11) =

 =20
