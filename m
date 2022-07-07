Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80B056AF26
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 01:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbiGGXoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 19:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbiGGXoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 19:44:37 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E10B6D551
        for <stable@vger.kernel.org>; Thu,  7 Jul 2022 16:44:36 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s27so20930394pga.13
        for <stable@vger.kernel.org>; Thu, 07 Jul 2022 16:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RFPhFMNXdbAGfHbMBn9qlp/M2zRTnTH1oYLcTwSXgeM=;
        b=YcBYE+PWSza7P2NtWFn3s0clksjjr6kcZVJPrq0J9TRzl7j+nB1eRTxUShLwIuiDn7
         ymeDtE7We/RBHRWTd5m5VPiyFinU0BBfp6UWA4eLoKKQ+iq1c5K9zZdbBHzwzClSm6cv
         ELJrrpvkxk6k2gCvhOSRKyDXaTGCGl6cNsPNjBNJf5Bwl1qDpkrVBGBn1NElmuIyjK8P
         dcNfshehIyMvBYUWLdwERnQ+gv0lzrBWhWO1xE8IzYdlwv9ysNsOgIYfYcWyjLeGFWND
         z6oTyKxxWHlcnuNj/9RK4LJMv9qmRqfRfYmKel+5eyGTJ4/KGgFDxF3JInbvH2nl1a4R
         lYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RFPhFMNXdbAGfHbMBn9qlp/M2zRTnTH1oYLcTwSXgeM=;
        b=TOWGto1YLU6MdXtc9dh32+JEVSQg/We5J/xIOKehlp9t2WIkrhpS445dysZBDlE8au
         p0zwQz7kroq5NnOLrGyO1IM7K64iI9QfToCpXlVto5upm64LcJCu+/E8FzgOrPIS2ueh
         Fh85rdOnA7goM5vvL8+AYuuW4YIUWt/wdoHlhtXovQsUuZLAR5dXD0THHBh2dsjNdQXg
         gBf6UeVlYnwChJJDNXcjAxtBLvMEsX3HiGpWs/F9NEt+2an1c93QZg14eiEnjC0G4Bhx
         5mw9bexLxonuku4JJEww5ywea/M2N/Nt6FFG57vsngMmv54F1fcMoz6SGAH9xoKG5Eb4
         NQAA==
X-Gm-Message-State: AJIora+f/ElBId1x5dytp6dv1kur1Rme7Af3RkiskxfjopsolbCWcwVz
        gBDaLgJgTkH9rSstqVK4+VLXa2ldqizrtxMI
X-Google-Smtp-Source: AGRyM1t6My6wJFdfq4rTQ53d9s9mXeCIhZAWj2F/aqWir+uxsy4cCtWhC4gPUWZM/4zJ2coArN0r9A==
X-Received: by 2002:aa7:88cc:0:b0:51c:319e:772c with SMTP id k12-20020aa788cc000000b0051c319e772cmr755511pff.41.1657237475417;
        Thu, 07 Jul 2022 16:44:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q6-20020aa79606000000b0052a75004c51sm300210pfg.146.2022.07.07.16.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 16:44:34 -0700 (PDT)
Message-ID: <62c76fe2.1c69fb81.d6cf0.09f2@mx.google.com>
Date:   Thu, 07 Jul 2022 16:44:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.10
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.18.y baseline: 150 runs, 4 regressions (v5.18.10)
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

stable/linux-5.18.y baseline: 150 runs, 4 regressions (v5.18.10)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron   | gcc-10   | defconfig=
                  | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-10   | defconfig=
                  | 1          =

tegra124-nyan-big            | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.10/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      bc560cecaa8b2517932808fa939e36371ffa036e =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62c73c23a28494d8d5a39bd2

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.10/a=
rm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.10/a=
rm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/62c=
73c23a28494d8d5a39be9
        new failure (last pass: v5.18.8)

    2022-07-07T20:03:35.232683  /lava-138317/1/../bin/lava-test-case
    2022-07-07T20:03:35.233059  <8>[   16.624977] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-07-07T20:03:35.233301  /lava-138317/1/../bin/lava-test-case
    2022-07-07T20:03:35.233524  <8>[   16.644723] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-07-07T20:03:35.233748  /lava-138317/1/../bin/lava-test-case
    2022-07-07T20:03:35.233964  <8>[   16.665854] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-07-07T20:03:35.234180  /lava-138317/1/../bin/lava-test-case   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62c73e247fad7b3060a39c05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.10/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kukui-=
jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.10/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kukui-=
jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c73e247fad7b3060a39=
c06
        new failure (last pass: v5.18.8) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62c73c787da2cae1c2a39bdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.10/a=
rm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.10/a=
rm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c73c787da2cae1c2a39=
bde
        failing since 31 days (last pass: v5.18.1, first fail: v5.18.2) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
tegra124-nyan-big            | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62c7652a4480e67033a39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.10/a=
rm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.10/a=
rm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c7652a4480e67033a39=
bdc
        new failure (last pass: v5.18.8) =

 =20
