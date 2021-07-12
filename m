Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E345F3C5BE7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 14:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbhGLMPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 08:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbhGLMPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 08:15:23 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF82C0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 05:12:35 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b12so16182470pfv.6
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 05:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QVWl705krAkirsGehqQfF/VZuSWBNNzwTxyyvTBmFI0=;
        b=bDAZ1oCWo2snOfD4ve285oOxg+Ip3WBlz/i6WdlzCkvLzJ5TnqZzOxXqTXd+jER4W1
         47zG+VfqXiWv1kiETY4gxLrEWOyPYJwAvOz8p+9BwEs/n8Fwhcg4y3W+MKCloxj9vBGw
         NTi6bGMSrgSKoZ/tjXIwJkU0dZL6vnggAFFZqEXJQEjKfZr4JM/PEfOynphS5zPKdqNv
         wfB6vwWP6vBRSaUWn59mkcwLHTjN80d+6bvbt1YeIg2BaQ6BcG6R8+Ry6u1TEaRpAF2I
         y6GSRcFZtX/BWQllfnA3NmQckYU+wx041qlsTie09qhO6u4gYESgD489md3XnZwrtaUk
         p9QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QVWl705krAkirsGehqQfF/VZuSWBNNzwTxyyvTBmFI0=;
        b=mTUyKxT4YcEDsbDs85Cg+uNEsjpNaCNdd465boQ5/RlLzHqXJlr365HmWnHs5qYbEb
         1je7cqaZqVIq9axnrn6rrDoImi5r+l2/MxiAzTePHe48TSOck1Lkz6kHxXVzKzABbtqD
         4qJ1/WpcGWBecZqT2GlOuhYVYjJQT4sB4n9JObl8Vx8vi3DevpE5LdgARhH86w0lpWMg
         6shQ0GYURkaBqPvgVtMSIJvpqhfH4mSG16Rvjrw8CNxvNH3ZmoYucd1I2ASjbNbeEJ4I
         Y/vCf7ue+yu2PAnWow9sqxl/XCkRagLC08S4k2W8o+wE3MAecEgdPFTHrYie35hahCDb
         AutA==
X-Gm-Message-State: AOAM5336bPQuI4sAaLC8pAXLuzBaThiaaji3Fi3YWzFvNqCtgy5PAXPe
        kN9FjhMoBeZbH4NMl79O33eN48Fg+3rJulVE
X-Google-Smtp-Source: ABdhPJw17OunmQGaVFwR4PXC0HeR3I5LVDPMp7m98X6NP/d8fN3jCZI8PmT/KPAua+Y7fPpned2YNA==
X-Received: by 2002:a05:6a00:8c5:b029:312:c824:c54c with SMTP id s5-20020a056a0008c5b0290312c824c54cmr51929498pfu.76.1626091954818;
        Mon, 12 Jul 2021 05:12:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15sm15456251pff.128.2021.07.12.05.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:12:34 -0700 (PDT)
Message-ID: <60ec31b2.1c69fb81.a3cc9.c9e8@mx.google.com>
Date:   Mon, 12 Jul 2021 05:12:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.16-706-ge2aabcece18e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 161 runs,
 2 regressions (v5.12.16-706-ge2aabcece18e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 161 runs, 2 regressions (v5.12.16-706-ge2aab=
cece18e)

Regressions Summary
-------------------

platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
hip07-d05  | arm64 | lab-collabora | gcc-8    | defconfig | 1          =

imx8mp-evk | arm64 | lab-nxp       | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.16-706-ge2aabcece18e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.16-706-ge2aabcece18e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e2aabcece18e176e2e0eca6da06c46dee874e145 =



Test Regressions
---------------- =



platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
hip07-d05  | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ec0421ed4947bc5b11796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
706-ge2aabcece18e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
706-ge2aabcece18e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ec0421ed4947bc5b117=
96b
        failing since 10 days (last pass: v5.12.13-109-g5add6842f3ea, first=
 fail: v5.12.13-109-g47e1fda87919) =

 =



platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp       | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ec036277eb39e5b711796c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
706-ge2aabcece18e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
706-ge2aabcece18e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ec036277eb39e5b7117=
96d
        new failure (last pass: v5.12.16-701-g5072f01b4ddd) =

 =20
