Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C90C394E59
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 00:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhE2WNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 18:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhE2WNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 18:13:10 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFF2C061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 15:11:31 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id z4so3311164plg.8
        for <stable@vger.kernel.org>; Sat, 29 May 2021 15:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wOodgdkhcdjpt3JGJzh1zX7pQMDg01Wt5z7WQ0vy7Ws=;
        b=p1SZcwIAXITFkYVP/VJ0qkZkNN6qnkQm95TDEViltLFNZcdK5Xjcr94UNc3QPAis/Z
         /MrX3j3uPf6VKIJQiDPSntmahlwl9ZsivhrVCup55NS/9U6Q589LqJ4UAivf8XIC4J0f
         DKJo7hiJse80Zl8H5OCmieDZwaRCvGn2bIk4O1ECWgpocqeYcIzfr6wxU1hEe48io5j4
         uTyauNS9ctGm+/geUyNhWRuv7BqOwaV1Q8c1WMYVShTSuUz5XYq38fInAmEZuJu8SEGi
         nNG/vyxjfmDXLmJ6kGdcexxHYRLjIvfXQ/Oxq8Nv3Nx8GnLN1HmOIGsCo5d/JULMIzUf
         pzCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wOodgdkhcdjpt3JGJzh1zX7pQMDg01Wt5z7WQ0vy7Ws=;
        b=ixNK6xyuTQMZL2OUofjiAWB0eSdf9PPZEp6xCPQQG8mvdP2fyJUq/xa0CS8jmV2ouZ
         s7u/xxgTDRmh4MDqgvkyYU2aYlC8Iur5qA+bi5teUb+572OJWyFev+Afy42cHflugVW9
         rhukZpttZYSeXMLRE8+Jrr7D/Bk14235TnakfISuX4dSZzFXZvYhJM3D1LHYG8ysGmyY
         POcJaZVh5g+1p5BKNRz7dq6c7ktoyrD6HmS34w/aljEt4QRCk5KEXn2/woOHw4IUU7fw
         MXGrYj0cNUrih9XHAv+/OwjEr9W5FTi1UaKBWymT/wAsZ+qn9gmp7OgDN1gLA21iSKsF
         A1ew==
X-Gm-Message-State: AOAM531TkPRgONy7J6NPUU8e9kJp6DZB1919sEvCiuRsJ6FlQPul2PG0
        QrA057m6ZiEhwiGJtDrHE55MPml/apJ8szch
X-Google-Smtp-Source: ABdhPJzvA82MZSreJCwUEnxZNahtlLmcdrecQYN3njMZuchPVmWi4ohd9aI8KQxevqe6iHvPyVoL3A==
X-Received: by 2002:a17:902:8505:b029:ec:b451:71cd with SMTP id bj5-20020a1709028505b02900ecb45171cdmr14128392plb.23.1622326290212;
        Sat, 29 May 2021 15:11:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r28sm7612253pgm.53.2021.05.29.15.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 15:11:29 -0700 (PDT)
Message-ID: <60b2bc11.1c69fb81.7d149.9154@mx.google.com>
Date:   Sat, 29 May 2021 15:11:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.7-68-g0c053f223af4
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 171 runs,
 1 regressions (v5.12.7-68-g0c053f223af4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 171 runs, 1 regressions (v5.12.7-68-g0c053f2=
23af4)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.7-68-g0c053f223af4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.7-68-g0c053f223af4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c053f223af4a07272c304928d77cc5128146532 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60b28b692c0511c4e2b3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-6=
8-g0c053f223af4/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-6=
8-g0c053f223af4/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b28b692c0511c4e2b3a=
fc2
        new failure (last pass: v5.12.7-31-gdd60917b7d06) =

 =20
