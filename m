Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BA54609FB
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 22:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238829AbhK1VIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 16:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbhK1VGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 16:06:53 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F06C061748
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 13:03:37 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id r130so14594978pfc.1
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 13:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3NvB6IYgFX7f/gxTt4t4f5RRCxj8lrC61nAfwA6UYUo=;
        b=4XTnv8ixx/yTlEyYzKkk5p0BhWUzyG3DAT/dGA2V6e5UxWpLzzIRctzQD9hEaOXC8o
         GPXe6wIDxAd+KWN9ifX5D2RIq7ABpfgXWuXRsoWgzRRtmiWIB07JDtxDzFW9GAGkGIko
         /YHq0emnYAb3jqvaez9jqQSxgIgc8DXalXvKRvpFyIHhZcxmnv41gqSfR60B51Q7IzKq
         Zg037YEidqq9IazIntqYPPVarmohmiDw7ouBC9hgaMnLyKUOZ5e29gGvyI5lPy1SCQ2P
         3jxM6Dh21O/vNPsJDnshq2Jxznn1/i7AyQVnfOq48wtuP04k6nbXR5LZZ01b1VwT36HA
         H1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3NvB6IYgFX7f/gxTt4t4f5RRCxj8lrC61nAfwA6UYUo=;
        b=eX8zPV0rKd8ydbBU6z7V23BKA7YWFzjh6HzKzQWEGETqyHSlt6BpKJjNPRHWTcLW1O
         96J6ZuIcXKGojMSUnLvUZmQcJB/XtDdzSYylph4C9vGj0IZ4xBSmwHW1uoiDC7Z3tI6L
         3qgtEJhP9Jp94LnVgdpSPfxeKcPb/e5REhO6l8AvoVpT4vL97p7WGWxsJKEBdsgArDSJ
         Cg3G9cfCBYSwIiswzBj2i3D4kaDFDTa35rVbbTVLijQ1FKBCvtxlUzT/vQQnPqZ1t9n/
         /e9CciWXm1sELuCJ3QJ29Xv7aAwDo96NrQoYSbF55KUMOyQovm+vOJF8YNDFtfnBj01D
         Z1xg==
X-Gm-Message-State: AOAM5336NgGdP1725DB1kLxvQ/YJmSWvKI1iSVQ5lB3olW4GrFeAwTWr
        g905wtbl/4RNHTzGTlja/WaSLfbNiAWNdge/
X-Google-Smtp-Source: ABdhPJyueKlgRWFnQtrUng0VfV7dzSjKBKwXb0patlHwryRjFbVg/j4S6b6KKZaM0dEkyi05ghcUww==
X-Received: by 2002:a05:6a00:b49:b0:49f:cc01:10ff with SMTP id p9-20020a056a000b4900b0049fcc0110ffmr34672490pfo.42.1638133416208;
        Sun, 28 Nov 2021 13:03:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y130sm13502708pfg.202.2021.11.28.13.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 13:03:35 -0800 (PST)
Message-ID: <61a3eea7.1c69fb81.b50e7.5bbe@mx.google.com>
Date:   Sun, 28 Nov 2021 13:03:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.218-36-g9a251c0c230bf
Subject: stable-rc/queue/4.19 baseline: 151 runs,
 2 regressions (v4.19.218-36-g9a251c0c230bf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 151 runs, 2 regressions (v4.19.218-36-g9a251=
c0c230bf)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.218-36-g9a251c0c230bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.218-36-g9a251c0c230bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a251c0c230bf72d3db2dbdc2227c267a50b2c8a =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61a3b95c306882b89718f6cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-36-g9a251c0c230bf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-36-g9a251c0c230bf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a3b95c306882b89718f=
6cd
        new failure (last pass: v4.19.218-14-gd6073091dc6a1) =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61a3b8937d9ea56a6d18f6ca

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-36-g9a251c0c230bf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-36-g9a251c0c230bf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a3b8937d9ea56=
a6d18f6d0
        failing since 3 days (last pass: v4.19.217-320-gdc7db2be81d5, first=
 fail: v4.19.217-320-ge8717633e0ba)
        2 lines

    2021-11-28T17:12:35.419314  <8>[   21.182250] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-28T17:12:35.467360  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2021-11-28T17:12:35.476493  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
