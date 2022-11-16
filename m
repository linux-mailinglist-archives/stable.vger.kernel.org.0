Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C50562C200
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 16:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiKPPMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 10:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbiKPPMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 10:12:34 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655674E402
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 07:12:34 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso2649111pjc.5
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 07:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uBWqApedqeI7bQu9183vZKfnj29BKTCRyylVl+gpMeY=;
        b=o4d5rLaJAEd/JczMktA24kNKb18bIiryWrMKSK3MJfOEUnisFFYTNaLIkQgr/qLyDq
         xWYXxkKak/9sg5NJwYdUQ01ExZJYvgj76buh5DMcScYQsn41Srvp1FB62Sn0CB2fKFoE
         9p+KNOGresI4cLRvVKHzLYogsck0wdVbQ2uGoSYVmnf7DRhQCEF8BAFYTESNQmXjaeaW
         gKRf9GFsiCakQMifUdfL3Tq80htjoSVnhZ230z8twJ9Oxibz5zqsnetGIt/e3O/od71f
         ZbEhsBgoFJEz2TK3anH1u/TU3mDltO6XCeOi79/vpDCH+jFAeZbR77FdWbgSGwFoCxdH
         LyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uBWqApedqeI7bQu9183vZKfnj29BKTCRyylVl+gpMeY=;
        b=JMqpGDsH+QrZd9ROTmEeJxVvVCFwTZDIfcaHOCSvTuOZGlXxJ7+aTTPyTnGK1gpuMO
         n+DNDI98c1XYZMgDirSxz+9whUaPWDHNURavh5pTP7mqG3HlvaVBIUjOg+5x/QS1Qgss
         +RCGH6fVBQ+P9HfVHUGuezxo7ckwV0t1vuaT/Yc0xDgzsylbkcrijBn7Fsy9O9U331nh
         sFqtf2LO4hGZvkwsxt/dS8JrYn4L2hTuXon7ArCIf8Tpg/SSLbq6bha0GOueIP4uTxu5
         f+CJTaagyH+yuKcwSKx3UZ/67or+tV0+iA2TdIC8/vOqFJTQYrDFOGQ+DugH90fASmoh
         Ms0A==
X-Gm-Message-State: ANoB5plf1SU7PRXPIt2MDRP0tGxyE88T/q8b0qhQA31hIkHrjz40aP01
        Izj7iilHfLCch+zORbLreRBL/vx56GaPtSpU11Y=
X-Google-Smtp-Source: AA0mqf58kBLr+GXFbdmhowBSvbrZEAv499YHFaKKeCDMXHYsFRxYJKTQthDreStwVcX6FLXQ+a+yfA==
X-Received: by 2002:a17:903:260d:b0:186:e01d:8f2f with SMTP id jd13-20020a170903260d00b00186e01d8f2fmr9271838plb.40.1668611553765;
        Wed, 16 Nov 2022 07:12:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090a644f00b0020ad86f4c54sm1724283pjm.16.2022.11.16.07.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 07:12:33 -0800 (PST)
Message-ID: <6374fde1.170a0220.cc022.2904@mx.google.com>
Date:   Wed, 16 Nov 2022 07:12:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.155
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 130 runs, 1 regressions (v5.10.155)
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

stable-rc/linux-5.10.y baseline: 130 runs, 1 regressions (v5.10.155)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.155/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.155
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41217963b1d97ec170f24fc4155953a2b0835191 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6374c9c65865f54e642abd1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6374c9c65865f54e642ab=
d20
        failing since 1 day (last pass: v5.10.154, first fail: v5.10.154-96=
-gd59f46a55fcd) =

 =20
