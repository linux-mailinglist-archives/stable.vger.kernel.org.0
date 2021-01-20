Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5BB2FD654
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 18:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732648AbhATRBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 12:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730067AbhATPw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 10:52:28 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BA1C061575
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 07:51:48 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id c22so15418020pgg.13
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 07:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yJPRaK/RGwVmWTfSqiXp5fomQ9qgpmAIR7CX8wcarJg=;
        b=HAZCUaKqgiccrVnbk+KHXij6RiTX8zPvwb0Hr8Ms5D0hhfDUWdQT8vO5AxbFKrA5yI
         Gso8djLqp8MVjzt4sL0iYMi3G46sHTjWL5XVzQjgp6sX6iBiLg8E8Wbm2u4NlKMg/8aV
         +tPmMnJgWjIgrDV0Ch59uNR6fC57+AlJYFZe4m6o1a+xmnWmUQptzBqaJcAALcxQh9xT
         q/55mmJ8ExAG4pwEFH4p5JSSRuRy0RFn0iy4G6w3PboSzMoHKNgO7gmIvYhXIYjWGrik
         /CUD0DpyXdINp5x01k+tah9BoPgRkpD124UE/jLJYQBdk6y1cB+rGvk6nz0t3Raw2zC4
         D9+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yJPRaK/RGwVmWTfSqiXp5fomQ9qgpmAIR7CX8wcarJg=;
        b=aw8VexlYJ7n0XUo+oVnKWS78O/qXc2oAQ7GNw7rGn32xOivxMh8bvOF61BN3Rd44+Z
         iJmsaOWz0cIZUIaK5q/XRpjXVEh46gdtIPudE1BeZhnPtT5QWXZl5AmczL26UqfYHTtV
         Ok/jwQAc0HLygNvsTjUISu48l650nW6Htk7Fn9dYMd07lgG9rb1bzhTkGQusVmWZqj2i
         Sc6dNTlwhk1JWoevXunxi2sOZrnfgYvJ18fGtYqDmTRd8crxUITSWeofelrOj77a8FI2
         fmhse1ghSAhaIvGgCb+DKOeFopqyKE5ICZDRyogD2zZHWBsMzkXM3dhG+6g6vCNB7xgy
         AS0Q==
X-Gm-Message-State: AOAM530p3dGWnuqpAZewSlD8K1K+M9GROOOYBPfqrJH8jpDKcBXj08u4
        +PgTSo6/f8G+rrMKfSgVTivi1o51QMNCgg==
X-Google-Smtp-Source: ABdhPJwRTjOXAY8t+hOy95FGv6pEfkIazkO588rPxkFq1EfueayrA3WLLY8LSm+TmfNX10QJ/bqdCA==
X-Received: by 2002:a63:cb06:: with SMTP id p6mr9817020pgg.146.1611157907674;
        Wed, 20 Jan 2021 07:51:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z13sm2826837pjz.42.2021.01.20.07.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 07:51:46 -0800 (PST)
Message-ID: <60085192.1c69fb81.1bf80.62e8@mx.google.com>
Date:   Wed, 20 Jan 2021 07:51:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.9
Subject: stable-rc/linux-5.10.y baseline: 188 runs, 2 regressions (v5.10.9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 188 runs, 2 regressions (v5.10.9)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e2d133180bbc28a48316e67a003796885580b087 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/60081f79223bb9a931bb5d2a

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboar=
d.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboar=
d.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60081f79223bb9a=
931bb5d2e
        new failure (last pass: v5.10.8)
        4 lines

    2021-01-20 12:17:51.790000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 0000004c
    2021-01-20 12:17:51.791000+00:00  kern  :alert : pgd =3D (ptrval)<8>[  =
 39.456497] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-01-20 12:17:51.792000+00:00  =

    2021-01-20 12:17:51.792000+00:00  kern  :alert : [0000004c] *pgd=3D491c=
1831   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60081f79223bb9a=
931bb5d2f
        new failure (last pass: v5.10.8)
        60 lines

    2021-01-20 12:17:51.849000+00:00  kern  :emerg : Process udevd (pid: 12=
7, stack limit =3D 0x(ptrval))
    2021-01-20 12:17:51.850000+00:00  kern  :emerg : Stack: (0xc3af9c00 to =
0xc3afa000)
    2021-01-20 12:17:51.850000+00:00  kern  :emerg : 9c00: c0eae864 c09b5ef=
4 c3b8c1b0 c3b8c1b4 c3b8c000 c09bba9c c3af8000 ef8435c0
    2021-01-20 12:17:51.850000+00:00  kern  :emerg : 9c20: c09bce94 8020001=
b c19c76c8 0000000c c19c76e4 c2001d80 c35e9c80 ef863d20
    2021-01-20 12:17:51.851000+00:00  kern  :emerg : 9c40: c09c9224 c14492d=
c c19c76c8 d0f6a241 c19c76e4 c25aec80 c269ed00 c3b8c000
    2021-01-20 12:17:51.851000+00:00  kern  :emerg : 9c60: c3b8c014 c14492d=
c c19c76c8 0000000c c19c76e4 c09c91f4 c1447004 00000000
    2021-01-20 12:17:51.892000+00:00  kern  :emerg : 9c80: c3b8c00c c3b8c00=
0 fffffdfb c22d8c10 c3a19240 c099f16c c3b8c000 bf026000
    2021-01-20 12:17:51.893000+00:00  kern  :emerg : 9ca0: fffffdfb bf02213=
8 c3a63300 c3931b08 00000120 c224f640 c3a19240 c09f8a98
    2021-01-20 12:17:51.893000+00:00  kern  :emerg : 9cc0: c25ae280 c25ae28=
0 00000040 c25ae280 c3a19240 00000000 c19c76dc bf049084
    2021-01-20 12:17:51.893000+00:00  kern  :emerg : 9ce0: bf04a014 0000001=
6 00000028 c09f8b78 c2232c10 00000000 bf04a014 00000000 =

    ... (35 line(s) more)  =

 =20
