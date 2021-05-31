Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1523954CC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 06:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhEaEvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 00:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhEaEvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 00:51:31 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D851CC061574
        for <stable@vger.kernel.org>; Sun, 30 May 2021 21:49:51 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r1so7430392pgk.8
        for <stable@vger.kernel.org>; Sun, 30 May 2021 21:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WP1v9CUt/EfWBRts+ovyE3432nJPMtxM7zLZ2C7TAzc=;
        b=nq24BwQcOTyOuhX9qESDUsXh8JcQ3OzPz7+UrQLoJu6mW97jHn/RfrhtdMD+1Z7OV/
         x7u0awgr5y1sPHV8LsK7h3Q/o5tO5jWvKA+NBu+4K0+2D3iMgir1p+Rbr/+EwYVhOunN
         iBdoKZFU568kTrTDFsilcFzEWNKbVM0zuEs6XrVimbyFl0PyoZ/xNVlIyWoE10yBTpNA
         OyTnMsrcZLSXJTHPY676ggeE+8WhyThU/sApqnzEzodOINS6R/DY1OcjtxGnpcFfwHe5
         kfZEjlU6zM0Llu1h1SCNlw+jKhkj2ns4PeucGux6DIFDtX7tdvP71Wk7UgSS0ZhRCu/5
         q6sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WP1v9CUt/EfWBRts+ovyE3432nJPMtxM7zLZ2C7TAzc=;
        b=P6rnSATk5UqOuz239Af193bQDMBrssnuhwsYBkkaNfPwf2rECk999fhmtIc/bQqENj
         sUXaIBPtuIbKCpEdkMV5sFht2TBwg2HDJp8RiWfbsFrjviXNUiKokGxAtxFQ9k+Olpru
         2yjLokFX0OZGgF0DWWYbHXgxtBZVlzLzBzsyB1PZLxG8/MU/F3i2H6F7lMLCeABXAVDa
         pRRu34n7LoTVXMD7/uGc0F4LoR9JtbqScpNiu/aDnN4IxG/RsD31Io1EbzhTMSKDmOmf
         MsqoTckKyqv/5i9gjqeOUGcXuGJqYZgBKHjcUpU+vX9aRaYDBN/AGedkcwbruv0uKTco
         q0bA==
X-Gm-Message-State: AOAM532+XJesnAmTx55JabcXDUGTinvaVxXRXgBCzJVTUeEji+8GZduY
        XRssdhNcLuCEpzGgjO/jWmRBcHEsWGCpeBC3
X-Google-Smtp-Source: ABdhPJxDVbi/X5GUYfh6Wrrx9toRNSAu5PSUAa1tFqUkSzyBq9NElnOrGR6TTDQTJBYOd61BggwPoA==
X-Received: by 2002:a62:1496:0:b029:2e7:2674:147 with SMTP id 144-20020a6214960000b02902e726740147mr15620269pfu.51.1622436591156;
        Sun, 30 May 2021 21:49:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b24sm2262768pff.58.2021.05.30.21.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 21:49:50 -0700 (PDT)
Message-ID: <60b46aee.1c69fb81.fcab2.70e3@mx.google.com>
Date:   Sun, 30 May 2021 21:49:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40-198-gc51a6e59c823
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 200 runs,
 2 regressions (v5.10.40-198-gc51a6e59c823)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 200 runs, 2 regressions (v5.10.40-198-gc51a6=
e59c823)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.40-198-gc51a6e59c823/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.40-198-gc51a6e59c823
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c51a6e59c823b286deb695a5e4c9cf6c90e32273 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b432790b3e7298aeb3afb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
198-gc51a6e59c823/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
198-gc51a6e59c823/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b432790b3e7298aeb3a=
fb9
        new failure (last pass: v5.10.40-139-gf93ddb6581f8) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4352a998ea139b1b3afc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
198-gc51a6e59c823/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
198-gc51a6e59c823/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4352a998ea139b1b3a=
fc5
        failing since 0 day (last pass: v5.10.40-98-gef1477410758, first fa=
il: v5.10.40-139-g2cb2acbbafd8) =

 =20
