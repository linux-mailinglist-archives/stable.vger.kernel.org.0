Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0750604664
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiJSNJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbiJSNJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:09:10 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9E55282B
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 05:54:18 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id fw14so16814787pjb.3
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 05:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AvlLYqUFj9RUbzeuKcWWLUhmrqJKXv/UYRicy9plc3o=;
        b=5KG1Jay/pYE3Y6QL1Sgldgy/2IrIMZwwT7sJyBVPu297vLEEr5RKjrd9r1TDFPPV5v
         dwqhcc4o3STKnPPzIu4ZX90pioPajQobQ4sJJOyj8kQoAqIiv+4yFq2r1a9YjkeM2DWc
         lutOeSVS8ConXTjRewNTM0fsk3BfH/Z59liv0bmAsG1zvDEeElXR+hyojGvNNWz1wcTu
         KEcykRkIOIzGI/uUBIQYoLV7lD43TaxbTsRwEjYaZZvUJVxo5V/lKWxwpU8quRTgUb0b
         YM39K+QwDGRLNwumNfzDdLcfmy7m9b1V4A/d9KdfZAdW3RYcW3GgL8XRHd46dzxJGp32
         aEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AvlLYqUFj9RUbzeuKcWWLUhmrqJKXv/UYRicy9plc3o=;
        b=a/aNDzUKBbO2woP9qgECjHipfOwSMw894VdAXAXSoKZZymlT6iygndcYYvoTKAcDf4
         l5UwyGlrVjcw1Gt5oO8bVcaF9q/jwtqo9/PsvlRaI6GS276kUHMrIbnZGd0z2RPaScP/
         ZIwpH8zIMoOmwilGGCxXIL6viwAvh6hKKItCJPzJXyu0w4l4qggmqfAZDIb4h1uq8CQ/
         oJ7+f+MvmR5g6qobSjr26/GUQuQbZRDyR3Iqd98lKpDa9Hd7eCj4hVp7VHmKImbD5m/3
         o8ic28l/tloOOwDJ4yZWQw1P7wr0J1X/EhzoD74H2ZEKnznfZbCCvCp3Ilcionm4HP/F
         udfw==
X-Gm-Message-State: ACrzQf0kXrz3tEEq+/jiKVDedlBbFnSFJtLMbU2MJ6tdaLBFw28/hXfe
        H9d/Nijov1v0RuOcCQE2nwyQvO3FcgXUZW9K
X-Google-Smtp-Source: AMsMyM48AVitIrC3dHtaD/wcC94Gwigi8spg29LTXsCZdkOKwvNGXAZF8UE4X7mdSm55ndAzxr8r8Q==
X-Received: by 2002:a17:903:2448:b0:17f:8069:532a with SMTP id l8-20020a170903244800b0017f8069532amr8251516pls.95.1666183898402;
        Wed, 19 Oct 2022 05:51:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902a3c300b001784a45511asm10647764plb.79.2022.10.19.05.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 05:51:38 -0700 (PDT)
Message-ID: <634ff2da.170a0220.24948.4088@mx.google.com>
Date:   Wed, 19 Oct 2022 05:51:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.261-239-g2367390a13a82
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 90 runs,
 4 regressions (v4.19.261-239-g2367390a13a82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 90 runs, 4 regressions (v4.19.261-239-g236=
7390a13a82)

Regressions Summary
-------------------

platform          | arch | lab          | compiler | defconfig             =
| regressions
------------------+------+--------------+----------+-----------------------=
+------------
beaglebone-black  | arm  | lab-cip      | gcc-10   | omap2plus_defconfig   =
| 1          =

da850-lcdk        | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig =
| 2          =

r8a7743-iwg20d-q7 | arm  | lab-cip      | gcc-10   | shmobile_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.261-239-g2367390a13a82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.261-239-g2367390a13a82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2367390a13a82ec2bd0146e67d8970650b978e4a =



Test Regressions
---------------- =



platform          | arch | lab          | compiler | defconfig             =
| regressions
------------------+------+--------------+----------+-----------------------=
+------------
beaglebone-black  | arm  | lab-cip      | gcc-10   | omap2plus_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/634fc72ef34b0a1b7b5e5b3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-239-g2367390a13a82/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-239-g2367390a13a82/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634fc72ef34b0a1b7b5e5=
b3c
        new failure (last pass: v4.19.261-246-g7bdef4764c48) =

 =



platform          | arch | lab          | compiler | defconfig             =
| regressions
------------------+------+--------------+----------+-----------------------=
+------------
da850-lcdk        | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/634fc08de8f66f6f7e5e5b4c

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-239-g2367390a13a82/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baselin=
e-da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-239-g2367390a13a82/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baselin=
e-da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/634fc08de8f66f6=
f7e5e5b4f
        failing since 1 day (last pass: v4.19.261-33-g7a24cdf8a13a5, first =
fail: v4.19.261-246-g7bdef4764c48)
        4 lines

    2022-10-19T09:16:32.095617  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-10-19T09:16:32.096136  kern  :emerg : flags: 0x0()
    2022-10-19T09:16:32.098779  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-10-19T09:16:32.099054  kern  :emerg : flags: 0x0()
    2022-10-19T09:16:32.169188  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-10-19T09:16:32.169489  + set +x   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/634fc08de8f66f6=
f7e5e5b50
        failing since 1 day (last pass: v4.19.261-33-g7a24cdf8a13a5, first =
fail: v4.19.261-246-g7bdef4764c48)
        6 lines

    2022-10-19T09:16:31.916734  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-10-19T09:16:31.917033  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-10-19T09:16:31.917237  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-10-19T09:16:31.917425  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-10-19T09:16:31.917605  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-10-19T09:16:31.919960  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-10-19T09:16:31.960676  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =

 =



platform          | arch | lab          | compiler | defconfig             =
| regressions
------------------+------+--------------+----------+-----------------------=
+------------
r8a7743-iwg20d-q7 | arm  | lab-cip      | gcc-10   | shmobile_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/634fc14e76d2a79dcc5e5b4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-239-g2367390a13a82/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-239-g2367390a13a82/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634fc14e76d2a79dcc5e5=
b4e
        new failure (last pass: v4.19.261-246-g7bdef4764c48) =

 =20
