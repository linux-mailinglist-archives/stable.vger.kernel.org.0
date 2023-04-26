Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6166EF983
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 19:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbjDZRhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 13:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbjDZRhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 13:37:41 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C39B7
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 10:37:39 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63d4595d60fso51139b3a.0
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 10:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682530658; x=1685122658;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1P0XhMC4tzGEk29Hc72HyI8OwNuIIn/mnACCg5OUnag=;
        b=mvHhfEibqj5oQYQIRSMdIiPxsWHXV2suDu+IhPYqRJwOHgLbz94YD5QtC2IfaY8t4X
         ddurfEl/QjLhWHf7olZp+B8zCfmP2w2PUasx0Ihrxxn+DKwFMQIv0hg8OlPZwShSJdpi
         3ciOhFu6kbcBDf9tch6PUUgB4YzeUGmJ2Q3Kwn52Y1sIBji3gf1Yd59o4O1R8qTIijGG
         2kSElhT7YBIBHwp75D1ivpacxu64FWsIZlQ9Swbc7p4/0cLquwaT+aRVG8fcDtZ5TmLz
         Tp7bj7AhtwR+au0J5GaQfuOPDcqu+M93s+P7xeGd6G+ls7NHvIcllk9gyTDUJBj1FIMB
         xx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682530658; x=1685122658;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1P0XhMC4tzGEk29Hc72HyI8OwNuIIn/mnACCg5OUnag=;
        b=GElcDENB5rHgiHb0bkKu+Z+d9L7uYWESE1rAUsjFtF2japfbybVmkmVllZF4UAv9ok
         rNPRU+llik/+PKB6vOQO2Ix9wqGbIt5vd10d7gDCYBNcKjmY26atj54rvV2OzNOmxPYH
         27YoS5V8X/qM/GxDRTfY0lYHOAsqHtPpjNlLleK+quqh1Y915H2TNtqN+q8pnvJrxlFJ
         jfDuFp4PNjxSlsTlh3YoTAKKavUpWD7+gC7WCHEPmslqxO5d/IQuwDlKN9ZYD+l4HENW
         Hux5xESd2AGl3iYGi5MT3nztoaiWBwzSpEsJvtMqYNkTpg0EqnSfpngekZ/PDOjNbf0Y
         jLRw==
X-Gm-Message-State: AC+VfDzWMVkbFndNPMm55lCOcVcFyeEmhjnVbxT5nrYPcLOuS3MpBMu3
        r2Q2uNGzoKCD/Ga5/JjcwbBheTt3Ub1gkvaIdOQwWg==
X-Google-Smtp-Source: ACHHUZ68cnhvKKH5Wf1HaKAJDoPJUglJByzKscRtHvCJxV5t1HNsYTRsFrND/fmwYcmRooIJo3A+YA==
X-Received: by 2002:a05:6a20:914e:b0:ef:8de0:6a5 with SMTP id x14-20020a056a20914e00b000ef8de006a5mr4290554pzc.3.1682530658058;
        Wed, 26 Apr 2023 10:37:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l21-20020a63ea55000000b005287a0560c9sm2219850pgk.1.2023.04.26.10.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 10:37:37 -0700 (PDT)
Message-ID: <64496161.630a0220.d706b.5159@mx.google.com>
Date:   Wed, 26 Apr 2023 10:37:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.109
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 125 runs, 9 regressions (v5.15.109)
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

stable/linux-5.15.y baseline: 125 runs, 9 regressions (v5.15.109)

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

mt8173-elm-hana              | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm...ok+kselftest | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.109/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.109
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f48aeeaaa64c628519273f6007a745cf55b68d95 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64492bfb8664ddbd672e85f1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64492bfb8664ddbd672e85f6
        failing since 27 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-26T13:49:24.096778  <8>[   11.370975] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10131526_1.4.2.3.1>

    2023-04-26T13:49:24.099962  + set +x

    2023-04-26T13:49:24.207436  =


    2023-04-26T13:49:24.309983  / # #export SHELL=3D/bin/sh

    2023-04-26T13:49:24.310506  =


    2023-04-26T13:49:24.411469  / # export SHELL=3D/bin/sh. /lava-10131526/=
environment

    2023-04-26T13:49:24.411928  =


    2023-04-26T13:49:24.512890  / # . /lava-10131526/environment/lava-10131=
526/bin/lava-test-runner /lava-10131526/1

    2023-04-26T13:49:24.513170  =


    2023-04-26T13:49:24.519623  / # /lava-10131526/bin/lava-test-runner /la=
va-10131526/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64492bad7dbe18de372e85ef

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64492bae7dbe18de372e85f4
        failing since 27 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-26T13:48:15.330817  + <8>[   10.959167] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10131472_1.4.2.3.1>

    2023-04-26T13:48:15.331393  set +x

    2023-04-26T13:48:15.439513  / # #

    2023-04-26T13:48:15.542191  export SHELL=3D/bin/sh

    2023-04-26T13:48:15.542983  #

    2023-04-26T13:48:15.644771  / # export SHELL=3D/bin/sh. /lava-10131472/=
environment

    2023-04-26T13:48:15.645563  =


    2023-04-26T13:48:15.747446  / # . /lava-10131472/environment/lava-10131=
472/bin/lava-test-runner /lava-10131472/1

    2023-04-26T13:48:15.748841  =


    2023-04-26T13:48:15.753482  / # /lava-10131472/bin/lava-test-runner /la=
