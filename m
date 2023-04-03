Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445606D3D94
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 08:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjDCGv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 02:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDCGvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 02:51:25 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F6D30D1
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 23:51:23 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so31485357pjp.1
        for <stable@vger.kernel.org>; Sun, 02 Apr 2023 23:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680504683;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nHANDBQq7EJ1DZdA+AmMV5Sf/onWAXD8rz/nb9HIuhk=;
        b=x2+QAKw0itLR1f/LoKYbptccI4Lp8V4WoaRDh2ArtNStxAQ9U68QCsyvLmkxFTewP1
         Ns9gmsoeqTCyF8dLRbOKPpFSyRVjppd5QwrEqH0dG2joaY6d1IMxzihLauxMp5do9skw
         dx+O7KeQyVifApnx+E4gWI3zV4Kn1JG/EBfb0UfbzWvWZF1eQdqS0RFdn2DqoOjsrB2Q
         m0/4/ugtPf2xq8H2Q5TJTP1P/b0ZIJfv3+N6fI70LyoimINexBXc3Zmlzx0lUBv8/CGR
         1aJ+w02Qt2f1bLAZgdWerMkwdLe8lYuaQFq5GULIqxe+reND+R3rLjQny5jBMSYtZb/n
         peDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680504683;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nHANDBQq7EJ1DZdA+AmMV5Sf/onWAXD8rz/nb9HIuhk=;
        b=Ra73FwyaAmAcWXf9Zg8XLqryIoZnQVWdd57H2f7LIrArnPazsirNz34zMq9jO6qWgD
         BIl5oMla4oNWYEARoNEnbnwiaZtns5KS3VToqRqV1DGoAuRoB4OwMIDJOXGyYUXIwxsu
         4rimYnA4CCF6mC+IeEsDhdwCnAsSIQXh8/ml9rpi+fbQImBAW40iVUFwbYx2rsTrG/js
         4AaAhQxOPoGZOTlOOTMyQORUrrJgaef5WoIWRa3EnAO8jsTiijIwyf4weSvN0BDE/Dzo
         h4Eaaj16BHYe44IGLu7JTlWpG1KbRSV3/JxkpDzGLOaLJ5yjiwiJ85a7iNryCTNmO6IU
         hDxg==
X-Gm-Message-State: AAQBX9fWFDg+DWiUvAzaBIBXdPvrKSU9MJx0P+ICckMwhxJWM6iit2ng
        DcnHeXn37VwV5QQbLcgqc91Ot04T34Cx2fMiMEQ=
X-Google-Smtp-Source: AKy350ZdGJwZGjmGN4dEz8auDwddYvi9v07/04iSymleuX8OHp/dgnkZBblxWPaG3hWVtZZIcJBjiQ==
X-Received: by 2002:a17:90a:e7d0:b0:237:461c:b31a with SMTP id kb16-20020a17090ae7d000b00237461cb31amr38174729pjb.32.1680504682620;
        Sun, 02 Apr 2023 23:51:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bv7-20020a17090af18700b0023fa2773aa5sm5522556pjb.26.2023.04.02.23.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 23:51:22 -0700 (PDT)
Message-ID: <642a776a.170a0220.50fa7.a3b9@mx.google.com>
Date:   Sun, 02 Apr 2023 23:51:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105-64-gbf7736e5615d
Subject: stable-rc/queue/5.15 baseline: 176 runs,
 9 regressions (v5.15.105-64-gbf7736e5615d)
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

stable-rc/queue/5.15 baseline: 176 runs, 9 regressions (v5.15.105-64-gbf773=
6e5615d)

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

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-64-gbf7736e5615d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-64-gbf7736e5615d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf7736e5615d72faeafea72067d89dd9eca5086f =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642a41c27dc980f1a062f7ac

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a41c27dc980f1a062f7b1
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T03:02:06.341370  <8>[   10.502603] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9846182_1.4.2.3.1>

    2023-04-03T03:02:06.345033  + set +x

    2023-04-03T03:02:06.453284  / # #

    2023-04-03T03:02:06.555773  export SHELL=3D/bin/sh

    2023-04-03T03:02:06.556627  #

    2023-04-03T03:02:06.658767  / # export SHELL=3D/bin/sh. /lava-9846182/e=
nvironment

    2023-04-03T03:02:06.659577  =


    2023-04-03T03:02:06.761520  / # . /lava-9846182/environment/lava-984618=
2/bin/lava-test-runner /lava-9846182/1

    2023-04-03T03:02:06.761807  =


    2023-04-03T03:02:06.767246  / # /lava-9846182/bin/lava-test-runner /lav=
a-9846182/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642a41b7347033470162f76b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a41b7347033470162f770
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T03:01:52.320080  + set +x<8>[   11.045115] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9846196_1.4.2.3.1>

    2023-04-03T03:01:52.320180  =


    2023-04-03T03:01:52.424890  / # #

    2023-04-03T03:01:52.525964  export SHELL=3D/bin/sh

    2023-04-03T03:01:52.526226  #

    2023-04-03T03:01:52.627202  / # export SHELL=3D/bin/sh. /lava-9846196/e=
nvironment

    2023-04-03T03:01:52.627537  =


    2023-04-03T03:01:52.728605  / # . /lava-9846196/environment/lava-984619=
6/bin/lava-test-runner /lava-9846196/1

    2023-04-03T03:01:52.728952  =


    2023-04-03T03:01:52.733815  / # /lava-9846196/bin/lava-test-runner /lav=
