Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5426EE641
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 19:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbjDYRCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 13:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbjDYRCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 13:02:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F093CC
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 10:02:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-24756a12ba0so4201966a91.1
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 10:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682442119; x=1685034119;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=608f5hnNDyFoxF93/oP6WsIsQtndqLdNqzDRljdvIV4=;
        b=mCQx089TKc1ZlgO3oGcJSpL/p7rgnU9TH4dGwG/+3y0mBfG2s1q1vVirQyDxKWCelh
         eS5pENxhICRC7tGV6nHxLDzhDR6ngS9+tyWodPjfCMqqoabuEVzKBX8iqc2fofy/y6XD
         bwkW/KrQUiaTvaPJekdmjEHPJ/0MMv8wY5dk9+7ho+NUXl7gfeeH7mCgEiurZnc+R6HZ
         EhFsCzVpiwovl9BvHhyG5lPzdQAaYX0VvPNR2+I6Aj36HjG0PIGFtDUJcbPxBhni1jDk
         OBGaQBgAppR6qZbLXRP8nbQ/xyLOZ2nsg068MAlZJBaN9DABPJDvMASqZrcPA4Y/YDeM
         aPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682442119; x=1685034119;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=608f5hnNDyFoxF93/oP6WsIsQtndqLdNqzDRljdvIV4=;
        b=FMzq8JU4fCNriSvo7xW6A5sZgoKSJ+BMemW9v8l0zOY2d+/h/6ddIq+NSeqenkDofZ
         O/C04ArfOAIGKeCBg6kMLhHEPqRWIUvQ9A3XDcvs292Qfcidn9xFpY3oVbz4b0r02cDs
         UGVsdnIrj8vBUeLBMYMqLYmclRSA99/p9O33S6dy5PK0hJSR5USww61Pj6U63Ub4HkqL
         hdzzy1HcOteOgOE5hTjwkmpvhthvscpz7AbFoEEUoI84AdqK8Br6wj4dcNm4Dhn/2Ewq
         cwA70QuIJiu3k/PXvy6bS6tcGaSgFwQ6B4NXRddtxg09wg7vfBQsvaguid4l+5aMSVul
         OGJQ==
X-Gm-Message-State: AAQBX9cJmRU3gZpxF6w1BqLepN4Ye5ud40vbo0zpxLTALg8iuHvJxNOE
        LJdVvVF8uOC20LZON2hg7++/rAcJhKPI67cHnyM3UduU
X-Google-Smtp-Source: AKy350Z5gOTZvhy5zPSoCG3tBETsxSMBxweZO6H2fOLI2sO8jpNuyVFnu0EVX6+xfZC4YoRYELtapA==
X-Received: by 2002:a17:90a:fb95:b0:248:839e:551 with SMTP id cp21-20020a17090afb9500b00248839e0551mr17285739pjb.35.1682442119212;
        Tue, 25 Apr 2023 10:01:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y14-20020a17090a2b4e00b002466f45788esm8087911pjc.46.2023.04.25.10.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 10:01:58 -0700 (PDT)
