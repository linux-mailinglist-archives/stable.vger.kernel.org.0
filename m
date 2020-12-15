Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255B12DA7DF
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 06:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgLOFxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 00:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgLOFxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 00:53:41 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17A8C061793
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 21:52:55 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 11so13808446pfu.4
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 21:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TlmFL6ugoEdF0+b2DeAYkmgTmmpUm+npBibWfgydROA=;
        b=O2h93mXcjXc7IWPDsDGoD8eiTNMkOsNzA23gFeIsN4lAM8AxAa/hb6149tfZFOVVTv
         LmjdRKWAG5W4V3c/0uufgHRVuDeMcmNYL9N2IqC7lN1uTmwcWKHV74KZ+GUueLjyLlGi
         C39V/5gaSl4hjPThGAWR9UqmrMq5KnkELlI+WzOnYGkNwDsI+eYdbxFwf19oIge+lkqs
         179kv55sQV3yaltbkYgJIZgWg1CvZ2COUzSVdhnxc0yefrWIJmUvC8RqyrXPifuY3ETK
         arwVoUSO8T+oN5wTOqs4AVrdx2qQH1EByxs0NTj+Fd9XMYRFIhpGtQXKwACTAdJS3AcY
         pD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TlmFL6ugoEdF0+b2DeAYkmgTmmpUm+npBibWfgydROA=;
        b=uJpTc5BLAJUf28THRBeGtKWQ7PLqDgdY/67KP8w2zv+/3QbKIa6lHJFeTtl5OsJpE+
         Gx3od/NrI9dGmRJSSKGLK3C04IhsDdPRjoX4VJJwaJ4Dl3bm7/MVche6im0plOhqNCum
         /XW6NCf6eogKcZNLG3YUFpV3wbm98me2A2zUdWFnRer016jKMOJq0ANySxyGb6acWNrj
         1O3WQZ9Z7Bic890GgvmlbdEuacNjNaQq32r0j2s8PYtifaulFB7MjMc4kUhDxHfun7K4
         go/p7aZaAnPV3+rXThAUQm8ISKyV4CYiIqYYJqXy0IEtDKSjgO8zAkDAf9ukN6Qqor9k
         o/1Q==
X-Gm-Message-State: AOAM533itJilpb12QcS+AHOyat8QoNlEN73dHxF4ycO02m8shaPkE2Ah
        ZTSJjqqWkzeaNWoIOivxiHz7XuFDDRMGow==
X-Google-Smtp-Source: ABdhPJw78a4wKjy7xN6gqJdZIXS9U844hBz+vxyi4BL3CJHk0wJTHPbS47aetaN1/df2aUQOoqPsXg==
X-Received: by 2002:a63:f64c:: with SMTP id u12mr27455428pgj.325.1608011575041;
        Mon, 14 Dec 2020 21:52:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u189sm7781650pfb.51.2020.12.14.21.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 21:52:54 -0800 (PST)
Message-ID: <5fd84f36.1c69fb81.c8424.38e2@mx.google.com>
Date:   Mon, 14 Dec 2020 21:52:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.212-17-gb86870677ee8
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 88 runs,
 3 regressions (v4.14.212-17-gb86870677ee8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 88 runs, 3 regressions (v4.14.212-17-gb868=
70677ee8)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.212-17-gb86870677ee8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.212-17-gb86870677ee8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b86870677ee81f42f24adc90f4e2a5f32f10a818 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd81c6b1a646a38d8c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-17-gb86870677ee8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-17-gb86870677ee8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd81c6b1a646a38d8c94=
ccd
        failing since 258 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd81a70c66921d4fdc94cf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-17-gb86870677ee8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-17-gb86870677ee8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd81a70c66921d4fdc94=
cf1
        failing since 30 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd81a69c66921d4fdc94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-17-gb86870677ee8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-17-gb86870677ee8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd81a69c66921d4fdc94=
cdb
        failing since 30 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =20
