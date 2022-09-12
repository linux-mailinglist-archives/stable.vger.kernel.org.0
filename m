Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB815B6387
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 00:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiILWSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 18:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiILWRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 18:17:54 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5171652813
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 15:16:09 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o70-20020a17090a0a4c00b00202f898fa86so93427pjo.2
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 15:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=T9DiPjl9X6I9aaPsVmWckywdNqc4YUuzSEeH4MJ5TAQ=;
        b=6lbtE8vYm7GJBeMf7H/PeIkKePUyPg2sVDLnBdZBG+EiC18lylzSfkAbt44Ggbunp+
         RKF2Cm73m0w+4r9iOziD/gyDH/U7thwOrMYXI2Pq+1J+OBk5SBHM9x92yWyX4oc73wVP
         K84vEd+L9lkHghC5QLuMEhGawCbzmBuim9RwJ/m7K+or0BzvCZ8xmLgMsHXn2GT1fBvZ
         pb7pF+9ZP5GaHjqY7FuO6zXXDh/z7/WAa/6HQOq95MD4WEiO6TCCnDxpRCC71iccmWJB
         iOOEunTIbKcQki5XCXUatfSx/90Gg4OgcEA1nST+yp4P0O/FHwaRJyp9p8WpC2hifdL1
         8Tzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=T9DiPjl9X6I9aaPsVmWckywdNqc4YUuzSEeH4MJ5TAQ=;
        b=yBuWm99jJm3rDNjchZx3aNOiY93w0o1mGlEBrbErtAaqXLtQhhGGB8ZYULza2tdaMt
         9nS0ucdcbt1gRcxMn16qNGjirmK3xyGI63BqC49VajzHTXyxvLc1s4TtLNtiaF+skWsz
         7mijUloH21NpvGtLxRBilaD+PrXH+DM9ag8GJMXMJlxzgLxcw9GfX9vZBKR1pIKPdE/1
         WnUEqi/w9X9IdAQz0C3tDfKXkmiVAQQ1Q5XPGggLPAo1G0eC51Eg225dWvYwVEtj76U8
         5a/rLa/NrHiMJxU7wfiBL4PTlR461SoBhGjOQzoSOFRmWhqu2l71Qtu5c21XktVxr57Z
         5bNA==
X-Gm-Message-State: ACgBeo2GVWsw3oLN/qFR+UqYuzBnqEubqo4ZClbc4h5mcr3ztOwRdfhd
        hTFdkaLfoNdPSREXZVGs2EvNjNXeAK6cwmkDPq8=
X-Google-Smtp-Source: AA6agR7KAlMOFTW1SYJ2/3yN8/igp8QIzPdM0cjsXtawDRTHJTFZ5gO0tp0Xh8DKYp1cHm9Gv7o2cQ==
X-Received: by 2002:a17:90b:4d0e:b0:1f7:ae99:4d7f with SMTP id mw14-20020a17090b4d0e00b001f7ae994d7fmr550489pjb.200.1663020967544;
        Mon, 12 Sep 2022 15:16:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ja1-20020a170902efc100b0017809688d16sm6580254plb.91.2022.09.12.15.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 15:16:07 -0700 (PDT)
Message-ID: <631fafa7.170a0220.be431.b2f6@mx.google.com>
Date:   Mon, 12 Sep 2022 15:16:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.67-119-gabdca1a68c773
Subject: stable-rc/linux-5.15.y baseline: 189 runs,
 4 regressions (v5.15.67-119-gabdca1a68c773)
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

stable-rc/linux-5.15.y baseline: 189 runs, 4 regressions (v5.15.67-119-gabd=
ca1a68c773)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig        | 1          =

imx7d-sdb                    | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.67-119-gabdca1a68c773/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.67-119-gabdca1a68c773
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      abdca1a68c77347d761bf5a274bef3e88c6882c8 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/631f7a1dad4bf0d58b355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-119-gabdca1a68c773/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-119-gabdca1a68c773/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f7a1dad4bf0d58b355=
643
        failing since 123 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7d-sdb                    | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/631f7733ca6225e28e355677

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-119-gabdca1a68c773/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-=
sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-119-gabdca1a68c773/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-=
sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/631f7733ca6225e=
28e35567c
        new failure (last pass: v5.15.67)
        2 lines

    2022-09-12T18:14:45.546274  kern  :emerg : BUG: spinlock wrong CPU on C=
PU#0, swapper/0/1
    2022-09-12T18:14:45.546863  kern  :emerg :  lock: 0xc49c890c, .magic: d=
ead4ead, .owner: swapper/0/1, .owner_cpu: 1
    2022-09-12T18:14:45.547128  <8>[   30.112960] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2022-09-12T18:14:45.547377  + set +x   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/631f8d5448c66484d73556c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-119-gabdca1a68c773/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-119-gabdca1a68c773/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f8d5448c66484d7355=
6c4
        new failure (last pass: v5.15.67) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/631f7b8a13108330c2355642

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-119-gabdca1a68c773/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-119-gabdca1a68c773/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/631f7b8a13108330c2355668
        failing since 188 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-09-12T18:33:37.185961  /lava-7248237/1/../bin/lava-test-case   =

 =20
