Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5E86C038C
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 18:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjCSRoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 13:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCSRoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 13:44:10 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CB51CF7C
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 10:44:09 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c4so5707073pfl.0
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 10:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679247848;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jmeQAyjEjrJ1bY9HTFeY/QOydwSz+xDGsyaEcN5mSW4=;
        b=ekZBQOIaGYSlYOMWhdXCESCV/m5n5qqHdYEgQOo0XeOtJJGnBkaxDVCn6Jds0+YWk5
         3u691A2kMzAA3oc574CU6INg/j/n/IzeXvHXjD2Cop19zkGJ5nSxF7ylTOJG37ZMMHsg
         UfDKPX4Bk13H9hsFEKx0SemUGdRJEMIDuP3qF55l8oY6kFYz53M/6G74Krt6Diz8kUrr
         E8fa1UZ/onSu5O/lrWJHgS11SwTNiBGqj8rkfce+bWHPCuYZGoSMJiVTlAfkXEfWASLS
         OddfhgQHMpsIIe/BITXAoXri6eJueYg1GZD6B8kLIArcDqSU2LrAD3vqkgns9ClFxDa9
         1Inw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679247848;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jmeQAyjEjrJ1bY9HTFeY/QOydwSz+xDGsyaEcN5mSW4=;
        b=FpU2aKPasjFwgGmAFtuZ0D30mP83VI2Q0pCTkjLf3YSOsKd/H1bjhC5kRvkTuCfg2i
         9UdLUHXxMzpmwQvkPdETh99B2peLpC7GM6YlvgqsTSRSZEkYYb+8xNbLLCYZhGgEg8DT
         82zXaVDF1Uf5/9638CK5Tkd7gVJK2YKUJPtfQ14+cWWZKJVn8iqibULagVa+KEKuxIDV
         K+ut3I1fh1Gnvgc42LGmaH5iI5tcRayd2kgxTFw+HboWAsLJ7hI3yv5IPMYArRClbuMx
         KkVcI1kpweRrb+emfhwtGwrpDJ0lr/ONOF8v3WVofUMXEJOdSMO0gT7nDuTU0p4c78Er
         Cqig==
X-Gm-Message-State: AO0yUKXVkf9beL7C8BprCYdASVBayYOtlJR6TNKpkQuDTHHsMw0t9PCM
        lNwAI0hqVMnVWJV3PS3qmEUYI7rWOXP0iJtMD5I/uA==
X-Google-Smtp-Source: AK7set8NAerZuGhiQUxyUYx3PIdxU/CkIouqDV6RHuIKoMh6AiU0Fa+XDvSaZ49cSk0lAebCfjhUOA==
X-Received: by 2002:aa7:9e92:0:b0:627:f13d:8ba9 with SMTP id p18-20020aa79e92000000b00627f13d8ba9mr1869088pfq.28.1679247848487;
        Sun, 19 Mar 2023 10:44:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j4-20020a62b604000000b00588e0d5124asm4806169pff.160.2023.03.19.10.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 10:44:08 -0700 (PDT)
Message-ID: <641749e8.620a0220.25279.78f2@mx.google.com>
Date:   Sun, 19 Mar 2023 10:44:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.20-92-gafcdef45f9b4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 176 runs,
 3 regressions (v6.1.20-92-gafcdef45f9b4)
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

stable-rc/queue/6.1 baseline: 176 runs, 3 regressions (v6.1.20-92-gafcdef45=
f9b4)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
acer-R721T-grunt   | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =

bcm2835-rpi-b-rev2 | arm    | lab-broonie   | gcc-10   | bcm2835_defconfig =
           | 1          =

qemu_mips-malta    | mips   | lab-collabora | gcc-10   | malta_defconfig   =
           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.20-92-gafcdef45f9b4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.20-92-gafcdef45f9b4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      afcdef45f9b495a2941c8e5bf6e21ee0b509d56c =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
acer-R721T-grunt   | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641715e57995a1cb7e8c8672

  Results:     18 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-92=
-gafcdef45f9b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-acer-R721T-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-92=
-gafcdef45f9b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-acer-R721T-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/641715e57995a1c=
b7e8c8675
        new failure (last pass: v6.1.19-139-g6d04fa2f2978)
        1 lines

    2023-03-19T14:02:03.267126  kern  :emerg : __common_interrupt: 1.55 No =
irq handler for vector

    2023-03-19T14:02:03.277384  <8>[    9.815169] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
   =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
bcm2835-rpi-b-rev2 | arm    | lab-broonie   | gcc-10   | bcm2835_defconfig =
           | 1          =


  Details:     https://kernelci.org/test/plan/id/64171525a89d5296168c8655

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-92=
-gafcdef45f9b4/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-92=
-gafcdef45f9b4/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64171525a89d5296168c8686
        failing since 2 days (last pass: v6.1.18-144-g88546018fee83, first =
fail: v6.1.19-139-g6d04fa2f2978)

    2023-03-19T13:58:39.557224  + set +x
    2023-03-19T13:58:39.561195  <8>[   16.443393] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 186781_1.5.2.4.1>
    2023-03-19T13:58:39.676546  / # #
    2023-03-19T13:58:39.779467  export SHELL=3D/bin/sh
    2023-03-19T13:58:39.780310  #
    2023-03-19T13:58:39.882552  / # export SHELL=3D/bin/sh. /lava-186781/en=
vironment
    2023-03-19T13:58:39.883406  =

    2023-03-19T13:58:39.985356  / # . /lava-186781/environment/lava-186781/=
bin/lava-test-runner /lava-186781/1
    2023-03-19T13:58:39.986680  =

    2023-03-19T13:58:39.993409  / # /lava-186781/bin/lava-test-runner /lava=
-186781/1 =

    ... (14 line(s) more)  =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
qemu_mips-malta    | mips   | lab-collabora | gcc-10   | malta_defconfig   =
           | 1          =


  Details:     https://kernelci.org/test/plan/id/641715e9936c63457d8c866e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-92=
-gafcdef45f9b4/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips=
-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-92=
-gafcdef45f9b4/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips=
-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641715e9936c63457d8c8=
66f
        new failure (last pass: v6.1.19-139-g6d04fa2f2978) =

 =20
