Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E92B6B003F
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 08:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCHHxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 02:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjCHHw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 02:52:59 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A247A02BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 23:52:39 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y2so15774000pjg.3
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 23:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678261958;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LKCSad4dCdfH1EqZHxabv6LFHKjBzUZD+D07nvt4i1w=;
        b=NrtsNdFjmqRVOwyfgkpZAKqfEy7f6NcYnP/5X5dwsSamZOsBzejoF4jhTrmJR5LUrX
         qrslFv2bcYjWHcAI31P3g4pBIdIKX9tHpE2rQmO2+FFYNInWnf9YdpxV0QrNYQsbvSlO
         KWNIN5RbGSP2z/EyW3mkFpZoxXbIiZwlO0phuqdR79tomgPp/cPAxGSmHi/MlQIwsHSD
         8tZYZ6fbfciXCtlfBMLm6xIzAHIR3TfSqz7W01vRS5y4cr7oIHpXtz1SpQAfpBSxP3+i
         ztU8F9lSHxn2gyISYvFvfx965g6TWIsSHIJjQKQMptvAinew5O0kY69Tch0yvChGNN3V
         v8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678261958;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LKCSad4dCdfH1EqZHxabv6LFHKjBzUZD+D07nvt4i1w=;
        b=FZX4+7b3ZAwA9GqvFnZPMgV5rzT37j0gvDn6aBH4EK3tuqIzwfbRI2KvN7XW1oosbt
         nHx0nw5OFvjFUE4BlRiHKq9tO4Bh6p2hvgiqgXQZi2e1FJ6zSPVZY1G7on9JCX20XLhy
         ijY3PJGtlCn3nKk6FbANf9mUNeg26h3X1Swu8hYJwkNYxfXaVs1W0VaTg6P6ZW6BJBB3
         k5v5aSHaFo64h92a95z5tKK3OG5n1t7K/pAIm9gD1IzLZ/p2esSseNxeaYwxg1YimrRO
         Dfxxx2fBpTXg/EfVF+GZhpkaAQKYT5zqb/+0dulh31qjmbHlAOy0ZmidISbasQwZZ4/t
         nRDQ==
X-Gm-Message-State: AO0yUKVjSsVezmBTCqTZIFxOSaUPeMKGUm9rWTYbbohn3RXdYmDyMxTt
        h6B+1HsOISiuBC+d8lqZG6HkSEXzsPXpQaYZCf+NUA==
X-Google-Smtp-Source: AK7set8bXWL7UaLr0t0KQwgvb51zGRZCxcgV+olqru6RWwgoWHJjrgBQ7fuWiRBTskaqPD44ll7RrQ==
X-Received: by 2002:a17:902:d509:b0:19c:65bd:d44b with SMTP id b9-20020a170902d50900b0019c65bdd44bmr21563988plg.60.1678261958403;
        Tue, 07 Mar 2023 23:52:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w26-20020a63475a000000b00502ea97cbc0sm8666899pgk.40.2023.03.07.23.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 23:52:38 -0800 (PST)
Message-ID: <64083ec6.630a0220.81af0.ffd6@mx.google.com>
Date:   Tue, 07 Mar 2023 23:52:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.15-886-g7ff82f8ebd2b
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 185 runs,
 2 regressions (v6.1.15-886-g7ff82f8ebd2b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-6.1.y baseline: 185 runs, 2 regressions (v6.1.15-886-g7ff82=
f8ebd2b)

Regressions Summary
-------------------

platform                | arch  | lab         | compiler | defconfig       =
  | regressions
------------------------+-------+-------------+----------+-----------------=
--+------------
bcm2835-rpi-b-rev2      | arm   | lab-broonie | gcc-10   | bcm2835_defconfi=
g | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe  | gcc-10   | defconfig       =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.15-886-g7ff82f8ebd2b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.15-886-g7ff82f8ebd2b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7ff82f8ebd2b276cf7467dcb449b8bb953a898c0 =



Test Regressions
---------------- =



platform                | arch  | lab         | compiler | defconfig       =
  | regressions
------------------------+-------+-------------+----------+-----------------=
--+------------
bcm2835-rpi-b-rev2      | arm   | lab-broonie | gcc-10   | bcm2835_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/64080a5a2a577f324d8c866f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.15-=
886-g7ff82f8ebd2b/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.15-=
886-g7ff82f8ebd2b/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64080a5a2a577f324d8c8678
        new failure (last pass: v6.1.15)

    2023-03-08T04:08:25.090926  + set +x
    2023-03-08T04:08:25.094755  <8>[   17.796056] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 123117_1.5.2.4.1>
    2023-03-08T04:08:25.211171  / # #
    2023-03-08T04:08:25.313003  export SHELL=3D/bin/sh
    2023-03-08T04:08:25.313488  #
    2023-03-08T04:08:25.415143  / # export SHELL=3D/bin/sh. /lava-123117/en=
vironment
    2023-03-08T04:08:25.415654  =

    2023-03-08T04:08:25.517424  / # . /lava-123117/environment/lava-123117/=
bin/lava-test-runner /lava-123117/1
    2023-03-08T04:08:25.518702  =

    2023-03-08T04:08:25.524614  / # /lava-123117/bin/lava-test-runner /lava=
-123117/1 =

    ... (14 line(s) more)  =

 =



platform                | arch  | lab         | compiler | defconfig       =
  | regressions
------------------------+-------+-------------+----------+-----------------=
--+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe  | gcc-10   | defconfig       =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/64080d9d90ccb867658c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.15-=
886-g7ff82f8ebd2b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.15-=
886-g7ff82f8ebd2b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64080d9d90ccb867658c8=
643
        new failure (last pass: v6.1.15) =

 =20
