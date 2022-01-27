Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AD749E47A
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 15:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242295AbiA0OTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 09:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237675AbiA0OTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 09:19:54 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F03EC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 06:19:54 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id i17so2720183pfq.13
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 06:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sBJ2b0PiqncU41ZMIqg5tUMaMtUZY06uLho53gEbZRY=;
        b=IOIGGGsXo5rZIZgrtGtfAgOANPs5uyj+NSsiMRqflUEBeY5k07/vgikoyD2f7o1Z4l
         oG5XpP7rYzChnVitue/0vW8unR/RDYKrQ+vlybW2KpqFU5iDjvixxUztyFZKQ5uO6SO2
         oGKOtG0ugoOL3QHe22DBphacF30SLug/QG+K2+CbHrbvg6Vna+dL51VC6YfbcQzC005q
         ecG4nHhqV3LihPIFi1B8ewdrBmEcSiLqPJhRVtf8TcCKdWNQqWRP48JqHmnov2UIYEmR
         6xVA7nOGNxiKN9kU2qU9X8i5ra8r6mJmh3EuZ2P6bQiJIj676b2CBs1JvgySrcy50K96
         KwJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sBJ2b0PiqncU41ZMIqg5tUMaMtUZY06uLho53gEbZRY=;
        b=ZzzJEOcJN6/pyp3NZDe/t4+oVGKF/3uUC5AGXlfzIjl2f2mGCHfka9BdrnmLIoUNjh
         q2w9/Ri4i+rjJlyYgi0F7Qz0WVi+g4uzaTOtnW/qWs+YISzgb3vh8IeIYFB7xQ1dA7Qy
         5/S0X2OJ3dXMr29bc+dSvuNgbIFD2s1v8gGXGpm71MAQa0xtXgOvsGbPgcXNIVQdahp0
         PNrZINETmyW5R2EwTaqQZUjQroyePs+qgzQZgM39My+cdwxgcB9jJPMGvBTZdoUX8+5M
         y3HlKFwLwVv3X6zj3LoA/RHRBtdM9W0BogpcIIi5Sge4oD1RDg+OgsdT2YnLtQV61zJ/
         UElg==
X-Gm-Message-State: AOAM530uB/hVXqRtZnXd97Y7s0ar9layaW1BfMRl6Kh1foOkKRpOa0T0
        4ia6tT958NbzrVj9Sdmug0LXROxTwGn9/1k3mvY=
X-Google-Smtp-Source: ABdhPJwawYSHyeP7huBQ53Bbmuia1EprKszuNQz+YLHfb2kzWyBk4xOq5CC+0OkSjvgy9wyXijSYAA==
X-Received: by 2002:a62:5a44:: with SMTP id o65mr3411209pfb.73.1643293193638;
        Thu, 27 Jan 2022 06:19:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13sm6216898pfv.97.2022.01.27.06.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 06:19:53 -0800 (PST)
Message-ID: <61f2aa09.1c69fb81.2c9e8.0522@mx.google.com>
Date:   Thu, 27 Jan 2022 06:19:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.226
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 168 runs, 1 regressions (v4.19.226)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 168 runs, 1 regressions (v4.19.226)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.226/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.226
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c8855e990a676dc5054395b63239e347ee56c85a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f271f5139f429cbfabbd40

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.226/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.226/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f271f5139f429=
cbfabbd46
        failing since 15 days (last pass: v4.19.224, first fail: v4.19.225)
        2 lines

    2022-01-27T10:20:25.098566  <8>[   21.225524] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-27T10:20:25.145975  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2022-01-27T10:20:25.155724  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
