Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB7855072C
	for <lists+stable@lfdr.de>; Sat, 18 Jun 2022 23:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiFRVxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jun 2022 17:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiFRVxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jun 2022 17:53:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462E512AA6
        for <stable@vger.kernel.org>; Sat, 18 Jun 2022 14:53:33 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w19-20020a17090a8a1300b001ec79064d8dso4160113pjn.2
        for <stable@vger.kernel.org>; Sat, 18 Jun 2022 14:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nY8xWz0GjPa4sigULfsVr67ydtnxAZoEqLJv8JSPJXA=;
        b=JH2Hv+JWPxZE0l9OeX91bs4F2Zl/Sgs4v0K4mri67PZWQ2HhWrQiNq2A2ttc6UWhR4
         wgmqZ9xNg0cvEsJ9okjTlzRk0OPVrStArOanJ/rwWE9pvKBcZDDwA8M8YdfY+8jboJvB
         r0LSDF24qNwV9R0BkNgeGr1ujxsnPhaLo2XHewd+yYFVz+7uZzRZ/MwoEfYBNOD20UpQ
         9ssuYTtovkbTwfQD6xeCUb/MVnQQ1iDYzUKSJRTk0HdyOOKRb31zLutbaAu5IfOyIxwi
         y63KU3tT/mxrqNXVgLHk1kXChoTn9GPrdVoGEYZD4Bd61CPxvakRuYwM3MWf5Ddv7kj5
         UWeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nY8xWz0GjPa4sigULfsVr67ydtnxAZoEqLJv8JSPJXA=;
        b=eO0y87WhQqz/A1BCURCOBF7uenIhcBX+mlkuNgZnAZpqy8c7T9YR95A4ruaCDVC84g
         TNMGjlGakAR7S7Tu26WNkXHFuFLs4ONCidq9cYSM5C2+wn8mWjJRyt6yFnrxSU7vUjCP
         sMwb4sjvQTLH456x4Tq9yuRGyd5/MPcGTCBmawyB2BQCscCZYhiPHwNxfG+Neq6wTEy/
         lwuBu5+85yPyUD3z0sZbxalJ+43IiSpV/01Bql1FLrgXWIxV0l/L+PVUQCMc2Xssyf7s
         FduWoow086Wn/nM5Mcc59kaZ1NuaJmsU5HLTK1MAIOdg7MOeUJ6FVQZLhNdEpXhqzIiZ
         aTtw==
X-Gm-Message-State: AJIora/sJzuIWmRJkUjcwNuXzbnR3t4zSIt3MZYmNsUqFJ+FpbMTdQzp
        47xCmEYC/7Xkatpx9ZwxFz6WVfd6rMdtTucvgZE=
X-Google-Smtp-Source: AGRyM1vIKmAvam2DWc5amM+BMyvwPfZz327e74oOTXkh8Y3EgLKevtOAmdTdeWw4YWMJ6Z3QpV4rPQ==
X-Received: by 2002:a17:90a:34c7:b0:1ec:91a6:f3db with SMTP id m7-20020a17090a34c700b001ec91a6f3dbmr2931983pjf.112.1655589212588;
        Sat, 18 Jun 2022 14:53:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mp15-20020a17090b190f00b001ec92c52285sm693067pjb.21.2022.06.18.14.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 14:53:32 -0700 (PDT)
Message-ID: <62ae495c.1c69fb81.7b434.0c70@mx.google.com>
Date:   Sat, 18 Jun 2022 14:53:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.5-51-g1c79ce42b8e0f
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 201 runs,
 2 regressions (v5.18.5-51-g1c79ce42b8e0f)
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

stable-rc/queue/5.18 baseline: 201 runs, 2 regressions (v5.18.5-51-g1c79ce4=
2b8e0f)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.5-51-g1c79ce42b8e0f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.5-51-g1c79ce42b8e0f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c79ce42b8e0f3e17e072e911d9bdb5eeb5f8d8d =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ae187b39f0175ae4a39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-5=
1-g1c79ce42b8e0f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-5=
1-g1c79ce42b8e0f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ae187b39f0175ae4a39=
bcf
        failing since 7 days (last pass: v5.18.2-866-g0f77def0f4d00, first =
fail: v5.18.2-1057-gd2f82031e36a5) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ae224f27c86d9228a39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-5=
1-g1c79ce42b8e0f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-5=
1-g1c79ce42b8e0f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ae224f27c86d9228a39=
bd4
        failing since 1 day (last pass: v5.18.2-1057-gd2f82031e36a5, first =
fail: v5.18.5-4-g941f74bf03b86) =

 =20
