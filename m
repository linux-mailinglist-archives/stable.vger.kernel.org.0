Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1B035B048
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 22:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhDJUFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 16:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDJUFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 16:05:51 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC0BC06138A
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 13:05:36 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 20so386539pll.7
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 13:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eL3rUPQLwuYpbEc0Qbo4gdAJNXXww2revPe15JB9/zg=;
        b=M1uBmS0ek5yQA0Ji3nPvVZtDpvTx6GCgZbYCl1N/xo6xx+ZIim7g36kjfoIoidhFh3
         Ec5bBHDHTzQSLVDc27Rz2qAhoxAMu1mvtwEK7ISvjSsbyWpNmHmkFRUrYdE+JgxEOwU+
         OTbpJBisMq+noyQqiT+t/Ovmsvt56pjDuLI86emSiw78qa+haTht4thvKcF+/N7+Uyn/
         1pB+k+uHv+ZgkM2BatqBLY9ampqp3Y2cCXDzHtmzFkzbVYGxGC3X1G5Ikt6p5sRnAO3Z
         cfLM4C+PmvlroihRH2pHIYO/N+Km7OqDV35BLEiegBTTC1nDyMBcDo35f63W7CB6mNHv
         z4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eL3rUPQLwuYpbEc0Qbo4gdAJNXXww2revPe15JB9/zg=;
        b=PySyzlxFTZpypTuOMIsP/3WG6Fq1/cGXmrC6dXfkVVKnpn7pQjqYZOzXB+M8kpLmF+
         cR66pGssyX1+IyUH812jhEEh+VHvMEqKXsJOqVhEA1sh48IBbqXuj0k9Dri9xf+dRIEC
         wkj7abTYiciI1htKY8M9laStxLcqOm4SyJ7bTpaXsBbvlwqnHBOPoXfSLQvArzFWdNxv
         hPdMkHrBckSIZp1wtTTCHHApq0pPNB0B4jODAoRT1DEUEh+5zS/z0rr2PkcAEHVoUdI0
         3IFnbF2EDzvOjBDH8lMqPcVOZK36MMXJ0ufp0DlGtWAj0/+xnwA188urc5rCPQAkm95s
         R9bA==
X-Gm-Message-State: AOAM532KmEpUok14C/So6RODfm6luxKeyKm0JovJyR9tKbvasrn8n9XN
        3/n+YZ1cqyHrj957XDxNbqY0Di4lukMeBz4K
X-Google-Smtp-Source: ABdhPJyPmWZ+Q8NhVBtSwYBLjLlgzBdST3qi6Ebc/eCN3cpkceZRqNO/zmquSaB4kTYNb94q0nVEJA==
X-Received: by 2002:a17:90a:c28a:: with SMTP id f10mr21420338pjt.15.1618085136287;
        Sat, 10 Apr 2021 13:05:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i73sm6678238pgc.9.2021.04.10.13.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 13:05:36 -0700 (PDT)
Message-ID: <60720510.1c69fb81.ada31.0cac@mx.google.com>
Date:   Sat, 10 Apr 2021 13:05:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.29
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 157 runs, 2 regressions (v5.10.29)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 157 runs, 2 regressions (v5.10.29)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.29/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.29
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d8cf82b410b4be8a1266c10d05453128bd40d03a =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/6071c9ab12f59b1509dac6b7

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6071c9ab12f59b1=
509dac6bd
        new failure (last pass: v5.10.28-42-g18f507c37f33)
        8 lines

    2021-04-10 15:51:49.219000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00<8>[   13.963008] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D8>
    2021-04-10 15:51:49.220000+00:00  000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6071c9ab12f59b1=
509dac6be
        new failure (last pass: v5.10.28-42-g18f507c37f33)
        69 lines

    2021-04-10 15:51:49.224000+00:00  kern  :alert : [00000000] *pgd=3D0417=
6835, *pte=3D00000000, *ppte=3D00000000
    2021-04-10 15:51:49.225000+00:00  kern  :alert : 8<--- cut here ---
    2021-04-10 15:51:49.226000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000000
    2021-04-10 15:51:49.226000+00:00  kern  :alert : pgd =3D 0ccae451
    2021-04-10 15:51:49.262000+00:00  kern  :alert : [00000000] *pgd=3D0417=
1835, *pte=3D00000000, *ppte=3D00000000
    2021-04-10 15:51:49.263000+00:00  kern  :emerg : Internal error: Oops: =
17 [#1] ARM
    2021-04-10 15:51:49.264000+00:00  kern  :emerg : Process S50dropbear (p=
id: 134, stack limit =3D 0xc26a5e16)
    2021-04-10 15:51:49.265000+00:00  kern  :emerg : Stack: (0xc41e7e50 to =
0xc41e8000)
    2021-04-10 15:51:49.265000+00:00  kern  :emerg : 7e40:                 =
                    c0f90340 00000000 c41e7e84 00000000
    2021-04-10 15:51:49.266000+00:00  kern  :emerg : 7e60: 00000000 c435ca8=
0 c41e7f40 00000000 c41e6000 00000078 c41e7ef4 c41e7e88 =

    ... (44 line(s) more)  =

 =20
