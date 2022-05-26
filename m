Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171F3535371
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 20:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348511AbiEZSiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 14:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348507AbiEZSiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 14:38:23 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E98A694A9
        for <stable@vger.kernel.org>; Thu, 26 May 2022 11:38:23 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id w3so2130551plp.13
        for <stable@vger.kernel.org>; Thu, 26 May 2022 11:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZOuJottT7HOkaCtaHw3o0/l/S1hqrOKbp4nm/dZd2R4=;
        b=mvC4KZESiwffUrxO6CpV5cEN730ngvuu0zWZxDOEZY0Aqgk4duFdSqXGjxsWQhOSJV
         i7CFe2Ak0KwcTe1WYggTuAlIC+aCRRv1vNLn65zfRvUUd1iBVoSF2hnuwVNWyDom6Thj
         e90oEeySMA0yDoVNFU84de4aVvx/C1G1YUAOM70UXtiFKgwLZDpA5mnU8PTQi+MWtKTp
         1T/7N5mWbsAZEtGsY9Xp6XJ0sep4049p9GlFKWQb18PlYxrbTXIIIoCatNzFH1JmTy6a
         +S5Px07TsP8bn1rzy7QVIzOV504TmsG9j4et8c+prl66tTwcuy4sO69mMFCggOgKaJBd
         WbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZOuJottT7HOkaCtaHw3o0/l/S1hqrOKbp4nm/dZd2R4=;
        b=vCBAqmpIYQmGVW38AVzCl5O+wnkR/CXHRbdFDgu4YrdDHV4EiBMk8ByhNVnZRdVDyY
         UtojWdkzZzhxEVmweKs6hjUa27BqJ+J4/FWPdsxh8BXWDyVYWwhTHWF7u0jsR9RKZrKc
         BhPIanSS9f5jM8rA4c/vg9MZTHlfz3f2pkkOOeKJ07qWy69bASRahoUCtU4KdDyuQcDq
         NUtt+8yO7E3E0+UD4A4mz+FDgwICSaH8bEVFcvXWf/cLvZVP20vHKpE0GT0iPrv7HPtA
         8qWWSx+UNzVpuGsZ4UuNDpKJMH0kLziD+qihuokWGsUjKlVb+LNJoV/taMt7guN7fkdx
         O3bg==
X-Gm-Message-State: AOAM530u1TkoQYG8sK4pSM+ddXz4ZaT3O4tWJVSUCDgoSLq/HFYQCBqa
        deN9MCmmh8nQvAUbzVrKNjcNsEcicI3KKsL6vMY=
X-Google-Smtp-Source: ABdhPJyRAIpAZ5Dfi427G7rmbHfy3BrB3uS2miUJZspwQcAn/+sKrDTXPqxqVI2RkdGSBYbnYYk2Uw==
X-Received: by 2002:a17:90b:180b:b0:1df:b2ac:faf9 with SMTP id lw11-20020a17090b180b00b001dfb2acfaf9mr3949824pjb.150.1653590302415;
        Thu, 26 May 2022 11:38:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m5-20020a63f605000000b003faebbb772esm1878612pgh.25.2022.05.26.11.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 11:38:19 -0700 (PDT)
Message-ID: <628fc91b.1c69fb81.d1d99.46da@mx.google.com>
Date:   Thu, 26 May 2022 11:38:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.11-2-ge8ea2b4363353
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 114 runs,
 2 regressions (v5.17.11-2-ge8ea2b4363353)
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

stable-rc/queue/5.17 baseline: 114 runs, 2 regressions (v5.17.11-2-ge8ea2b4=
363353)

Regressions Summary
-------------------

platform      | arch | lab          | compiler | defconfig         | regres=
sions
--------------+------+--------------+----------+-------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | at91_dt_defconfig | 1     =
     =

jetson-tk1    | arm  | lab-baylibre | gcc-10   | tegra_defconfig   | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.11-2-ge8ea2b4363353/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.11-2-ge8ea2b4363353
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e8ea2b436335375f0bc1fb85162563ac231e1f60 =



Test Regressions
---------------- =



platform      | arch | lab          | compiler | defconfig         | regres=
sions
--------------+------+--------------+----------+-------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | at91_dt_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/628f8df83545fe33faa39be4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
2-ge8ea2b4363353/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
2-ge8ea2b4363353/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8df83545fe33faa39=
be5
        new failure (last pass: v5.17.11) =

 =



platform      | arch | lab          | compiler | defconfig         | regres=
sions
--------------+------+--------------+----------+-------------------+-------=
-----
jetson-tk1    | arm  | lab-baylibre | gcc-10   | tegra_defconfig   | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/628f949779674040eea39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
2-ge8ea2b4363353/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
2-ge8ea2b4363353/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f949779674040eea39=
bd3
        failing since 2 days (last pass: v5.17.7-12-g470ab13d43837, first f=
ail: v5.17.9-158-g0fff55a57433d) =

 =20
