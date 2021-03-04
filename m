Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038BD32D431
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241341AbhCDN3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbhCDN3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 08:29:35 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE13C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 05:28:55 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o6so6944832pjf.5
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 05:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FKD5dVNBL+c6Rsu2Q+oaZYufm7Tl+YEjGq6nC0KZekw=;
        b=Q/l0IWouu3Nseij+DatIGkVCVXD9vIVLmtLoHb3rD8Dj0F3N2h1sELDrC1Swh819TR
         gHgxVCR9Q8VfMakQ2/m3MlaQ+neVpmuNx0taSbceTSiqQrvKJNDyFMtRrIWm3s1YcIyT
         V5RVKuOSBz1hw5HrUnJXfdlCTfde9OHkOCsbx0LiFJDUP5cy1PMxyCs4ulfon8pY2+/b
         zo8uLSmIGIFZ8ygG68kdPUPBDgTlwgUzWrt1srPKoF0i2qXotQxUfgGJUDCC8mPDaulR
         Q5cRDuDtiFzI12/C9lLhqa8P26Rg+7YhWpQmcdCg2I/K3Rfbmgugb2K6DWnPrqssLufi
         gZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FKD5dVNBL+c6Rsu2Q+oaZYufm7Tl+YEjGq6nC0KZekw=;
        b=gNbqwf5+bcUhHEFmytXh5KNURzYF7xCpqzSOAfXT/y9zHJklt+5iyvUIreD3Tx+bWr
         mciGNZkbukbIHXEDcpTpElSGsTeGaBB6rR0pgmyupr6h4ZfiWJ50EO4ZHlVGy08M6BKu
         pKWt+Pg7gC6t3cAz2eSFkyYM5wV1I+zaT57IUQ6RhUr2q4EaexwqguWvvWFq9LlJA606
         QQx4RG1TXcDqYWwrjPOSGJuuVbt3CNSJ0uArMfYLfEvgCLMblsJUaF+UN7XGftWcTr7l
         jWunDTFWOKf+P5gsSquFQ7akjxiNncSdTrNsF/tXsGt1ZJ8fuBkj+y1t/Y6ErjgYqv8i
         YyzA==
X-Gm-Message-State: AOAM5327gEKkPRlvlo1M+pMQk3r35gmxZFCS/j9PfZ/eE7Xh9O7ejoBY
        fal1tr8Wj2dHVTwfMfa+totvl0Ih0QpjwUXV
X-Google-Smtp-Source: ABdhPJxhF8h+lxssxKwnXK8AlgtvRFYRGH/+B6I0PEdjMTeA9iHqPjsVT8ZN1epCRMo9DOZ93/QA4A==
X-Received: by 2002:a17:902:e781:b029:e4:3bd3:3b00 with SMTP id cp1-20020a170902e781b02900e43bd33b00mr4045256plb.70.1614864534658;
        Thu, 04 Mar 2021 05:28:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d75sm25212049pfd.20.2021.03.04.05.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 05:28:54 -0800 (PST)
Message-ID: <6040e096.1c69fb81.b942b.a403@mx.google.com>
Date:   Thu, 04 Mar 2021 05:28:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19-656-gd3a7334586025
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 172 runs,
 4 regressions (v5.10.19-656-gd3a7334586025)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 172 runs, 4 regressions (v5.10.19-656-gd3a73=
34586025)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =

meson-gxm-q200     | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.19-656-gd3a7334586025/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.19-656-gd3a7334586025
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d3a7334586025049de1e723a4edb061a78f3d2d3 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =


  Details:     https://kernelci.org/test/plan/id/6040acd4f3b53e35e3addcc9

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
656-gd3a7334586025/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
656-gd3a7334586025/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6040acd4f3b53e3=
5e3addccd
        new failure (last pass: v5.10.19-655-g2acc6a4ae931)
        12 lines

    2021-03-04 09:47:49.193000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00<8>[   42.735057] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D12>
    2021-03-04 09:47:49.194000+00:00  000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6040acd4f3b53e3=
5e3addcce
        new failure (last pass: v5.10.19-655-g2acc6a4ae931)
        84 lines

    2021-03-04 09:47:49.198000+00:00  kern  :alert : [00000000] *pgd=3D0421=
3835, *pte=3D00000000, *ppte=3D00000000
    2021-03-04 09:47:49.199000+00:00  kern  :alert : 8<--- cut here ---
    2021-03-04 09:47:49.200000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000000
    2021-03-04 09:47:49.200000+00:00  kern  :alert : pgd =3D edef5ff7
    2021-03-04 09:47:49.236000+00:00  kern  :alert : [00000000] *pgd=3D0422=
5835, *pte=3D00000000, *ppte=3D00000000
    2021-03-04 09:47:49.236000+00:00  kern  :alert : 8<--- cut here ---
    2021-03-04 09:47:49.237000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000000
    2021-03-04 09:47:49.238000+00:00  kern  :alert : pgd =3D b092ebc8
    2021-03-04 09:47:49.239000+00:00  kern  :alert : [00000000] *pgd=3D0416=
d835, *pte=3D00000000, *ppte=3D00000000
    2021-03-04 09:47:49.240000+00:00  kern  :emerg : Internal error: Oops: =
17 [#1] ARM =

    ... (48 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/6040b05b8aa8de7919addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
656-gd3a7334586025/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
656-gd3a7334586025/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040b05b8aa8de7919add=
cb2
        new failure (last pass: v5.10.19-655-g2acc6a4ae931) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
meson-gxm-q200     | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/6040af482859b94d04addcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
656-gd3a7334586025/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
656-gd3a7334586025/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040af482859b94d04add=
cca
        new failure (last pass: v5.10.19-655-g2acc6a4ae931) =

 =20
