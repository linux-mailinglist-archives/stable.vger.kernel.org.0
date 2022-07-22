Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD6F57D82E
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 03:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiGVByd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 21:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGVByc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 21:54:32 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB9F90DB8
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 18:54:29 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gq7so3177070pjb.1
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 18:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TS4dTgOTjNPYPYBT+sn0zyV6OdmUtUsRBBPTKmC+bI0=;
        b=gkPGqOVYi7Bp2UJVB2yPq276zMXjf67D7qAHNjWtmmgsYsozHMQz4i8n4xazKqEQT3
         85DP3GScX26+GzGnRToE+6bR8QqyNryR0Zn0z0z7Quyh3n4Qsn14Wn9szVaG2zWH0XvM
         cUfCkOfB6+RXvk6QQQrL6ckDcbUTjXEfpoIrpNh/01ODOzLkhXBcWJKjmDx/RIKuoljG
         zFIKuI69RtYV+cjXel5mQmExKDDa+1XOpa/465oZNJyBvkvKXdgCDkZ32QYZGgMb1+bz
         BXaC+NEFb0JkczehWaBxRaMRXYrM1mNI4lqwuwCd1rrMgQpjFNS3UmRTeAp5eVZj+I+X
         YgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TS4dTgOTjNPYPYBT+sn0zyV6OdmUtUsRBBPTKmC+bI0=;
        b=1HsxNz3Nuy1K5flWLGpSnRxj+GzzEl6xR8ECNy6Q5Z++ZwRn99f0o7Cda6NN3w4K/c
         4Rt7xToG8hg6FdMII/2zGP+qMmcVLR313hUX7WRUnijXJywBlLT7q4Y/ZdpOonki9RPN
         17kDKeadn+UXnxdxkhrBYeP9QigD9XTOe+aUpPTZUJ3jQIWQQ8lQzezPrNwTldNhh6ol
         7heDUDP3+pF7oHIfyY02+w32PyNjSow47AuEWwpXPnMvb6w5fHFNTvAKGDqFrlu/MolF
         Vc+Qm7umhLdOfCunlvFsz3v6AtNKFYxxe16ThS+zBKJhvN68s4TXLVhuDVSWuILxMwtC
         yepw==
X-Gm-Message-State: AJIora9qw2Rp7WMbChrOOlNETqTWNl0U1AWu4Q5IKoLa48hqPnHJ7yh9
        fOVJWWZ7Kc9hBIkhIWqN2isfSjmn9wcu+kD/hlI=
X-Google-Smtp-Source: AGRyM1twKj0vq60lHx6PR23uuhyAK2xDoai8jtBqa2SIFILLoQfFiIviElU5inSjCJg7sn8krW9idA==
X-Received: by 2002:a17:90b:3c8c:b0:1f2:205c:2480 with SMTP id pv12-20020a17090b3c8c00b001f2205c2480mr11770072pjb.54.1658454869011;
        Thu, 21 Jul 2022 18:54:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n7-20020a170903110700b0016bdeb58611sm2421676plh.112.2022.07.21.18.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 18:54:28 -0700 (PDT)
Message-ID: <62da0354.1c69fb81.8a589.43b4@mx.google.com>
Date:   Thu, 21 Jul 2022 18:54:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.55-168-gbe2291082cf2
Subject: stable-rc/queue/5.15 baseline: 172 runs,
 3 regressions (v5.15.55-168-gbe2291082cf2)
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

stable-rc/queue/5.15 baseline: 172 runs, 3 regressions (v5.15.55-168-gbe229=
1082cf2)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
beagle-xm          | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig =
| 1          =

i945gsex-qs        | i386  | lab-clabbe   | gcc-10   | i386_defconfig      =
| 1          =

kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig           =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.55-168-gbe2291082cf2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.55-168-gbe2291082cf2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be2291082cf26437e8abf29e0dc4c48dc35cd230 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
beagle-xm          | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62d9d28d561dbe7c5bdaf073

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.55-=
168-gbe2291082cf2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.55-=
168-gbe2291082cf2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d9d28d561dbe7c5bdaf=
074
        failing since 113 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
i945gsex-qs        | i386  | lab-clabbe   | gcc-10   | i386_defconfig      =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62d9ce27866618772cdaf063

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.55-=
168-gbe2291082cf2/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.55-=
168-gbe2291082cf2/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d9ce27866618772cdaf=
064
        new failure (last pass: v5.15.52-99-g46abc1c965f7) =

 =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62d9ce48091bfcedafdaf087

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.55-=
168-gbe2291082cf2/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.55-=
168-gbe2291082cf2/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/62d=
9ce48091bfcedafdaf09a
        new failure (last pass: v5.15.55-167-gddb6c29a78fb)

    2022-07-21T22:07:55.718126  /lava-144079/1/../bin/lava-test-case
    2022-07-21T22:07:55.718451  <8>[   14.620909] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-07-21T22:07:55.718605  /lava-144079/1/../bin/lava-test-case
    2022-07-21T22:07:55.718781  <8>[   14.640563] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-07-21T22:07:55.718958  /lava-144079/1/../bin/lava-test-case
    2022-07-21T22:07:55.719135  <8>[   14.661653] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-07-21T22:07:55.719274  /lava-144079/1/../bin/lava-test-case   =

 =20
