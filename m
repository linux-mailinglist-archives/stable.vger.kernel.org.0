Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515036C3E85
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 00:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjCUXbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 19:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCUXbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 19:31:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05743BB89
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 16:31:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q102so2501788pjq.3
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 16:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679441476;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=fUqQ1ePA2k/n0EIvzh55+eNcw5ltuc6mdNCn7sOn14U=;
        b=WnPhPPa25h8L+LRTxcvXCYPhSB6jT36Ss7ySmzEDYnYaM5SblYd2XL8kD4BbBWGVC8
         vUwTk7JM8uCgfpl/c9QOa4+uV2vX0SJ0hXgngwUrLl7nwdRB9yVC7qWNFHSP66xJl2Ph
         TgbIs8DRwwBA6mESSEvtRKxQqY/S/lzkyS3OEC0ifL8BpryOuDkdwtJ7QARA7UVKyEJv
         74eKyTcY8Qt+LPyhJpA/FNxggyKtuFBuoJ52iXkgV04MiMc9ofbduhKtMufmbSqyfEKi
         x/leE5gGa6RdprqXIelvIVsdDHcrrrC0Lxv6/bEeX81aox5gIJj++Y4orQn2wNRGixbZ
         hiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679441476;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fUqQ1ePA2k/n0EIvzh55+eNcw5ltuc6mdNCn7sOn14U=;
        b=DisD1y9kt6a9dpAKYtKMafe28lUhIZQLlEkZdz4ppPJ52hkWL1s1GRMcf1YUDs/soU
         3Aem1ZsXUuzjj/M3CaZNYPKlq46EvXVpTEddHqjDA6JUMYz+0cMWD9sWRuNWzkxzx5Yj
         85NTm1epQ9sixZRuky+vNIjvGRsw5CEzFFRuO/nTmrhnhxmshYzaSDVRSSEraYdiil2a
         YPRIddpsLM0F/RbqVsLZSZ7l1LvxWxiH6gLs5lsvOosZgPviT4KzJ+e2v7n+MiUFWCyz
         9QlSLOkO4SEy9yWI6fk6DE6imyUb6zoc7eMomJscgidM60A/QeSW6XdEQnyrPGdoQUXe
         ljLA==
X-Gm-Message-State: AO0yUKVTmWHgFv7iwuEvvKbLt+RuvCYfl3aIiJCUGQAjyW1WdXE0g26d
        /wNaitUFIf04XL25cW8hqZliwn+LRwJY5zTMc84=
X-Google-Smtp-Source: AK7set8hoAsP8IC9TqAQB//86hJdLqcnYYeFkXoLc3dwKMlHEZm69+f5Z53mVxynKwOqXHkNxJu92g==
X-Received: by 2002:a17:903:4094:b0:1a1:c8b3:3fe1 with SMTP id z20-20020a170903409400b001a1c8b33fe1mr554595plc.31.1679441476244;
        Tue, 21 Mar 2023 16:31:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019c90f8c831sm9234690plo.242.2023.03.21.16.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 16:31:15 -0700 (PDT)
Message-ID: <641a3e43.170a0220.3c16d.157b@mx.google.com>
Date:   Tue, 21 Mar 2023 16:31:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.20-200-g2152cefff654
Subject: stable-rc/linux-6.1.y baseline: 172 runs,
 2 regressions (v6.1.20-200-g2152cefff654)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-6.1.y baseline: 172 runs, 2 regressions (v6.1.20-200-g2152c=
efff654)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
bcm2835-rpi-b-rev2 | arm  | lab-broonie   | gcc-10   | bcm2835_defconfig | =
1          =

qemu_mips-malta    | mips | lab-collabora | gcc-10   | malta_defconfig   | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.20-200-g2152cefff654/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.20-200-g2152cefff654
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2152cefff654f81f4c754469a07ac3c6105ed4b3 =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
bcm2835-rpi-b-rev2 | arm  | lab-broonie   | gcc-10   | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/641a05dd81967b4c1a9c950e

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20-=
200-g2152cefff654/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20-=
200-g2152cefff654/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641a05dd81967b4c1a9c9545
        failing since 1 day (last pass: v6.1.20, first fail: v6.1.20-199-ga=
6e5071b9d96)

    2023-03-21T19:30:11.127327  + set +x
    2023-03-21T19:30:11.131011  <8>[   16.842320] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 202819_1.5.2.4.1>
    2023-03-21T19:30:11.248318  / # #
    2023-03-21T19:30:11.350548  export SHELL=3D/bin/sh
    2023-03-21T19:30:11.351054  #
    2023-03-21T19:30:11.452448  / # export SHELL=3D/bin/sh. /lava-202819/en=
vironment
    2023-03-21T19:30:11.453080  =

    2023-03-21T19:30:11.554512  / # . /lava-202819/environment/lava-202819/=
bin/lava-test-runner /lava-202819/1
    2023-03-21T19:30:11.555318  =

    2023-03-21T19:30:11.562639  / # /lava-202819/bin/lava-test-runner /lava=
-202819/1 =

    ... (14 line(s) more)  =

 =



platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
qemu_mips-malta    | mips | lab-collabora | gcc-10   | malta_defconfig   | =
1          =


  Details:     https://kernelci.org/test/plan/id/641a074592d4dbddc29c9508

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20-=
200-g2152cefff654/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20-=
200-g2152cefff654/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/641a074592d4dbd=
dc29c950c
        failing since 0 day (last pass: v6.1.20-199-ga6e5071b9d96, first fa=
il: v6.1.20-199-gdb4b67830dc1)
        1 lines

    2023-03-21T19:36:16.699604  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 351b0bdc, epc =3D=3D 8023f540, ra =3D=
=3D 8023f524
    2023-03-21T19:36:16.699904  =

   =

 =20
