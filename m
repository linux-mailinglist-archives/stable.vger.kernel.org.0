Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9DF5C049D
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiIUQu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiIUQuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:50:07 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92757F12F
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 09:45:13 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w13so6259950plp.1
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 09:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=kogPRJfafxl53YR3k4XHhBt0q1xVGwXab0d1Du1ck68=;
        b=1XuLiMOhCcPb4VTTwdRNij+6XIDMWRHbHCZwT35g0a0ZtxCEcM0R1/ht2tIv0hkvb1
         9ZK5D16SZ/bYcRHls9sJdtZGbzRQu8Kexw7AKVbQhljrnBUKfsgu1iWkYzcPIWhcJvcL
         K3W04piiaMngCr9zFC5lnt/YIkk88tc956jjG+SBQBhAHIyu6DZyQPlxr9q8XaaBr/pi
         9qF7HriyWmBDj6dARbIhsXEXWd6YsGXLrSZwt24p2UG7uK1w1Mw095Muqc/QiuNfp+nH
         nTH307CgcIS709esMkSE2j7NtBvCF7ZGogQ5Kg6bp3IWd08LmJTU+t8E+ypS0Nz8e+xR
         H3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=kogPRJfafxl53YR3k4XHhBt0q1xVGwXab0d1Du1ck68=;
        b=uYEhOixmbV4z2p/rHp/xySDNsxDOIa7HllnHAh/tghsoXy3bet6HhX/5PqPNvKoqZ6
         3s005kukKLQ54jv2wxg8dpnKUaNxZhml47/qE6Yqwxa5qyuv+E/mcB4p4JnIv8oa3pnV
         TS3b4IlUal4I5G7/4uA9Pyp9H1nCemFne+fVIERtWAq4xE8ccUxCJ8CyCygVdDFWs8u/
         Hk8hXCdhm+BVsZHOGFeUtTmUWDi8tPZ1ugg2JZwJ/1HQTpyCB9dbbD9d8G078GXtoCTP
         UX/u9PriTF9TjcRAJf+BGlXloH08anl7KWDUkAMJZRF/gUQYLhTRDp2d6C9bj7+nbr7T
         1HQw==
X-Gm-Message-State: ACrzQf1K7F3qEpP6ImhajUAtEbvE2ecoIwIWg5OHKQYsCzFtogJRHzwa
        HQ0uwqti4NqGzb1wf3Io05f/tHvtn5Yat/F5w/0=
X-Google-Smtp-Source: AMsMyM61yJYuPmt4Q52I+bqlLXF4I8UE6DgvPrFaxpPNRCW1WClOT3UkqOfV014FUGFM5BMYcVZpaw==
X-Received: by 2002:a17:90b:3b47:b0:202:d9d4:23f7 with SMTP id ot7-20020a17090b3b4700b00202d9d423f7mr10456335pjb.56.1663778712988;
        Wed, 21 Sep 2022 09:45:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l5-20020a17090a660500b002005114fbf5sm2088516pjj.22.2022.09.21.09.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 09:45:12 -0700 (PDT)
Message-ID: <632b3f98.170a0220.9fbf7.3f02@mx.google.com>
Date:   Wed, 21 Sep 2022 09:45:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.214-43-g75c9ce402d61c
Subject: stable-rc/queue/5.4 baseline: 83 runs,
 2 regressions (v5.4.214-43-g75c9ce402d61c)
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

stable-rc/queue/5.4 baseline: 83 runs, 2 regressions (v5.4.214-43-g75c9ce40=
2d61c)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 2     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.214-43-g75c9ce402d61c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.214-43-g75c9ce402d61c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      75c9ce402d61c09364db2a2c451c75080f665fed =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 2     =
     =


  Details:     https://kernelci.org/test/plan/id/632b0c9a51e5ca68cb355681

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-4=
3-g75c9ce402d61c/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-4=
3-g75c9ce402d61c/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/632b0c9a51e5ca68=
cb355686
        new failure (last pass: v5.4.213-14-g01680cfbf5dc)
        3 lines

    2022-09-21T13:07:13.749678  / # =

    2022-09-21T13:07:13.766477  =

    2022-09-21T13:07:13.870438  / # #
    2022-09-21T13:07:13.878440  #
    2022-09-21T13:07:13.981523  / # export SHELL=3D/bin/sh
    2022-09-21T13:07:13.989422  export SHELL=3D/bin/sh
    2022-09-21T13:07:14.090696  / # . /lava-2513378/environment
    2022-09-21T13:07:14.101438  . /lava-2513378/environment
    2022-09-21T13:07:14.202708  / # /lava-2513378/bin/lava-test-runner /lav=
a-2513378/0
    2022-09-21T13:07:14.213666  /lava-2513378/bin/lava-test-runner /lava-25=
13378/0 =

    ... (11 line(s) more)  =


  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
632b0c9a51e5ca68cb355689
        new failure (last pass: v5.4.213-14-g01680cfbf5dc)

    2022-09-21T13:07:14.805491  /lava-2513378/1/../bin/lava-test-case
    2022-09-21T13:07:15.810299  /lava-2513378/1/../bin/lava-test-case
    2022-09-21T13:07:15.826289  <8>[   12.844571] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>   =

 =20
