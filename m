Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346C5376A06
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 20:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbhEGSa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 14:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhEGSa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 14:30:28 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D362C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 11:29:28 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id md17so5554810pjb.0
        for <stable@vger.kernel.org>; Fri, 07 May 2021 11:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ox5ciYSsgDPEnY8J28lKhOsOezwtVUKgu2qETTnZsAA=;
        b=vk/UU2/q7y8ptJEud7ZrrYPafTb0zGMa9g7HMu1HqrCPq1kkZUFLwlSWfdqEfHgKyL
         2YSSaK8rpOz6BqD+dIzvnU3idbmx9nbrg3Owfhg/g9Tgdx39YPyln6ES9lHQ6qpXJ0H4
         YspPJbHWl7k6Rzxdj7ND3ckFaimBad8JD9P42+Kl7Y5MFLBy6zlJ78zzauoNA5qqztAB
         RFJdmF37Qeo453ptsiGYHYkcI74jglLKyvHakzhhOD3K8lfStIH23H6WyBTZ1K/0EeiA
         +MWrPzJGJfVpla491pAM6+VdMY7LygZiI1AH3YcGHZX7+kI2M9C+j/9oTk8sids6u9bb
         M1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ox5ciYSsgDPEnY8J28lKhOsOezwtVUKgu2qETTnZsAA=;
        b=EtRBIdLpGkDWnzbfx9AvzBY1Zbll3LSBF5a6RzhdSF8iP8IwR1GLiKVyZMTlj69KIa
         CIu66L2pF49GGvUDT/cO38+j8zY36MFQdkhnGeuVXmD1slTdXqGITP4mjDlOtV6tomIr
         wZOJ7NL+zE95Qtyp+nTAtC8vSO3Dm7uoj3xABGGYdywjRPIEShMx04tWGsXD39OrSpfW
         2leaS2NFP+D4mIki/cUhCGejGrW+u03kcqPbOwgAF3ezA0w7SpJvT/RtjO3ioMH2S25j
         1+aNO24aQAsVwHRdAxfjnQWWf9f3uZRkjEVfVmyDmynYZxAiOSYCi/7JROI9en32F+bX
         KppQ==
X-Gm-Message-State: AOAM532g1qiVf00us//mABc9Uxa6xNorVHd2vSPOO51QGT2rK6OwkAaN
        UjM7KIs96IxGhX92p7yPMdWFfMDchBoStfy4
X-Google-Smtp-Source: ABdhPJzWv9zzGeLu1iNI3hK09F/7MNFmrVzJUXQwemiYwEfrhqTIuBbJyB6g0YzlFLgagHLyWgYRoQ==
X-Received: by 2002:a17:90a:e298:: with SMTP id d24mr11953063pjz.144.1620412167397;
        Fri, 07 May 2021 11:29:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n5sm5238753pfo.40.2021.05.07.11.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 11:29:27 -0700 (PDT)
Message-ID: <60958707.1c69fb81.f93cb.004f@mx.google.com>
Date:   Fri, 07 May 2021 11:29:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.2-7-g5520f97895f07
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 122 runs,
 1 regressions (v5.12.2-7-g5520f97895f07)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 122 runs, 1 regressions (v5.12.2-7-g5520f978=
95f07)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.2-7-g5520f97895f07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.2-7-g5520f97895f07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5520f97895f07aa1a06cd2289367fb8ab7dda790 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/609552d1a9d12d73e56f5473

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-7=
-g5520f97895f07/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-7=
-g5520f97895f07/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609552d1a9d12d73e56f5=
474
        new failure (last pass: v5.12.1-15-g33676b89fbad) =

 =20
