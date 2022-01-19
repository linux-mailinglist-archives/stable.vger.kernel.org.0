Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692414941ED
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 21:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiASUkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 15:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiASUkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 15:40:51 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21B4C061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 12:40:51 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id q25so3357443pfl.8
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 12:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8cYsunmArAHi6VKmMViAwUl+Q3fLhiBJAXa+mB+Isuk=;
        b=0MNwObS/pen/uaYaNFoipD5pG4s+RrMbFWcQYkBLcV6L9+HWCvS3OVddmc/mhP92j3
         Wi4hCk/cV1MhvOZFA2RQinQ/XcriKnUdvgXa2/UxgvRI0/UcyipiFlFbNM9h34zVXLJ7
         se1+vWWnVIGdT5FM0RLH0O8PRHnWY6w+c31tor5HpJBxcSfRjogheY1Nr3bTgpSfxjgc
         p2kFNghVKYLfR/11YedL27J+BW+P4obTZb6IfOOWTY5CbojZ/JZdL47iTM5AdZ/vOi7W
         7FSBvSuFIZZJUuvnCBBmVS0IAFgBNNUPIQm+jrUYUW3hHqSInVxU81T2OBfDGPp7oscg
         UzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8cYsunmArAHi6VKmMViAwUl+Q3fLhiBJAXa+mB+Isuk=;
        b=YROq2azw44bV2pkJ+vZXSg12H1MPr3w68DRGjrbznej9ze9GJDm6lP5z1RHO52Mxea
         Dh2YCa+SySdyW79Cbk92/x5Q1HnOIsIdzWqLOJu7WtbJhbAhYPidJaP/x5YW3BVuXYbL
         NXoAVB26J7OhrVc8oYfIYP4Pq8mIMZ2YboMlavBcZODaPVf72KzTKxzYh/4H3fcgRAKK
         zDK30tWjZTygGnHGXLSZsertNdZetgJgWGFaBPt6vDDXqhzv6yfuSYkb/g7PT9h/JZ7B
         cbH0n+Ur+zBMZMaIke7xf5txDkaCpv0zKtkGoD+DEYs+Cyk3jzw2cI+dOG+7XYBcFBzU
         +EdQ==
X-Gm-Message-State: AOAM532TJf4H0F5xAv57kefdEFnT0RbXq/ggS1jDo+fIF2KrQTuZyyvo
        9Oqc5KBNd3oKhVntDKeW0Z1FnPiqNG4mp6cz
X-Google-Smtp-Source: ABdhPJykH8qLtSocCyK8i//kBmaHp+GsPPNdepQPP0wao/nAkXa4ndcQdPw5coPRNgUztoNyvN2TvA==
X-Received: by 2002:a63:b145:: with SMTP id g5mr28694014pgp.113.1642624851060;
        Wed, 19 Jan 2022 12:40:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t23sm458288pgg.30.2022.01.19.12.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 12:40:50 -0800 (PST)
Message-ID: <61e87752.1c69fb81.f2893.1fb1@mx.google.com>
Date:   Wed, 19 Jan 2022 12:40:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16-66-ge6abef275919
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 153 runs,
 2 regressions (v5.16-66-ge6abef275919)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 153 runs, 2 regressions (v5.16-66-ge6abef275=
919)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =

r8a77950-salvator-x          | arm64 | lab-baylibre  | gcc-10   | defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16-66-ge6abef275919/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16-66-ge6abef275919
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6abef275919520e9b5c12946901b612c40c4d17 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61e84533e3b28ff690abbd35

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16-66-=
ge6abef275919/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a311=
d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16-66-=
ge6abef275919/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a311=
d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e84533e3b28ff690abb=
d36
        new failure (last pass: v5.16-66-g0a52f03a4702) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
r8a77950-salvator-x          | arm64 | lab-baylibre  | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61e845ce88f2b4798fabbd48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16-66-=
ge6abef275919/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvato=
r-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16-66-=
ge6abef275919/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvato=
r-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e845ce88f2b4798fabb=
d49
        new failure (last pass: v5.16-66-g0a52f03a4702) =

 =20
