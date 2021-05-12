Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7661237BC92
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhELMe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbhELMe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:34:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129E5C061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:33:17 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t2-20020a17090ae502b029015b0fbfbc50so259923pjy.3
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2tVQ+T6cCzSLqGL3pQtXmOXW4FoLMW7xa0jjqn/zMPA=;
        b=aJG13kFoYGgi6CX9TtGq35n0AO2lzy1ni/py9NEJ6N3BibCGuFHGVPr2MJCkwDVjSs
         UeqlHecWktknRXpzTdWLKzkAyqBAwlTjkXFYvzewhz1ljCS7wRCE0TzZy3fSAP/EX4Fz
         f941tkUrbQHE+ip2dZObFpVV0iykbhf508vGxlQcvwz1ZEibx2T/ciVowbNoyhYEn13m
         oUEZgkMtTZENDuGs5BqvQ1C1PNaJNrEbjBn3/x7J2UuyHaNB1Y38RJUbnlpM8LtKSaOZ
         J7Kl3H8/ka1KuRnDafrFXRd3z1HMn85d3lya578GL/AoZkrKjMOdsiLM27vKdco8SntX
         0hvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2tVQ+T6cCzSLqGL3pQtXmOXW4FoLMW7xa0jjqn/zMPA=;
        b=rlUC9fxpnnR2rx9pgNFvCWQ+C/ompUoHRa79VpnrDk2aE7b3073Gey125CMyc3uNnH
         alZnCP4dk4wFe+hdrjJpmNl/GT1bcPurDLLIFHg228q1TCfnwvvaFmfDMISCpyCPUA3N
         vjyfqaPQYxapdVpnr3ioeae6kSv4vBkkyb0BvCr2VOC4dsrqmiCDAeCLN9/918qd8bcB
         tc4eUdgVuZ7/1GVFbeFEDRshJESQTS3ZLOX06oSTNBWlqJPBMFM5s6VLb2xB5OcGJ4ay
         6aP1nzW8NFZDB7oaZ0KLj8sXHkBHK39fVf3+AcW/evCJewYu0l4Jz1rfSzejw/4r4wS4
         cq7g==
X-Gm-Message-State: AOAM530TiBF2VWBNMpibDbU3EpGqkzI/wSnps4dfaIc+a8+L7gZAP7Hl
        oKUDLmKMq+QCvbIGOHrkFvwsnx8aiqrRXbXm
X-Google-Smtp-Source: ABdhPJwsJWTMX4Vx9xX3leYGdNQbD21iEic5G6cosf3UVRV4Zpptibsac3NA2c7CYOcgLeGSzwy+kQ==
X-Received: by 2002:a17:902:122:b029:e8:bde2:7f6c with SMTP id 31-20020a1709020122b02900e8bde27f6cmr35216599plb.29.1620822796431;
        Wed, 12 May 2021 05:33:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h15sm16018848pfk.26.2021.05.12.05.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 05:33:16 -0700 (PDT)
Message-ID: <609bcb0c.1c69fb81.5725e.0a80@mx.google.com>
Date:   Wed, 12 May 2021 05:33:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.2-383-g4da1b11242f4e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 184 runs,
 2 regressions (v5.12.2-383-g4da1b11242f4e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 184 runs, 2 regressions (v5.12.2-383-g4da1b1=
1242f4e)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.2-383-g4da1b11242f4e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.2-383-g4da1b11242f4e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4da1b11242f4e50e07c02467e627b3fe28f577da =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/609b95cbcfc27d98f0d08f23

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-3=
83-g4da1b11242f4e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-3=
83-g4da1b11242f4e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/609b95cbcfc27d9=
8f0d08f29
        new failure (last pass: v5.12.2-384-gb24e2ca092b86)
        8 lines

    2021-05-12 08:45:40.905000+00:00  kern  :alert : addr:b6dfe000 vm_flags=
:0<8>[   13.786462] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D8>
    2021-05-12 08:45:40.906000+00:00  0000075 anon_vma:00000000 mapping:c1b=
e6960 index:34
    2021-05-12 08:45:40.907000+00:00  kern  :alert : file:libc-2.30.so faul=
t:filemap_fault mmap:generic_file_mmap readpage:simple_readpage
    2021-05-12 08:45:40.907000+00:00  kern  :alert : BUG: Bad page map in p=
rocess readlink  pte:50220476 pmd:042e1835   =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/609b9c0277e3fe883ad08f26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-3=
83-g4da1b11242f4e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-3=
83-g4da1b11242f4e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609b9c0277e3fe883ad08=
f27
        new failure (last pass: v5.12.2-383-g508b08e40956) =

 =20
