Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D65845F6C2
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 23:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243427AbhKZWPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 17:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244441AbhKZWNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 17:13:43 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842E5C061757
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 14:10:30 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so10664466pjc.4
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 14:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8WOhvX2stFdOY5MFF8ewe/ByxaQxnlHVvk+yYLa2rms=;
        b=pCB6TkI8LgMbzjgrWhedxHvlGNQ+qWjII/M+H4uvYOqhrme6/GTCOi6tSlXjtBnwJO
         y5ccl0KX5ImEPTCAS/GiOIF2vYhGbT9bJyUt2OxZeAEod9NKXh8B17suwkCImGqirNVu
         Cisd7v1C7LH10riUSkFX/xS+QkzgmiC2BIcTlhIX2qwZbmoy7PLS07g+z0K0060Yt3V0
         gUrPtuQ0ILlrJrgKqYnmHqgIzOmLLnc4zZxM+IU1AFwe4+pC80PH9rcFJQuFLs+m5jcj
         mGBduX8pPK8Q4n8+0nETZxYud+I/YQgVGK/pwQbj9RGST1hJEownr0jGm8CaWbEOAlRY
         0yRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8WOhvX2stFdOY5MFF8ewe/ByxaQxnlHVvk+yYLa2rms=;
        b=3rMo4Iu/wAf7V7+HXD2R0gRG1LZ4y2s64a7rolFOhb1CX5Iw5yYEHb+7nAell0OCtZ
         GfgjOLXXbPjNvKGNjd5JtLJyuCpemagDa3XTnyI0OCot/mMDl4x0jrW8fCwJHRDGHopi
         cYBxUjD3Iyvcfko2Cp9p9mtqhnz/MQkt3CpTl8VAIXLJ1n5aUezXqCgY+t8JFI2OUnMG
         ypVJDp8MmP2LksfOW78P7oOBiIzs9K3eMIQF6UCOhc18ux3fs2LUmFLx9nxcdwcPMmvE
         RxxrrjapkpZDI5R5BbmXzPdFxCFdFwmS2qVHOhuc0xt7tw6Jx2JN3ZvF918TUO1TsYS8
         nk+Q==
X-Gm-Message-State: AOAM531LE94bf5QhreHteZDtSMyqxWkhzDy0LgaXAwjplFpiz3dsL+3N
        1oIhadL/7On0uMz0WArZtzg4I9Apn8xUVKk9
X-Google-Smtp-Source: ABdhPJw/Z2kZFZk/7akKcxYdP8/RYdcEBES1Lx19K2D4BcqZTYkA7phOBUMSr0L74RUmMopLY0SbvA==
X-Received: by 2002:a17:903:230d:b0:141:e3ce:2738 with SMTP id d13-20020a170903230d00b00141e3ce2738mr39961135plh.57.1637964629904;
        Fri, 26 Nov 2021 14:10:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g18sm7741516pfb.103.2021.11.26.14.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 14:10:29 -0800 (PST)
Message-ID: <61a15b55.1c69fb81.a7409.5f34@mx.google.com>
Date:   Fri, 26 Nov 2021 14:10:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256
Subject: stable-rc/linux-4.14.y baseline: 134 runs, 1 regressions (v4.14.256)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 134 runs, 1 regressions (v4.14.256)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.256/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.256
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      66722c42ec916e92cadda46316f8f6e3fdcaedc6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a122e9463a36746918f6d1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a122e9463a367=
46918f6d7
        failing since 0 day (last pass: v4.14.255-251-gf86517f95e30b, first=
 fail: v4.14.255-249-g84f842ef3cc1)
        2 lines

    2021-11-26T18:09:26.777118  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, mmcqd/0/60
    2021-11-26T18:09:26.786539  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-26T18:09:26.801532  [   20.289154] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
