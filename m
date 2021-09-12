Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A65407D4A
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 14:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbhILMjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 08:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhILMjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 08:39:31 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3ECC061574
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 05:38:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gp20-20020a17090adf1400b00196b761920aso4561921pjb.3
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 05:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0Qr59aigBq2/6Hr5W2jFB06bqDNfH6toNW9DWe4WE2o=;
        b=MFMrmoBM7Zyoj7uMVNArbHd7Szh9m4msugJxintuFMD24YwWNlXnkbquOwnMhHgfek
         rEx8MjIYri68Uy8pf04KVXEveDJQ014umfKCvmAqcKFHQJuHgJcUPD6SWuv0iQwqR05k
         lvXbYeLm65uY5bYmNCHgB3JBJmi9PjkhKmxg10jlNet09ft8dCVmkMd9DhZJaWLYEvTF
         /NQJ4QzCa9rdbxZ+SfizUTHWdwlSBno7cd+een6bYrjuv8fJ0xP01EsEhm4eN1jRLOMs
         EwuNBuOWGjQW4psDyrnQFY7z3jwBOmJRRJAHbPPCHct5ctUkr1K4aE+r9RRhKVbbcQ8l
         FKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0Qr59aigBq2/6Hr5W2jFB06bqDNfH6toNW9DWe4WE2o=;
        b=iRGnMq0ui7uJQpbLIe2ZLBb7sAVuiqwHopu34cx8k5dXl+JgW+86fXJUNVAwFaXD5o
         wyLUDoH0slddRWhI2AjAgwFeKHof1zJG/hS197vnGM2Bx0VjS6TzZzMsoGtpNGk0Uc9m
         e0djYTzVqwcREDaFBQuDbGSvn18L6QIh3X1xmMObGAsovNfYWa8AW/3P9Wmgw6MLhmk3
         t5GxtL2CETEBuaqQtlDZcSNh8COZXCzPFtcvqY6/ptsehpY+cvtPGZ5pXsor/v3zwaIF
         jMB/COLDcu6EH7HMzWZB92GC1hN4i/8baPmO3nB2/IdPLt1gVY69t5TxYdlvfJjjcEe4
         uucg==
X-Gm-Message-State: AOAM5309ARAd3pJyIdo5CSCxwH2WB6H6nuFNVqWqTix8tOFCHputf6jc
        DIGWYnjxPs/9crHeh07YVim3Q4jYJfcaUrVa
X-Google-Smtp-Source: ABdhPJzyhyAxjAVSD8JRSRAja508yy6lORBRS6ddnVU4ppBjzl91dqpqb/dZECwSFP3cKlMRhbs6zg==
X-Received: by 2002:a17:902:710e:b0:139:3bd:59b9 with SMTP id a14-20020a170902710e00b0013903bd59b9mr6013922pll.3.1631450296944;
        Sun, 12 Sep 2021 05:38:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r8sm4718135pgp.30.2021.09.12.05.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 05:38:16 -0700 (PDT)
Message-ID: <613df4b8.1c69fb81.8e708.c4a9@mx.google.com>
Date:   Sun, 12 Sep 2021 05:38:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.3
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.14.y
Subject: stable/linux-5.14.y baseline: 203 runs, 3 regressions (v5.14.3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.14.y baseline: 203 runs, 3 regressions (v5.14.3)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.14.y/kernel=
/v5.14.3/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.14.y
  Describe: v5.14.3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d27a14321366788cef927dbe69854f34460b3f7c =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/613dc403dbcf491ad9d5966e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.3/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.3/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613dc403dbcf491ad9d59=
66f
        new failure (last pass: v5.14.2) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/613dc2b02085b9e2bed5968a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.3/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.3/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613dc2b02085b9e2bed59=
68b
        new failure (last pass: v5.14.2) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613dc4ed1348ad2332d59667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.3/ar=
m64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.3/ar=
m64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613dc4ed1348ad2332d59=
668
        new failure (last pass: v5.14.2) =

 =20
