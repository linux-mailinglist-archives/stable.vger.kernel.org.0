Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127FB6D0D46
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 20:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjC3SAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 14:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjC3SAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 14:00:24 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E492BE19C
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 11:00:22 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso20532129pjb.3
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 11:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680199222;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=v3z7bwJEO9+ggc0qht72IY2t5kLWEvy/tkUYOeaXgY4=;
        b=veIdyzS/FV9hj74O8IPCR9a2xrAGpVcTcpP/v/asR5FrelH7dOLpwfffRDg+DVlvng
         AamIstJWJFhQX0m5CzxpLUXvKhrerNj7Pjgvugm1KvQ3QfSgaTqdFdQ2MBGJkzga7oLs
         XOM2YVLK+LxUusbp46FCen5mpPcb6pShrBE0CrI8ybFxwQkowqSyk8aT4lwiSl1yaVnu
         jmV56U0F2JMvwMFO5Q9hPj9eiqMvg01KlUrSTs9amazmO4MLMgNDpwkaf0jbex5Q6a/s
         0QaNRDlAKRpoovOKC3l5duAvULDN0C0U2dYCt8MocEiMrqKWJFW+wmBFQPTiHh0SeewG
         XIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680199222;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v3z7bwJEO9+ggc0qht72IY2t5kLWEvy/tkUYOeaXgY4=;
        b=Jv9hmNDvp8KwsTqjcnKa/tYcCaVzk7nM0IUyuCtN5yy2inCADlLGOqz/jrYzb4F/PF
         OCm4Grc7aVMgwAxv2l8/x+lbUYS1NFO+Sb4nqaUsOrV4970hFieElBnywWd3/LDERxhJ
         hZQHOuZK1Ahv2ld+hccmd12fK90Wq4xkJYqZpc+zY4yMe/9YjPsTVaOzcND+w+RZYV5C
         efJPEhP9HxQ/RG6coV3hCxUDxBJ73337zKdqtEnENfddXFKCv7ULhtp8S4HJVDN491JL
         PkW84dFJOg70oZ8hNGi6I9HPI5b1MfEziyh440tL9qO8bStyL2fAd0Z/gavqBlwkErYn
         dSog==
X-Gm-Message-State: AAQBX9d6prGlHZ+22n/wLD+pubk0GTtiHuLrUhzIOjCmv8V97Ae59hz6
        3D8u9TRiMGmPGLPCNthrYTfb21drPwq2sAbMNsku0w==
X-Google-Smtp-Source: AKy350Zau0m320lJLFMOS10Xy7PjrUSBpmU74GHUJEXj8dYmhy79vKfo2TCrOPkJJ7QiDGO8rEI8+w==
X-Received: by 2002:a17:90b:180a:b0:23f:aa93:6cfd with SMTP id lw10-20020a17090b180a00b0023faa936cfdmr26817677pjb.18.1680199221266;
        Thu, 30 Mar 2023 11:00:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2-20020a17090a8d8200b0023d3845b02bsm3510279pjo.45.2023.03.30.11.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 11:00:20 -0700 (PDT)
Message-ID: <6425ce34.170a0220.2e988.7b72@mx.google.com>
Date:   Thu, 30 Mar 2023 11:00:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105
Subject: stable-rc/linux-5.15.y baseline: 174 runs, 11 regressions (v5.15.105)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 174 runs, 11 regressions (v5.15.105)

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

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

kontron-pitx-imx8m           | arm64  | lab-kontron   | gcc-10   | defconfi=
g                    | 2          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.105/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.105
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c957cbb8731536ddc9a01e4c1cd51eab6558aa14 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642595f0fd6cd7af3562f792

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642595f0fd6cd7af3562f797
        failing since 1 day (last pass: v5.15.104, first fail: v5.15.104-14=
7-gea115396267e)

    2023-03-30T14:00:05.931264  + set +x

    2023-03-30T14:00:05.938009  <8>[   10.190994] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816743_1.4.2.3.1>

    2023-03-30T14:00:06.040124  #

    2023-03-30T14:00:06.040454  =


    2023-03-30T14:00:06.141464  / # #export SHELL=3D/bin/sh

    2023-03-30T14:00:06.141701  =


    2023-03-30T14:00:06.242714  / # export SHELL=3D/bin/sh. /lava-9816743/e=
nvironment

    2023-03-30T14:00:06.242953  =


    2023-03-30T14:00:06.343694  / # . /lava-9816743/environment/lava-981674=
