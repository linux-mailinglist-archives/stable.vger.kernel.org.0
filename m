Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06DE42D163
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 06:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbhJNEPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 00:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNEPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 00:15:37 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0501C061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 21:13:32 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lk8-20020a17090b33c800b001a0a284fcc2so5992827pjb.2
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 21:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4/dheum95E3tf2RAHl29m2wJhJ70TnkFKMifp0vGSls=;
        b=4ZUkNrFH56/IysZDzKkzocbMYl8R4mV8n8pBvBvLdhwGtQD4PMRdvZvJCiwAcU6Auc
         b1J3mCJ/Rz6c8hasaii7bd6KyK1zfdReQJp0VRicr7Cy4NtsGIw2FgvVmDJf/AOjqfZp
         z3YhH/zJk3SvlmuLBzGiXxfgY2Ry9nLHW1EDp4zK4Q9iITQ1kd2floC0+V0V6rryiiK+
         teuQproXfuBUhAjXOncsiq6uGzBrQRHqpFeTfdl2GyUrKqkZon51byYvT7QqTIk8oVOx
         xzdSEr54ZbRkfPSbvNZrqKoBfif1lDigTwwpPQK9ILbg16DiceGfX0tu6JunXynYjG4G
         v5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4/dheum95E3tf2RAHl29m2wJhJ70TnkFKMifp0vGSls=;
        b=KyPlYMmu0UKvuD43WFgWM6roC5WkUUWFoJUOHG7iyp3QajLFOtg2QkyyJuVZoAy3gZ
         RsWenworxtWznA5EMODXuq6NV5+4SZ1Em+QI2ZKUcUsTWs6+fO9kJ38m1K38k3lxLNR6
         VjPwMmY7nvgVCM+QsVG1e5Mbo8M97L2NqDrwdWv6r/X9vYiR3hLO2QxN28K8y0qWV9d/
         Uf51N9Ihu9Wc17FOe64w9zthRtLoVPP3elEpnQ3yBRsXxhRYM/Nlnkj9C8h6gNqbzKmd
         PFfPcxnmjOjtU5dIZcKV1lXHKRQWiGmMHDghcZP7QeJkay36q8qvzU+w37rAoHhM75Gd
         xfkA==
X-Gm-Message-State: AOAM532yu58KVWcubJo/8mbvj4eBrl5fbtfkH3mzmpbEKv8XPf3D7N3C
        QQMac5sxiaWPF0ahvYMuYtvEuMizE6A5xuUgz84=
X-Google-Smtp-Source: ABdhPJw7vQjLiwHCPn5Ry2EUtWw3QLa72dmm//FMab59hfP8jnRAT75x4e/P3YBGYv6iYdJhE5e+HQ==
X-Received: by 2002:a17:903:11c3:b0:138:f348:4340 with SMTP id q3-20020a17090311c300b00138f3484340mr3042358plh.84.1634184812284;
        Wed, 13 Oct 2021 21:13:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e20sm942508pfc.11.2021.10.13.21.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 21:13:31 -0700 (PDT)
Message-ID: <6167ae6b.1c69fb81.6932.41df@mx.google.com>
Date:   Wed, 13 Oct 2021 21:13:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.73-22-g5d643d9910b1
Subject: stable-rc/queue/5.10 baseline: 83 runs,
 1 regressions (v5.10.73-22-g5d643d9910b1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 83 runs, 1 regressions (v5.10.73-22-g5d643d9=
910b1)

Regressions Summary
-------------------

platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.73-22-g5d643d9910b1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.73-22-g5d643d9910b1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d643d9910b1d969e591fe49338e880487b1102b =



Test Regressions
---------------- =



platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6167741760bd2337c308faaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.73-=
22-g5d643d9910b1/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.73-=
22-g5d643d9910b1/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6167741760bd2337c308f=
aab
        failing since 4 days (last pass: v5.10.71-29-g7067f3d9b27d, first f=
ail: v5.10.72-19-g2ca9b8bdb28b) =

 =20
