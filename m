Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C335762CE
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 15:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiGONav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 09:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGONau (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 09:30:50 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3EA37FA7
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 06:30:50 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b2so3240816plx.7
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 06:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aIUdkqdE7yzZ5x1YKtQSz50R4sU7oJTTfipxxjmhwBA=;
        b=p7vfH5dakRVYtwuojEWTNrXwlLGwzzmhvy5kkXJ5Xtsm9CRSpv90esZhn8yg+w3cMh
         jlzNHmenfqVt5PdGdFLAPYX7aB5zO65iyskubzpfcbuynexSwj/AC5SzQudvOipHv1am
         O7beLh2TKUq3kHHd9c9FHqEeiWdtRrGIrvBpatCApEQORdoeMTxT2PIczyNJYISks5IL
         Ke3JTWNSa+A892nqt7XBx85bafMOTqsh+kmQvS7x6KZol1+5MaLIudc+tuZGN9mgVY1U
         CfxeDz3ZAOCVKB53M82GGLlYPYNAwSq+0e4mxotJIN2aZWWTwgdvISAEENhH8bmKpsU0
         e6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aIUdkqdE7yzZ5x1YKtQSz50R4sU7oJTTfipxxjmhwBA=;
        b=yrtCJxEE681htwXLRu/Vhk/uhm1GhF5SaW0hZnos9sIMIMhTubYjobyOeNuYn6hwkV
         7igG4Y758abD/wThHWUNeZ16NlRKu8hiV2l8UID+66HIiqZ8hL7kJ0mV7jzEz5Qt+v0Y
         XxkIh2wWNrI5Tv3yaO7RYgArA25b2Qoq4YdbozsGS88ThJUEHVPZOPEQ+pEFllIsCtbr
         xp+RbfoSUSyKWZ6OVHNhYDvCuc6gjWv3bi/NR20EnFijp7OMH70KF/I3z5K//cC6q20u
         HtPBqaV5ERIqIIT5EM2odaBw8pMZtjpT6yUnq8gMU9ovNHItvCezuHv+h/XCbUqz01D6
         FhIQ==
X-Gm-Message-State: AJIora9zOSufUZoFNoWvGti/1N6gL8a0Pd+1ybgKfV7FqxKNHe65jIkm
        gF64KaKt3c9u4oqT5yB3wuR/0G9MZ4JpBhnn
X-Google-Smtp-Source: AGRyM1vYJ46qU8XdHo/XJtOCMAySv9ZI/w0/JCy/8x5uIVATQDj4q7wIofLSLit/qVHkqIGZpT3Vxw==
X-Received: by 2002:a17:90a:bc8f:b0:1ef:845d:d34d with SMTP id x15-20020a17090abc8f00b001ef845dd34dmr15944108pjr.118.1657891849458;
        Fri, 15 Jul 2022 06:30:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa12-20020a17090b1bcc00b001ef8de342b8sm3550503pjb.15.2022.07.15.06.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 06:30:49 -0700 (PDT)
Message-ID: <62d16c09.1c69fb81.5593b.56fd@mx.google.com>
Date:   Fri, 15 Jul 2022 06:30:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.130-1-g05215305b554
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 56 runs,
 1 regressions (v5.10.130-1-g05215305b554)
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

stable-rc/queue/5.10 baseline: 56 runs, 1 regressions (v5.10.130-1-g0521530=
5b554)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.130-1-g05215305b554/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.130-1-g05215305b554
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      05215305b554db793b3d034d3292edbd33fcb0c4 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62d138b38208bf27fda39c00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.130=
-1-g05215305b554/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.130=
-1-g05215305b554/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d138b38208bf27fda39=
c01
        failing since 1 day (last pass: v5.10.130-131-gb71540e08722, first =
fail: v5.10.130-132-g59d697b2ea179) =

 =20