3/bin/lava-test-runner /lava-9816743/1

    2023-03-30T14:00:06.344003  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642595df381ba6028762f770

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642595df381ba6028762f775
        failing since 1 day (last pass: v5.15.104, first fail: v5.15.104-14=
7-gea115396267e)

    2023-03-30T13:59:52.716767  + set<8>[   11.049898] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9816756_1.4.2.3.1>

    2023-03-30T13:59:52.716862   +x

    2023-03-30T13:59:52.820972  / # #

    2023-03-30T13:59:52.922057  export SHELL=3D/bin/sh

    2023-03-30T13:59:52.922299  #

    2023-03-30T13:59:53.023249  / # export SHELL=3D/bin/sh. /lava-9816756/e=
nvironment

    2023-03-30T13:59:53.023499  =


    2023-03-30T13:59:53.124639  / # . /lava-9816756/environment/lava-981675=
6/bin/lava-test-runner /lava-9816756/1

    2023-03-30T13:59:53.125096  =


    2023-03-30T13:59:53.129657  / # /lava-9816756/bin/lava-test-runner /lav=
a-9816756/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642595e0e19189785662f793

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642595e0e19189785662f798
        failing since 1 day (last pass: v5.15.104, first fail: v5.15.104-14=
7-gea115396267e)

    2023-03-30T13:59:39.091696  <8>[   10.860389] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816700_1.4.2.3.1>

    2023-03-30T13:59:39.095096  + set +x

    2023-03-30T13:59:39.196895  #

    2023-03-30T13:59:39.297919  / # #export SHELL=3D/bin/sh

    2023-03-30T13:59:39.298146  =


    2023-03-30T13:59:39.399112  / # export SHELL=3D/bin/sh. /lava-9816700/e=
nvironment

    2023-03-30T13:59:39.399306  =


    2023-03-30T13:59:39.500262  / # . /lava-9816700/environment/lava-981670=
0/bin/lava-test-runner /lava-9816700/1

    2023-03-30T13:59:39.500593  =


    2023-03-30T13:59:39.505634  / # /lava-9816700/bin/lava-test-runner /lav=
a-9816700/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64259920afe6a9c49d62f7f1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259920afe6a9c49d62f7f6
        failing since 72 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-03-30T14:13:40.248999  <8>[   10.048703] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3455756_1.5.2.4.1>
    2023-03-30T14:13:40.359862  / # #
    2023-03-30T14:13:40.463852  export SHELL=3D/bin/sh
    2023-03-30T14:13:40.464773  #
    2023-03-30T14:13:40.465272  / # <3>[   10.193305] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-03-30T14:13:40.567194  export SHELL=3D/bin/sh. /lava-3455756/envir=
onment
    2023-03-30T14:13:40.568097  =

    2023-03-30T14:13:40.670236  / # . /lava-3455756/environment/lava-345575=
6/bin/lava-test-runner /lava-3455756/1
    2023-03-30T14:13:40.670847  =

    2023-03-30T14:13:40.676045  / # /lava-3455756/bin/lava-test-runner /lav=
a-3455756/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6425963430ffae5c4d62f77f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425963430ffae5c4d62f782
        failing since 26 days (last pass: v5.15.79, first fail: v5.15.98)

    2023-03-30T14:00:52.021732  [   14.710626] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1190407_1.5.2.4.1>
    2023-03-30T14:00:52.125942  / # #
    2023-03-30T14:00:52.228007  export SHELL=3D/bin/sh
    2023-03-30T14:00:52.228607  #
    2023-03-30T14:00:52.329956  / # export SHELL=3D/bin/sh. /lava-1190407/e=
nvironment
    2023-03-30T14:00:52.330431  =

    2023-03-30T14:00:52.431812  / # . /lava-1190407/environment/lava-119040=
7/bin/lava-test-runner /lava-1190407/1
    2023-03-30T14:00:52.432596  =

    2023-03-30T14:00:52.434425  / # /lava-1190407/bin/lava-test-runner /lav=
a-1190407/1
    2023-03-30T14:00:52.452583  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642595e1cb37d8ea8762f782

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642595e1cb37d8ea8762f787
        failing since 1 day (last pass: v5.15.104, first fail: v5.15.104-14=
7-gea115396267e)

    2023-03-30T13:59:44.841075  + set +x

    2023-03-30T13:59:44.848101  <8>[   10.954735] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816725_1.4.2.3.1>

    2023-03-30T13:59:44.952522  / # #

    2023-03-30T13:59:45.053527  export SHELL=3D/bin/sh

    2023-03-30T13:59:45.053723  #

    2023-03-30T13:59:45.154505  / # export SHELL=3D/bin/sh. /lava-9816725/e=
nvironment

    2023-03-30T13:59:45.154709  =


    2023-03-30T13:59:45.255617  / # . /lava-9816725/environment/lava-981672=
5/bin/lava-test-runner /lava-9816725/1

    2023-03-30T13:59:45.255941  =


    2023-03-30T13:59:45.260351  / # /lava-9816725/bin/lava-test-runner /lav=
