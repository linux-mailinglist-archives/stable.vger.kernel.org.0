Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C545B501AF7
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 20:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243701AbiDNSXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 14:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbiDNSXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 14:23:36 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485C22AE36
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 11:21:11 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso6461104pjj.2
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 11:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MwqIiSsE4IjuwhoxK0A0JOp3+yMedDNQGZWeK1wnAgA=;
        b=0ite6iNiJ6BKJ2UOF89oHF4pu5ulk42JtgSWxRL+vVU2APfxCRVpmxj13rh73R/Tu7
         0oQCsN0N4FTil/3SvMzja6blLrPe2FDqC/hCOAAZ9hkduyG2EO8FpyM/U1ZmWqrf+6k5
         txCSFaMMfM6Z3l0fESdMOcIQ/lUUvgHAps+pFW3SnryF+X2rUcNC8dqUywC20aNuc/3U
         x/qSfrqhni7nsEFn0o/okgt4ApJ5Jmgf/5+jEDzN+H1freq93eECvyygmw6gfuTixHrh
         gPoLAP3wSyseVE7zotjcFRFz1eHYIlXjuryZdrCBg9rsgv56SnGxG1ZIAlZR+PYBv418
         kTPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MwqIiSsE4IjuwhoxK0A0JOp3+yMedDNQGZWeK1wnAgA=;
        b=WfBHYCh9O5ALRYEpdvk6uP6jnkJI1lIru4mnb3yNt2eSMs/6EOZuQ+MdK1riwwtNuw
         F48AchxiboM2UJky5sag7AzJ5BYWC2HANC7aWok190hL57S2umbHuCInQDRLQCJ3slL/
         GLBIj7+kEF/kgVFt2uLtNnNMBK7SMs/lFNu5tNiyq7oy8KwwrngcyK93QYO7LvSGgu5G
         K9ZJB7aXreODH7HEx40MKTO/Wz31gsLDbcGxPTqxzEyF4xCdAijUFMM8Iu2p9/1KxwPi
         myd8sYy2EJly+rPPTLcwTNHa9H07GjscjtENhlaCv3jSzbKWGgHJIIIkPFa9hlW2GI34
         7gsg==
X-Gm-Message-State: AOAM533eBHJiuGbnUZUwN95UNSYw0P2zN3Y4xzoOY8PmBDneei+O0DPU
        bwZib/oKSuBtqdiu+8F4gFAzGHbQssK9x4L1
X-Google-Smtp-Source: ABdhPJzdgcWQH6AOdJxO7ufsOGjO573gI5t93ZLcHf2Olq5jFjfkKr6PySZYIJ46IEqIaynebcvGqQ==
X-Received: by 2002:a17:90a:7f94:b0:1cb:1853:da1b with SMTP id m20-20020a17090a7f9400b001cb1853da1bmr5020429pjl.14.1649960470570;
        Thu, 14 Apr 2022 11:21:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v10-20020a63ac0a000000b0039901c45810sm2633781pge.47.2022.04.14.11.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 11:21:09 -0700 (PDT)
Message-ID: <62586615.1c69fb81.9fa9f.76b8@mx.google.com>
Date:   Thu, 14 Apr 2022 11:21:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.3-7-g214113ee8b920
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 94 runs,
 2 regressions (v5.17.3-7-g214113ee8b920)
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

stable-rc/queue/5.17 baseline: 94 runs, 2 regressions (v5.17.3-7-g214113ee8=
b920)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =

at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.3-7-g214113ee8b920/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.3-7-g214113ee8b920
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      214113ee8b920f110a1d0724e48c9b4ca1c9457c =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6258319be4cccf7af3ae0695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-7=
-g214113ee8b920/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-7=
-g214113ee8b920/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6258319be4cccf7af3ae0=
696
        new failure (last pass: v5.17.2-343-g74625fba2cc43) =

 =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62583304b58d4e0b17ae0684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-7=
-g214113ee8b920/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-7=
-g214113ee8b920/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62583304b58d4e0b17ae0=
685
        new failure (last pass: v5.17.2-339-g22fa848c25c53) =

 =20
