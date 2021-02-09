Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F5F3148FB
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 07:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhBIGiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 01:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhBIGhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 01:37:25 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584E5C061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 22:36:45 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u11so9169001plg.13
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 22:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bw6fKDVthjprpqXjyDjojaSz/DnU5svA9Gl7eo4j/zM=;
        b=nlvCSMQX011oNoa6UUVI9lr5RGUygYnVeGZCyQfZDm7WZSC1OTFhryqFtMjlWyrEH/
         2yrkI28B9fJ9KuToZ7qrcjo4IManBfGo8n3fab2FW0nKZDWFXeTVXiKugo4jigJ8c7lS
         MWirZQIB7Lul4Ykd0TzKqPMZrKuTtl5vpeE1fmXUrbZGmq2pPot44cJNn4MMb/ZAhxX2
         I+lqTwR5wjKog/NkCQGbIS8Igi0YcDmkfjE37IFzspciGlBPSP6wowXA0syPSgOlmINf
         4iA5sJTlMpucsAx4eL1Mid03kRneu4cOKH6BJ5HXD34BITLsPJKgUqQ0TNY77J3PXnn6
         Dt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bw6fKDVthjprpqXjyDjojaSz/DnU5svA9Gl7eo4j/zM=;
        b=PCRG/n6EyHR9Hv0TL/wN2vvGIRFi48KTTiyiNCUyriHj2xfWLSLbOd+irKuw3tKl9R
         xRIloR2SuztiastMi50gEiF+GBjS5yJMc9u95M8+drjZbuu8f9390/2TJMFSWx66/L5L
         xtM6A+BsVuUhKBPsQwxTjuibeEgKpKlJqOCQWdJnURdj8QoYpepEKyOD5UXwKJJBEalY
         nPGAZznM/ZPRdZpQoxiJm5+F9ke22TVTOoGT8vUlkO6jqTVUzVZWf2rP5KHbqepy4Yea
         dOgTy34L/oJ61eChDSDDtz6RJRnBxcXe2fyQSfdba43VDX3fTpkQ7EGR4Na2p3LMAOSL
         EwwA==
X-Gm-Message-State: AOAM531VeKBAhFj7aiLip7HlmrZ+1JK0oztrMbBli4zBvfcNgscNs8QX
        54Q86XWIxURrV9codjrNFgA7S5biS6j9zQ==
X-Google-Smtp-Source: ABdhPJw8+KS8zPi+ZJTSqvkM3Ku3404EMTNfBssLa0HPsw/2/V/Im9BHLwGcCQcGbfdTgX+OJJPIMA==
X-Received: by 2002:a17:90b:46c5:: with SMTP id jx5mr2600720pjb.27.1612852604523;
        Mon, 08 Feb 2021 22:36:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lr7sm1213163pjb.56.2021.02.08.22.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 22:36:43 -0800 (PST)
Message-ID: <60222d7b.1c69fb81.a971d.3a43@mx.google.com>
Date:   Mon, 08 Feb 2021 22:36:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.220-31-gc7c1196add208
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 68 runs,
 3 regressions (v4.14.220-31-gc7c1196add208)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 68 runs, 3 regressions (v4.14.220-31-gc7c1=
196add208)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =

meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.220-31-gc7c1196add208/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.220-31-gc7c1196add208
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c7c1196add2085d4956a80729d2832ef83d963c8 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/6021fbd3dbb7f58be53abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
20-31-gc7c1196add208/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
20-31-gc7c1196add208/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6021fbd3dbb7f58be53ab=
e63
        new failure (last pass: v4.14.220) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/6021fbd0af0cd028583abe64

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
20-31-gc7c1196add208/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
20-31-gc7c1196add208/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6021fbd0af0cd028583ab=
e65
        failing since 314 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6021f91e55b8f655583abe9c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
20-31-gc7c1196add208/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
20-31-gc7c1196add208/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6021f91e55b8f65=
5583abea3
        failing since 1 day (last pass: v4.14.219-16-g9bdfeb6e50d8, first f=
ail: v4.14.220)
        2 lines

    2021-02-09 02:53:14.569000+00:00  [   20.237854] usb 3-1.1: New USB dev=
ice found, idVendor=3D0424, idProduct=3Dec00
    2021-02-09 02:53:14.576000+00:00  [   20.245239] usb 3-1.1: New USB dev=
ice strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
    2021-02-09 02:53:14.604000+00:00  [   20.276824] smsc95xx v1.0.6
    2021-02-09 02:53:14.621000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/93
    2021-02-09 02:53:14.630000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
