Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D546AF4E9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbjCGTVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233866AbjCGTUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:20:46 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B4B76F64
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:04:40 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id a9so15170458plh.11
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 11:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678215880;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=TkzU8KfCvMr/GoiUJc2wEn0IzlZD3UoeCxWyCQ5m+44=;
        b=oIpsjXxnBAi1Se7QKspbgOIUFdgh/zGHLfwXuowLsM4JLBwJzIyGEbmR0P3TtssWD0
         RkNv+JoXF0zOsLpTPurU6Pa/WnIZbJob0JThbxHIRLYAFdp4/Rn5kzVJj1Qc8f7mo9IV
         Ce69ao3EXXZA5rtaMZgx3A0fgjL4S9jN80qu4F7+72EKiZHvrD03obapRcFnPHFuNVho
         Vq4TOqI851DYSYJtDfb0fhLiwR60iiToUKc5F7Mtm8dYgj5waqgPn/wcbrej0+KwpcqE
         QyMM8+DJHJBnW2bJwr9EWpZE9KLavP3NotSNFYoqXhcotw0fFOx/s+Ul4jXzXox1f6QA
         lNHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215880;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TkzU8KfCvMr/GoiUJc2wEn0IzlZD3UoeCxWyCQ5m+44=;
        b=EMyssena3+gqAo1s3wmZZPUKRLTSxF6n5MoWVjCJ1VBCP8hR2GzrVoritONVHL58yx
         OU7EaheFjq/z/Fn4iymQr+LH4vpQ2liQoFZNOdpGQOIAM0+Jy3ZnXqiTqRCLBAr4fIBY
         /3gXhAJho8OSd+hy0dtqQxf2TIndCkjWKoNn1q829hx8SjUhNSo3ZRPzvoDVO2wZI1Ke
         KyvlnzaCIGCIrYiXAjkBjE2jn8Cc2P7Oz83725TNBlDVLaNYc4deEoaSRE27I50s3K5B
         8XEWURs6TxglH2vfN5syQRZgNafUuQFGGmWzmEn7ln8q1gyQJrKwB8qzcAFD795TkVyI
         dh1Q==
X-Gm-Message-State: AO0yUKVFlvgNd4jGYaOXGW2IP2et/GNC6pMpbDB5uP8uPe3Y6c3cpKOl
        FiP7/ai9oQoQy7ei9rKANlXzHiJqDqVggV0wjiU4YO2x
X-Google-Smtp-Source: AK7set/fDmhLo5vodpyhFfVLOoLCmiDri3IyVXrKi/tu5JrqVuHl5AaVDRdS2sOEkNc4IXKa9PiTvw==
X-Received: by 2002:a05:6a20:898f:b0:cd:f17:5292 with SMTP id h15-20020a056a20898f00b000cd0f175292mr16332758pzg.44.1678215879781;
        Tue, 07 Mar 2023 11:04:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k8-20020a635608000000b005033e653a17sm7936675pgb.85.2023.03.07.11.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 11:04:39 -0800 (PST)
Message-ID: <64078ac7.630a0220.b27b5.e029@mx.google.com>
Date:   Tue, 07 Mar 2023 11:04:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.15-852-g8c53975a36f6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 183 runs,
 3 regressions (v6.1.15-852-g8c53975a36f6)
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

stable-rc/queue/6.1 baseline: 183 runs, 3 regressions (v6.1.15-852-g8c53975=
a36f6)

Regressions Summary
-------------------

platform               | arch   | lab          | compiler | defconfig      =
   | regressions
-----------------------+--------+--------------+----------+----------------=
---+------------
bcm2835-rpi-b-rev2     | arm    | lab-broonie  | gcc-10   | bcm2835_defconf=
ig | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g  | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.15-852-g8c53975a36f6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.15-852-g8c53975a36f6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c53975a36f6594d954f0158fe1d05b1dd22356a =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
   | regressions
-----------------------+--------+--------------+----------+----------------=
---+------------
bcm2835-rpi-b-rev2     | arm    | lab-broonie  | gcc-10   | bcm2835_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/64075a81b3e36c4a268c8638

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-85=
2-g8c53975a36f6/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-85=
2-g8c53975a36f6/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64075a81b3e36c4a268c8641
        failing since 0 day (last pass: v6.1.15-660-g430daf603d29, first fa=
il: v6.1.15-782-g0dcd2816cbbf)

    2023-03-07T15:38:32.096991  + set +x
    2023-03-07T15:38:32.099871  <8>[   18.044127] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 116286_1.5.2.4.1>
    2023-03-07T15:38:32.214369  / # #
    2023-03-07T15:38:32.316110  export SHELL=3D/bin/sh
    2023-03-07T15:38:32.316584  #
    2023-03-07T15:38:32.418015  / # export SHELL=3D/bin/sh. /lava-116286/en=
vironment
    2023-03-07T15:38:32.418364  =

    2023-03-07T15:38:32.519676  / # . /lava-116286/environment/lava-116286/=
bin/lava-test-runner /lava-116286/1
    2023-03-07T15:38:32.520181  =

    2023-03-07T15:38:32.527637  / # /lava-116286/bin/lava-test-runner /lava=
-116286/1 =

    ... (14 line(s) more)  =

 =



platform               | arch   | lab          | compiler | defconfig      =
   | regressions
-----------------------+--------+--------------+----------+----------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/6407580be40460b17b8c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-85=
2-g8c53975a36f6/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-85=
2-g8c53975a36f6/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6407580be40460b17b8c8=
63f
        failing since 2 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =



platform               | arch   | lab          | compiler | defconfig      =
   | regressions
-----------------------+--------+--------------+----------+----------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/64075a96f04e44f4e68c8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-85=
2-g8c53975a36f6/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-85=
2-g8c53975a36f6/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64075a96f04e44f4e68c8=
644
        failing since 2 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =20
