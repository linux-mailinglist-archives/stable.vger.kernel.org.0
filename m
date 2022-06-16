Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D476154E817
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 18:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiFPQuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 12:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiFPQuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 12:50:13 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75006B8A
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 09:50:12 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id o17so1722407pla.6
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 09:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5NLo64B0r5ZomnHSc2yEX0ZvIlwmn+E5CS8o+tFM3G8=;
        b=1Z07OfxNZ6V8SY2x5hBtmyRvj46z8fcBUKqevAaueWITgPnpWnXaLC6BhjkCSvc/h5
         nFDsTb5xMp7JLUuQvDv12AP/32UnrJpXhZstpsWnHycK37MeDNNAN3oSK7ssmuovRMVK
         s1FfN6Q4c/VFUqmJgmN7tXrhXNq2Jd0V7rP6B0EqlLdaon0OZrcrKzxsYqFASsaYY56J
         kj++iF0grybStHKEnqPDySCT7hcHlEE1y7iO/T/hxzMIe/8sm5n7Zla3/NWm4mML3NRc
         Xtdde5f01Q51Lj0+CvzFI8wQsxOrwjdOymhGmPs6sxFp+JtscB3128gc801j8XAiRvWF
         6eUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5NLo64B0r5ZomnHSc2yEX0ZvIlwmn+E5CS8o+tFM3G8=;
        b=WUz2DVfZsBvk2yIivUz0lkCVC0Pp74h27oLU33ojWlh39ELun3JFxCc8nHSne54HIJ
         ed+IxuzZwXqGknLqjgEUk/zquFMbSHfsFmKxz9wOdIIJZvXltZMv598K2mZtXefxsJLl
         gJ4VX/ZiN5WZWqjRrRm/TlxsNXo0bBe/hlyqpOeHCUmF8I3p5Y9Omz4T8iXEBMdISEUI
         vRbXuwDPT2Xt7Ddr4GCrOI5ZRzI77Nl/0/8bFy3Nq5/LBitKNWbBAU6JoWcu2krZkxNh
         XWYUKoZIDOxsJ1WwOOm6d+KVbm8oJ1+ygLnS/PV6pojgR688B21mGforE+xGbD86rmvg
         vtRQ==
X-Gm-Message-State: AJIora83i4NZC2EAHshtRTugnvCTFFDquwbYJmyAbpM3tWE5CUryDrQ2
        Z3NB+1RjVfhQfsivTEz0xNDUks6KsY8nhgliICc=
X-Google-Smtp-Source: AGRyM1v+NlD/tKgnDzUZR1ke67fLrEFU4JHZvPaig+IkV49y7+F/DRm2prC8RrZrRzi2UEZqDp2h/g==
X-Received: by 2002:a17:902:a70d:b0:15e:da68:b1b1 with SMTP id w13-20020a170902a70d00b0015eda68b1b1mr5464455plq.53.1655398211766;
        Thu, 16 Jun 2022 09:50:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l18-20020a17090a409200b001eb162ffaa3sm718286pjg.25.2022.06.16.09.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 09:50:11 -0700 (PDT)
Message-ID: <62ab5f43.1c69fb81.def41.1143@mx.google.com>
Date:   Thu, 16 Jun 2022 09:50:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.198-15-g2ff259ec549cc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 93 runs,
 2 regressions (v5.4.198-15-g2ff259ec549cc)
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

stable-rc/queue/5.4 baseline: 93 runs, 2 regressions (v5.4.198-15-g2ff259ec=
549cc)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =

jetson-tk1         | arm    | lab-baylibre  | gcc-10   | multi_v7_defconfig=
           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.198-15-g2ff259ec549cc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.198-15-g2ff259ec549cc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ff259ec549ccfdd3216fd618bf416799a8a25cd =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ab2640ee08dbfef8a39c07

  Results:     17 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.198-1=
5-g2ff259ec549cc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.198-1=
5-g2ff259ec549cc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/x86/rootfs.cpio.gz =



  * baseline.bootrr.thermal-device-probed: https://kernelci.org/test/case/i=
d/62ab2640ee08dbfef8a39c0c
        failing since 9 days (last pass: v5.4.196-34-g2d8686793d26, first f=
ail: v5.4.197-272-g3e870ca209935)

    2022-06-16T12:46:52.494167  /lava-6629649/1/../bin/lava-test-case
    2022-06-16T12:46:52.501684  <8>[   12.025772] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dthermal-device-probed RESULT=3Dfail>   =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
jetson-tk1         | arm    | lab-baylibre  | gcc-10   | multi_v7_defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/62ab2e3775f071be10a39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.198-1=
5-g2ff259ec549cc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.198-1=
5-g2ff259ec549cc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab2e3775f071be10a39=
be2
        failing since 8 days (last pass: v5.4.197-281-ga668ecde02cee, first=
 fail: v5.4.197-281-gcb042b4c222ce) =

 =20
