Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3C458578F
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 02:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiG3AgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 20:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiG3AgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 20:36:11 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB661CFD1
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 17:36:09 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o3so5923973ple.5
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 17:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QlEeNdx4CPTflXPzs39+Mo6S4B7YlV8AmW7Xw4clxvo=;
        b=RM7tdZSz6xL14k+chU3WSGQUdt/7tZDOaLGqPmgTXSvJ5PMi5bBRqyNJdfvYFsrZgD
         I2KXFfqrbadKttw7w9kompaW9Yv92N0gdEX8nP+B0qepzgiQ+ShK4noWsUU9ctxyo44K
         GVwJCMMed3LRwpp2+kwXnZVRdE3jh5ZiFDWEsvTAYjOUK8h/lyYYt2GssAF+nwGp80NK
         FYBFVPxW2mWUkATOWN6Vlj6HQGqrPbxX7MJ01T4kI+TV11cdvNpBDRuSy5Wu7L5k2LQc
         lSuzh4f90ZLJKFSv+yzVkTx66SOLDiuFTHGX1hZ6IDHGSrgGu9TNhmHl60og4HS03wVo
         wdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QlEeNdx4CPTflXPzs39+Mo6S4B7YlV8AmW7Xw4clxvo=;
        b=YkuLSoRmYMCxBZ0E0IknmBxdiPIQnEeHkOAHPtAnjeRYLnTt4VW4frA7qpuQhy//Qa
         hQpT7P/54uHbpWQirNw9ul+JX9+AW58TFvd7K4B2AFQkHzjuwMEsnMI5vQYMrzO23Gb7
         QFLtQIBOlAvIcjy8u1j2/afNmcR51sEhbCP/IyVaIQpR7kAHnwSEAmzBuutT+BU5gg59
         KoRsMYtdO+B4oJ9YN2JzBLRmN9CRbYtpGWIZzvecZNAgOooALiToiHV5Vr9TAdrFlZvS
         v/YgFrKM2ITxRwc2xYApzDgdcRlN1sZtCYimBwVa7+g/IOrrp00QuwoUpaPImF1dMsBm
         sQoA==
X-Gm-Message-State: ACgBeo0jB/nz8xKn1fj7HiPjgRct5KnUlAlbjU0Pvd1OwjlyQtNxLCJf
        c3I926H5/TzuEOH0dSQ4t98YIWPKyp9RsqPTkUk=
X-Google-Smtp-Source: AA6agR4NLVnMzausE2EAqwSsQ5ODm0KcdRKNpL+1SnlLyJJrozQL0BSf49skfkk+Qs0QuWM0bNUnIw==
X-Received: by 2002:a17:902:6a8c:b0:16d:ca07:61df with SMTP id n12-20020a1709026a8c00b0016dca0761dfmr6365814plk.124.1659141369126;
        Fri, 29 Jul 2022 17:36:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v4-20020a622f04000000b005252680aa30sm3555954pfv.3.2022.07.29.17.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 17:36:08 -0700 (PDT)
Message-ID: <62e47cf8.620a0220.9ee5b.5e23@mx.google.com>
Date:   Fri, 29 Jul 2022 17:36:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.15
Subject: stable/linux-5.18.y baseline: 68 runs, 1 regressions (v5.18.15)
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

stable/linux-5.18.y baseline: 68 runs, 1 regressions (v5.18.15)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
asus-cx9400-volteer | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6=
-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.15/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3740a5da82ebec7a6d8f3a6deea77b8129c8c2ee =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
asus-cx9400-volteer | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6=
-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e44618a94b17cad7daf071

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.15/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx=
9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.15/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx=
9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e44618a94b17cad7daf=
072
        new failure (last pass: v5.18.13) =

 =20
