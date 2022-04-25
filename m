Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAD550DFD5
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 14:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiDYMYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 08:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbiDYMY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 08:24:28 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7862D1E6
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 05:21:24 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id j6so12301092pfe.13
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 05:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LnMIHczQV5hDKFgy+R6hyzxak3rLPOz+NatbbA04teE=;
        b=Zqh4nBaqC0sldKfolluo++a+JetRMMk9nzAiuxYH+5U2AOOXD7tyrCZnq3CHk0SNOJ
         FRXV/3/Xh43RH5LaHAuoQWgNqEiEECJEueMdsGEkk1ss2retoyMTlxG2m0YHTxiGdV5v
         /u47Z8cXXTcWmqukbIgRmJMojY4EE4tCszvGpaHhtMzS3+2tEeTY+NWpxS9a+4/f1TMd
         4A0rBKNvhHo5CTTiRtADq04LjLwCFyroHvNwvM1+i4fN7NVq3OqXHIeJY2Yq4nQmpuM+
         4JNJC9MtkFGiQBKLkq3DfUQu52wllJHM9icNJrx6x4/cRaVPktz7VdQ4DEkG3/nd1S63
         8tPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LnMIHczQV5hDKFgy+R6hyzxak3rLPOz+NatbbA04teE=;
        b=ksgcDggFIZfTCV5FLiVEwt9D6hsiSuhwoYdoI7utPyF/S6EQrAk1h84w47YzapDXzz
         1pgS317syKON/91hIKaMd7+dNN1XmvUPx1aW9EIBupb6I1iasYrE9oAQ72GX9h5ipO3+
         gf6U0Dw5UP98PFU/0WzibtCxR8yriRxE8wqi47Oprgunk+5BOjmySASvLbzgrVDdO19I
         ZqVqGsHyTLKHx8A5EVSO3gyCGJz0b/spi7tJFtADqub9XCEKZwYSEaMV3/I+qfW5AoYb
         OYImoYIXsGigaVKCrhvu+63tH1wsQuBTLKADkQqKAkEJ70qg3xBurfCQ3GVKefEA7sVx
         Or9w==
X-Gm-Message-State: AOAM531LkBIcg9pIpEWlFhkYuw/i8p3NXaMPBSl7nPJp/oxmPCz/AAZ7
        nVorcfdUWXQXMHERKh8ODumh02lI1ypa77CLFe8=
X-Google-Smtp-Source: ABdhPJwsIY+QiyuVtyF/SxQAg7MaARC0bWppqG5xt5at3upGNiEQMBLMWe4DKPPlpI111PF9tvDYLw==
X-Received: by 2002:a65:6a4c:0:b0:39c:f169:b54a with SMTP id o12-20020a656a4c000000b0039cf169b54amr15021103pgu.384.1650889284168;
        Mon, 25 Apr 2022 05:21:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bw22-20020a056a00409600b0050a8e795672sm11094592pfb.29.2022.04.25.05.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 05:21:23 -0700 (PDT)
Message-ID: <62669243.1c69fb81.54430.a71e@mx.google.com>
Date:   Mon, 25 Apr 2022 05:21:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.239-9-gc0261350248b4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 104 runs,
 5 regressions (v4.19.239-9-gc0261350248b4)
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

stable-rc/queue/4.19 baseline: 104 runs, 5 regressions (v4.19.239-9-gc02613=
50248b4)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
da850-lcdk                   | arm   | lab-baylibre  | gcc-10   | davinci_a=
ll_defconfig      | 2          =

meson-gxbb-p200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.239-9-gc0261350248b4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.239-9-gc0261350248b4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c0261350248b46f0c18bdaf921e9812d82d62272 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
da850-lcdk                   | arm   | lab-baylibre  | gcc-10   | davinci_a=
ll_defconfig      | 2          =


  Details:     https://kernelci.org/test/plan/id/6263e9fc9bacf16a4bff9499

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-9-gc0261350248b4/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-9-gc0261350248b4/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6263e9fc9bacf16=
a4bff949c
        new failure (last pass: v4.19.239-6-g5ad0881ca15e2)
        4 lines

    2022-04-23T11:58:45.697218  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-04-23T11:58:45.697488  kern  :emerg : flags: 0x0()
    2022-04-23T11:58:45.697668  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-04-23T11:58:45.697824  kern  :emerg : flags: 0x0()
    2022-04-23T11:58:45.766010  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-04-23T11:58:45.766287  + set +x
    2022-04-23T11:58:45.766457  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1862576_1.5.=
2.4.1>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6263e9fc9bacf16=
a4bff949d
        new failure (last pass: v4.19.239-6-g5ad0881ca15e2)
        6 lines

    2022-04-23T11:58:45.523198  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-04-23T11:58:45.523447  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-04-23T11:58:45.523622  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-04-23T11:58:45.523777  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-04-23T11:58:45.523926  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-04-23T11:58:45.524072  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-04-23T11:58:45.560018  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6263eb8bfe7619f296ff94ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-9-gc0261350248b4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-9-gc0261350248b4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6263eb8bfe7619f296ff9=
4bb
        failing since 22 days (last pass: v4.19.235-17-gd92d6a84236d, first=
 fail: v4.19.235-22-ge34a3fde5b20) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6263eafac8049b6cdaff9466

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-9-gc0261350248b4/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-9-gc0261350248b4/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6263eafac8049b6cdaff9=
467
        failing since 4 days (last pass: v4.19.238-22-gb215381f8cf05, first=
 fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6263eb45a897069dd5ff9481

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-9-gc0261350248b4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-9-gc0261350248b4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6263eb45a897069dd5ff94a7
        failing since 48 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-23T12:04:13.362189  <8>[   36.033698] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-23T12:04:14.375930  /lava-6162141/1/../bin/lava-test-case
    2022-04-23T12:04:14.384485  <8>[   37.057490] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
