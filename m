Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C474C2323
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 05:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiBXEuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 23:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiBXEup (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 23:50:45 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA40230E5B
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 20:50:16 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso4689652pjk.1
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 20:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vOTShBGDH7h+bL1oh0yLWJnLRe8BOWPfLFAWp2joyPg=;
        b=1b5hmwYbR5KH4C4TFTVH23CGOFUI4FyKhnyn+TYHCNWhv+LtkemNcdGsy3rKlv80TX
         T94s3kJckeJbKfn3/SfMmcpwlTTZNXMy3ASd5G1v6I4Keu5MtWRQFOsVcQiT0zFWZ3p6
         i26nVwje1SmHiDppCxmjL5KcqfMmf53mWTYJ+V9vMzlcBGTTqoQNzCecEhjM9v8rKJsG
         fo3+2NPKn9DDvS2aWnRdjQAWGolrl268KNVWUGbaPnHbQP1rAecHoMI0mMILfKmKasn5
         xCzM0zbAPUsV5ekAUo+k3rXjjMnP7234L0dXt9UHATHrurkBw4c8g2yqE4UBTNH0wIWx
         /EoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vOTShBGDH7h+bL1oh0yLWJnLRe8BOWPfLFAWp2joyPg=;
        b=XvSrkkR0qZKmqzf9vCjSTNKoTVr4t6l1Y/6KdHNyDaQLtH70iGCrbUIkK9kll6XIbU
         025IHKzxNbOtO1uAKI7dABFvjRRlgMGdtYrQnlJS8yjkrxKvK9zpTkwtsLhD9hhCSJmf
         9N44xpQBb0I1kZc5Big0BpaJ4kCzpnm/S8htCr6ZdQ5UAnlaz8qikpE+m0JlCzsml7mg
         1WyeWoEMcY9FqfjygkoJiC4uEQW/BZgaJRhZEgrbh+TscrH5jWfCx6ymW714bL1WnFyK
         q1sGCJxCnVw4XPSp00SaUU633VgI1MG7Ji54cc4ZRKNIT2XpnCfPMlERxFUdLHZWSobV
         7oUg==
X-Gm-Message-State: AOAM530175n600iBb3sayWj+45UpkSAkAPKB+b+0MLSPCKcX3MLdnqv0
        STbnnZ+odl2gzf75HnCl7EiqZmPH5ofbiNUfspo=
X-Google-Smtp-Source: ABdhPJzmqDROtB34MzEcpXVehbIrC1POfZbuX/9nQt57mUhOM2mmm5miQoeX8MjOKHuv3B9WLuFuZQ==
X-Received: by 2002:a17:903:18e:b0:14d:d208:58d3 with SMTP id z14-20020a170903018e00b0014dd20858d3mr1033373plg.57.1645678216221;
        Wed, 23 Feb 2022 20:50:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g20sm1360589pfj.64.2022.02.23.20.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 20:50:15 -0800 (PST)
Message-ID: <62170e87.1c69fb81.41e0.5033@mx.google.com>
Date:   Wed, 23 Feb 2022 20:50:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.181-1-g182150e71d5f
Subject: stable-rc/queue/5.4 baseline: 103 runs,
 2 regressions (v5.4.181-1-g182150e71d5f)
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

stable-rc/queue/5.4 baseline: 103 runs, 2 regressions (v5.4.181-1-g182150e7=
1d5f)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.181-1-g182150e71d5f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.181-1-g182150e71d5f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      182150e71d5fbec88cb77fec9ffae9ed1f8d7aa4 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6216d9dfeacedc2beac629db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-1=
-g182150e71d5f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-1=
-g182150e71d5f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6216d9dfeacedc2beac62=
9dc
        failing since 70 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6216d9a5a7f5668ebbc62993

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-1=
-g182150e71d5f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-1=
-g182150e71d5f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6216d9a5a7f5668ebbc62=
994
        failing since 70 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
