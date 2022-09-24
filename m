Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2C95E8707
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 03:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbiIXBpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 21:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiIXBph (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 21:45:37 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A6DDCE90
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 18:45:35 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 3so1766654pga.1
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 18:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=N3nRayDjzXzToNS+UZMzOqgn+8EJ4epRRfJuJO7klYQ=;
        b=widvL/73j9b3c2yiiwTO2x1ewFDeBNcLGOxJ+kOFD+1tGvpAbXs4wWZMAGHOs739ZR
         VHC6tcvlFt7Lnth0/NDhC2AFgYozRZPEuXm1QxrR6UUYvnw4g7E5CGNNFDXMa+HklQi0
         ls3H6pv/ckhC98+cIFWKE8KA3Yu900FhNodbn1OQxxIorbt04GyCxUomEGHnrTDmkleH
         aypvtPH55xRH7gdurVF6PPTudQBgsLod9EiNyYfQwmroLSsxgZqeA7IlGyuR7/KaF9eh
         sSoe6Azx4ySgMNx978kf9M0EwhI7eRMuVWB7180Tl6LaX9VRoY97HQWr1B07xr316vFS
         J7LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=N3nRayDjzXzToNS+UZMzOqgn+8EJ4epRRfJuJO7klYQ=;
        b=gtChUTwSHBHRlEWH3CiZQ3gJZ3Fn5Mc5eK2RhZTW5IsDprmrvGLDp39Bvd3VZX50y1
         tnnltUlFNq720Hg0XuNVR+ih1zF74l7iP1j/wjyJd2bkNL7PIBKso7zwqtmgu/gAXcu2
         Kvcg7aCUMxnJeoRFMTHpulh0mznsTavpeWi1o3ihJj2OCe4ZVsZVzdmqXaij5+8hij9D
         jbJHf35l0yxLGmhAzTziMzHb+k2eOR94wzj6H+JbqCKXUIiOYV1wayxjUtDMGD2G/TOU
         /TZEVv6O2z41sERT7de7wWl3psfj5Jpub7hEUrHVkPkMONPP0QUxU3j+NjxKfdv4r3s4
         g5CA==
X-Gm-Message-State: ACrzQf2DALMBRNBTrFNXXJWY4hjew0IxknaveXrwQFKhYHndrvYUCMxb
        4RmplH8ZI9usquOZFlQSxH/EXEMvtqh2G2ycjaU=
X-Google-Smtp-Source: AMsMyM4/RrN8P9IO1MbODLd6M78qo8JELFH2znjVHQPPhj/lPlwExYfy82lS/dXruiKfQqqfKXal0Q==
X-Received: by 2002:a63:d30e:0:b0:438:c9c9:7d95 with SMTP id b14-20020a63d30e000000b00438c9c97d95mr9821334pgg.380.1663983935289;
        Fri, 23 Sep 2022 18:45:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z125-20020a623383000000b0052d98fbf8f3sm7072648pfz.56.2022.09.23.18.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 18:45:34 -0700 (PDT)
Message-ID: <632e613e.620a0220.1c2c7.eda3@mx.google.com>
Date:   Fri, 23 Sep 2022 18:45:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11-55-g9888f771c3a9
Subject: stable-rc/queue/5.19 baseline: 98 runs,
 3 regressions (v5.19.11-55-g9888f771c3a9)
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

stable-rc/queue/5.19 baseline: 98 runs, 3 regressions (v5.19.11-55-g9888f77=
1c3a9)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.11-55-g9888f771c3a9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.11-55-g9888f771c3a9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9888f771c3a964ede02767e7e913ede0d1d44f0e =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632e3069d56b9ae1d5355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
55-g9888f771c3a9/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
55-g9888f771c3a9/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632e3069d56b9ae1d5355=
645
        failing since 1 day (last pass: v5.19.10-36-g00099e2e5131, first fa=
il: v5.19.10-39-g0c9655cc6e1a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/632e31938e83ced9a035566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
55-g9888f771c3a9/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
55-g9888f771c3a9/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632e31938e83ced9a0355=
66c
        new failure (last pass: v5.19.10-39-g0c9655cc6e1a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632e304242bf318cbe355673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
55-g9888f771c3a9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
55-g9888f771c3a9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632e304242bf318cbe355=
674
        failing since 4 days (last pass: v5.19.9-55-g7dbe36eefdad, first fa=
il: v5.19.9-56-g29b6ff678b0e) =

 =20
