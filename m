Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6302A1795
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 14:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgJaNTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 09:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgJaNTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 09:19:23 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA04BC0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 06:19:23 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g19so498259pji.0
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 06:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X7xiKB5g4FmopQgFJ8t09SL+Po/+H+5fs9gAI+Scq1Y=;
        b=cSP1gwxfC6YJDNhvSEQ3ZKj13gT95iI+iNTr7VyygGbR1b5vIXsXUBhCNL8R9AO31v
         cJuXpHVullrumc2S/s+PrmUsc2q8iHUJEaBUy8+vFQ+SP5FHMo71ypPbDTDTyYCVKi4j
         Tqc8z8t5PTkFPGOsYTMbVyI78C1WvteQffLiJt0dR8c09qLOqJYWCyGVW0wwO/gMWf/P
         PM3YVzuw9wry/AyQimGdHA08Zi95KD1Fg6bz99fIf+bED5XRIVBkJyUqD0ulA7B4cWqp
         UNsglv7RMC70gMfEbHU4ZKAWK++CmLSH+jwXdcOYJsLKE3Y2B+LIFY32k1y+LG8hGyGk
         pfWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X7xiKB5g4FmopQgFJ8t09SL+Po/+H+5fs9gAI+Scq1Y=;
        b=Hx472WMhjicBZO0oatGugqM5T3kdB7Qz7sRODnLedNL1u3mTrfwsUqcwPmks9pWCYT
         8CP0MkwnX598xS+fXEWdDv+oF+Kr644pxUy/P3u1Dc4lcwMp1Sg9Sp73RadsHrku96W3
         yjBOOsoFOFuxMxrEGALdMgovzFphy5ukon5hmVCy/FJbGLBeSNkwKlL/5EHiDDYvtQgh
         +ozBBnb53knE8YSRRYLT8+UhL1h+Oio/8Is5B8VGGPnYYcM2aMEj46DK2fVs6J9MuI2o
         AZ0Y9W8vZP53JOGKfgEY8TcpqBqPuDtjDjjdoBHUhU0RBs2BoKkJNCyIUOx8cwqH+PL7
         g7Lg==
X-Gm-Message-State: AOAM531p3xL+9M2TrPuDlY4eD3ZRIPU8dtYoppV6c/zgkCeyix5nmVg7
        MuWh8cCbL2Ptnkdk9ffg98k6idLa0ZjU+Q==
X-Google-Smtp-Source: ABdhPJxIQYQmGl9yKXFT83sqU+OcAdBroReG7/dvx+z1F455wCFsneWXrJgFWlP2/nuVN5Mh/VDVhA==
X-Received: by 2002:a17:90a:6b0a:: with SMTP id v10mr8360081pjj.141.1604150362762;
        Sat, 31 Oct 2020 06:19:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y23sm6613250pju.35.2020.10.31.06.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 06:19:22 -0700 (PDT)
Message-ID: <5f9d645a.1c69fb81.762d1.ffd6@mx.google.com>
Date:   Sat, 31 Oct 2020 06:19:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-4-g0d795de442ab
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 129 runs,
 4 regressions (v4.4.241-4-g0d795de442ab)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 129 runs, 4 regressions (v4.4.241-4-g0d795de4=
42ab)

Regressions Summary
-------------------

platform       | arch   | lab           | compiler | defconfig           | =
regressions
---------------+--------+---------------+----------+---------------------+-=
-----------
panda          | arm    | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =

qemu_i386      | i386   | lab-baylibre  | gcc-8    | i386_defconfig      | =
1          =

qemu_i386-uefi | i386   | lab-baylibre  | gcc-8    | i386_defconfig      | =
1          =

qemu_x86_64    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-4-g0d795de442ab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-4-g0d795de442ab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0d795de442abc3fd0fb47ee467ca48ebef0a5d99 =



Test Regressions
---------------- =



platform       | arch   | lab           | compiler | defconfig           | =
regressions
---------------+--------+---------------+----------+---------------------+-=
-----------
panda          | arm    | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9d32d6d8b39a88563fe7da

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g0d795de442ab/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g0d795de442ab/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9d32d6d8b39a8=
8563fe7e1
        new failure (last pass: v4.4.241-4-ga5b62fb44d07)
        2 lines =

 =



platform       | arch   | lab           | compiler | defconfig           | =
regressions
---------------+--------+---------------+----------+---------------------+-=
-----------
qemu_i386      | i386   | lab-baylibre  | gcc-8    | i386_defconfig      | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9d3013422bfb4ac73fe806

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g0d795de442ab/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g0d795de442ab/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d3013422bfb4ac73fe=
807
        new failure (last pass: v4.4.241-4-ga5b62fb44d07) =

 =



platform       | arch   | lab           | compiler | defconfig           | =
regressions
---------------+--------+---------------+----------+---------------------+-=
-----------
qemu_i386-uefi | i386   | lab-baylibre  | gcc-8    | i386_defconfig      | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9d2ffce468955f723fe7ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g0d795de442ab/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g0d795de442ab/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d2ffce468955f723fe=
7ef
        new failure (last pass: v4.4.241-4-ga5b62fb44d07) =

 =



platform       | arch   | lab           | compiler | defconfig           | =
regressions
---------------+--------+---------------+----------+---------------------+-=
-----------
qemu_x86_64    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9d30c2ce6b69c81b3fe7d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g0d795de442ab/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-g0d795de442ab/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d30c2ce6b69c81b3fe=
7d6
        failing since 1 day (last pass: v4.4.240-112-g1a1bb4139b4c, first f=
ail: v4.4.241-2-g0b3b9f46127e) =

 =20
