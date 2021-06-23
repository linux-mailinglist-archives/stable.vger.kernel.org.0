Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B753B21BD
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 22:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFWUXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 16:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWUXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 16:23:49 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E089C061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:21:30 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c8so3255062pfp.5
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vekwraM1oyMJQmHw+/C1PptZPaGJlT10ucfxOY9PbBQ=;
        b=Ljv00R8jXKdGrpx6zEEZJQJYqylyrRUTgOe0DH10zLAzZEycJ126Cw5/Opp2Qs82vb
         Hp6ffhYRMWkp62grGlIMG6wBcRMshE8srj6hNLrOs/gxj+GfBlZgHHiZy2n1ArmkExe1
         0wvHOVYoimLni89mMSeBkIY7jI8wIYyGLXHf3GOjZggBAR2hAvOGiFHLF19BwohCacxG
         AG6EnJykKa9rWJSG/hEGIDkQADQfb1iPhv4JcGc5ZpKKU2Ex1ab9igTBtAuq/c5wHP/L
         o1XkCNhuDOlHjONV0SxCzJ5EWXJHOtO1Lgu+P/fshzRfkj+7IJp8wdPDSaYZuBJi3uZ5
         Gb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vekwraM1oyMJQmHw+/C1PptZPaGJlT10ucfxOY9PbBQ=;
        b=k3Te3c7lPjdHWN5+4fGHJZAB0FSRbLFlMbD9mDXxvTbudrvzU3iYF9LrzjakVnPZA7
         WAqESkVuZxkf2ew2qnYUnrELS6M9tMUBfS8Q06hax5mYxVGVN2wj48qqApi5yQQu9PYr
         7UGraE06KTWoMEIPfclpJyi7TQp0a4mjZsMoPkVLiov2ODJXfwTAoIoBl5/jAn+7FxDO
         hyZ3dBzzrMBbI1SaevAo37BZkYZbO4VYHybFIwF4Qpnt8MS9hoxRqhzVDLC7twq01RLB
         Zr0kIbEdMMrkgZx5Hv0XkzzH31nUJqpxbo5oG9xyLI1VBbKhDnyLLX4bxO/wZOuVAUR5
         tfDw==
X-Gm-Message-State: AOAM533v7ls7rlpekyu5chaleLwjjm61fBaNXR8+rRoHCVNSdYkqZ8vn
        C5IXMUhoN3DSXq5+ZnOZCb/l1o5a9x2E3bze
X-Google-Smtp-Source: ABdhPJwRiUufACCx9GabMK1gLJ/VHYOtKhhI66saWeC0GC27UittyewWxtTVjuDvGV32oc7dLiHg+A==
X-Received: by 2002:a63:4653:: with SMTP id v19mr1154763pgk.240.1624479689900;
        Wed, 23 Jun 2021 13:21:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 21sm613400pfh.103.2021.06.23.13.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:21:29 -0700 (PDT)
Message-ID: <60d397c9.1c69fb81.92d88.24fa@mx.google.com>
Date:   Wed, 23 Jun 2021 13:21:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.45-144-gf00ac70b7013
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 181 runs,
 1 regressions (v5.10.45-144-gf00ac70b7013)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 181 runs, 1 regressions (v5.10.45-144-gf00ac=
70b7013)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.45-144-gf00ac70b7013/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.45-144-gf00ac70b7013
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f00ac70b701340965113729227a4eb1943484a47 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60d3610e4bd4b74d07413274

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-gf00ac70b7013/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-gf00ac70b7013/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d3610e4bd4b74d07413=
275
        new failure (last pass: v5.10.45-144-g9affbf10e0b6) =

 =20
