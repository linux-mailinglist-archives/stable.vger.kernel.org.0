Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4496C386D2A
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 00:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbhEQWtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 18:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237094AbhEQWtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 18:49:24 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C908BC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 15:48:06 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so440104pjb.2
        for <stable@vger.kernel.org>; Mon, 17 May 2021 15:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FWMlFoLty/rGHEhO1V+CAmgom2tViOAUgFnJiZJmI9Q=;
        b=sAEX4DDpcHGypXdQ7vOEjO0TypHMbsqSVgiAkrlLzk7KQ4rklfyusqqooh8nqduXsf
         6Rp412er637Y6EUCoEb74UcFl9gi2Ubv90gv+mcacoPJTtRz51Z4qI00+CZSrSaBlKG1
         Pt+GT3JETa+ZTHgNayocbebP1SuvwYGPQxsuE4LrumqioDD6p6TWnhw+43xvDn6fsDdv
         CnEHnpHMewAigvR8X5N5Ptk/SYUWiBESpO2dP1JKHfQwA+0Py92c9iBGjf/c9pnAN2P7
         Ps7QvQZ9J93TLVoJOva9xlZctodGe1a1KXeNIDizGamMK+zGqLEG8YFZshv3hzdqFE+A
         oYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FWMlFoLty/rGHEhO1V+CAmgom2tViOAUgFnJiZJmI9Q=;
        b=R5g0XIwV36j9tH0gErEUrEKCAtfbZEYgjKvx36RVa8Z/iKCpRUi8nSrc+zyJb/Q1gT
         xMbBJrS3+jGfl7DytQlxHr3vx4xR9DSrotjvzGBjL0MNw/gXvlI8TewPv3oUdMaugo7q
         54lPGe4Ijh6C8cgkZrH02kjmpOShSBeHJZN9oD7r9DblU2sySRBax3mYlWCbofACuGA0
         vGoEa7IMlLYZf0FuoAC7Kq2zxl7S81al/d68yEaxT6o5rJWODed3qP0RvdwqCVEKgdK8
         b25i2bPjWpmqwD9ML7P6AS95R+dChRMANEIhC+PpbC3NvXI25tmrSHmS2F6/bbUzZCF+
         Z3LA==
X-Gm-Message-State: AOAM533mCllSB13ju3FNIpsFMnJXN5KPSzcfbTyWbEWSheg/9QFuG50f
        c2dEij93UJd+DXjOiTtDuJLyyiQLhHUZSiIA
X-Google-Smtp-Source: ABdhPJwuIez15oIhof/8HYrPJ5fnS8BWBfuaccf+rLTFjxEQXuzD210PLQBTCbLpBwIyURN/tOPIWg==
X-Received: by 2002:a17:90a:d496:: with SMTP id s22mr1852732pju.146.1621291686155;
        Mon, 17 May 2021 15:48:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13sm6003273pgp.16.2021.05.17.15.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:48:05 -0700 (PDT)
Message-ID: <60a2f2a5.1c69fb81.9b08e.30cf@mx.google.com>
Date:   Mon, 17 May 2021 15:48:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.4-362-g6cee647af019
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 131 runs,
 3 regressions (v5.12.4-362-g6cee647af019)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 131 runs, 3 regressions (v5.12.4-362-g6cee64=
7af019)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig | 1 =
         =

meson-g12b-odroid-n2     | arm64 | lab-baylibre | gcc-8    | defconfig | 1 =
         =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.4-362-g6cee647af019/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.4-362-g6cee647af019
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6cee647af0191fe276b8d531ec23a9d0bd99e176 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/60a2c29e30c5896f38b3afb0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
62-g6cee647af019/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
62-g6cee647af019/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2c29e30c5896f38b3a=
fb1
        new failure (last pass: v5.12.4-363-g103a5cc56863) =

 =



platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
meson-g12b-odroid-n2     | arm64 | lab-baylibre | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/60a2c1dfeb4c30509bb3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
62-g6cee647af019/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
62-g6cee647af019/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2c1dfeb4c30509bb3a=
fc2
        new failure (last pass: v5.12.4-363-g103a5cc56863) =

 =



platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/60a2c1fefe4640df97b3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
62-g6cee647af019/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
62-g6cee647af019/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2c1fefe4640df97b3a=
fa6
        failing since 0 day (last pass: v5.12.4-307-g93ac62543375, first fa=
il: v5.12.4-340-gdc9ee8b28006) =

 =20
