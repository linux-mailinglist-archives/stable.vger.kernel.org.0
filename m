Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05EB414D8A
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 17:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhIVP5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 11:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhIVP5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 11:57:09 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED15C061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:55:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id z14-20020a17090a8b8e00b0019cc29ceef1so4823224pjn.1
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8EjP5gCpriu1iZ5gtdeEVLv6c7FGocdrmSFmdS4EBS8=;
        b=2LomjjpzRW7zgw9WNhhOKBWCGwDHRa8C7co7ZBoV2M94xr3OMGjtVT/WplYlZNVLTD
         6c51VCBD4l1FndMfmVMNUOLWfWkkN9xFp18uHNOGAMiEISvsVO1IzQwdq9UslfdZvA8q
         l8rFYChMN4cYKhpPgVs1tr1HKFTenPe9Bz+Qh4nlyzcf6CMqHEV0fpaYimA1zHT5Krtz
         8qbB1+Qx6IQ9P0tPAVj/IcvgFwaxXQQLBNCSaYq9Q6hXcDvACYGs77jLF2LjuPwyYIxC
         vh7p5FvbnR3uGG2RSfeiGe+dPhIB4B5gOMe/+5r1x9d7uxwQWVHLUrqm60/aZam/VfdV
         Y2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8EjP5gCpriu1iZ5gtdeEVLv6c7FGocdrmSFmdS4EBS8=;
        b=nk9uNRlFVXoSgY/CHPV26pjyMeIAfvRfhUJ6woqhPwJFta8+c+nYwL9ZuC7OoTFyia
         87xCCZ3RhAKeV8wBSfmLTSnnwBhKKH4/QXrR2CxWnIx+xmJMRR94YHvNtQVtTZpLDN3+
         8QQf2oQB3oai+ezbng7grsPBu7wtrVA5BYezLfWVvOLRjVnfKqZ9fcwNmeIosON/uyxq
         h8BZOfRcw5PZKszPBcqY2+jXNjKWxZdz8ieA/fxGqDWmG4evlvflGmEqOlQ/OcPQeeUQ
         CtUK8RehBbJiiCz2szqMyh06VPPNIqx0lNRxcv43bexRO+P6bvY5QNCIu+Tu9Sa6lqZh
         IaYA==
X-Gm-Message-State: AOAM530QGJop/tfiQLe/542bTm59qACo/3ZhHT/xTS7brD1p8ohx8UYU
        duHiypPi8V3iwjS82D5luPKlVDtrsDOE+u9V
X-Google-Smtp-Source: ABdhPJwkmUqToEEBpA/FLEjlt5bX/KodzoHYOqjRC0WszNuoQ8a7beAMzctg+QYGDt89yBqR+52d8Q==
X-Received: by 2002:a17:902:780f:b0:13a:3a88:f4cb with SMTP id p15-20020a170902780f00b0013a3a88f4cbmr311028pll.68.1632326139011;
        Wed, 22 Sep 2021 08:55:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d14sm3039207pfq.61.2021.09.22.08.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 08:55:38 -0700 (PDT)
Message-ID: <614b51fa.1c69fb81.b24c6.7f0c@mx.google.com>
Date:   Wed, 22 Sep 2021 08:55:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.67-125-gcad917b556de
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 93 runs,
 2 regressions (v5.10.67-125-gcad917b556de)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 93 runs, 2 regressions (v5.10.67-125-gcad917=
b556de)

Regressions Summary
-------------------

platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
hip07-d05  | arm64 | lab-collabora | gcc-8    | defconfig | 1          =

imx8mp-evk | arm64 | lab-nxp       | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.67-125-gcad917b556de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.67-125-gcad917b556de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cad917b556de0aaf8c58ff95498519101f455d98 =



Test Regressions
---------------- =



platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
hip07-d05  | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/614b17b8da0993333d99a301

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
125-gcad917b556de/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
125-gcad917b556de/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b17b8da0993333d99a=
302
        failing since 82 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp       | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/614b18a301c01e259b99a41e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
125-gcad917b556de/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
125-gcad917b556de/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b18a301c01e259b99a=
41f
        new failure (last pass: v5.10.67-124-gd409bad9aec2) =

 =20
