Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8E6312798
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 22:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhBGVhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 16:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhBGVhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 16:37:09 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929C4C06174A
        for <stable@vger.kernel.org>; Sun,  7 Feb 2021 13:36:28 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o63so8973273pgo.6
        for <stable@vger.kernel.org>; Sun, 07 Feb 2021 13:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ln/t7uwPJZksB9DsDMUDb40FC6aYrTLNPV5CNRy1bOY=;
        b=a/sGXGeLSVn2FDui6y4CCDCUHNvDWO4mTaF3J4MS/y23vpjkyvdGuUkXxjV68WGWXK
         BCjhyQcA3MKZGZiAFOUh1KAV4vBbLQXR9sJR3+rGXxS7lgajKIewUn0ocB5ppCQZdhFI
         MHMXXb7VB/bbBQmPa7VuVth5vG7avhyEuqBe4ybLPwBhW0JovDG9IasJvOtdzCxVGdBm
         focFjrcZsF1RyXk0egFT9Ifi5URDU2VjWzcgOrQX9HJ8P0GROhcGjV8PcJULi6SCrppU
         fHUU9FUUhYEZ+zlasN46l2K19zkUNt7aEB/rary30D2+0PS7B0Qp2HTm+jsMsHvya+9S
         iLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ln/t7uwPJZksB9DsDMUDb40FC6aYrTLNPV5CNRy1bOY=;
        b=k7y0LRyKALppwl2bB/T8kaLudFwyTUJrkpDy0kYwGavavhe9+b5UuRJxc1SimEAU7I
         XrPnlnm/pSEwUeBNxwXHWX6+VStsBth4KlP1Sw8T8yz5TKV/WUkG5wt9BLzOFskt9B9M
         YUFcTOexOm0+yGK+Ew9ofpDVw/gimVJlqZoN5YlgXgpi9s+8haD1XGhlnwfKb+6IlVB7
         hPZVbXDWzJsLpRrq4M/z3u5tB8POqqr2TDVA0F3k6LN/F2XUOrBXxjJDII3Tr5+2sKNL
         o50+GYiuir1v9JNpqBWfFukDupOx0+eq7tA5ksb6g5+N+3A7488qBVs9bpSbg75sFrH8
         5amQ==
X-Gm-Message-State: AOAM533o1u4BDtWSlmXKB8j4G/slcri2/tqNZTkwmsGmONKmdtJ6n2IF
        9yFBDEciP35gJsy8utL0Sa6X439es53pSw==
X-Google-Smtp-Source: ABdhPJwWZsyZq+CXxsJq0zPhWrAiUYyQ+Ulq7I4puVEjz9dGJ+/qpXg7ZvrdOTki3x9k5c2u9Zz5cg==
X-Received: by 2002:a63:1201:: with SMTP id h1mr14578263pgl.296.1612733787813;
        Sun, 07 Feb 2021 13:36:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i1sm17669929pfb.54.2021.02.07.13.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 13:36:27 -0800 (PST)
Message-ID: <60205d5b.1c69fb81.1a425.6ce0@mx.google.com>
Date:   Sun, 07 Feb 2021 13:36:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.14-4-g5bf21c370d20
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 191 runs,
 3 regressions (v5.10.14-4-g5bf21c370d20)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 191 runs, 3 regressions (v5.10.14-4-g5bf21c3=
70d20)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =

imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.14-4-g5bf21c370d20/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.14-4-g5bf21c370d20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5bf21c370d20161a580c698ab0175787be2c23ef =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60202aa78c640d63043abea5

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
4-g5bf21c370d20/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-va=
r-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
4-g5bf21c370d20/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-va=
r-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60202aa78c640d6=
3043abeab
        new failure (last pass: v5.10.13-57-gadb6856092da6)
        4 lines

    2021-02-07 17:59:56.695000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000313
    2021-02-07 17:59:56.696000+00:00  kern  :alert : pgd =3D dc397f3f<8>[  =
 11.532784] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-02-07 17:59:56.696000+00:00  =

    2021-02-07 17:59:56.697000+00:00  kern  :alert : [00000313] *pgd=3D0000=
0000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60202aa78c640d6=
3043abeac
        new failure (last pass: v5.10.13-57-gadb6856092da6)
        47 lines

    2021-02-07 17:59:56.754000+00:00  kern  :emerg : Process kworker/0:2 (p=
id: 76, stack limit =3D 0x291b98e7)
    2021-02-07 17:59:56.755000+00:00  kern  :emerg : Stack: (0xc32d9d58 to =
0xc32da000)
    2021-02-07 17:59:56.755000+00:00  kern  :emerg : 9d40:                 =
                                      c3a551b0 c3a551b4
    2021-02-07 17:59:56.755000+00:00  kern  :emerg : 9d60: c3a55000 c3a5501=
4 c1449378 c09bbd34 c32d8000 ef83cba0 c09bd0f4 c3a55000
    2021-02-07 17:59:56.756000+00:00  kern  :emerg : 9d80: 000002f3 0000000=
c c19c76e4 c2001a80 c3a54c00 ef86ca80 c2001a80 c3a54c00
    2021-02-07 17:59:56.756000+00:00  kern  :emerg : 9da0: ef86ca80 78a296b=
f c1449378 c225d6c0 c3a76780 c3a55000 c3a55014 c1449378
    2021-02-07 17:59:56.797000+00:00  kern  :emerg : 9dc0: c19c76c8 0000000=
c c19c76e4 c09c945c c14470a0 00000000 c3a5500c c3a55000
    2021-02-07 17:59:56.798000+00:00  kern  :emerg : 9de0: fffffdfb c22d8c1=
0 c3a6f1c0 c099f3cc c3a55000 bf048000 fffffdfb bf044138
    2021-02-07 17:59:56.798000+00:00  kern  :emerg : 9e00: c3a99dc0 c32dbf0=
8 00000120 c37cf240 c3a6f1c0 c09f8d00 c3a99dc0 c3a99dc0
    2021-02-07 17:59:56.798000+00:00  kern  :emerg : 9e20: 00000040 c3a99dc=
0 c3a6f1c0 00000000 c19c76dc bf06b084 bf06c014 00000020 =

    ... (37 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60202db0c57f56057c3abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
4-g5bf21c370d20/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
4-g5bf21c370d20/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60202db0c57f56057c3ab=
e63
        new failure (last pass: v5.10.13-57-gadb6856092da6) =

 =20
