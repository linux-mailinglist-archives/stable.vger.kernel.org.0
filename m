Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CED47D8EB
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 22:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhLVVrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 16:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbhLVVrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 16:47:48 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AACC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 13:47:48 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v13-20020a17090a088d00b001b0e3a74cf7so4878149pjc.1
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 13:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JB4XaOGkwjGy8TzLP9iSiWWB9+J6vQzFZ5bddv+WB0M=;
        b=wI57wtrMJ30m+hqW4rvX3jqgDA++H+A5zkr3lKN5K90H4844O3tQBROImcouSBIVmj
         Fdvsg7UyfNKwaD3pKWcIxpZNxWs/Tg0vsjdmFS1E3BNzSaDvTWyDyWggSlX24HHRNYXe
         kpIoCIh8XDA+t92ppNe16lwnkEe/bcamnHjuLxeTtZodDOpBMy2/I9qYT3tKwSSW0l03
         zOzoeMzKxbMnVvNoiuDA+6LaZkhmaaFj0eOAm5OO5pQQ6U8kvkCAEBHUTdR/9AyCbYaJ
         AoLlMbmFVyM2kLznM8uCR7RffsK1wyJVKB4D4gCYx5eDFj2FDBoazb2Kj1EgLX+EBVtV
         71hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JB4XaOGkwjGy8TzLP9iSiWWB9+J6vQzFZ5bddv+WB0M=;
        b=n87JfI/qTuwR1cUdWeWTSoLfR6FwP2n4dZOW2AUx4e3tV52D79V8EoIW+x6NAFPOd+
         gR4HjSzotcProhPIEghmfHbz72tkqnb0wHfuJ21cFPa1WIN3Eb57zxHXORmxy2vEVi8w
         PZX1HwTHDbnzBLn2jyv1+8GVQb1d83912NhfKd39AtG02gc9i9o2fsPkMs9NfYd2geKm
         lxgiP/zqV3cMgEcRdKXGJUU2lCQGNz+vT3DSr3Bw/qqACC8d6p+cusO0z23vfvoK6XZB
         a2NQVWpW3BaNSfxHifRMNVRmJouXqTVdtOaQ0vhrgl7RnaqNUgyTVVO0+fdTTP40oWrV
         ELQA==
X-Gm-Message-State: AOAM530cTA2rT5T9N6J1aiHw6clZwJoa25L60FPCf6IVzkpftjHk5oXj
        adzZZf33t+LuzSLR+8LbbY7vIM9gXLTltAiXCQ8=
X-Google-Smtp-Source: ABdhPJwPNmo7LkocXIAnBWl7moYQGhh+2C8MXsT8Ki6s2QwqMMUP+nT957XjLc1KRAPFf36YeJfrgg==
X-Received: by 2002:a17:902:7003:b0:143:c009:89f9 with SMTP id y3-20020a170902700300b00143c00989f9mr4568943plk.11.1640209667869;
        Wed, 22 Dec 2021 13:47:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oo13sm3514819pjb.25.2021.12.22.13.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 13:47:47 -0800 (PST)
Message-ID: <61c39d03.1c69fb81.6c96b.984c@mx.google.com>
Date:   Wed, 22 Dec 2021 13:47:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.11
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 205 runs, 1 regressions (v5.15.11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 205 runs, 1 regressions (v5.15.11)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fb6ad5cb3b6745e7bffc5fe19b130f3594375634 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c3636241c6cb080e397162

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
1/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-=
E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
1/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-=
E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c3636241c6cb080e397=
163
        new failure (last pass: v5.15.10-178-g6c3eb74f1432) =

 =20
