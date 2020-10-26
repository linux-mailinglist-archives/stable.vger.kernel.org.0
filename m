Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901C829896A
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 10:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1422387AbgJZJaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 05:30:39 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:46273 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422386AbgJZJai (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 05:30:38 -0400
Received: by mail-pl1-f172.google.com with SMTP id x10so2207243plm.13
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 02:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OJrcxgLIZhrP3DBgXRhSXDRrZWQZH8FrzISvVI08tq4=;
        b=S8Kas4e++xrMOW5zcH9l1ge8CguuqMNmM6Daz122swGug224j3XrX78UVDI46Nl/g+
         Y/rtGTh6/VprzTG2davZUiZQEsjLF8UTOAIp+ukJ2SHtN5Z01LDq3x3GgJeODqENr60E
         N37Cpu5CCJF6hYn5Rw6hPiGKIYI/hLChcH/+Bsewcb18T+ANwnycBRzeyx3uJB02HwSW
         g0V7w+/fkBk8U2H6upsy4UxaPjMVlB3R4g9/QIrP0KCaPlDciC/aKiRmOAqUf7RUP2sb
         73OE9A/3cx3j3YzUnqPSN/GkGnpVSx38Zc93XHk7GGjc9wH3pVD7U8/TPeOlE6EEzh/N
         izqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OJrcxgLIZhrP3DBgXRhSXDRrZWQZH8FrzISvVI08tq4=;
        b=V3YgGNs2eptGGGO+pjzsvoFTtFf4KZ5GXXVU0rLbqSBmC+MeHufHjfLQURlmbCXWVY
         m7NlsZMOgEUYKaQ0rr+D9gaHWtBnqnyFaGisgOG2t4UxGDDvu6vOeRde8snxhD5+PQUO
         QqrIRXaxmr/xMbXxgIWOb0bK5xKcJuodVVZTh5IRhUCkIf+/wq+Kq3OaXN/3JndNCpGv
         4deWvrwEfJs2u+ZjtR339oPdDKfFqn5qdKVcO5+qStVX0ol354SW6JqZ94zdYj7OjKHR
         M4kgIJInwoku6mCmVHD4+cldbnQ9QCZhGjs07cUPJ7nWyNBYWTnr6/+Ml77Cz130x3OV
         YqoQ==
X-Gm-Message-State: AOAM533XS8r5UKpQidFvZhRkixNf0Y68lne/4MC6ndVv3sWffoGpuErc
        JMFdttH7Lyv6YFTjzMrOsx1VgStmjTS7Lg==
X-Google-Smtp-Source: ABdhPJw39gFcEL/Hvi9dWpLUlPBXA06at4hOFyceRZonp6HRZVmrS7JflfyfJRTtElwB0xZEHhb5EA==
X-Received: by 2002:a17:90b:3849:: with SMTP id nl9mr14134077pjb.217.1603704637411;
        Mon, 26 Oct 2020 02:30:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i30sm10591292pgb.81.2020.10.26.02.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 02:30:36 -0700 (PDT)
Message-ID: <5f96973c.1c69fb81.a4a6a.4de3@mx.google.com>
Date:   Mon, 26 Oct 2020 02:30:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.202-187-g41515da3a101
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 158 runs,
 3 regressions (v4.14.202-187-g41515da3a101)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 158 runs, 3 regressions (v4.14.202-187-g4151=
5da3a101)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1      =
    =

panda     | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig  | 1      =
    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.202-187-g41515da3a101/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.202-187-g41515da3a101
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41515da3a1014f259d1c8f97de09a2b861ef0acb =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5f9665d01741e05a38381012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-187-g41515da3a101/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-187-g41515da3a101/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9665d01741e05a38381=
013
        new failure (last pass: v4.14.202-21-g136cf8fe1a50) =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig  | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5f96656b4aece92e04381012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-187-g41515da3a101/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-187-g41515da3a101/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96656b4aece92e04381=
013
        new failure (last pass: v4.14.202-21-g136cf8fe1a50) =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5f9664f72bd442bc693810ce

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-187-g41515da3a101/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-187-g41515da3a101/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9664f72bd442b=
c693810d5
        new failure (last pass: v4.14.202-21-g136cf8fe1a50)
        2 lines

    2020-10-26 05:56:04.324000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
