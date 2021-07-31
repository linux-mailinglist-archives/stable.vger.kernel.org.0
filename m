Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD09F3DC3E2
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 08:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhGaGUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 02:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhGaGUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 02:20:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8E6C06175F
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 23:20:05 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so23947504pjb.0
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 23:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UJg+JBDIpbTV11ySA/6p6EmaP4iSjRcrhW591Yfd9/I=;
        b=oR+pBSPGPmqkadDSWf029NaB334NPzRHYlAunrxfyobd2HkakcvnzjqozKfkGzKU05
         FWpaqPw8XjuyGgeCQUxfhkRSVA3mKCuEMROdnUIdbupzlEQwzq9KXShCNl6wBOwWpHvB
         YyJ1wqm6NN4xxfzZiPPnoFwOUVkYWVOmYsxMn8FgCREnXu+Xu4fv5VAoSIghlpZHlYb9
         p5VAPw6alVp7TEnvaLTHrJIrCJFT0zOQSvrK8CB+pioyFk0ttERTazJ0dTbtgt4PNzuF
         ZbIBRfAtAyUprm5UVsPOsVO8n92jv1YgsuhiyybcdEtX/PkpdN6c0FfX0sG5dw+iLhy4
         WRVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UJg+JBDIpbTV11ySA/6p6EmaP4iSjRcrhW591Yfd9/I=;
        b=JXq6604/llJUyCBxm0UUzk9zGCz7W/0gB3bCKWAoNe5vU7s5H/ZPp1WofbQ1EM3SAD
         pdFDS48AgABSvpUrPxeKOqSG1BXCAbePQOL95mLgTSxkcgCbA+cBkijXS+vuwEX0Y5S5
         dHp1R6BDtDO8Zvo2x1DvMoBLCn7j7Q5m3HDPphlVF/2Evuuxq42H0e/dnR+Mv7CZU7T+
         sjYVLjawCUQ2FcF/8BfkH1M4l/YxarjJIgei0ZMp/E+NXHwAQlRofGdRJYUuICZzfV8u
         dzGDRMN1D2WfM+Z6FLAd7h16bgqNdutf6NFkgvz6w8Hf/VCVjE8gFlfxAzSz5c/XX0ru
         iujw==
X-Gm-Message-State: AOAM532SOyG/FqU+DFF8W7FlGj0JLJBPPKFEIiHN0fX02zSBHMoenUTH
        v2dQ9euQ0gVGkDHenBj5SiM2IfOFYFhzbDUW
X-Google-Smtp-Source: ABdhPJyhI2oPZ0Kij+0XhOgLgv/0MeLiLE06kItKxDBIZ+ouCiDVtqYfeYEeF6dHRwovqAkyU7lJoA==
X-Received: by 2002:a17:90b:1d0b:: with SMTP id on11mr6883112pjb.94.1627712404221;
        Fri, 30 Jul 2021 23:20:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13sm3313197pfi.210.2021.07.30.23.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 23:20:03 -0700 (PDT)
Message-ID: <6104eb93.1c69fb81.bdbd1.9fc8@mx.google.com>
Date:   Fri, 30 Jul 2021 23:20:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.241-16-g69e247082971
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 90 runs,
 1 regressions (v4.14.241-16-g69e247082971)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 90 runs, 1 regressions (v4.14.241-16-g69e247=
082971)

Regressions Summary
-------------------

platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.241-16-g69e247082971/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.241-16-g69e247082971
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69e247082971400fcb7164b1f39580e0e0c8cf3c =



Test Regressions
---------------- =



platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6104b07d846cca810e85f478

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-16-g69e247082971/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-16-g69e247082971/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104b07d846cca810e85f=
479
        new failure (last pass: v4.14.241-13-g64ab6520c0fe) =

 =20
