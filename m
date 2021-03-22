Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43C1344A1F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 17:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhCVQCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 12:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhCVQBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 12:01:44 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBE0C061762
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 09:01:43 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x126so11237909pfc.13
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 09:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N/AipSwn9HEOtUSlSw4oRoroMcSjl+VyzRSdPLgT/MM=;
        b=NsZQYkU4q4Aly1wgcjEcE5u+iMNqajnj2uYUzwt2xOPofbk8G52Ral1cvjxZnEAmHF
         Eyd3MuXYH49XEWnQNQ58wIWXMjhcrnGu/Pj9WgAWTcaCnwNFCnqoPNPYFsLDC4RXOi6L
         qzMzu6Vsn5z1xfE0MxFV5jRJvEzaqTGY+0pxheHZEBfZ6JtPkgulYNNVdAu+m664d5p8
         Hve7esCYBB83l9mqA6G7ufVfjD/sx//G5GS9a9sU1Hf1372rscN1KC+2x8pLPRGrgP1z
         j5rm3jBeLcvEOy/nHC+knmhxL0TUpHy/T91jhH4R8X8pCpWlCIe0kqtac9AhRGFkHEGS
         AKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N/AipSwn9HEOtUSlSw4oRoroMcSjl+VyzRSdPLgT/MM=;
        b=FEsL1ZtWA4wh/hG1xuSfZDeYQpBAAPVows6qtoPDQE0XngRkoHsDSff9iXzXVcVgyD
         RldmV1ahQ2zti6NTrWgyExtQgWPIDyFhBohdasX2bHv3a3sKst3sxqydSLMBzrzQdLxy
         MxnxI7MCUtjDNwOvtOpaCp+wloNnRcT7LLUBQpKlLOxtQReTQ6pff28tlaFmLYHSmGNl
         uc9EiwYStki5wTexN7x3Vl5nsnvfaKFvfvkKsyl1f83wOgVzfRlmH7ZQvCcOhj93Mabb
         9DTo9qILHgbZghrpIdVCdtjZas4BDRpDWMXZPqT+PcS9kqZdXmPogjISv0BIrFgMmCIQ
         jTDA==
X-Gm-Message-State: AOAM531oZn6Po9IYQdn7aOIxhGSqBTjkt8JaDPx6Ng80jpULIUa1eTUa
        HcM3bcvmZrYNbHMAB1ELmIsLqhC1RWqo0g==
X-Google-Smtp-Source: ABdhPJzCJjXFlSHk4H5nAt6c+dhPsTe1KHZdqTuDwGLZlPgul1nCZqYRzF1wkDYQYd/PH06K6NCLjQ==
X-Received: by 2002:a63:74c:: with SMTP id 73mr268939pgh.200.1616428903228;
        Mon, 22 Mar 2021 09:01:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f17sm7037483pgj.86.2021.03.22.09.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 09:01:42 -0700 (PDT)
Message-ID: <6058bf66.1c69fb81.19226.0a65@mx.google.com>
Date:   Mon, 22 Mar 2021 09:01:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.25-157-gb5c16f33a901
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 180 runs,
 4 regressions (v5.10.25-157-gb5c16f33a901)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 180 runs, 4 regressions (v5.10.25-157-gb5c16=
f33a901)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =

imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.25-157-gb5c16f33a901/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.25-157-gb5c16f33a901
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b5c16f33a90182791ad79ad5a3963f86edd3dfe0 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6058a20cb2295d019caddcb1

  Results:     1 PASS, 3 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
157-gb5c16f33a901/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
157-gb5c16f33a901/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058a20cb2295d019cadd=
cb2
        new failure (last pass: v5.10.25-122-g41ea6b8505eb9) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/605899ad0b094e2009addcc2

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
157-gb5c16f33a901/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
157-gb5c16f33a901/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/605899ad0b094e2=
009addcc5
        new failure (last pass: v5.10.25-122-g41ea6b8505eb9)
        59 lines

    2021-03-22 13:19:57.803000+00:00  kern  :emerg : Process udevd (pid: 13=
1, stack limit =3D 0x(ptrval))
    2021-03-22 13:19:57.803000+00:00  kern  :emerg : Stack: (0xc3ab5c00 to =
0xc3ab6000)
    2021-03-22 13:19:57.803000+00:00  kern  :emerg : 5c00: c36c55b0 c36c55b=
4 c36c5400 c36c5414 c1449500 c09bf664 c3ab4000 ef86d9e0
    2021-03-22 13:19:57.804000+00:00  kern  :emerg : 5c20: c09c0a24 c36c540=
0 000002f3 0000000c c19c7724 c049a8b0 c3ab4000 c39efc00
    2021-03-22 13:19:57.804000+00:00  kern  :emerg : 5c40: c39efc50 c36c541=
4 c1449500 8087c1c8 0000000c c3acf300 c3a65080 c36c5400
    2021-03-22 13:19:57.845000+00:00  kern  :emerg : 5c60: c36c5414 c144950=
0 c19c7708 0000000c c19c7724 c09ccd8c c1447228 00000000
    2021-03-22 13:19:57.846000+00:00  kern  :emerg : 5c80: c36c540c c36c540=
0 fffffdfb c22d8c10 c39aa040 c09a2cb4 c36c5400 bf048000
    2021-03-22 13:19:57.846000+00:00  kern  :emerg : 5ca0: fffffdfb bf04413=
8 c39ac140 c39e1708 00000120 c39a13c0 c39aa040 c09fc800
    2021-03-22 13:19:57.846000+00:00  kern  :emerg : 5cc0: c3a67980 c3a6798=
0 00000040 c3a67980 c39aa040 00000000 c19c771c bf0ea084
    2021-03-22 13:19:57.847000+00:00  kern  :emerg : 5ce0: bf0eb014 0000001=
3 00000028 c09fc8e0 c2232c10 00000000 bf0eb014 00000000 =

    ... (36 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/605899ad0b094e2=
009addcc6
        new failure (last pass: v5.10.25-122-g41ea6b8505eb9)
        4 lines

    2021-03-22 13:19:57.743000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000313
    2021-03-22 13:19:57.745000+00:00  kern  :alert : pgd =3D (ptrval)<8>[  =
 39.495403] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-03-22 13:19:57.745000+00:00  =

    2021-03-22 13:19:57.745000+00:00  kern  :alert : [00000313] *pgd=3D4920=
3831   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/60588fecb98933e31baddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
157-gb5c16f33a901/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
157-gb5c16f33a901/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60588fecb98933e31badd=
cb2
        new failure (last pass: v5.10.25-122-g41ea6b8505eb9) =

 =20
