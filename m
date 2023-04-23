Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE786EC289
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 23:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjDWVwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 17:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDWVwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 17:52:22 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6206E67
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 14:52:19 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-51b661097bfso2979572a12.0
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 14:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682286739; x=1684878739;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vel6semo9UcmVBVkV60AOmNnxEjDz95K15oXcH2JASM=;
        b=2BEIWNNF8HWFM9Pv0Vw1U16QcDi81hn5OSD5dwuWEseqs1x+xPzCjQgcflwPsG7hv2
         mo4FanOo6/ylgFbUL2dX3XntDpaahYBbm0Ion7+UycVMI8MulXiF0ELNWiISbM28+Fi4
         wd9Q0kQMVBf4dmyN/bas1NBVCRuDRHr7neETYE2fuaN4hrA6bmUtZGtL+pIKq9zDDfWm
         hAIL6sGUyG3sLnneuZE+xXQAKXvtwHI9FyEyP9xhHZD8MtnIO4zaxlHq1i0zqynVUJh1
         y4Bg2xG9EpTdAnVGNPfHTzO6JhXxA3vayTn06GRCLjEWXc+GzlOHfgKLQwJa5GNJ20ax
         qafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682286739; x=1684878739;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vel6semo9UcmVBVkV60AOmNnxEjDz95K15oXcH2JASM=;
        b=CadZ9ey19maDnCuL/+tQD6BoYFSgibnr9KaRh4xHo7E0wRmCLRukQg8FKGa+oD9B/9
         NiSe6x0/nDTHneOyF2Fhczvye0nzM9c0kcLVa1kjD3g1zw7M9eLSwqyvspjbziqCjXE+
         hKuWc5yFxAVWBFaPil0oRT78qJtl+JGlYfage/twVB2B4JgLD8F1+maZKl00szWlUuZO
         ANV9hY1/xsqvtHkZKiBHTQUwkNQ/3ddYbUfyBs8pLbQSIDtAQsboAxx1u+JygDevaaO5
         n1RPdV0LreIdsHtCkpTcWkX/CwsqR7F9d8SEXc7YEEoXLumP9JbEHD/gB00KnNM47+Qh
         SsXA==
X-Gm-Message-State: AAQBX9c4ex2FMYbjrri6gKYAb9LI7j4BnuFVgnKSH7mtgk2P+CFXNfU1
        +/BpTNCHnPYRn7w8eLnLFta614xHL63wKl0y9M5/Zg==
X-Google-Smtp-Source: AKy350ZiVugGpibNlWLvx3WF9vWEOtC7s+PSO80uG+xEokgVTZht+p2RF+YN/Vv9DgO6Y85NOfZyrQ==
X-Received: by 2002:a05:6a00:1904:b0:63d:2911:3683 with SMTP id y4-20020a056a00190400b0063d29113683mr14739520pfi.17.1682286739120;
        Sun, 23 Apr 2023 14:52:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v1-20020a056a00148100b0062e0515f020sm6065130pfu.162.2023.04.23.14.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 14:52:18 -0700 (PDT)
Message-ID: <6445a892.050a0220.3840e.bc3a@mx.google.com>
Date:   Sun, 23 Apr 2023 14:52:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-357-g58672241ac982
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 97 runs,
 4 regressions (v5.10.176-357-g58672241ac982)
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

stable-rc/linux-5.10.y baseline: 97 runs, 4 regressions (v5.10.176-357-g586=
72241ac982)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.176-357-g58672241ac982/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.176-357-g58672241ac982
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      58672241ac982584a44e8f6bef4257f7fc7ad294 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644571410334989fe82e85ed

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-357-g58672241ac982/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-357-g58672241ac982/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644571410334989fe82e85f2
        failing since 95 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-04-23T17:55:48.166881  <8>[   10.954592] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3525158_1.5.2.4.1>
    2023-04-23T17:55:48.274870  / # #
    2023-04-23T17:55:48.376225  export SHELL=3D/bin/sh
    2023-04-23T17:55:48.376598  #
    2023-04-23T17:55:48.478007  / # export SHELL=3D/bin/sh. /lava-3525158/e=
nvironment
    2023-04-23T17:55:48.478895  =

    2023-04-23T17:55:48.580967  / # . /lava-3525158/environment/lava-352515=
8/bin/lava-test-runner /lava-3525158/1
    2023-04-23T17:55:48.582813  =

    2023-04-23T17:55:48.583289  / # <3>[   11.291387] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-23T17:55:48.589206  /lava-3525158/bin/lava-test-runner /lava-35=
25158/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644577cc66b8b53eea2e85fc

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-357-g58672241ac982/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-357-g58672241ac982/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644577cd66b8b53eea2e8601
        failing since 25 days (last pass: v5.10.176, first fail: v5.10.176-=
105-g18265b240021)

    2023-04-23T18:23:59.381842  + set +x

    2023-04-23T18:23:59.388405  <8>[   14.698971] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10095878_1.4.2.3.1>

    2023-04-23T18:23:59.496741  / # #

    2023-04-23T18:23:59.599682  export SHELL=3D/bin/sh

    2023-04-23T18:23:59.600522  #

    2023-04-23T18:23:59.702337  / # export SHELL=3D/bin/sh. /lava-10095878/=
environment

    2023-04-23T18:23:59.703147  =


    2023-04-23T18:23:59.805278  / # . /lava-10095878/environment/lava-10095=
878/bin/lava-test-runner /lava-10095878/1

    2023-04-23T18:23:59.806547  =


    2023-04-23T18:23:59.811264  / # /lava-10095878/bin/lava-test-runner /la=
va-10095878/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64457769873b60dd542e8621

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-357-g58672241ac982/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-357-g58672241ac982/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64457769873b60dd542e8626
        failing since 25 days (last pass: v5.10.176, first fail: v5.10.176-=
105-g18265b240021)

    2023-04-23T18:22:17.452510  <8>[   12.540902] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10095843_1.4.2.3.1>

    2023-04-23T18:22:17.455922  + set +x

    2023-04-23T18:22:17.561371  #

    2023-04-23T18:22:17.664527  / # #export SHELL=3D/bin/sh

    2023-04-23T18:22:17.665353  =


    2023-04-23T18:22:17.767289  / # export SHELL=3D/bin/sh. /lava-10095843/=
environment

    2023-04-23T18:22:17.768172  =


    2023-04-23T18:22:17.870185  / # . /lava-10095843/environment/lava-10095=
843/bin/lava-test-runner /lava-10095843/1

    2023-04-23T18:22:17.871476  =


    2023-04-23T18:22:17.877248  / # /lava-10095843/bin/lava-test-runner /la=
va-10095843/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6445726e78b9117e302e85eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-357-g58672241ac982/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-357-g58672241ac982/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6445726e78b9117e302e8=
5ec
        failing since 31 days (last pass: v5.10.175-100-g1686e1df6521, firs=
t fail: v5.10.176) =

 =20
