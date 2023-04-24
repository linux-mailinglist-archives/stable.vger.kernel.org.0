Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC766ED443
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 20:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjDXSSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 14:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjDXSSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 14:18:31 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8646A62
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 11:18:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-24756a12ba0so3368511a91.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 11:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682360280; x=1684952280;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mX3D7xk8bJ1z8YO8ZHOV189kS408dsObZtVAH+9Gurk=;
        b=OMnc8vpdYxPtyADMKaPN4HLELIK1PfEw/tS17aViC9e1ndzEZxehMOUt7Vui80J+cQ
         69H/fb3GT4oO4QagQhJSfbmY+8TtnSzpBufW2ivGbr/HUqTNTU515ogPf7BkvniFoz66
         ilULJCqUI2vCyRrCbFkNw2/t/B4ne1gcEq65L00n+5k0n+QEEDXsEPR8O/dgdm14b4Uf
         9ysDhdfT/lqE3yRjd3GHT2sxSaUP2LBv5BVp3tOxPFjNaLARON6ygaCvWcw2/v1XNip2
         I4f1XDDP5VOcTBWf9UoP2dldhk8JDJxa1nl0vvJZ3d7SeM/IfrGJfiPZP6j9iDtvWpn+
         MHdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682360280; x=1684952280;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mX3D7xk8bJ1z8YO8ZHOV189kS408dsObZtVAH+9Gurk=;
        b=bWEP/byXG7Qc1qM6nP6Z8N4wd8kHy/HCJlXfsXBzg5+opKfM58Nu7cXBf9cYl5JdjK
         u2kp8q9TenO4ThnEIS0uvYYAcBjssPCPSt1/KEfbeou6VM1P8WOOGP7ruIEtyu+9mhQa
         6TnouCLZ6lBn4++7zt/oAbCXgrkPWu1Tk9GnCpHv+7WEXTfHT7tfUz0XY8DY+5ZgGLXz
         NVjCkYUuhbEK8cypMYDP8LC+a9TCCpBhyOg0QCXjpeUe4KRQKBzm5jTm+gyCGjDirgh9
         dd2yfiAVUQo4D2z8o3SPSNJKjj+Wggs9QHX16Fx+fu3KQFh/Z0uXnV/QMYDdp3GBKiyk
         Kh/Q==
X-Gm-Message-State: AAQBX9cDD4yMBDNlBwCtfrX9zp7ovCL0CnfD8jq6WSAjeWr3Ba4dS0l9
        E685AGkVnXZgRpeMelBqLTcRxhHzbcsrjOE58Uq8fQ==
X-Google-Smtp-Source: AKy350avvcJxQWDrDsiP2JPDPB2nrtOrEDLFsFG4bBy6USzLftfcxOp542SFn9t2m1SK+ZW/r8LYcA==
X-Received: by 2002:a17:90b:28b:b0:246:91d0:9e6f with SMTP id az11-20020a17090b028b00b0024691d09e6fmr15653532pjb.3.1682360280500;
        Mon, 24 Apr 2023 11:18:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h9-20020a17090a710900b002473d046e23sm6615604pjk.3.2023.04.24.11.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 11:17:59 -0700 (PDT)
Message-ID: <6446c7d7.170a0220.2a799.d778@mx.google.com>
Date:   Mon, 24 Apr 2023 11:17:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-574-ge4ff6ff54dea
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 138 runs,
 7 regressions (v6.1.22-574-ge4ff6ff54dea)
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

stable-rc/linux-6.1.y baseline: 138 runs, 7 regressions (v6.1.22-574-ge4ff6=
ff54dea)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.22-574-ge4ff6ff54dea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.22-574-ge4ff6ff54dea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e4ff6ff54dea67f94036a357201b0f9807405cc6 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644693bbe75337a3c22e860f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644693bbe75337a3c22e8614
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-24T14:35:22.251633  + set +x

    2023-04-24T14:35:22.257880  <8>[   10.297430] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10104156_1.4.2.3.1>

    2023-04-24T14:35:22.362930  / # #

    2023-04-24T14:35:22.463629  export SHELL=3D/bin/sh

    2023-04-24T14:35:22.463857  #

    2023-04-24T14:35:22.564398  / # export SHELL=3D/bin/sh. /lava-10104156/=
environment

    2023-04-24T14:35:22.564668  =


    2023-04-24T14:35:22.665247  / # . /lava-10104156/environment/lava-10104=
156/bin/lava-test-runner /lava-10104156/1

    2023-04-24T14:35:22.665677  =


    2023-04-24T14:35:22.671217  / # /lava-10104156/bin/lava-test-runner /la=
va-10104156/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644693b7e813a907e72e861a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644693b7e813a907e72e861f
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-24T14:35:12.345159  + <8>[   11.732184] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10104144_1.4.2.3.1>

    2023-04-24T14:35:12.345264  set +x

    2023-04-24T14:35:12.449724  / # #

    2023-04-24T14:35:12.550343  export SHELL=3D/bin/sh

    2023-04-24T14:35:12.550517  #

    2023-04-24T14:35:12.651076  / # export SHELL=3D/bin/sh. /lava-10104144/=
