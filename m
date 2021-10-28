Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE9843D7FF
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 02:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhJ1AVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 20:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhJ1AVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 20:21:49 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735F5C061570
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 17:19:23 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id t7so4602393pgl.9
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 17:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V6/MO5rxmz9+sg2V5WZnJAKzaOZxnJf3KmPzYX1ONzE=;
        b=juKRxz9t8NShAE3pDlq1xivWjRhICIf90km4NmPfFj6l0TSgGzEXxyWW2wRlbp+W08
         yMwyT8gY1eiI3FmhyWkWMrCJogwdD8ueQ80esghZULcfbnT034fq7CqmIRYajF7WNUWI
         wuSQ3LVP3UjNqtNNX4qe0KHANzLZ776jIb+CwO1AP+qeD92awKDJPAJPGCXrMiThshBS
         PSDjavWZ/m2I2z6HrLnrjalKCuxxFOKPH690bsreUR83smSm6qAKks345ChiVDOpUse6
         VuJeOZ//swszvBX0boMEECpe6kOUM64iSFJMCsOYF8eQMRXO4u4wM5AbuyA52fyvFyA8
         eEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V6/MO5rxmz9+sg2V5WZnJAKzaOZxnJf3KmPzYX1ONzE=;
        b=twt5n4vHgWJ3oHyrTZZ/PKoEHqmt8KNzboXUeBED4ae2QKI/zMBss8Urx4KqXdJ2Va
         NZoP8ILw0xAqGIyscseUDqM0L19ISx4oZPpMP+xPEau9IPuV5PNnsWRWGsRJeDyupHuB
         amKXCqnmNeBOeKuq2WCmtRZDjjOQ/hqx9ot9mztzZBKwjQksYAWEdNoL8cEzhWQZRPh8
         O08uMMolTgavYakin9a0b2E3h5mXDHF9ICRtL5u6DfcIOdvoy/jvAZ5mKdMHn7jn1kpL
         0HXlgQZmHrpN4pmoy9+Ak6D7yj5H8Ps8fdLMd2IzGeqwZVyTESLt8wxMIUx5ufyi1cbg
         rA0A==
X-Gm-Message-State: AOAM530ZMKjeLhxJyCzRbLDMZDkd9fqKrMi/yUK3p9eD5cvVjl6UM1wI
        ZKSpybR2Nt2MyIZ9gVybErGh3Wgf08nYgd366XM=
X-Google-Smtp-Source: ABdhPJzV1APQB8sAC6S5Rd7Tyu6lSo0qpsXfiYsIrFjfBbi7Qy1hoGcjnjKDTNChOltpgV+Vk+UM0A==
X-Received: by 2002:a05:6a00:228a:b0:47b:ee7f:223b with SMTP id f10-20020a056a00228a00b0047bee7f223bmr885285pfe.81.1635380362798;
        Wed, 27 Oct 2021 17:19:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21sm1172075pfc.89.2021.10.27.17.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 17:19:22 -0700 (PDT)
Message-ID: <6179ec8a.1c69fb81.917d0.4f5c@mx.google.com>
Date:   Wed, 27 Oct 2021 17:19:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.76-9-g950a5a5683c4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 114 runs,
 1 regressions (v5.10.76-9-g950a5a5683c4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 114 runs, 1 regressions (v5.10.76-9-g950a5a5=
683c4)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.76-9-g950a5a5683c4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.76-9-g950a5a5683c4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      950a5a5683c42e7f9ed08497830cd6b54d03a531 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6179b46ce8c308b10d33594c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.76-=
9-g950a5a5683c4/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.76-=
9-g950a5a5683c4/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6179b46ce8c308b10d335=
94d
        new failure (last pass: v5.10.75-94-g1c548c21e7d7) =

 =20
