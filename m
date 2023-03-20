Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004496C226E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 21:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCTUUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 16:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjCTUUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 16:20:44 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBC86582
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:20:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so17868382pjt.2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679343642;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yTf7FAR2tU1EoBqS2XcH1CvlzxJgSOHwOzVShU56VwM=;
        b=ZBwTvCHqgugIZRvtmGH8LfFMHL4ycj0n4Z2LjOpZpXWOxkoteRBk0HyFTFGMwISYjU
         gTpL2hEpzLK2BhGFyHLwY63/HQHlx7CmtwdorbAGy11T7ZQPE8yi622O3mPUkC7DEAS8
         7g3MHuL+i/4HHZHwaYqb4tcXrewmiHjuYehmfhTdq5ucpe5qoVKcXWyPJtC7xX5c8c0F
         VIN3nueSsL300H63Xs0UYldd4pBKPapPo6iuEgmnxbPTAO7aSkI3LKjdrw2IliFjIuK0
         9hMQd6J/qPX+RIXgJMaxS3oyZDCz2kEHiAsBTooiZ/XXLALIgMuOuBh69uTpmrMDyDOo
         MVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679343642;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yTf7FAR2tU1EoBqS2XcH1CvlzxJgSOHwOzVShU56VwM=;
        b=zxdVwz0DaR8GYk3tKY6rwJCWQ3OWIpG/IhKHEbdBNl9+tRWMNCGDEpgwdzlpWL19gy
         rpnlDwlYvoJEbdAbWFLKTUrXDw37OMAe5wNHKNMF5P/5p3hKMU2vEfJb23ZmdJrQx8b/
         8QNDXJ6ZIf/AUaHHXeQS3dvZBktkdBKEWqG1ZjP2MzoRM2gVlVuKSsqeX9TImjRDk6j4
         8UQZsoBBq3wm1VTowHWMCXqwbXJOz5s4hN0q3bkT3lkuBnJLPpuu2jFhx3Dg3+ezOhPQ
         uH+kyvR2zgoK6R4E3IzewBPxx7G0B4pzLcA4lztWa92pOuP85XkJ+0toytqVw4vQphOs
         vX3A==
X-Gm-Message-State: AO0yUKVUK8xWdQQSxJ3vJv96flDhBQpHQl463gT3bquJZ3BWQ8UmiIHj
        3pRqrGgceN/K9g7Arcov4+EUmd8AGIy/0NAWTac=
X-Google-Smtp-Source: AK7set+9FC6gol0zxpWxl4XBGdyhU6DizVulyLrXf6ABWH+SNy/XvQXBGgC427+WIV1+MzQvZQ259g==
X-Received: by 2002:a05:6a20:8c02:b0:d9:fc6c:51fa with SMTP id j2-20020a056a208c0200b000d9fc6c51famr2464056pzh.32.1679343641710;
        Mon, 20 Mar 2023 13:20:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s5-20020a656445000000b004fb3e5681cesm6691931pgv.20.2023.03.20.13.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 13:20:41 -0700 (PDT)
Message-ID: <6418c019.650a0220.edb2f.afe1@mx.google.com>
Date:   Mon, 20 Mar 2023 13:20:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.103-116-g433daa4de681
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 163 runs,
 2 regressions (v5.15.103-116-g433daa4de681)
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

stable-rc/linux-5.15.y baseline: 163 runs, 2 regressions (v5.15.103-116-g43=
3daa4de681)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
cubietruck      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =

fsl-lx2160a-rdb | arm64 | lab-nxp      | gcc-10   | defconfig          | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.103-116-g433daa4de681/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.103-116-g433daa4de681
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      433daa4de6819b2f97fc17c5a71d1fa5b1f8b14c =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
cubietruck      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/64188c4461fe2efd4b8c8636

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
03-116-g433daa4de681/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
03-116-g433daa4de681/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64188c4461fe2efd4b8c863f
        failing since 62 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-03-20T16:39:08.668888  <8>[    9.991986] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3429371_1.5.2.4.1>
    2023-03-20T16:39:08.778563  / # #
    2023-03-20T16:39:08.880448  export SHELL=3D/bin/sh
    2023-03-20T16:39:08.881162  #
    2023-03-20T16:39:08.983011  / # export SHELL=3D/bin/sh. /lava-3429371/e=
nvironment
    2023-03-20T16:39:08.983847  =

    2023-03-20T16:39:09.085956  / # . /lava-3429371/environment/lava-342937=
1/bin/lava-test-runner /lava-3429371/1
    2023-03-20T16:39:09.087065  =

    2023-03-20T16:39:09.087375  / # <3>[   10.353188] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-20T16:39:09.092484  /lava-3429371/bin/lava-test-runner /lava-34=
29371/1 =

    ... (12 line(s) more)  =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
fsl-lx2160a-rdb | arm64 | lab-nxp      | gcc-10   | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/64188a14c2b03be7738c8666

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
03-116-g433daa4de681/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
03-116-g433daa4de681/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64188a14c2b03be7738c866d
        failing since 16 days (last pass: v5.15.79, first fail: v5.15.98)

    2023-03-20T16:29:40.146491  [   11.100360] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1179366_1.5.2.4.1>
    2023-03-20T16:29:40.252456  / # #
    2023-03-20T16:29:40.354149  export SHELL=3D/bin/sh
    2023-03-20T16:29:40.354640  #
    2023-03-20T16:29:40.455823  / # export SHELL=3D/bin/sh. /lava-1179366/e=
nvironment
    2023-03-20T16:29:40.456227  =

    2023-03-20T16:29:40.557561  / # . /lava-1179366/environment/lava-117936=
6/bin/lava-test-runner /lava-1179366/1
    2023-03-20T16:29:40.558177  =

    2023-03-20T16:29:40.559881  / # /lava-1179366/bin/lava-test-runner /lav=
a-1179366/1
    2023-03-20T16:29:40.576121  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
