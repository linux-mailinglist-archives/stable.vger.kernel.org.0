Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9975BC1E2
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 05:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiISD5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 23:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiISD5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 23:57:20 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A41515835
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 20:57:19 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id bh13so25649881pgb.4
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 20:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=AqEGLahRBRMLmxxkIMgo+ZfnfrhG6zA0HFulYqG3qVk=;
        b=DpqNvtuWyKLNJ6/Ez/h/Jezxg6R7r+6heKgW8KLidzvTy8Jmo83ttAWSl+RVve1rg9
         H5NJhdTjHJwLnhrHfKCQhBVirZN2DOWov8RzmPYmhonXgiAbux3qBbs+7waV1x/N3786
         X7GhqQSzeaQXf66I+JVzRkMV0l/trdXHa39Duf04fF6s/SJltPgGND3ymOHpF5nMjd8c
         OGPTt741R+eLatt4JO8m0wIOAzdFEFw599RSFt776DWbVr5yk522BRDpTEOdBPMbEZyG
         8QQPbAfAradZp9+4DdyULBpyYvJVaWuNBox18cW2TPNRTsuYhzvqTmFOrRRisR2OXLDb
         j8og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=AqEGLahRBRMLmxxkIMgo+ZfnfrhG6zA0HFulYqG3qVk=;
        b=snV2WGkCNQ2Lt3YYQuEXAtKsb79k2BesfiKYMrvhD67hdG/Ur/sMcpEVG2LDWtyWl0
         r8mAzRa9dTmosW+pbC1/DkLHxdbe+x+RFM8HtTBNJU55z7dHVUjW6v7tfGE7mRWta0v8
         hPtCutRIDowtBlAto2Qm6w2gE0fxtkKOmLtqhcEP3n1RHVIbDWuX8dziuZN42rUJy4LX
         Wwsc5Qw6r3yQQDQajegGfVhKa2I5rEf4X7e+6tKf0vLxacs/zjnT4Fg+dDNkBTPXKRb8
         MzixPNkSyeYu7ez7sC0GKNo10B4oYhHavIhHsYO0+UojryJZkg3cjsPJqX2XzR+fzvOQ
         lL1Q==
X-Gm-Message-State: ACrzQf3XziFuEHHBEFVASr6dBQpvfkeUKxF6sDw45JaQXUjcrRXo14Uw
        wYNBPPg1joR5rMP+gFMJaBlm8e1XtGh9/ZgZ+HU=
X-Google-Smtp-Source: AMsMyM5Yuwmx4RWtUk853LuCWZCRmAO9NVUbGWTkEKTu6GxydXNnJhn8a/xguy72OcjSMTR2Rc36LQ==
X-Received: by 2002:a62:170b:0:b0:53b:93dc:966b with SMTP id 11-20020a62170b000000b0053b93dc966bmr16956472pfx.29.1663559838653;
        Sun, 18 Sep 2022 20:57:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d12-20020a170902cecc00b0017305e99f00sm19659957plg.107.2022.09.18.20.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 20:57:18 -0700 (PDT)
Message-ID: <6327e89e.170a0220.70a94.2b9a@mx.google.com>
Date:   Sun, 18 Sep 2022 20:57:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.9-55-g7dbe36eefdad
Subject: stable-rc/queue/5.19 baseline: 197 runs,
 2 regressions (v5.19.9-55-g7dbe36eefdad)
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

stable-rc/queue/5.19 baseline: 197 runs, 2 regressions (v5.19.9-55-g7dbe36e=
efdad)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =

imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.9-55-g7dbe36eefdad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.9-55-g7dbe36eefdad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7dbe36eefdadab89a60b948f0c1fef2347dd897a =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6327b61c7a0440ef45355684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
5-g7dbe36eefdad/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
5-g7dbe36eefdad/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327b61c7a0440ef45355=
685
        failing since 6 days (last pass: v5.19.8-181-gaa55d426b3c1, first f=
ail: v5.19.8-186-g25c29f8a1cae5) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6327b691af5a87fa2c355665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
5-g7dbe36eefdad/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
5-g7dbe36eefdad/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327b691af5a87fa2c355=
666
        failing since 33 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =20