va-10131472/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64492bb9e51d7a0a872e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64492bb9e51d7a0a872e85eb
        failing since 27 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-26T13:48:23.707316  <8>[   10.506288] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10131478_1.4.2.3.1>

    2023-04-26T13:48:23.710583  + set +x

    2023-04-26T13:48:23.815838  #

    2023-04-26T13:48:23.817125  =


    2023-04-26T13:48:23.919039  / # #export SHELL=3D/bin/sh

    2023-04-26T13:48:23.919899  =


    2023-04-26T13:48:24.021475  / # export SHELL=3D/bin/sh. /lava-10131478/=
environment

    2023-04-26T13:48:24.022210  =


    2023-04-26T13:48:24.123741  / # . /lava-10131478/environment/lava-10131=
478/bin/lava-test-runner /lava-10131478/1

    2023-04-26T13:48:24.125014  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64492b99e8ffc89ec22e8735

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64492b99e8ffc89ec22e873a
        failing since 27 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-26T13:47:54.602050  + <8>[   10.363455] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10131479_1.4.2.3.1>

    2023-04-26T13:47:54.602159  set +x

    2023-04-26T13:47:54.703699  #

    2023-04-26T13:47:54.703945  =


    2023-04-26T13:47:54.804549  / # #export SHELL=3D/bin/sh

    2023-04-26T13:47:54.804724  =


    2023-04-26T13:47:54.905217  / # export SHELL=3D/bin/sh. /lava-10131479/=
environment

    2023-04-26T13:47:54.905397  =


    2023-04-26T13:47:55.005975  / # . /lava-10131479/environment/lava-10131=
479/bin/lava-test-runner /lava-10131479/1

    2023-04-26T13:47:55.006224  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64492bbabbf298e0a42e8654

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64492bbabbf298e0a42e8659
        failing since 27 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-26T13:48:21.292891  + set +x

    2023-04-26T13:48:21.299650  <8>[   10.956581] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10131516_1.4.2.3.1>

    2023-04-26T13:48:21.406836  / # #

    2023-04-26T13:48:21.509285  export SHELL=3D/bin/sh

    2023-04-26T13:48:21.510053  #

    2023-04-26T13:48:21.611525  / # export SHELL=3D/bin/sh. /lava-10131516/=
environment

    2023-04-26T13:48:21.612382  =


    2023-04-26T13:48:21.714117  / # . /lava-10131516/environment/lava-10131=
516/bin/lava-test-runner /lava-10131516/1

    2023-04-26T13:48:21.715364  =


    2023-04-26T13:48:21.720953  / # /lava-10131516/bin/lava-test-runner /la=
va-10131516/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64492bb17dbe18de372e861c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64492bb17dbe18de372e8621
        failing since 27 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-26T13:48:22.806245  + set<8>[   10.931100] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10131532_1.4.2.3.1>

    2023-04-26T13:48:22.806854   +x

    2023-04-26T13:48:22.917455  / # #

    2023-04-26T13:48:23.019641  export SHELL=3D/bin/sh

    2023-04-26T13:48:23.020335  #

    2023-04-26T13:48:23.121685  / # export SHELL=3D/bin/sh. /lava-10131532/=
environment

    2023-04-26T13:48:23.122591  =


    2023-04-26T13:48:23.224259  / # . /lava-10131532/environment/lava-10131=
532/bin/lava-test-runner /lava-10131532/1

    2023-04-26T13:48:23.224601  =


    2023-04-26T13:48:23.230185  / # /lava-10131532/bin/lava-test-runner /la=
va-10131532/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64492c357a8f8c94242e85ff

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64492c357a8f8c94242e8604
        failing since 84 days (last pass: v5.15.81, first fail: v5.15.91)

    2023-04-26T13:50:35.224720  + set +x
    2023-04-26T13:50:35.224947  [    9.366518] <LAVA_SIGNAL_ENDRUN 0_dmesg =
938386_1.5.2.3.1>
    2023-04-26T13:50:35.332939  / # #
    2023-04-26T13:50:35.434868  export SHELL=3D/bin/sh
    2023-04-26T13:50:35.436112  #
    2023-04-26T13:50:35.537504  / # export SHELL=3D/bin/sh. /lava-938386/en=
vironment
    2023-04-26T13:50:35.538007  =

    2023-04-26T13:50:35.639491  / # . /lava-938386/environment/lava-938386/=
bin/lava-test-runner /lava-938386/1
    2023-04-26T13:50:35.640348  =

    2023-04-26T13:50:35.643123  / # /lava-938386/bin/lava-test-runner /lava=
-938386/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64492b9730605d49662e8615

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64492b9730605d49662e861a
        failing since 27 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-26T13:47:52.081288  + set<8>[   11.918617] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10131503_1.4.2.3.1>

    2023-04-26T13:47:52.081390   +x

    2023-04-26T13:47:52.185536  / # #

    2023-04-26T13:47:52.286155  export SHELL=3D/bin/sh

    2023-04-26T13:47:52.286352  #

    2023-04-26T13:47:52.386851  / # export SHELL=3D/bin/sh. /lava-10131503/=
environment

    2023-04-26T13:47:52.387067  =


    2023-04-26T13:47:52.487576  / # . /lava-10131503/environment/lava-10131=
503/bin/lava-test-runner /lava-10131503/1

    2023-04-26T13:47:52.487870  =


    2023-04-26T13:47:52.493043  / # /lava-10131503/bin/lava-test-runner /la=
va-10131503/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
mt8173-elm-hana              | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64492727664b41e7002e8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
arm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt=
8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.109/=
arm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt=
8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64492727664b41e7002e8=
649
        failing since 92 days (last pass: v5.15.89, first fail: v5.15.90) =

 =20
