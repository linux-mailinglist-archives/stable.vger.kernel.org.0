Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C84A460AC8
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 23:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347549AbhK1Wj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 17:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350971AbhK1Wh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 17:37:56 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927F7C061746
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:34:39 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id o14so10545050plg.5
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fV8eRZQmmDdZrYdgsRh4Sof+CNmxiu6dskPEnJhZm58=;
        b=pW1YGxyTrC6C5+B/4wrTN2PEuCRCjJXAQ2Jo17IcBbmDv3/pj2MuSk1z3nafdi2jaX
         uP1J2JkaTqWPYj9zjzDBsnRZBIPJ0hxMUxozYSe2NzkNOZDnGCU0U9NDZmu0GR3LHIis
         P0gFFe/hkRJMTmxS447e/ZieEEnzcrsRCDh9Jb3WrUHZ1c+ixzm3x99Lpq4AVKVze92R
         TPqKSirz4f9Xh7Ww3/Kuyjpdw4nDlbTtPuOlBys6dDHvGdmL6GjPuejfRqskC2NR4m4a
         xBFFN9q0Xvf3twuJWH+WIVJs6nGoMNxv5GSFL3tsnYBYQTmAYv7Ji12Tyc9DBkJmjmUe
         qLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fV8eRZQmmDdZrYdgsRh4Sof+CNmxiu6dskPEnJhZm58=;
        b=13JSfx/DZT14v15kxQKIyCV3KGbB+XQHumqzyDFgHnc2Ut1KhGQe6+y/jxQ3mAXeUx
         rA/rdb0T0JN/OEGbpvMkC6Bd/McIyg0j9kdIN/wn1LdNCxV/EdxNdb7VGDFvUG6o1U+L
         fK0gyHnhOlPsjEaG2QbpeviEsNlcVSvUX1A243QVV9NvxVvv7y+cTzJa2AgOkzDtXvZ8
         o1EFDjD9mvZKFwSyD1jC7Sl4n6beZy6FijEyUmaz8J1DqdvWaIY/XOo05AjwZxHGx+Nm
         3oV26HGfWWXhP6jZsM9/X3+O4ic+cZin1cnJfUjcRJtHD1Q8074U0m6ah78XA4Kwk5N1
         kCwg==
X-Gm-Message-State: AOAM531gmN30q/BoyMxUEKSrkuKjqnVgWuGsqMcA6PP1AldfIKolce56
        Vfvo53r9bIwh3ZUX8NaGPyX8MolR2oamVm4G
X-Google-Smtp-Source: ABdhPJwiNmklKQTuGOt33FAvTQL3yJChwD0CK+WBEpzyQikz00sjyY4TliCd0Wz0X8H/oBGrs2CPGA==
X-Received: by 2002:a17:90a:c297:: with SMTP id f23mr33871249pjt.138.1638138878966;
        Sun, 28 Nov 2021 14:34:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm14364237pfv.48.2021.11.28.14.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 14:34:38 -0800 (PST)
Message-ID: <61a403fe.1c69fb81.b0817.7672@mx.google.com>
Date:   Sun, 28 Nov 2021 14:34:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-13-g259c8c7b3d8e3
Subject: stable-rc/queue/4.14 baseline: 98 runs,
 2 regressions (v4.14.256-13-g259c8c7b3d8e3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 98 runs, 2 regressions (v4.14.256-13-g259c8c=
7b3d8e3)

Regressions Summary
-------------------

platform    | arch   | lab     | compiler | defconfig                    | =
regressions
------------+--------+---------+----------+------------------------------+-=
-----------
qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defconfig             | =
1          =

qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defcon...6-chromebook | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-13-g259c8c7b3d8e3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-13-g259c8c7b3d8e3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      259c8c7b3d8e33bbf194df63298d169e02e24c61 =



Test Regressions
---------------- =



platform    | arch   | lab     | compiler | defconfig                    | =
regressions
------------+--------+---------+----------+------------------------------+-=
-----------
qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defconfig             | =
1          =


  Details:     https://kernelci.org/test/plan/id/61a3ccf15f9620bc8a18f6df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-13-g259c8c7b3d8e3/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-13-g259c8c7b3d8e3/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a3ccf15f9620bc8a18f=
6e0
        new failure (last pass: v4.14.256-13-g1cfed6be06acb) =

 =



platform    | arch   | lab     | compiler | defconfig                    | =
regressions
------------+--------+---------+----------+------------------------------+-=
-----------
qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/61a3ce09a76e28817218f6e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-13-g259c8c7b3d8e3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/ba=
seline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-13-g259c8c7b3d8e3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/ba=
seline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a3ce09a76e28817218f=
6e1
        new failure (last pass: v4.14.256-13-g1cfed6be06acb) =

 =20
