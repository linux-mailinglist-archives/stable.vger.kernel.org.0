Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202F4681A2D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 20:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbjA3TSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 14:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjA3TSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 14:18:23 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A481A4BD
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 11:18:22 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id e8-20020a17090a9a8800b0022c387f0f93so11513535pjp.3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 11:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=C9JLND/JYIiOZLtF8IFNGcql1CeirG1W0rq+MhIq8ug=;
        b=nZmGd0jtPvkcJbQXcmBNcQ70cuaks4cIlCFLK8hNpzIw/eIo78kupw+5fEcRGrbT4I
         cc0kjOpziq7wx8NlbYuyXqnBFlMELDKZtd2s/aW9l0GcDku49IbSD1+OyczWmpfJ1/IF
         vbnrLLppQKVsZCJIlixIc5WxO2W1DH2Thev2+lWcHpe3lU+X/U7LQ4O0XOSYUUQQAW9U
         5lWq5HhPxUts3jACVEW2Cbxv46+mAouQRlILaqIvIPS9Y3bz2lfANtVYHnW5+4oOxj7k
         KOxr4jWivI1ouw//DCv56j8cmEzFPBw4Z3Gl/9WTNyo3obOTCFj4usMyiKOvDhSaObmM
         93aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9JLND/JYIiOZLtF8IFNGcql1CeirG1W0rq+MhIq8ug=;
        b=SY6JmKWTFqafLwlb5WjvNEDPoc9Tl+rADvpgmmh9pW/+JUWI4J5A1wbLJ108QXTs0/
         6Z11i9E9cUmxnqvSbHaBL8+k7+K2i3wXUA29p4L6WZEPfot2gSGq85cTRHQFbP3RNOpZ
         uGKUd/LG9dT39SHEUeV620tPOJ/C042QvFtNe4OBHRSNMutImYaBqUhUXz5ZYWwl3KRF
         PyG1RAULGKUavVYYlXhJVFre5jRr/AI5lU2OGQ5quVi9ee0XmU3oUUSX2RPYTScIynaO
         wOPLMZDWt8m07jWdNHADSElrrLqnJTQXIafyL5mFDuLHQlruOl7DP4mSRqaxZpmgQzOv
         qcCA==
X-Gm-Message-State: AO0yUKUtOgB1D4WHtyP6zsMZRc6/mZ4owa6loGHDMtTjyHZyTTl6x2HI
        tQxA95UMvMCZpBTLhAQ1H4zSf/BFNxjXauG4bQQNUA==
X-Google-Smtp-Source: AK7set8ZEydTA6h1bAYng5sA0xXRUAkwmBZdUAjWp9eOs678/kIvh2Sjok91WV3a2lUB7HYlVF1s2w==
X-Received: by 2002:a17:903:1d1:b0:196:433e:236b with SMTP id e17-20020a17090301d100b00196433e236bmr21618126plh.54.1675106301272;
        Mon, 30 Jan 2023 11:18:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902ec8f00b001968b529c98sm1834292plg.128.2023.01.30.11.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 11:18:20 -0800 (PST)
Message-ID: <63d817fc.170a0220.61673.3701@mx.google.com>
Date:   Mon, 30 Jan 2023 11:18:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.165-144-g930bc29c79c4
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 175 runs,
 4 regressions (v5.10.165-144-g930bc29c79c4)
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

stable-rc/linux-5.10.y baseline: 175 runs, 4 regressions (v5.10.165-144-g93=
0bc29c79c4)

Regressions Summary
-------------------

platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =

r8a7743-iwg20d-q7      | arm   | lab-cip      | gcc-10   | shmobile_defconf=
ig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.165-144-g930bc29c79c4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.165-144-g930bc29c79c4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      930bc29c79c40d957f1ec23eba4fc9abec745eb5 =



Test Regressions
---------------- =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7e47d3044f3f2a9915ed8

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65-144-g930bc29c79c4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65-144-g930bc29c79c4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7e47d3044f3f2a9915edd
        failing since 12 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-01-30T15:38:23.109408  <8>[   11.040243] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3248210_1.5.2.4.1>
    2023-01-30T15:38:23.223195  / # #
    2023-01-30T15:38:23.327643  export SHELL=3D/bin/sh
    2023-01-30T15:38:23.328806  #
    2023-01-30T15:38:23.431551  / # export SHELL=3D/bin/sh. /lava-3248210/e=
nvironment
    2023-01-30T15:38:23.432724  =

    2023-01-30T15:38:23.535378  / # . /lava-3248210/environment/lava-324821=
0/bin/lava-test-runner /lava-3248210/1
    2023-01-30T15:38:23.537241  =

    2023-01-30T15:38:23.542316  / # /lava-3248210/bin/lava-test-runner /lav=
a-3248210/1
    2023-01-30T15:38:23.599296  <3>[   11.530942] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
r8a7743-iwg20d-q7      | arm   | lab-cip      | gcc-10   | shmobile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7e4a5f26a451b1b915ee2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65-144-g930bc29c79c4/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65-144-g930bc29c79c4/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d7e4a5f26a451b1b915=
ee3
        failing since 5 days (last pass: v5.10.162-951-g9096aabfe9e0, first=
 fail: v5.10.165) =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7e8930d5cc68b3b915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65-144-g930bc29c79c4/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a6=
4-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65-144-g930bc29c79c4/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a6=
4-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7e8930d5cc68b3b915ebe
        new failure (last pass: v5.10.158-107-g6b6a42c25ed4)

    2023-01-30T15:55:48.409103  + set +x
    2023-01-30T15:55:48.413204  <8>[   17.037715] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3248326_1.5.2.4.1>
    2023-01-30T15:55:48.533277  / # #
    2023-01-30T15:55:48.638823  export SHELL=3D/bin/sh
    2023-01-30T15:55:48.640368  #
    2023-01-30T15:55:48.743659  / # export SHELL=3D/bin/sh. /lava-3248326/e=
nvironment
    2023-01-30T15:55:48.745171  =

    2023-01-30T15:55:48.848601  / # . /lava-3248326/environment/lava-324832=
6/bin/lava-test-runner /lava-3248326/1
    2023-01-30T15:55:48.851314  =

    2023-01-30T15:55:48.854538  / # /lava-3248326/bin/lava-test-runner /lav=
a-3248326/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7e78b6f85fbf9d5915ef8

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65-144-g930bc29c79c4/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64=
-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65-144-g930bc29c79c4/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64=
-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7e78b6f85fbf9d5915efd
        new failure (last pass: v5.10.158-107-g6b6a42c25ed4)

    2023-01-30T15:51:25.102353  + set +x
    2023-01-30T15:51:25.106623  <8>[   17.199905] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 214541_1.5.2.4.1>
    2023-01-30T15:51:25.219168  / # #
    2023-01-30T15:51:25.322117  export SHELL=3D/bin/sh
    2023-01-30T15:51:25.322834  #
    2023-01-30T15:51:25.425109  / # export SHELL=3D/bin/sh. /lava-214541/en=
vironment
    2023-01-30T15:51:25.425831  =

    2023-01-30T15:51:25.528001  / # . /lava-214541/environment/lava-214541/=
bin/lava-test-runner /lava-214541/1
    2023-01-30T15:51:25.529558  =

    2023-01-30T15:51:25.533629  / # /lava-214541/bin/lava-test-runner /lava=
-214541/1 =

    ... (12 line(s) more)  =

 =20
