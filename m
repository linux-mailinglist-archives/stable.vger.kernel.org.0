Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD12395230
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 18:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhE3Q5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 12:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhE3Q5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 12:57:06 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2718C061574
        for <stable@vger.kernel.org>; Sun, 30 May 2021 09:55:27 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso5345962pji.0
        for <stable@vger.kernel.org>; Sun, 30 May 2021 09:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7X53FSXa390flKoWKi7UbXl9Z0JC1N2NVf6JHzy+UCI=;
        b=jqZOmbMm9G6qvY4eQtD0jk45TcCSOpRWnE/lAKcXAXwdDhRRJQoch7v73m6KjFS5Eg
         6ZpXhhYQOT2KwPnNO+cDcNCUh65oDA5HL6HM4eLtY7QTD0iuSlLv1qZeKToD5KO6kWl+
         i4SbuRvZJr8Bo816RWZZ6/hpIV8iEn3+ECNbDb+F8QQ1a3hzpGVFzeSbAsQEnHDeBxnj
         IdNrDE0He0rwF4XncqAnuFXaF5eJUXh5CDVitLV6KbkZ+0ttLbYhUfL1BDny4l6Ki+EI
         JQnrmsfNm4jvqG78Gq9TpBdxOHGMu6ZjEXUo0KeakAeOGtZD6tBo1xNX3HRz5Fh/HEKq
         Vntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7X53FSXa390flKoWKi7UbXl9Z0JC1N2NVf6JHzy+UCI=;
        b=jdR2xCV+T9DOdyD5QxBqisMZH4yDHD9/hJKDTtSH3vxNQxO90qlL0mkRXmahI+Xi12
         p1BOSJBoLLpuw3d3qzbnaqnUWJOo5+4FRSa17e3zfLchawU8D0NGqRYPgW/uZaMzcXll
         uC8tCyaPQ0ujEskxxPHyZeOFWZOwYAJn3Thp906JRcgYHvTcEsKtl0KRwHZe4h69TW92
         BNDKp49abw6sCDsIaWdnVSgCe1uuev2nuXDXrkmLXxwZ/24WfXk8sYk5JpCeA/y/nzAZ
         TAvKxqfh0X7FIyQKN3Jt2irsDs8EkK0YS82/pohGlxPn2Iy4Qz/1abZNj1KM73X3Rm3L
         Wr0w==
X-Gm-Message-State: AOAM533m47FxPqU3D/oHGgnwFIaSPHIMzF8wmJRkoTpI0XFiKPZq1sdG
        O1Lnjeq7vpdHwLr8RDvsMwvSGlxarQvfGwCt
X-Google-Smtp-Source: ABdhPJyXLQwYvS951/rlrTWJOXNGnXWIKAINkdhVlyT3C8EbkmKsfXNH5PmtybjNIcGiuaJL+JHYyA==
X-Received: by 2002:a17:90b:3001:: with SMTP id hg1mr3024402pjb.169.1622393727207;
        Sun, 30 May 2021 09:55:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s9sm8857704pfm.120.2021.05.30.09.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 09:55:26 -0700 (PDT)
Message-ID: <60b3c37e.1c69fb81.428c5.caf1@mx.google.com>
Date:   Sun, 30 May 2021 09:55:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.7-118-gc6a391109100
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 133 runs,
 1 regressions (v5.12.7-118-gc6a391109100)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 133 runs, 1 regressions (v5.12.7-118-gc6a391=
109100)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.7-118-gc6a391109100/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.7-118-gc6a391109100
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c6a391109100339b463c4e7a3696ae855105f143 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b38a31bf5c82702db3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-1=
18-gc6a391109100/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-1=
18-gc6a391109100/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b38a31bf5c82702db3a=
faa
        new failure (last pass: v5.12.7-69-gd4f1b01eb53c) =

 =20