a-9846196/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642a41a3fd8239904862f776

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a41a3fd8239904862f77b
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T03:01:49.539642  <8>[    8.013797] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9846205_1.4.2.3.1>

    2023-04-03T03:01:49.542959  + set +x

    2023-04-03T03:01:49.644554  #

    2023-04-03T03:01:49.644835  =


    2023-04-03T03:01:49.745776  / # #export SHELL=3D/bin/sh

    2023-04-03T03:01:49.745981  =


    2023-04-03T03:01:49.846872  / # export SHELL=3D/bin/sh. /lava-9846205/e=
nvironment

    2023-04-03T03:01:49.847087  =


    2023-04-03T03:01:49.947987  / # . /lava-9846205/environment/lava-984620=
5/bin/lava-test-runner /lava-9846205/1

    2023-04-03T03:01:49.948314  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642a44c343406b17a962f778

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642a44c343406b17a962f=
779
        failing since 58 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642a44ee4c9fef0fd662f810

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a44ee4c9fef0fd662f815
        failing since 75 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-03T03:15:40.865566  <8>[    9.970167] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3466315_1.5.2.4.1>
    2023-04-03T03:15:40.973109  / # #
    2023-04-03T03:15:41.075101  export SHELL=3D/bin/sh
    2023-04-03T03:15:41.076056  #
    2023-04-03T03:15:41.177914  / # export SHELL=3D/bin/sh. /lava-3466315/e=
nvironment
    2023-04-03T03:15:41.178510  =

    2023-04-03T03:15:41.178784  <3>[   10.193231] Bluetooth: hci0: command =
0xfc18 tx timeout
    2023-04-03T03:15:41.280106  / # . /lava-3466315/environment/lava-346631=
5/bin/lava-test-runner /lava-3466315/1
    2023-04-03T03:15:41.280653  =

    2023-04-03T03:15:41.285669  / # /lava-3466315/bin/lava-test-runner /lav=
a-3466315/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642a423a98bad700a662f77f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a423a98bad700a662f784
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T03:04:10.213957  + <8>[   10.615709] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9846215_1.4.2.3.1>

    2023-04-03T03:04:10.214042  set +x

    2023-04-03T03:04:10.315785  #

    2023-04-03T03:04:10.316064  =


    2023-04-03T03:04:10.417115  / # #export SHELL=3D/bin/sh

    2023-04-03T03:04:10.417329  =


    2023-04-03T03:04:10.518206  / # export SHELL=3D/bin/sh. /lava-9846215/e=
nvironment

    2023-04-03T03:04:10.518396  =


    2023-04-03T03:04:10.619266  / # . /lava-9846215/environment/lava-984621=
5/bin/lava-test-runner /lava-9846215/1

    2023-04-03T03:04:10.619509  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642a41f703926da7b262f7f3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a41f703926da7b262f7f8
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T03:02:58.046883  + set +x

    2023-04-03T03:02:58.053569  <8>[   10.628159] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9846191_1.4.2.3.1>

    2023-04-03T03:02:58.155928  =


    2023-04-03T03:02:58.256941  / # #export SHELL=3D/bin/sh

    2023-04-03T03:02:58.257144  =


    2023-04-03T03:02:58.358068  / # export SHELL=3D/bin/sh. /lava-9846191/e=
nvironment

    2023-04-03T03:02:58.358286  =


    2023-04-03T03:02:58.459213  / # . /lava-9846191/environment/lava-984619=
1/bin/lava-test-runner /lava-9846191/1

    2023-04-03T03:02:58.459565  =


    2023-04-03T03:02:58.464284  / # /lava-9846191/bin/lava-test-runner /lav=
a-9846191/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642a41c47dc980f1a062f7b7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a41c47dc980f1a062f7bc
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T03:02:10.333334  + set<8>[   11.408029] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9846164_1.4.2.3.1>

    2023-04-03T03:02:10.333444   +x

    2023-04-03T03:02:10.438389  / # #

    2023-04-03T03:02:10.539232  export SHELL=3D/bin/sh

    2023-04-03T03:02:10.539467  #

    2023-04-03T03:02:10.640442  / # export SHELL=3D/bin/sh. /lava-9846164/e=
nvironment

    2023-04-03T03:02:10.640697  =


    2023-04-03T03:02:10.741532  / # . /lava-9846164/environment/lava-984616=
4/bin/lava-test-runner /lava-9846164/1

    2023-04-03T03:02:10.741870  =


    2023-04-03T03:02:10.746525  / # /lava-9846164/bin/lava-test-runner /lav=
a-9846164/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642a41b07dc980f1a062f783

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-64-gbf7736e5615d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a41b07dc980f1a062f788
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-03T03:01:53.585800  + set +x<8>[   12.319381] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9846208_1.4.2.3.1>

    2023-04-03T03:01:53.585881  =


    2023-04-03T03:01:53.690619  / # #

    2023-04-03T03:01:53.791535  export SHELL=3D/bin/sh

    2023-04-03T03:01:53.791747  #

    2023-04-03T03:01:53.892683  / # export SHELL=3D/bin/sh. /lava-9846208/e=
nvironment

    2023-04-03T03:01:53.892871  =


    2023-04-03T03:01:53.993777  / # . /lava-9846208/environment/lava-984620=
8/bin/lava-test-runner /lava-9846208/1

    2023-04-03T03:01:53.994138  =


    2023-04-03T03:01:53.998553  / # /lava-9846208/bin/lava-test-runner /lav=
a-9846208/1
 =

    ... (12 line(s) more)  =

 =20
