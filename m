Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64C06ED59A
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 21:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbjDXTya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 15:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbjDXTyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 15:54:21 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD7B7AA3
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 12:54:08 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b67a26069so6637358b3a.0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 12:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682366048; x=1684958048;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=w4HEneIH8oQUE417V+kqADm/7TCd6SViJXLNwYdIyVI=;
        b=047YO5fFnaiTxHb//C6XVXYp20KXOsEytj/MKouNU1k/7wtFzjHmmXQ/sB5QvfkwCX
         xFF6vBam+1CuvFwDRg0+XQ/iEXtS+r1fw9shBQr2zLJ7NkQzcxUEo/VxNK+lV9MWPIfU
         V296IuWKWJIxdeZ9uO2ZMTGip8Fo4CTVXFgDGtmuuE3V7hT2p7ACh3ipuhxCg5YIYLRN
         an7Zvh2FN5kLPJkoTVGfXtzebWDgc7eHgbYuF03VI6ut6O4s3Co357MZbSprcJMhNPIw
         09EjgjQUTKmKTuVI4cWUBxq73ccbpqWOd7CENyAQDdq0Q5jiexqAdK1NJTGWbcBdyWvG
         vNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682366048; x=1684958048;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w4HEneIH8oQUE417V+kqADm/7TCd6SViJXLNwYdIyVI=;
        b=l7/o1/XC2F2jdePVuj4hvG8NAvO8kRuCgSQKT4WW+0QRr0q6A/DknkWAqQbLiZn5pR
         VNFQr3niz1f5ZwdfYxDf4+O6AcMG3AkTVB/I1Wl+Z7SBdZuvCC8Nm7SDVzRAGIBjn8zc
         fa9eEIaxcv4pBsotHY+UBhBorhzEeFVoVMI8W1NRXghiPndTTuWlIAILe4oqjZeH9bxh
         lxPErYCXnhjnRfdZzmF1jr90Pc4XCtQIWaryZa989L3fAoaeG4NjHuFvjmsRCu2zD6pk
         /xsyhr7w7wE0xrr3E7bYjc+j4hQLPrSR+3i9HJ22XzyXprVIaPtMg4SseRSQvt0G6fX/
         pT5A==
X-Gm-Message-State: AAQBX9dDZ0HS58c0OaVQSltzr5c9UYMVQDRbImxyU02SxEZfksbs5nqm
        pA/VbV6QTYiNqAWIDcOYB+NNdltcBp8kC82l0kUrkw==
X-Google-Smtp-Source: AKy350bkX7bx+7wV4Fva0Z7X0uDXtqarhFCfwIfcEyA33wTpQYR6PoeBrmZYi7dxz/VpUcjY6T3snw==
X-Received: by 2002:a05:6a20:7d9a:b0:f2:4f56:be57 with SMTP id v26-20020a056a207d9a00b000f24f56be57mr17257623pzj.2.1682366047753;
        Mon, 24 Apr 2023 12:54:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t40-20020a056a0013a800b0063d29df1589sm7835889pfg.136.2023.04.24.12.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 12:54:07 -0700 (PDT)
Message-ID: <6446de5f.050a0220.5d8a2.f534@mx.google.com>
Date:   Mon, 24 Apr 2023 12:54:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-347-g579deb859f242
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 135 runs,
 10 regressions (v5.15.105-347-g579deb859f242)
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

stable-rc/linux-5.15.y baseline: 135 runs, 10 regressions (v5.15.105-347-g5=
79deb859f242)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.105-347-g579deb859f242/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.105-347-g579deb859f242
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      579deb859f242ad9458861ca39034d5dbd3b885b =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446accc9bdcf4afb12e8651

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446accc9bdcf4afb12e8656
        failing since 26 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-24T16:22:13.077316  <8>[   10.268617] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10106031_1.4.2.3.1>

    2023-04-24T16:22:13.080669  + set +x

    2023-04-24T16:22:13.188295  / # #

    2023-04-24T16:22:13.290472  export SHELL=3D/bin/sh

    2023-04-24T16:22:13.291203  #

    2023-04-24T16:22:13.392670  / # export SHELL=3D/bin/sh. /lava-10106031/=
