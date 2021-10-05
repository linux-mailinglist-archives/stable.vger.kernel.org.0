Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A51421B12
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 02:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhJEAXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 20:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhJEAXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 20:23:06 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6CCC061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 17:21:16 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h1so5184296pfv.12
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 17:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bsX3KwnyARdgx/71rRrVKtyx2kZYdo6/IAGKp1vBaOQ=;
        b=sfG2Bm7L1aTD6GMvdtAN4iBN49YoLmX2nKecwVZ9iwIjAPZQR+MITckrMWDyLM/cjs
         T4uccuylYPEvINhYaNpBylYqfMWmzVvuO95IksE+SrHe7v6FW4Qe89WmxmTN9CCv5WcY
         Zk6vmc76pRcKm9RyflTKxwXLT75lbF7Vfwr1iVALJtuc27dj7K8OrAbqAOlH1xwT3cUL
         YdKfrlA4Nao6Uhr4W8hLV6+ZAYR2qBP2zo0vm+u33BK/glKzBy1vgDosgvk2bl9mPHIt
         2mh9kPBN1LxG8i8AU8PWoQtf9EDcVkdDmzWLba7zgmqP6VLEL0fd3HCz42pxRbkBGeRT
         hd5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bsX3KwnyARdgx/71rRrVKtyx2kZYdo6/IAGKp1vBaOQ=;
        b=0dg5aQS1HEgZfzU6m+llbD5XrfyJdCeuTS+lhfJrgpuZQqjVJdajuTgxraxQEdBYJs
         oDOnKoCxtX2ak9HpuQzyu+4emNXBtToSCLXKJhRRaZ74JxWdrhjNsX1B6ufHHVNIAKbT
         4CyeCZHWSD7MCsJY8GolGsKPY2JVmNZOyZLZQrJtIUQ+GglTZjs+zmT0SQ2TH2QupcOx
         10HyE/FekSZvTWIkHP2j5mWJ1Q0xBHSQcSu3g4lFOI6oP9AW/phLPYRusWPp2+eVv1Tr
         mxfyLO7N8xSQJKEAv4sZe1sJzHmZRtir1Aedxe/d1GfDhU+blME3m2JTojlyAv2UC/oy
         FjQg==
X-Gm-Message-State: AOAM533A728wXScMllhwWiP/hdj3jlPm2kjEZQNd4Fnvs5C+/I8Pj/39
        CeYbn5jtW6Hc3+eIjEh5Be9kXksBDt5o3RaA
X-Google-Smtp-Source: ABdhPJxur6KMrFzHfj3snDnIdBp2cp7jcYJncOspSonyEhQnyshQTMQY9d5LJjZOc5C6AR+Sgkd+cw==
X-Received: by 2002:a63:4d56:: with SMTP id n22mr13415349pgl.414.1633393275873;
        Mon, 04 Oct 2021 17:21:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d12sm15897437pgf.19.2021.10.04.17.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 17:21:15 -0700 (PDT)
Message-ID: <615b9a7b.1c69fb81.4f231.144d@mx.google.com>
Date:   Mon, 04 Oct 2021 17:21:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.9-172-gb2bc50ae5dd9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 166 runs,
 2 regressions (v5.14.9-172-gb2bc50ae5dd9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 166 runs, 2 regressions (v5.14.9-172-gb2bc50=
ae5dd9)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.9-172-gb2bc50ae5dd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.9-172-gb2bc50ae5dd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2bc50ae5dd96d0a362a314241333b81bb6b3b07 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/615b628a6f46d8646399a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
72-gb2bc50ae5dd9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
72-gb2bc50ae5dd9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b628a6f46d8646399a=
2f0
        failing since 4 days (last pass: v5.14.8-160-gc91145f28005, first f=
ail: v5.14.8-160-g69e08636c9b8) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/615b65777267a4b15599a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
72-gb2bc50ae5dd9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
72-gb2bc50ae5dd9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b65777267a4b15599a=
2f4
        new failure (last pass: v5.14.9-73-gb9d08ffadf94) =

 =20
