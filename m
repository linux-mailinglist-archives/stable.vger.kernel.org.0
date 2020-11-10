Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A859E2AE34A
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 23:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbgKJWXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 17:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKJWXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 17:23:35 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE06C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 14:23:35 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c66so178543pfa.4
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 14:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kbjePKiI3a1YVca02UQPJfWaUbQ/GkLkwhVBcIqHmqw=;
        b=Nm128Qa4uBT0IWWVT6YgOeQkhdwBzWXvZYNlkCIJTnN9vGAvRAnLh3KseYRktOLwr8
         7xDlGZnROF/E4osPSEkQD6sPid0rFu1BGVvAORPZB484KQ7yAwOEuDuA77dQJM4Jnl6z
         qx9LCBuwY82wOEkCEO+YAvnAcZYsOrbYEt+WThOrdgev+mMFUMzd8PR8Tk86tCPeLDJ7
         qkZZAo7+rfj4SkBam/6hA7TLCCec89JvH5pXRPmxhu7ZF8GZatVyYq5IGkuFqLKdqRPC
         g5NkaYGjYOEKDk24uCKB5psxHSA/445oCRZ+5DbFQNWLMVjdxyomMZhOMEHbdEo2dLr5
         tLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kbjePKiI3a1YVca02UQPJfWaUbQ/GkLkwhVBcIqHmqw=;
        b=ty68nQDxaj2V3NItay15l5vpriFqvuQ+9KCX2Zkwd4MyNE+rDuO7mIMMkkTUCS65Qv
         6YtK3lnb3pjM1RpLq193yAMq8AUIPj0uRBlbUSgLM/dY8QTlSTSabm72cdtwRPxrmTPS
         ePzxp+ma9PkphA2tAthlgc/KPbbwaOI6FHJyyygi/crt3cjNLFif9GykC+YYBrPQFnoi
         BQQucviu6VTLo84I3bK9M/p6LSYYwH1biDWLZuC14TTOoz5goHhf1ZEfoeYdWKU/1XXT
         qwMgbtCoYZFEzEb/eRFb4xkzJ/51SbZ+74ZHUDOaVAX5zNK9FyEsaRcs1hdj191V1PVZ
         KV+g==
X-Gm-Message-State: AOAM532x4hdre0pbXDf3CKOQ/jdwg+UsQffaxG4sb5+KLjHgvU7bJcH3
        Hw+/fWAFLHnasoe8hJ5smaOCH0qc2osbWA==
X-Google-Smtp-Source: ABdhPJw7/K+nq4aKiKkFjSaZOHQ6EqT/JIY26w/3L5Y/p2auBslzWO3Y/tZJS5cP1XxjzrNFZOX12A==
X-Received: by 2002:a63:fc1c:: with SMTP id j28mr17954799pgi.95.1605047014580;
        Tue, 10 Nov 2020 14:23:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2sm3613pjl.15.2020.11.10.14.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 14:23:33 -0800 (PST)
Message-ID: <5fab12e5.1c69fb81.e0f52.0027@mx.google.com>
Date:   Tue, 10 Nov 2020 14:23:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.242
Subject: stable-rc/linux-4.4.y baseline: 121 runs, 3 regressions (v4.4.242)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 121 runs, 3 regressions (v4.4.242)

Regressions Summary
-------------------

platform       | arch | lab          | compiler | defconfig           | reg=
ressions
---------------+------+--------------+----------+---------------------+----=
--------
beagle-xm      | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2  =
        =

qemu_i386-uefi | i386 | lab-baylibre | gcc-8    | i386_defconfig      | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.242/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.242
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad5e80d0d772cea9c08eceaceda3b30131cdaaac =



Test Regressions
---------------- =



platform       | arch | lab          | compiler | defconfig           | reg=
ressions
---------------+------+--------------+----------+---------------------+----=
--------
beagle-xm      | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2  =
        =


  Details:     https://kernelci.org/test/plan/id/5faae19d5e7ddfd853db8869

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.242=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.242=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5faae19d5e7ddfd8=
53db886c
        new failure (last pass: v4.4.241-87-gcbe5dd8b3604)
        1 lines

    2020-11-10 18:51:26.755000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-10 18:51:26.755000+00:00  (user:khilman) is already connected
    2020-11-10 18:51:26.755000+00:00  (user:) is already connected
    2020-11-10 18:51:26.755000+00:00  (user:) is already connected
    2020-11-10 18:51:26.756000+00:00  (user:) is already connected
    2020-11-10 18:51:26.756000+00:00  (user:) is already connected
    2020-11-10 18:51:26.756000+00:00  (user:) is already connected
    2020-11-10 18:51:26.756000+00:00  (user:) is already connected
    2020-11-10 18:51:26.756000+00:00  (user:) is already connected
    2020-11-10 18:51:26.757000+00:00  (user:) is already connected =

    ... (457 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5faae19d5e7ddfd=
853db886e
        new failure (last pass: v4.4.241-87-gcbe5dd8b3604)
        28 lines

    2020-11-10 18:53:12.445000+00:00  kern  :emerg : Stack: (0xcb933d10 to =
0xcb934000)
    2020-11-10 18:53:12.453000+00:00  kern  :emerg : 3d00:                 =
                    bf0328fc bf017b84 cb98fa10 bf032988
    2020-11-10 18:53:12.461000+00:00  kern  :emerg : 3d20: cb98fa10 bf1fc0a=
8 00000002 ce33a010 cb98fa10 bf24bb54 cbc1d510 cbc1d510
    2020-11-10 18:53:12.469000+00:00  kern  :emerg : 3d40: 00000000 0000000=
0 ce226930 c01fb398 ce226930 ce226930 c0859688 00000001
    2020-11-10 18:53:12.477000+00:00  kern  :emerg : 3d60: ce226930 cbc1d51=
0 cbc1d5d0 00000000 ce226930 c0859688 00000001 c09632c0
    2020-11-10 18:53:12.486000+00:00  kern  :emerg : 3d80: ffffffed bf24fff=
4 fffffdfb 00000026 00000001 c00ce2ec bf250188 c0406f7c
    2020-11-10 18:53:12.494000+00:00  kern  :emerg : 3da0: c09632c0 c120ea3=
0 bf24fff4 00000000 00000026 c0405450 c09632c0 c09632f4
    2020-11-10 18:53:12.502000+00:00  kern  :emerg : 3dc0: bf24fff4 0000000=
0 00000000 c04055f8 00000000 bf24fff4 c040556c c040391c
    2020-11-10 18:53:12.510000+00:00  kern  :emerg : 3de0: ce0c38a4 ce22091=
0 bf24fff4 cbaed640 c09ddba8 c0404a68 bf24eb6c c0960460
    2020-11-10 18:53:12.518000+00:00  kern  :emerg : 3e00: cbccce80 bf24fff=
4 c0960460 cbccce80 bf253000 c0406030 c0960460 c0960460 =

    ... (16 line(s) more)  =

 =



platform       | arch | lab          | compiler | defconfig           | reg=
ressions
---------------+------+--------------+----------+---------------------+----=
--------
qemu_i386-uefi | i386 | lab-baylibre | gcc-8    | i386_defconfig      | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5faae219f2a1cfa5cadb8879

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.242=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.242=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faae219f2a1cfa5cadb8=
87a
        new failure (last pass: v4.4.241-87-gcbe5dd8b3604) =

 =20