a-9816725/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642595eae79e204aef62f76f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642595eae79e204aef62f774
        failing since 1 day (last pass: v5.15.104, first fail: v5.15.104-14=
7-gea115396267e)

    2023-03-30T13:59:53.971608  + set +x

    2023-03-30T13:59:53.978170  <8>[    8.091449] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816729_1.4.2.3.1>

    2023-03-30T13:59:54.080330  #

    2023-03-30T13:59:54.181589  / # #export SHELL=3D/bin/sh

    2023-03-30T13:59:54.181849  =


    2023-03-30T13:59:54.282709  / # export SHELL=3D/bin/sh. /lava-9816729/e=
nvironment

    2023-03-30T13:59:54.282969  =


    2023-03-30T13:59:54.383964  / # . /lava-9816729/environment/lava-981672=
9/bin/lava-test-runner /lava-9816729/1

    2023-03-30T13:59:54.384342  =


    2023-03-30T13:59:54.389240  / # /lava-9816729/bin/lava-test-runner /lav=
a-9816729/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642595ebfd6cd7af3562f76d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642595ebfd6cd7af3562f772
        failing since 1 day (last pass: v5.15.104, first fail: v5.15.104-14=
7-gea115396267e)

    2023-03-30T14:00:03.236097  + <8>[   11.514225] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9816727_1.4.2.3.1>

    2023-03-30T14:00:03.236215  set +x

    2023-03-30T14:00:03.341428  / # #

    2023-03-30T14:00:03.442504  export SHELL=3D/bin/sh

    2023-03-30T14:00:03.442757  #

    2023-03-30T14:00:03.543724  / # export SHELL=3D/bin/sh. /lava-9816727/e=
nvironment

    2023-03-30T14:00:03.543985  =


    2023-03-30T14:00:03.644969  / # . /lava-9816727/environment/lava-981672=
7/bin/lava-test-runner /lava-9816727/1

    2023-03-30T14:00:03.645335  =


    2023-03-30T14:00:03.650624  / # /lava-9816727/bin/lava-test-runner /lav=
a-9816727/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
kontron-pitx-imx8m           | arm64  | lab-kontron   | gcc-10   | defconfi=
g                    | 2          =


  Details:     https://kernelci.org/test/plan/id/64259594276e173d3162f76d

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259594276e173d3162f770
        failing since 1 day (last pass: v5.15.104, first fail: v5.15.104-14=
7-gea115396267e)

    2023-03-30T13:58:28.567286  / # #
    2023-03-30T13:58:28.669927  export SHELL=3D/bin/sh
    2023-03-30T13:58:28.670612  #
    2023-03-30T13:58:28.772236  / # export SHELL=3D/bin/sh. /lava-306668/en=
vironment
    2023-03-30T13:58:28.772630  =

    2023-03-30T13:58:28.874289  / # . /lava-306668/environment/lava-306668/=
bin/lava-test-runner /lava-306668/1
    2023-03-30T13:58:28.875647  =

    2023-03-30T13:58:28.893951  / # /lava-306668/bin/lava-test-runner /lava=
-306668/1
    2023-03-30T13:58:28.940996  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-30T13:58:28.941548  + cd /l<8>[   12.187176] <LAVA_SIGNAL_START=
RUN 1_bootrr 306668_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/642=
59594276e173d3162f780
        failing since 1 day (last pass: v5.15.104, first fail: v5.15.104-14=
7-gea115396267e)

    2023-03-30T13:58:31.264209  /lava-306668/1/../bin/lava-test-case
    2023-03-30T13:58:31.264694  <8>[   14.604370] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-03-30T13:58:31.265026  /lava-306668/1/../bin/lava-test-case   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642595eb381ba6028762f824

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-len=
ovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-len=
ovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642595eb381ba6028762f829
        failing since 1 day (last pass: v5.15.104, first fail: v5.15.104-14=
7-gea115396267e)

    2023-03-30T13:59:53.042283  + set<8>[   12.030950] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9816746_1.4.2.3.1>

    2023-03-30T13:59:53.042723   +x

    2023-03-30T13:59:53.151655  / # #

    2023-03-30T13:59:53.254335  export SHELL=3D/bin/sh

    2023-03-30T13:59:53.255127  #

    2023-03-30T13:59:53.357165  / # export SHELL=3D/bin/sh. /lava-9816746/e=
nvironment

    2023-03-30T13:59:53.357993  =


    2023-03-30T13:59:53.459724  / # . /lava-9816746/environment/lava-981674=
6/bin/lava-test-runner /lava-9816746/1

    2023-03-30T13:59:53.460811  =


    2023-03-30T13:59:53.465858  / # /lava-9816746/bin/lava-test-runner /lav=
a-9816746/1
 =

    ... (12 line(s) more)  =

 =20
