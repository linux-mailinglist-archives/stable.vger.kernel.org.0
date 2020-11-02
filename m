Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14132A2B29
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 14:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgKBNDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 08:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgKBNDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 08:03:44 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0951C0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 05:03:43 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id w65so11073146pfd.3
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 05:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fhfIbd7JSVBVpS694lG+BGm+F6JYKEnFz39cI+XrMTU=;
        b=HRRD3cuuaJNdA4fIHkaqXFXxnvBqPC0/VRrWei3INtHG1uZk6qUklIdMpWkLX+26UU
         aZnDmabznjGOBr7LSl54cyhjhpm9NE271pkSnxMWS/ID1D9RF76MYZrv6GUzT9n3cIuU
         NXIw77rbldaU5gydcPgt+995lY0dG9AuP7NBXNzH9slssvaarPsN78HVDpkG3ddioYRW
         2xkn6RX7J+Vc8LAI1cCWAuT+M9p424f6+fPP2daDnmU0VDnZ3eWCOs9fO1d9Kw9uOCSi
         hTBiWvPPNeiM5oJBv052eJXtTqMDu3GXh93k6pLwmN5/cWj4i0Echxds8Mz/Gvhq9K4G
         CYEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fhfIbd7JSVBVpS694lG+BGm+F6JYKEnFz39cI+XrMTU=;
        b=C9Zywjz09SKlnI+ZE9HLSgUiocZ47Tn5uWRVlEwB8dFtbc9qLMAOSqtSegzXglbzkg
         FDPfbByKpkN1T5kKNAyBqp+ObeMfoGBxRCY8jX1c+XdwHu4N4T2y4UOU5qcuPLKuVfcd
         7szb4oN5KWQcX+Bf8rL7HuIKxz40Hwmzk14qxmM3UN3T+HkZVj18GfWnWA1K4NC9UI3B
         E+3nzU841OnFmrcG/dWESQ0NVVfvoIgizDKZzOMniDMaz5G/zVeHmqx77hzKBDKUwPZM
         JBwjjJJlOjHdfdw3ix6aUY6/jjTEtFtYVjTOv9Q/UA3f5pakPrVvCu+V56ahWlX5IWw5
         0hvQ==
X-Gm-Message-State: AOAM533ud+zLSkgiB4llRlLb25+DsLQ6+ALEDx/ERu+jeELIpaWR/S/K
        WCFUmmQCEnqbc+XvNJTvoOVDcaoc/FdFqg==
X-Google-Smtp-Source: ABdhPJzkH4jtrthfxO7CUHWsYpvvmZQ6HqfIhD1gnucpmIBwBmmXODGlKo2GRUMcOZ9e9TNWo6HuOw==
X-Received: by 2002:a62:1c8f:0:b029:156:6ebd:3361 with SMTP id c137-20020a621c8f0000b02901566ebd3361mr22284217pfc.42.1604322222995;
        Mon, 02 Nov 2020 05:03:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w128sm7059993pfw.50.2020.11.02.05.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 05:03:42 -0800 (PST)
Message-ID: <5fa003ae.1c69fb81.a4a48.5476@mx.google.com>
Date:   Mon, 02 Nov 2020 05:03:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-34-gaf6f85ddc502
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 127 runs,
 2 regressions (v4.4.241-34-gaf6f85ddc502)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 127 runs, 2 regressions (v4.4.241-34-gaf6f85d=
dc502)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =

qemu_i386 | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-34-gaf6f85ddc502/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-34-gaf6f85ddc502
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af6f85ddc50241837b0fa934d9bd8d457169921e =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5f9fd201be6a84c45b3fe7df

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
4-gaf6f85ddc502/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
4-gaf6f85ddc502/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9fd201be6a84c=
45b3fe7e6
        failing since 0 day (last pass: v4.4.241-8-gd71fd6297abd, first fai=
l: v4.4.241-10-g5dfc3f093ca4)
        2 lines =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
qemu_i386 | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5f9fd024b04292efef3fe7d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
4-gaf6f85ddc502/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-3=
4-gaf6f85ddc502/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9fd024b04292efef3fe=
7d7
        new failure (last pass: v4.4.241-10-g5dfc3f093ca4) =

 =20
