Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F504BC31F
	for <lists+stable@lfdr.de>; Sat, 19 Feb 2022 00:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbiBSAAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 19:00:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240280AbiBSAAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 19:00:12 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563ED257DFA
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 15:59:53 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id m11so4789653pls.5
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 15:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Hwtk/by3UoGrNN6hAKVP4raHkMvBK2AzNFeGASLWtpM=;
        b=kTLhdShZrXU4eYHkj9DQlxw0OgbGEIkc1PFzaarSdzFpvVlbW8OtGXjZtN77tYEfSj
         vBQ+cG8u1ReOr0Ef+gBmaQ98bzEH8JQJw0G5/6x6UhaQJ0R14+J3DBgE2NNuG+VddRRT
         HJLIuNt5oodOgua7gFWl4TLhMyNBs55NO7HDU8+89mkN9XB8zCcQZdNKtUzlu+OOSzSe
         JPnzD3zWkxJUK+ZoOGWovnqXjZtQSauL8ysFNV3EntaVxiNz7HEGY34ygolaPi5Ykcvt
         LQSngUN/turwemoJD6UGeLetluWzrTa8LMB6GdZevj84cqf2/UJVg6GiNld9Q13epzNI
         wZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Hwtk/by3UoGrNN6hAKVP4raHkMvBK2AzNFeGASLWtpM=;
        b=3vRFrOsqJY3+E+kNKzCb0CyZEDi2vwo52wFIh9OPjDQO72bpBQ0gDJAe1A+5e5g34n
         O86OWwDMfAtWiAg4Yq0x3JPBGvppivso5xRzk1tWQaDVghFLJR3+J9EhrDmqxh6SbLbu
         N7ZsCnk9ua454GMdOrftZSXBnaS3UDKg7Ckizfb5GUpnSRHN1rKfyhzObw8zOOB42WE5
         qjiVYJOgya2ScGXX3YajBASQcKkKLCMSKfINC7+OIqAxP4Q2hh6pnKZt4wPdv56dONKF
         ax6lc+oJA4p5ZcMFXLJTSLrKZJaJIsfj21QW2XUrpjdpufik3APld2pvZv8OMWIYLhvb
         BkYA==
X-Gm-Message-State: AOAM533l52wNBvBNO3ibTVZD94uWtlFHXxa/aE4wPScfFrIMdr4aXam9
        73Hgx2J5fFvwbbJ0NXfyIGBMniluKZJ2Nxo+
X-Google-Smtp-Source: ABdhPJy41aXD73e2BUDAwyupgnVBw76e8SRhgeGwTXn/lNmNEB1K4NB1/4ylBxrP6Ea0s9NX2p+jig==
X-Received: by 2002:a17:90a:86c1:b0:1b9:157e:383 with SMTP id y1-20020a17090a86c100b001b9157e0383mr14832530pjv.63.1645228793084;
        Fri, 18 Feb 2022 15:59:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nm19-20020a17090b19d300b001b9b85a5744sm410527pjb.22.2022.02.18.15.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 15:59:52 -0800 (PST)
Message-ID: <621032f8.1c69fb81.c9f90.1bd1@mx.google.com>
Date:   Fri, 18 Feb 2022 15:59:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.230-30-g3989d6047b08
Subject: stable-rc/queue/4.19 baseline: 93 runs,
 10 regressions (v4.19.230-30-g3989d6047b08)
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

stable-rc/queue/4.19 baseline: 93 runs, 10 regressions (v4.19.230-30-g3989d=
6047b08)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
panda                      | arm   | lab-collabora | gcc-10   | omap2plus_d=
efconfig        | 2          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.230-30-g3989d6047b08/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.230-30-g3989d6047b08
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3989d6047b08ceabfd1c68b8731e7be274b309c3 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
panda                      | arm   | lab-collabora | gcc-10   | omap2plus_d=
efconfig        | 2          =


  Details:     https://kernelci.org/test/plan/id/620ff9f49e15399724c629f2

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/620ff9f49e15399=
724c629f5
        failing since 0 day (last pass: v4.19.230-16-g06418b3894b9, first f=
ail: v4.19.230-20-g549cd99b49a8)
        2 lines

    2022-02-18T19:56:18.032416  <8>[   21.874999] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>
    2022-02-18T19:56:18.077974  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2022-02-18T19:56:18.087116  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/620ff9f49e15399=
724c629f6
        new failure (last pass: v4.19.230-30-g704d460002f5)
        3 lines

    2022-02-18T19:56:17.961998  <8>[   21.804473] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcrit RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-18T19:56:18.009667  kern  :alert : Unhandled fault: imprecise e=
xternal abort (0x1406) at 0xbf48d340
    2022-02-18T19:56:18.012379  kern  :alert : pgd =3D (ptrval)
    2022-02-18T19:56:18.016174  kern  :alert : [bf48d340] *pgd=3D00000000   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620ff7db10e6a14319c62994

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620ff7db10e6a14319c62=
995
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620ff7f3f1783b306ec62992

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620ff7f3f1783b306ec62=
993
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620ff7da61970a611ec62991

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620ff7da61970a611ec62=
992
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620ff7cc10e6a14319c6297f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620ff7cc10e6a14319c62=
980
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620ff7b0e2d165235bc6299a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620ff7b0e2d165235bc62=
99b
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620ff7b7e2d165235bc629aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620ff7b7e2d165235bc62=
9ab
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620ff7b1375230f98fc6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620ff7b1375230f98fc62=
96b
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620ff7b9e2d165235bc629ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g3989d6047b08/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620ff7b9e2d165235bc62=
9ae
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =20