Message-ID: <64480786.170a0220.32eaa.0141@mx.google.com>
Date:   Tue, 25 Apr 2023 10:01:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-346-gc8982b58a2ae
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 95 runs,
 8 regressions (v5.15.105-346-gc8982b58a2ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 95 runs, 8 regressions (v5.15.105-346-gc8982=
b58a2ae)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-346-gc8982b58a2ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-346-gc8982b58a2ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8982b58a2aec8fae13e507792fc4f8aac9930a8 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447cec111241deae62e8614

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447cec111241deae62e8619
        failing since 28 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-25T12:59:25.532804  + set +x

    2023-04-25T12:59:25.539322  <8>[   11.077194] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10117317_1.4.2.3.1>

    2023-04-25T12:59:25.643883  / # #

    2023-04-25T12:59:25.744500  export SHELL=3D/bin/sh

    2023-04-25T12:59:25.744712  #

    2023-04-25T12:59:25.845226  / # export SHELL=3D/bin/sh. /lava-10117317/=
environment

    2023-04-25T12:59:25.845436  =


    2023-04-25T12:59:25.945961  / # . /lava-10117317/environment/lava-10117=
317/bin/lava-test-runner /lava-10117317/1

    2023-04-25T12:59:25.946252  =


    2023-04-25T12:59:25.951403  / # /lava-10117317/bin/lava-test-runner /la=
va-10117317/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447cebad8f5a819e22e8608

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447cebad8f5a819e22e860d
        failing since 28 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-25T12:59:15.374289  + <8>[    8.858927] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10117315_1.4.2.3.1>

    2023-04-25T12:59:15.374719  set +x

    2023-04-25T12:59:15.481671  / # #

    2023-04-25T12:59:15.583693  export SHELL=3D/bin/sh

    2023-04-25T12:59:15.584460  #

    2023-04-25T12:59:15.685803  / # export SHELL=3D/bin/sh. /lava-10117315/=
environment

    2023-04-25T12:59:15.686516  =


    2023-04-25T12:59:15.787916  / # . /lava-10117315/environment/lava-10117=
315/bin/lava-test-runner /lava-10117315/1

    2023-04-25T12:59:15.789155  =


    2023-04-25T12:59:15.794013  / # /lava-10117315/bin/lava-test-runner /la=
va-10117315/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447cecfa96fd330c22e85fd

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447cecfa96fd330c22e8602
        failing since 28 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-25T12:59:33.440823  <8>[   10.460634] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10117378_1.4.2.3.1>

    2023-04-25T12:59:33.444252  + set +x

    2023-04-25T12:59:33.550490  =


    2023-04-25T12:59:33.652267  / # #export SHELL=3D/bin/sh

    2023-04-25T12:59:33.653041  =


    2023-04-25T12:59:33.754477  / # export SHELL=3D/bin/sh. /lava-10117378/=
environment

    2023-04-25T12:59:33.755272  =


    2023-04-25T12:59:33.857068  / # . /lava-10117378/environment/lava-10117=
378/bin/lava-test-runner /lava-10117378/1

    2023-04-25T12:59:33.858472  =


    2023-04-25T12:59:33.863994  / # /lava-10117378/bin/lava-test-runner /la=
va-10117378/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447cef6263942719c2e864d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447cef6263942719c2e8652
        failing since 28 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-25T13:00:20.633042  + set +x

    2023-04-25T13:00:20.639648  <8>[   10.505684] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10117303_1.4.2.3.1>

    2023-04-25T13:00:20.747216  / # #

    2023-04-25T13:00:20.849457  export SHELL=3D/bin/sh

    2023-04-25T13:00:20.850223  #

    2023-04-25T13:00:20.951657  / # export SHELL=3D/bin/sh. /lava-10117303/=
environment

    2023-04-25T13:00:20.952387  =


    2023-04-25T13:00:21.053819  / # . /lava-10117303/environment/lava-10117=
303/bin/lava-test-runner /lava-10117303/1

    2023-04-25T13:00:21.055066  =


    2023-04-25T13:00:21.059857  / # /lava-10117303/bin/lava-test-runner /la=
va-10117303/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447ceaf4708bc00782e8645

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447ceaf4708bc00782e864a
        failing since 28 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-25T12:59:11.776196  <8>[   10.253507] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10117323_1.4.2.3.1>

    2023-04-25T12:59:11.779250  + set +x

    2023-04-25T12:59:11.880723  #

    2023-04-25T12:59:11.880980  =


    2023-04-25T12:59:11.981577  / # #export SHELL=3D/bin/sh

    2023-04-25T12:59:11.981781  =


    2023-04-25T12:59:12.082319  / # export SHELL=3D/bin/sh. /lava-10117323/=
environment

    2023-04-25T12:59:12.082559  =


    2023-04-25T12:59:12.183075  / # . /lava-10117323/environment/lava-10117=
323/bin/lava-test-runner /lava-10117323/1

    2023-04-25T12:59:12.183348  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447ceb9512a852fd62e8671

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447ceb9512a852fd62e8676
        failing since 28 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-25T12:59:11.700578  + set<8>[    8.573261] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10117311_1.4.2.3.1>

    2023-04-25T12:59:11.700677   +x

    2023-04-25T12:59:11.804832  / # #

    2023-04-25T12:59:11.905510  export SHELL=3D/bin/sh

    2023-04-25T12:59:11.905728  #

    2023-04-25T12:59:12.006232  / # export SHELL=3D/bin/sh. /lava-10117311/=
environment

    2023-04-25T12:59:12.006442  =


    2023-04-25T12:59:12.107035  / # . /lava-10117311/environment/lava-10117=
311/bin/lava-test-runner /lava-10117311/1

    2023-04-25T12:59:12.107422  =


    2023-04-25T12:59:12.112495  / # /lava-10117311/bin/lava-test-runner /la=
va-10117311/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6447cedf871fd39a0d2e85ec

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447cedf871fd39a0d2e85f1
        failing since 88 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-25T13:00:07.796744  + set +x
    2023-04-25T13:00:07.796972  [    9.362954] <LAVA_SIGNAL_ENDRUN 0_dmesg =
936945_1.5.2.3.1>
    2023-04-25T13:00:07.904711  / # #
    2023-04-25T13:00:08.006404  export SHELL=3D/bin/sh
    2023-04-25T13:00:08.006855  #
    2023-04-25T13:00:08.108279  / # export SHELL=3D/bin/sh. /lava-936945/en=
vironment
    2023-04-25T13:00:08.108724  =

    2023-04-25T13:00:08.210079  / # . /lava-936945/environment/lava-936945/=
bin/lava-test-runner /lava-936945/1
    2023-04-25T13:00:08.210676  =

    2023-04-25T13:00:08.213210  / # /lava-936945/bin/lava-test-runner /lava=
-936945/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447cec211241deae62e8636

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gc8982b58a2ae/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447cec211241deae62e863b
        failing since 28 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-25T12:59:22.600698  <8>[   11.158758] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10117329_1.4.2.3.1>

    2023-04-25T12:59:22.705261  / # #

    2023-04-25T12:59:22.805998  export SHELL=3D/bin/sh

    2023-04-25T12:59:22.806251  #

    2023-04-25T12:59:22.906847  / # export SHELL=3D/bin/sh. /lava-10117329/=
environment

    2023-04-25T12:59:22.907065  =


    2023-04-25T12:59:23.007687  / # . /lava-10117329/environment/lava-10117=
329/bin/lava-test-runner /lava-10117329/1

    2023-04-25T12:59:23.007977  =


    2023-04-25T12:59:23.013306  / # /lava-10117329/bin/lava-test-runner /la=
va-10117329/1

    2023-04-25T12:59:23.018476  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
