Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AB83DF436
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 19:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbhHCR4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 13:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbhHCR4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 13:56:33 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B4AC061757
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 10:56:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j1so30659775pjv.3
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 10:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Kt9EZ2G/5XbgcUSGwJEjkPSnWSfRP/Il7zR+8sysfZ4=;
        b=Y/GF8ZUggivOu4AG3ughf4h6/o5FypjD8grXvhG5ZnPjUHh/NC6Www+UbCqLxHm53d
         VP38e9mXqU/pGP1iVkE6LrZBEx+zsTmmcHRxR2SCpveEvtlArfrUxLYF+390e5l5Sgtv
         guh/vVzd0wSbTmHKZMVe/UDfqpYt6/TiIaQ+gtzFKVfww7c3dchMIpY05SmMv+lcakmT
         Fd4JspN+tmCuehdo1ejjOZOt8jDxRQ39b9eflLht6ThNfW7Jqn8QAx2smvH67IxPJjG7
         E69iAIrHgMC9npOQ3aGPuhKl7mfxEKiLlS3T4OR9RIYFvgHe7V9MOnzINa3Yo+z7J0Df
         h5og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Kt9EZ2G/5XbgcUSGwJEjkPSnWSfRP/Il7zR+8sysfZ4=;
        b=NuXUEa0fL7AN1EzU41KgKoujWbyhFA7yFQ7zNNURqfxZssqJv41CIvcfWNUpR8ZJGJ
         irCrjQLBtiv9wPNKPponNzuY3m/RMrOLhWMiR5SXFfylUqF3Hp8rNwSs0iBtqDHmRNeU
         Ev0eQowUfEHA7U6mY6JrJnSmNAcOdv3oV1XvFypE6YaIs0B1x0TarPxFdBzjbU90RVAb
         ZQvZRhWDaug5MZKQPsijXWP3NMkmNx8eb9QgwtVbIg/LzjQHVKKMxaGh3wIRyvca0IlM
         UCDV2Y9K35MwwNN2l9SyuT5OITJujqdZp1KK7jjQE3cEtIB1F4mSoZWXsZqVPK27nM/P
         erMw==
X-Gm-Message-State: AOAM5312gD/OACOMoBr2XNIdR+YH13Bh5xuQPu5Gp1tWXEzQataO61F3
        dEJe3NM5w02ADGgg4ym2ZLMJG0ofX5r8Trkm
X-Google-Smtp-Source: ABdhPJwc9KQxaoPIbmzLvFy463/E/Yd/wOQ8Sn65Zofl9R0kPQTnzG1BtBZRF/QGJpgBsMvU7kUDmw==
X-Received: by 2002:a63:556:: with SMTP id 83mr904014pgf.1.1628013381372;
        Tue, 03 Aug 2021 10:56:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e27sm11533028pfj.23.2021.08.03.10.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 10:56:21 -0700 (PDT)
Message-ID: <61098345.1c69fb81.ab9cd.127c@mx.google.com>
Date:   Tue, 03 Aug 2021 10:56:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.7-13-g46719403ead9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 191 runs,
 3 regressions (v5.13.7-13-g46719403ead9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 191 runs, 3 regressions (v5.13.7-13-g4671940=
3ead9)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =

meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.7-13-g46719403ead9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.7-13-g46719403ead9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      46719403ead9ebb7bcdfa04ac1a6ba3d1884dcca =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =


  Details:     https://kernelci.org/test/plan/id/61094c1bad150c2adbb13698

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
3-g46719403ead9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
3-g46719403ead9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61094c1bad150c2=
adbb1369c
        new failure (last pass: v5.13.7-117-gc89230bd6b35)
        137 lines

    2021-08-03T14:00:37.860885  kern  :alert : 8<--- cut here ---
    2021-08-03T14:00:37.862200  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000000
    2021-08-03T14:00:37.862960  kern  :alert : pgd =3D c3b8496a
    2021-08-03T14:00:37.863662  kern  :alert : [00000000] *pgd=3D035c6835, =
*pte=3D00000000, *ppte=3D00000000
    2021-08-03T14:00:37.864810  kern  :alert : Register r0 information: NUL=
L pointer
    2021-08-03T14:00:37.865534  kern  :alert : Register r1 information: sla=
b dentry start c28e3770 pointer offset 0 size 40
    2021-08-03T14:00:37.866191  kern  :alert : Register r2 information: NUL=
L pointer
    2021-08-03T14:00:37.866832  kern  :alert : Register r3 information: non=
-paged memory
    2021-08-03T14:00:37.905419  kern  :alert : Register r4 information: sla=
b dentry start c28e3770 pointer offset 0 size 40
    2021-08-03T14:00:37.906778  kern  :alert : Register r5 information: non=
-paged memory =

    ... (114 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61094c1bad150c2=
adbb1369d
        new failure (last pass: v5.13.7-117-gc89230bd6b35)
        237 lines

    2021-08-03T14:00:38.564402  kern  :alert : [00000000] *pgd=3D0359f835, =
*pte=3D00000000, *ppte=3D00000000
    2021-08-03T14:00:38.565171  kern  :alert : Register r0 information: NUL=
L pointer
    2021-08-03T14:00:38.565786  kern  :alert : Register r1 information: non=
-paged memory
    2021-08-03T14:00:38.566379  kern  :alert : Register r2 information: NUL=
L pointer
    2021-08-03T14:00:38.566966  kern  :alert : Register r3 information: non=
-paged memory
    2021-08-03T14:00:38.567553  kern  :alert : Register r4 information: sla=
b dentry start c28e32a8 pointer offset 0 size 40
    2021-08-03T14:00:38.604597  kern  :alert : Register r5 information: non=
-paged memory
    2021-08-03T14:00:38.605848  kern  :alert : Register r6 information: sla=
b dentry start c28e32a8 pointer offset 0 size 40
    2021-08-03T14:00:38.606521  kern  :alert : Register r7 information: sla=
b dentry start c1802088 pointer offset 0 size 40
    2021-08-03T14:00:38.607503  kern  :alert : Register r8 information: non=
-slab/vmalloc memory =

    ... (226 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/6109520d32c808e408b136a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
3-g46719403ead9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
3-g46719403ead9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6109520d32c808e408b13=
6a4
        new failure (last pass: v5.13.7-104-gf0ecd7adb24d) =

 =20
