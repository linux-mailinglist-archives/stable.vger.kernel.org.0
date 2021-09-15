Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DA440CA65
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 18:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhIOQhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 12:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhIOQhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 12:37:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48627C061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 09:35:50 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso2619681pjq.4
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 09:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b/B9yH35DM7eg2HGYYCEXP5PTrzdOyG6Ae+BGlouS0k=;
        b=kBeM5Xtgc3RRqzGhWfzJlu1Hz1s4yCuqBhZK0Nd+sJBThXyef6x9lkuPOCbuiGd5Hh
         nUeRsfJBVKs6H/hC0mML9Qr3sHtlKIXLdZRc8KbP3nX/P1YcAGLfh1S8Fga3dU6QUjL+
         8gHM1cLpf1QhhjMavCQCMobR+TTdgSnFomYRfMeU4gtR8GU6QG8vQat2/u8WVdwrdhZT
         PmSA8QpPHLRPaUYp5kz623zojCXcl/CVm/l6hcOB8ojesLzW3yo52mrjJNkzJK2EyZt7
         LnTRAdvycSU8CjtndQ3S2Ni/Xzjze1k3HpqJ2iiscrdtkrtjeHEtPOHbJL0nHb32s5vO
         dZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b/B9yH35DM7eg2HGYYCEXP5PTrzdOyG6Ae+BGlouS0k=;
        b=YQdcxPdyylIva60g3yhJuVT17sx4uYBkD0tC7pKLEbxaGOjg3NCRYHRG8DVext3U2j
         XBowBBynj8Sdgo3QeKEYfh04h+LF/0hBvphLAYEDExXXfBMjcMSDe6Y3vXxsqAgUKxPY
         TbAvuouLhOzQ5v9PUl9yh35luTyk1IldIZxlgQH5z21vjeCQJbYqh90AzWW9LAlZn1tB
         BxMBct09ZHCQKyoW2MhV0vH+3d9LaDHsWpWNn4MG6NRQ2PcvCE5SLU54+t6V3GRU8aLK
         zh4KydNkhSqPlQUhVLnblpOSiX8iMKJCLSwDEQ/zAtyZguLUAoIg+jbypQ7vOSE9dlev
         7sZA==
X-Gm-Message-State: AOAM532k/jyW+EALzHSIh+VVOJ0YS0le6e5v1REJlVkMy+synZ+OSCkt
        MaTGBvpZ/xe7pVAfmLb6adzBui2wtS9+XpyGKC8=
X-Google-Smtp-Source: ABdhPJw2TFXbHQDJfXLTtAO8cN3x6NY5bzJPBpjSP/qkcOOfwU/H+ziRKXAFPToKLA0WxMWgFxaA+w==
X-Received: by 2002:a17:90a:ab86:: with SMTP id n6mr689972pjq.159.1631723749644;
        Wed, 15 Sep 2021 09:35:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t10sm495080pge.10.2021.09.15.09.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:35:49 -0700 (PDT)
Message-ID: <614220e5.1c69fb81.7f192.1c8c@mx.google.com>
Date:   Wed, 15 Sep 2021 09:35:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.4-24-g6da4ee8977f4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 153 runs,
 1 regressions (v5.14.4-24-g6da4ee8977f4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 153 runs, 1 regressions (v5.14.4-24-g6da4ee8=
977f4)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.4-24-g6da4ee8977f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.4-24-g6da4ee8977f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6da4ee8977f4bd178e5ab51f0602bd1ce338a557 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6141ef708fa0c5582f99a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.4-2=
4-g6da4ee8977f4/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.4-2=
4-g6da4ee8977f4/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141ef708fa0c5582f99a=
2e6
        new failure (last pass: v5.14.3-328-g86b6bc3e3300) =

 =20
