Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341833D9B5B
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 03:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhG2B6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 21:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbhG2B6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 21:58:03 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788E6C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 18:58:01 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id f13so5062762plj.2
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 18:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=isZXBtjiNCxC6R1pmMer6J2VAu72wpYvNjdHSYT6J7Y=;
        b=Cax8/JvdFEM1Q3vyexV3h6xuHNviXoIn14nvLw9ZmJjo3Bo7QSIFgoTwXDzUDgIRZW
         QQZr6kcUxtzBDGobb+xuC8V54P2FcjMSC+k/bCu3FztqXVbNB8sWfhynHg1cGKkFnj2g
         wkDMu07GNEMduvNQIe9IISDN/TUK1N/tKwFzNvVjOyR2SOH+saNl5Tt92opJjE2GI7Ox
         KArKhDbO42MfQaSQ12VjCvW9zoLBHlCqN6YmAwiQDVt20JJ4kiagY42ieMIj61Lgz8uo
         mgH3tQwWyGv8Q7Cb5gvJ5fmhIXA9BGGdbMVH7h9c9afy7SfBiEV2S8ClasbQEPnTKBfg
         /oWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=isZXBtjiNCxC6R1pmMer6J2VAu72wpYvNjdHSYT6J7Y=;
        b=ldGYMpmPOwLD4D852iPKBOTXKvOObTC/zz7QHiwh1Re23zfHMmFGVZIFIRDvGZb4UP
         aYQOsBcKpnbg2P0rK7EscVdcgZptVDRXbGor4Ca4/hJZg9MttiCoexyvFCRQkKJ8bqxb
         CEEyZQKVx4+ujHUJaLvD7LyqxMADSeswDRIcQ4slPDiRdN4eE4E+qJbR2BslLGRYSWsG
         PENO6x+QJHBy5N9iPUAPbbYqQCiN0a8OBfTtemdN57jSHQl8ejrSEwQxi7lkic3dim3x
         9wcRyevhw+OZ3ZxIEbk11UFoaiA7Ylo2JSz++lFE3gF8bICftmCbIkLOF1O4Klcy3lAO
         PpZQ==
X-Gm-Message-State: AOAM531G21P8tr74TP7DKR3rcSD3yfED+l8CwmP2MHjxlqvJpR3YBGQI
        oNTTDm+QYueW2hBeGghzgmb5aZ28opYYytbj
X-Google-Smtp-Source: ABdhPJw52scGPTneV+86EeBrSMzmkmB7h1752Rgt9IQotf/+EQImaHe/v+hnp0F0r8fbUL0Z0uyf1w==
X-Received: by 2002:a17:902:70cb:b029:12c:6ccc:ebb5 with SMTP id l11-20020a17090270cbb029012c6cccebb5mr2448007plt.77.1627523880846;
        Wed, 28 Jul 2021 18:58:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lk5sm1005296pjb.53.2021.07.28.18.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 18:58:00 -0700 (PDT)
Message-ID: <61020b28.1c69fb81.6bf51.46ba@mx.google.com>
Date:   Wed, 28 Jul 2021 18:58:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.54
Subject: stable/linux-5.10.y baseline: 152 runs, 4 regressions (v5.10.54)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 152 runs, 4 regressions (v5.10.54)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
 | 2          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
 | 1          =

imx7ulp-evk        | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.54/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.54
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      08277b9dde633e1447e96b8cb89da2b40f96ae69 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
 | 2          =


  Details:     https://kernelci.org/test/plan/id/6101d2898a072c63e65018cd

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.54/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.54/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6101d2898a072c6=
3e65018d4
        new failure (last pass: v5.10.53)
        8 lines

    2021-07-28T21:56:09.695434  kern  :alert : 8<--- cut here ---
    2021-07-28T21:56:09.738573  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00<8>[   42.663865] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>
    2021-07-28T21:56:09.739392  000006   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6101d2898a072c6=
3e65018d5
        new failure (last pass: v5.10.53)
        96 lines

    2021-07-28T21:56:09.743337  kern  :alert : pgd =3D 94d99d2f
    2021-07-28T21:56:09.744063  kern  :alert : [00000006] *pgd=3D04228835, =
*pte=3D00000000, *ppte=3D00000000
    2021-07-28T21:56:09.744760  kern  :alert : 8<--- cut here ---
    2021-07-28T21:56:09.745263  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000004
    2021-07-28T21:56:09.745760  kern  :alert : pgd =3D 759423e4
    2021-07-28T21:56:09.781473  kern  :alert : [00000004] *pgd=3D04182835, =
*pte=3D00000000, *ppte=3D00000000
    2021-07-28T21:56:09.782858  kern  :emerg : Internal error: Oops: 17 [#1=
] ARM
    2021-07-28T21:56:09.783595  kern  :emerg : Process udevd (pid: 104, sta=
ck limit =3D 0x421a909a)
    2021-07-28T21:56:09.784521  kern  :emerg : Stack: (0xc4245d18 to 0xc424=
6000)
    2021-07-28T21:56:09.785643  kern  :emerg : 5d00:                       =
                                c0214914 c0e04248 =

    ... (92 line(s) more)  =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6101d561c3c0e9d26e5018d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.54/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.54/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101d561c3c0e9d26e501=
8d9
        failing since 21 days (last pass: v5.10.46, first fail: v5.10.48) =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
imx7ulp-evk        | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6101d4a71d19b3b16f5018c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.54/a=
rm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.54/a=
rm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101d4a71d19b3b16f501=
8c9
        new failure (last pass: v5.10.53) =

 =20
