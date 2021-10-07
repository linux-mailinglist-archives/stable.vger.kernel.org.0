Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC8D426004
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 00:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhJGWmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 18:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbhJGWmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 18:42:07 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE10BC061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 15:40:13 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g14so6578709pfm.1
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 15:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uW0QT/82Z36jQwtE/M3UhW2OVDdhQn7UaRqVRbGOZ5E=;
        b=3RZZtz/QKMCeB3U+4965HYWmL/F1NKnFvB6HZg6tRAlyAszUWgem1xbEj2BQoVffjS
         vVf4TngperfcQLjgOzM0v1QWlzHXrCTxIduOsKWDPoikEMFjxY4B1gU4D5hRlVmDQw0f
         Zr3wWq9k3bbFeukf5DG8ZtM4KGHMmJ8Kjq5IuD7lu2Bm0gmMVP0reIvCQEQb/Mzy+9RX
         RY+s4wr5leC+/CGJEJsHmg0wB4H+aEiyWlmpYwXAvFzmH7Fn6W2PJNs5g6Vd39kZn4lA
         pMD4Zq2LjpECHLSIiDwWngkd/fVMWXmeeUP0r/rxxbT1SvOj0tbtjCmFNUw8jvvbmCMb
         gaRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uW0QT/82Z36jQwtE/M3UhW2OVDdhQn7UaRqVRbGOZ5E=;
        b=PaSFekAbQW5P0GxHjsnst1jtqr7yL26McyiNWOL4FZskYzCCBC9xevJNOA84FZ7IXZ
         9me00uYnpkaUT5ObjJ2cISwqt3tyAzJM9pB2hT4kfTmgoQ1CBXRnivNF+7vX08Ga4oKW
         L/qcOlaPBs1haQEkZwmlmXgbqmUMvfSDopI97xzQT2I7H7HvVLpOxxnZhMAF1dkgD7Vo
         e6puCQHydzwJBK09Kr/2L9xskl8EWD1CQULZcJ+9Q2FhsifLBlo7VRYAO9WExXXOPsrf
         D1UaY/GMKgmJROFyypzCJdpplSJt12eTaIMHL/C/Irv8rAVFUddnAhDPkbHXSWK9kYwq
         Y2ZA==
X-Gm-Message-State: AOAM532cqjbE2hnO4A0m2bA1spZklb8bSquAjSzT0dvz2gQP1k4lQ6y/
        S0IDYu5GSCDL9pLeYtqwmQ+40wphG/llyeif
X-Google-Smtp-Source: ABdhPJw9AtPIPioQlwvIeAO+nw8DSclke4ay8J5Bl7BwIrBLiFDjIQK/qlY0Hxi8Qwa0qXxKbXTumQ==
X-Received: by 2002:a63:d654:: with SMTP id d20mr1802335pgj.122.1633646413040;
        Thu, 07 Oct 2021 15:40:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gj6sm251674pjb.34.2021.10.07.15.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 15:40:12 -0700 (PDT)
Message-ID: <615f774c.1c69fb81.a8dcf.125e@mx.google.com>
Date:   Thu, 07 Oct 2021 15:40:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.10-44-g08b40de697db
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 126 runs,
 2 regressions (v5.14.10-44-g08b40de697db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 126 runs, 2 regressions (v5.14.10-44-g08b40d=
e697db)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1      =
    =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig          | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.10-44-g08b40de697db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.10-44-g08b40de697db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      08b40de697dbcd3678551d48ed136da7deba27b0 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/615f3ffb58a4c2708b99a314

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
44-g08b40de697db/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
44-g08b40de697db/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f3ffb58a4c2708b99a=
315
        failing since 2 days (last pass: v5.14.9-172-gb2bc50ae5dd9, first f=
ail: v5.14.9-173-g4ad9884c65e5) =

 =



platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig          | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/615f476b5f5c17775a99a36b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
44-g08b40de697db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
44-g08b40de697db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f476b5f5c17775a99a=
36c
        failing since 2 days (last pass: v5.14.9-73-gb9d08ffadf94, first fa=
il: v5.14.9-172-gb2bc50ae5dd9) =

 =20