environment

    2023-04-24T14:35:12.651274  =


    2023-04-24T14:35:12.751813  / # . /lava-10104144/environment/lava-10104=
144/bin/lava-test-runner /lava-10104144/1

    2023-04-24T14:35:12.752133  =


    2023-04-24T14:35:12.757082  / # /lava-10104144/bin/lava-test-runner /la=
va-10104144/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644693b8e813a907e72e8626

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644693b8e813a907e72e862b
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-24T14:35:28.469489  <8>[    9.981682] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10104140_1.4.2.3.1>

    2023-04-24T14:35:28.472632  + set +x

    2023-04-24T14:35:28.574108  =


    2023-04-24T14:35:28.674659  / # #export SHELL=3D/bin/sh

    2023-04-24T14:35:28.674854  =


    2023-04-24T14:35:28.775439  / # export SHELL=3D/bin/sh. /lava-10104140/=
environment

    2023-04-24T14:35:28.775646  =


    2023-04-24T14:35:28.876199  / # . /lava-10104140/environment/lava-10104=
140/bin/lava-test-runner /lava-10104140/1

    2023-04-24T14:35:28.876503  =


    2023-04-24T14:35:28.881600  / # /lava-10104140/bin/lava-test-runner /la=
va-10104140/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644693ac0a1375c0002e8602

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644693ac0a1375c0002e8607
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-24T14:35:15.739638  + set +x

    2023-04-24T14:35:15.746393  <8>[   10.407576] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10104121_1.4.2.3.1>

    2023-04-24T14:35:15.857771  / # #

    2023-04-24T14:35:15.960672  export SHELL=3D/bin/sh

    2023-04-24T14:35:15.961427  #

    2023-04-24T14:35:16.062659  / # export SHELL=3D/bin/sh. /lava-10104121/=
environment

    2023-04-24T14:35:16.062884  =


    2023-04-24T14:35:16.163479  / # . /lava-10104121/environment/lava-10104=
121/bin/lava-test-runner /lava-10104121/1

    2023-04-24T14:35:16.163777  =


    2023-04-24T14:35:16.168293  / # /lava-10104121/bin/lava-test-runner /la=
va-10104121/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446939a6e0b61b3b62e8630

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446939a6e0b61b3b62e8635
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-24T14:34:51.210211  <8>[    7.909210] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10104101_1.4.2.3.1>

    2023-04-24T14:34:51.213871  + set +x

    2023-04-24T14:34:51.318184  / # #

    2023-04-24T14:34:51.418819  export SHELL=3D/bin/sh

    2023-04-24T14:34:51.419028  #

    2023-04-24T14:34:51.519570  / # export SHELL=3D/bin/sh. /lava-10104101/=
environment

    2023-04-24T14:34:51.519825  =


    2023-04-24T14:34:51.620420  / # . /lava-10104101/environment/lava-10104=
101/bin/lava-test-runner /lava-10104101/1

    2023-04-24T14:34:51.620735  =


    2023-04-24T14:34:51.625603  / # /lava-10104101/bin/lava-test-runner /la=
va-10104101/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644693b8289dce91142e85f9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644693b8289dce91142e85fe
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-24T14:35:17.853083  + set<8>[   11.076738] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10104106_1.4.2.3.1>

    2023-04-24T14:35:17.853199   +x

    2023-04-24T14:35:17.957640  / # #

    2023-04-24T14:35:18.058322  export SHELL=3D/bin/sh

    2023-04-24T14:35:18.058617  #

    2023-04-24T14:35:18.159164  / # export SHELL=3D/bin/sh. /lava-10104106/=
environment

    2023-04-24T14:35:18.159393  =


    2023-04-24T14:35:18.259917  / # . /lava-10104106/environment/lava-10104=
106/bin/lava-test-runner /lava-10104106/1

    2023-04-24T14:35:18.260287  =


    2023-04-24T14:35:18.264740  / # /lava-10104106/bin/lava-test-runner /la=
va-10104106/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644693a0ec0ed521692e860e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
574-ge4ff6ff54dea/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644693a0ec0ed521692e8613
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-24T14:34:58.708929  <8>[   12.292451] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10104125_1.4.2.3.1>

    2023-04-24T14:34:58.813063  / # #

    2023-04-24T14:34:58.913762  export SHELL=3D/bin/sh

    2023-04-24T14:34:58.913941  #

    2023-04-24T14:34:59.014399  / # export SHELL=3D/bin/sh. /lava-10104125/=
environment

    2023-04-24T14:34:59.014574  =


    2023-04-24T14:34:59.115255  / # . /lava-10104125/environment/lava-10104=
125/bin/lava-test-runner /lava-10104125/1

    2023-04-24T14:34:59.115512  =


    2023-04-24T14:34:59.120160  / # /lava-10104125/bin/lava-test-runner /la=
va-10104125/1

    2023-04-24T14:34:59.126771  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
