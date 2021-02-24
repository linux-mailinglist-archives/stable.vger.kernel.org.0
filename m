Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C007324355
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 18:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhBXRtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 12:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhBXRtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 12:49:53 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E476DC061574
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 09:49:12 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id r5so1778094pfh.13
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 09:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7jEsxQAo5hpjar++CPWnMAIVD1HXpCGU/gPVDqtQkb0=;
        b=fdG9UlAbjEXxNgXED8x5BJBS5jRk1P40te2xYHo0dfdXwn1lZdMRnJtpiVEWiY9Ahw
         J+iPUn6hRRQueEGihJaY1NmSsU5yXHpfOwadUTUiOHi1LJ3AHiydltQ+jYTvzKgu8UC1
         hFSwhVG6bGWlQYO2ECWWkS4RP0XrWRIRJaXYZFS8Exv/gLlmU/zhaVaMNO7Pnp0fg1u9
         dHQz8u5oyGAgruNG8ahL2yoty9lCZ6Lsi6tLzvTHcngwFx524764xRnawqYpCywcCLwC
         9QGNeUIV4WDKn8H6heedYpinFTyEqbtfdYEqwHabo0mTNJUQ2YG+HmibbbRd9MHJwX7i
         jPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7jEsxQAo5hpjar++CPWnMAIVD1HXpCGU/gPVDqtQkb0=;
        b=mVGuM8X9PpG8WFXPidOs6K7J4kcXfWhpc+3FeCkzwVxjpbqxRsssiRXDkQDHM9ZGRy
         oFgNYOg7V9/mPj7myBFVdLtjHLhtz8nKWFbLoYbvVdULFTgX8vZWcMg1ZLSlMattTtXm
         8MkzUZ0xa3d7fXLm7e5TR/d1o/M2nsH/cZHS52bEHTNcmZDaZU61hFSInPTkkLU3v4wp
         Tk3qtG7wmhXxEJzePzvWl7QDVRZe8tRbQXMUa9yHsUDjaB1c80nL1AdWBK0n8zv6qr+L
         TRiKik0BR/hdjXdJ50+tIm9jcNBqELA6L6qUBqV4SgJe8K2KchHp7e0abLjmukxVgekB
         4RZg==
X-Gm-Message-State: AOAM530520Udru1T7T/J7freum3iAtaGgDo0o9+fe72XNuvtIddBXHqM
        XMYp6V/+iGadXS+3TE9mMgqtnXBwLYLVBA==
X-Google-Smtp-Source: ABdhPJyeV2ATTnGKxvsprZ0c0PH9YDWzFat3hlIvJmq96gcJnQvS4WFC7JM6e2XiCU2KEIlFExScgg==
X-Received: by 2002:a63:1157:: with SMTP id 23mr30334390pgr.418.1614188952216;
        Wed, 24 Feb 2021 09:49:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm2894060pgz.22.2021.02.24.09.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 09:49:11 -0800 (PST)
Message-ID: <60369197.1c69fb81.47ccb.5bed@mx.google.com>
Date:   Wed, 24 Feb 2021 09:49:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-6-gc2abc0d9dcbc4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 94 runs,
 2 regressions (v4.19.177-6-gc2abc0d9dcbc4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 94 runs, 2 regressions (v4.19.177-6-gc2abc0d=
9dcbc4)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-8    | davinci_all_defconfig | 2    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.177-6-gc2abc0d9dcbc4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.177-6-gc2abc0d9dcbc4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2abc0d9dcbc4934a6d27d1c6f2a0550a2cccd7c =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-8    | davinci_all_defconfig | 2    =
      =


  Details:     https://kernelci.org/test/plan/id/60365cac0fc00930d7addcde

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-6-gc2abc0d9dcbc4/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da8=
50-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-6-gc2abc0d9dcbc4/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da8=
50-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60365cac0fc0093=
0d7addce2
        new failure (last pass: v4.19.177-3-gf35f4fc2fb4e)
        3 lines

    2021-02-24 14:02:59.215000+00:00  kern  :alert : raw: 00000000 00000100=
 00000200 00000000 00000004 0000000a ffffff7f 00000000
    2021-02-24 14:02:59.215000+00:00  kern  :alert : page dumped because: n=
onzero mapcount
    2021-02-24 14:02:59.275000+00:00  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60365cac0fc0093=
0d7addce3
        new failure (last pass: v4.19.177-3-gf35f4fc2fb4e)
        2 lines

    2021-02-24 14:02:59.418000+00:00  kern  :emerg : flags: 0x0()
    2021-02-24 14:02:59.504000+00:00  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-02-24 14:02:59.504000+00:00  + set +x
    2021-02-24 14:02:59.504000+00:00  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 756530=
_1.5.2.4.1>
    2021-02-24 14:02:59.609000+00:00  #   =

 =20
