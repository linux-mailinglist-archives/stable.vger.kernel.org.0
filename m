Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C549319583
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 23:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhBKWCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 17:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhBKWCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 17:02:48 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17EDC061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 14:02:08 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id z68so205517pgz.0
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 14:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=REgNLfmxH7Hv8ZyfrxMJdWPvFn6kBslTCsNuB+1uxIk=;
        b=TZtzCtrAJhVr7j6yZWrhGB9xNQ+kQ/jhJCo75j1CRpeY2vA0g47CkylkGnrIJPzhLw
         7qTXHwhVqY9VUzil/nnDjNS6ureotBAVgYTIngtyIt2VeELEIHzjDA+WvT6/sAJQG2eK
         /v4kml91cvBMAQ5qVe1i1Y+4/YL4v7L7kPaERAGYq8uiqpIhGL6Xba+S3AnCGRT/oSeW
         N2/wKrrgfKlWIwp3OUOGG5hWpnaeujVLAtmBdqBReCsBTOKXrOsDzMNGmwPBxLOrGIy2
         9crQIchuLPplMmVb7D0cNI/fVowDpZf0A550lozKDMkEjFEDYW7hIqYGlTWqrxrbz3x6
         JQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=REgNLfmxH7Hv8ZyfrxMJdWPvFn6kBslTCsNuB+1uxIk=;
        b=cJu8cC58u+RE92P0VAV7C0lZsachlkNBKYvBOZn7bvEYvoyNawyCAu0lM7pQJhi6Ae
         Wrnba3NLB4JwR53YlewSXDJY3623QIv7O4EuH09ybSopaURmEH+J+XftgtWVIxFnTwPp
         nDqHSPNtZI2pVUrcpImE2bwS30MO7sDcE1GY3wr5kA2SNu5pLcVnSpCqO9EovidLhIxQ
         ZPgDant339RGVLVqtG80QENlzQ99cSezKuWdgdXTn3+iWY+onCoVn3JcK6ig/SESJX/4
         neVasd/Sl8B6NIW3+FS6xonM9WODC7aKxksAyU7WC3ehTo51EKoljdidzi+qZJipiTyD
         ZB7w==
X-Gm-Message-State: AOAM533kVrSrRqSNWrVPe2yPQP4o8D0eohiWo9xl1SdROSNlIZ4snoOS
        Oho16bXWpeHw/OxLwddxlZycw1oVHjjHYA==
X-Google-Smtp-Source: ABdhPJzL0ExSZwIKXq0ybt3TimZa+WEnFuM4UmzqzTu9gaXDkYaXy8NwmwTeOHhrbQMs4jB/uhVH6A==
X-Received: by 2002:a63:1826:: with SMTP id y38mr217240pgl.252.1613080927698;
        Thu, 11 Feb 2021 14:02:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f33sm6122654pjk.17.2021.02.11.14.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 14:02:07 -0800 (PST)
Message-ID: <6025a95f.1c69fb81.c5122.dd4b@mx.google.com>
Date:   Thu, 11 Feb 2021 14:02:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221-16-gbfa793128f32
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 60 runs,
 2 regressions (v4.14.221-16-gbfa793128f32)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 60 runs, 2 regressions (v4.14.221-16-gbfa793=
128f32)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-16-gbfa793128f32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-16-gbfa793128f32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bfa793128f3295d9ca8e875a1c2ed1cdb0d1a8d2 =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60258a417c73be4d333abe68

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-gbfa793128f32/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-gbfa793128f32/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60258a417c73be4d333ab=
e69
        failing since 65 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6025779845c45322913abe63

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-gbfa793128f32/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-gbfa793128f32/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6025779845c4532=
2913abe6a
        failing since 5 days (last pass: v4.14.219-15-g82c6ae41b66a6, first=
 fail: v4.14.219-15-g8b9453943a205)
        2 lines

    2021-02-11 18:29:41.044000+00:00  [   20.572052] smsc95xx 3-1.1:1.0 eth=
0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet,=
 ce:48:56:3d:7e:50
    2021-02-11 18:29:41.051000+00:00  [   20.585449] usbcore: registered ne=
w interface driver smsc95xx
    2021-02-11 18:29:41.081000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/95
    2021-02-11 18:29:41.090000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
