Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB6F502012
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 03:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346463AbiDOBXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 21:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348535AbiDOBW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 21:22:59 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791A02A259
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 18:20:32 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id md4so6547494pjb.4
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 18:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z65084CBkW08OPjEpV5CuS7+fT8KtRJJfiYLIq/kuh8=;
        b=UmmeAWVM/VX1NU92sf0nkOu8VrePux1yVDTFQInFNcf+EP/U/7DGJuToURuF7oB/WP
         XjH1lDCcoOIfR8lp9MdWZJFjgw5BxZLqcQcf0EHqBDBjpqK+/R8isKTN8B9dKT9GjHM8
         Ie0c1avMSwyBF8Yi2ziT60BiZMhpo6Rp70Rx06hTnTIR5TCIxqUJg76A1pHMMyfLd1jf
         weuvblJkEd10/r+H6B3Q/M1fOFDadfOuxqIqf4r2LNTqSDJjjTNLhSaSDwII4UCgcm8t
         qt7hjcgXyAzUwSK4HUI+SNQwdSnYme+1keY1GrNEfrN44AITD0yVwZi44byLoI+eNdVx
         1Ibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z65084CBkW08OPjEpV5CuS7+fT8KtRJJfiYLIq/kuh8=;
        b=RNx0SMoAfKeHZs1gnWC6EwQEsoL1G9+ptwTUz4P41DuROBa9o24LBuia9nvN5hfEPh
         inrmMMO83iCuU6Hq8mnuU9RY5GBmn3lhbGsYnRP3TyjIsdqKYET3HFO1u+2S7Pls99tT
         BG7PGNnjlqhegtZVr8a4noA2NDGkQ1EopaRZnsYxoNGLLNyoZcZ1z+CHIgQYk0FZEV2A
         //HuoWcpS8egiCWYcTn7t5rTLMZIrArJZrpnPgGsKifQOWLdN39PbKqchrWfI6Lv6o5s
         OC4JEIa+YTz/uGUwjA1ws5de+oSU4gvGB8lla0kW72CJFbIFJilktzOXsYMHtl1f4nvm
         JvDg==
X-Gm-Message-State: AOAM5329vif/X+Hyv6Efslw9q+LzcqgYPglzPvkpWSqwyNfV3owJNohI
        z2umlHhz8IDJiXBmGuyVuYkHu/75QNmurMtS
X-Google-Smtp-Source: ABdhPJw/7NR7ijB3p7fucrr9jxcmwPcjNHO5UNnTK51V4PTNfmCnVTy/4yYpeDfNIW4fkqVmHPYLRg==
X-Received: by 2002:a17:902:bc86:b0:151:ec83:4a8b with SMTP id bb6-20020a170902bc8600b00151ec834a8bmr48921732plb.69.1649985631864;
        Thu, 14 Apr 2022 18:20:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l22-20020a17090aaa9600b001ca7a005620sm3001931pjq.49.2022.04.14.18.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 18:20:31 -0700 (PDT)
Message-ID: <6258c85f.1c69fb81.a2e20.8a0a@mx.google.com>
Date:   Thu, 14 Apr 2022 18:20:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.3-7-g363c8c6fd7ed5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 122 runs,
 2 regressions (v5.17.3-7-g363c8c6fd7ed5)
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

stable-rc/queue/5.17 baseline: 122 runs, 2 regressions (v5.17.3-7-g363c8c6f=
d7ed5)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig         | r=
egressions
-------------------+-------+-------------+----------+-------------------+--=
----------
at91sam9g20ek      | arm   | lab-broonie | gcc-10   | at91_dt_defconfig | 1=
          =

kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig         | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.3-7-g363c8c6fd7ed5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.3-7-g363c8c6fd7ed5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      363c8c6fd7ed5459b0fcf4dde2e4b3c985062bf9 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig         | r=
egressions
-------------------+-------+-------------+----------+-------------------+--=
----------
at91sam9g20ek      | arm   | lab-broonie | gcc-10   | at91_dt_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62589100b40f853e94ae0681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-7=
-g363c8c6fd7ed5/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-7=
-g363c8c6fd7ed5/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62589100b40f853e94ae0=
682
        failing since 0 day (last pass: v5.17.2-343-g74625fba2cc43, first f=
ail: v5.17.3-7-g214113ee8b920) =

 =



platform           | arch  | lab         | compiler | defconfig         | r=
egressions
-------------------+-------+-------------+----------+-------------------+--=
----------
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig         | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62589442450e579e33ae070d

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-7=
-g363c8c6fd7ed5/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-7=
-g363c8c6fd7ed5/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/625=
89442450e579e33ae0720
        new failure (last pass: v5.17.3-7-g214113ee8b920)

    2022-04-14T21:37:53.851643  /lava-108813/1/../bin/lava-test-case
    2022-04-14T21:37:53.851969  <8>[   13.473831] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-04-14T21:37:53.852168  /lava-108813/1/../bin/lava-test-case
    2022-04-14T21:37:53.852364  <8>[   13.493615] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-04-14T21:37:53.852527  /lava-108813/1/../bin/lava-test-case
    2022-04-14T21:37:53.852680  <8>[   13.514827] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-04-14T21:37:53.852835  /lava-108813/1/../bin/lava-test-case   =

 =20
