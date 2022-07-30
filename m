Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E119E585796
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 02:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiG3AnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 20:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiG3AnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 20:43:15 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED6C2F39D
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 17:43:13 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c3so5918776pfb.13
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 17:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OqVNbo/n4zPEGytgzlTZ62eXJDiw/INPurEFDTwkQMg=;
        b=A3wNVvcwSuuTCNEgKoFHcIW9FofRsAdzs/gQG6S8rcOBrfLoWdohAH7c9qZh1NHqm/
         BGWj52qnQivRVaDzGcOUY+QMjRETqz1lfdvMBVI9yaqK/PmqcQX2sGxMfb+oSALkfy01
         U+x7y+hm8nwdd6ZwD95sYvx2YLv8Dk2ysa/cIrD/mhxntTS8OCN/3z9Y4vCU2ejRCqBf
         kJF7EJ2UFgxT9ehuBcwiG7gOUaoe1RwZv/CLn3SjRo47jZjEAE8nFW9FbylVZXtJ/7xx
         fBKBFzP6X2nQHdKcN4++UDVwGK+lUwfVABsES9ZeV1Ly3uRaIxYSIAzqq+z/fdLG29W2
         hbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OqVNbo/n4zPEGytgzlTZ62eXJDiw/INPurEFDTwkQMg=;
        b=bJPCaj8JRlHS6Yr0FLiAFdXUHfyRMj1ieFR2l6DPKIENkqRvmcFqGA9DKF5G7u+3uy
         QM1+ZKfxCn7Cv4MWN3XLt1twiOrHYDx/eDan9+Fs+Rs5qohvowX7urYarShJQ+Tu2bD9
         vYAiUiMxs461IbHsBjBvpDlhBalRnYy5vjTlb4zYDY2Bs4XwftseAj5cvIfs67RcFQS6
         blUbwVrWXqTNM0l7G/GGuq93Yk8vyJtMZiYbBJcOLgFxFmYlmPUkaBMFFJ+y0fvHTLAi
         eaT4lIGdckA3d1zWac1nKP8rpsj7guVAePz6vwl4fF9PBUlI2ukBhTz7sqb/RGlOIhk/
         CuqA==
X-Gm-Message-State: AJIora9OygHx9nTU2jXtyEgwM9chVv+6vTH1V46lsGi0rQ2HX7Y6zzfl
        XMIUZlfzQz2zQ3NPCL//4cAhLG73OI/0qZ9TMPQ=
X-Google-Smtp-Source: AGRyM1vN7scmuMNPfuHYjBb96Mdj1hVQzl24iURYB9kl+lflSkCwS4EdS3vxVXYWCxuBKy0HGtknFQ==
X-Received: by 2002:aa7:8889:0:b0:52a:f05b:31f5 with SMTP id z9-20020aa78889000000b0052af05b31f5mr5896705pfe.69.1659141793274;
        Fri, 29 Jul 2022 17:43:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z12-20020a170903018c00b0016dd0242e04sm453854plg.276.2022.07.29.17.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 17:43:13 -0700 (PDT)
Message-ID: <62e47ea1.170a0220.72af6.0ea5@mx.google.com>
Date:   Fri, 29 Jul 2022 17:43:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14-158-gfd1e19d579fb6
Subject: stable-rc/queue/5.18 baseline: 79 runs,
 3 regressions (v5.18.14-158-gfd1e19d579fb6)
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

stable-rc/queue/5.18 baseline: 79 runs, 3 regressions (v5.18.14-158-gfd1e19=
d579fb6)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
asus-C436FA-Flip-hatch | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

hp-x360-14-G1-sona     | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.14-158-gfd1e19d579fb6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.14-158-gfd1e19d579fb6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd1e19d579fb67ae40c53f1f2bbe67a4f534f972 =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
asus-C436FA-Flip-hatch | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e448b9e76061a105daf0a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-gfd1e19d579fb6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-gfd1e19d579fb6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e448b9e76061a105daf=
0a7
        new failure (last pass: v5.18.14-158-g3182404666adc) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
hp-x360-14-G1-sona     | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e44639d2b21517c5daf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-gfd1e19d579fb6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-gfd1e19d579fb6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e44639d2b21517c5daf=
066
        new failure (last pass: v5.18.14-158-g3182404666adc) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62e44c9d4ac2c5442bdaf0cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-gfd1e19d579fb6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-gfd1e19d579fb6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e44c9d4ac2c5442bdaf=
0cd
        failing since 23 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