environment

    2023-04-24T16:22:13.393408  =


    2023-04-24T16:22:13.494883  / # . /lava-10106031/environment/lava-10106=
031/bin/lava-test-runner /lava-10106031/1

    2023-04-24T16:22:13.496155  =


    2023-04-24T16:22:13.500842  / # /lava-10106031/bin/lava-test-runner /la=
va-10106031/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446ac577c80180c6e2e860d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446ac577c80180c6e2e8612
        failing since 26 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-24T16:20:29.984986  + <8>[   11.509214] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10106039_1.4.2.3.1>

    2023-04-24T16:20:29.985455  set +x

    2023-04-24T16:20:30.092562  / # #

    2023-04-24T16:20:30.194720  export SHELL=3D/bin/sh

    2023-04-24T16:20:30.195351  #

    2023-04-24T16:20:30.296708  / # export SHELL=3D/bin/sh. /lava-10106039/=
environment

    2023-04-24T16:20:30.297337  =


    2023-04-24T16:20:30.398830  / # . /lava-10106039/environment/lava-10106=
039/bin/lava-test-runner /lava-10106039/1

    2023-04-24T16:20:30.399847  =


    2023-04-24T16:20:30.404629  / # /lava-10106039/bin/lava-test-runner /la=
va-10106039/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446ac6462f8707f962e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446ac6462f8707f962e85ec
        failing since 26 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-24T16:20:29.047275  <8>[    7.828101] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10105985_1.4.2.3.1>

    2023-04-24T16:20:29.050881  + set +x

    2023-04-24T16:20:29.152468  =


    2023-04-24T16:20:29.252988  / # #export SHELL=3D/bin/sh

    2023-04-24T16:20:29.253168  =


    2023-04-24T16:20:29.353624  / # export SHELL=3D/bin/sh. /lava-10105985/=
environment

    2023-04-24T16:20:29.353808  =


    2023-04-24T16:20:29.454290  / # . /lava-10105985/environment/lava-10105=
985/bin/lava-test-runner /lava-10105985/1

    2023-04-24T16:20:29.454550  =


    2023-04-24T16:20:29.459160  / # /lava-10105985/bin/lava-test-runner /la=
va-10105985/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6446ae8063cb76a5432e8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6446ae8063cb76a5432e8=
641
        failing since 347 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6446aa13802386c10f2e864c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446aa13802386c10f2e8650
        failing since 97 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-04-24T16:10:27.398454  + set +x<8>[    9.954872] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3527633_1.5.2.4.1>
    2023-04-24T16:10:27.398658  =

    2023-04-24T16:10:27.505914  / # #
    2023-04-24T16:10:27.608295  export SHELL=3D/bin/sh
    2023-04-24T16:10:27.608701  #
    2023-04-24T16:10:27.709995  / # export SHELL=3D/bin/sh. /lava-3527633/e=
nvironment
    2023-04-24T16:10:27.711074  =

    2023-04-24T16:10:27.711493  / # <3>[   10.192706] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-24T16:10:27.813362  . /lava-3527633/environment/lava-3527633/bi=
n/lava-test-runner /lava-3527633/1
    2023-04-24T16:10:27.815130   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446ac4ca78c3fabb42e85f4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446ac4ca78c3fabb42e85f9
        failing since 26 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-24T16:20:19.808762  + set +x

    2023-04-24T16:20:19.815774  <8>[   10.755557] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10105961_1.4.2.3.1>

    2023-04-24T16:20:19.919540  / # #

    2023-04-24T16:20:20.020220  export SHELL=3D/bin/sh

    2023-04-24T16:20:20.020434  #

    2023-04-24T16:20:20.120964  / # export SHELL=3D/bin/sh. /lava-10105961/=
environment

    2023-04-24T16:20:20.121172  =


    2023-04-24T16:20:20.221717  / # . /lava-10105961/environment/lava-10105=
