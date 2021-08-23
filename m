Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387ED3F45FA
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 09:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhHWHsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 03:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbhHWHsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 03:48:21 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03C9C061575
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 00:47:39 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j187so14603961pfg.4
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 00:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AX5mM4+Zo/FPi902k0cTixKSACWXKIp47Ip4saeSKaI=;
        b=VTkY3rVtwAwSTDsccy8ROklIuHPsf1UskOSeMib15UdOo+G1Z/bNUI9j9qlHozoAAU
         d2a5nfU4bQVC96tYQJIkJ1+88gWss/UVcxeTOfG6OLZ4rwam7v39tDaLF4mcttMQ1WbG
         gfYU7zaSaGF2FJTvoL1CRJ6rcf5k1uZkQnHfKwL4kyAYOVBVwKXVrdyjfY+rsCql/G2J
         KUR5IDz6IatC5wjCVIEDfdyzELdvRUcSXz2cNJf5fbRe3xUxvRbLmgwKLgJvaYkUlYoB
         juDKAFmON4sa+TGSqCz+VVa1i/KZbc/bbRwVhCDkW3/tfJfIU2UMw+XdQReoA9LeHLJp
         NCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AX5mM4+Zo/FPi902k0cTixKSACWXKIp47Ip4saeSKaI=;
        b=pX21VMl2LB/Telvh+uO0kcnml+qig9AhlQ9sTzS4CNhe5+gaMzXFDP4WPuKUbp/esU
         H8hRMy3QKC2Q9x0kZOCdTauGR0+LpWIV/pq7ZzcTtplNNm4VeJARdjFfkHMlSzLQGEIl
         ZBdAyRXeM3XtgpSxZ7ccpgk+itZlvrcmKH3JS374NtbUnJPsnW2yZznb84WHWDR7x4b8
         rhf1G/La13EIyheXj6vftZc8CQWfUQqUNmBYp7a7QJcATHf0pC9KtkR5MQVZTNcIWQX+
         aKJiKFlucFWmFKep78ubbEUfs3bnCGGANI9sxhivOKyK01OyT/l6Er8iMzHLLC5HALA2
         GYtQ==
X-Gm-Message-State: AOAM533G4KTXMaeggl1jY6Gs3gw3+CisafpH9Vz9L/2TZpMhg73mQxqj
        z9PrOewG3O4hIAbz/7IjOgdMWu4w4Om1wXky
X-Google-Smtp-Source: ABdhPJwTEi7h1A0w9AChz92Q0JyrF8sZoZfy/UNDnpWfmypJqJEByYh840Odr3msP0/jG4gmzYhPeA==
X-Received: by 2002:a05:6a00:2295:b0:3e2:2cf5:47b9 with SMTP id f21-20020a056a00229500b003e22cf547b9mr32630620pfe.1.1629704859313;
        Mon, 23 Aug 2021 00:47:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p3sm15114881pfw.152.2021.08.23.00.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 00:47:39 -0700 (PDT)
Message-ID: <6123529b.1c69fb81.22143.cc66@mx.google.com>
Date:   Mon, 23 Aug 2021 00:47:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.281-20-g03cc210cbc44
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 71 runs,
 1 regressions (v4.4.281-20-g03cc210cbc44)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 71 runs, 1 regressions (v4.4.281-20-g03cc210c=
bc44)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.281-20-g03cc210cbc44/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.281-20-g03cc210cbc44
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      03cc210cbc448d75042fcf3fb838e1ba1be0dde2 =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/611ee9e608645526e4b13666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.281-2=
0-g03cc210cbc44/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.281-2=
0-g03cc210cbc44/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611ee9e608645526e4b13=
667
        failing since 1 day (last pass: v4.4.281-11-gd362d998f31b, first fa=
il: v4.4.281-15-gb79b089409fb) =

 =20
