Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD5C2A6BFB
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 18:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731876AbgKDRp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 12:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731862AbgKDRp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 12:45:26 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF16C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 09:45:25 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 72so11196561pfv.7
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 09:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z6xzMwU+yhqdUZeP9noe68nRAP7yklBfO6dSeOXMHAo=;
        b=nNBjxdAuurgJLI1BOvWwPbUVKpeVPAWOANavcB8iD0D4QEfgS4PkDQxobU4/rf9AOg
         gjlOGPMN2CPyJsVwRE1O+UoOlfaEFq4HtEycICxnyWI3fOChwLSUdZymC0I7/kEzXaUQ
         6/qDpIDafAJns+/d3dljyjPZPRzBfeyL9ki1fbszLoAdw7uCWlSEPsTRqvm1Otc1psGW
         qh1/iqxMXuz2S0DZD6OhXSipyCbwW+652FN6+LQajVMAHhmgRFT1yt+uI6Gpteou/nCV
         sgi9QouFlqBK/l7P99pC8pDTOiNJRU8AXsG0N9+ERYwa1ITm38hgZ8i8mU9i6BfT8fZt
         AgEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z6xzMwU+yhqdUZeP9noe68nRAP7yklBfO6dSeOXMHAo=;
        b=l3lcXHljoYbRsTRT2iyFp5jqU/bjwUbrwXzfZKXr2QenhaC3Jc3phROEVv54ik/8Ky
         fwQ++7p4PH1SFT+QWrhi+rJA3LLI/82NL7nDCmkjV0GWLHP6C/SihFEcfYiXW/67cVWl
         GW+6h5zD5yvybxNgCLb9VZkoB2FjT14GFDU+DavtVnj0w309ybhISw6WmGNmI9vfSqDL
         mQjxxfHU3dC8DQceA3FzC7ff4IL7jRJsux67eZjbhBUDflJGr916uUY1IVgPQGALC0hE
         xLDvvjnzE4CXspKNufeDgHruY/6ZpTlUtColwDzbewpcQi8BwFXgRltpbSL0Jgbt/AtZ
         YB/g==
X-Gm-Message-State: AOAM5307grhB0uhNi4ZSDx+ym6GqYWlCdBdgkljOOqhTSvseGSezz2ro
        q4yvnVaTFnU/esmeALmXScnqumIjrfcwcg==
X-Google-Smtp-Source: ABdhPJzeNmfW1eE4JwG9g4zHX/68cILdax3Wh1/fDSVMRGUrD96820nVfRLY46vCj2uAVsfZbcpwVQ==
X-Received: by 2002:a17:90a:9dcb:: with SMTP id x11mr5157070pjv.132.1604511925095;
        Wed, 04 Nov 2020 09:45:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i11sm3090601pfq.156.2020.11.04.09.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 09:45:24 -0800 (PST)
Message-ID: <5fa2e8b4.1c69fb81.63abc.7347@mx.google.com>
Date:   Wed, 04 Nov 2020 09:45:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.74-212-g91dd5e0e05da
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 215 runs,
 3 regressions (v5.4.74-212-g91dd5e0e05da)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 215 runs, 3 regressions (v5.4.74-212-g91dd5e0=
e05da)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.74-212-g91dd5e0e05da/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.74-212-g91dd5e0e05da
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91dd5e0e05daba53fb026dec9710749d0f1942ab =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa2b3b73027ea6651fb532a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g91dd5e0e05da/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g91dd5e0e05da/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2b3b73027ea6651fb5=
32b
        failing since 6 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa2b08456e910bdb8fb5338

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g91dd5e0e05da/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g91dd5e0e05da/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa2b08456e910bd=
b8fb533d
        failing since 0 day (last pass: v5.4.74-95-g49cb9af04b0c, first fai=
l: v5.4.74-213-g67dd1e38607a)
        1 lines

    2020-11-04 13:43:26.573000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-04 13:43:26.574000+00:00  (user:khilman) is already connected
    2020-11-04 13:43:42.053000+00:00  =00
    2020-11-04 13:43:42.053000+00:00  =

    2020-11-04 13:43:42.053000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-04 13:43:42.053000+00:00  =

    2020-11-04 13:43:42.053000+00:00  DRAM:  948 MiB
    2020-11-04 13:43:42.068000+00:00  RPI 3 Model B (0xa02082)
    2020-11-04 13:43:42.156000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-04 13:43:42.188000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (380 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa2b6525fd9144358fb5311

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g91dd5e0e05da/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g91dd5e0e05da/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2b6525fd9144358fb5=
312
        failing since 9 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
