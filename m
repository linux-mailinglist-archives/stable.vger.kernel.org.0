Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937C23E3635
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 17:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhHGPxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 11:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbhHGPxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 11:53:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F30C0613D3
        for <stable@vger.kernel.org>; Sat,  7 Aug 2021 08:53:22 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j3so11391720plx.4
        for <stable@vger.kernel.org>; Sat, 07 Aug 2021 08:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M6uWxj/soLTMi+br2o+5ayt/k02u/yFWSDpGt+Qe+7E=;
        b=WLMN56pszOjaWCT2bO/F3aNhXzmDtFlDf1tXaHOTeCAKfRfie/JjV52eXcHtUZqLfz
         wOZ40f+d8Q5I6HfOj7UPxJMSenzmhPqtXPrOj1wXU5Qbd+rEMvp/HfpFM8BeSaSK+saq
         sgjxrTIHH4XopT/K8sQRzI57D7mFW7LiKH/NYCKEpeSZ+30VyxwwMvHHVxqiIgAosRwj
         IQPg/pwr96ml5PVu1jlE9o8LtecqbdwbgzPSgFsRXZafjA6kSECfDM9/fiQcbiUDiLfs
         AGf3mB29Gu/EAqwziipoOsy0Fs3TDLMXXfagr+zr1FkB1yNeEQEagAjOkH21iwfwgG6Y
         x8NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M6uWxj/soLTMi+br2o+5ayt/k02u/yFWSDpGt+Qe+7E=;
        b=PGUf32tQ9X5c1KJPWw+7EmSrWhBejRDl1kZz5ghtWvJPG7psWQxwXY5NufsY9eWksa
         tVQHyUsYPQ7MeS8BIY9r3rnJzctc8H+3Z2bazCJ+efQhbqs+ZFkrWIaJHr+Q0XF65DK6
         PL8QafZ0CZrusLzDbx+TTaLV8qvikIQQ9F0d4uklyEeKd7AgqvY4kVcy4ZY6ULx5tzPF
         aHdY/ACv0lLRk2M8es/NHV0gCN1dUypmcUqUkfuqqY7w3e/fM0oqG2bIJQxOuubY39o9
         X2SCMyMXsR3ExY0Ue/efZqn4e6V/QADE8DLZXw8OsmYXtRZ8ah803zrMHJV63aRxwcFw
         UIxQ==
X-Gm-Message-State: AOAM530M31BqX/LtiJqQXt7/zN7LAkhoEXLTHIkM7SkoCu+Megcvp0kB
        Ug7H/umjFLMug2nzQ0lCPiGmEl4K4xBBUT89
X-Google-Smtp-Source: ABdhPJxLdZbU1Ktif3m9vgwzPm1SfJxM7O/zhh4CvYiIORukPNxApykXP8BqQZCk/9WJ5BPDt8lsEA==
X-Received: by 2002:a17:90b:1882:: with SMTP id mn2mr16405058pjb.2.1628351602004;
        Sat, 07 Aug 2021 08:53:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8sm15031973pfe.162.2021.08.07.08.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 08:53:21 -0700 (PDT)
Message-ID: <610eac71.1c69fb81.ba835.b55d@mx.google.com>
Date:   Sat, 07 Aug 2021 08:53:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.8-35-g0d55d58934f9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 134 runs,
 2 regressions (v5.13.8-35-g0d55d58934f9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 134 runs, 2 regressions (v5.13.8-35-g0d55d58=
934f9)

Regressions Summary
-------------------

platform       | arch  | lab     | compiler | defconfig           | regress=
ions
---------------+-------+---------+----------+---------------------+--------=
----
imx6qp-sabresd | arm   | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1      =
    =

imx8mp-evk     | arm64 | lab-nxp | gcc-8    | defconfig           | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.8-35-g0d55d58934f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.8-35-g0d55d58934f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0d55d58934f9424d7230c6f4d535386994a8c9c7 =



Test Regressions
---------------- =



platform       | arch  | lab     | compiler | defconfig           | regress=
ions
---------------+-------+---------+----------+---------------------+--------=
----
imx6qp-sabresd | arm   | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/610e777729bdaee954b13693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-g0d55d58934f9/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabre=
sd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-g0d55d58934f9/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabre=
sd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610e777729bdaee954b13=
694
        new failure (last pass: v5.13.8-35-ge21c26fae3e0) =

 =



platform       | arch  | lab     | compiler | defconfig           | regress=
ions
---------------+-------+---------+----------+---------------------+--------=
----
imx8mp-evk     | arm64 | lab-nxp | gcc-8    | defconfig           | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/610e7751ce24aba57eb13663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-g0d55d58934f9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-g0d55d58934f9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610e7751ce24aba57eb13=
664
        failing since 1 day (last pass: v5.13.8-33-gd8a5aa498511, first fai=
l: v5.13.8-35-ge21c26fae3e0) =

 =20
