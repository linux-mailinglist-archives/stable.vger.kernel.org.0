Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBAE29FAC1
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 02:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgJ3Bty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 21:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgJ3Btx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 21:49:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96697C0613D2
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 18:49:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id b19so2217162pld.0
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 18:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4aJnFs0iJi+vdbDlrE4sxFbPPPzFFcuUE7yxnylBvQ4=;
        b=iaxxC2crWw3K/21wIJ5hQdp4qkW7Ijq0nIEEWhztvDYpllgHNf8otXWxKfT59aqae+
         b7D/X31C9ZRt8HVPuo1Aolur8qE2uH4drqOK680F4pwYSBAaFi7TEMJsxSBAX4Sp9AU6
         RbDfOziRHdg+Yj87eAVf4eESbj5TDlxbeVhar0FiRG48GZmZDH/w/qoziuekM553hgf6
         znq97OpuFXCFObG99sIMxTBKU0Z5XyxX88IwEXBP06LNlGivlDnSTl38Di9jaugXP1B4
         acezWhmEhyWW5CO70ZX6VEg7dvwG2Yz0TK+u+t82um1SX+67exBEhz1YqivdRe/p+sKm
         Ig9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4aJnFs0iJi+vdbDlrE4sxFbPPPzFFcuUE7yxnylBvQ4=;
        b=ImSbKf4sL3dkmE+hwzFljdYGh7l6yBxaWqW3Atmx7WIkHS9Ef4abr0WYp2UpWHRKbx
         mv0VNu4bS8jM+ecHjWJod0vkwBdkW7pa18PhClvzg6239c2u0SoLoYm+bnYiAaibQoKg
         vVRhnnSWwiQZmPVw/J8nKT7oC/rtcW3bEIB0D3FV4xuv/bV3ryoZ583aIqx4AEH3Z3ls
         j3AsQ8NcKmLyXBmvv3OUppTe7H2RU56SDiVyzRSzgvu9WlHRTl4IyMByhPN+mh9RLzxb
         ppTkACRLWo5OvwvNqIp6AyNGs18ZN/Mu90UFtIhFZ/fsVOH0mx8PF+OFECgry7n6FrS0
         OmTQ==
X-Gm-Message-State: AOAM530ORIOwkFwZlL/PDpx9CpsBsFvtautEWm1fW+Es9pBHwn7PaozV
        EUHWzzwXceAw4iwQwYW0ZMdis9ZK6jeSYA==
X-Google-Smtp-Source: ABdhPJzhvf6Tlqh6UUs2W/OSeY6485D6Lqv6ef12/oGtQi6le7IvQvpo3hmwBVFwB8LYysVlAoVF3w==
X-Received: by 2002:a17:902:9a84:b029:d2:9390:5e6 with SMTP id w4-20020a1709029a84b02900d2939005e6mr6864723plp.37.1604022592601;
        Thu, 29 Oct 2020 18:49:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w31sm1163106pjj.32.2020.10.29.18.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 18:49:52 -0700 (PDT)
