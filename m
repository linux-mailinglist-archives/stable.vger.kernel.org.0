Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75B753D40D
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 02:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiFDAUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 20:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiFDAUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 20:20:55 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291B95932C
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 17:20:54 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h1so7855346plf.11
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 17:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A2GfEm2k+DcqSI7482Lr60vKNEHFOk0JCK7bNUNr3bU=;
        b=k8JJfAurUV1rW94i6aPlTr80UnIJGzlfVv8e4wxK+k06lEjQlV0sibqbdOepxI8NCI
         3m8xMS7Fx90Hw585OecRa9HAF2If35m1hHJ34gLGs+gWCkSIQkYnmVFU6VsjAvSSMsjM
         AObtzv+HR3/+c/68HYXg8iMwAt2S2vXiNR2obcX99PulqKyvPjRbhUf7ku9+7SEogJQS
         rNEn8utuzxVSbXmJf4xh2AoyAZpYj+qTy01aBmxa/sJ/DIQh0b9eR9DIlVr0suUTsNNL
         USZ/RulH0NnPwtbl8m13ziXCs/pzAPleMYSpselskdeseEHwcEzuNReaR8jQ85NQLlO2
         YpHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A2GfEm2k+DcqSI7482Lr60vKNEHFOk0JCK7bNUNr3bU=;
        b=rIG4lowi0UMa5mWOG4aFSLrYv/7uGv/Jyz22abuFfgzLRQA+OYDY1rHo6Ah81jsiiG
         ayGEretYxoLr4CD2tiSq5rKkFxt1cjok+JgXWyygPttEPdTxZXZ9O275bTfxPWtFMQ2x
         Rdb7TaI/qSv3x2N2GG3AomaqzEYfGODklb7nyQUrOOUyUDahfpOxH+OpJc/9p6tLuNKO
         uaZYpCAHL9N9F+BEEXgDXK97/WQdmlzvGlf8eEevTtUB1F4q0Q9rGyiktQrpTTRB3jEj
         4g3xy5nzKGbtwM+FdAKzYws9L0dE/9qehdlVZD84wHphhkgb3URqE2lL1t4EuhNpcq3/
         iojw==
X-Gm-Message-State: AOAM531vRd/ZYSMbj/5SLXQqXRMuGzZEgcjzzZcsthLbXvTb6Bca6wrG
        R30w28xfCsRNpfdjB8x8xtHa2RKsSSXpQJgP
X-Google-Smtp-Source: ABdhPJyA3qspoqTdwi18JcBtp7WhQjDO0Tu92rgOeCYUC+VMfGT9SwFLBewMxKZvRuZtR1dM/88bZQ==
X-Received: by 2002:a17:902:bf45:b0:163:ad4b:dde9 with SMTP id u5-20020a170902bf4500b00163ad4bdde9mr12137561pls.25.1654302053568;
        Fri, 03 Jun 2022 17:20:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g7-20020a170902934700b0015e8d4eb1e5sm5906814plp.47.2022.06.03.17.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 17:20:52 -0700 (PDT)
Message-ID: <629aa564.1c69fb81.e6675.d9b8@mx.google.com>
Date:   Fri, 03 Jun 2022 17:20:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.11-188-g30200667e8235
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.17.y baseline: 68 runs,
 2 regressions (v5.17.11-188-g30200667e8235)
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

stable-rc/linux-5.17.y baseline: 68 runs, 2 regressions (v5.17.11-188-g3020=
0667e8235)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =

jetson-tk1         | arm    | lab-baylibre  | gcc-10   | tegra_defconfig   =
           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.17.y/ker=
nel/v5.17.11-188-g30200667e8235/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.17.y
  Describe: v5.17.11-188-g30200667e8235
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30200667e823559c51baeb2bd95c14b144cd8e5c =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629a6faa049fd54f0da39bd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
1-188-g30200667e8235/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
1-188-g30200667e8235/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a6faa049fd54f0da39=
bd9
        new failure (last pass: v5.17.11-112-g118948632858) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
jetson-tk1         | arm    | lab-baylibre  | gcc-10   | tegra_defconfig   =
           | 1          =


  Details:     https://kernelci.org/test/plan/id/629a73e509d682164fa39bed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
1-188-g30200667e8235/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
1-188-g30200667e8235/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a73e509d682164fa39=
bee
        new failure (last pass: v5.17.11) =

 =20
