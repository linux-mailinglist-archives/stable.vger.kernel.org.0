Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540EC28A87E
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 19:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388290AbgJKRY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 13:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387501AbgJKRY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 13:24:28 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D3DC0613CE
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 10:24:26 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id b193so10854685pga.6
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 10:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nwf3xA48wC/veiFYT1eFHxqeqykaZ80Pid6ZZZL7LTc=;
        b=mvj7Y7m0Vt/B9qBf6czXgXQOb8Oa53+jdFB3Q7mj1MBcbNZsUeV3HHUwU2TpOu+7VW
         WFndo5Gja7CS9V4epic987ON0Y8Prf/ULiS1teASyGSvDdVLSFeraUP15uOUq5yhWFrp
         g2QDF5e5wge2980VoVCtaQfrDq+1kVp/N8ERIIqbdwF5Rg4nxHLRdQdZmm6/tdL6FGz4
         okART+D+owaiadBXsPJV6NMtbWcFuOxs6cyD98ki7Fi+PessN65b8W2XQ15ExCQqUb3z
         1GvlCEeN/xvl5KMgI12p36UiUF0jwWAJqLGttBT69sTK9EzG1eFjWn3s0OXIoXwAm/jw
         qxFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nwf3xA48wC/veiFYT1eFHxqeqykaZ80Pid6ZZZL7LTc=;
        b=WJwL0ABRqbk6mCmrRd6/A8hTQw11vBQfKJPoEccQp4Ec9UHmzo6DMY7ZTzltxTvI9R
         V53sQB1twpSSMjnhYwfzw3c6rmSIh5/mvzZUfuRdSm8j9clzg9ZR7tm+FhjfdRM7EA3W
         +NiBcWN/sPfDI4qSBJEaosnz0B688okpsiyfV9IqmmM6iAZAbQ5Yx3nRYvJkWvzjbu2O
         TANwJnA2uyD7wZ6/0RyAiX1iIta5g19RxRaStN7hJnRfGa3uFm6SKAvR7rL0ifPpAa5B
         vcR7K/vIbHCvWvH21v+ygDbNWlpx/lw0RLlFaSysJYKHzGE6l9o3+mROrm9iaG7N5jgy
         T7CA==
X-Gm-Message-State: AOAM531eHHFbvVXL0OzuZUYz7a2gPv/w9ZtzDQNiteZncwxdax5KfC5Q
        px8pYzm0sm8jvcq/UxLzMyiWbV22OTp+tA==
X-Google-Smtp-Source: ABdhPJxatZ+EG0dJ1o6jU0TBFr6dr9a5gKWumujMuvHCk5cG+jgsubI/tqNBqwq3to9OE/yRISt+Xw==
X-Received: by 2002:a17:90a:3f10:: with SMTP id l16mr15665101pjc.110.1602437065273;
        Sun, 11 Oct 2020 10:24:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q6sm17033175pfn.10.2020.10.11.10.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 10:24:24 -0700 (PDT)
Message-ID: <5f833fc8.1c69fb81.b07cc.0fb2@mx.google.com>
Date:   Sun, 11 Oct 2020 10:24:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-47-g18c925fbeeef
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 124 runs,
 4 regressions (v4.14.200-47-g18c925fbeeef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 124 runs, 4 regressions (v4.14.200-47-g18c=
925fbeeef)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 0/1    =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 3/5    =

qemu_i386-uefi        | i386  | lab-cip       | gcc-8    | i386_defconfig  =
    | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.200-47-g18c925fbeeef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.200-47-g18c925fbeeef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      18c925fbeeefdc904673c41ad862e5dcb22a2a09 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f83023f85e7bd75754ff3f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-47-g18c925fbeeef/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-47-g18c925fbeeef/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f83023f85e7bd75754ff=
3f3
      failing since 79 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f82e75ca4716e39ed4ff3e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-47-g18c925fbeeef/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-47-g18c925fbeeef/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f82e75ca4716e39ed4ff=
3e1
      failing since 193 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f82fddf9d8833a3054ff3f4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-47-g18c925fbeeef/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-47-g18c925fbeeef/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f82fddf9d8833a=
3054ff3fb
      new failure (last pass: v4.14.200-36-g2ae705c76879)
      2 lines  =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
qemu_i386-uefi        | i386  | lab-cip       | gcc-8    | i386_defconfig  =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f82fcea001b1977924ff3ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-47-g18c925fbeeef/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-47-g18c925fbeeef/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f82fcea001b1977924ff=
3ef
      new failure (last pass: v4.14.200-36-g2ae705c76879)  =20
