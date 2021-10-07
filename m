Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF84424BBB
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 04:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhJGCUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 22:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhJGCUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 22:20:33 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFFAC061746
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 19:18:40 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id oa6-20020a17090b1bc600b0019ffc4b9c51so5751536pjb.2
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 19:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/1cW7u3dewch40FD9wKP2uAWeF6NpZg86lQc/Y6Vu00=;
        b=P6haqpjESROqONw8eJafBcbK896W4wKwBmioOSeqAtfYQBbOmivvfkb4qwTN+y+MZk
         e92PdBVK6KxkAkcjGIZsXjEm9NnJJNpIZjjpSQY5aDKrZTMCvPA1Uf/5ORQFjNh3iFRj
         GS6q8MMYztlP1qD9VhxP0GSbCVIKeZX/L9GnQzA34JH+s3eK35bRA4CRWyokvmD7EBEu
         wSYHgY3y1WBeeI17pSQXE/RYU81+s4FrZuup7HRbjFrVZYi2mw5qyaH8TkBnO/Yq+VRy
         ydrAjN3CAexlhFx7QlnfNpg92Hy/wVp6juEgI9jLGGqwZzD8h9VHGviLKPJtV8F8zvpo
         x7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/1cW7u3dewch40FD9wKP2uAWeF6NpZg86lQc/Y6Vu00=;
        b=tyXjBx85zyKVOJD0qqH23NgA/O0UkAObR8cwCLzmU9F0dMlObKE8lNWAKMKtYP2pgQ
         ZaAzQOBE0cxtQw49R9hOYcQ7NjsV1gt6yC44tj2gvVyNkDs4OZ7qqZPNsuLttK4ok3b9
         ewTKQC4YfURqcYcTqyNYNSribDXzQf0Swuzj2PMA5D1zhv3rNS3JHFDYEk5ESSaTGOnn
         0svdz0bgk9aUeUvfzp+yOxfsVjJGqDOrCFpuUTJVCe/+aBR6jf7hKPCGwBNwjBZhu+lD
         pHY4WUQf9AVGXHGcXh+uIm3U2mNwcIcUm0p0dJYzVWQydYu8IdlYgYR4oW8T+8n2AK9o
         KhVQ==
X-Gm-Message-State: AOAM533angTKWw4+Pl8u4O/hFE5pthgKhwxbve3nlRFvkhYKe27nvdCV
        s58FZ17r3PKz0mXocqa3CYRXvqSQL2hh3nBl
X-Google-Smtp-Source: ABdhPJx+oLeQAPM+8CTbB9g2z5x72rglaDt2ljZDtFwbVBOQbBIc7sATqnDAfJw+YTTYB5FGUL3QGg==
X-Received: by 2002:a17:902:7b84:b0:13b:90a7:e270 with SMTP id w4-20020a1709027b8400b0013b90a7e270mr1261278pll.21.1633573119877;
        Wed, 06 Oct 2021 19:18:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y3sm6763718pfo.188.2021.10.06.19.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 19:18:39 -0700 (PDT)
Message-ID: <615e58ff.1c69fb81.fbb64.5786@mx.google.com>
Date:   Wed, 06 Oct 2021 19:18:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.9-172-gf4ca9a7e9815
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 181 runs,
 3 regressions (v5.14.9-172-gf4ca9a7e9815)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 181 runs, 3 regressions (v5.14.9-172-gf4ca9a=
7e9815)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =

beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.9-172-gf4ca9a7e9815/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.9-172-gf4ca9a7e9815
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4ca9a7e981528a812428446aa879aff46714c10 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/615e257639608f574c99a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
72-gf4ca9a7e9815/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
72-gf4ca9a7e9815/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615e257639608f574c99a=
2e7
        failing since 1 day (last pass: v5.14.9-172-gb2bc50ae5dd9, first fa=
il: v5.14.9-173-g4ad9884c65e5) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/615e249a9af5b3c4cc99a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
72-gf4ca9a7e9815/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
72-gf4ca9a7e9815/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615e249a9af5b3c4cc99a=
2eb
        failing since 6 days (last pass: v5.14.8-160-gc91145f28005, first f=
ail: v5.14.8-160-g69e08636c9b8) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/615e260a3eb52ca28499a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
72-gf4ca9a7e9815/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
72-gf4ca9a7e9815/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615e260a3eb52ca28499a=
2ed
        failing since 2 days (last pass: v5.14.9-73-gb9d08ffadf94, first fa=
il: v5.14.9-172-gb2bc50ae5dd9) =

 =20
