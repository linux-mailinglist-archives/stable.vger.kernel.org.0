Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80269548C4C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352516AbiFMMpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356826AbiFMMos (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:44:48 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC68A612AA
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 04:11:21 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i64so5440354pfc.8
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 04:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5+YkgqSMWZf2s+6R/3h4KZ7isX9pYx/lJA2Ke3EpLT4=;
        b=Y99qWuQNlSDFKKSM5abZgECje6aK7AHvlIMuyvlWnBVutagRPn3UMtObgJEgBiMKKH
         WD4BBKaovvAqZOe96Oqdyyg1taiZNbJPYWkXd40ArX/pezteu7zyquHkXgiGrjczaqJr
         +hAP2M8yk7mAyVUTA+7k8JY0W4A2a10ZqIebZQDE3WFIrRq+3uuILqYIEToulww2+Bw2
         Gd1f2+WeamL+MQQ+z+qobb/t/ezwgaMS110bxncsvg3RbU5acrunG32V+FsJwPMcZ3l1
         P3HFHUq1f5EB+fvcUSA78uqNwzwr6rDq6CUORUzmWHTb92Tct3+LjU0zeqX7qP0pfUwk
         L3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5+YkgqSMWZf2s+6R/3h4KZ7isX9pYx/lJA2Ke3EpLT4=;
        b=uu5m1rGJT3cqPPa6XeawA/p4SryMCaXtPjiUt+L3sVCAYeO+pcR/NB37vHexl6Lmm4
         1K+qiWf3mMw3raUsu7cc4yMsl9ajmAYT/2v2KpF4V6KiZ6NfvY6RE3dHTax0YurziEnY
         /0RhxWUgte0ELwf8xPg9YFaCzTBFte7aDxSoJmqsaW5hfOXPruuu1B8VRsSnToQ59BXR
         Jg6Y4mCUO4O7AwOE5dKIq/lAw+RCV2Qw0L20Ls0N5gZsy84pv8EqUak8isacRD3hTcK0
         sDhISYHSzLDtBt+cQdpDgnSVB8b3zn15jbl4Quu+KA1hjQB/c4W+hILq5GVBD3tjeasN
         ehLg==
X-Gm-Message-State: AOAM532QX/I9rMYN0LRLn8vpjfAr6Q1FEm2TyaFkgwdr1PRVaOaZOT4b
        u3GX6iTwhkkixqdD+jdx+x4dI6exWFRysNKLdF0=
X-Google-Smtp-Source: ABdhPJzq2XhXKiVDW0kTZFC8fw5odWLJc7gUBOAQk1a+5yGdJLLUNxpQZjWaWDSWYcvMEa/EHvUpJQ==
X-Received: by 2002:a05:6a00:1683:b0:4f7:e497:6a55 with SMTP id k3-20020a056a00168300b004f7e4976a55mr59351721pfc.21.1655118679796;
        Mon, 13 Jun 2022 04:11:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 130-20020a630188000000b003fadd680908sm5155955pgb.83.2022.06.13.04.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 04:11:19 -0700 (PDT)
Message-ID: <62a71b57.1c69fb81.154a7.5d07@mx.google.com>
Date:   Mon, 13 Jun 2022 04:11:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.13-1029-g0132bdf6be9af
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 183 runs,
 1 regressions (v5.17.13-1029-g0132bdf6be9af)
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

stable-rc/queue/5.17 baseline: 183 runs, 1 regressions (v5.17.13-1029-g0132=
bdf6be9af)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.13-1029-g0132bdf6be9af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.13-1029-g0132bdf6be9af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0132bdf6be9af8a1e1bd5cc7f587b740a63b2402 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6e6e8e53a5bae8ca39bdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1029-g0132bdf6be9af/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1029-g0132bdf6be9af/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6e6e8e53a5bae8ca39=
bde
        failing since 2 days (last pass: v5.17.13-907-ga980fa631e355, first=
 fail: v5.17.13-928-gfe5fcee7b41f8) =

 =20
