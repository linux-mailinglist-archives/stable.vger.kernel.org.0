Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB8629E43F
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 08:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgJ2HfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 03:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728203AbgJ2HY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 03:24:58 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBCDC0610D4
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 22:37:32 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h6so1432091pgk.4
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 22:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jsj/LMp+pGp9FwyZ7PzKn9XLHanETaWPfeLxxDBmUmQ=;
        b=MY1LffTaXscnUu0BUxrpkRuXQT6lLMD2oepoA3Qkh0dVhYvwtQae41bX+bnOD3Ekds
         DXOS+/3VLL2a+Dip1RMJu2BGK9ftgrUIBaR/G3eCqqQ9A9g/vooJJR0dtGJMkMBjvkqT
         Oy6foIalEnZ+QpCHX//0rpuzvnPekcncmTTBZWYxkQ1GfDQsGYMLaDJNn/rRHXNYicU9
         7zcbygxyhls4ow1A/EuqRO6rXZFNVjdmPCtJ/BT/IE/92W3FqFpTuj0K1KnRmDnARXid
         jcewAPnq8SoFLPjCrvEDIVJON9DoSUzQb7bOuxgbir4jEVbR56xGQB1VlZ/Zeu49gCNx
         Br0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jsj/LMp+pGp9FwyZ7PzKn9XLHanETaWPfeLxxDBmUmQ=;
        b=WiHIiLt3D097C8/KQKU1GpBQvi3SREm4pkbawbZFVY7PcD6AzHQI5JpMBHNBkRZBH6
         lMuZxLOFfKc/SQ7nI8VQbKK86i+KtsZNiZWlRdYq9KJPj9EeKRp0PQfOwNOh3gTuyzJM
         ulMPOp1bmlZeSPkhgWbCbRS2cSUHFsiPAD4naV/++RVF6uyrG7/VFLzMlu+/NvOGOx0Z
         q/hRCuytor4GywwjJE4n9hCLE37yf1uTEitNs0bXVZOelWIba7RYL8Jcl+ahYIz2rxif
         YN8JsjZiUx86MDe3VGfB743/Bv9gqNbbDI7lTzkGQ7CuwnsxZkmp+/E7OmRgesBLHAtM
         uaOA==
X-Gm-Message-State: AOAM5302ujQNBiRmslXwE1jzK1SCNnZhRwncdPpE2W/qwsp0VeZx4xp/
        jZF7mq82HDkoN3355/K5Le3PXB79lVeR5w==
X-Google-Smtp-Source: ABdhPJxKUE66AoL3lOIaGYDHwhWdCjsHMAvjpOQ52Iz8Z1AfFajGbVJ2u3o7YA+dpobKMw/v+Eol6A==
X-Received: by 2002:a17:90b:23c2:: with SMTP id md2mr2364072pjb.205.1603949851314;
        Wed, 28 Oct 2020 22:37:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 3sm1417640pfv.92.2020.10.28.22.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 22:37:30 -0700 (PDT)
Message-ID: <5f9a551a.1c69fb81.b49e.4a53@mx.google.com>
Date:   Wed, 28 Oct 2020 22:37:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.240-139-g65bd9a74252c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 145 runs,
 3 regressions (v4.9.240-139-g65bd9a74252c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 145 runs, 3 regressions (v4.9.240-139-g65bd9a=
74252c)

Regressions Summary
-------------------

platform              | arch   | lab          | compiler | defconfig       =
 | regressions
----------------------+--------+--------------+----------+-----------------=
-+------------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
 | 1          =

qemu_i386             | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
 | 1          =

qemu_x86_64-uefi      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.240-139-g65bd9a74252c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.240-139-g65bd9a74252c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65bd9a74252cf5d28f317c6f8482dd948d0abf01 =



Test Regressions
---------------- =



platform              | arch   | lab          | compiler | defconfig       =
 | regressions
----------------------+--------+--------------+----------+-----------------=
-+------------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a23779326b2db5938101c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
39-g65bd9a74252c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
39-g65bd9a74252c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a23779326b2db59381=
01d
        new failure (last pass: v4.9.240-139-gd719c4ad8056) =

 =



platform              | arch   | lab          | compiler | defconfig       =
 | regressions
----------------------+--------+--------------+----------+-----------------=
-+------------
qemu_i386             | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a21da8e30d27239381012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
39-g65bd9a74252c/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
39-g65bd9a74252c/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a21da8e30d27239381=
013
        new failure (last pass: v4.9.240-139-gd719c4ad8056) =

 =



platform              | arch   | lab          | compiler | defconfig       =
 | regressions
----------------------+--------+--------------+----------+-----------------=
-+------------
qemu_x86_64-uefi      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a22ef555a92bbd5381036

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
39-g65bd9a74252c/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
39-g65bd9a74252c/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a22ef555a92bbd5381=
037
        new failure (last pass: v4.9.240-139-gd719c4ad8056) =

 =20