961/bin/lava-test-runner /lava-10105961/1

    2023-04-24T16:20:20.222082  =


    2023-04-24T16:20:20.227154  / # /lava-10105961/bin/lava-test-runner /la=
va-10105961/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446ac3c370e3fe2202e8618

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446ac3c370e3fe2202e861d
        failing since 26 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-24T16:19:56.397207  <8>[    8.165104] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10105932_1.4.2.3.1>

    2023-04-24T16:19:56.400637  + set +x

    2023-04-24T16:19:56.505318  / # #

    2023-04-24T16:19:56.606086  export SHELL=3D/bin/sh

    2023-04-24T16:19:56.606311  #

    2023-04-24T16:19:56.706805  / # export SHELL=3D/bin/sh. /lava-10105932/=
environment

    2023-04-24T16:19:56.707026  =


    2023-04-24T16:19:56.807550  / # . /lava-10105932/environment/lava-10105=
932/bin/lava-test-runner /lava-10105932/1

    2023-04-24T16:19:56.807899  =


    2023-04-24T16:19:56.812818  / # /lava-10105932/bin/lava-test-runner /la=
va-10105932/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446ac587c80180c6e2e8618

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446ac587c80180c6e2e861d
        failing since 26 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-24T16:20:17.274790  + set<8>[   11.595678] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10105983_1.4.2.3.1>

    2023-04-24T16:20:17.274877   +x

    2023-04-24T16:20:17.379183  / # #

    2023-04-24T16:20:17.479912  export SHELL=3D/bin/sh

    2023-04-24T16:20:17.480143  #

    2023-04-24T16:20:17.580647  / # export SHELL=3D/bin/sh. /lava-10105983/=
environment

    2023-04-24T16:20:17.580848  =


    2023-04-24T16:20:17.681375  / # . /lava-10105983/environment/lava-10105=
983/bin/lava-test-runner /lava-10105983/1

    2023-04-24T16:20:17.681719  =


    2023-04-24T16:20:17.685904  / # /lava-10105983/bin/lava-test-runner /la=
va-10105983/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6446a9a5d06f5852f12e8603

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446a9a5d06f5852f12e8608
        failing since 84 days (last pass: v5.15.81-122-gc5f8d4a5d3c8, first=
 fail: v5.15.90-205-g5605d15db022)

    2023-04-24T16:09:03.877733  + set +x
    2023-04-24T16:09:03.877908  [    9.418397] <LAVA_SIGNAL_ENDRUN 0_dmesg =
936039_1.5.2.3.1>
    2023-04-24T16:09:03.985696  / # #
    2023-04-24T16:09:04.087743  export SHELL=3D/bin/sh
    2023-04-24T16:09:04.088242  #
    2023-04-24T16:09:04.189643  / # export SHELL=3D/bin/sh. /lava-936039/en=
vironment
    2023-04-24T16:09:04.190208  =

    2023-04-24T16:09:04.291476  / # . /lava-936039/environment/lava-936039/=
bin/lava-test-runner /lava-936039/1
    2023-04-24T16:09:04.292044  =

    2023-04-24T16:09:04.294278  / # /lava-936039/bin/lava-test-runner /lava=
-936039/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446ac562f24eb44462e85ee

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-347-g579deb859f242/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446ac562f24eb44462e85f3
        failing since 26 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-24T16:20:15.469107  <8>[   11.394824] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10105999_1.4.2.3.1>

    2023-04-24T16:20:15.573749  / # #

    2023-04-24T16:20:15.674394  export SHELL=3D/bin/sh

    2023-04-24T16:20:15.674599  #

    2023-04-24T16:20:15.775108  / # export SHELL=3D/bin/sh. /lava-10105999/=
environment

    2023-04-24T16:20:15.775291  =


    2023-04-24T16:20:15.875786  / # . /lava-10105999/environment/lava-10105=
999/bin/lava-test-runner /lava-10105999/1

    2023-04-24T16:20:15.876060  =


    2023-04-24T16:20:15.880352  / # /lava-10105999/bin/lava-test-runner /la=
va-10105999/1

    2023-04-24T16:20:15.886095  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
