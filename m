Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8AD3C3FF9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 01:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhGKXay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 19:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGKXay (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 19:30:54 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B43C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 16:28:06 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id oj10-20020a17090b4d8ab0290172f77377ebso9487803pjb.0
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 16:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PdVeS+ds4m/04lr6Mtmxxg8eVM/a4cmv6P4zrZx5gSk=;
        b=O5mZmlwWAiZ5tnkG16M1Dp9Hn8gmOEDeCBRnp+u1qxTK2nFy8zbgCYg5UT0bQQNMo7
         Gnk3elaKJio3FapFgXA4F9KlBBghLqZmqsVX6M3toEjxhuJvl/tdIyeQV5FFi381RiW0
         MhXyFiKdjUAN2EqYPRM7fAXiIroYXuFKSgP2NxXBl0kRC6+LT4WmKsQNonEpdHPFNilM
         xxGmijd8oxkWm0JVktP0ksEJDccMFhfaSx2fOeRpytQgr/XmMUQqp3IGLKES3P8owYVu
         4u1Y1TazajN6smywYiQ9eSxgCQkzRPFvgqCxY2swt3XpRnWuaIQ7LzNfKCTAk5YJbSn7
         q8mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PdVeS+ds4m/04lr6Mtmxxg8eVM/a4cmv6P4zrZx5gSk=;
        b=nO2Suy9IhTo8XLVW690uL9u0tCtIxgZFiGpLneyshpFsoif9v4j1+PBQksjbKhUYj5
         dnvshfono6MFha5SrJy4QzvI0sP3Tm5HIjvzhjJtWwAhp3QflDbuGcxzX/aeSG4DmjyV
         DkoeEZasy5imA7GcyZOn7j5U0/2Ey5i2AiBQziT98zoPIOv1bh7Z3WirZANkAeENqqlm
         KiKL2QGQ4Gqk3BzHn8RqNb38kc1uKp7u6QsJC/Xm8SaAWJlWbPHrDMVkFORIGMsUrR/Y
         vav1m6r3l34Ze1rW7obymkawGgS/QJlLCYHb0UbHwPtXjfjk6baqg2fIPagJB4dxtwo8
         uf1A==
X-Gm-Message-State: AOAM532MBNLPWhcIhA8EGIeDGF7+5tuBgqzpWpoXjJ3ePk5EpFOySpMk
        EC1ODfg7hI38DWVWzozV224oKc3hpHO1N0Bo
X-Google-Smtp-Source: ABdhPJzrtzIBrG5i+3GFNEEHLhcvnadOaWut/iqmmCamlYbd3OwT1UmUBKImIiGaLzVMj9543WLhuQ==
X-Received: by 2002:a17:90a:d3ca:: with SMTP id d10mr4163300pjw.35.1626046086008;
        Sun, 11 Jul 2021 16:28:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v5sm14957766pgi.74.2021.07.11.16.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 16:28:05 -0700 (PDT)
Message-ID: <60eb7e85.1c69fb81.431c4.c6be@mx.google.com>
Date:   Sun, 11 Jul 2021 16:28:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.131-348-g3770ccf78001
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 182 runs,
 3 regressions (v5.4.131-348-g3770ccf78001)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 182 runs, 3 regressions (v5.4.131-348-g3770cc=
f78001)

Regressions Summary
-------------------

platform             | arch   | lab          | compiler | defconfig        =
            | regressions
---------------------+--------+--------------+----------+------------------=
------------+------------
d2500cc              | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =

d2500cc              | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig =
            | 1          =

meson-gxl-s905d-p230 | arm64  | lab-baylibre | gcc-8    | defconfig        =
            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.131-348-g3770ccf78001/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.131-348-g3770ccf78001
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3770ccf78001987e483fd4046fc3400dd4a616e6 =



Test Regressions
---------------- =



platform             | arch   | lab          | compiler | defconfig        =
            | regressions
---------------------+--------+--------------+----------+------------------=
------------+------------
d2500cc              | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb49841297415a6011796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
48-g3770ccf78001/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
48-g3770ccf78001/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb49841297415a60117=
96b
        failing since 0 day (last pass: v5.4.130-4-g2151dbfa7bb2, first fai=
l: v5.4.131-344-g7da707277666) =

 =



platform             | arch   | lab          | compiler | defconfig        =
            | regressions
---------------------+--------+--------------+----------+------------------=
------------+------------
d2500cc              | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb4ad8ab47c4315c117983

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
48-g3770ccf78001/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
48-g3770ccf78001/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb4ad8ab47c4315c117=
984
        failing since 0 day (last pass: v5.4.130-4-g2151dbfa7bb2, first fai=
l: v5.4.131-344-g7da707277666) =

 =



platform             | arch   | lab          | compiler | defconfig        =
            | regressions
---------------------+--------+--------------+----------+------------------=
------------+------------
meson-gxl-s905d-p230 | arm64  | lab-baylibre | gcc-8    | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb5001b242b0bfa4117978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
48-g3770ccf78001/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905=
d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
48-g3770ccf78001/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905=
d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb5001b242b0bfa4117=
979
        new failure (last pass: v5.4.131-344-g7da707277666) =

 =20