Message-ID: <5f9b7140.1c69fb81.d5829.379a@mx.google.com>
Date:   Thu, 29 Oct 2020 18:49:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-4-g71c7677aa3c2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 122 runs,
 4 regressions (v4.4.241-4-g71c7677aa3c2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 122 runs, 4 regressions (v4.4.241-4-g71c7677a=
a3c2)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig           | regr=
essions
------------+--------+--------------+----------+---------------------+-----=
-------
beagle-xm   | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig | 2   =
       =

qemu_i386   | i386   | lab-baylibre | gcc-8    | i386_defconfig      | 1   =
       =

qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-4-g71c7677aa3c2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-4-g71c7677aa3c2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71c7677aa3c2a5548cc64e5afbf63e51c1f8e0cd =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig           | regr=
essions
------------+--------+--------------+----------+---------------------+-----=
-------
beagle-xm   | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig | 2   =
       =


  Details:     https://kernelci.org/test/plan/id/5f9b3ff637d4012d0438103f

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g71c7677aa3c2/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g71c7677aa3c2/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9b3ff637d4012d=
04381044
        new failure (last pass: v4.4.241-2-g0b3b9f46127e)
        1 lines

    2020-10-29 22:17:37.042000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-10-29 22:17:37.042000+00:00  (user:) is already connected
    2020-10-29 22:17:37.042000+00:00  (user:) is already connected
    2020-10-29 22:17:37.042000+00:00  (user:) is already connected
    2020-10-29 22:17:37.042000+00:00  (user:) is already connected
    2020-10-29 22:17:37.042000+00:00  (user:) is already connected
    2020-10-29 22:17:37.042000+00:00  (user:) is already connected
    2020-10-29 22:17:37.043000+00:00  (user:) is already connected
    2020-10-29 22:17:37.043000+00:00  (user:) is already connected
    2020-10-29 22:17:37.043000+00:00  (user:) is already connected =

    ... (495 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9b3ff637d4012=
d04381046
        new failure (last pass: v4.4.241-2-g0b3b9f46127e)
        28 lines

    2020-10-29 22:19:29.551000+00:00  kern  :emerg : Stack: (0xcb92fd10 to =
0xcb930000)
    2020-10-29 22:19:29.559000+00:00  kern  :emerg : fd00:                 =
                    bf02b8fc bf010b84 cbc39c10 bf02b988
    2020-10-29 22:19:29.568000+00:00  kern  :emerg : fd20: cbc39c10 bf21e0a=
8 00000002 cba58010 cbc39c10 bf24bb54 cbcba8d0 cbcba8d0
    2020-10-29 22:19:29.575000+00:00  kern  :emerg : fd40: 00000000 0000000=
0 ce228930 c01fb3d8 ce228930 ce228930 c0857e88 00000001
    2020-10-29 22:19:29.584000+00:00  kern  :emerg : fd60: ce228930 cbcba8d=
0 cbcba990 00000000 ce228930 c0857e88 00000001 c09612c0
    2020-10-29 22:19:29.592000+00:00  kern  :emerg : fd80: ffffffed bf24fff=
4 fffffdfb 00000025 00000001 c00ce2f4 bf250188 c04070c8
    2020-10-29 22:19:29.600000+00:00  kern  :emerg : fda0: c09612c0 c120da3=
0 bf24fff4 00000000 00000025 c040559c c09612c0 c09612f4
    2020-10-29 22:19:29.609000+00:00  kern  :emerg : fdc0: bf24fff4 0000000=
0 00000000 c0405744 00000000 bf24fff4 c04056b8 c0403a68
    2020-10-29 22:19:29.617000+00:00  kern  :emerg : fde0: ce0b08a4 ce22191=
0 bf24fff4 cbc321c0 c09dd3a8 c0404bb4 bf24eb6c c095e460
    2020-10-29 22:19:29.625000+00:00  kern  :emerg : fe00: cbcdccc0 bf24fff=
4 c095e460 cbcdccc0 bf253000 c040617c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform    | arch   | lab          | compiler | defconfig           | regr=
essions
------------+--------+--------------+----------+---------------------+-----=
-------
qemu_i386   | i386   | lab-baylibre | gcc-8    | i386_defconfig      | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/5f9b3ddca7674ac79e38101e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g71c7677aa3c2/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g71c7677aa3c2/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b3ddca7674ac79e381=
01f
        failing since 0 day (last pass: v4.4.240-112-g1a1bb4139b4c, first f=
ail: v4.4.241-2-g0b3b9f46127e) =

 =



platform    | arch   | lab          | compiler | defconfig           | regr=
essions
------------+--------+--------------+----------+---------------------+-----=
-------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/5f9b3ea6ded2374efd3810a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g71c7677aa3c2/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g71c7677aa3c2/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b3ea6ded2374efd381=
0a1
        failing since 0 day (last pass: v4.4.240-112-g1a1bb4139b4c, first f=
ail: v4.4.241-2-g0b3b9f46127e) =

 =20
