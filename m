Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF7D2AA8CD
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 02:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgKHBZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 20:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKHBY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 20:24:59 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0035C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 17:24:59 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id z3so4859234pfb.10
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 17:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HW0zUbVcxaK4xAgCR1QsGsfDAEk5tnwMfSVg7Ost8nk=;
        b=kph4F92eEmC8J8KSpWKVO2szm8xb24gDGSmwxlKfLZTMhN9HESMZ1nYqgXGa0DLqyL
         mRKeABboblfEgLMXPuXWhufvR/8l6qrH7SX+F6pNlw0DYQIXS4QyqUGCS8Wxo5Wf+axk
         w4YRCb2fXmwYkkaEgCl6Smr1F+5Q/hA/eaAq4+KHCgUvpmxpgcBlxrEtquI9bzVszuBU
         F3QmevKMArJhDJXkeUfypQxpRNqwTau+FTXXvVE8jJxFkoFU1N3rN5tiFWnVzhgoS5V3
         VB/biKVs6YXJt01ArQUATcMYFW928CfjdfSMuFrTe+BijoXhFxVX6efG7WKHDqwAull4
         acZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HW0zUbVcxaK4xAgCR1QsGsfDAEk5tnwMfSVg7Ost8nk=;
        b=nC3Ge7EkmbiQwLq8evgjGeUdk26hri6VT9s7hNua4UV1vU4yzsq5RZIHjM5ZEvl4yl
         3SETwpo7VCDtxQF2myqWLz7GKAUSJfGWdqMAvx1Vv6wxlZV3mVFVEYWpdvF2tHxcNO95
         qapzbzDM3sT/DnvyE7/fwzFsaA6Z6fcvt6cnzz+DueqsBouZ2aiNJD+8c4fcFrDxjdGP
         G3mYa6T15em8+tiEEEYzkGuUgeYojKrGkZn1Ef+zd+fKpDVLSWGYcnhVEKY3fuajDy6C
         lmHJ8HOZP79cnVMooaoGrVzvvW98/tWTvmnoGuo9Kgy6CCKUfNPUJAxDI1WuOIbA+aW6
         s1/g==
X-Gm-Message-State: AOAM532utLGfQdjDvPMw+mR+ZMearGV/040ez49rs/7utDkYeTIubXXT
        hraY3cr3cM5UTSPTiv6LGQRvT2Pq+LQVfw==
X-Google-Smtp-Source: ABdhPJwF4Xfh5uohHCZT4B7yHYHwyJNTsjI1If2wy4s00uf1uF4y76FpjP19ncaAj0V74zvp/S5yIA==
X-Received: by 2002:a63:4855:: with SMTP id x21mr7603885pgk.382.1604798698780;
        Sat, 07 Nov 2020 17:24:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11sm5872820pgl.20.2020.11.07.17.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 17:24:57 -0800 (PST)
Message-ID: <5fa748e9.1c69fb81.dd1fa.b75b@mx.google.com>
Date:   Sat, 07 Nov 2020 17:24:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.241-70-g8925fc6112bf
Subject: stable-rc/linux-4.4.y baseline: 80 runs,
 2 regressions (v4.4.241-70-g8925fc6112bf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 80 runs, 2 regressions (v4.4.241-70-g8925fc=
6112bf)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.241-70-g8925fc6112bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.241-70-g8925fc6112bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8925fc6112bfa4216475b81531407c50f5bcf310 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa71767d43136f3c7db8853

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-70-g8925fc6112bf/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-70-g8925fc6112bf/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa71767d43136f3=
c7db8856
        failing since 8 days (last pass: v4.4.240-19-ge3d3be91473e, first f=
ail: v4.4.241)
        1 lines

    2020-11-07 21:51:52.972000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-07 21:51:52.972000+00:00  (user:) is already connected
    2020-11-07 21:51:52.972000+00:00  (user:) is already connected
    2020-11-07 21:51:52.972000+00:00  (user:) is already connected
    2020-11-07 21:51:52.972000+00:00  (user:) is already connected
    2020-11-07 21:51:52.972000+00:00  (user:) is already connected
    2020-11-07 21:51:52.972000+00:00  (user:) is already connected
    2020-11-07 21:51:52.973000+00:00  (user:) is already connected
    2020-11-07 21:51:52.973000+00:00  (user:khilman) is already connected
    2020-11-07 21:51:52.973000+00:00  (user:) is already connected =

    ... (459 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa71767d43136f=
3c7db8858
        failing since 8 days (last pass: v4.4.240-19-ge3d3be91473e, first f=
ail: v4.4.241)
        28 lines

    2020-11-07 21:53:39.242000+00:00  kern  :emerg : Stack: (0xcba13d10 to =
0xcba14000)
    2020-11-07 21:53:39.250000+00:00  kern  :emerg : 3d00:                 =
                    bf02b8fc bf010b84 cba44610 bf02b988
    2020-11-07 21:53:39.258000+00:00  kern  :emerg : 3d20: cba44610 bf2000a=
8 00000002 cb8b9010 cba44610 bf24bb54 cbc7adb0 cbc7adb0
    2020-11-07 21:53:39.267000+00:00  kern  :emerg : 3d40: 00000000 0000000=
0 ce226930 c01fb3a0 ce226930 ce226930 c0859694 00000001
    2020-11-07 21:53:39.275000+00:00  kern  :emerg : 3d60: ce226930 cbc7adb=
0 cbb946f0 00000000 ce226930 c0859694 00000001 c09632c0
    2020-11-07 21:53:39.283000+00:00  kern  :emerg : 3d80: ffffffed bf24fff=
4 fffffdfb 00000027 00000001 c00ce2f4 bf250188 c0407034
    2020-11-07 21:53:39.291000+00:00  kern  :emerg : 3da0: c09632c0 c120ea3=
0 bf24fff4 00000000 00000027 c0405508 c09632c0 c09632f4
    2020-11-07 21:53:39.300000+00:00  kern  :emerg : 3dc0: bf24fff4 0000000=
0 00000000 c04056b0 00000000 bf24fff4 c0405624 c04039d4
    2020-11-07 21:53:39.308000+00:00  kern  :emerg : 3de0: ce0c38a4 ce22091=
0 bf24fff4 cbc91740 c09ddba8 c0404b20 bf24eb6c c0960460
    2020-11-07 21:53:39.316000+00:00  kern  :emerg : 3e00: cbc66980 bf24fff=
4 c0960460 cbc66980 bf253000 c04060e8 c0960460 c0960460 =

    ... (16 line(s) more)  =

 =20
